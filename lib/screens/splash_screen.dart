import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:technician_rensys/constants/colors.dart';
import 'package:technician_rensys/screens/login_screen.dart';

class SplashPage extends StatefulWidget {
  SplashPage({required this.setLocale});

  @override
  _SplashPageState createState() => _SplashPageState();
  final void Function(Locale locale) setLocale;
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        'assets/images/logo.png',
      ),
      title: const Text(
        "Rensys Engineering",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      logoWidth: 150,
      backgroundColor: Colors.white70,
      showLoader: false,
      loadingText: Text("Great things are coming..."),
      navigator: Login(setLocale: widget.setLocale),
      durationInSeconds: 2,
    );
  }
}
