import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:super_banners/super_banners.dart';

import 'package:technician_rensys/models/service.dart';
import 'package:technician_rensys/providers/id_provider.dart';

import 'package:technician_rensys/providers/page_index.dart';

import 'package:technician_rensys/widgets/text_app.dart';

import '../constants/colors.dart';

class ServiceCard extends StatefulWidget {
  final ServiceModel service;
  final bool actionTitle;
  final bool showNeedAccessory;

  const ServiceCard({
    super.key,
    required this.service,
    this.actionTitle = false,
    this.showNeedAccessory = true,
  });

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndex>(context);

    return Consumer<IDProvider>(
      builder: (context, value, child) {
        return Card(
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child:

                    //
                    Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextApp(
                        title: widget.service.title,
                        weight: FontWeight.bold,
                        size: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      widget.service.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                      ),
                    ),
                    const Divider(
                      height: 5,
                      color: darkBlue,
                    ),
                    Row(
                      children: const [
                        Icon(Icons.location_on),
                        Text("Customer Address")
                      ],
                    ),
                    const Divider(
                      height: 5,
                      color: darkBlue,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.phone_android_outlined),
                        const TextApp(
                            title: "Phone",
                            weight: FontWeight.normal,
                            size: 18),
                        const Spacer(),
                        Text(
                          widget.service.cusPhone,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),
                    //Experimenting table in flutter
                    Table(
                      border: TableBorder.all(width: 1.0, color: Colors.grey),
                      children: [
                        TableRow(
                          children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Region'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(widget.service.address.region ?? ''),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Zone'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.service.address.zone ?? ''),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Wereda'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(widget.service.address.wereda ?? ''),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Kebele'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text(widget.service.address.kebele ?? ''),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.date_range_rounded),
                        Text(
                          DateFormat("dd/MM/yyyy").format(
                              DateTime.parse(widget.service.requestedDate)),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Claimed On"),
                            Row(
                              children: [
                                const Icon(Icons.date_range_rounded),
                                Text(
                                  DateFormat("dd/MM/yyyy").format(
                                      DateTime.parse(
                                          widget.service.claimedDate ?? '')),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    widget.showNeedAccessory
                        ? TextButton(
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Icon(Icons.build),
                                SizedBox(
                                  width: 8,
                                ),
                                Text("Need Accessory"),
                              ],
                            ),
                          )
                        : Container(),

                    const SizedBox(
                      height: 8,
                    ),

                    widget.actionTitle
                        ? InkWell(
                            onTap: () async {
                              value.setService(widget.service);
                              pageIndex.navigateTo(7);
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
                                    "Resolved",
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
                        : Container()
                  ],
                ),
              ),
              widget.service.isWarranty
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
      },
    );
  }
}
