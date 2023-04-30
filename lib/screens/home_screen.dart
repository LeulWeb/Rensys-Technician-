import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/job_list.dart';
import '../services/graphql_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const homeRoute = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  QueryResult? result;
  final _graphql_service = GraphQLService();
  List jobs = [];

  @override
  void initState() {
    super.initState();
    _loadJob();
  }

  void _loadJob() async {
    QueryResult _result = await _graphql_service.getJob();
    setState(() {
      result = _result;
      jobs = result!.data!["jobs"];

    });
    seeData();
  }

  void seeData(){
    jobs.forEach((e) => print(e["customer_phone"]));
  }

  @override
  Widget build(BuildContext context) {
    final jobList = Provider.of<JobList>(context);



    return const Scaffold(
      body: Center(
        child: Text("This is home Screen"),
      ),
    );
  }
}
