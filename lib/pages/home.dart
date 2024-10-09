import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';


//////////////////////////////////////////////////////////////////////////////////////////////////////////
// HOME PAGE //
///////////////

class PowerUpGolfHomePage extends StatefulWidget {
  const PowerUpGolfHomePage({super.key});

  @override
  PowerUpGolfHomePageState createState() => PowerUpGolfHomePageState();
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
// HOME PAGE STATE //
/////////////////////

class PowerUpGolfHomePageState extends State<PowerUpGolfHomePage> {

  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  // STATE VARIABLES //
  /////////////////////

  // Initialize a list of players with empty names and zero scores
  List<PlayerScore> players = List.generate(
    4,
    (index) => PlayerScore(
      nameController: TextEditingController(),
      holeScores: List.generate(9, (i) => TextEditingController(text: '0')),
    ),
  );

  // Other variables
  PlayerScore? selectedPlayer;
  String powerUp = '';
  String powerUpDescription = '';
  String finalScores = '';


  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  // POWER-UPS //
  ///////////////
  
  // Leader Power-Ups
  final Map<String, PowerUpDetail> leaderPowerUps = {
    "Bunker Challenge": PowerUpDetail(
        description:
            "After the player's tee shot, their next shot must be from the nearest bunker. If the player is shot swapped on your original shot, the opponent must take their next shot from the nearest bunker.",
        probability: "Medium"),
    "Teed Up": PowerUpDetail(
        description:
            "Player can tee up a shot after their first shot of the hole.",
        probability: "High"),
    "Immunity": PowerUpDetail(
        description:
            "Negate any power-up played on a player for this hole, including yourself. This can be announced in response to any power-up played against the player.",
        probability: "Low"),
    "Lie Improvement": PowerUpDetail(
        description:
            "The player can improve their lie by moving their ball a club length no closer to the hole. This power-up can be announced anytime before a shot off of the green.",
        probability: "High"),
    "Halftime at a Harvard Basketball Game": PowerUpDetail(
        description:
            "The player gets a free stroke if they spin 5 times before taking their next shot. This shot must be off the green. This power-up can be announced anytime before a shot off of the green.",
        probability: "High"),
    "Gambler": PowerUpDetail(
        description:
            "Bet on who will have the highest score on this hole. If you're right, you get to take a stroke off from your score. If you're wrong, a stroke is added to your score. The gamble must be made before the first tee shot.",
        probability: "Medium"),
    "Club Declaration": PowerUpDetail(
        description:
            "The player must announce what club they will use for their second shot BEFORE their first shot. This supersedes any club bans.",
        probability: "Low"),
    "One Call": PowerUpDetail(
        description:
            "If someone accidentally knocks their ball off of the tee and anybody says ‘that's one’, the player gets one stroke taken off of their score.",
        probability: "Medium"),
    "Club Dictator": PowerUpDetail(
        description:
            "The player can choose which club an opponent must hit for the next shot.",
        probability: "Medium"),
    "Double Ball": PowerUpDetail(
        description:
            "Force any opponent to hit two balls at once; the opponent gets to choose which ball they want to play. This can be activated before any shot.",
        probability: "Low"),
    "Shared Fate": PowerUpDetail(
        description:
            "The player must ban a type of club for all players for the hole including themselves. This must be activated before everyone’s first shot.",
        probability: "Very Low"),
    "Free Drop": PowerUpDetail(
        description:
            "The player gets a free drop. This can be activated in response to a ball going out of bounds.",
        probability: "High"),
  };

