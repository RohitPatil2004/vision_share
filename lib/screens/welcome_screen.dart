import 'package:flutter/material.dart';
import '../animations/pop_animation.dart';
import '../widgets/custom_button.dart';

import 'register_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900], // Dark blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PopAnimation(
              child: Text(
                'Vision Share',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40), // Space between text and button
            CustomButton(
              text: 'REGISTER → ',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
            ),
            SizedBox(height: 20), // Space between buttons
            CustomButton(
              text: 'LOGIN → ',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
