import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../models/user_bank.dart';

class UserBankProvider with ChangeNotifier{
  Logger logger = Logger();
  List<UserBank> _userBank = [];

   List<UserBank> get userBankList => _userBank;

  void setBankList(List<UserBank> userBankList) {
    _userBank =  userBankList;
    // logger.d(_userBank,"Called from provider");
    notifyListeners();
  }
}