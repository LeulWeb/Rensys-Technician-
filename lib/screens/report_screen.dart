import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/constants/colors.dart';
import 'package:technician_rensys/providers/id_provider.dart';
import 'package:technician_rensys/providers/page_index.dart';
import 'package:technician_rensys/services/main_service.dart';
import 'package:technician_rensys/widgets/service_card.dart';

import '../widgets/alert_box.dart';
import '../widgets/text_app.dart';

class Report extends StatefulWidget {
  const Report({
    super.key,
  });

  static const reportRoute = "/home/completed/report";

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isFixed = false;
  String serviceId = "";
  String problemDescription = "";
  String solutionProvided = "";
  final _graphQlService = MainService();
  QueryResult? result;

  void _onSwitchChanged(bool value) {
    setState(() {
      isFixed = value;
    });
  }

  void _showDialogBox({
    required String title,
    required String description,
    required String actionTitle,
    required Function done,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertBox(
            title: title,
            description: description,
            actionTitle: actionTitle,
            done: () {
              done();
            },
          );
        });
  }

  void _submit() async {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      print("alfa fdkfalkdfjalkdf adfjasdl f");
      _formKey.currentState!.save();
      result = await _graphQlService.reportWork(
        serviceId: serviceId,
        isCompleted: isFixed,
        problemDescription: problemDescription,
        solutionDescription: solutionProvided,
      );

      if (result!.hasException) {
        print(result!.exception);
      }

      if (result!.data!["insert_technician_report_one"]["id"] != null) {
        _showDialogBox(
          title: "Submitted",
          description:
              "The form has been submitted and is currently under review by the administrator. You will be notified once a decision has been made",
          actionTitle: "Done",
          done: () {
            goBack();
            Navigator.of(context).pop();
          },
        );
      }
    }
  }

  void goBack() {
    final pageIndex = Provider.of<PageIndex>(context, listen: false);
    pageIndex.navigateTo(5);
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndex>(context);
    final idProvider = Provider.of<IDProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            idProvider.setService(null);
            pageIndex.navigateTo(5);
          },
          tooltip: "Go to home",
        ),
        title: const Text("Report Service"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextApp(
                title: "Work Summary",
                weight: FontWeight.normal,
                size: 18,
              ),
              const SizedBox(
                height: 12,
              ),
              const TextApp(
                title:
                    "Once you submit your work summary report, it will be sent for review and approval by the admin. We appreciate your efforts and will notify you once your report has been approved.",
                weight: FontWeight.w200,
                size: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.white
                      : Colors.black,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: ExpansionTile(
                  clipBehavior: Clip.none,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  title: Text(idProvider.service.title),
                  children: <Widget>[
                    ServiceCard(
                      service: idProvider.service,
                      actionTitle: false,
                    ),
                  ],
                ),
              ),

              //Form For Report
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.light
                      ? Colors.white
                      : Colors.black,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextApp(
                            title: "Is the solution completed?",
                            weight: FontWeight.normal,
                            size: 18,
                          ),
                          Switch(
                              value: isFixed,
                              activeTrackColor: Colors.green,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Colors.red,
                              onChanged: (value) {
                                _onSwitchChanged(value);
                              })
                        ],
                      ),
                      TextFormField(
                        minLines: 3,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText:
                              "Please provide a detailed description of the problem.",
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: lightBlue,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                        ),
                        onSaved: (newValue) {
                          serviceId = idProvider.service.serviceReqId;
                          problemDescription = newValue!.trim();
                        },
                        validator: (value) {
                          if (value == null) {
                            return "problem description can't empty";
                          }
                          if (value.isEmpty) {
                            return "problem description can't empty";
                          }
                          List<String> words = value.split(' ');
                          int wordCount = words.length;
                          if (wordCount < 5) {
                            return "Please enter at least 5 words.";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextFormField(
                        minLines: 3,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText:
                              "Please provide a detailed explanation of the solution provided.",
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 2,
                              color: lightBlue,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                        ),
                        onSaved: (newValue) {
                          solutionProvided = newValue!.trim();
                        },
                        validator: (value) {
                          if (value == null) {
                            return "work summary can't empty";
                          }
                          if (value.isEmpty) {
                            return "work summary can't empty";
                          }
                          List<String> words = value.split(' ');
                          int wordCount = words.length;
                          if (wordCount < 5) {
                            return "Please enter at least 5 words.";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () {
                          _submit();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "submit",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
