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
import '../widgets/bank_card.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  static const profileRoute = "/profile";

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences? loginData;
  final _service = MainService();

  Logger logger = Logger();

  void logout() async {
    loginData = await SharedPreferences.getInstance();
    loginData!.setBool("loggedIn", false);
    loginData!.setString("accestoken", "");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Login(),
      ),
    );
  }

  void _loadData() async {
    await _service.getTechnician(context);
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
            icon: Icon(Icons.more_vert),
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
                      Icon(Icons.language),
                      const SizedBox(
                        width: 12,
                      ),
                      Text('Languages'),
                    ],
                  ),
                  value: 'language',
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
              print(value);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1621905252472-943afaa20e20?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=388&q=80",
                        ),
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
              const SizedBox(
                height: 23,
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
                                    onPressed: () {},
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
                          //Woking on the Bar
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

              Card(
                color: lightBlue,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ExpansionTile(
                    subtitle: Text(
                      "Account details",
                      style: TextStyle(color: Colors.white),
                    ),
                    iconColor: Colors.white,
                    leading: Icon(
                      Icons.account_balance,
                      size: 25,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Bank accounts",
                      style: TextStyle(color: Colors.white, fontSize: 16),
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
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                userBankProvider.userBankList[i].accountBalance
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //* Forth ROw to show complain

              const SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "Complain",
                          style: TextStyle(color: Colors.red, fontSize: 18),
                        ),
                        subtitle: Text(
                          "Report a problem",
                          style: TextStyle(color: Colors.red),
                        ),
                        leading: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.red,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "About Us",
                          style: TextStyle(color: lightBlue, fontSize: 18),
                        ),
                        subtitle: Text(
                          "Rensys Engineering",
                          style: TextStyle(color: lightBlue),
                        ),
                        leading: Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: lightBlue,
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
