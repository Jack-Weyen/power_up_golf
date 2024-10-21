const mysql = require('mysql2/promise');
const bcrypt = require('bcrypt');


//////////////////////////////////////////////////////////////////////////////////////////////////////
// CONNECTION //
////////////////

// Connection configuration
const connectionConfig = {
    host: 'your-db-host',
    user: 'your-db-user',
    password: 'your-db-password',
    database: 'your-db-name',
};

// Get connetion to MySQL database
const getConnection = async () => {
    return await mysql.createConnection(connectionConfig);
};


//////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN //
//////////

exports.handler = async (event) => {
    const { action, data } = event;
    
    try {

        // Get connetion to MySQL database
        const connection = await getConnection();
        
        // Action switch
        switch(action) {

            // Available actions
            case 'addPlayer':
                return await addPlayer(connection, data.username, data.password);
            case 'getPlayerId':
                return await getPlayerId(connection, data.username, data.password);
            case 'addGame':
                return await addGame(connection, data.creatorId, data.length);
            case 'addPlayerToGame':
                return await addPlayerToGame(connection, data.gameId, data.playerId, data.code);
            case 'beginGame':
                return await beginGame(connection, data.creatorId, data.gameId);
            case 'cancelGame':
                return await cancelGame(connection, data.creatorId, data.gameId);
            case 'updateScore':
                return await updateScore(connection, data.playerId, data.gameId, data.holeNumber, data.score, data.powerUp);
            case 'getGameInfo':
                return await getGameInfo(connection, data.playerId, data.gameId);
            case 'getActiveGames':
                return await getActiveGames(connection, data.playerId);
            case 'endGame':
                return await endGame(connection, data.creatorId, data.gameId);
            case 'deleteOldGames':
                return await deleteOldGames(connection);

            // Invalid action
            default:
                throw new Error('Invalid action');
        }
    
    // Error handling
    } catch (error) {
        return { statusCode: 500, body: error.message };

    // End connection
    } finally {
        connection && connection.end();
    }
};


//////////////////////////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS //
///////////////

