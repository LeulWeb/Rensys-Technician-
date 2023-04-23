import 'package:flutter/material.dart';

class Progress extends StatelessWidget {
  const Progress({super.key});

  static const ongoingRoute = "/home/ongoing";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child:  Text("This is progress Screen"),
      ),
    );
  }
}