import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const homeRoute = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:  Text("This is home Screen"),
      ),
    );
  }
}