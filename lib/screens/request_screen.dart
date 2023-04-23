import 'package:flutter/material.dart';

class Request extends StatelessWidget {
  const Request({super.key});

  static const requestRoute = "/home/completed/request";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Container(
        child:  Text("This is Request Screen"),
      ),
    );
  }
}