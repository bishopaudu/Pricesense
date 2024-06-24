import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/components/text_input.dart';
import 'package:pricesense/model/agent_history_model.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/error_dialog.dart';
import 'package:pricesense/utils/sizes.dart';

class RemarksScreen extends ConsumerStatefulWidget {
  RemarksScreen({super.key, required this.historyItem});
  final HistoryItem historyItem;

  @override
  ConsumerState<RemarksScreen> createState() => _RemarksScreenState();
}

class _RemarksScreenState extends ConsumerState<RemarksScreen> {
  final TextEditingController marketController = TextEditingController();
  final TextEditingController brandsController = TextEditingController();
  final TextEditingController measurementController = TextEditingController();
  final TextEditingController foodnameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController taxandLeviesController = TextEditingController();
  final TextEditingController shoprentController = TextEditingController();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode taxandLeviesFocusNode = FocusNode();
  final FocusNode shoprentFocusNode = FocusNode();
  final FocusNode marketFocusNode = FocusNode();
  final FocusNode brandsFocusNode = FocusNode();
  final FocusNode measurementFocusNode = FocusNode();
  final FocusNode foodnameFocusNode = FocusNode();
  String submitText = "Submit";
  bool uploading = false;

  @override
  void initState() {
    super.initState();
    marketController.text = widget.historyItem.market.name;
    priceController.text = widget.historyItem.price.toString();
    brandsController.text = widget.historyItem.brand;
    measurementController.text = widget.historyItem.measurement;
    foodnameController.text = widget.historyItem.foodItem.name;
    taxandLeviesController.text = widget.historyItem.taxes.toString();
    shoprentController.text = widget.historyItem.rent.toString();
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> submitRemarks() async {
    if (priceController.text.isNotEmpty ||
        taxandLeviesController.text.isNotEmpty ||
        shoprentController.text.isNotEmpty) {
      final user = ref.read(userProvider);
      final connectivityResult = ref.read(connectivityProvider);
      setState(() {
        submitText = 'Submitting';
        uploading = true;
      });

      try {
        final data = {
          'price': '${int.parse(priceController.text)}',
          'rent': '${int.parse(shoprentController.text)}',
          'taxes': '${int.parse(taxandLeviesController.text)}'
        };

        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          final response = await http.post(
            Uri.parse(
                'https://priceintel.vercel.app/data/review/${widget.historyItem.id}'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${user!.token}',
            },
            body: json.encode(data),
          );
          if (response.statusCode == 200) {
            showSnackBar("Review Submitted");
            priceController.clear();
            taxandLeviesController.clear();
            shoprentController.clear();
            setState(() {
              submitText = 'Submitted';
              uploading = false;
            });
            // showSnackBar('Successfully uploaded to server');
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
          showSnackBar("Not connected to server");
          setState(() {
            uploading = false;
          });
        }
      } catch (e) {
        print(e);
        showErrorDialog('error $e', context);
        setState(() {
          uploading = false;
        });
      }
    } else {
      showSnackBar("please fill all required fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.watch(connectivityProvider);
    Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back button
        ),
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? "Review"
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextInput(
                      enabled: false,
                      focusNode: foodnameFocusNode,
                      text: "Food Name",
                      obsecureText: false,
                      controller: foodnameController,
                      textInputType: TextInputType.name,
                      widget: const Icon(
                        Icons.food_bank,
                        color: mainColor,
                        size: Sizes.iconSize,
                      ),
                      onChanged: (value) {},
                      labelText: "Food Name",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextInput(
                      enabled: false,
                      focusNode: marketFocusNode,
                      text: "Market",
                      obsecureText: false,
                      controller: marketController,
                      textInputType: TextInputType.name,
                      widget: const Icon(
                        Icons.storefront,
                        color: mainColor,
                        size: Sizes.iconSize,
                      ),
                      onChanged: (value) {},
                      labelText: "Market",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    if (widget.historyItem.brand != 'No Brands Available') ...[
                      TextInput(
                        enabled: false,
                        focusNode: brandsFocusNode,
                        text: "Brand",
                        obsecureText: false,
                        controller: brandsController,
                        textInputType: TextInputType.name,
                        widget: const Icon(
                          Icons.branding_watermark,
                          color: mainColor,
                          size: Sizes.iconSize,
                        ),
                        onChanged: (value) {},
                        labelText: "Brand",
                      ),
                    ],
                    const SizedBox(
                      height: 10,
                    ),
                    TextInput(
                      enabled: false,
                      focusNode: measurementFocusNode,
                      text: "Measurement",
                      obsecureText: false,
                      controller: measurementController,
                      textInputType: TextInputType.name,
                      widget: const Icon(
                        Icons.monitor_weight,
                        color: mainColor,
                        size: Sizes.iconSize,
                      ),
                      onChanged: (value) {},
                      labelText: "Measurement",
                    ),
                    const SizedBox(
                      height: 10,
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
                                  color: mainColor, fontSize: Sizes.iconSize),
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
                      height: 10,
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
                                  color: mainColor,
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
                      height: 10,
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
                                  color: mainColor,
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
                  ],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                submitRemarks();
              },
              child: uploading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                            height: 20,
                            width: 20,
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                        const SizedBox(width: 20),
                        Text(submitText,
                            style: const TextStyle(color: Colors.white)),
                      ],
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
