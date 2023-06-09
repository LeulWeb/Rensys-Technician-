import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset("assets/images/inbox.json"),
                const Text(
                  "No new notification at the moment stay tuned",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ]),
        ),
      ),
    );
  }
}
