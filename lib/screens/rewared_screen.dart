import 'package:flutter/material.dart';

class Reward extends StatelessWidget {
  const Reward({super.key});


  //Route 
  static const rewardRoute = "/home/reward";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child:  Text("This is rewared Screen"),
      ),
    );
  }
}