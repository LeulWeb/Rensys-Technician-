import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:technician_rensys/services/main_service.dart';
import '../constants/colors.dart';
import '../providers/page_index.dart';
import '../providers/service_list.dart';
import '../widgets/empty.dart';
import '../widgets/service_card.dart';
import '../widgets/text_app.dart';

class CompletedScreen extends StatefulWidget {
  const CompletedScreen({super.key});

  @override
  State<CompletedScreen> createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  QueryResult? result;
  final MainService service = MainService();

  @override
  void initState() {
    loadServicesList();
    super.initState();
  }

  void loadServicesList() async {
    result = await service.getService(context, "completed");
    print(result!.data);
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndex>(context);
    final serviceList = Provider.of<ServiceList>(context);
    return RefreshIndicator(
      color: darkBlue,
      backgroundColor: Colors.white,
      displacement: 40.0,
      strokeWidth: 3.0,
      semanticsLabel: 'Refresh',
      semanticsValue: 'Refresh',
      onRefresh: () async {
        loadServicesList();
      },
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextApp(
                title: "See what you have completed",
                weight: FontWeight.w300,
                size: 18,
              ),

              //Listing the available jobs
              serviceList.completedServiceList.isEmpty
                  ? const Text("No completed jobs")
                  : Expanded(
                      child: ListView.builder(
                        itemCount: serviceList.completedServiceList.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            title: Text(
                                serviceList.completedServiceList[index].title),
                            children: [
                              ServiceCard(
                                service:
                                    serviceList.completedServiceList[index],
                                actionTitle: false,
                                showNeedAccessory: false,
                              )
                            ],
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
