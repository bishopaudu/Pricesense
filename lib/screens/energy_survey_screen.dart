import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/components/cities_dropdown.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/model/enery_model.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/collection_complete.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/database_service.dart';
import 'package:pricesense/utils/error_dialog.dart';
import 'package:pricesense/utils/grid_data_service.dart';
import 'package:pricesense/utils/sizes.dart';
import 'package:http/http.dart' as http;

class EnergySurveyScreen extends ConsumerStatefulWidget {
  const EnergySurveyScreen({super.key});

  @override
  ConsumerState<EnergySurveyScreen> createState() => _EnergySurveyScreenState();
}

class _EnergySurveyScreenState extends ConsumerState<EnergySurveyScreen> {
  bool isCompleted = false;
  int _currentPage = 0;
  String? coordinatorValue;
  String? cityValue;
  String? cityId;
  String submitText = "Submit";
  bool uploading = false;
  final PageController _pageController = PageController();
  TextEditingController dateController = TextEditingController();
  final FocusNode dateFocusNode = FocusNode();
  final TextEditingController exchangeRateController = TextEditingController();
  final TextEditingController energyCostPerLiterIndependent =
      TextEditingController();
  final TextEditingController energyCostPerLiterNNPC = TextEditingController();
  final TextEditingController energyCostDieselIndependent =
      TextEditingController();
  final TextEditingController energyCostDieselNNPC = TextEditingController();
  FocusNode exchangeRateFocusNode = FocusNode();
  FocusNode energyCostPerLiterIndependentFocusNode = FocusNode();
  FocusNode energyCostPerLiterNNPCFocusNode = FocusNode();
  FocusNode energyCostPerDieselNNPCFocusNode = FocusNode();
  FocusNode energyCostPerDieselIndependentFocusNode = FocusNode();

