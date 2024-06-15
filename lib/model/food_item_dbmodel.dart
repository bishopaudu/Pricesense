class FoodItemDbModel {
  final int? id;
  final String marketid;
  final String foodId;
  final String distributionType;
  final String brand;
  final String measurement;
  final String userId;
  final int price;
  final String location;
  final String foodname;
  final int shoprent;
  final int taxandLevies;

  FoodItemDbModel(
      {this.id,
      required this.marketid,
      required this.foodId,
      required this.distributionType,
      required this.brand,
      required this.measurement,
      required this.userId,
      required this.price,
      required this.location,
      required this.foodname,
      required this.shoprent,
      required this.taxandLevies
      });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marketid': marketid,
      'foodId': foodId,
      'distributionType': distributionType,
      'brand': brand,
      'measurement': measurement,
      'userId': userId,
      'price': price,
      'location': location,
      'foodname': foodname,
      'shoprent':shoprent,
      'taxandLevies':taxandLevies
    };
  }

  factory FoodItemDbModel.fromMap(Map<String, dynamic> map) {
    return FoodItemDbModel(
      id: map['id'],
      marketid: map['marketid'],
      foodId: map['foodId'],
      distributionType: map['distributionType'],
      brand: map['brand'],
      measurement: map['measurement'],
      userId: map['userId'],
      price: map['price'],
      location: map['location'],
      foodname: map['foodname'],
      shoprent: map['shoprent'],
      taxandLevies: map['taxandLevies'],
    );
  }
}
