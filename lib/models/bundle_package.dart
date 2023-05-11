class BundlePackage {
  const BundlePackage({
    required this.name,
    required this.numberOfServices,
    required this.price,
    required this.type,
  });

  final String name;
  final int numberOfServices;
  final int price;
  final String type;

  static BundlePackage fromJson(Map json) {
    return BundlePackage(
      name: json['name'],
      numberOfServices: json['number_of_service'],
      price: json['price'],
      type: json['plan_type'],
    );
  }
}
