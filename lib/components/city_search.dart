// ignore_for_file: must_be_immutable
/*import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pricesense/utils/data.dart';
import 'package:pricesense/utils/sizes.dart';

class CitySeacrh extends StatefulWidget {
  CitySeacrh({super.key, required this.cityController,required this.selectedCity});
  TextEditingController cityController = TextEditingController();
  String? selectedCity;
  

  @override
  State<CitySeacrh> createState() => _CitySeacrhState();
}

class _CitySeacrhState extends State<CitySeacrh> {
  static List<String> getSuggestions(String query) {
    List<String> allCities =
        Data.citiesInNigeria.values.expand((cities) => cities).toList();
    return allCities
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
           decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color.fromRGBO(76, 194, 201, 1), width: 1)),
          child: TypeAheadFormField(
            suggestionsBoxDecoration: SuggestionsBoxDecoration(
              color:Colors.white,
              scrollbarThumbAlwaysVisible: true,
              scrollbarTrackAlwaysVisible: false,
               elevation: 4.0,
              borderRadius: BorderRadius.circular(8),
            ),
            hideKeyboardOnDrag: false,
            hideKeyboard: false,
            textFieldConfiguration: TextFieldConfiguration(
              controller: widget.cityController,
              decoration: InputDecoration(
                icon:const Icon(Icons.location_city,size: Sizes.iconSize,color: Color.fromRGBO(76, 194, 201, 1)),
               contentPadding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                 enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              
                hintText:'Enter City' ,
                fillColor: Colors.grey.shade100,
                filled: true,
                 hintStyle: const TextStyle(color: Color.fromRGBO(184, 184, 184, 1)),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)
                ),
                 focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color.fromRGBO(76, 194, 201, 1))),
                
              ),
              
            ),
            suggestionsCallback: (pattern) {
              return getSuggestions(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion as String),
              );
            },
            onSuggestionSelected: (suggestion) {
              widget.cityController.text = suggestion as String;
              setState(() {
                widget.selectedCity = suggestion;
              });
            },
            noItemsFoundBuilder: (context) {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No city found'),
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
          ),
        ),
      ),
    );
  }
}*/

