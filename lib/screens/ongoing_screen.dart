import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/providers/page_index.dart';

class Progress extends StatelessWidget {
  const Progress({super.key});

  static const ongoingRoute = "/home/ongoing";

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
        title: const Text("Work in progress"),
      ),
      body: Container(
        child: Text("This is progress Screen"),
      ),
    );
  }
}
