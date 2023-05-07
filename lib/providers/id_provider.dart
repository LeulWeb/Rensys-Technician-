import 'package:flutter/material.dart';
import 'package:technician_rensys/models/service.dart';

class IDProvider with ChangeNotifier {
   ServiceModel? _service;

  ServiceModel get service => _service!;

  void setService(ServiceModel? data) {
    _service = data;
    notifyListeners();
  }
}