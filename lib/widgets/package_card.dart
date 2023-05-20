import 'package:flutter/material.dart';
import 'package:super_banners/super_banners.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';

import '../services/main_service.dart';

class PackageCard extends StatefulWidget {
  final String name;
  final num service;
  final num price;
  final String type;
  final String id;

  PackageCard({
    super.key,
    required this.name,
    required this.service,
    required this.price,
    required this.type,
    required this.id,
  });

  @override
  State<PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<PackageCard> {
  String _receipt_number = "";
  bool isLoading = false;
  bool response = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  MainService _service = MainService();

  void _buyPackage(context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isLoading = true;
      });
      bool result = await _service.buyPackage(
          amount: widget.price,
          subId: widget.id,
          receiptNumber: _receipt_number);
      setState(() {
        response = result;
        isLoading = false;
      });
      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Purchase sent for verification, stay patient"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Something went wrong"),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buy Package'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to buy this package?'),
                const SizedBox(
                  height: 12,
                ),
                Text('This will cost you ${widget.price.toString()} Birr'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Enter transaction number",
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (newValue) {
                              _receipt_number = newValue!;
                            },

                            //For validating user input
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your transaction number';
                              }
                              return null;
                            },
                          ),
                          isLoading
                              ? Center(
                                  child: Lottie.asset(
                                      "assets/images/loading.json",
                                      width: 150),
                                )
                              : Container(),
                        ],
                      )),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                _buyPackage(context);
              },
              child: const Text(
                'Purchase',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDialog(context);
      },
      child: Container(
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
                                widget.service.toString(),
                                style: TextStyle(
                                    fontSize: 26, color: Colors.white),
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
                  widget.type == "discount"
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
                        "${widget.price.toString()} Birr",
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Get access to ${widget.service} Job",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(widget.name),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
