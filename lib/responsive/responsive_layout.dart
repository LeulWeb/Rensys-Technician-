import 'package:flutter/material.dart';
import 'package:technician_rensys/responsive/mobile_layout.dart';
import 'package:technician_rensys/responsive/website_layout.dart';

import '../constants/breakpoint.dart';



class Responsive extends StatelessWidget {
  final void Function(Locale locale) setLocale;

  const Responsive({super.key, required this.setLocale});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint){
        if(constraint.maxWidth<= mobileBreakPoint){
          return Mobile(setLocale: setLocale,);
        }else{
          return Website();
        }
      },
    );
  }
}