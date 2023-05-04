import 'package:flutter/material.dart';

class CompletedScreen extends StatelessWidget {


  const CompletedScreen({super.key});
   static const completedRoute = "/home/completed";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child:  Text("Completed"),
      ),
    );
  }
}