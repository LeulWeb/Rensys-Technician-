import 'package:flutter/material.dart';

class Website extends StatefulWidget {
  const Website({super.key});

  @override
  State<Website> createState() => _WebsiteState();
}

class _WebsiteState extends State<Website> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Drawer(
              width: MediaQuery.of(context).size.width * 0.2,
            )
          ],
        ),
      ),
    );
  }
}
