// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:pricesense/model/markets.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/fetch_market_data.dart';
import 'package:pricesense/utils/sizes.dart';

class MarketDropdown extends StatefulWidget {
  final String userCity;
  final Function(String) onMarketSelected;

  const MarketDropdown(
      {required this.userCity, required this.onMarketSelected});

  @override
  _MarketDropdownState createState() => _MarketDropdownState();
}

class _MarketDropdownState extends State<MarketDropdown> {
  List<City> cities = [];
  bool isLoading = true;
  String? selectedMarket;

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getData() async {
    fetchCities().then((fetchedCities) {
      setState(() {
        cities = fetchedCities;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching cities: $error");
      showErrorDialog(error);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  void refresh() {
    setState(() {
      isLoading = true;
    });
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: mainColor
              )),
          SizedBox(
            width: 10,
          ),
          Text("Loading Markets")
        ],
      ));
    }

    City? userCity = cities.firstWhere((city) => city.name == widget.userCity,
        orElse: () => City(id: '', name: '', markets: []));

    // ignore: unnecessary_null_comparison
    return userCity == null || userCity.markets.isEmpty
        ? Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No markets available for your city'),
              TextButton(
                  onPressed: refresh,
                  child: const Text("Refresh",
                      style: TextStyle(
                         color:mainColor)))
            ],
          ))
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color:mainColor,
                    width: 1)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Markets',
                      style: TextStyle(
                          fontSize: 12,
                          color: mainColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Select Market',
                        style: TextStyle(
                            fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1)))
                  ],
                ),
                value: selectedMarket,
                isExpanded: true,
                iconSize: Sizes.iconSize,
                icon:Icon(Icons.arrow_drop_down, color: Colors.black),
                items: userCity.markets.map((Market market) {
                  return DropdownMenuItem<String>(
                    value: market.id,
                    child: Text(market.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedMarket = newValue;
                  });
                  widget.onMarketSelected(newValue ?? '');
                },
              ),
            ),
          );
  }
}
