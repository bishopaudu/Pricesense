import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/model/history_model.dart';
import 'package:pricesense/utils/capitalize.dart';
import 'package:pricesense/utils/colors.dart';

class DetailsScreen extends StatelessWidget {
  final HistoryItem historyItem;

  const DetailsScreen({super.key, required this.historyItem});

  @override
  Widget build(BuildContext context) {
       Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");
    return Scaffold(
      appBar: AppBar(
        title: Text(Capitalize.capitalizeFirstLetter(historyItem.foodItem.name),style: const TextStyle(color: Colors.white),),
        backgroundColor: mainColor,
        centerTitle: true,
           iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryItem('Market:', historyItem.market.name),
              _buildSummaryItem('Brand/Types', '${Capitalize.capitalizeFirstLetter(historyItem.brand)}'),
              _buildSummaryItem("Measurement", historyItem.measurement),
              _buildSummaryItem('Price:', '${format.currencySymbol}${historyItem.price}'),
              _buildSummaryItem('Price Informant:', '${historyItem.user.firstname} ${historyItem.user.lastname}'),
             _buildSummaryItem('Distribution Type:',historyItem.distributionType),
              _buildSummaryItem('Date:',DateFormat('yyyy-MM-dd').format(historyItem.date)),
                 ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor:mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                  },
                  child: const Text(
                    'Remarks',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
            ],
          ),
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

