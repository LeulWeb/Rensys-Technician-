import 'location.dart';

class ServiceModel {
  ServiceModel({
    required this.status,
    required this.description,
    required this.title,
    required this.requestedDate,
    required this.cusPhone,
    required this.claimedDate,
    required this.address,
    required this.isWarranty,
    required this.serviceReqId,
    required this.customerId,
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
  final String status;
  final String? customerId;

  static ServiceModel fromMap(Map map) {
    return ServiceModel(
        description: map['problem_description'],
        title: map['problem_class']['name'],
        requestedDate: map['created_at'],
        // cusName: map['cusName'], //cus Name is not set yet
        cusPhone: map['customer_phone'],
        claimedDate: map['technician_assigned_at'],
        address: Location.fromMap(map['address']),
        isWarranty: map['is_in_warranty_request'],
        serviceReqId: map['id'],
        status: map['status'],
        customerId: map['customer_id']);
  }

  factory ServiceModel.fromJson(Map<String, dynamic> data) {
    return ServiceModel(
      status: data["status"],
      description: data[" problem_description"],
      title: data["problem_class"]["name"],
      requestedDate: data["created_at"],
      cusPhone: data["customer_phone"],
      claimedDate: data["technician_assigned_at"],
      address: Location.fromMap(data["address"]),
      isWarranty: data["is_in_warranty_request"],
      serviceReqId: data["id"],
      customerId: data["customer_id"],
    );
  }
}
