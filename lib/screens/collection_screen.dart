import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/components/custom_dropdown.dart';
import 'package:pricesense/components/food_dropdown.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/screens/collection_complete.dart';


class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool isCompleted = false;

  final TextEditingController priceInformantNameController =
      TextEditingController();
  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController sizeLevelController = TextEditingController();
  final TextEditingController priceLevelController = TextEditingController();
  final TextEditingController modularSizeController = TextEditingController();
  final TextEditingController estimatePriceController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  List<String> coordinatorsList = [
    'Udosen Emma',
    'Adebayo Femi',
    'Abubakar Gani'
  ];
  List<String> market = ['Akpan Andem', 'Itam Market', 'Ariaria Market','Shoprite','Market Square'];
  List<String> distributionType = ['WholeSale', 'Retails'];

  String? coordinatorValue;
  String? marketValue;
  String? distributionTypeValue;
  @override
  void dispose() {
    _pageController.dispose();
    priceInformantNameController.dispose();
    foodNameController.dispose();
    sizeLevelController.dispose();
    priceLevelController.dispose();
    modularSizeController.dispose();
    estimatePriceController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
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

  @override
  Widget build(BuildContext context) {
     
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Collection",
          style:
              TextStyle(fontSize: 24, color: Color.fromRGBO(76, 194, 201, 1)),
        ),
        actions: const [
          Icon(
            Icons.more_vert,
            color: Color.fromRGBO(76, 194, 201, 1),
          )
        ],
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
                        value: (_currentPage + 1) / 4,
                        backgroundColor: Colors.grey.shade200,
                        color: const Color.fromRGBO(76, 194, 201, 1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Step ${_currentPage + 1} of 4",
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
                     // _buildPage3(),
                      _buildPage4(),
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
              text: "Price Informant Name",
              obsecureText: false,
              controller: priceInformantNameController,
            
              textInputType: TextInputType.name, widget: Icon(Icons.person, color: Colors.teal),
            ),
            const SizedBox(height: 8),
            CustomDropdown(
              dataList: coordinatorsList,
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
              dataList: market,
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
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Food Item",
            style: TextStyle(fontSize: 18, color: Color.fromRGBO(76, 194, 201, 1)),
          ),
          const SizedBox(height: 10),
         CustomDropdown(
            dataList: distributionType,
            value: distributionTypeValue,
            maintitle: "Distribution Type",
            subtitle: "Select Distribution Type",
            onChanged: (value) {
              setState(() {
                distributionTypeValue = value;
              });
            },
          ),
          const SizedBox(height: 10,),
          FoodDropdown()
        ],
      ),
    ),
  );
}


  Widget _buildPage3() {
    Localizations.localeOf(context);
    var format  = NumberFormat.simpleCurrency(locale:Platform.localeName,name:"NGN");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Distribution Type",
            style:
                TextStyle(fontSize: 18, color: Color.fromRGBO(76, 194, 201, 1)),
          ),
          const SizedBox(height: 16),
          TextInput(
            text: "Price Level",
            obsecureText: false,
            controller: priceLevelController,
           
            textInputType: TextInputType.number, widget:Text(format.currencySymbol),
          ),
          const SizedBox(height: 8),
          TextInput(
            text: "Modular Size",
            obsecureText: false,
            controller: modularSizeController,
        
            textInputType: TextInputType.text, widget: Icon(Icons.straighten, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  Widget _buildPage4() {
     Localizations.localeOf(context);
    var format  = NumberFormat.simpleCurrency(locale:Platform.localeName,name:"NGN");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Remark Details",
            style:
                TextStyle(fontSize: 18, color: Color.fromRGBO(76, 194, 201, 1)),
          ),
          const SizedBox(height: 16),
          TextInput(
            text: "Estimate Price",
            obsecureText: false,
            controller: estimatePriceController,
            textInputType: TextInputType.number, 
            widget:Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(format.currencySymbol,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextInput(
            text: "Remarks",
            obsecureText: false,
            controller: remarksController,
            textInputType: TextInputType.text, 
            widget: Icon(Icons.note, color: Colors.teal)
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Summary",
            style:
                TextStyle(fontSize: 18, color: Color.fromRGBO(76, 194, 201, 1)),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem(
              "Price Informant Name:", priceInformantNameController.text),
          _buildSummaryItem("Coordinator:", coordinatorValue ?? ""),
          _buildSummaryItem("Market:", marketValue ?? ""),
          _buildSummaryItem("Distribution Type:", distributionTypeValue ?? ""),
          _buildSummaryItem("Food Name:", foodNameController.text),
          _buildSummaryItem("Size Level:", sizeLevelController.text),
          _buildSummaryItem("Price Level:", priceLevelController.text),
          _buildSummaryItem("Modular Size:", modularSizeController.text),
          _buildSummaryItem("Estimate Price:", estimatePriceController.text),
          _buildSummaryItem("Remarks:", remarksController.text),
        ],
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

  Widget _buildNavigationButtons() {
    final isLastPage = _currentPage == 3;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color:const Color.fromRGBO(76, 194, 201, 1),
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
                  child: const Text("Back",style:TextStyle(color: Colors.white)),
                ),
              ),
            ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:const Color.fromRGBO(76, 194, 201, 1),
                border: Border.all(
                  color: const Color.fromRGBO(76, 194, 201, 1),
                  width: 1,
                ),
              ),
              child: ElevatedButton(
                onPressed: isLastPage ? _completeForm : _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(76, 194, 201, 1),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: Text(isLastPage ? "Submit" : "Next",style:TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
