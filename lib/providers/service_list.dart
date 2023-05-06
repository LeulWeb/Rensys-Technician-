import 'package:flutter/material.dart';
import 'package:technician_rensys/models/service.dart';

class ServiceList with ChangeNotifier {
  List<ServiceModel> _serviceList = [];
  List<ServiceModel> _completedServiceList = [];

  List<ServiceModel> get serviceList => _serviceList;
  List<ServiceModel> get completedServiceList => _completedServiceList;

  void setServices(List<ServiceModel> serviceList) {
    _serviceList = serviceList;
    notifyListeners();
  }

  void setCompleted(List<ServiceModel> completedServiceList) {
    _completedServiceList = completedServiceList;
    notifyListeners();
  }

  
}
