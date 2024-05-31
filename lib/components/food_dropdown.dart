/*import 'dart:io';
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
    'Noddles',
    '500g Spaghetti',
    'Crate Of Eggs',
    'Garri',
    'Noodles',
    'Kilo of Fish'
  ];
  final Map<String, List<String>?> foodSubTypes = {
    'Bag of Rice': ['Foreign', 'Imported'],
    'Bag of Beans': ['Olutu', 'Plebe', 'White', 'oloyin'],
    'Plate of Pepper': [
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
    '500g Spaghetti': ['Power Pasta', 'Crown Premium', 'Honywell'],
    'Garri': ['Brown', 'White'],
    'Noodles': [],
    'Kilo of Fish': [
      'Alaran/Sardines',
          'Panla',
          'Express',
          'Shawa/Mackerel',
          'Croaker',
          'Catfish',
          'Bonga',
    ],
    'Basket Of Cassava': null,
  };

  String? selectedFoodItem;
  String? selectedSubtype;
  String? customSubtype;
  TextEditingController priceController = TextEditingController();
  FocusNode priceFocusNode = FocusNode();

  void _notifyParent() {
    widget.onFoodDataChanged({
      'foodItem': selectedFoodItem ?? '',
      'subtype': selectedSubtype ?? customSubtype ?? '',
      'price': priceController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: const Color.fromRGBO(76, 194, 201, 1), width: 1)),
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
                  SizedBox(height: 5),
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
                });
                _notifyParent();
              },
            ),
          ),
        ),
        const SizedBox(height:5),
        if (selectedFoodItem != null) buildSubtypeOrBrandDropdown(),
        const SizedBox(height:5),
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
                  style: const TextStyle(
                      color: Color.fromRGBO(76, 194, 201, 1),
                      fontSize: Sizes.iconSize,
                      ),
                ),
              ],
            ),
          ),
          obsecureText: false,
          controller: priceController,
          focusNode: priceFocusNode,
          onChanged: (value) => _notifyParent(),
        ),
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
                    color: const Color.fromRGBO(76, 194, 201, 1), width: 1)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Type",
                      style: TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(184, 184, 184, 1)),
                    ),
                    SizedBox(height: 5),
                    Text("Select Type",
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
                  _notifyParent();
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                  hintText: "Custom Type",
                  hintStyle:
                      const TextStyle(color: Color.fromRGBO(184, 184, 184, 1)),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                ),
                onChanged: (value) {
                  customSubtype = value;
                  _notifyParent();
                },
              ),
            ),
        ],
      );
    }
  }
}*/
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
    'Noddles',
    '500g Spaghetti',
    'Crate Of Eggs',
    'Garri',
    'Noodles',
    'Kilo of Fish',
    'Bunch of Plantain',		
'Bunch of Banana',	
'Piece of Apple Fruit',		
'Piece of Orange Fruit',	
'Piece of Watermelon Fruit',		
'Piece of Pineapple Fruit',		
'Usual Plastic Congo of Wheat',		
'Usual Plastic Congo of Elubo',				
'Usual Plastic Congo of Grains',		
'Usual Plastic Congo of Melon',		
'Kilo of Meat',		
'Bunch of Vegetables',
//'Usual Plastic Congo of Elubo'
  ];

  final Map<String, List<String>?> foodSubTypes = {
    'Bag of Rice': ['Foreign', 'Imported'],
    'Bag of Beans': ['Olutu', 'Plebe', 'White', 'Oloyin'],
    'Plate of Pepper': ['Rodo', 'Tatase', 'Sombo/Bawa', 'Bell/Sweet', 'Alligator', 'Black', 'White', 'Habanero'],
    'Tuber Of Yam': ['Water Yam', 'Dry Yam', 'White Guinea Yam'],
    '500g Spaghetti': ['Power Pasta', 'Crown Premium', 'Honeywell'],
    'Garri': ['Brown', 'White'],
    'Noodles':['Mimee',	'Golden Penny','Supreme','Cherrie','Tummy Tummy','Bestie','Jolly Jolly','Master','Honeywell'],
    'Kilo of Fish': ['Alaran/Sardines', 'Panla', 'Express', 'Shawa/Mackerel', 'Croaker', 'Catfish', 'Bonga'],
    'Crate Of Eggs':['Small','Big','Medium'],
    //'Usual Plastic Congo of Elubo':['green','yellow']
  };

  final Map<String, List<String>?> foodBrands = {
    'Bag of Rice': ['Mama Gold', 'Royal Stallion', 'Caprice'],
    'Bag of Beans': null,
    'Plate of Pepper': null,
    'Tuber Of Yam': null,
    '500g Spaghetti': ['Dangote', 'Golden Penny', 'Honeywell'],
    'Garri': null,
    'Noodles':null,
    'Kilo of Fish': null,
  };

  final Map<String, List<String>?> foodWeights = {
    'Bag of Rice': null,
    'Bag of Beans':null,
    'Plate of Pepper': null,
    'Tuber Of Yam': ['Small', 'Medium', 'Large'],
    '500g Spaghetti': null,
    'Garri': null,
    'Noodles': ['70g', '100g','120g','200g','210g'],
    //'Kilo of Fish': ['1kg', '2kg'],
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
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
        const SizedBox(height: 5),
        if (selectedFoodItem != null) buildSubtypeOrBrandDropdown(),
        if (selectedFoodItem != null && foodBrands[selectedFoodItem] != null) buildBrandDropdown(),
        if (selectedFoodItem != null && foodWeights[selectedFoodItem] != null) buildWeightDropdown(),
        const SizedBox(height: 5),
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
          onChanged: (value) => _notifyParent(), labelText: 'Price',
        ),
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
              border: Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type", style: TextStyle(fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1))),
                    SizedBox(height: 5),
                    Text("Select Type", style: TextStyle(fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1))),
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
                  _notifyParent();
                },
              ),
            ),
          ),
          const SizedBox(height: 5),
          if (selectedSubtype == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(76, 194, 201, 1)),
                  ),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Custom Type",
                  hintStyle: const TextStyle(color: Color.fromRGBO(184, 184, 184, 1)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                ),
                onChanged: (value) {
                  customSubtype = value;
                  _notifyParent();
                },
              ),
            ),
            const SizedBox(height: 5),
        ],
      );
    }
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
            mainAxisAlignment: MainAxisAlignment.start,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Weight", style: TextStyle(fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1))),
              SizedBox(height: 5),
              Text("Select Weight", style: TextStyle(fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1))),
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

