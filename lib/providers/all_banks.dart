import 'package:flutter/material.dart';

class AllBanksModel {
  AllBanksModel({required this.name, required this.id});
  final String name;
  final String id;

  static AllBanksModel fromMap(Map map) {
    return AllBanksModel(
      name: map["name"],
      id: map["id"],
    );
  }
}

class AllBanksProvider with ChangeNotifier {
  List<AllBanksModel> _allBanks = [];

  get allBanks => _allBanks;

  void setAllBanks(List<AllBanksModel> allBanks) {
    _allBanks = allBanks;
    notifyListeners();
  }
}
