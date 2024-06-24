
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pricesense/model/grid_data_model.dart';
import 'package:pricesense/providers/userproviders.dart';

// Define your provider
final gridDataProvider = FutureProvider<GridData>((ref) async {
  final user = ref.read(userProvider);
 final response = await http.get(Uri.parse('https://priceintel.vercel.app/user/analytics'), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${user!.token}',
  });

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return GridData.fromJson(json['data']); 
  } else {
    throw Exception('Failed to load grid data');
  }
});


