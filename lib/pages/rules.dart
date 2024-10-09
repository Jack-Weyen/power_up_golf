import 'package:flutter/material.dart';


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// RULES PAGE //
////////////////

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});


  //////////////////////////////////////////////////////////////////////////////////////////////////////////
  // RULES PAGE LAYOUT //
  ///////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      //////////////////////////////////////////////////////////////////////////////////////////////////////
      // APP BAR //
      /////////////

      appBar: AppBar(
        title: const Text(
          'Rules',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.lightGreen,
      ),


      //////////////////////////////////////////////////////////////////////////////////////////////////////
      // BODY //
      //////////

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            ////////////////////////////////////////////////////////////////////////////////////////////////
            // GENERAL RULES SECTION //
            ///////////////////////////

            // Section Title
            Text(
              'General Rules',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    ),
            ),

            // Spacer
            const SizedBox(height: 8.0),

            // Rules
            const Text('• This game is played individually\n'
                '• Everyone gets a power-up per hole\n'
                '• Power-ups only last one hole\n'
                '• Power-ups are randomly generated\n'
                '• A player’s power-up for the hole is only revealed to them.\n'
                '• Discussing power-ups between players is encouraged\n'
                '• Players must announce that they are using a power-up\n'
                '• Only one type of club can be banned at once. The latest club ban supersedes previous club bans.\n'
                '• All score multipliers stack\n'
                '• Winner is the player with the lowest score\n'),

            // Spacers and Divider
            const SizedBox(height: 8.0),
            const Divider(
              color: Colors.black
            ),
            const SizedBox(height: 16.0),


            ////////////////////////////////////////////////////////////////////////////////////////////////
            // POWER-UPS SECTION //
            ///////////////////////

            // Section Title
            Text(
              'Par 3 Power-Ups',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),

            // Spacer
            const SizedBox(height: 24.0),


            ////////////////////////////////////////////////////////////////////////////////////////////////
            // LEADER POWER-UPS SUBSECTION //
            /////////////////////////////////

            // Subsection Title
            Container(
              decoration: const BoxDecoration(
                color: Colors.lightGreen,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                'Leader Power-Ups',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                      ),
              ),
            ),

            // Spacer
            const SizedBox(height: 16.0),

            // Leader Power-Ups
            ..._buildPowerUps(
              [
                {
                  'name': '1. Bunker Challenge',
                  'description':
                      'After the player\'s tee shot, their next shot must be from the nearest bunker. If the player is shot swapped on your original shot, the opponent must take their next shot from the nearest bunker.',
                  'probability': 'Medium'
                },
                {
                  'name': '2. Teed Up',
                  'description':
                      'Player can tee up a shot after their first shot of the hole.',
                  'probability': 'High'
                },
                {
                  'name': '3. Immunity Penalty',
                  'description':
                      'Pay a stroke penalty to negate any power-up played on a player for this hole, including yourself.',
                  'probability': 'Low'
                },
                {
                  'name': '4. Scramble Command',
                  'description':
                      'Force any two players to be scramble partners for this hole, including yourself and another player. Players will share the same score and players will share any power-ups played on them.',
                  'probability': 'Medium'
                },
                {
                  'name': '5. Lie Improvement',
                  'description':
                      'The player can improve their lie by moving their ball a club length no closer to the hole. This power-up can be announced anytime before a shot off of the green.',
                  'probability': 'High'
                },
                {
                  'name': '6. Halftime at a Harvard Basketball Game',
                  'description':
                      'The player gets a free stroke if they spin 5 times before taking their next shot. This shot must be off the green.',
                  'probability': 'Medium'
                },
                {
                  'name': '7. Putter Only',
                  'description':
                      'The player gets to take one stroke off if they only use their putter for this hole.',
                  'probability': 'Medium'
                },
                {
                  'name': '8. Club Declaration',
                  'description':
                      'The player must announce what club they will use for their second shot BEFORE their first shot. This supersedes any club bans.',
                  'probability': 'Low'
                },
                {
                  'name': '9. One Call',
                  'description':
                      'If someone accidentally knocks their ball off of the tee and the player is the first person to say "one", the player can get a mulligan for any shot.',
                  'probability': 'Medium'
                },
                {
                  'name': '10. Club Dictator',
                  'description':
                      'The player can choose which club an opponent must hit for the next shot.',
                  'probability': 'Medium'
                },
                {
                  'name': '11. Double Ball',
                  'description':
                      'Force any opponent to get two balls at once; the opponent gets to choose which ball they want to play. This can be activated before any shot.',
                  'probability': 'Low'
                },
                {
                  'name': '12. Shared Fate',
                  'description':
                      'The player must ban a type of club for all players for the hole including themselves. This must be activated before everyone’s first shot.',
                  'probability': 'Very Low'
                },
                {
                  'name': '13. Free Drop',
                  'description':
                      'The player gets a free drop. This can be activated in response to a ball going out of bounds.',
                  'probability': 'High'
                },
              ],
            ),

            // Spacer
            const SizedBox(height: 24.0),


            ////////////////////////////////////////////////////////////////////////////////////////////////
            // MIDDLE POWER-UPS SUBSECTION //
            /////////////////////////////////

            // Subsection Title
            Container(
              decoration: const BoxDecoration(
                color: Colors.lightGreen,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                'Middle Power-Ups',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
              ),
            ),

            // Spacer
            const SizedBox(height: 16.0),

            // Middle Power-Ups
            ..._buildPowerUps(
              [
                {
                  'name': '1. Free Drop',
                  'description':
                      'The player gets a free drop. This can be activated in response to a ball going out of bounds.',
                  'probability': 'High'
                },
                {
                  'name': '2. Mulligan',
                  'description': 'The player can take a mulligan.',
                  'probability': 'Medium'
                },
                {
                  'name': '3. Shot Swap',
                  'description':
                      'Swap a tee shot with any player. This can be activated after everyone has shot their tee shot.',
                  'probability': 'Medium'
                },
                {
                  'name': '4. Reversal',
                  'description':
                      'Reverse any power-up played against the player to the person who played it.',
                  'probability': 'Medium'
                },
                {
                  'name': '5. Immunity Penalty',
                  'description':
                      'Pay a stroke penalty to negate any power-up played on a player for this hole, including yourself.',
                  'probability': 'Medium'
                },
                {
                  'name': '6. Club Ban',
                  'description':
                      'The player can choose an opponent and ban a type of club for the hole.',
                  'probability': 'High'
                },
                {
                  'name': '7. Flagpin Assist',
                  'description':
                      'Use the flagpin as a backboard for the player\'s next putt.',
                  'probability': 'Low'
                },
                {
                  'name': '8. Scramble Command',
                  'description':
                      'Force any two players to be scramble partners for this hole, including yourself and another player. Players will share the same score and players will share any power-ups played on them.',
                  'probability': 'Medium'
                },
                {
                  'name': '9. Lie Improvement',
                  'description': 'The player can improve their lie.',
                  'probability': 'Medium'
                },
                {
                  'name': '10. Putter Only',
                  'description':
                      'The player gets to take one stroke off if they only use their putter for this hole.',
                  'probability': 'Medium'
                },
                {
                  'name': '11. One-Handed Shot',
                  'description':
                      'Force a player to hit their next shot with one hand.',
                  'probability': 'Medium'
                },
                {
                  'name': '12. Toss and Play',
                  'description':
                      'The player can pick up their ball and toss it for the next stroke.',
                  'probability': 'Medium'
                },
                {
                  'name': '13. Double Ball',
                  'description':
                      'Force any opponent to get two balls at once; the opponent gets to choose which ball they want to play.',
                  'probability': 'Low'
                },
                {
                  'name': '14. Club Dictator',
                  'description':
                      'The player can choose which club an opponent must hit for the next shot.',
                  'probability': 'Medium'
                },
                {
                  'name': '15. Ball Finder',
                  'description':
                      'Once activated, the player gets 1 stroke deduction/ball found for the next 15 seconds.',
                  'probability': 'Low'
                },
                {
                  'name': '16. Theft',
                  'description':
                      'Steal someone else’s power-up. Must be played before they play their power-up.',
                  'probability': 'Medium'
                },
                {
                  'name': '17. Club Multiplier',
                  'description':
                      'The player chooses an opponent. For this hole, the chosen opponent’s score is multiplied by the number of clubs they use. This must be played before an opponent’s first shot.',
                  'probability': 'Very Low'
                },
              ],
            ),

            // Spacer
            const SizedBox(height: 24.0),


            ////////////////////////////////////////////////////////////////////////////////////////////////
            // LAST PLACE POWER-UPS SUBSECTION //
            /////////////////////////////////////

            // Subsection Title
            Container(
              decoration: const BoxDecoration(
                color: Colors.lightGreen,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Text(
                'Last Place Power-Ups',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
              ),
            ),

            // Spacer
            const SizedBox(height: 16.0),

            // Last Place Power-Ups
            ..._buildPowerUps(
              [
                {
                  'name': '1. Green Only',
                  'description':
                      'Only shots on the green count. If the player takes no shots on the green, they get a 0. The player has up to 5 shots to get on the green; otherwise, this power-up does not come into effect.',
                  'probability': 'Low'
                },
                {
                  'name': '2. Shot Swap',
                  'description': 'The player can swap a shot with any player.',
                  'probability': 'Low'
                },
                {
                  'name': '3. Putt Multiplier',
                  'description':
                      'The player chooses an opponent. For this hole, the chosen opponent’s score is multiplied by the number of times they putt on the green. This can be played after the opponent’s first shot.',
                  'probability': 'Medium'
                },
                {
                  'name': '4. Club Multiplier',
                  'description':
                      'The player chooses an opponent. For this hole, the chosen opponent’s score is multiplied by the number of clubs they use. This must be played before an opponent’s first shot.',
                  'probability': 'Low'
                },
                {
                  'name': '5. Club Banishment',
                  'description':
                      'The player can ban a type of club for the rest of the players for the hole.',
                  'probability': 'Very Low'
                },
                {
                  'name': '6. Immunity',
                  'description':
                      'Negate any power-up played on a player for this hole, including yourself. You do not need to pay a stroke penalty.',
                  'probability': 'Medium'
                },
                {
                  'name': '7. Hole-in-One',
                  'description':
                      'If the player gets a GIR, it counts as a hole-in-one.',
                  'probability': 'Medium'
                },
                {
                  'name': '8. Scramble Command',
                  'description':
                      'Force any two players to be scramble partners for this hole, including yourself and another player. Players will share the same score and players will share any power-ups played on them.',
                  'probability': 'Medium'
                },
                {
                  'name': '9. Double Ball',
                  'description':
                      'Force any opponent to get two balls at once; the opponent gets to choose which ball they want to play.',
                  'probability': 'Medium'
                },
                {
                  'name': '10. Personal Caddy',
                  'description':
                      'The player becomes a chosen opponent’s caddy. The opponent must hit whichever club the player tells them to for the entire hole.',
                  'probability': 'Medium'
                },
                {
                  'name': '11. Toss and Play',
                  'description':
                      'The player can pick up their ball and toss it for the next stroke.',
                  'probability': 'Low'
                },
                {
                  'name': '12. Putter Only',
                  'description':
                      'The player gets to take one stroke off if they only use their putter for this hole.',
                  'probability': 'Low'
                },
                {
                  'name': '13. 3x Mulligans',
                  'description':
                      'The player can take up to 3 mulligans this hole.',
                  'probability': 'Medium'
                },
                {
                  'name': '14. Ball Finder',
                  'description':
                      'Once activated, the player gets 1 stroke deduction/ball found for the next 15 seconds.',
                  'probability': 'Medium'
                },
                {
                  'name': '15. Theft',
                  'description':
                      'Steal someone else’s power-up. Must be played before they play their power-up.',
                  'probability': 'Medium'
                },
              ],
            ),

            // Spacers and Divider
            const SizedBox(height: 8.0),
            const Divider(
              color: Colors.black
            ),
            const SizedBox(height: 16.0),


            ////////////////////////////////////////////////////////////////////////////////////////////////
            // THINGS TO IMPROVE SECTION //
            ///////////////////////////////

            // Section Title
            Text(
              'Things to Improve:',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),

            // Spacer
            const SizedBox(height: 8.0),

            // Things to Improve
            const Text(
              '• Speed of power-up generation\n'
              '• Weights of power-ups\n'
              '• Game session shared with multiple players\n'
              '• Grint-like integration\n'
              '• Rubber Band Power-Ups NOT IMPLEMENTED\n'
              '• One-Handed Hole: Leader must play the entire hole using only one hand for all shots.\n'
              '• Double Trouble: The leader\'s score for this hole will be doubled.\n'
              '• Blind Shot: The leader must take all their shots with their eyes closed.\n'
              '• Putt Multiplier: For this hole, the leader’s score is multiplied by the number of times they putt on the green. This can be played anytime before the opponent’s first putt.\n'
              '• Shot Multiplier: For this hole, the leader’s score is multiplied by the number of shots it takes them to get on the green. This can be played anytime before the opponent holes out.',
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }


  //////////////////////////////////////////////////////////////////////////////////////////////////////////
  // POWER-UP BUILDER FUNCTION //
  ///////////////////////////////

  // Function to build the Power-Ups list
  List<Widget> _buildPowerUps(List<Map<String, String>> powerUps) {
    return powerUps.map((powerUp) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Power-up name
          Text(powerUp['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold)),

          // Spacer
          const SizedBox(height: 4.0),

          // Power-up description
          Text('${powerUp['description']}'),

          // Spacer
          const SizedBox(height: 4.0),

          // Power-up probability
          Text('Probability: ${powerUp['probability']}'),

          // Spacer
          const SizedBox(height: 16.0),
        ],
      );
    }).toList();
  }
}
