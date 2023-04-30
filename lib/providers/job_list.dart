import 'package:flutter/material.dart';
import 'package:technician_rensys/models/job.dart';
import '../services/graphql_service.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/job.dart';

class JobList with ChangeNotifier {
  //fetch the data , construct an array out of it and provide the data in the form of JOb model

  final List<JobModel> _jobList= [];

  get jobList => _jobList;

  void setJobList(JobModel job){
    _jobList.add(job);
    notifyListeners();
  }
}
