import 'package:flutter/material.dart';

class Job extends StatelessWidget {
  const Job({super.key});

  static const jobRoute = "/job";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("This is job Screen"),
      ),
    );
  }
}
