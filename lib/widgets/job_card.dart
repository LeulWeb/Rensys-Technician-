import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:super_banners/super_banners.dart';
import 'package:technician_rensys/services/main_service.dart';
import 'package:technician_rensys/widgets/alert_box.dart';
import 'package:technician_rensys/widgets/text_app.dart';

import '../constants/colors.dart';
import '../models/job.dart';

class JobCard extends StatefulWidget {
  final JobModel job;

  JobCard({
    super.key,
    required this.job,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  QueryResult? claimResult;

  bool isLoading = false;

  final mainService = MainService();

  void _claimJob(String id, BuildContext context) async {
    claimResult = await mainService.claimJob(id);
    setState(() {
      isLoading = true;
    });
    await mainService.getJob(context);
    setState(() {
      isLoading = false;
    });

    if (claimResult!.data != null) {
      _showDialogBox(
        title: "Success",
        description: "The job is now in your queue.",
        actionTitle: "Done",
        done: () {
          Navigator.of(context).pop();
        },
      );
    }

    if (claimResult!.hasException) {
      _showDialogBox(
        title: "Error",
        description: "We apologize, Job is not claimed.",
        actionTitle: "Done",
        done: () {
          Navigator.of(context).pop();
        },
      );
    }
  }

  void _showDialogBox(
      {required String description,
      required String title,
      required String actionTitle,
      required VoidCallback done}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertBox(
            title: title,
            description: description,
            actionTitle: actionTitle,
            done: done,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextApp(
                    title: widget.job.service.title,
                    weight: FontWeight.bold,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  widget.job.service.description,
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
                          DateTime.parse(widget.job.service.requestedDate)),
                    ),
                    const Spacer(),
                    const Icon(Icons.location_on_outlined),
                    Text('${widget.job.distance.toString()} away'),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                isLoading
                    ? Center(
                        child: Lottie.asset("assets/images/loading.json",
                            width: 100),
                      )
                    : InkWell(
                        onTap: () {
                          _claimJob(widget.job.service.serviceReqId, context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: darkBlue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.handyman,
                                color: Colors.white,
                                weight: 500,
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Text(
                                "Fix It",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
              ],
            ),
          ),
          widget.job.service.isWarranty
              ? Positioned(
                  child: CornerBanner(
                      bannerPosition: CornerBannerPosition.topLeft,
                      bannerColor: Colors.green,
                      child: IntrinsicWidth(
                        child: Row(
                          children: const [
                            Icon(
                              Icons.shield,
                              color: Colors.white,
                            ),
                            Text(
                              "Warranty",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      )),
                )
              : Container()
        ],
      ),
    );
  }
}
