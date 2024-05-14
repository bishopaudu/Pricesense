import 'package:flutter/material.dart';

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

int currentStep = 0;
//bool isCompleted = false;

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Collection",
          style: TextStyle(fontSize: 24),
        ),
        actions: [Icon(Icons.more_vert)],
      ),
      body: Theme(
        data: Theme.of(context)
            .copyWith(colorScheme: ColorScheme.light(primary: Colors.teal)),
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
              print("Done");
            } else {
              setState(() => currentStep += 1);
            }
          },
          onStepCancel:
              currentStep == 0 ? null : () => setState(() => currentStep -= 1),
        ),
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
            state: currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 0,
            title: Text("Food Details"),
            content: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: "Food Name"),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Size Level"),
                )
              ],
            )),
        Step(
            state: currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: currentStep >= 1,
            title: Text("Price Detials"),
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
}
