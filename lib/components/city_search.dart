// ignore_for_file: must_be_immutable
/*import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pricesense/utils/data.dart';
//import 'package:pricesense/utils/sizes.dart';

class CitySearch extends StatefulWidget {
  CitySearch({super.key, required this.cityController,required this.selectedCity});
  TextEditingController cityController = TextEditingController();
  String? selectedCity;
  

  @override
  State<CitySearch> createState() => _CitySearchState();
}

class _CitySearchState extends State<CitySearch> {
  static List<String> getSuggestions(String query) {
    List<String> allCities = Data.states.toList();
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
               // icon:const Icon(Icons.location_city,size: Sizes.iconSize,color: Color.fromRGBO(76, 194, 201, 1)),
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
                    borderSide: BorderSide(color: Colors.white,
                    )),
                
              ),
              
            ),
            suggestionsCallback: (pattern) {
              return getSuggestions(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion),
              );
            },
            onSuggestionSelected: (suggestion) {
              widget.cityController.text = suggestion;
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
 /* ListView.builder(
                  physics: NeverScrollableScrollPhysics(), // Disable list view scrolling
                  shrinkWrap: true, // Ensure the list view takes only necessary space
                  itemCount: Data.surveyHistory.length,
                  itemBuilder: (context, index) {
                    final item = Data.surveyHistory[index];
                    return/* Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade200,
                          child: Text(
                            item['title']!.substring(0, 1),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(item['title']!),
                        subtitle: Text(item['subtitle']!),
                        trailing: Text(item['date']!),
                        onTap: () {
                          // Handle item tap
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Details()));
                        },
                      ),
                    );*/
                  },
                ),*/

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pricesense/utils/sizes.dart';
import 'package:pricesense/providers/connectivity_provider.dart';

class InternetStatus extends ConsumerWidget {
  const InternetStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityResult = ref.watch(connectivityProvider);

    String status;
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      status = "Connected To Server";
    } else {
      status = "No Internet Access";
    }

    return Row(
      children: [
        Icon(
          connectivityResult == ConnectivityResult.none
              ? Icons.signal_wifi_off
              : Icons.signal_wifi_4_bar,
          size: Sizes.iconSize,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: const TextStyle(fontSize: 16, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}


