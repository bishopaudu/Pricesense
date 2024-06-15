import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/food_item_dbmodel.dart';
import 'package:pricesense/providers/survey_count_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/capitalize.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/database_service.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:http/http.dart' as http;

class SurveyListScreen extends ConsumerStatefulWidget {
  @override
  _SurveyListScreenState createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends ConsumerState<SurveyListScreen> {
  bool isUploading = false;
 // int surveyCount = 0;
  List<FoodItemDbModel> surveys = [];

  @override
  void initState() {
    super.initState();
    _loadSurveys();
  }

  /*Future<void> _loadSurveys() async {
    await ref.read(surveyCountProvider.notifier).loadSurveys();
  }*/

  
  Future<void> _loadSurveys() async {
    final db = DatabaseHelper();
   // final count = await db.getSurveyCount();
    final surveyList = await db.getSurveys();

    setState(() {
      //surveyCount = count;
      surveys = surveyList;
    });
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _uploadSurveys() async {
  //  final surveys = ref.watch(surveyCountProvider).surveys;
    final user = ref.watch(userProvider);
    final connectivityResult = ref.watch(connectivityProvider);

    if ((connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) && surveys.isNotEmpty) {
      setState(() {
        isUploading = true;
      });

      for (var survey in surveys) {
        final data = {
          'market': survey.marketid,
          'food_item': survey.foodId,
          'distribution_type': survey.distributionType,
          'brand': survey.brand,
          'measurement': survey.measurement,
          'user': survey.userId,
          'price': survey.price,
          'location': survey.location,
          'taxes':survey.taxandLevies,
          'rent':survey.shoprent
        };

        try {
          final response = await http.post(
            Uri.parse('https://priceintel.vercel.app/data/new'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${user?.token}',
            },
            body: json.encode(data),
          );

          if (response.statusCode == 200) {
            await DatabaseHelper().deleteSurvey(survey.id);
            ref.read(surveyCountProvider.notifier).refreshSurveyCount();
            showSnackBar("Uploaded survey successfully");
          } else {
            showErrorDialog('Failed to upload survey: ${survey.foodId}');
          }
        } catch (e) {
          showErrorDialog('Error uploading survey: $e');
        }
      }

      setState(() {
        isUploading = false;
      });
      await _loadSurveys();
    } else {
      showSnackBar("No Surveys To Upload or No Internet Connection");
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
        final internetStatus = ref.watch(connectivityProvider);
    final surveyState = ref.watch(surveyCountProvider);

    return Scaffold(
      appBar: AppBar(
        title:  Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? "Local Collections"
              : "No Internet Acess",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor:internetStatus == ConnectivityResult.mobile ||
                internetStatus == ConnectivityResult.wifi
            ? mainColor
            : Colors.red.shade400,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Number of Pending Reports: ${surveyState}'),
            Expanded(
              child: surveys.isNotEmpty
                  ? ListView.builder(
                      itemCount: surveys.length,
                      itemBuilder: (context, index) {
                        final survey = surveys[index];
                        return Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal.shade200,
                                child: Text(
                                  survey.foodname.substring(0, 1),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                Capitalize.capitalizeFirstLetter(survey.foodname),
                                style: const TextStyle(fontSize: 16),
                              ),
                              subtitle: Text(survey.brand,
                                  style: const TextStyle(fontSize: 15)),
                              trailing: Text(survey.location,
                                  style: const TextStyle(fontSize: 15)),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    )
                  : const Center(
                      child: Text('No surveys to display'),
                    ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                elevation: 5,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(300, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: isUploading ? null : _uploadSurveys,
              child: isUploading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white)),
                        SizedBox(width: 20),
                        Text("Uploading", style: TextStyle(color: Colors.white)),
                      ],
                    )
                  : const Text("Upload Surveys", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

