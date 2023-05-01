import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:technician_rensys/services/main_service.dart';
import 'package:technician_rensys/widgets/text_app.dart';
import '../providers/job_list.dart';
import '../services/graphql_service.dart';
import '../models/job.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const homeRoute = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // SharedPreferences? loginData;
  // String accessToken = '';
  final _graphqlService = MainService(JobList());
  QueryResult? result;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadJob();
  }

  void _loadJob() async {
    setState(() {
      isLoading = true; 
    });
    QueryResult _result = await _graphqlService.getJob(context);
    setState(() {
      result = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobList>(builder: (context, jobList, child) {
      final jobsData = jobList.jobList;
      return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    children: [
                      TextApp(
                        title: jobsData[0].description,
                        size: 24,
                        weight: FontWeight.bold,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text("click Me"),
                      )
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
