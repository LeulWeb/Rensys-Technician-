import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician_rensys/constatnts/colors.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:technician_rensys/responsive/mobile_layout.dart';
import 'package:technician_rensys/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/screens/home_screen.dart';
import 'package:technician_rensys/screens/login_screen.dart';

void main(List<String> args) async {
  await initHiveForFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => PageIndex())],
      child: MaterialApp(
        //Defining custom theme
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: lightBackground,
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: darkBackground,
        ),
        themeMode: ThemeMode.system,
        home: const Login(),
        routes: {
          Home.homeRoute: (context) => const Home(),
        },
      ),
    );
  }
}
