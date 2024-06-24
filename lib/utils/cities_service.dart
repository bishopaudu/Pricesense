import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pricesense/model/cities.dart';
import 'package:pricesense/utils/database_service.dart';

Future<List<cityData>> fetchCities() async {
  final dbHelper = DatabaseHelper();

  try {
    final response = await http
        .get(Uri.parse('https://priceintel.vercel.app/online-market/cities'));
    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> data = json.decode(response.body);
      List<cityData> cities =
          data.map((item) => cityData.fromJson(item)).toList();
      // Clear old data and insert new data into the database
      await dbHelper.deleteCities();
      for (var city in cities) {
        await dbHelper.insertCityData(city);
      }

      return cities;
    } else {
      print('error getting cities');
      throw Exception('Failed to load cities');
    }
  } catch (e) {
    // If there is an error, try to fetch data from the database
    print('cannot fetch cities');
    return await dbHelper.getCity();
  }
}
