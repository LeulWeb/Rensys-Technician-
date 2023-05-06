import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:technician_rensys/providers/service_list.dart';
import 'package:technician_rensys/widgets/service_card.dart';
import 'package:technician_rensys/widgets/text_app.dart';

import '../services/main_service.dart';

class Progress extends StatefulWidget {
  const Progress({super.key});

  static const ongoingRoute = "/home/ongoing";

  @override
  State<Progress> createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  final _graphqlService = MainService();
  QueryResult? result;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadService();
  }

  void _loadService() async {
    setState(() {
      isLoading = true;
    });
    QueryResult _result = await _graphqlService.getService(context, "progress");
    setState(() {
      result = _result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndex>(context);
    final serviceList = Provider.of<ServiceList>(context);

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextApp(
              title: "Track your progress with ease",
              weight: FontWeight.w300,
              size: 18,
            ),

            //Listing the available jobs
            Expanded(
              child: ListView.builder(
                itemCount: serviceList.serviceList.length,
                itemBuilder: (context, index) {
                  return ServiceCard(service: serviceList.serviceList[index]);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
