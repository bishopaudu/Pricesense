import 'dart:convert';
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
}
