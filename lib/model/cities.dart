class cityData {
  final String id;
  final String name;

  cityData({required this.id, required this.name});

  factory cityData.fromJson(Map<String, dynamic> json) {
    return cityData(
      id: json['_id'] ?? "",
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
    };
  }
}
