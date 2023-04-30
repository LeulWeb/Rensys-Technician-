import './location.dart';

class JobModel {
  JobModel({
    required this.isWarranty,
    required this.id,
    required this.description,
    required this.title,
    required this.requestedDate,
    required this.distance,
    required this.cusName,
    required this.cusPhone,
    required this.claimedDate,
    required this.address,
    this.isClaimed = false,
  });

  final String id;
  final String description;
  final String title;
  final DateTime requestedDate;
  final double distance;
  final String cusName;
  final String cusPhone;
  final DateTime claimedDate;
  final Location address;
  final bool isWarranty;
  bool isClaimed;
  //Method for converting the backend data to job model
  static JobModel fromMap(Map map) {
    return JobModel(
      id: map['id'],
      description: map['problem_description'],
      title: map['title'],
      requestedDate: map['requestedDate'],
      distance: map['proximity'],
      cusName: map['cusName'],
      cusPhone: map['customer_phone'],
      claimedDate: map['technician_assigned_at'],
      address: map['service_request']['address'],
      isWarranty: map['is_in_warranty_request'],
    );
  }
}
