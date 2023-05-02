import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:technician_rensys/services/main_service.dart';
import 'package:technician_rensys/widgets/text_app.dart';
import '../providers/job_list.dart';
import '../services/graphql_service.dart';
import '../models/job.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

import 'job_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  static const homeRoute = "/home";

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // SharedPreferences? loginData;
  // String accessToken = '';
  final _graphqlService = MainService(JobList());
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
    setState(() {
      result = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobList>(builder: (context, jobList, child) {
      final jobsData = jobList.jobList;
      return Scaffold(
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextApp(
                        title: "Home",
                        size: 24,
                        weight: FontWeight.bold,
                      ),

                      const SizedBox(
                        height: 22,
                      ),
                      const TextApp(
                        title: "New Jobs",
                        size: 20,
                        weight: FontWeight.normal,
                      ),
                      //Working with the carousel

                      const SizedBox(
                        height: 22,
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                            height: MediaQuery.of(context).size.height * 0.30),
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
                    ],
                  ),
                ),
              ),
      );
    });
  }
}

class CarouselCard extends StatelessWidget {
  final JobModel job;
  const CarouselCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(color: Colors.amber),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              TextApp(
                title: job.title,
                weight: FontWeight.bold,
                size: 18,
              ),

              const SizedBox(
                height: 12,
              ),
              Expanded(child: Container()),

              Text(
                job.description.length >= 50
                    ? job.description.substring(50)
                    : job.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              // TextApp(
              //   title: job.description.length >= 50
              //       ? job.description.substring(50)
              //       : job.description,
              //   size: 12,
              //   weight: FontWeight.normal,
              // ),
              // const SizedBox(
              //   height: 12,
              // ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Displaying date of request
                  Row(
                    children: [
                      const Icon(Icons.date_range),
                      TextApp(
                        title: DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(job.requestedDate)),
                        weight: FontWeight.w300,
                        size: 12,
                      ),
                    ],
                  ),

                  //Working with distance
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      TextApp(
                        title: "${job.distance.toString()} Far",
                        weight: FontWeight.w300,
                        size: 12,
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(child: Container()),
              Container(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {
                    // Navigator.of(context).pushNamed(Job.jobRoute);
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              )
            ],
          )),
    );
  }
}
