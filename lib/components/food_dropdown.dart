// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/components/text_input.dart';

class FoodDropdown extends StatefulWidget {
  @override
  _FoodDropdown createState() => _FoodDropdown();
}

class _FoodDropdown extends State<FoodDropdown> {
  List<String> foodItems = [
    'Bag OF Rice',
    'Ball Pepper',
    'Bag Of Beans',
    'Tuber Of Yam',
    'Noddles',
    'Spaghetti',
    'Crate Of Eggs',
    'Garri',
    'Noodles',
  ];
  final Map<String, List<String>?> foodSubTypes = {
    'Bag OF Rice': ['Foreign', 'Imported'],
    'Ball Pepper': ['Olutu', 'Plebe', 'White'],
    'Bag Of Beans': [
      'Rodo',
      'Tatase',
      'Sombo/Bawa',
      'Bell/Sweet',
      'Alligator',
      'Black',
      'White',
      'Habanero'
    ],
    'Tuber Of Yam': ['Water Yam', 'Dry Yam', 'White Guinea Yam'],
    'Garri': ['Brown', 'White'],
    'Noodles':["Golden Penny",'Mimee',"Jolly","Supreme",'Honywell'],
    'Basket Of Cassava': null,
  };

  String? selectedFoodItem;
  String? selectedSubtype;
  String? customSubtype;
  String? customBrand;
  TextEditingController priceController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    var format  = NumberFormat.simpleCurrency(locale:Platform.localeName,name:"NGN");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: const Color.fromRGBO(
                    76,
                    194,
                    201,
                    1,
                  ),
                  width: 1)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select FoodItems",
                    style: TextStyle(
                        fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1)),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text("Food Items",
                      style: TextStyle(
                          fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1)))
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
                  customSubtype = null;
                  customBrand = null;
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 20),
        if (selectedFoodItem != null) buildSubtypeOrBrandDropdown(),
        const SizedBox(height: 20),
        TextInput(
            textInputType: TextInputType.name,
            text: "Price",
            widget:Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(format.currencySymbol,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
            obsecureText: false,
            controller: priceController),
        const SizedBox(height: 20),
        if (selectedFoodItem == 'Noodles' && customBrand == null)
          buildBrandDropdown(),
        if (selectedFoodItem == 'Noodles' && customBrand != null)
          TextField(
            decoration: const InputDecoration(
              labelText: 'Custom Brand',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              customBrand = value;
            },
          ),
        const SizedBox(height: 20),
        /* ElevatedButton(
          onPressed: () {
            // Handle form submission
            print('Selected Food Item: $selectedFoodItem');
            print('Selected Subtype: $selectedSubtype');
            print('Custom Subtype: $customSubtype');
            print('Price: ${priceController.text}');
            if (selectedFoodItem == 'Noodles') {
              print('Custom Brand: $customBrand');
            }
          },
          child: const Text('Submit'),
        ),*/
      ],
    );
  }

  Widget buildSubtypeOrBrandDropdown() {
    if (foodSubTypes[selectedFoodItem] == null) {
      return const SizedBox.shrink();
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color.fromRGBO(
                      76,
                      194,
                      201,
                      1,
                    ),
                    width: 1)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SubType",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(184, 184, 184, 1)),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text("Select SubType",
                        style: TextStyle(
                            fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1)))
                  ],
                ),
                isExpanded: true,
                value: selectedSubtype,
                items: foodSubTypes[selectedFoodItem]!.map((String subtype) {
                  return DropdownMenuItem<String>(
                    value: subtype,
                    child: Text(subtype),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubtype = newValue;
                    customSubtype = null;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (selectedSubtype == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromRGBO(76, 194, 201, 1)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Custom SubType",
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(184, 184, 184, 1)),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                ),
                onChanged: (value) {
                  customSubtype = value;
                },
              ),
            ),
        ],
      );
    }
  }

  Widget buildBrandDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select Brand', style: TextStyle(fontSize: 16)),
        TypeAheadField<String>(
          textFieldConfiguration: const TextFieldConfiguration(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select Brand',
            ),
          ),
          suggestionsCallback: (pattern) {
            return foodSubTypes[selectedFoodItem]!
                .where((brand) =>
                    brand.toLowerCase().contains(pattern.toLowerCase()))
                .toList();
          },
          itemBuilder: (context, String suggestion) {
            return ListTile(
              title: Text(suggestion),
            );
          },
          onSuggestionSelected: (String suggestion) {
            setState(() {
              customBrand = suggestion;
            });
          },
          noItemsFoundBuilder: (context) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No brands found', style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Custom Brand',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            customBrand = value;
          },
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FoodDropdown(),
  ));
}
