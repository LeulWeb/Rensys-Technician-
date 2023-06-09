import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:technician_rensys/widgets/text_app.dart';

class EmptyData extends StatelessWidget {
  final String title;
  final String description;
  const EmptyData({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Lottie.asset("assets/images/wait.json"),
          Expanded(child: Container()),
          TextApp(
            title: description,
            weight: FontWeight.w300,
            size: 16,
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
