import 'package:flutter/material.dart';

class Report extends StatelessWidget {
  const Report({super.key});

  static const reportRoute = "/home/completed/report";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child:  Text("This is report Screen"),
      ),
    );
  }
}