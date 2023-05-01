import 'package:flutter/material.dart';

class Location {
  Location({
    this.region,
    this.zone,
    this.wereda,
    this.kebele,
  });
  final String? region;
  final String? zone;
  final String? wereda;
  final String? kebele;

  static Location fromMap(Map map) {
    return Location(
      region: map['region']['name'],
      zone: map['zone']['name'],
      wereda: map['woreda']['name'],
      kebele: map['kebele']['name'],
    );
  }
}
