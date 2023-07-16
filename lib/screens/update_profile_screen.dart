// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/constants/colors.dart';
import 'package:technician_rensys/models/user_bank.dart';
import 'package:technician_rensys/providers/all_banks.dart';
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
  final MainService _service = MainService();
  bool isLoading = false;
  bool isUpdate = false;
  String errMessage = '';

  File? selectedImage;
  String? _chosenImage;
  Logger logger = Logger();
  dynamic _selectedValue;
  bool _isChecked = true;
  final _formKey = GlobalKey<FormState>();
  Profile _initProfile = Profile(
      firstName: "",
      lastName: "",
      isAvailable: false,
      isVerified: false,
      phoneNumber: "",
      package: 0,
      bio: "",
      id: "");

  Profile _userProfile = Profile(
    id: "",
    firstName: "",
    lastName: "",
    isAvailable: false,
    isVerified: false,
    phoneNumber: "",
    package: 0,
    bio: "",
  );

  //Dealing with all banks
  var ubank = UserBank(id: "", accountBalance: "", name: "", bankId: "");
  List<UserBank> userBankList = [];

  @override
  void didChangeDependencies() {
    _initProfile = Provider.of<ProfileProvider>(context).profile;
    _userProfile = Profile(
      id: _initProfile.id,
      firstName: _initProfile.firstName,
      lastName: _initProfile.lastName,
      isAvailable: _initProfile.isAvailable,
      isVerified: _initProfile.isAvailable,
      phoneNumber: _initProfile.phoneNumber,
      package: _initProfile.package,
      bio: _initProfile.bio,
    );

    userBankList = Provider.of<UserBankProvider>(context).userBankList;
    super.didChangeDependencies();
  }
  // using focus nodes

  late final lastNameNode;
  late final phoneNode;
  late final bioNode;

  @override
  void initState() {
    super.initState();
    lastNameNode = FocusNode();
    phoneNode = FocusNode();
    bioNode = FocusNode();
  }

  @override
  void dispose() {
    lastNameNode.dispose();
    phoneNode.dispose();
    bioNode.dispose();
    super.dispose();
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

  void showBar(
      Widget snack, String snackLabel, Color ctxColor, VoidCallback doSnack) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ctxColor,
        content: snack,
        // showCloseIcon: true,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> loadUpdate(Profile profile) async {
    try {
      final result = await _service.updateProfile(profile);

      if (result.data?["update_technician_by_pk"]["id"] == profile.id) {
        setState(() {
          isUpdate = true;
        });
      } else {
        setState(() {
          isUpdate = false;
        });
      }

      //  logger.d(result.data?["update_technician_by_pk"]["id"]);

      if (result.hasException) {
        logger.d(result.exception!.graphqlErrors[0].message);
        setState(() {
          errMessage = result.exception!.graphqlErrors[0].message.toString();
        });
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  void _handleUpdate() async {
    // logger.d(_userProfile.firstName);
    bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
        errMessage = '';
      });
      await loadUpdate(_userProfile);

      logger.d(isUpdate);
      if (isUpdate) {
        showBar(const Text("Profile has been updated successfully."), "",
            Colors.green, () {
          // Some code to undo the change.
        });
      } else {
        if (errMessage ==
            'Uniqueness violation. duplicate key value violates unique constraint "users_phone_number_key"') {
          errMessage = "Phone number already exist";
        }
        showBar(Text(errMessage), errMessage, Colors.red, () {
          // Some code to undo the change.
        });
      }
      setState(() {
        isLoading = false;
      });
      Provider.of<PageIndex>(context, listen: false).navigateTo(3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndex>(context);
    // final _userBank = Provider.of<UserBankProvider>(context).userBankList;
    // logger.d(_userBank[0].id);
    // logger.d(_userBank[0].accountBalance);
    // dynamic currentBank = _userBank.first.id;
    // dynamic currentAccount = _userBank.first.accountBalance;
    // logger.d(_userProfile.firstName);

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
                                : AssetImage('assets/images/profile.jpg')
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
                          //? First Name
                          TextFormField(
                            initialValue: _initProfile.firstName,
                            textInputAction: TextInputAction.next,
                            autofocus: true,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "First Name",
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your first name";
                              }
                              return null;
                            },
                            // textInputAction: TextInputAction.continueAction,
                            onFieldSubmitted: (value) {
                              lastNameNode.requestFocus();
                            },
                            onSaved: (newValue) {
                              _userProfile = Profile(
                                id: _userProfile.id,
                                firstName: newValue!,
                                lastName: _userProfile.lastName,
                                isAvailable: _userProfile.isAvailable,
                                isVerified: _userProfile.isVerified,
                                phoneNumber: _userProfile.phoneNumber,
                                package: _userProfile.package,
                                bio: _userProfile.bio,
                              );
                            },
                          ),

                          //* Last Name in
                          TextFormField(
                            focusNode: lastNameNode,
                            initialValue: _userProfile.lastName,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: "Last Name",
                              border: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value == '') {
                                return "Please enter your last name";
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              phoneNode.requestFocus();
                            },
                            onSaved: (newValue) {
                              _userProfile = Profile(
                                  id: _userProfile.id,
                                  firstName: _userProfile.firstName,
                                  lastName: newValue!,
                                  isAvailable: _userProfile.isAvailable,
                                  isVerified: _userProfile.isVerified,
                                  phoneNumber: _userProfile.phoneNumber,
                                  package: _userProfile.package,
                                  bio: _userProfile.bio);
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

                // *Phone Number Field
                TextFormField(
                  focusNode: phoneNode,
                  textInputAction: TextInputAction.next,
                  initialValue: _userProfile.phoneNumber,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(),
                  ),
                  // initialValue: phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your phone number";
                    } else if (value.length != 10) {
                      return "Your phone number should be 10 digit long, 0901234567 ";
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    bioNode.requestFocus();
                  },
                  onSaved: (newValue) {
                    _userProfile = Profile(
                        id: _userProfile.id,
                        firstName: _userProfile.firstName,
                        lastName: _userProfile.lastName,
                        isAvailable: _userProfile.isAvailable,
                        isVerified: _userProfile.isVerified,
                        phoneNumber: newValue!,
                        package: _userProfile.package,
                        bio: _userProfile.bio);
                  },
                ),
                const SizedBox(
                  height: 12,
                ),

                // * Bio Input
                TextFormField(
                  focusNode: bioNode,
                  initialValue: _userProfile.bio,
                  decoration: const InputDecoration(
                    labelText: "Bio",
                    border: UnderlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(),
                  ),
                  // initialValue: bio,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter your bio";
                    } else if (value.length > 100) {
                      return "Your bio can not be greater than 100 character";
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {},
                  onSaved: (newValue) {
                    _userProfile = Profile(
                        id: _userProfile.id,
                        firstName: _userProfile.firstName,
                        lastName: _userProfile.lastName,
                        isAvailable: _userProfile.isAvailable,
                        isVerified: _userProfile.isVerified,
                        phoneNumber: _userProfile.phoneNumber,
                        package: _userProfile.package,
                        bio: newValue!);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),

                //* Section two working with banks

                // This is for adding new bank account
                DropdownButtonFormField(
                  value: _selectedValue,
                  onChanged: (newValue) {
                    // setState(() {
                    //   _selectedValue = newValue;
                    // });
                  },
                  items: userBankList.map((bank) {
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

                // TextFormField(
                //   decoration: const InputDecoration(
                //     labelText: "Account Number",
                //     border: OutlineInputBorder(),
                //   ),
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return "Please enter your account number";
                //     }
                //     return null;
                //   },
                //   onFieldSubmitted: (value) {},
                //   textInputAction: TextInputAction.done,
                // ),

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
                  contentPadding: const EdgeInsets.all(0),
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: isLoading ? () {} : _handleUpdate,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: const BoxDecoration(
                        color: lightBlue,
                      ),
                      child: isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.hourglass_bottom,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Loading...",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            )
                          : const Row(
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
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
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
