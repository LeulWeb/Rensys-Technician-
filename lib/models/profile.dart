
import 'package:flutter/material.dart';

class Profile {
  Profile({
    required this.firstName,
    required this.lastName,
    this.avatar,
    this.bio,
    required this.isAvailable,
    required this.isVerified,
    required this.phoneNumber,
    required this.package,
    required this.id,
  });

  final String firstName;
  final String lastName;
  bool isAvailable;
  final String? bio;
  final String phoneNumber;
  final bool isVerified;
  final String id;

  //*Work on base 64 later
  final String? avatar;
  final int package;


  static Profile fromMap(Map map) {
    return Profile(
      id: map["id"],
      firstName: map["first_name"],
      lastName: map["last_name"],
      bio: map["bios"],
      phoneNumber: map["phone_number"],
      package: map["packages"],
      isAvailable: map["availability"],
      isVerified: map["is_verified"],
    );
  }
}


class ProfileProvider with ChangeNotifier{
  Profile _profile = Profile(
    id: "",
    firstName: "",
    lastName: "",
    bio: "",
    phoneNumber: "",
    package: 0,
    isAvailable: false,
    isVerified: false,
  );

  Profile get profile => _profile;

  void setProfile(Profile profile) {
    _profile = profile;
    notifyListeners();
  }
}