// providers/history_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/agent_history_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pricesense/providers/userproviders.dart';

final historyProvider = FutureProvider<HistoryResponse>((ref) async {
  final user = ref.watch(userProvider);
  final response = await http.get(
          Uri.parse('https://priceintel.vercel.app/data/market/history'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user!.token}',
          },
        );

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return HistoryResponse.fromJson(json);
  } else {
    throw Exception('Failed to load history');
  }
});
