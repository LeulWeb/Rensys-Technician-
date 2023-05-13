import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:technician_rensys/screens/login_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  static const profileRoute = "/profile";

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SharedPreferences? loginData;

  // void logout() async {
  //   loginData = await SharedPreferences.getInstance();
  //   loginData!.setBool("loggedIn", false);
  //   loginData!.setString("accestoken", "");
  //   Navigator.of(context).pushReplacement(
  //     MaterialPageRoute(
  //       builder: (context) => Login(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndex>(context);

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        backgroundColor: Colors.green,
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
                            "First Name",
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Last Name",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(
                          "This is placeholder for bio of the technician, awesome",
                          // maxLines: 2,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 23,
            ),
            Divider(),
            Row(
              children: [
                Expanded(
                    child: Container(
                  child: Text("50"),
                  color: Colors.red,
                )),
                Expanded(
                  child: Container(
                    color: Colors.green,
                    child: Column(
                      children: [
                        //Woking on the Bar
                        CircularPercentIndicator(
                          radius: 60.0,
                          lineWidth: 5.0,
                          percent: 1.0,
                          center: new Text("100%"),
                          progressColor: Colors.green,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
