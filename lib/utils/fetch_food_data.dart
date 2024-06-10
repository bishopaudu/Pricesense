import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pricesense/model/food_item_model.dart';

Future<List<FoodItem>> fetchFoodItems() async {
  final response = await http.get(Uri.parse('https://priceintel.vercel.app/food'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => FoodItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load food items');
  }
}
