import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/constants/colors.dart';
import 'package:technician_rensys/services/main_service.dart';

import '../models/profile.dart';
import '../providers/page_index.dart';
import '../providers/user_bank_provider.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  MainService _service = MainService();
  File? selectedImage;
  String? _chosenImage;
  Logger logger = Logger();
  List _banks = [];
  dynamic _selectedValue;
  bool _isChecked = true;
  @override
  void initState() {
    super.initState();
    allBanks();
  }

  //Pick image
  // Function to handle image selection from gallery
  Future<void> _pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    final imageBytes = await pickedImage!.readAsBytes();
    final base64Image = base64Encode(imageBytes);

    if (pickedImage != null) {
      setState(() {
        selectedImage = File(pickedImage.path);
        _chosenImage = base64Image;
      });
      // Do something with the selected image
    }
    print(_chosenImage);
  }

  //? Load all banks
  void allBanks() async {
    List _bankList = await _service.getAllBanks(context);
    setState(() {
      _banks = _bankList;
    });
  }

  //? Load all user banks
  // void userBanks() async {
  //   List _userBankList = await _service.getBankAccount(context);
  //   setState(() {
  //     _userBank = _userBankList;
  //   });
  //   logger.d(_userBankList);
  // }

  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndex>(context);
    final _profile = Provider.of<ProfileProvider>(context);
    final _userBank = Provider.of<UserBankProvider>(context);
    dynamic currentBank = _userBank.userBankList.first.id;
    dynamic currentAccount = _userBank.userBankList.first.accountBalance;
    logger.i(_userBank.userBankList);

    //  final FocusNode _passwordFocus = FocusNode();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            pageIndex.navigateTo(3);
          },
          tooltip: "Go to home",
        ),
        title: const Text("Update Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : AssetImage('assets/images/avatar.png')
                                    as ImageProvider,
                            radius: 60,
                          ),
                          Positioned(
                            child: CircleAvatar(
                              child: IconButton(
                                icon: Icon(Icons.camera_alt_outlined),
                                onPressed: () {
                                  _pickImageFromGallery();
                                },
                              ),
                              backgroundColor: lightBlue,
                            ),
                            bottom: 0,
                            right: 0,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "First Name",
                              border: OutlineInputBorder(),
                            ),
                            initialValue: _profile.profile.firstName,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your first name";
                              }
                              return null;
                            },
                            // onFieldSubmitted: (value) {
                            //   _passwordFocus.requestFocus();
                            // },
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Last Name",
                              border: OutlineInputBorder(),
                            ),
                            initialValue: _profile.profile.lastName,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your last name";
                              }
                              return null;
                            },
                            // onFieldSubmitted: (value) {
                            //   _passwordFocus.requestFocus();
                            // },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _profile.profile.phoneNumber,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your phone number";
                    }
                    return null;
                  },
                  // onFieldSubmitted: (value) {
                  //   _passwordFocus.requestFocus();
                  // },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Bio",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _profile.profile.bio,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your bio";
                    }
                    return null;
                  },
                  // onFieldSubmitted: (value) {
                  //   _passwordFocus.requestFocus();
                  // },
                ),
                const SizedBox(
                  height: 16,
                ),

                //This is for adding new bank account
                DropdownButtonFormField(
                  value: _selectedValue,
                  onChanged: (newValue) {
                    // Set the selected value
                    setState(() {
                      _selectedValue = newValue;
                    });
                    print(_selectedValue);
                  },
                  items: _banks.map((bank) {
                    return DropdownMenuItem(
                      value: bank.id,
                      child: Text(bank.name),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Choose your bank',
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Account Number",
                    border: OutlineInputBorder(),
                  ),
                  initialValue: _userBank.userBankList
                          .any((element) => element.id == _selectedValue)
                      ? _userBank.userBankList
                          .firstWhere((element) => element.id == _selectedValue)
                          .accountBalance
                      : "",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your account number";
                    }
                    return null;
                  },
                  // onFieldSubmitted: (value) {
                  //   _passwordFocus.requestFocus();
                  // },
                ),
                const SizedBox(
                  height: 12,
                ),
                CheckboxListTile(
                  title: Text('Availability'),
                  subtitle: Text('Are you available for jobs?'),
                  value: _isChecked,
                  onChanged: (bool? newValue) {
                    setState(() {
                      _isChecked = newValue!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.all(0),
                ),
                const SizedBox(
                  height: 8,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: lightBlue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.mode_edit,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Update",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
