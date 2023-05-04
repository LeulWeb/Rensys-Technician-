
import 'service.dart';

class JobModel {
  JobModel( {
    // required this.isWarranty,
    required this.id,
    // required this.description,
    // required this.title,
    // required this.requestedDate,
    required this.distance,
    // required this.address, 
    required this.service
    // this.cusName,
    // required this.cusPhone,
    // this.claimedDate,
    // required this.address,
    // this.isClaimed = false,
    // required this.serviceReqId,
  });

  final String id;
  // final String description;
  // final String title;
  // final String requestedDate;
  final int distance;
  // final String? cusName;
  // final String cusPhone;
  // final String? claimedDate;
  // final Location address;
  final ServiceModel service;
  // final bool isWarranty;
  // bool isClaimed;
  // final String serviceReqId;
  //Method for converting the backend data to job model

  static JobModel fromMap(Map map) =>JobModel(
      id: map['id'],
      // description: map['service_request']['problem_description'],
      // title: map['service_request']['problem_class']['name'],
      // requestedDate: map['service_request']['created_at'],
      distance: map['proximity'],
      service: ServiceModel.fromMap(map['service_request']),
      // cusName: map['service_request']['cusName'], //cus Name is not set yet
      // cusPhone: map['service_request']['customer_phone'],
      // claimedDate: map['service_request']['technician_assigned_at'],
      // address: Location.fromMap(map['service_request']['address']),
      // isWarranty: map['service_request']['is_in_warranty_request'], serviceReqId: map['service_request']['id'],
    );
  
}
