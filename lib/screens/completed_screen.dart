import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/page_index.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndex>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            pageIndex.navigateTo(0);
          },
          tooltip: "Go to home",
        ),
        title: const Text("Completed Jobs"),
      ),
      body: Container(
        child: Text("Completed"),
      ),
    );
  }
}
