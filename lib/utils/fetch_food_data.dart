import 'package:pricesense/model/food_item_model.dart';
import 'package:pricesense/utils/database_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<FoodItem>> fetchFoodItems() async {
  final dbHelper = DatabaseHelper();

  try {
    final response = await http.get(Uri.parse('https://priceintel.vercel.app/food'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<FoodItem> foodItems = data.map((item) => FoodItem.fromJson(item)).toList();    
      // Clear old data and insert new data into the database
      await dbHelper.deleteFoodItems();
      for (var item in foodItems) {
        await dbHelper.insertFoodItem(item);
      }
      
      return foodItems;
    } else {
      throw Exception('Failed to load food items');
    }
  } catch (e) {
    // If there is an error, try to fetch data from the database
    return await dbHelper.getFoodItems();
  }
}


