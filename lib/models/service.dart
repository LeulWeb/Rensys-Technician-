import 'location.dart';

class ServiceModel {
  ServiceModel({
    required this.description,
    required this.title,
    required this.requestedDate,
    required this.cusPhone,
    required this.claimedDate,
    required this.address,
    required this.isWarranty,
    required this.serviceReqId,
    this.isClaimed = false,
  });

  final String description;
  final String title;
  final String requestedDate;
  // final String? cusName;
  final String cusPhone;
  final String? claimedDate;
  final Location address;
  final bool isWarranty;
  bool isClaimed;
  final String serviceReqId;

  static ServiceModel fromMap(Map map) => ServiceModel(
        description: map['problem_description'],
        title: map['problem_class']['name'],
        requestedDate: map['created_at'],
        // cusName: map['cusName'], //cus Name is not set yet
        cusPhone: map['customer_phone'],
        claimedDate: map['technician_assigned_at'],
        address: Location.fromMap(map['address']),
        isWarranty: map['is_in_warranty_request'],
        serviceReqId: map['id'],
      );
}
