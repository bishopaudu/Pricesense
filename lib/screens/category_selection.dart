// ignore_for_file: must_be_immutable

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/collection_screen.dart';
import 'package:pricesense/screens/energy_survey_screen.dart';
import 'package:pricesense/screens/online_stores.dart';
import 'package:pricesense/screens/macroeconomics.dart';
import 'package:pricesense/screens/unauthorizedscreen.dart';
import 'package:pricesense/utils/colors.dart';

class CategorySelectionScreen extends ConsumerWidget {
  CategorySelectionScreen({super.key});
  List<String> categoryTypes = [
    'Physical Market Collection',
    'Online Market Price Collection',
    'Macroeconomic Variables',
    'Energy Price Survey'
  ];

 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final internetStatus = ref.watch(connectivityProvider);
     void navigateToCategoryScreen(BuildContext context, String category) {
    final user = ref.watch(userProvider);
    Widget screen;
    switch (category) {
      case 'Physical Market Collection':
      if (user?.role == 'agent') {
          screen = const CollectionScreen();
        } else {
          screen = const UnauthorizedScreen();
        }
        break;
      case 'Online Market Price Collection':
        if (user?.role == 'analyst') {
          screen = const OnlineStores();
        } else {
          screen = const UnauthorizedScreen();
        }
        break;
      case 'Macroeconomic Variables':
        if (user?.role == 'analyst') {
          screen = const Marcoeconomics();
        } else {
          screen = const UnauthorizedScreen();
        }
        break;
        case 'Energy Price Survey':
        if (user?.role == 'coordinator') {
          screen = const EnergySurveyScreen();
        } else {
          screen = const UnauthorizedScreen();
        }
        break;
      default:
        screen = const SizedBox(child: Center(child: Text('Text')));
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }


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
              ? "Select Collection Type"
              : "No Internet Access",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var types in categoryTypes)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: mainColor,
                      elevation: 5,
                      minimumSize:
                          const Size.fromHeight(60), // Increased button height
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(types),
                    onPressed: () => navigateToCategoryScreen(context, types),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
