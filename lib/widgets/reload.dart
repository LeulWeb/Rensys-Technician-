import 'package:flutter/material.dart';

class ReloadPage extends StatelessWidget {
  final Function action;
  final Widget page;
  const ReloadPage({super.key, required this.action, required this.page});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        action();
      },
      child: page,
    );
  }
}
