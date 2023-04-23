import 'package:flutter/material.dart';

class PageIndex with ChangeNotifier{
  int _pageIndex = 0;

  int get pageIndex => _pageIndex;

  void navigateTo(int index){
    _pageIndex = index;
    notifyListeners();
  }
}