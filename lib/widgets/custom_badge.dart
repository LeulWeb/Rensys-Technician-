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
      decoration: BoxDecoration(),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 12,
        child: Text(
          number.toString(),
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
