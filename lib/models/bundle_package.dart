class BundlePackage {
  const BundlePackage({
    required this.name,
    required this.numberOfServices,
    required this.price,
    required this.type,
    required this.id,
  });

  final String name;
  final num numberOfServices;
  final num price;
  final String type;
  final String id;

  static BundlePackage fromJson(Map json) {
    return BundlePackage(
      name: json['name'],
      numberOfServices: json['number_of_service'],
      price: json['price'],
      type: json['plan_type'],
      id: json['id'],
    );
  }
}
