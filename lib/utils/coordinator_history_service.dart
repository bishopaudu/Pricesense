
/*import 'package:http/http.dart' as http;
import 'package:pricesense/model/coordinator_history_model.dart';
import 'dart:convert';

class CoordinatorHistoryService {
  Future<EnergyHistoryModel> fetchHistory(String token) async {
    final response = await http.get(
      Uri.parse('https://priceintel.vercel.app/data/energy/history'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      print(' Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      return EnergyHistoryModel.fromJson(json as String);
    } else if (response.statusCode == 401) {
      
      throw Exception('Unauthorized! Please log in again.');
    } else {
      throw Exception('Failed to load coordinator history');
    }
  }
}
*/

import 'package:http/http.dart' as http;
import 'package:pricesense/model/coordinator_history_model.dart';
import 'dart:convert';

class CoordinatorHistoryService {
  Future<EnergyHistoryModel> fetchHistory(String token) async {
    final response = await http.get(
      Uri.parse('https://priceintel.vercel.app/data/energy/history'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return EnergyHistoryModel.fromMap(json);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized! Please log in again.');
    } else {
      throw Exception('Failed to load coordinator history');
    }
  }
}
