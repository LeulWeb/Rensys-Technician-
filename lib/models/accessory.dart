class Accessory {
  Accessory({
    required this.id,
    required this.name,
    required this.description,
    required this.images,
  });


  final String id;
  final String name;
  final String description;
  String images;



  static Accessory fromMap(Map map)=> Accessory(
    id: map["id"],
    name: map["name"],
    description: map["description"],
    images: map["images"],
  );
}
