// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pricesense/components/city_search.dart';
import 'package:pricesense/components/custom_dropdown.dart';
import 'package:pricesense/components/food_dropdown.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/screens/collection_complete.dart';
import 'package:pricesense/utils/data.dart';
import 'package:pricesense/utils/sizes.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isCompleted = false;
  Map<String, String> selectedFoodData = {};

  final TextEditingController priceInformantNameController =
      TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController remarksApplicableController =
      TextEditingController();
  final TextEditingController brandsController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final FocusNode priceInformantFocusNode = FocusNode();
  final FocusNode remarksFocusNode = FocusNode();
  final FocusNode weightstFocusNode = FocusNode();
  final FocusNode remarksApplicableFocusNode = FocusNode();
  final FocusNode brandsFocusNode = FocusNode();
  final FocusNode dateFocusNode = FocusNode();
  final FocusNode timeFocusNode = FocusNode();

  String? coordinatorValue;
  String? marketValue;
  String? distributionTypeValue;
  String? collectionType;
  String? cityValue;
  String? city;
  String? _filePath;
  DateTime dateTime = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();
  bool timeText = false;
  bool dateText = false;

  @override
  void dispose() {
    _pageController.dispose();
    priceInformantNameController.dispose();
    remarksController.dispose();
    brandsController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
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

  void _completeForm() {
    setState(() {
      isCompleted = true;
    });
  }



  Future<DateTime?> selectDate() => showDatePicker(
      context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));

  Future<TimeOfDay?> selectTime() =>
      showTimePicker(context: context, initialTime: TimeOfDay.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Collection",
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
                        value: (_currentPage + 1) / 3,
                        backgroundColor: Colors.grey.shade200,
                        color: const Color.fromRGBO(76, 194, 201, 1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step ${_currentPage + 1} of 3",
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
                      _buildPage1(),
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

  /*Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Collection Type",
            style:
                TextStyle(fontSize: 18, color: Color.fromRGBO(76, 194, 201, 1)),
          ),
          const SizedBox(height: 5),
          CustomDropdown(
              onChanged: (value) {
                setState(() {
                  collectionType = value;
                });
              },
              dataList: Data.collectionType,
              value: collectionType,
              maintitle: 'Collection Type',
              subtitle: 'Select Collection Type')
        ],
      ),
    );
  }*/

  Widget _buildPage1() {
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
            TextInput(
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
              onChanged: (value) {}, labelText: "Price Informant Name",
            ),
            const SizedBox(height: 8),
            CustomDropdown(
              dataList: Data.coordinatorsList,
              value: coordinatorValue,
              maintitle: "Coordinator",
              subtitle: "Select Coordinator",
              onChanged: (value) {
                setState(() {
                  coordinatorValue = value;
                });
              },
            ),
            const SizedBox(height: 8),
            CustomDropdown(
              dataList: Data.states,
              value: cityValue,
              maintitle: "Cities",
              subtitle: "Select Cities",
              onChanged: (value) {
                setState(() {
                  cityValue = value;
                });
              },
            ),
            const SizedBox(height: 8),
            CustomDropdown(
              dataList: Data.market,
              value: marketValue,
              maintitle: "Market",
              subtitle: "Select Market",
              onChanged: (value) {
                setState(() {
                  marketValue = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage2() {
    final hour = timeOfDay.hour.toString().padLeft(2, '0');
    final minutes = timeOfDay.minute.toString().padLeft(2, '0');
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
                  fontSize: 18, color: Color.fromRGBO(76, 194, 201, 1)),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              height: 8,
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
              height: 8,
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
            Container(
              height: 60,
              width: 300,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(76, 194, 201, 1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color.fromRGBO(76, 194, 201, 1),
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed:(){},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.photo_camera,
                        size: Sizes.iconSize, color: Colors.white),
                    SizedBox(width: 5),
                    Text("View Photo",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                TextInput(
                    textInputType: TextInputType.none,
                    text: "Select Date",
                    widget: IconButton(
                      onPressed: () async {
                        final date = await selectDate();
                        if (date == null) {
                          return;
                        }
                        setState(() {
                          dateTime = date;
                          // dateText = true;
                          dateController.text =
                              '${dateTime.year}/${dateTime.month}/${dateTime.day}';
                        });
                      },
                      icon: const Icon(
                        Icons.event,
                        size: Sizes.iconSize,
                        color: Color.fromRGBO(76, 194, 201, 1),
                      ),
                    ),
                    obsecureText: false,
                    controller: dateController,
                    focusNode: dateFocusNode,
                    onChanged: (value) {}, labelText: 'Select Date',),
                const SizedBox(
                  height: 8,
                ),
                TextInput(
                    textInputType: TextInputType.none,
                    text: "Select Time",
                    widget: IconButton(
                      onPressed: () async {
                        final time = await selectTime();
                        if (time == null) {
                          return;
                        }
                        setState(() {
                          timeOfDay = time;
                          //timeText = true;
                          timeController.text = '$hour:$minutes';
                        });
                      },
                      icon: const Icon(
                        Icons.schedule,
                        size: Sizes.iconSize,
                        color: Color.fromRGBO(76, 194, 201, 1),
                      ),
                    ),
                    obsecureText: false,
                    controller: timeController,
                    focusNode: timeFocusNode,
                    onChanged: (value) {}, labelText: 'Select Time',),
              ],
            ),
           /* const SizedBox(
              height: 8,
            ),
            TextInput(
                textInputType: TextInputType.name,
                text: "Brand(Optional)",
                widget: const Icon(
                  Icons.label_important,
                  size: Sizes.iconSize,
                  color: Color.fromRGBO(76, 194, 201, 1),
                ),
                obsecureText: false,
                controller: brandsController,
                focusNode: brandsFocusNode,
                onChanged: (value) {}, labelText: '',),
            const SizedBox(
              height: 8,
            ),
            TextInput(
              text: "Remarks(Optional)",
              obsecureText: false,
              controller: remarksApplicableController,
              textInputType: TextInputType.text,
              widget: const Icon(
                Icons.note_add,
                color: Color.fromRGBO(76, 194, 201, 1),
                size: Sizes.iconSize,
              ),
              onChanged: (value) {},
              focusNode: remarksApplicableFocusNode,
            ),*/
            /*const SizedBox(
              height: 8,
            ),*/
            /* _pickedImage != null
                ? Column(
                    children: [
                      Image.file(
                        File(_pickedImage!.path),
                        height: 200,
                      ),
                      const SizedBox(height: 8),
                      /*Text(
                        'Image Path: $_filePath',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),*/
                    ],
                  )
                : Text("No Image Selected"),*/
          ],
        ),
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
            _buildSummaryItem(
                "Price Informant Name:", priceInformantNameController.text),
            _buildSummaryItem("Coordinator:", coordinatorValue ?? ""),
            _buildSummaryItem("City:", cityController.text),
            _buildSummaryItem("Market:", marketValue ?? ""),
            _buildSummaryItem(
                "Distribution Type:", distributionTypeValue ?? ""),
            _buildSummaryItem("Food Item:", selectedFoodData['foodItem'] ?? ""),
            _buildSummaryItem("Type:", selectedFoodData['subtype'] ?? ""),
            _buildSummaryItem("Price:", selectedFoodData['price'] ?? ""),
            _buildSummaryItem("Remarks:", remarksController.text),
            _buildSummaryItem("Image:",
                _filePath != null ? 'Image Present' : 'No Image Availiable'),
            _buildSummaryItem("Date Submitted:",
                '${dateTime.year}/${dateTime.month}/${dateTime.day}'),
            _buildSummaryItem("Time Submitted:", timeController.text),
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

 /* Widget _buildNavigationButtons() {
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
                  color: const Color.fromRGBO(76, 194, 201, 1),
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: _previousPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text(
                  "Back",
                  style: TextStyle(color: Color.fromRGBO(76, 194, 201, 1)),
                ),
              ),
            ),
          ),
        if (_currentPage > 0) SizedBox(width: 8.0), // Add space between buttons
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
