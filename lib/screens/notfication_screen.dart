import 'package:flutter/material.dart';

class Notfication extends StatelessWidget {
  const Notfication({super.key});


  static const notificationRoute = "/notification";
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  Container(
        child:  Text("This is notfication Screen"),
      ),
    );
  }
}