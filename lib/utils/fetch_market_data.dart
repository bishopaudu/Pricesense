/*import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pricesense/model/markets.dart';

Future<List<City>> fetchCities() async {
  final response = await http.get(Uri.parse('https://priceintel.vercel.app/cities'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => City.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load cities');
  }
}*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pricesense/model/markets.dart';
import 'package:pricesense/utils/database_service.dart';

Future<List<City>> fetchCities() async {
  final db = DatabaseHelper();

  // First, check if data is available in the cache
  List<City> cachedCities = await db.getCities();
  if (cachedCities.isNotEmpty) {
    print("Loaded cities from cache");
    return cachedCities;
  }

  // If not, fetch from API
  final response = await http.get(Uri.parse('https://priceintel.vercel.app/cities'));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<City> cities = data.map((item) => City.fromJson(item)).toList();

    // Cache the fetched data
    for (var city in cities) {
      await db.insertCity(city);
    }
    print("Fetched and cached cities from API");
    return cities;
  } else {
    throw Exception('Failed to load cities');
  }
}