  // Middle Power-Ups
  final Map<String, PowerUpDetail> middlePowerUps = {
    "2x Mulligans": PowerUpDetail(
        description: "The player can take up to 2 mulligans this hole.",
        probability: "Medium"),
    "Best Ball": PowerUpDetail(
        description:
            "The player goes to the best tee shot of the group. If the player has the best tee shot, a stroke is deducted from their score for the hole.",
        probability: "Medium"),
    "Club Ban": PowerUpDetail(
        description:
            "The player can choose an opponent and ban a type of club for the hole.",
        probability: "High"),
    "Flagpin Assist": PowerUpDetail(
        description: "Use the flagpin to assist your next putt.",
        probability: "Low"),
    "Scramble Command": PowerUpDetail(
        description:
            "Force any two players to be scramble partners for this hole, including yourself and another player. Players will share the same score and players will share any power-ups played on them. (If Player 1 has irons banned, and Player 2 has a free drop, both players cannot use irons and get a free drop.)",
        probability: "Medium"),
    "Gambler": PowerUpDetail(
        description:
            "Bet on who will have the highest score on this hole. If you're right, you get to take a stroke off from your score. If you're wrong, a stroke is added to your score. The gamble must be made before the first tee shot.",
        probability: "Medium"),
    "One-Handed Shot": PowerUpDetail(
        description: "Force a player to hit their next shot with one hand.",
        probability: "Medium"),
    "Toss and Play": PowerUpDetail(
        description:
            "The player can pick up their ball and toss it for the next stroke.",
        probability: "Medium"),
    "Double Ball": PowerUpDetail(
        description:
            "Force any opponent to hit two balls at once; the opponent must play the worst ball hit.",
        probability: "Low"),
    "Club Dictator": PowerUpDetail(
        description:
            "The player can choose which club an opponent must hit for the next shot.",
        probability: "Medium"),
    "Theft": PowerUpDetail(
        description:
            "Steal someone else’s power-up. Can be activated once their power-up is announced.",
        probability: "Medium"),
    "Club Multiplier": PowerUpDetail(
        description:
            "The player chooses an opponent. For this hole, the chosen opponent’s score is multiplied by the number of clubs they use. This must be played before an opponent’s first shot.",
        probability: "Low"),
    "Par or Bust": PowerUpDetail(
        description:
            "The leader must make a par or par is added to their score for the hole. Must be announced before the leader tees off.",
        probability: "Low"),
    "Putt-off": PowerUpDetail(
        description:
            "Choose a person at the beginning of the hole. Once both players make it to the green, both players go to the furthest ball and do a putt-off. Winner gets one stroke taken off and the loser gets one stroke penalty.",
        probability: "Low"),
  };

  // Last place Power-Ups
  final Map<String, PowerUpDetail> lastPowerUps = {
    "Green Only": PowerUpDetail(
        description:
            "Only shots on the green count. If the player takes no shots on the green, they get a 0. The player has up to 5 shots to get on the green; otherwise, this power-up does not come into effect.",
        probability: "Medium"),
    "Shot Swap": PowerUpDetail(
        description: "The player can swap a shot with any player.",
        probability: "Medium"),
    "Putt Multiplier": PowerUpDetail(
        description:
            "The player chooses an opponent. For this hole, the chosen opponent’s score is multiplied by the number of times they putt on the green. This can be played anytime before the opponent’s first putt. (If a person gets a 3 and took 2 putts, their score is 6 [3 x 2 (putts) = 6], If a person gets a 4 and took 0 putts, their score is 0 [4 x 0 (putts) = 0], If a person gets a 2 and took 1 putt, their score is 2 [2 x 1 (putt) = 2])",
        probability: "Medium"),
    "Club Multiplier": PowerUpDetail(
        description:
            "The player chooses an opponent. For this hole, the chosen opponent’s score is multiplied by the number of clubs they use. This must be played before an opponent’s first shot.",
        probability: "Medium"),
    "Club Banishment": PowerUpDetail(
        description:
            "The player can ban a type of club for the rest of the players for the hole.",
        probability: "Medium"),
    "Score Swap": PowerUpDetail(
        description:
            "Swap the scores of two players other than yourself. Use after everyone has completed the hole.",
        probability: "Medium"),
    "Scramble Command": PowerUpDetail(
        description:
            "Force any two players to be scramble partners for this hole, including yourself and another player. Players will share the same score and players will share any power-ups played on them. (If Player 1 has irons banned, and Player 2 has a free drop, both players cannot use irons and get a free drop.)",
        probability: "Medium"),
    "Double Ball": PowerUpDetail(
        description:
            "Force any opponent to hit two balls at once; the opponent must play the worst ball hit.",
        probability: "Medium"),
    "Personal Caddy": PowerUpDetail(
        description:
            "The player becomes a chosen opponent’s caddy. The opponent must hit whichever club the player tells them to for the entire hole.",
        probability: "Medium"),
    "3x Mulligans": PowerUpDetail(
        description: "The player can take up to 3 mulligans this hole.",
        probability: "Medium"),
    "Ball Finder": PowerUpDetail(
        description:
            "Once activated, the player gets 1 stroke deduction/ball found for the next 15 seconds.",
        probability: "Medium"),
    "One-Hand Bandit": PowerUpDetail(
        description:
            "Force a player to hit every other shot with one hand for the entire hole.",
        probability: "Medium"),
    "Birdie or Bust": PowerUpDetail(
        description:
            "The leader must make a birdie or par is added to their score for the hole. Must be announced before the leader tees off.",
        probability: "Low"),
    "Score Subtraction": PowerUpDetail(
        description:
            "Choose a player at the beginning of the hole. Subtract their score on this hole from your score on this hole.",
        probability: "Low"),
  };

  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  // STATE FUNCTIONS //
  /////////////////////

