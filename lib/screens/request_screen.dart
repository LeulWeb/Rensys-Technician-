import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:technician_rensys/providers/accessory_list.dart';
import 'package:technician_rensys/providers/id_provider.dart';

import '../providers/page_index.dart';
import '../services/main_service.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  bool _isLoading = false;
  String errMessage = "";
  bool isSuccess = false;
  MainService service = MainService();

  @override
  void initState() {
    _loadAccessories();
    super.initState();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _loadAccessories() async {
    try {
      setState(() {
        _isLoading = true;
        errMessage = "";
      });

      final result = await service.getAccessories(context);

      if (result.hasException) {
        setState(() {
          errMessage = result.exception!.graphqlErrors[0].message;
        });
      }

      setState(() {
        isSuccess = true;
        _isLoading = false;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  //Request accessory
  void requestAccessory(
      {required String servId,
      required String accessoryId,
      required int quantity,
      required String reason}) async {
    try {
      setState(() {
        _isLoading = true;
        errMessage = "";
      });

      final result = await service.requestAccessory(
        accessoryId: accessoryId,
        quantity: quantity,
        description: reason,
        serviceId: servId,
      );

      if (result.hasException) {
        setState(() {
          errMessage = result.exception!.graphqlErrors[0].message;
          isSuccess = false;
          _isLoading = false;
        });
      }

      setState(() {
        isSuccess = true;
        _isLoading = false;
      });

      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Request sent successfully"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Request failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  //show dialog
  void _showDialog(String servId, String accessoryId, String accessoryName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(accessoryName),
        content: Container(
          width: double.infinity,
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Select the accessory you need"),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  children: [
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Why do you need the accessory",
                        labelText: "Reason",
                      ),
                      controller: _reasonController,
                    ),

                    // Quantity
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "How many do you need",
                        labelText: "Quantity",
                      ),
                      controller: _quantityController,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              requestAccessory(
                servId: servId,
                accessoryId: accessoryId,
                quantity: int.parse(_quantityController.text) < 1 ||
                        int.parse(_quantityController.text) == null
                    ? 1
                    : int.parse(_quantityController.text),
                reason: _reasonController.text,
              );
              Navigator.of(context).pop();
            },
            child: const Text("Request"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = Provider.of<PageIndex>(context);
    final idProvider = Provider.of<IDProvider>(context);
    final List accessoryList =
        Provider.of<AccessoryProvider>(context).accessoryList;

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
        title: const Text("Need Accessory"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select the accessory you need",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            // Accessory list
            Container(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                        ),
                        itemCount: accessoryList.length,
                        itemBuilder: (context, index) {
                          String firstImageUrl = accessoryList[index]
                              .images
                              .split(',')
                              .first
                              .trim();
                          return Card(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 9.0),
                                    child: Text(
                                      accessoryList[index].name,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 100,
                                    alignment: Alignment.center,
                                    child: Image.network(
                                      firstImageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    accessoryList[index]
                                            .description
                                            .substring(0, 200) +
                                        "......",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),

                                  // Button
                                  InkWell(
                                    onTap: () {
                                      // print(accessoryList[index].id);
                                      // print(accessoryList[index].name);
                                      // print(idProvider.service.serviceReqId);
                                      _showDialog(
                                        idProvider.service.serviceReqId,
                                        accessoryList[index].id,
                                        accessoryList[index].name,
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.blue,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Text(
                                          "Request " +
                                              accessoryList[index].name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
