import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:technician_rensys/providers/job_list.dart';
import 'package:technician_rensys/services/main_service.dart';
import 'package:technician_rensys/widgets/empty.dart';
import 'package:technician_rensys/widgets/text_app.dart';
import 'package:provider/provider.dart';
import '../widgets/job_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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
        title:  Text(
          AppLocalizations.of(context)!.jobs,
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
          child: jobList.jobList.isEmpty
              ? const EmptyData(
                  title: "",
                  description:
                      "We regret to inform you that there are no new jobs available for you at this time.")
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     TextApp(
                      title: AppLocalizations.of(context)!.newNearByJobs,
                      weight: FontWeight.normal,
                      size: 18,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                     TextApp(
                      title:
                          AppLocalizations.of(context)!.jobsMessage,
                      weight: FontWeight.w200,
                      size: 16,
                    ),

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
