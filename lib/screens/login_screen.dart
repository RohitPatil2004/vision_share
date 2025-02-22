import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

import 'home_screen.dart';
import 'register_screen.dart';
import '../widgets/form_input.dart';
import '../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
        // Naviage to home screen.
        print("Login Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        // Handle successful login (e.g., navigate to home screen)
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Dark blue background
      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: Colors.amberAccent, // Darker blue for AppBar
        automaticallyImplyLeading: false, // Remove back arrow
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FormInput(
                controller: _emailController,
                hintText: "Email",
                obscureText: false,
                backgroundColor: const Color.fromARGB(
                  255,
                  31,
                  28,
                  28,
                ), // Black background for input
                textColor: Colors.white, // White text color
              ),
              SizedBox(height: 16),
              FormInput(
                controller: _passwordController,
                hintText: "Password",
                obscureText: true,
                backgroundColor: const Color.fromARGB(
                  255,
                  31,
                  28,
                  28,
                ), // Black background for input
                textColor: Colors.white, // White text color
              ),
              SizedBox(height: 20),
              CustomButton(text: "Login", onPressed: _login),
              SizedBox(height: 20),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    "Go to Register Page →",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
