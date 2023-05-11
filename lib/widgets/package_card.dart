import 'package:flutter/material.dart';
import 'package:super_banners/super_banners.dart';

class PackageCard extends StatelessWidget {
  final String name;
  final int service;
  final int price;
  final String type;

  const PackageCard({
    super.key,
    required this.name,
    required this.service,
    required this.price,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 0,
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  color: Colors.green,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.handyman,
                              size: 20,
                              color: Colors.white,
                            ),
                            Text(
                              service.toString(),
                              style:
                                  TextStyle(fontSize: 26, color: Colors.white),
                            ),
                          ],
                        ),
                        const Text(
                          "Jobs",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
                type == "discount"
                    ? Positioned(
                        bottom: 0,
                        child: CornerBanner(
                          bannerPosition: CornerBannerPosition.bottomLeft,
                          bannerColor: Colors.blue,
                          child: Text(
                            "Discount",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    const Icon(Icons.monetization_on_rounded),
                    Text(
                      "${price.toString()} Birr",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  "Get access to ${service} Job",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(name),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
