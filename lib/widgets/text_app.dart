import 'package:flutter/material.dart';

class TextApp extends StatelessWidget {
  final String title;
  final FontWeight weight;
  final double size;
  final bool isWhite;

  const TextApp(
      {super.key,
      required this.title,
      required this.weight,
      required this.size,
      this.isWhite = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: isWhite ? Colors.white : Colors.black,
      ),
    );
  }
}