  // Function to launch URL
  Future<void> _launchURL() async {
      final Uri url = Uri.parse(
          'https://docs.google.com/document/d/1Vx1JY4Medi2a1A26oDWUWT6xGh6jxz6UTAX4tDPjcBQ/edit#heading=h.ekelnqntm8of');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    }

  // Function to update the selected player dropdown
  void _updateSelectedPlayer() {
    List<String> playerNames = players
        .map((p) => p.nameController.text.trim())
        .where((name) => name.isNotEmpty)
        .toList();
    setState(() {

      // If the currently selected player is no longer in the list, deselect
      if (selectedPlayer != null &&
          !playerNames.contains(selectedPlayer!.nameController.text.trim())) {
        selectedPlayer = null;
      }
    });
  }

  // Function to clear power-up fields
  void _clearPowerUp() {
    setState(() {
      powerUp = '';
      powerUpDescription = '';
    });
  }

  // Function to calculate final scores
  void _getScores() {
    List<PlayerScore> validPlayers =
        players.where((p) => p.nameController.text.trim().isNotEmpty).toList();

    for (var player in validPlayers) {
      double total = 0;
      for (var controller in player.holeScores) {
        double score = double.tryParse(controller.text) ?? 0;
        total += score;
      }
      player.totalScore = total;
    }

    validPlayers.sort((a, b) => a.totalScore.compareTo(b.totalScore));

    String scores = validPlayers
        .map((p) => "${p.nameController.text.trim()}: ${p.totalScore.toInt()}")
        .join("\n");

    setState(() {
      finalScores = scores;
    });
  }

  // Function to determine leader and last place
  Map<String, dynamic> _determineLeaderAndLastPlace() {
    List<PlayerScore> validPlayers =
        players.where((p) => p.nameController.text.trim().isNotEmpty).toList();

    for (var player in validPlayers) {
      player.totalScore = 0;
      for (var controller in player.holeScores) {
        double score = double.tryParse(controller.text) ?? 0;
        player.totalScore += score;
      }
    }

    validPlayers.sort((a, b) => a.totalScore.compareTo(b.totalScore));

    PlayerScore leader = validPlayers.first;
    PlayerScore lastPlace = validPlayers.last;

    Map<String, double> strokesBehind = {};
    double leaderScore = leader.totalScore;
    for (var player in validPlayers) {
      strokesBehind[player.nameController.text.trim()] =
          player.totalScore - leaderScore;
    }

    return {
      'leader': leader,
      'lastPlace': lastPlace,
      'strokesBehind': strokesBehind,
    };
  }

