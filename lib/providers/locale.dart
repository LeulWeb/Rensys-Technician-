import 'package:flutter/material.dart';

class Lang with ChangeNotifier{
  Locale _locale = Locale('en', 'US');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}