  Future<DateTime?> selectDate() => showDatePicker(
      context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
  DateTime dateTime = DateTime.now();

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleCitySelected(String selectedCityId) {
    setState(() {
      cityId = selectedCityId;
      //cityValue = selectedCityName;
    });
    print('Selected city ID: $selectedCityId');
    //print('Selected city name: $selectedCityName');
  }

  Future<void> _completeForm() async {
    final db = DatabaseHelper();
    final user = ref.watch(userProvider);
    final connectivityResult = ref.watch(connectivityProvider);
    setState(() {
      submitText = 'Submitting';
      uploading = true;
    });

    try {
      // data to be sent in the POST request
      final data = {
        'city': '$cityId',
        'unofficial_usd_exchange_rate':
            '${int.parse(exchangeRateController.text)}',
        'litre_of_petrol_independent':
            '${int.parse(energyCostPerLiterIndependent.text)}',
        'litre_of_petrol_nnpc': '${int.parse(energyCostPerLiterNNPC.text)}',
        'litre_of_diesel_independent':
            '${int.parse(energyCostDieselIndependent.text)}',
        'litre_of_diesel_nnpc': '${int.parse(energyCostDieselNNPC.text)}',
      };

      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        // Make the POST request
        final response = await http.post(
          Uri.parse('https://priceintel.vercel.app/data/energy/new'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${user!.token}',
          },
          body: json.encode(data),
        );
        if (response.statusCode == 200) {
          setState(() {
            submitText = 'Submitted';
            isCompleted = true;
            uploading = false;
          });
          ref.invalidate(gridDataProvider);
          showSnackBar('Successfully uploaded to server');
          print(response.body);
        } else {
          showSnackBar('Error uploading');
          setState(() {
            uploading = false;
            submitText = 'Submitt';
          });
          print(response.body);
          print(response.statusCode);
        }
      } else {
        final energyData = EnergyModel(
            city: cityId!,
            unofficialusdexchangerate: int.parse(exchangeRateController.text),
            pricepetrolindependent:
                int.parse(energyCostPerLiterIndependent.text),
            pricepetrolnnpc: int.parse(energyCostPerLiterNNPC.text),
            pricedieselindependent: int.parse(energyCostDieselIndependent.text),
            pricedieselnnpc: int.parse(energyCostDieselNNPC.text));
        await db.insertEnergy(energyData);
        setState(() {
          uploading = false;
          isCompleted = true;
        });
        showSnackBar("Not connected to server.Saved locally");
        setState(() {
          uploading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        uploading = false;
      });
      showErrorDialog('error $e', context);
    }
  }

  bool _validatePage1() {
    return dateController.text.isNotEmpty &&
        exchangeRateController.text.isNotEmpty &&
        energyCostPerLiterIndependent.text.isNotEmpty &&
        energyCostPerLiterNNPC.text.isNotEmpty &&
        energyCostDieselIndependent.text.isNotEmpty &&
        energyCostDieselNNPC.text.isNotEmpty;
  }

  void _nextPage() {
    bool canNavigate = false;
    if (_currentPage == 0) {
      canNavigate = _validatePage1();
    }

    if (canNavigate && _currentPage < 1) {
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

  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.watch(connectivityProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back button
        ),
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? 'Energy Price Survey'
              : "No Internet Access",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: internetStatus == ConnectivityResult.mobile ||
                internetStatus == ConnectivityResult.wifi
            ? mainColor
            : Colors.red.shade400,
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
                        value: (_currentPage + 1) / 1,
                        backgroundColor: Colors.grey.shade200,
                        color: mainColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step ${_currentPage + 1} of 2",
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
                      _buildPage1(),
                      _buildSummaryPage(),
                    ],
                  ),
                ),
                _buildNavigationButtons(),
              ],
            ),
    );
  }

  Widget _buildPage1() {
    Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Basic Details",
              style: TextStyle(fontSize: 18, color: mainColor),
            ),
            const SizedBox(height: 16),
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
                    color: mainColor,
                  ),
                  obsecureText: false,
                  controller: dateController,
                  focusNode: dateFocusNode,
                  onChanged: (value) {},
                  labelText: 'Select Date',
                ),
              ),
            ),
            /*const SizedBox(height: 12),
            CustomDropdown(
                onChanged: (value) {
                  setState(() {
                    coordinatorValue = value;
                  });
                },
                dataList: Data.coordinatorsList,
                value: coordinatorValue,
                maintitle: "Coordinator",
                subtitle: "Select Coordinator"),*/
            const SizedBox(height: 12),
            CitiesDropdown(onCitySelected: _handleCitySelected),
            const SizedBox(height: 8),
            TextInput(
                labelText: "Exchange Rate (unofficial)-Naira/USD",
                textInputType: TextInputType.number,
                text: "Exchange Rate (unofficial)",
                widget: const Icon(
                  Icons.currency_exchange,
                  size: Sizes.iconSize,
                  color: mainColor,
                ),
                obsecureText: false,
                controller: exchangeRateController,
                focusNode: exchangeRateFocusNode,
                enabled: true,
                onChanged: (value) {}),
            const SizedBox(height: 8),
            TextInput(
                labelText:
                    "Energy Cost - 1 Litre of Petrol (An Independent Marketer)",
                textInputType: TextInputType.number,
                text:
                    "Energy Cost -1 Litre of Petrol(An Independent Marketer) ",
                widget: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        format.currencySymbol,
                        style: const TextStyle(
                            color: mainColor, fontSize: Sizes.iconSize),
                      ),
                    ],
                  ),
                ),
                obsecureText: false,
                controller: energyCostPerLiterIndependent,
                focusNode: energyCostPerLiterIndependentFocusNode,
                enabled: true,
                onChanged: (value) {}),
            const SizedBox(height: 8),
            TextInput(
                labelText: "Energy Cost - 1 Litre of Petrol (NNPC Station)",
                textInputType: TextInputType.number,
                text: "Energy Cost -1 Litre of Petrol(NNPC Station) ",
                widget: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        format.currencySymbol,
                        style: const TextStyle(
                            color: mainColor, fontSize: Sizes.iconSize),
                      ),
                    ],
                  ),
                ),
                obsecureText: false,
                controller: energyCostPerLiterNNPC,
                focusNode: energyCostPerLiterNNPCFocusNode,
                enabled: true,
                onChanged: (value) {}),
            const SizedBox(height: 8),
            TextInput(
                labelText:
                    "Energy Cost - 1 Litre of Diesel (An Independent Marketer)",
                textInputType: TextInputType.number,
                text:
                    "Energy Cost - 1 Litre of Diesel (An Independent Marketer)",
                widget: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        format.currencySymbol,
                        style: const TextStyle(
                            color: mainColor, fontSize: Sizes.iconSize),
                      ),
                    ],
                  ),
                ),
                obsecureText: false,
                controller: energyCostDieselIndependent,
                focusNode: energyCostPerDieselIndependentFocusNode,
                enabled: true,
                onChanged: (value) {}),
            const SizedBox(height: 8),
            TextInput(
                labelText: "Energy Cost - 1 Litre of Diesel (NNPC Station)",
                textInputType: TextInputType.number,
                text: "Energy Cost - 1 Litre of Diesel (NNPC Station)",
                widget: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        format.currencySymbol,
                        style: const TextStyle(
                            color: mainColor, fontSize: Sizes.iconSize),
                      ),
                    ],
                  ),
                ),
                obsecureText: false,
                controller: energyCostDieselNNPC,
                focusNode: energyCostPerDieselNNPCFocusNode,
                enabled: true,
                onChanged: (value) {}),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == 1;
    return Padding(
      padding: const EdgeInsets.all(16),
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
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
            ),
          if (_currentPage > 0)
            const SizedBox(width: 8.0), // Add space between buttons
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: mainColor,
              ),
              child: ElevatedButton(
                onPressed: isLastPage ? _completeForm : _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
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

  Widget _buildSummaryPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Summary",
              style: TextStyle(fontSize: 24, color: mainColor),
            ),
            const SizedBox(height: 16),
            //_buildSummaryItem("City", cityId ?? ""),
            // _buildSummaryItem("Coordinator", coordinatorValue ?? ""),
            _buildSummaryItem(
                "Exchange Rate (Naira/USD)", exchangeRateController.text),
            _buildSummaryItem("Date Submitted:",
                '${dateTime.year}/${dateTime.month}/${dateTime.day}'),
            _buildSummaryItem(
                "Energy Cost - 1 Litre of Petrol (An Independent Marketer)",
                energyCostPerLiterIndependent.text),
            _buildSummaryItem("Energy Cost - 1 Litre of Petrol (NNPC Station)",
                energyCostPerLiterNNPC.text),
            _buildSummaryItem(
                "Energy Cost - 1 Litre of Diesel (An Independent Marketer)",
                energyCostDieselIndependent.text),
            _buildSummaryItem("Energy Cost - 1 Litre of Diesel (NNPC Station)",
                energyCostDieselNNPC.text),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.visible,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
