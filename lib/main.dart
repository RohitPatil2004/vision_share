import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vision_share/screens/login_screen.dart';
import 'firebase_options.dart';

// screens imported
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
      // return WelcomeScreen();
      if (snapshot.connectionState == ConnectionState.active) {
        User? user = snapshot.data;
        if (user != null) {
          return HomeScreen();
        } else {
          FirebaseFirestore.instance
            .collection('IDS')
            .doc(user!.uid)
            .update({'isActive': false});
            return WelcomeScreen();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
