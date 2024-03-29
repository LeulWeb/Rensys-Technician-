import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:technician_rensys/screens/home_screen.dart';
import 'package:technician_rensys/screens/job_screen.dart';
import 'package:technician_rensys/screens/notfication_screen.dart';
import 'package:technician_rensys/screens/ongoing_screen.dart';
import 'package:technician_rensys/screens/profile_screen.dart';
import 'package:technician_rensys/screens/recent_screen.dart';
import 'package:technician_rensys/screens/report_screen.dart';
import 'package:technician_rensys/screens/request_screen.dart';
import 'package:technician_rensys/screens/package_screen.dart';

import '../constants/colors.dart';
import '../screens/completed_screen.dart';
import '../screens/update_profile_screen.dart';

class Mobile extends StatefulWidget {
  final void Function(Locale locale) setLocale;
  //const Mobile({required Key key, required this.setLocale}) : super(key: key);
  const Mobile({super.key, required this.setLocale});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    pages = [
      const Home(),
      const Job(),
      const NotificationScreen(),
      Profile(setLocale: widget.setLocale),
      const CompletedScreen(),
      const Progress(),
      const Recent(),
      const Report(),
      const Request(),
      const BuyCoin(),
       UpdateProfile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageIndex>(
      builder: (context, pageIndex, child) {
        return Scaffold(
          body: pages[pageIndex.pageIndex],
          bottomNavigationBar: SafeArea(
              child: SlidingClippedNavBar(
            activeColor: darkBlue,
            selectedIndex: pageIndex.pageIndex,
            onButtonPressed: (index) {
              pageIndex.navigateTo(index);
            },
            iconSize: 30,
            barItems: [
              BarItem(title: "Home", icon: Icons.home),
              BarItem(title: "Job", icon: Icons.work),
              BarItem(title: "Alert", icon: Icons.notifications),
              BarItem(title: "Profile", icon: Icons.person),
            ],
          )),
        );
      },
    );
  }
}
