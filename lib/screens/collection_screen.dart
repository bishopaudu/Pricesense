// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print, unnecessary_brace_in_string_interps
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/components/custom_dropdown.dart';
import 'package:pricesense/components/food_dropdown.dart';
import 'package:pricesense/components/market_dropdown.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/model/food_item_dbmodel.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/survey_count_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/collection_complete.dart';
import 'package:pricesense/utils/agent_history_notifier.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/data.dart';
import 'package:pricesense/utils/database_service.dart';
import 'package:pricesense/utils/grid_data_service.dart';
import 'package:pricesense/utils/sizes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isCompleted = false;
  Map<String, String> selectedFoodData = {};

  final TextEditingController priceInformantNameController =
      TextEditingController();
  final TextEditingController brandsController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController taxandLeviesController = TextEditingController();
  final TextEditingController shoprentController = TextEditingController();
  final TextEditingController coordinatorController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  final FocusNode priceInformantFocusNode = FocusNode();
  final FocusNode weightstFocusNode = FocusNode();
  final FocusNode brandsFocusNode = FocusNode();
  final FocusNode dateFocusNode = FocusNode();
  final FocusNode taxandLeviesFocusNode = FocusNode();
  final FocusNode shoprentFocusNode = FocusNode();
  final FocusNode coordinatorFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  FocusNode priceFocusNode = FocusNode();

  String? coordinatorValue;
  String? marketValue;
  String? distributionTypeValue;
  String? collectionType;
  String? cityValue;
  String? city;
  DateTime dateTime = DateTime.now();
  bool dateText = false;
  String submitText = 'Submitting';
  bool uploading = false;

  @override
  void dispose() {
    _pageController.dispose();
    priceInformantNameController.dispose();
    brandsController.dispose();
    shoprentController.dispose();
    taxandLeviesController.dispose();
    coordinatorController.dispose();
    super.dispose();
  }

  void _nextPage() {
    bool canNavigate = false;
    if (_currentPage == 0) {
      canNavigate = _validatePage1();
    } else if (_currentPage == 1) {
      canNavigate = _validatePage2();
    }

    if (canNavigate && _currentPage < 2) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please fill all required fields before proceeding.')),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text('Error'),
          content: Container(
            height: 40,
            width: 35,
            child: Center(
                child: Text(
              message,
              style: const TextStyle(fontSize: 16),
            )),
          ),
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

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _completeForm() async {
    final db = DatabaseHelper();
    final user = ref.watch(userProvider);
    //final surveyCount = ref.read(surveyCountProvider.notifier);
    final connectivityResult = ref.watch(connectivityProvider);
    setState(() {
      submitText = 'Submitting';
      uploading = true;
    });

    try {
      // data to be sent in the POST request
      final data = {
        'market': '${marketValue}',
        'food_item': '${selectedFoodData['foodid']}',
        'distribution_type': '${distributionTypeValue}',
        'brand': '${selectedFoodData['brand']}',
        'measurement': '${selectedFoodData['measurement']}',
        'user': '${user!.id}',
        'price': int.parse(priceController.text),
        'location': '${user.city}',
        'taxes':int.parse(taxandLeviesController.text),
        'rent':int.parse(shoprentController.text)
      };

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // Make the POST request
        final response = await http.post(
          Uri.parse('https://priceintel.vercel.app/data/market/new'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user.token}',
          },
          body: json.encode(data),
        );
        if (response.statusCode == 200) {
          setState(() {
            submitText = 'Submitted';
            isCompleted = true;
            uploading = false;
          });
          ref.read(historyNotifierProvider.notifier).fetchHistory();
           ref.invalidate(gridDataProvider);
           showSnackBar('Successfully uploaded to server');
          print(response.body);
        } else {
          showSnackBar('Error uploading');
          uploading = false;
          print(response.body);
          print(response.statusCode);
        }
      } else {
        // data saved to the local database(sqlite)
        final localSurvey = FoodItemDbModel(
          marketid: marketValue ?? "",
          foodId: selectedFoodData['foodid']!,
          distributionType: distributionTypeValue ?? "",
          brand: selectedFoodData['brand']!,
          measurement: selectedFoodData['measurement']!,
          userId: user.id,
          price: int.parse(priceController.text),
          location: user.city,
          foodname: selectedFoodData['foodItem']!,
          shoprent: int.parse(shoprentController.text),
          taxandLevies: int.parse(taxandLeviesController.text)
        );
        await db.insertSurvey(localSurvey); //saving to the database
        ref.read(surveyCountProvider.notifier).refreshSurveyCount();
        setState(() {
          uploading = false;
          isCompleted = true;
        });
        //showErrorDialog('Not Connected To Server.Saved Locally');
        showSnackBar("Not connected to server.Saved locally");
      }
    } catch (e) {
      print(e);
      showErrorDialog('error ${e}');
    }
  }

  Future<DateTime?> selectDate() => showDatePicker(
      context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));

  bool _validatePage1() {
    return marketValue != null && marketValue!.isNotEmpty;
  }

  bool _validatePage2() {
    return distributionTypeValue != null &&
        distributionTypeValue!.isNotEmpty &&
        selectedFoodData['foodItem'] != null &&
        selectedFoodData['foodItem']!.isNotEmpty &&
        selectedFoodData['brand'] != null &&
        selectedFoodData['brand']!.isNotEmpty &&
        selectedFoodData['measurement'] != null &&
        selectedFoodData['measurement']!.isNotEmpty &&
        dateController.text.isNotEmpty &&
        taxandLeviesController.text.isNotEmpty &&
        shoprentController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.watch(connectivityProvider);
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
          color: Colors.white, 
        ),
         backgroundColor: internetStatus == ConnectivityResult.mobile ||
                internetStatus == ConnectivityResult.wifi
            ? mainColor
            : Colors.red.shade400,
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? 'Physical Market Collection'
              : "No Internet Access",style:const TextStyle(color: Colors.white)),
              centerTitle: true,
              ),
      
      body: isCompleted
          ? const CollectionComplete()
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: (_currentPage + 1) / 3,
                        backgroundColor: Colors.grey.shade200,
                        color: mainColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step ${_currentPage + 1} of 3",
                        style: const TextStyle(
                          fontSize: 16,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildPage1(ref),
                      _buildPage2(),
                      _buildSummaryPage(),
                    ],
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
    );
  }

  Widget _buildPage1(WidgetRef ref) {
    final agentDetails = ref.watch(userProvider);
    String prefilledAgentName =
        '${agentDetails!.firstName} ${agentDetails.lastName}';
    String coordinatorName = agentDetails.coordinator;
    String cityName = agentDetails.city;
    priceInformantNameController.text = prefilledAgentName;
    coordinatorController.text = coordinatorName;
    cityController.text = cityName;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Basic Details",
              style: TextStyle(
                  fontSize: 18, color:mainColor),
            ),
            const SizedBox(height: 16),
            TextInput(
              enabled: false,
              focusNode: priceInformantFocusNode,
              text: "Price Informant Name",
              obsecureText: false,
              controller: priceInformantNameController,
              textInputType: TextInputType.name,
              widget: const Icon(
                Icons.person,
                color: mainColor,
                size: Sizes.iconSize,
              ),
              onChanged: (value) {},
              labelText: "Price Informant Name",
            ),
            const SizedBox(height: 8),
            TextInput(
              enabled: false,
              focusNode: coordinatorFocusNode,
              text: "Coordinator Name",
              obsecureText: false,
              controller: coordinatorController,
              textInputType: TextInputType.name,
              widget: const Icon(
                Icons.supervisor_account,
                color:  mainColor,
                size: Sizes.iconSize,
              ),
              onChanged: (value) {},
              labelText: "Coordinator Name",
            ),
            const SizedBox(height: 8),
            TextInput(
              enabled: false,
              focusNode: cityFocusNode,
              text: "City",
              obsecureText: false,
              controller: cityController,
              textInputType: TextInputType.name,
              widget: const Icon(
                Icons.location_city,
                color:  mainColor,
                size: Sizes.iconSize,
              ),
              onChanged: (value) {},
              labelText: "City",
            ),
            const SizedBox(height: 8),
            MarketDropdown(
              userCity: cityName,
              onMarketSelected: (String market) {
                print("Selected Market ID: $market");
                setState(() {
                  marketValue = market;
                });
                print("Selected Market: $marketValue");
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPage2() {
    Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Food Item",
              style: TextStyle(
                  fontSize: 18, color: mainColor),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 10,
            ),
            CustomDropdown(
              dataList: Data.distributionType,
              value: distributionTypeValue,
              maintitle: "Distribution Type",
              subtitle: "Select Distribution Type",
              onChanged: (value) {
                setState(() {
                  distributionTypeValue = value;
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            FoodDropdown(
              onFoodDataChanged: (Map<String, String> foodData) {
                setState(() {
                  selectedFoodData = foodData;
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            TextInput(
              enabled: true,
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
                          color:  mainColor,
                          fontSize: Sizes.iconSize),
                    ),
                  ],
                ),
              ),
              obsecureText: false,
              controller: priceController,
              focusNode: priceFocusNode,
              onChanged: (value) => {},
              labelText: 'Price',
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final date = await selectDate();
                    if (date != null) {
                      setState(() {
                        dateTime = date;
                        dateController.text =
                            '${dateTime.year}/${dateTime.month}/${dateTime.day}';
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextInput(
                      enabled: true,
                      textInputType: TextInputType.none,
                      text: "Select Date",
                      widget: const Icon(
                        Icons.event,
                        size: Sizes.iconSize,
                        color:  mainColor,
                      ),
                      obsecureText: false,
                      controller: dateController,
                      focusNode: dateFocusNode,
                      onChanged: (value) {},
                      labelText: 'Select Date',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextInput(
                    enabled: true,
                    labelText: 'Tax/Levies',
                    textInputType: TextInputType.number,
                    text: 'Tax/Levies',
                    widget: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            format.currencySymbol,
                            style: const TextStyle(
                              color:  mainColor,
                              fontSize: Sizes.iconSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    obsecureText: false,
                    controller: taxandLeviesController,
                    focusNode: taxandLeviesFocusNode,
                    onChanged: (value) {}),
                const SizedBox(
                  height: 8,
                ),
                TextInput(
                    enabled: true,
                    labelText: 'Shop Rent',
                    textInputType: TextInputType.number,
                    text: 'Shop Rent',
                    widget: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            format.currencySymbol,
                            style: const TextStyle(
                              color:  mainColor,
                              fontSize: Sizes.iconSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    obsecureText: false,
                    controller: shoprentController,
                    focusNode: shoprentFocusNode,
                    onChanged: (value) {}),
                const SizedBox(
                  height: 8,
                ),
              
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryPage() {
        //final formatter = NumberFormat('#,##0');
   var format =NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Summary",
              style: TextStyle(
                  fontSize: 24, color:mainColor),
            ),
            const SizedBox(height: 16),
            _buildSummaryItem(
                "Price Informant Name:", priceInformantNameController.text),
            _buildSummaryItem("Coordinator:", coordinatorController.text),
            _buildSummaryItem("City:", cityController.text),
            //  _buildSummaryItem("Market:", marketValue ?? ""),
            _buildSummaryItem(
                "Distribution Type:", distributionTypeValue ?? ""),
            _buildSummaryItem("Food Item:", selectedFoodData['foodItem'] ?? ""),
            _buildSummaryItem("Type:", selectedFoodData['brand'] ?? ""),
            _buildSummaryItem(
                "Measurement:", selectedFoodData['measurement'] ?? ""),
            _buildSummaryItem("Price:", '${format.currencySymbol}${priceController.text}'),
            _buildSummaryItem("Shop Rent:", shoprentController.text),
            _buildSummaryItem("Tax/Levies", taxandLeviesController.text),
            _buildSummaryItem("Date Submitted:",
                '${dateTime.year}/${dateTime.month}/${dateTime.day}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
          Text(value!),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == 2;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: primaryColor,
                    width: 1,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _previousPage,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 4,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text(
                    "Back",
                    style: TextStyle(color:mainColor),
                  ),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 8.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:  mainColor,
              ),
              child: ElevatedButton(
                onPressed: isLastPage ? _completeForm : _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  elevation: 5,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: uploading
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white)),
                          const SizedBox(width: 20),
                          Text(submitText,
                              style: const TextStyle(color: Colors.white)),
                        ],
                      )
                    : Text(
                        isLastPage ? 'Submit' : "Next",
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
