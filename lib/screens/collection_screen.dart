// ignore_for_file: avoid_types_as_parameter_names

/*import 'package:flutter/material.dart';
import 'package:pricesense/components/custom_dropdown.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/screens/collection_complete.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  int currentStep = 0;
  bool isCompleted = false;
  final TextEditingController foodNameController = TextEditingController();
  List<String> coordinatorsList = [
    'Udosen Emma',
    'Adebayo Femi',
    'Abubakar Gani'
  ];
  List<String> market = ['Akpan Andem', 'Itam Market', 'Ariaria Market'];
  List<String> distrubtionType = ['WholeSale', 'Retails'];
  List<String> foodItems = ['Bag Of Rice', 'Retails'];

  String? coordinatorValue;
  String? marketValue;
  String? distributionTypeValue;

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
          ? CollectionComplete()
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Theme(
                  data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                          primary: Color.fromRGBO(76, 194, 201, 1))),
                  child: Stepper(
                    onStepTapped: (step) => setState(() {
                      currentStep = step;
                    }),
                    currentStep: currentStep,
                    type: StepperType.vertical,
                    steps: getSteps(),
                    onStepContinue: () {
                      final isLastStep = currentStep == getSteps().length - 1;
                      if (isLastStep) {
                        isCompleted = true;
                        print("Done");
                      } else {
                        setState(() => currentStep += 1);
                      }
                    },
                    onStepCancel: currentStep == 0
                        ? null
                        : () => setState(() => currentStep -= 1),
                    controlsBuilder: (context, ControlsDetails) {
                      final isLastStep = currentStep == getSteps().length - 1;
                      return Container(
                        margin: const EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          const Color.fromRGBO(76, 194, 201, 1),
                                      elevation: 5,
                                    ),
                                    onPressed: ControlsDetails.onStepContinue,
                                    child:
                                        Text(isLastStep ? "Confirm" : "Next"))),
                            const SizedBox(
                              width: 12,
                            ),
                            if (currentStep != 0)
                              Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: const Color.fromRGBO(
                                            76, 194, 201, 1),
                                        elevation: 5,
                                      ),
                                      onPressed: ControlsDetails.onStepCancel,
                                      child: const Text("Back"))),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: const Text(
              "Basic Details",
              style: TextStyle(color: Color.fromRGBO(76, 194, 201, 1)),
            ),
            content: Column(
              children: [
                TextInput(
                  text: "Price Informant Name",
                  obsecureText: false,
                  controller: TextEditingController(),
                  Icon: const Icon(Icons.person, color: Colors.teal),
                  textInputType: TextInputType.name,
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomDropdown(
                  dataList: coordinatorsList,
                  value: coordinatorValue,
                  subtitle: "Select Coordinator",
                  maintitle: "Coordinator",
                  onChanged: (value) {
                    setState(() {
                      coordinatorValue = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomDropdown(
                  dataList: market,
                  value: marketValue,
                  subtitle: "Select Market",
                  maintitle: "Market",
                  onChanged: (value) {
                    setState(() {
                      marketValue = value;
                    });
                  },
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomDropdown(
                  dataList: distrubtionType,
                  value: distributionTypeValue,
                  subtitle: " Distribution Type",
                  maintitle: "Select Distribution Type",
                  onChanged: (value) {
                    setState(() {
                      distributionTypeValue = value;
                    });
                  },
                )
              ],
            )),
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text("Food Item",
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(76, 194, 201, 1),
                )),
            content: Column(
              children: [
                TextInput(
                  text: "Food Name",
                  obsecureText: false,
                  controller: TextEditingController(),
                  Icon: const Icon(Icons.fastfood, color: Colors.teal),
                  textInputType: TextInputType.name,
                ),
                TextInput(
                  text: "Size Level",
                  obsecureText: false,
                  controller: TextEditingController(),
                  Icon: const Icon(Icons.linear_scale, color: Colors.teal),
                  textInputType: TextInputType.text,
                ),
              ],
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text("Distrubtion Type"),
            content: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Price Level"),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Modular Size"),
                )
              ],
            )),
        Step(
            state: currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 2,
            title: Text("Remark Details"),
            content: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Estimate Price"),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Remarks"),
                )
              ],
            ))
      ];

  DropdownMenuItem<String> buildItem(String data) => DropdownMenuItem(
        value: data,
        child: Text(
          data,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      );
}
*/
import 'package:flutter/material.dart';
import 'package:pricesense/components/custom_dropdown.dart';
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

  final TextEditingController foodNameController = TextEditingController();
  final TextEditingController priceInformantNameController = TextEditingController();
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
  List<String> market = ['Akpan Andem', 'Itam Market', 'Ariaria Market'];
  List<String> distributionType = ['WholeSale', 'Retails'];

  String? coordinatorValue;
  String? marketValue;
  String? distributionTypeValue;

  @override
  void dispose() {
    _pageController.dispose();
    foodNameController.dispose();
    priceInformantNameController.dispose();
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
          style: TextStyle(fontSize: 24, color: Color.fromRGBO(76, 194, 201, 1)),
        ),
        actions: const [
          Icon(
            Icons.more_vert,
            color: Color.fromRGBO(76, 194, 201, 1),
          )
        ],
      ),
      body: isCompleted
          ? CollectionComplete()
          : Column(
              children: [
                LinearProgressIndicator(
                  value: (_currentPage + 1) / 4,
                  backgroundColor: Colors.grey.shade200,
                  color: const Color.fromRGBO(76, 194, 201, 1),
                ),
                 Text(
                        "Step ${_currentPage + 1} of 4",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(76, 194, 201, 1),
                        ),
                      ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildPage1(),
                      _buildPage2(),
                      _buildPage3(),
                      _buildPage4(),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Basic Details",
            style: TextStyle(color: Color.fromRGBO(76, 194, 201, 1)),
          ),
          const SizedBox(height: 16),
          TextInput(
            text: "Price Informant Name",
            obsecureText: false,
            controller: priceInformantNameController,
            Icon: const Icon(Icons.person, color: Colors.teal),
            textInputType: TextInputType.name,
          ),
          const SizedBox(height: 8),
          CustomDropdown(
            dataList: coordinatorsList,
            value: coordinatorValue,
            subtitle: "Select Coordinator",
            maintitle: "Coordinator",
            onChanged: (value) => setState(() => coordinatorValue = value),
          ),
          const SizedBox(height: 8),
          CustomDropdown(
            dataList: market,
            value: marketValue,
            subtitle: "Select Market",
            maintitle: "Market",
            onChanged: (value) => setState(() => marketValue = value),
          ),
          const SizedBox(height: 8),
          CustomDropdown(
            dataList: distributionType,
            value: distributionTypeValue,
            subtitle: "Select Distribution Type",
            maintitle: "Distribution Type",
            onChanged: (value) => setState(() => distributionTypeValue = value),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Food Item",
            style: TextStyle(color: Color.fromRGBO(76, 194, 201, 1)),
          ),
          const SizedBox(height: 16),
          TextInput(
            text: "Food Name",
            obsecureText: false,
            controller: foodNameController,
            Icon: const Icon(Icons.fastfood, color: Colors.teal),
            textInputType: TextInputType.name,
          ),
          const SizedBox(height: 8),
          TextInput(
            text: "Size Level",
            obsecureText: false,
            controller: sizeLevelController,
            Icon: const Icon(Icons.linear_scale, color: Colors.teal),
            textInputType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Distribution Type",
            style: TextStyle(color: Color.fromRGBO(76, 194, 201, 1)),
          ),
          const SizedBox(height: 16),
          TextInput(
            text: "Price Level",
            obsecureText: false,
            controller: priceLevelController,
            Icon: const Icon(Icons.attach_money, color: Colors.teal),
            textInputType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextInput(
            text: "Modular Size",
            obsecureText: false,
            controller: modularSizeController,
            Icon: const Icon(Icons.straighten, color: Colors.teal),
            textInputType: TextInputType.text,
          ),
        ],
      ),
    );
  }

  Widget _buildPage4() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Remark Details",
            style: TextStyle(color: Color.fromRGBO(76, 194, 201, 1)),
          ),
          const SizedBox(height: 16),
          TextInput(
            text: "Estimate Price",
            obsecureText: false,
            controller: estimatePriceController,
            Icon: const Icon(Icons.money, color: Colors.teal),
            textInputType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          TextInput(
            text: "Remarks",
            obsecureText: false,
            controller: remarksController,
            Icon: const Icon(Icons.comment, color: Colors.teal),
            textInputType: TextInputType.text,
          ),
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
            ElevatedButton(
               style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          const Color.fromRGBO(76, 194, 201, 1),
                                      elevation: 5,
                                    ),
              onPressed: _previousPage,
              child: const Text("Back"),
            ),
          ElevatedButton(
             style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          const Color.fromRGBO(76, 194, 201, 1),
                                      elevation: 5,
                                    ),
            onPressed: isLastPage ? _completeForm : _nextPage,
            child: Text(isLastPage ? "Confirm" : "Next"),
          ),
        ],
      ),
    );
  }
}
