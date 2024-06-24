import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pricesense/model/analyst_history_model.dart';

class AnalystHistoryService {
  Future<AnalystHistoryResponse> fetchHistory(String token) async {
    final response = await http.get(
      Uri.parse('https://priceintel.vercel.app/data/analyst/history'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      print(response.statusCode);
      print(response.body);
      return AnalystHistoryResponse.fromJson(json);
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception('Failed to load  history');
    }
  }
}

final analystHistoryProvider =
    Provider<AnalystHistoryService>((ref) => AnalystHistoryService());

/*import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pricesense/model/analyst_history_model.dart';



class AnalystHistoryService {
  Future<AnalystHistoryData> fetchHistory(String token) async {
    final response = await http.get(
      Uri.parse('https://priceintel.vercel.app/data/analyst/history'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AnalystHistoryData.fromJson(json['data']);
    } else {
      throw Exception('Failed to load analyst history');
    }
  }
}

final analystHistoryServiceProvider = Provider<AnalystHistoryService>((ref) => AnalystHistoryService());*/


