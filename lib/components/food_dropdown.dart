import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/utils/sizes.dart';

class FoodDropdown extends StatefulWidget {
  final Function(Map<String, String>) onFoodDataChanged;

  const FoodDropdown({required this.onFoodDataChanged});

  @override
  _FoodDropdownState createState() => _FoodDropdownState();
}

class _FoodDropdownState extends State<FoodDropdown> {
  List<String> foodItems = [
    'Bag of Rice',
    'Plate of Pepper',
    'Bag of Beans',
    'Tuber Of Yam',
  ];

  final Map<String, List<String>?> foodBrands = {
    'Bag of Rice': ['Mama Gold', 'Royal Stallion', 'Caprice'],
    'Bag of Beans': ['Olutu', 'Plebe', 'White', 'Oloyin'],
    'Plate of Pepper': ['Rodo', 'Tatase', 'Sombo/Bawa', 'Bell/Sweet', 'Alligator', 'Black', 'White', 'Habanero'],
    'Tuber Of Yam': ['Water Yam', 'Dry Yam', 'White Guinea Yam'],
  };

  final Map<String, List<String>?> foodWeights = {
    'Bag of Rice': ['1 cup', '1 custard bucker', '1 bag'],
    'Bag of Beans': ['1 cup', '1 custard bucker', '1 bag'],
    'Plate of Pepper': ['1 cup', '1 Basket', 'A basin'],
    'Tuber Of Yam': ['Small', 'Medium', 'Large'],
  };

  String? selectedFoodItem;
  String? selectedSubtype;
  String? selectedBrand;
  String? selectedWeight;
  String? customSubtype;
  TextEditingController priceController = TextEditingController();
  FocusNode priceFocusNode = FocusNode();

  void _notifyParent() {
    widget.onFoodDataChanged({
      'foodItem': selectedFoodItem ?? '',
      'subtype': selectedSubtype ?? customSubtype ?? '',
      'brand': selectedBrand ?? '',
      'weight': selectedWeight ?? '',
      'price': priceController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Select FoodItems", style: TextStyle(fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1))),
                  SizedBox(height: 5),
                  Text("Food Items", style: TextStyle(fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1))),
                ],
              ),
              isExpanded: true,
              value: selectedFoodItem,
              items: foodItems.map((String foodItem) {
                return DropdownMenuItem<String>(
                  value: foodItem,
                  child: Text(foodItem),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedFoodItem = newValue;
                  selectedSubtype = null;
                  selectedBrand = null;
                  selectedWeight = null;
                  customSubtype = null;
                });
                _notifyParent();
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        if (selectedFoodItem != null && foodBrands[selectedFoodItem] != null)
          Column(
            children: [
              buildBrandDropdown(),
              const SizedBox(height: 8), // Added space between brand and weight dropdowns
              buildWeightDropdown(),
            ],
          ),
        const SizedBox(height: 8),
        TextInput(
          textInputType: TextInputType.number,
          text: "Price",
          widget: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  format.currencySymbol,
                  style: const TextStyle(color: Color.fromRGBO(76, 194, 201, 1), fontSize: Sizes.iconSize),
                ),
              ],
            ),
          ),
          obsecureText: false,
          controller: priceController,
          focusNode: priceFocusNode,
          onChanged: (value) => _notifyParent(),
          labelText: 'Price',
        ),
      ],
    );
  }

  Widget buildBrandDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Brand", style: TextStyle(fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1))),
              SizedBox(height: 5),
              Text("Select Brand", style: TextStyle(fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1))),
            ],
          ),
          isExpanded: true,
          value: selectedBrand,
          items: foodBrands[selectedFoodItem]!.map((String brand) {
            return DropdownMenuItem<String>(
              value: brand,
              child: Text(brand),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedBrand = newValue;
            });
            _notifyParent();
          },
        ),
      ),
    );
  }

  Widget buildWeightDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Measurement", style: TextStyle(fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1))),
              SizedBox(height: 5),
              Text("Select Measurement", style: TextStyle(fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1))),
            ],
          ),
          isExpanded: true,
          value: selectedWeight,
          items: foodWeights[selectedFoodItem]!.map((String weight) {
            return DropdownMenuItem<String>(
              value: weight,
              child: Text(weight),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedWeight = newValue;
            });
            _notifyParent();
          },
        ),
      ),
    );
  }
}


