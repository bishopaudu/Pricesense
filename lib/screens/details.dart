import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/model/agent_history_model.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/screens/review.dart';
import 'package:pricesense/utils/capitalize.dart';
import 'package:pricesense/utils/colors.dart';

class DetailsScreen extends ConsumerWidget {
  final HistoryItem historyItem;

  const DetailsScreen({super.key, required this.historyItem});

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
              ? Capitalize.capitalizeFirstLetter(historyItem.foodItem.name)
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
                    _buildSummaryItem('Market:', historyItem.market.name),
                    // _buildSummaryItem('Brand/Types','${Capitalize.capitalizeFirstLetter(historyItem.brand)}'),
                    if (historyItem.brand != 'No Brands Available') ...[
                      _buildSummaryItem('Brand/Types',
                          '${Capitalize.capitalizeFirstLetter(historyItem.brand)}')
                    ],
                    _buildSummaryItem("Measurement", historyItem.measurement),
                    _buildSummaryItem('Price:',
                        '${format.currencySymbol}${formatter.format(historyItem.price)}'),
                    _buildSummaryItem('Price Informant:',
                        '${historyItem.user.firstname} ${historyItem.user.lastname}'),
                    _buildSummaryItem(
                        'Distribution Type:', historyItem.distributionType),
                    _buildSummaryItem('Shop Rent:',
                        '${format.currencySymbol}${formatter.format(historyItem.rent).toString()}'),
                    _buildSummaryItem('Taxes/Levies:',
                       '${format.currencySymbol} ${formatter.format(historyItem.taxes).toString()}'),
                    _buildSummaryItem('Date:',
                        DateFormat('yyyy-MM-dd').format(historyItem.date)),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RemarksScreen(
                              historyItem: historyItem,
                            )));
              },
              child: const Text(
                'Review',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
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
