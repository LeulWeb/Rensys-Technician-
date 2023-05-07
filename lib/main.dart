import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:technician_rensys/constants/colors.dart';
import 'package:technician_rensys/providers/id_provider.dart';
import 'package:technician_rensys/providers/job_list.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/providers/service_list.dart';
import 'package:technician_rensys/screens/home_screen.dart';
import 'package:technician_rensys/screens/job_screen.dart';
import 'package:technician_rensys/screens/login_screen.dart';
import './services/graphql_client.dart';

void main(List<String> args) async {
  await initHiveForFlutter();
  GraphQLConfig.getAccessToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageIndex()),
        ChangeNotifierProvider(create: (_) => JobList()),
        ChangeNotifierProvider(create: (_) => ServiceList()),
        ChangeNotifierProvider(create: (_) => IDProvider())
      ],
      child: MaterialApp(
        //Defining custom theme
        theme: ThemeData().copyWith(
          useMaterial3: true,
          scaffoldBackgroundColor: lightBackground,
          // appBarTheme: AppBarTheme().copyWith(color: Colors.red),
        ),
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: darkBackground,
        ),
        themeMode: ThemeMode.system,
        home: const Login(),
        routes: {
          Home.homeRoute: (context) => const Home(),
          Job.jobRoute: (context) => const Job(),
        },
      ),
    );
  }
}
