class FoodItem {
  final String id;
  final String name;
  final List<String> brand;
  final List<String> measurement;

  FoodItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.measurement,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
      brand: List<String>.from(json['brand'] ?? []),
      measurement: List<String>.from(json['measurement'] ?? []),
    );
  }
}
