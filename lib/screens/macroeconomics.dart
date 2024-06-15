import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/screens/collection_complete.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/sizes.dart';

class Marcoeconomics extends ConsumerStatefulWidget {
  const Marcoeconomics({super.key});

  @override
  ConsumerState<Marcoeconomics> createState() => _MarcoeconomicsState();
}

class _MarcoeconomicsState extends ConsumerState<Marcoeconomics> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isCompleted = false;
  void _completeForm() {
    setState(() {
      isCompleted = true;
    });
  }


  bool _validatePage1() {
    return dateController.text.isNotEmpty &&
        FXController.text.isNotEmpty &&
        energyController.text.isNotEmpty &&
        deiselController.text.isNotEmpty &&
        mrrController.text.isNotEmpty &&
        interbankController.text.isNotEmpty;
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
  final FocusNode FXFocusNode = FocusNode();
  final FocusNode energyFocusNode = FocusNode();
  final FocusNode mprFocusNode = FocusNode();
  final FocusNode deiselFocusNode = FocusNode();
  final FocusNode mrrFocusNode = FocusNode();
  final FocusNode interbankFocusNode = FocusNode();

  Future<DateTime?> selectDate() => showDatePicker(
      context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
  DateTime dateTime = DateTime.now();
  final FocusNode dateFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
      final internetStatus = ref.watch(connectivityProvider);

    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
          color: Colors.white, 
        ),
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? "Macroeconomics Collection"
              : "No Internet Access",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
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
              style: TextStyle(
                  fontSize: 24, color:mainColor),
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
            style:
                TextStyle(fontSize: 18, color:  mainColor),
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
            focusNode: FXFocusNode,
            text: "Daily Foreign Exchange Rate (Naira/USD)",
            obsecureText: false,
            controller: FXController,
            textInputType: TextInputType.number,
            widget: const Icon(
              Icons.currency_exchange,
              color:  mainColor,
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
                      color:  mainColor,
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
                      color:  mainColor,
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
              color:  mainColor,
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
              color:  mainColor,
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
              color:  mainColor,
              size: Sizes.iconSize,
            ),
            onChanged: (value) {},
            labelText: "Inter-Bank Call Rate",
          ),
          const SizedBox(
            height: 8,
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
          if (_currentPage > 0)
            const SizedBox(width: 8.0),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:  mainColor,
              ),
              child: ElevatedButton(
                onPressed: isLastPage ? _completeForm : _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor:  mainColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(
                  isLastPage ? "Submit" : "Next",
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
