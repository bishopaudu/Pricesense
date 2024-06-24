import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/model/macroeconomics_history.dart';
import 'package:pricesense/model/online_history_model.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/capitalize.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalystDetailsScreen extends ConsumerWidget {
  final String type;
  final String id;

  const AnalystDetailsScreen({super.key, required this.type, required this.id});

  Future<OnlineStoreResponse> fetchOnlineStoreData(String url,String? token) async {
      final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token!}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return OnlineStoreResponse.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load online store data');
    }
  }

  Future<MacroeconomicsHistoryResponse> fetchMacroeconomicsData(
      String url,String? token) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token!}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      return MacroeconomicsHistoryResponse.fromJson(jsonDecode(response.body));
    } else {
      print(response.statusCode);
      print(response.body);
      throw Exception('Failed to load macroeconomics data');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internetStatus = ref.watch(connectivityProvider);
    final formatter = NumberFormat('#,##0');
        final user = ref.watch(userProvider);

    Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");
    String url = 'https://priceintel.vercel.app/data/history/${type}/${id}';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? Capitalize.capitalizeFirstLetter(type)
              : "No Internet Access",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: internetStatus == ConnectivityResult.mobile ||
                internetStatus == ConnectivityResult.wifi
            ? mainColor
            : Colors.red.shade400,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    type == "onlinestore"
                        ? FutureBuilder<OnlineStoreResponse>(
                            future: fetchOnlineStoreData(url,user!.token),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: mainColor,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                var data = snapshot.data!.data;
                                return Column(
                                  children: [
                                    _buildSummaryItem('Store', data.store),
                                    _buildSummaryItem(
                                        'Food Item', data.foodItem),
                                    _buildSummaryItem('Brand', data.brand),
                                    _buildSummaryItem(
                                        'Measurement', data.measurement),
                                    _buildSummaryItem('Status', data.status),
                                    _buildSummaryItem(
                                        'Date',
                                        DateFormat('yyyy-MM-dd')
                                            .format(data.date)),
                                    _buildSummaryItem('Analyst', data.analyst),
                                  ],
                                );
                              } else {
                                return const Center(child: Text('No data found'));
                              }
                            },
                          )
                        : FutureBuilder<MacroeconomicsHistoryResponse>(
                            future: fetchMacroeconomicsData(url,user!.token),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: mainColor,
                                ));
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (snapshot.hasData) {
                                var data = snapshot.data!.data;
                                return Column(
                                  children: [
                                    _buildSummaryItem('Status', data.status),
                                    _buildSummaryItem(
                                        'Date',
                                        DateFormat('yyyy-MM-dd')
                                            .format(data.date)),
                                    _buildSummaryItem('Analyst', data.analyst),
                                  ],
                                );
                              } else {
                                return const Center(child: Text('No data found'));
                              }
                            },
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
