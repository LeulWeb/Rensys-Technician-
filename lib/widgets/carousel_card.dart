import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/constants/colors.dart';
import 'package:technician_rensys/widgets/text_app.dart';

import '../models/job.dart';
import '../providers/page_index.dart';

class CarouselCard extends StatelessWidget {
  final JobModel job;
  const CarouselCard({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    final index = Provider.of<PageIndex>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                Color(0xFF0d47a1),
                Color(0xFF0d47a1),
                Color(0xFF0d47a1),
                Color.fromARGB(255, 25, 114, 192),
                Color(0xFF0d47a1),
                Color(0xFF0d47a1),
                Color(0xFF0d47a1),
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              TextApp(
                isWhite: true,
                title: job.service.title,
                weight: FontWeight.bold,
                size: 18,
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(child: Container()),
              Text(
                job.service.description.length >= 50
                    ? job.service.description.substring(50)
                    : job.service.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Displaying date of request
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range,
                        color: Colors.white,
                      ),
                      TextApp(
                        isWhite: true,
                        title: DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(job.service.requestedDate)),
                        weight: FontWeight.w300,
                        size: 12,
                      ),
                    ],
                  ),

                  //Working with distance
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                      ),
                      TextApp(
                        isWhite: true,
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
                    index.navigateTo(1);
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
