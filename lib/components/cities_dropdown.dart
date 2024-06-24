/*import 'package:flutter/material.dart';
import 'package:pricesense/model/cities.dart';
import 'package:pricesense/utils/cities_service.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/sizes.dart';

class CitiesDropdown extends StatefulWidget {
  final Function(String, String) onCitySelected;
  const CitiesDropdown({Key? key, required this.onCitySelected}) : super(key: key);

  @override
  _CitiesDropdownState createState() => _CitiesDropdownState();
}

class _CitiesDropdownState extends State<CitiesDropdown> {
  List<cityData> _cities = [];
  String? _selectedCityId;
  String? _selectedCityName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndDisplayCities();
  }

  void refresh() {
    setState(() {
      isLoading = true;
    });
    _fetchAndDisplayCities();
  }

  Future<void> _fetchAndDisplayCities() async {
    try {
      List<cityData> cities = await fetchCities();
      setState(() {
        _cities = cities;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching or displaying cities: $e');
      setState(() {
        isLoading = false;
      });
    }
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
              child: CircularProgressIndicator(color: mainColor)),
          SizedBox(
            width: 10,
          ),
          Text("Loading Cities")
        ],
      ));
    }
    return _cities.isEmpty
        ? Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No available city'),
              TextButton(
                  onPressed: refresh,
                  child:
                      const Text("Refresh", style: TextStyle(color: mainColor)))
            ],
          ))
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: mainColor, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cities',
                      style: TextStyle(fontSize: 12, color: mainColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Select Cities',
                        style: TextStyle(
                            fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1)))
                  ],
                ),
                isExpanded: true,
                value: _selectedCityId,
                iconSize: Sizes.iconSize,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                items: _cities.map((cityData city) {
                  return DropdownMenuItem<String>(
                    value: city.id,
                    child: Text(city.name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCityId = newValue;
                    _selectedCityName = _cities
                        .firstWhere((city) => city.id == newValue)
                        .name;
                  });
                  widget.onCitySelected(
                      _selectedCityId ?? '', _selectedCityName ?? '');
                },
              ),
            ),
          );
  }
}*/
import 'package:flutter/material.dart';
import 'package:pricesense/model/cities.dart';
import 'package:pricesense/utils/cities_service.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/sizes.dart';
class CitiesDropdown extends StatefulWidget {
  final Function(String) onCitySelected;
  const CitiesDropdown({required this.onCitySelected});

  @override
  _CitiesDropdownState createState() => _CitiesDropdownState();
}

class _CitiesDropdownState extends State<CitiesDropdown> {
  List<cityData> _cities = [];
 // String? _selectedCityId;
  String? _selectedCityName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndDisplayCities();
  }

  void refresh() {
    setState(() {
      isLoading = true;
    });
    _fetchAndDisplayCities();
  }

  Future<void> _fetchAndDisplayCities() async {
    try {
      List<cityData> cities = await fetchCities();
      setState(() {
        _cities = cities;
        isLoading = false;
        print(cities);
      });
    } catch (e) {
      print('Error fetching or displaying cities: $e');
    }
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
              child: CircularProgressIndicator(color: mainColor)),
          SizedBox(
            width: 10,
          ),
          Text("Loading Cities")
        ],
      ));
    }
    return _cities.isEmpty
        ? Center(
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No available city'),
              TextButton(
                  onPressed: refresh,
                  child:
                      const Text("Refresh", style: TextStyle(color: mainColor)))
            ],
          ))
        : Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: mainColor, width: 1),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cities',
                      style: TextStyle(fontSize: 12, color: mainColor),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Select Cities',
                        style: TextStyle(
                            fontSize: 12, color: Color.fromRGBO(8, 8, 8, 1)))
                  ],
                ),
                isExpanded: true,
                value: _selectedCityName,
                iconSize: Sizes.iconSize,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                items: _cities.map((cityData city) {
                  return DropdownMenuItem<String>(
                    value: city.id,
                    child: Text(city.name),
                  );
                }).toList(),
                onChanged:  (String? newValue) {
                  setState(() {
                  _selectedCityName = newValue;
                  });
                  widget.onCitySelected(newValue ?? '');
                },
              ),
            ),
          );
  }
}


