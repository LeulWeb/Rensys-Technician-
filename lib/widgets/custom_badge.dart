import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final int number;

  const CustomBadge({
    super.key,
    required this.number,
  });

  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.red,
      ),
      child: Text(
        number.toString(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
