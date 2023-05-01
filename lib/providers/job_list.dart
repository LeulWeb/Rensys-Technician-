import 'package:flutter/material.dart';
import 'package:technician_rensys/models/job.dart';

class JobList with ChangeNotifier {
  List<JobModel> _jobList = [];

  List<JobModel> get jobList => _jobList;

  void setJobs(List<JobModel> jobList) {
    _jobList =  jobList;
    notifyListeners();
  }
}
