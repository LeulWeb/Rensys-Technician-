import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // updated value holders
  String fname = '';
  String lname = '';
  String phone = '';
  String? bio;
  String bank = '';
  String accountNumber = '';

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

  void showWarning() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    _isChecked = false;
                  },
                  child: const Text("Yes Continue")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancel"))
            ],
            title: Row(
              children: [
                Lottie.asset("assets/images/warning.json", width: 40),
                const Text(
                  "Are you Sure",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
              ],
            ),
            content: const IntrinsicHeight(
                child: Column(
              children: [
                Text(
                    "Turning off availability will make you inactive and prevent access to new job postings")
              ],
            )),
          );
        });
  }

  void _handleUpdate() {
    // final bool isValid = _formKey.currentState!.validate();
    if (true) {
      print(fname);
      print(lname);
    }
  }

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
    // fname = _profile.profile.firstName;
    // lname = _profile.profile.lastName;
    // phone = _profile.profile.phoneNumber;
    // bio = _profile.profile.bio;

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
                                : AssetImage('assets/images/logo.png')
                                    as ImageProvider,
                            radius: 60,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: lightBlue,
                              child: IconButton(
                                icon: const Icon(Icons.camera_alt_outlined),
                                onPressed: () {
                                  _pickImageFromGallery();
                                },
                              ),
                            ),
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
                            decoration: const InputDecoration(
                              labelText: "First Name",
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(),
                            ),
                            initialValue:fname,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your first name";
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              fname = value;
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Last Name",
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(),
                            ),
                            initialValue: lname,
                            validator: (value) {
                              if (value == null || value == '') {
                                return "Please enter your last name";
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              lname = value;
                            },
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
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(),
                  ),
                  initialValue:phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your phone number";
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    phone = value;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "Bio",
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(),
                  ),
                  initialValue: bio,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your bio";
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    bio = value;
                  },
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
                  decoration: const InputDecoration(
                    labelText: 'Choose your bank',
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  decoration: const InputDecoration(
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
                  onFieldSubmitted: (value) {
                    accountNumber = value;
                  },
                ),
                const SizedBox(
                  height: 12,
                ),
                CheckboxListTile(
                  title: const Text('Availability'),
                  subtitle: const Text('Are you available for jobs?'),
                  value: _isChecked,
                  onChanged: (bool? newValue) {
                    if (newValue != true) {
                      showWarning();
                    } else {
                      _isChecked = newValue!;
                    }
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.all(0),
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: _handleUpdate,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(
                        color: lightBlue,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mode_edit,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Update",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ],
                      ),
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
