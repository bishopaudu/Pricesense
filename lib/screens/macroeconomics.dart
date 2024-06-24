import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/model/macroeconomics_model.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/collection_complete.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/database_service.dart';
import 'package:pricesense/utils/error_dialog.dart';
import 'package:pricesense/utils/grid_data_service.dart';
import 'package:pricesense/utils/sizes.dart';
import 'package:http/http.dart' as http;
import 'package:pricesense/utils/analyst_history_notifier.dart';

class Marcoeconomics extends ConsumerStatefulWidget {
  const Marcoeconomics({super.key});

  @override
  ConsumerState<Marcoeconomics> createState() => _MarcoeconomicsState();
}

class _MarcoeconomicsState extends ConsumerState<Marcoeconomics> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isCompleted = false;
  bool uploading = false;
  String submitText = 'Submit';

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

 Future<void> _completeForm() async {
  final user = ref.watch(userProvider);
  final connectivityResult = ref.watch(connectivityProvider);
  setState(() {
    submitText = 'Submitting';
    uploading = true;
  });

  try {
    int parseValue(String value) {
      try {
        return int.parse(value);
      } catch (e) {
        print('Error parsing value: $value');
        return 0;
      }
    }

    final data = MacroeconomicsModel(
      officialUsdExchangeRate: parseValue(FXController.text),
      monetaryPolicyRate: parseValue(mprController.text),
      minimumDiscountRate: parseValue(mrrController.text),
      interbankCallRate: parseValue(interbankController.text),
      treasuryBillRate: parseValue(treasuryBillController.text),
      savingsDepositRate: parseValue(savingdepositrateController.text),
      primeLendingRate: parseValue(primelendingrateController.text),
      marketCapitalization: parseValue(marketCapController.text),
      allShareIndex: parseValue(allShareIndexController.text),
      turnOverRatio: parseValue(turnoverController.text),
      valueShareTraded: parseValue(valuesharetradedController.text),
      totalListingStocks: parseValue(totallistingstockController.text),
    );

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      final response = await http.post(
        Uri.parse('https://priceintel.vercel.app/data/macroeconomics/new'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user!.token}',
        },
        body: json.encode(data.toMap()),
      );

      if (response.statusCode == 200) {
        setState(() {
          submitText = 'Submitted';
          isCompleted = true;
          uploading = false;
        });
        ref.refresh(analystHistoryNotifierProvider);
         ref.invalidate(gridDataProvider);
        showSnackBar('Successfully uploaded to server');
        print(response.body);
      } else {
        showSnackBar('Error uploading');
        setState(() {
          uploading = false;
        });
        print(response.body);
        print(response.statusCode);
      }
    } else {
      await DatabaseHelper().insertMacroeconomics(data);
      showSnackBar("Not connected to server.Saved locally");
      setState(() {
        uploading = false;
        isCompleted = true;
      });
    }
  } catch (e) {
    print(e);
    setState(() {
      uploading = false;
      submitText = "Submit";
    });
    showErrorDialog('error $e', context);
  }
}

  bool _validatePage1() {
    return dateController.text.isNotEmpty &&
        FXController.text.isNotEmpty &&
        energyController.text.isNotEmpty &&
        deiselController.text.isNotEmpty &&
        mrrController.text.isNotEmpty &&
        interbankController.text.isNotEmpty&&
    treasuryBillController.text.isNotEmpty &&
        savingdepositrateController.text.isNotEmpty &&
        primelendingrateController.text.isNotEmpty &&
        marketCapController.text.isNotEmpty &&
        allShareIndexController.text.isNotEmpty &&
        turnoverController.text.isNotEmpty &&
        valuesharetradedController.text.isNotEmpty &&
        totallistingstockController.text.isNotEmpty;
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

  TextEditingController dateController = TextEditingController();
  TextEditingController FXController = TextEditingController();
  TextEditingController energyController = TextEditingController();
  TextEditingController mprController = TextEditingController();
  TextEditingController deiselController = TextEditingController();
  TextEditingController mrrController = TextEditingController();
  TextEditingController interbankController = TextEditingController();
  TextEditingController treasuryBillController = TextEditingController();
  TextEditingController savingdepositrateController = TextEditingController();
  TextEditingController primelendingrateController = TextEditingController();
  TextEditingController marketCapController = TextEditingController();
  TextEditingController allShareIndexController = TextEditingController();
  TextEditingController turnoverController = TextEditingController();
  TextEditingController valuesharetradedController = TextEditingController();
  TextEditingController totallistingstockController = TextEditingController();

  final FocusNode FXFocusNode = FocusNode();
  final FocusNode energyFocusNode = FocusNode();
  final FocusNode mprFocusNode = FocusNode();
  final FocusNode deiselFocusNode = FocusNode();
  final FocusNode mrrFocusNode = FocusNode();
  final FocusNode interbankFocusNode = FocusNode();
  final FocusNode treasuryBillFocusNode = FocusNode();
  final FocusNode savingdepositrateFocusNode = FocusNode();
  final FocusNode primelendingrateFocusNode = FocusNode();
  final FocusNode marketCapFocusNode = FocusNode();
  final FocusNode allShareIndexFocusNode = FocusNode();
  final FocusNode turnoverFocusNode = FocusNode();
  final FocusNode valuesharetradedFocusNode = FocusNode();
  final FocusNode totallistingstockFocusNode = FocusNode();

  Future<DateTime?> selectDate() => showDatePicker(
      context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
  DateTime dateTime = DateTime.now();
  final FocusNode dateFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.watch(connectivityProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? 'Macroeconomic Variables'
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
            _buildSummaryItem(
                "Daily Foreign Exchange Rate (Naira/USD)", FXController.text),
            _buildSummaryItem("Date Submitted:",
                '${dateTime.year}/${dateTime.month}/${dateTime.day}'),
            _buildSummaryItem(
                "Minimum Rediscount Rate (MRR)", mprController.text),
            _buildSummaryItem("Energy Cost (daily) - 1 Litre of Petrol",
                energyController.text),
            _buildSummaryItem(
                "Minimum Rediscount Rate (MRR)", mrrController.text),
            _buildSummaryItem("Inter-Bank Call Rate", interbankController.text),
            _buildSummaryItem("Energy Cost (daily) - 1 Litre of Diesel",
                deiselController.text),
                _buildSummaryItem("Saving Deposit Rate",
                savingdepositrateController.text),
                _buildSummaryItem("Treasury Bill",
                treasuryBillController.text),
                 _buildSummaryItem("Prime Lending Rate",
                primelendingrateController.text),
                _buildSummaryItem("Market Capitalization",
                 marketCapController.text),
                  _buildSummaryItem("Turn Over",
                 turnoverController.text),
                 _buildSummaryItem("All Share Index",
                 allShareIndexController.text),
                 _buildSummaryItem("Value Share Traded",
                 valuesharetradedController.text),
                 _buildSummaryItem("Total Listing Stock",
                 totallistingstockController.text),
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
          Text(
            title,
            overflow: TextOverflow.clip,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPage1() {
    Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Macroeconomics",
            style: TextStyle(fontSize: 18, color: mainColor),
          ),
          const SizedBox(height: 5),
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
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: FXFocusNode,
            text: "Daily Foreign Exchange Rate (Naira/USD)",
            obsecureText: false,
            controller: FXController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.currency_exchange,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: 'Foreign Exchange Rate',
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: energyFocusNode,
            text: "Energy Cost (daily) - 1 Litre of Petrol",
            obsecureText: false,
            controller: energyController,
            textInputType: TextInputType.number,
            widget: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    format.currencySymbol,
                    style: const TextStyle(
                      color: mainColor,
                      fontSize: Sizes.iconSize,
                    ),
                  ),
                ],
              ),
            ),
            onChanged: (value) {},
            labelText: '1 Litre of Petrol',
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: deiselFocusNode,
            text: "Energy Cost (daily) - 1 Litre of Diesel",
            obsecureText: false,
            controller: deiselController,
            textInputType: TextInputType.number,
            widget: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    format.currencySymbol,
                    style: const TextStyle(
                      color: mainColor,
                      fontSize: Sizes.iconSize,
                    ),
                  ),
                ],
              ),
            ),
            onChanged: (value) {},
            labelText: '1 Litre of Diesel',
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: mprFocusNode,
            text: "Monetary Policy Rate (MPR)",
            obsecureText: false,
            controller: mprController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: 'Monetary Policy Rate(MPR)',
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: mrrFocusNode,
            text: "Minimum Rediscount Rate (MRR)",
            obsecureText: false,
            controller: mrrController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "Minimum Rediscount Rate (MRR)",
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: interbankFocusNode,
            text: "Inter-Bank Call Rate",
            obsecureText: false,
            controller: interbankController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "Inter-Bank Call Rate",
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: primelendingrateFocusNode,
            text: "Prime Lending Rate",
            obsecureText: false,
            controller: primelendingrateController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "Prime Lending Rate",
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: allShareIndexFocusNode,
            text: "All Share Index",
            obsecureText: false,
            controller: allShareIndexController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "All Share Index",
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: marketCapFocusNode,
            text: "Market Capitalization",
            obsecureText: false,
            controller: marketCapController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "Market Capitalization",
          ),
          const SizedBox(
            height: 8,
          ),
           TextInput(
            enabled: true,
            focusNode:valuesharetradedFocusNode,
            text: "Value Share Traded",
            obsecureText: false,
            controller: valuesharetradedController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "Value Share Traded",
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: savingdepositrateFocusNode,
            text: "Savings Deposit Rate",
            obsecureText: false,
            controller: savingdepositrateController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "Savings Deposit Rate",
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: turnoverFocusNode,
            text: "Turn Over Ratio",
            obsecureText: false,
            controller: turnoverController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "Turn Over Ratio",
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: treasuryBillFocusNode,
            text: "Treasury Bill Rate",
            obsecureText: false,
            controller: treasuryBillController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "Treasury Bill Rate",
          ),
          const SizedBox(
            height: 8,
          ),
          TextInput(
            enabled: true,
            focusNode: totallistingstockFocusNode,
            text: "Total Stock Listing",
            obsecureText: false,
            controller: totallistingstockController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.numbers,
              color: mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "Total Stock Listing",
          ),
        ]),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == 1;

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
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 8.0),
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
}
