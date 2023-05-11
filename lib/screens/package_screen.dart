import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/models/bundle_package.dart';
import 'package:technician_rensys/providers/bundle_package_provider.dart';
import 'package:technician_rensys/services/main_service.dart';

import '../providers/page_index.dart';
import '../widgets/package_card.dart';
import '../widgets/text_app.dart';

class BuyCoin extends StatefulWidget {
  const BuyCoin({super.key});

  @override
  State<BuyCoin> createState() => _BuyCoinState();
}

class _BuyCoinState extends State<BuyCoin> {
  bool isLoading = false;
  final _service = MainService();
  bool response = false;

  @override
  void initState() {
    super.initState();
    _loadPackage();
  }

  void _loadPackage() async {
    isLoading = true;
    response = await _service.getPackage(context);
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndex>(context);
    final bundlePackage = Provider.of<BundlePackageProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        _loadPackage();
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                pageIndex.navigateTo(0);
              },
              tooltip: "Go to home",
            ),
            title: const Text("Packages"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextApp(
                  title: "Buy package",
                  weight: FontWeight.normal,
                  size: 18,
                ),
                const SizedBox(
                  height: 12,
                ),
                const TextApp(
                  title:
                      "Buy packages to claim jobs, and see customers address",
                  weight: FontWeight.w200,
                  size: 16,
                ),

//List View to show all  bundle packages
                Expanded(
                  child: ListView.builder(
                    itemCount: bundlePackage.bundlePackage.length,
                    itemBuilder: (context, index) {
                      return PackageCard(
                        name: bundlePackage.bundlePackage[index].name,
                        price: bundlePackage.bundlePackage[index].price,
                        service:
                            bundlePackage.bundlePackage[index].numberOfServices,
                        type: bundlePackage.bundlePackage[index].type,
                      );
                    },
                  ),
                )
              ],
            ),
          )),
    );
  }
}
