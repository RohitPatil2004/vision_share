import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color backgroundColor;
  final Color textColor;
  final String? Function(String?)? validator;

  FormInput({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.backgroundColor,
    required this.textColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
      ),
      style: TextStyle(color: textColor),
      validator: validator,
    );
  }
}