import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:technician_rensys/providers/job_list.dart';
import 'package:technician_rensys/services/main_service.dart';
import 'package:technician_rensys/widgets/text_app.dart';
import 'package:provider/provider.dart';
import '../widgets/job_card.dart';

class Job extends StatefulWidget {
  const Job({super.key});

  static const jobRoute = "/job";

  @override
  State<Job> createState() => _JobState();
}

class _JobState extends State<Job> {
  final mainService = MainService();

  @override
  Widget build(BuildContext context) {
    //consuming the provider
    final jobList = Provider.of<JobList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Jobs",
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await mainService.getJob(context);
        },
        child: Padding(
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
              jobList.jobList.isEmpty
                  ? Center(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            "assets/images/emptyJob.json",
                          ),
                          const Text(
                              "We regret to inform you that there are no new jobs available for you at this time."),
                        ],
                      ),
                    ),
                  )
                  :
                  //List view for the Jobs
                  Expanded(
                      child: ListView.builder(
                        itemCount: jobList.jobList.length,
                        itemBuilder: (context, index) {
                          return JobCard(
                            job: jobList.jobList[index],
                          );
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
