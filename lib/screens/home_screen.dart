import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:technician_rensys/constants/colors.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:technician_rensys/providers/service_list.dart';

import 'package:technician_rensys/services/main_service.dart';
import 'package:technician_rensys/widgets/action_card.dart';
import 'package:technician_rensys/widgets/custom_badge.dart';
import 'package:technician_rensys/widgets/reload.dart';
import 'package:technician_rensys/widgets/text_app.dart';
import '../providers/job_list.dart';

import 'package:carousel_slider/carousel_slider.dart';

import '../widgets/carousel_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const homeRoute = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // SharedPreferences? loginData;
  // String accessToken = '';
  final _graphqlService = MainService();
  QueryResult? result;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadJob();
  }

  void _loadJob() async {
    setState(() {
      isLoading = true;
    });
    QueryResult _result = await _graphqlService.getJob(context);
    _graphqlService.getService(context, "progress");
    _graphqlService.getService(context, "completed");

    setState(() {
      result = _result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    int progressCount = Provider.of<ServiceList>(context).serviceList.length;

    final int completedCount =
        Provider.of<ServiceList>(context).completedServiceList.length;

    return RefreshIndicator(
      onRefresh: () async {
        _loadJob();
      },
      child: Consumer<JobList>(builder: (context, jobList, child) {
        final jobsData = jobList.jobList;
        return RefreshIndicator(
          onRefresh: () async {
            _loadJob();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Home",
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TextApp(
                      title: "New Jobs",
                      size: 20,
                      weight: FontWeight.normal,
                    ),
                    //Working with the carousel

                    const SizedBox(
                      height: 22,
                    ),

                    ReloadPage(
                      action: () {
                        _loadJob();
                      },
                      page: Container(
                        child: result != null
                            ? isLoading
                                ? Container(
                                    child: Text("Loading"),
                                  )
                                : result!.hasException ||
                                        jobList.jobList.isEmpty
                                    ? ReloadPage(
                                        action: () {
                                          _loadJob();
                                        },
                                        page: Center(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    "assets/images/hero.png",
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.25),
                                                const Text(
                                                    "We regret to inform you that there are no new jobs available for you at this time.")
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : CarouselSlider(
                                        options: CarouselOptions(
                                            aspectRatio: 16 / 9,
                                            enlargeCenterPage: true,
                                            enlargeFactor: 0.1,
                                            viewportFraction: 0.9,
                                            enableInfiniteScroll: false,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.30),
                                        items: jobsData.map((job) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return CarouselCard(
                                                job: job,
                                              );
                                            },
                                          );
                                        }).toList(),
                                      )
                            : Container(
                                child: Column(
                                  children: [
                                    Lottie.asset(
                                        "assets/images/noInternet.json",
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.25),
                                    const Text(
                                        "Check your Internet connection, and try again later")
                                  ],
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),
                    const TextApp(
                      title: "My Work",
                      size: 20,
                      weight: FontWeight.normal,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    //The Grid Components
                    Expanded(
                      child: Consumer<PageIndex>(
                        builder: (context, value, child) => GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 5 / 4,
                          ),
                          children: [
                            ActionCard(
                                custom_badge:
                                    CustomBadge(number: progressCount),
                                goTo: () {
                                  value.navigateTo(5);
                                },
                                colors: [orange, orange],
                                color: orange,
                                ActionIcon: const Icon(
                                  Icons.hourglass_bottom_rounded,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                title: "Pending",
                                description: "Track in-progress"),
                            ActionCard(
                                colors: const [lightBlue, lightBlue],
                                custom_badge:
                                    CustomBadge(number: completedCount),
                                goTo: () {
                                  value.navigateTo(4);
                                },
                                color: Colors.red,
                                ActionIcon: const Icon(
                                  Icons.check_circle_outline_outlined,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                title: "Finished",
                                description: "View finished tasks."),
                            ActionCard(
                                colors: [Colors.green, Colors.green],
                                custom_badge: null,
                                goTo: () {
                                  value.navigateTo(9);
                                },
                                color: Colors.red,
                                ActionIcon: Icon(
                                  Icons.attach_money,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                title: "Coin",
                                description: "Buy service bundle"),
                            ActionCard(
                              colors: [yellow, yellow],
                              custom_badge: null,
                              goTo: () {
                                value.navigateTo(6);
                              },
                              color: Colors.red,
                              title: "Recent",
                              ActionIcon: const Icon(
                                Icons.access_time,
                                color: Colors.white,
                                size: 50,
                              ),
                              description: "View recent tasks.",
                            ),
                          ],
                        ),
                      ),
                    ),
                    // const TextApp(
                    //   title: "Packages",
                    //   size: 20,
                    //   weight: FontWeight.normal,
                    // ),
                    // const SizedBox(
                    //   height: 12,
                    // ),
                    // const Placeholder(
                    //   fallbackHeight: 100,
                    // ),
                    // const SizedBox(
                    //   height: 12,
                    // )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
