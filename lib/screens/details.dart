import 'package:flutter/material.dart';

class Details extends StatefulWidget {
  const Details({super.key});
  

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Summary of Survey",
                  style: TextStyle(
                      fontSize: 24, color: Color.fromRGBO(76, 194, 201, 1)),
                ),
                const SizedBox(height: 16),
                _buildSummaryItem("Price Informant Name:", 'James Udo'),
                _buildSummaryItem("Coordinator:", "Udosen Uko"),
                _buildSummaryItem("Market:", "Gwarinpa Main Market"),
                _buildSummaryItem("Distribution Type:", "Retails"),
                _buildSummaryItem("Food Item:", "Pepper"),
                _buildSummaryItem("Subtype:", "Olutu"),
                _buildSummaryItem("Price:", "100"),
                _buildSummaryItem("Weights", "300g"),
                _buildSummaryItem("Remarks:", "Fair Price"),
                _buildSummaryItem("Status:", "Uploaded to Server"),
              ],
            ),
          ),
        ));
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
              color: Color.fromRGBO(76, 194, 201, 1),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
