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