  // Function to get a power-up for a player
  void _getPowerUp() {
    if (selectedPlayer == null) return;

    var result = _determineLeaderAndLastPlace();
    PlayerScore leader = result['leader'];
    PlayerScore lastPlace = result['lastPlace'];
    Map<String, double> strokesBehind = result['strokesBehind'];

    String playerName = selectedPlayer!.nameController.text.trim();
    double strokes = strokesBehind[playerName] ?? 0;

    Map<String, PowerUpDetail> powerUpDict;
    if (playerName == leader.nameController.text.trim()) {
      powerUpDict = leaderPowerUps;
    } else if (strokes < 10) {
      powerUpDict = middlePowerUps;
    } else {
      powerUpDict = lastPowerUps;
    }

    if (powerUpDict.isEmpty) {
      setState(() {
        powerUp = 'No Power-Ups Available';
        powerUpDescription = '';
      });
      return;
    }

    List<String> powerUps = powerUpDict.keys.toList();
    String selectedPowerUp = powerUps[Random().nextInt(powerUps.length)];
    String description = powerUpDict[selectedPowerUp]!.description;

    setState(() {
      powerUp = selectedPowerUp;
      powerUpDescription = description;
    });
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  // DISPOSAL //
  //////////////

  @override
  void dispose() {

    // Dispose all controllers to free resources
    for (var player in players) {
      player.nameController.dispose();
      for (var controller in player.holeScores) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////
  // HOME PAGE LAYOUT //
  //////////////////////

  @override
  Widget build(BuildContext context) {

    // Update selected player list whenever there's a change
    _updateSelectedPlayer();

    // Scaffold
    return Scaffold(

      ////////////////////////////////////////////////////////////////////////////////////////////////////
      // APP BAR //
      /////////////

      appBar: AppBar(
        title: const Text(
          'Power-Up Golf',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightGreen,
      ),


      ////////////////////////////////////////////////////////////////////////////////////////////////////
      // BODY //
      //////////

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [

            //////////////////////////////////////////////////////////////////////////////////////////////
            // RULES SECTION //
            ///////////////////

            // Markdown-like rules link
            RichText(
              text: 
                TextSpan(
                  text: 'Rules and Power-Up Descriptions',
                  style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = _launchURL,
                ),
              ),

            // Spacer
            const SizedBox(height: 20),


            //////////////////////////////////////////////////////////////////////////////////////////////
            // SCORE CARD SECTION //
            ////////////////////////

            // Score Card Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(

                // Columns
                columns: [

                  // Create a column for players
                  const DataColumn(label: Text('Player')),

                  // Then one for each hole
                  for (int i = 1; i <= 9; i++)
                    DataColumn(label: Text('Hole $i')),
                ],

                // Rows
                rows: players
                  .map(

                    // Map each player to a row
                    (player) => DataRow(
                      cells: [

                        // Player name cell
                        DataCell(
                          TextField(
                            controller: player.nameController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Player Name',
                            ),
                            onChanged: (value) {
                              _updateSelectedPlayer();
                            },
                          ),
                        ),

                        // Hole score cells
                        for (int i = 0; i < 9; i++)
                          DataCell(
                            TextField(
                              controller: player.holeScores[i],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '0',
                              ),
                              onChanged: (value) {
                                // Optionally, you can add validation here
                              },
                            ),
                          ),
                      ],
                    ),
                  )
                  .toList(),
              ),
            ),

            // Spacer
            const SizedBox(height: 20),


            //////////////////////////////////////////////////////////////////////////////////////////////
            // POWER-UP SECTION //
            //////////////////////
            
            // Dropdown and Buttons
            Row(
              children: [

                // Dropdown menu for players
                Expanded(
                  child: DropdownButton<PlayerScore>(
                    isExpanded: true,
                    hint: const Text('Select Player'),
                    value: selectedPlayer,
                    items: players
                        .where((p) => p.nameController.text.trim().isNotEmpty)
                        .map(
                          (p) => DropdownMenuItem<PlayerScore>(
                            value: p,
                            child: Text(p.nameController.text.trim()),
                          ),
                        )
                        .toList(),
                    onChanged: (PlayerScore? newValue) {
                      setState(() {
                        selectedPlayer = newValue;
                        _clearPowerUp();
                      });
                    },
                  ),
                ),

                // Spacer
                const SizedBox(width: 10),

                // Get Power-Up button
                ElevatedButton(
                  onPressed: _getPowerUp,
                  child: const Text('Get Power-Up'),
                ),
              ],
            ),

            // Spacer
            const SizedBox(height: 10),

            // Power-Up Display
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Power-Up name
                const Text(
                  'Power-Up:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(powerUp),

                // Spacer
                const SizedBox(height: 10),

                // Power-Up description
                const Text(
                  'Power-Up Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(powerUpDescription),
              ],
            ),

            // Spacer
            const SizedBox(height: 20),

            //////////////////////////////////////////////////////////////////////////////////////////////
            // SCORES SECTION //
            ////////////////////

            // Get Scores Button
            ElevatedButton(
              onPressed: _getScores,
              child: const Text('Get Scores'),
            ),

            // Spacer
            const SizedBox(height: 10),

            // Final Scores Display
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Scores:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(finalScores),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////
// CLASSES //
/////////////

class PlayerScore {
  TextEditingController nameController;
  List<TextEditingController> holeScores;
  double totalScore;

  PlayerScore({
    required this.nameController,
    required this.holeScores,
    this.totalScore = 0,
  });
}

class PowerUpDetail {
  String description;
  String probability;

  PowerUpDetail({
    required this.description,
    required this.probability,
  });
}
