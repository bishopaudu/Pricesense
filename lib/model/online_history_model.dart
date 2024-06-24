class OnlineStoreResponse {
  final String? error;
  final OnlineItemData data;

  OnlineStoreResponse({this.error, required this.data});

  factory OnlineStoreResponse.fromJson(Map<String, dynamic> json) {
    return OnlineStoreResponse(
      error: json['error'],
      data: OnlineItemData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data.toJson(),
    };
  }
}

class OnlineItemData {
  final String id;
  final String store;
  final String foodItem;
  final String brand;
  final String measurement;
  final String status;
  final DateTime date;
  final String analyst;
  final int v;

  OnlineItemData({
    required this.id,
    required this.store,
    required this.foodItem,
    required this.brand,
    required this.measurement,
    required this.status,
    required this.date,
    required this.analyst,
    required this.v,
  });

  factory OnlineItemData.fromJson(Map<String, dynamic> json) {
    return OnlineItemData(
      id: json['_id'],
      store: json['store'],
      foodItem: json['food_item'],
      brand: json['brand'],
      measurement: json['measurement'],
      status: json['status'],
      date: DateTime.parse(json['date']),
      analyst: json['analyst'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'store': store,
      'food_item': foodItem,
      'brand': brand,
      'measurement': measurement,
      'status': status,
      'date': date.toIso8601String(),
      'analyst': analyst,
      '__v': v,
    };
  }
}
