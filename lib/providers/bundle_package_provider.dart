import 'package:flutter/material.dart';
import 'package:technician_rensys/models/bundle_package.dart';

class BundlePackageProvider with ChangeNotifier{
  List<BundlePackage> _bundlePackage = [];

  List<BundlePackage> get bundlePackage => _bundlePackage;

  void setBundlePackage(List<BundlePackage> data){
    _bundlePackage = data;
    notifyListeners();
  }


}