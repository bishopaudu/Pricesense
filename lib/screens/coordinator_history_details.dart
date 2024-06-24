import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/model/coordinator_history_model.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/utils/capitalize.dart';
import 'package:pricesense/utils/colors.dart';

class CoordinatorDetailsScreen extends ConsumerWidget {
  final EnergyHistory coordhistoryItem;

  const CoordinatorDetailsScreen ({super.key, required this.coordhistoryItem});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internetStatus = ref.watch(connectivityProvider);
    final formatter = NumberFormat('#,##0');

    Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? Capitalize.capitalizeFirstLetter(coordhistoryItem.city.name)
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
                    _buildSummaryItem(
                "City", '${coordhistoryItem.city.name}'),
                     _buildSummaryItem(
                "Coordinator", '${coordhistoryItem.coordinator.firstname} ${coordhistoryItem.coordinator.lastname}'),
                      _buildSummaryItem(
                "Exchange Rate (Naira/USD)", coordhistoryItem.unofficialUsdExchangeRate.toString()),
            _buildSummaryItem(
                "Energy Cost - 1 Litre of Petrol (An Independent Marketer)",
                coordhistoryItem.litreOfPetrolIndependent.toString()),
            _buildSummaryItem("Energy Cost - 1 Litre of Petrol (NNPC Station)",
                coordhistoryItem.litreOfPetrolNnpc.toString()),
            _buildSummaryItem(
                "Energy Cost - 1 Litre of Diesel (An Independent Marketer)",
                coordhistoryItem.litreOfDieselIndependent.toString(),),
            _buildSummaryItem("Energy Cost - 1 Litre of Diesel (NNPC Station)",
                coordhistoryItem.litreOfDieselNnpc.toString()),
                   _buildSummaryItem('Date:',
                        DateFormat('yyyy-MM-dd').format(coordhistoryItem.date)),
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
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
