import 'package:flutter/material.dart';
import 'package:pricesense/model/food_item_model.dart';
import 'package:pricesense/utils/fetch_food_data.dart';
import 'package:pricesense/utils/sizes.dart';

class FoodDropdown extends StatefulWidget {
  final Function(Map<String, String>) onFoodDataChanged;

  const FoodDropdown({required this.onFoodDataChanged});

  @override
  _FoodDropdownState createState() => _FoodDropdownState();
}

class _FoodDropdownState extends State<FoodDropdown> {
  List<FoodItem> foodItems = [];
  bool isLoading = true;

  String? selectedFoodItem;
  String? selectedBrand;
  String? selectedMeasurement;
  String? foodid;

  @override
  void initState() {
    super.initState();
    getData();
  }

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
    fetchFoodItems().then((items) {
      setState(() {
        foodItems = items;
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

  void _notifyParent() {
    widget.onFoodDataChanged({
      'foodItem': selectedFoodItem ?? '',
      'brand': selectedBrand ?? '',
      'measurement': selectedMeasurement ?? '',
      'foodid': foodid ?? '',
    });
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
                color: Color.fromRGBO(76, 194, 201, 1),
              )),
          SizedBox(
            width: 10,
          ),
          Text("Loading Food Items")
        ],
      ));
    }
    return foodItems.isEmpty
        ? Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No Food Items Available'),
              TextButton(
                  onPressed: refresh,
                  child: const Text("Refresh",
                      style: TextStyle(
                          color: Color.fromRGBO(
                        76,
                        194,
                        201,
                        1,
                      ))))
            ],
          ))
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFoodItemDropdown(),
              if (selectedFoodItem != null)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    buildBrandDropdown(),
                    const SizedBox(height: 8),
                    buildMeasurementDropdown(),
                  ],
                ),
            ],
          );
  }

  Widget buildFoodItemDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Food Items',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1)),
              ),
              SizedBox(
                height: 5,
              ),
              Text('Select Food Items',
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1)))
            ],
          ),
          isExpanded: true,
          value: selectedFoodItem,
            iconSize: Sizes.iconSize,
                icon: selectedFoodItem != null
                    ? Icon(
                        Icons.done,
                        color: Colors.green.shade200,
                      )
                    : Icon(Icons.arrow_drop_down, color: Colors.black),
          items: foodItems.map((FoodItem foodItem) {
            return DropdownMenuItem<String>(
              value: foodItem.name,
              child: Text(foodItem.name),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedFoodItem = newValue;
              selectedBrand = null;
              selectedMeasurement = null;
              foodid = foodItems.firstWhere((item) => item.name == newValue).id;
            });
            _notifyParent();
            print(foodid);
          },
        ),
      ),
    );
  }

  Widget buildBrandDropdown() {
    List<String> brands =
        foodItems.firstWhere((item) => item.name == selectedFoodItem).brand;
    List<String> empty = ['No Brands Availiable'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Brands/Types',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1)),
              ),
              SizedBox(
                height: 5,
              ),
              Text('Select Brands/Types',
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1)))
            ],
          ),
          isExpanded: true,
          value: selectedBrand,
            iconSize: Sizes.iconSize,
                icon: selectedBrand != null
                    ? Icon(
                        Icons.done,
                        color: Colors.green.shade200,
                      )
                    : Icon(Icons.arrow_drop_down, color: Colors.black),
          items: brands.isEmpty
              ? empty.map((String brand) {
                  return DropdownMenuItem<String>(
                    value: brand,
                    child: Text(brand),
                  );
                }).toList()
              : brands.map((String brand) {
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

  Widget buildMeasurementDropdown() {
    List<String> measurements = foodItems
        .firstWhere((item) => item.name == selectedFoodItem)
        .measurement;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: const Color.fromRGBO(76, 194, 201, 1), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Measurement',
                style: TextStyle(
                    fontSize: 12, color: Color.fromRGBO(184, 184, 184, 1)),
              ),
              SizedBox(
                height: 5,
              ),
              Text('Select Measurement',
                  style: TextStyle(
                      fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1)))
            ],
          ),
          isExpanded: true,
          value: selectedMeasurement,
            iconSize: Sizes.iconSize,
                icon: selectedMeasurement != null
                    ? Icon(
                        Icons.done,
                        color: Colors.green.shade200,
                      )
                    : Icon(Icons.arrow_drop_down, color: Colors.black),
          items: measurements.map((String measurement) {
            return DropdownMenuItem<String>(
              value: measurement,
              child: Text(measurement),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedMeasurement = newValue;
            });
            _notifyParent();
          },
        ),
      ),
    );
  }
}
