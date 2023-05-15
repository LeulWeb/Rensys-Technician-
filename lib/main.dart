import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician_rensys/constants/colors.dart';
import 'package:technician_rensys/providers/all_banks.dart';
import 'package:technician_rensys/providers/bundle_package_provider.dart';
import 'package:technician_rensys/providers/id_provider.dart';
import 'package:technician_rensys/providers/job_list.dart';
import 'package:technician_rensys/providers/locale.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/providers/service_list.dart';
import 'package:technician_rensys/providers/user_bank_provider.dart';
import 'package:technician_rensys/screens/home_screen.dart';
import 'package:technician_rensys/screens/job_screen.dart';
import 'package:technician_rensys/screens/login_screen.dart';
import './services/graphql_client.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'models/profile.dart';


void main(List<String> args) async {
  await initHiveForFlutter();
  GraphQLConfig.getAccessToken();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  SharedPreferences? Lang;

  @override
  void initState() {
    super.initState();
    getLang();
    // _determinePosition();
  }

  //ask for user permission


  void getLang() async {
    Lang = await SharedPreferences.getInstance();
    if (Lang!.getString('lang') == null) {
      setState(() {
        _locale = Locale('en');
      });
    } else {
      setState(() {
        _locale = Locale(Lang!.getString('lang')!);
      });
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PageIndex()),
        ChangeNotifierProvider(create: (_) => JobList()),
        ChangeNotifierProvider(create: (_) => ServiceList()),
        ChangeNotifierProvider(create: (_) => IDProvider()),
        ChangeNotifierProvider(create: (_) => BundlePackageProvider()),
        ChangeNotifierProvider(create: (_) => UserBankProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => AllBanksProvider()),
      ],
      child: MaterialApp(
        title: 'Technician Rensys',
        locale: _locale,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
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
        home: Login(
          setLocale: setLocale,
        ),
        routes: {
          Home.homeRoute: (context) => const Home(),
          Job.jobRoute: (context) => const Job(),
        },
      ),
    );
  }
}
