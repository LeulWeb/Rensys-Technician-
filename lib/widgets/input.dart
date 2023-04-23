import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType inputType;
  final TextInputAction action;
  final String hintText;

  const Input({
    super.key,
    required this.controller,
    required this.isPassword,
    required this.inputType,
    required this.action, required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText
      ),
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      textInputAction: action,
    );
  }
}
