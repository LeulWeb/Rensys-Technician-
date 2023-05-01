import './location.dart';

class JobModel {
  JobModel({
    required this.isWarranty,
    required this.id,
    required this.description,
    required this.title,
    required this.requestedDate,
    required this.distance,
    // this.cusName,
    required this.cusPhone,
    this.claimedDate,
    required this.address,
    this.isClaimed = false,
  });

  final String id;
  final String description;
  final String title;
  final String requestedDate;
  final int distance;
  // final String? cusName;
  final String cusPhone;
  final String? claimedDate;
  final Location address;
  final bool isWarranty;
  bool isClaimed;
  //Method for converting the backend data to job model

  static JobModel fromMap(Map map) =>JobModel(
      id: map['id'],
      description: map['service_request']['problem_description'],
      title: map['service_request']['problem_class']['name'],
      requestedDate: map['service_request']['created_at'],
      distance: map['proximity'],
      // cusName: map['cusName'], //cus Name is not set yet
      cusPhone: map['service_request']['customer_phone'],
      claimedDate: map['service_request']['technician_assigned_at'],
      address: Location.fromMap(map['service_request']['address']),
      isWarranty: map['service_request']['is_in_warranty_request'],
    );
  
}
