import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlertBox extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback done;
  final String actionTitle;
  const AlertBox(
      {super.key,
      required this.title,
      required this.description,
      required this.done,
      required this.actionTitle});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 200,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Lottie.asset('assets/images/success.json', width: 100),
            Text(description),
            Expanded(child: Container()),
          ],
        ),
      ),
      actions: [TextButton(onPressed: done, child: Text(actionTitle))],
    );
  }
}
