import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:technician_rensys/providers/job_list.dart';
import '../services/graphql_service.dart';
import 'package:provider/provider.dart';

class Job extends StatefulWidget {
  const Job({super.key});

  static const jobRoute = "/job";

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("This is job Screen"),
      ),
    );
  }
}