// Add a new player
async function addPlayer(connection, username, password) {
    const [existing] = await connection.query('SELECT * FROM players WHERE username = ?', [username]);
    if (existing.length > 0) {
        throw new Error('Username already exists');
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    await connection.query('INSERT INTO players (username, password) VALUES (?, ?)', [username, hashedPassword]);
    return { statusCode: 200, body: 'Player added successfully' };
}

// Return player_id given username and password
async function getPlayerId(connection, username, password) {
    const [rows] = await connection.query('SELECT * FROM players WHERE username = ?', [username]);
    if (rows.length === 0 || !(await bcrypt.compare(password, rows[0].password))) {
        throw new Error('Invalid username or password');
    }
    return { statusCode: 200, body: { playerId: rows[0].player_id } };
}

// Add a new game
async function addGame(connection, creatorId, length) {
    if (![9, 18].includes(length)) {
        throw new Error('Game length must be 9 or 18');
    }

    const [pendingGames] = await connection.query('SELECT * FROM games WHERE creator = ? AND status IN ("pending", "active")', [creatorId]);
    if (pendingGames.length > 0) {
        throw new Error('Cannot create a new game while another game is pending or active');
    }

    let code;
    do {
        code = generateRandomCode();
        const [existingCodes] = await connection.query('SELECT * FROM games WHERE code = ? AND status = "pending"', [code]);
    } while (existingCodes.length > 0);

    await connection.query('INSERT INTO games (creator, date, status, code, length) VALUES (?, NOW(), "pending", ?, ?)', [creatorId, code, length]);
    return { statusCode: 200, body: { code } };
}

// Generate a random 4-character code
function generateRandomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    let code = '';
    for (let i = 0; i < 4; i++) {
        code += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return code;
}

// Add a new player to a game
async function addPlayerToGame(connection, gameId, playerId, code) {
    const [game] = await connection.query('SELECT * FROM games WHERE game_id = ? AND status = "pending" AND code = ?', [gameId, code]);
    if (game.length === 0) {
        throw new Error('Game is not pending or code is incorrect');
    }

    const [playersInGame] = await connection.query('SELECT COUNT(*) as count FROM players_in_game WHERE game_id = ?', [gameId]);
    if (playersInGame[0].count >= 12) {
        throw new Error('Cannot add more players, game is full');
    }

    await connection.query('INSERT INTO players_in_game (game_id, player_id) VALUES (?, ?)', [gameId, playerId]);
    return { statusCode: 200, body: 'Player added to game' };
}

// Begin a game
async function beginGame(connection, creatorId, gameId) {
    const [game] = await connection.query('SELECT * FROM games WHERE game_id = ? AND creator = ? AND status = "pending"', [gameId, creatorId]);
    if (game.length === 0) {
        throw new Error('Game is not pending or you are not the creator');
    }

    await connection.query('UPDATE games SET status = "active" WHERE game_id = ?', [gameId]);
    return { statusCode: 200, body: 'Game started' };
}

// Cancel a game
async function cancelGame(connection, creatorId, gameId) {
    const [game] = await connection.query('SELECT * FROM games WHERE game_id = ? AND creator = ? AND status IN ("pending", "active")', [gameId, creatorId]);
    if (game.length === 0) {
        throw new Error('Game cannot be canceled or you are not the creator');
    }

    await connection.query('DELETE FROM players_in_game WHERE game_id = ?', [gameId]);
    await connection.query('DELETE FROM holes WHERE player_in_game_id IN (SELECT player_in_game_id FROM players_in_game WHERE game_id = ?)', [gameId]);
    await connection.query('DELETE FROM games WHERE game_id = ?', [gameId]);
    return { statusCode: 200, body: 'Game canceled' };
}

// Update score for each hole
async function updateScore(connection, playerId, gameId, holeNumber, score, powerUp) {
    const [game] = await connection.query('SELECT * FROM games WHERE game_id = ? AND status = "active"', [gameId]);
    if (game.length === 0) {
        throw new Error('Game is not active');
    }

    const [playerInGame] = await connection.query('SELECT * FROM players_in_game WHERE game_id = ? AND player_id = ?', [gameId, playerId]);
    if (playerInGame.length === 0) {
        throw new Error('Player is not in this game');
    }

    const playerInGameId = playerInGame[0].player_in_game_id;
    await connection.query('INSERT INTO holes (player_in_game_id, hole_number, score, power_up) VALUES (?, ?, ?, ?)', [playerInGameId, holeNumber, score, powerUp]);
    return { statusCode: 200, body: 'Score updated' };
}

// Return all info for a game
async function getGameInfo(connection, playerId, gameId) {
    const [game] = await connection.query('SELECT * FROM games WHERE game_id = ? AND status IN ("active", "finished")', [gameId]);
    if (game.length === 0) {
        throw new Error('Game is not active or finished');
    }

    const [players] = await connection.query('SELECT * FROM players_in_game WHERE game_id = ?', [gameId]);
    const [holes] = await connection.query('SELECT * FROM holes WHERE player_in_game_id IN (SELECT player_in_game_id FROM players_in_game WHERE game_id = ?)', [gameId]);
    return { statusCode: 200, body: { game: game[0], players, holes } };
}

// Return all active or finished games for a player
async function getActiveGames(connection, playerId) {
    const [games] = await connection.query('SELECT * FROM games WHERE game_id IN (SELECT game_id FROM players_in_game WHERE player_id = ?) AND status IN ("active", "finished")', [playerId]);
    return { statusCode: 200, body: games };
}

// End the game
async function endGame(connection, creatorId, gameId) {
    const [game] = await connection.query('SELECT * FROM games WHERE game_id = ? AND creator = ? AND status = "active"', [gameId, creatorId]);
    if (game.length === 0) {
        throw new Error('Game is not active or you are not the creator');
    }

    await connection.query('UPDATE games SET status = "finished" WHERE game_id = ?', [gameId]);
    return { statusCode: 200, body: 'Game ended' };
}

// Delete old games
async function deleteOldGames(connection) {
    const [oldGames] = await connection.query('SELECT * FROM games WHERE status IN ("pending", "active") AND TIMESTAMPDIFF(HOUR, date, NOW()) > 24');
    for (const game of oldGames) {
        await connection.query('DELETE FROM players_in_game WHERE game_id = ?', [game.game_id]);
        await connection.query('DELETE FROM holes WHERE player_in_game_id IN (SELECT player_in_game_id FROM players_in_game WHERE game_id = ?)', [game.game_id]);
        await connection.query('DELETE FROM games WHERE game_id = ?', [game.game_id]);
    }
    return { statusCode: 200, body: 'Old games deleted' };
}