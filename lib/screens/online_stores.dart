import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/components/custom_dropdown.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/collection_complete.dart';
import 'package:pricesense/utils/data.dart';
import 'package:pricesense/utils/sizes.dart';

class OnlineStores extends ConsumerStatefulWidget {
  const OnlineStores({super.key});

  @override
  ConsumerState<OnlineStores> createState() => _OnlineStoresState();
}

class _OnlineStoresState extends ConsumerState<OnlineStores> {
  Map<String, String> selectedFoodData = {};
  String? coordinatorValue;
  String? onlineMarketValue;
  String? onlineMarketDataValue;
  final PageController _pageController = PageController();
  TextEditingController priceController = TextEditingController();
  final TextEditingController priceInformantNameController =
      TextEditingController();
  FocusNode priceFocusNode = FocusNode();
  final FocusNode priceInformantFocusNode = FocusNode();

  int _currentPage = 0;
  bool isCompleted = false;
  void _completeForm() {
    setState(() {
      isCompleted = true;
    });
  }

  bool _validatePage1() {
    return onlineMarketValue != null &&
        onlineMarketValue!.isNotEmpty &&
        priceController.text.isNotEmpty &&
        dateController.text.isNotEmpty;
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

  /* void _nextPage() {
    if (_currentPage < 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }*/

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

  Future<DateTime?> selectDate() => showDatePicker(
      context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
  DateTime dateTime = DateTime.now();
  final FocusNode dateFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Online Shopping Survey Form",
          style:
              TextStyle(fontSize: 24, color: Color.fromRGBO(76, 194, 201, 1)),
        ),
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
                        color: const Color.fromRGBO(76, 194, 201, 1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step ${_currentPage + 1} of 2",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(76, 194, 201, 1),
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
                  fontSize: 24, color: Color.fromRGBO(76, 194, 201, 1)),
            ),
            const SizedBox(height: 16),
            _buildSummaryItem("Food Item:", onlineMarketDataValue ?? ""),
            _buildSummaryItem("Online Store:", onlineMarketValue ?? ""),
            _buildSummaryItem("Price:", priceController.text),
            _buildSummaryItem(
                "Date:", '${dateTime.year}/${dateTime.month}/${dateTime.day}'),
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
              color: Color.fromRGBO(76, 194, 201, 1),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPage1(WidgetRef ref) {
    final agentName = ref.watch(userProvider);
    String prefilledAgentName = '${agentName!.firstName} ${agentName.lastName}';
    priceInformantNameController.text = prefilledAgentName;
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
              "Basic Details",
              style: TextStyle(
                  fontSize: 18, color: Color.fromRGBO(76, 194, 201, 1)),
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
                    color: Color.fromRGBO(76, 194, 201, 1),
                  ),
                  obsecureText: false,
                  controller: dateController,
                  focusNode: dateFocusNode,
                  onChanged: (value) {},
                  labelText: 'Select Date',
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextInput(
              enabled: false,
              focusNode: priceInformantFocusNode,
              text: "Price Informant Name",
              obsecureText: false,
              controller: priceInformantNameController,
              textInputType: TextInputType.name,
              widget: const Icon(
                Icons.person,
                color: Color.fromRGBO(76, 194, 201, 1),
                size: Sizes.iconSize,
              ),
              onChanged: (value) {},
              labelText: "Price Informant Name",
            ),
            const SizedBox(height: 8),
            CustomDropdown(
              dataList: Data.onlineStores,
              value: onlineMarketValue,
              maintitle: "Online Store",
              subtitle: "Select Online Store",
              onChanged: (value) {
                setState(() {
                  onlineMarketValue = value;
                });
              },
            ),
            const SizedBox(height: 8),
            CustomDropdown(
              dataList: Data.onlineShopData,
              value: onlineMarketDataValue,
              maintitle: "Food Item",
              subtitle: "Select Food Items",
              onChanged: (value) {
                setState(() {
                  onlineMarketDataValue = value;
                });
              },
            ),
            const SizedBox(height: 8),
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
                          color: Color.fromRGBO(76, 194, 201, 1),
                          fontSize: Sizes.iconSize),
                    ),
                  ],
                ),
              ),
              obsecureText: false,
              controller: priceController,
              focusNode: priceFocusNode,
              onChanged: (value) {},
              labelText: 'Price',
            ),
          ],
        ),
      ),
    );
  }

  /*Widget _buildNavigationButtons() {
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
                  color: const Color.fromRGBO(76, 194, 201, 1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromRGBO(76, 194, 201, 1),
                    width: 1,
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _previousPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child:
                      const Text("Back", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromRGBO(76, 194, 201, 1),
                border: Border.all(
                  color: const Color.fromRGBO(76, 194, 201, 1),
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: isLastPage ? _completeForm : _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(isLastPage ? "Submit" : "Next",
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }*/
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
                    color: const Color.fromRGBO(76, 194, 201, 1),
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
                    style: TextStyle(color: Color.fromRGBO(76, 194, 201, 1)),
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
                color: const Color.fromRGBO(76, 194, 201, 1),
              ),
              child: ElevatedButton(
                onPressed: isLastPage ? _completeForm : _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
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
