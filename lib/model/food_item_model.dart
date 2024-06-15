import 'dart:convert';

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

    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': jsonEncode(brand),
      'measurement': jsonEncode(measurement),
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'] ?? "",
      name: map['name'] ?? "",
      brand: List<String>.from(jsonDecode(map['brand'] ?? '[]')),
      measurement: List<String>.from(jsonDecode(map['measurement'] ?? '[]')),
    );
  }
}
