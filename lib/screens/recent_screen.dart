import 'package:flutter/material.dart';

class Recent extends StatelessWidget {
  const Recent({super.key});

  static const recentRoute = "/home/recent";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child:  Text("This is recent Screen"),
      ),
    );
  }
}