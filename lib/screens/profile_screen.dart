import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician_rensys/screens/login_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  static const profileRoute = "/profile";

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences? loginData;

  void logout() async {
    loginData = await SharedPreferences.getInstance();
    loginData!.setBool("loggedIn", false);
    loginData!.setString("accestoken", "");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
          child: TextButton(
        child: const Text("Log Out"),
        onPressed: () {
          logout();
        },
      )),
    );
  }
}
