import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/form_input.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Naviage to the loginscreen after successful registraion.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        
        // Handle successful registration (e.g., navigate to home screen)
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Registration failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.amberAccent,
        automaticallyImplyLeading: false,
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
                backgroundColor: const Color.fromARGB(255, 31, 28, 28),
                textColor: Colors.white,
              ),
              SizedBox(height: 16),
              FormInput(
                controller: _passwordController,
                hintText: "Password",
                obscureText: true,
                backgroundColor: const Color.fromARGB(255, 31, 28, 28),
                textColor: Colors.white,
              ),
              SizedBox(height: 16),
              FormInput(
                controller: _confirmPasswordController,
                hintText: "Confirm Password",
                obscureText: true,
                backgroundColor: const Color.fromARGB(255, 31, 28, 28),
                textColor: Colors.white,
              ),
              SizedBox(height: 20),
              CustomButton(
                text: "Register",
                onPressed: _register,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
