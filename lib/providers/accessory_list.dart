import 'package:flutter/material.dart';
import 'package:technician_rensys/models/accessory.dart';

class AccessoryProvider with ChangeNotifier{
  List<Accessory> _accessoryList = [];


  List<Accessory> get accessoryList => _accessoryList;

  void  setAccessoryList(List<Accessory> value) {
    _accessoryList = value;
    notifyListeners();
  }
}