/*import 'dart:io';
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
    'Noodles',
    '500g Spaghetti',
    'Crate Of Eggs',
    'Garri',
    'Kilo of Fish'
  ];

  final Map<String, List<String>?> foodSubTypes = {
    'Bag of Rice': ['Foreign', 'Imported'],
    'Bag of Beans': ['Olutu', 'Plebe', 'White', 'Oloyin'],
    'Plate of Pepper': [
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
    '500g Spaghetti': ['Power Pasta', 'Crown Premium', 'Honeywell'],
    'Garri': ['Brown', 'White'],
    'Noodles': null,
    'Kilo of Fish': [
      'Alaran/Sardines',
      'Panla',
      'Express',
      'Shawa/Mackerel',
      'Croaker',
      'Catfish',
      'Bonga',
    ],
  };

  final Map<String, List<String>?> foodBrands = {
    'Bag of Rice': ['Mama Gold', 'Royal Stallion', 'Caprice'],
    'Bag of Beans': null,
    'Plate of Pepper': null,
    'Tuber Of Yam': null,
    '500g Spaghetti': ['Dangote', 'Golden Penny', 'Honeywell'],
    'Garri': null,
    'Noodles': ['Indomie', 'Minimie', 'Golden Penny'],
    'Kilo of Fish': null,
  };

  final Map<String, List<String>?> foodWeights = {
    'Bag of Rice': ['25kg', '50kg'],
    'Bag of Beans': ['5kg', '10kg', '25kg'],
    'Plate of Pepper': null,
    'Tuber Of Yam': ['Small', 'Medium', 'Large'],
    '500g Spaghetti': null,
    'Garri': ['1kg', '2kg'],
    'Noodles': ['70g', '100g'],
    'Kilo of Fish': ['1kg', '2kg'],
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
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: const Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
        const SizedBox(height: 5),
        if (selectedFoodItem != null) ...[
          buildSubtypeOrBrandDropdown(),
          if (foodBrands[selectedFoodItem] != null) ...[
            const SizedBox(height: 5),
            buildBrandDropdown(),
          ],
          if (foodWeights[selectedFoodItem] != null) ...[
            const SizedBox(height: 5),
            buildWeightDropdown(),
          ],
        ],
        const SizedBox(height: 5),
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
          onChanged: (value) => _notifyParent(), labelText: 'Price',
        ),
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
              border: Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type", style: TextStyle(fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1))),
                    SizedBox(height: 5),
                    Text("Select Type", style: TextStyle(fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1))),
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
                  _notifyParent();
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (selectedSubtype == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(76, 194, 201, 1)),
                  ),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  hintText: "Custom Type",
                  hintStyle: const TextStyle(color: Color.fromRGBO(184, 184, 184, 1)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                ),
                onChanged: (value) {
                  customSubtype = value;
                  _notifyParent();
                },
              ),
            ),
        ],
      );
    }
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
            mainAxisAlignment: MainAxisAlignment.start,
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Weight", style: TextStyle(fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1))),
              SizedBox(height: 5),
              Text("Select Weight", style: TextStyle(fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1))),
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
}*/

