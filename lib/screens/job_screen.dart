import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:technician_rensys/providers/job_list.dart';
import 'package:technician_rensys/widgets/text_app.dart';
import '../constatnts/colors.dart';
import '../services/graphql_service.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class Job extends StatefulWidget {
  const Job({super.key});

  static const jobRoute = "/job";

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  @override
  Widget build(BuildContext context) {
    //consuming the provider
    final jobList = Provider.of<JobList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Jobs",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextApp(
              title: "New nearby jobs",
              weight: FontWeight.normal,
              size: 18,
            ),
            const SizedBox(
              height: 12,
            ),
            const TextApp(
              title:
                  "Discover new nearby jobs and apply for maintenance jobs with ease.",
              weight: FontWeight.w200,
              size: 16,
            ),

            //List view for the Jobs
            Expanded(
              child: ListView.builder(
                itemCount: jobList.jobList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Stack(
                        children: [
                          if (jobList.jobList[index].isWarranty)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.green,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.shield,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      'Warranty',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: jobList.jobList[index].isWarranty
                                            ? Colors.white
                                            : orange,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          else
                            Container(),

                          //
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextApp(
                                title: jobList.jobList[index].title,
                                weight: FontWeight.bold,
                                size: 20,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                jobList.jobList[index].description,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                ),
                              ),
                              const Divider(),
                              Row(
                                children: [
                                  const Icon(Icons.date_range_rounded),
                                  Text(
                                    DateFormat("dd/MM/yyyy").format(
                                        DateTime.parse(jobList
                                            .jobList[index].requestedDate)),
                                  ),
                                  const Spacer(),
                                  const Icon(Icons.location_on_outlined),
                                  Text(
                                      '${jobList.jobList[index].distance.toString()} away'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
