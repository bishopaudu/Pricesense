import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/agent_history_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoryService {
  
  Future<HistoryResponse> fetchHistory(String token) async {
    final response = await http.get(
      Uri.parse('https://priceintel.vercel.app/data/market/history'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return HistoryResponse.fromJson(json);
    } else {
       print('Failed to load history. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to load history');
    }
  }
}

final historyProvider = Provider<HistoryService>((ref) => HistoryService());
