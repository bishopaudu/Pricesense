// models/history_model.dart
class HistoryResponse {
  final dynamic error;
  final HistoryData data;

  HistoryResponse({required this.error, required this.data});

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      error: json['error'],
      data: HistoryData.fromJson(json['data']),
    );
  }
}

class HistoryData {
  final List<HistoryItem> history;

  HistoryData({required this.history});

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    var list = json['history'] as List;
    List<HistoryItem> historyList =
        list.map((i) => HistoryItem.fromJson(i)).toList();
    return HistoryData(history: historyList);
  }
}

class HistoryItem {
  final String id;
  final Market market;
  final FoodItem foodItem;
  final User user;
  final int price;
  final String distributionType;
  final String brand;
  final String measurement;
  final int taxes;
  final int rent;
  final DateTime date;
  final int v;

  HistoryItem({
    required this.id,
    required this.market,
    required this.foodItem,
    required this.user,
    required this.price,
    required this.distributionType,
    required this.brand,
    required this.measurement,
    required this.taxes,
    required this.rent,
    required this.date,
    required this.v,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['_id'],
      market: Market.fromJson(json['market']),
      foodItem: FoodItem.fromJson(json['food_item']),
      user: User.fromJson(json['user']),
      price: json['price'],
      distributionType: json['distribution_type'],
      brand: json['brand'],
      measurement: json['measurement'],
      taxes:json['taxes'],
      rent:json['rent'],
      date: DateTime.parse(json['date']),
      v: json['__v'],
    );
  }
}

class Market {
  final String name;

  Market({required this.name});

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      name: json['name'],
    );
  }
}

class FoodItem {
  final String name;

  FoodItem({required this.name});

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'],
    );
  }
}

class User {
  final String firstname;
  final String lastname;

  User({required this.firstname, required this.lastname});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }
}
