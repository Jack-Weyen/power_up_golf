import 'package:flutter/material.dart';
import 'package:power_up_golf/pages/home.dart';


//////////////////////////////////////////////////////////////////////////////////////////////////////
// MAIN //
//////////

void main() {
  runApp(const PowerUpGolfApp());
}


//////////////////////////////////////////////////////////////////////////////////////////////////////
// APP //
/////////

class PowerUpGolfApp extends StatelessWidget {
  const PowerUpGolfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Power-Up Golf',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      
      // Go to home page
      home: const PowerUpGolfHomePage(),
    );
  }
}

// TODO
//
// Connect app to MySQL database
//  Get AWS Lambda code deployed
//  Connect to app
//  Send test data
//  
// Get user and game tables set up - DONE
//
// Create "new game" functionality - DONE
//  Creates new game, shows new game available
//    Game ID, game code, game creator, player, hole 1, hole 1 powerup, ... hole 9 powerup
//
// Create "new user" functionality - DONE
//  Creates new user
//    User ID, username, email (encrypted), password (encrypted)
//
// Test out all lambda functions
//
// Change functions so that only the username of other players is accessible
// on the front end; since player_id is basically the key to everything, this means
// that if it is accessible on the front end, it can be used to change another
// user's information. So, in the backend, ensure that all player_id's are
// replaced with usernames before being sent back to the frontend.

