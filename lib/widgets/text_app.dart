import 'package:flutter/material.dart';

class TextApp extends StatelessWidget {
  final String title;
  final FontWeight weight;
  final double size;

  const TextApp(
      {super.key,
      required this.title,
      required this.weight,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:
          TextStyle(fontSize: size, fontWeight: weight, fontFamily: "poppins"),
    );
  }
}
