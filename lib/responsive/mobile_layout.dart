import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:technician_rensys/screens/home_screen.dart';
import 'package:technician_rensys/screens/job_screen.dart';
import 'package:technician_rensys/screens/notfication_screen.dart';
import 'package:technician_rensys/screens/profile_screen.dart';

class Mobile extends StatefulWidget {
  const Mobile({super.key});

  @override
  State<Mobile> createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  List<Widget> pages = const [Home(), Job(), Notfication(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Consumer<PageIndex>(
      builder: (context, pageIndex, child) {
        return Scaffold(
          body: pages[pageIndex.pageIndex],
          bottomNavigationBar: SafeArea(
              child: SlidingClippedNavBar(
            activeColor: Colors.red,
            selectedIndex: pageIndex.pageIndex,
            onButtonPressed: (index) {
              pageIndex.navigateTo(index);
            },
            iconSize: 30,
            barItems: [
              BarItem(title: "Home", icon: Icons.home),
              BarItem(title: "Job", icon: Icons.work),
              BarItem(title: "Notification", icon: Icons.notifications),
              BarItem(title: "Profile", icon: Icons.person),
            ],
          )),
        );
      },
    );
  }
}
