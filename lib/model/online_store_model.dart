// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OnlineStoreModel {
  final int? id;
  final String store;
  final String foodItem;
  final int price;
  final String brand;
  final String measurement;

  OnlineStoreModel(
      {this.id,
      required this.store,
      required this.foodItem,
      required this.price,
      required this.brand,
      required this.measurement});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'store': store,
      'foodItem': foodItem,
      'price': price,
      'brand': brand,
      'measurement': measurement,
    };
  }

  factory OnlineStoreModel.fromMap(Map<String, dynamic> map) {
    return OnlineStoreModel(
      id: map['id'] as int,
      store: map['store'] as String,
      foodItem: map['foodItem'] as String,
      price: map['price'] as int,
      brand: map['brand'] as String,
      measurement: map['measurement'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OnlineStoreModel.fromJson(String source) =>
      OnlineStoreModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
