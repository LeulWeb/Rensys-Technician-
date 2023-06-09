// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician_rensys/constants/colors.dart';
import 'package:technician_rensys/models/profile.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:technician_rensys/screens/login_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:technician_rensys/services/main_service.dart';
import 'package:logger/logger.dart';
import '../providers/service_list.dart';
import '../providers/user_bank_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.setLocale});

  final void Function(Locale locale) setLocale;
  static const profileRoute = "/profile";

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences? loginData;
  final _service = MainService();

  SharedPreferences? Lang;

  Future<void> initLang() async {
    Lang = await SharedPreferences.getInstance();
  }

  Logger logger = Logger();

  void logout() async {
    loginData = await SharedPreferences.getInstance();
    loginData!.setBool("loggedIn", false);
    loginData!.setString("accestoken", "");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Login(
          setLocale: widget.setLocale,
        ),
      ),
    );
  }

  void _loadData() async {
    await _service.getTechnician(context);
  }

  //
  void _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Rensys Engineering"),
            content: IntrinsicHeight(
              child: IntrinsicWidth(
                child: Column(
                  children: [
                    Image.asset("assets/images/logo.png"),
                    Text(
                      "Rensys Engineering & Trading PLC is an energy solution company based in Addis Ababa.  It was established with the aim of playing its role in providing renewable energy solutions for energy-deprived communities. Since its establishment, the company has electrified millions of lives through SHS, solar mini-grid, and solar lanterns.",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                    Row(
                      children: [
                        Icon(Icons.phone),
                        SizedBox(
                          width: 2,
                        ),
                        Text("+251 952 494949 "),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.message_rounded),
                        SizedBox(
                          width: 2,
                        ),
                        Text("8544 (Toll Free)"),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.email_outlined),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "info@rensysengineering.com",
                          overflow: TextOverflow.clip,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  //function to alter the language
  void changeLang(String locale) async {
    widget.setLocale(Locale(locale));
    await Lang!.setString("lang", locale);

    String? currentlanguage = Lang!.getString("lang");
    if (currentlanguage! == "en") {
      showSuccess("Language is set to English");
    }
    if (currentlanguage == "am") {
      showSuccess("ቋንቋ ወደ አማርኛ ተቀናብሯል");
    }
  }

  void showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      backgroundColor: Colors.green,
      showCloseIcon: true,
      padding: const EdgeInsets.all(10),
    ));
  }

  double doPercentage() {
    final completedService =
        Provider.of<ServiceList>(context).completedServiceList;
    final enrolledService = Provider.of<ServiceList>(context).serviceList;
    return completedService.length /
        (enrolledService.length + completedService.length);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    initLang();
  }

  @override
  Widget build(BuildContext context) {
    final userBankProvider = Provider.of<UserBankProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final pageIndex = Provider.of<PageIndex>(
        context); //  logger.d(userBankProvider.userBankList,"Called from the profile screen");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            pageIndex.navigateTo(0);
          },
          tooltip: "Go to home",
        ),
        title: const Text("Profile"),
        actions: [
          PopupMenuButton(
            color: Color(0xffffffff),
            elevation: 0,
            icon: Icon(Icons.more_vert, color: darkBlue),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      const SizedBox(
                        width: 12,
                      ),
                      Text('Edit Profile'),
                    ],
                  ),
                  value: 'edit',
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.info_outline),
                      const SizedBox(
                        width: 12,
                      ),
                      Text('About Us'),
                    ],
                  ),
                  value: 'about',
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      const SizedBox(
                        width: 12,
                      ),
                      Text('Logout'),
                    ],
                  ),
                  value: 'logout',
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'logout') {
                logout();
              } else if (value == 'about') {
                _showDialog();
              } else {
                //edit profile
                pageIndex.navigateTo(10);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: Image.network(
                          "https://images.unsplash.com/photo-1682688759157-57988e10ffa8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=870&q=80",
                          fit: BoxFit.cover,
                        ).image,
                        radius: 50,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: profileProvider.profile.isAvailable
                              ? Colors.green
                              : Colors.red,
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              profileProvider.profile.firstName,
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              profileProvider.profile.lastName,
                              style: TextStyle(fontSize: 18),
                            ),
                            profileProvider.profile.isVerified
                                ? Icon(
                                    Icons.verified,
                                    color: lightBlue,
                                  )
                                : Container(),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            profileProvider.profile.bio ?? "",
                            // maxLines: 2,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          profileProvider.profile.phoneNumber,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ),

              Divider(),
              //* Second Row
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.handyman,
                                  color: Colors.white,
                                ),
                                Text(
                                  profileProvider.profile.package.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Jobs to Claim",
                              style: TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Buy package",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      pageIndex.navigateTo(9);
                                    },
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      color: lightBlue,
                    ),
                    Container(
                      child: Column(
                        children: [
                          //Working on the Bar
                          CircularPercentIndicator(
                            backgroundColor: Colors.red,
                            radius: 60.0,
                            lineWidth: 30.0,
                            percent: doPercentage(),
                            center: Text(
                                "${(doPercentage() * 100).toStringAsFixed(2)}%"),
                            progressColor: Colors.green,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text("Completed Jobs")
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Divider(),

              //* the third Div

              ClipRRect(
                borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(16),
                  topEnd: Radius.circular(16),
                ),
                child: Container(
                  color: Colors.white,
                  child: ExpansionTile(
                    subtitle: Text(
                      "Account details",
                      // style: TextStyle(color: Colors.white),
                    ),
                    iconColor: Colors.white,
                    leading: Icon(
                      Icons.account_balance,
                      size: 25,
                      color: lightBlue,
                    ),
                    title: Text(
                      "Bank accounts",
                      style: TextStyle(fontSize: 16),
                    ),
                    children: List.generate(
                      userBankProvider.userBankList.length,
                      (i) => ListView(
                        shrinkWrap: true,
                        children: [
                          ListTile(
                              title: Text(
                                userBankProvider.userBankList[i].name,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              subtitle: Text(
                                userBankProvider.userBankList[i].accountBalance
                                    .toString(),
                                style: TextStyle(fontSize: 16),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              ClipRRect(
                child: Container(
                  color: Colors.white,
                  child: ExpansionTile(
                      subtitle: Text(
                        "Your location is used to filter nearby jobs",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                      iconColor: Colors.white,
                      leading: Icon(
                        Icons.location_on_outlined,
                        size: 25,
                        color: lightBlue,
                      ),
                      title: Text(
                        "Location",
                        style: TextStyle(fontSize: 16),
                      ),
                      children: [Text("Location of user")]),
                ),
              ),

              ClipRRect(
                child: Container(
                  color: Colors.white,
                  child: ExpansionTile(
                      subtitle: Text(
                        "Select your language",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w300),
                      ),
                      iconColor: Colors.white,
                      leading: Icon(
                        Icons.translate_outlined,
                        size: 25,
                        color: lightBlue,
                      ),
                      title: Text(
                        "Language",
                        style: TextStyle(fontSize: 16),
                      ),
                      children: [
                        InkWell(
                          //to english language
                          onTap: () {
                            changeLang("en");
                          },
                          child: ListTile(
                            title: Text("English"),
                            subtitle: Text("Use English language"),
                          ),
                        ),
                        InkWell(
                          //to amharic language
                          onTap: () {
                            changeLang("am");
                          },
                          child: ListTile(
                            title: Text("አማርኛ"),
                            subtitle: Text("አማርኛ ቋንቋ ይምረጡ"),
                          ),
                        )
                      ]),
                ),
              ),

              //* Forth Row to show complain

              // const SizedBox(
              //   height: 8,
              // ),
              ClipRRect(
                borderRadius: BorderRadiusDirectional.only(
                  bottomStart: Radius.circular(16),
                  bottomEnd: Radius.circular(16),
                ),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Complain",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        subtitle: Text(
                          "Report a problem",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                        leading: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
