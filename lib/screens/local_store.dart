/*import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/food_item_dbmodel.dart';
import 'package:pricesense/providers/survey_count_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/agent_history_notifier.dart';
import 'package:pricesense/utils/capitalize.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/database_service.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pricesense/utils/grid_data_service.dart';

class SurveyListScreen extends ConsumerStatefulWidget {
  @override
  _SurveyListScreenState createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends ConsumerState<SurveyListScreen> {
  bool isUploading = false;
  double uploadProgress = 0.0;
  List<FoodItemDbModel> surveys = [];
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _loadSurveys();
    _monitorConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _monitorConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        _uploadSurveys();
      }
    });
  }

  Future<void> _loadSurveys() async {
    final db = DatabaseHelper();
    final surveyList = await db.getSurveys();
    setState(() {
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
    final user = ref.watch(userProvider);
    final connectivityResult = ref.watch(connectivityProvider);

    if ((connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) && surveys.isNotEmpty) {
      setState(() {
        isUploading = true;
        uploadProgress = 0.0;
      });

      for (int i = 0; i < surveys.length; i++) {
        final survey = surveys[i];
        final data = {
          'market': survey.marketid,
          'food_item': survey.foodId,
          'distribution_type': survey.distributionType,
          'brand': survey.brand,
          'measurement': survey.measurement,
          'user': survey.userId,
          'price': survey.price,
          'location': survey.location,
          'taxes': survey.taxandLevies,
          'rent': survey.shoprent
        };

        try {
          final response = await http.post(
            Uri.parse('https://priceintel.vercel.app/data/market/new'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${user?.token}',
            },
            body: json.encode(data),
          );

          if (response.statusCode == 200) {
            await DatabaseHelper().deleteSurvey(survey.id);
            ref.read(surveyCountProvider.notifier).refreshSurveyCount();
             ref.read(historyNotifierProvider.notifier).fetchHistory();
              ref.invalidate(gridDataProvider);
            showSnackBar("Uploaded Survey Successfully");
          } else {
            showSnackBar('Failed To Upload Survey');
          }
        } catch (e) {
          showErrorDialog('Error Uploading Survey: $e');
        }

        setState(() {
          uploadProgress = (i + 1) / surveys.length;
        });
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
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          internetStatus == ConnectivityResult.mobile || internetStatus == ConnectivityResult.wifi
              ? "Local Collections"
              : "No Internet Access",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: internetStatus == ConnectivityResult.mobile || internetStatus == ConnectivityResult.wifi
            ? mainColor
            : Colors.red.shade400,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Number of Pending Reports: ${surveyState}'),
            if (isUploading)
              LinearProgressIndicator(value: uploadProgress),
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
                                backgroundColor: mainColor,
                                child: Text(
                                  survey.foodname.substring(0, 1).toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                Capitalize.capitalizeFirstLetter(survey.foodname),
                                style: const TextStyle(fontSize: 16),
                              ),
                              subtitle: Text(survey.measurement,
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
*/

import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/model/enery_model.dart';
import 'package:pricesense/model/food_item_dbmodel.dart';
import 'package:pricesense/model/macroeconomics_model.dart';
import 'package:pricesense/model/online_store_model.dart';
import 'package:pricesense/providers/survey_count_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/utils/agent_history_notifier.dart';
import 'package:pricesense/utils/base_url.dart';
import 'package:pricesense/utils/capitalize.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/coordinator_history_notifier.dart';
import 'package:pricesense/utils/database_service.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:http/http.dart' as http;
import 'package:pricesense/utils/grid_data_service.dart';

class SurveyListScreen extends ConsumerStatefulWidget {
  @override
  _SurveyListScreenState createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends ConsumerState<SurveyListScreen> {
  bool isUploading = false;
  double uploadProgress = 0.0;
  List<FoodItemDbModel> surveys = [];
  List<MacroeconomicsModel> macroeconomics = [];
  List<OnlineStoreModel> onlineStores = [];
  List<EnergyModel> energyData = [];
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _loadData();
    _monitorConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void _monitorConnectivity() {
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        _uploadSurveys();
      }
    });
  }

  Future<void> _loadData() async {
    final db = DatabaseHelper();
    final user = ref.read(userProvider);

    if (user?.role == 'agent') {
      final surveyList = await db.getSurveys();
      setState(() {
        surveys = surveyList;
      });
    } else if (user?.role == 'analyst') {
      final macroList = await db.getMacroeconomics();
      final storeList = await db.getOnlinestore();
      setState(() {
        macroeconomics = macroList;
        onlineStores = storeList;
      });
    } else if (user?.role == 'coordinator') {
      final energyList = await db.getEnergy();
      setState(() {
        energyData = energyList;
      });
    }
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
    final user = ref.watch(userProvider);
    final connectivityResult = ref.watch(connectivityProvider);

    if ((connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      setState(() {
        isUploading = true;
        uploadProgress = 0.0;
      });
      switch (user?.role) {
        case 'agent':
          uploadAgentSurvey(agentupload_url, user?.token);
          break;
        case 'analyst':
          uploadMacroeconomics(macroeconomics_url, user?.token);
          uploadOnlineStore(online_store_url, user?.token);
          break;
        case 'coordinator':
          uploadEnergy(energy_url, user?.token);
          break;
        default:
          const SizedBox(child: Center(child: Text('Text')));
      }
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
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? "Local Collections"
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Number of Pending Reports: ${surveyState}'),
            if (isUploading) LinearProgressIndicator(value: uploadProgress),
            Expanded(
              child: user?.role == 'agent'
                  ? _buildSurveyList()
                  : user?.role == 'analyst'
                      ? _buildAnalystView()
                      : _buildCoordinatorView(),
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
                            child:
                                CircularProgressIndicator(color: Colors.white)),
                        SizedBox(width: 20),
                        Text("Uploading",
                            style: TextStyle(color: Colors.white)),
                      ],
                    )
                  : const Text("Upload Surveys",
                      style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurveyList() {
    return surveys.isNotEmpty
        ? ListView.builder(
            itemCount: surveys.length,
            itemBuilder: (context, index) {
              final survey = surveys[index];
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: mainColor,
                      child: Text(
                        survey.foodname.substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      Capitalize.capitalizeFirstLetter(survey.foodname),
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(survey.measurement,
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
          );
  }

  Widget _buildAnalystView() {
    return ListView(
      children: [
        ExpansionTile(
          title: const Text("Macroeconomics Data"),
          children: macroeconomics.map((macro) {
            return ListTile(
              title: Text(
                  'Official USD Exchange Rate: ${macro.officialUsdExchangeRate}'),
              subtitle:
                  Text('Monetary Policy Rate: ${macro.monetaryPolicyRate}'),
            );
          }).toList(),
        ),
        ExpansionTile(
          title: const Text("Online Store Data"),
          children: onlineStores.map((store) {
            return ListTile(
              title: Text('Brand: ${store.brand}'),
              subtitle: Text('Price: ${store.price}'),
              trailing: Text('Measurement: ${store.measurement}'),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCoordinatorView() {
    return ListView(
      children: energyData.map((energy) {
        return ListTile(
          title: Text('Price Petrol NNPC: ${energy.pricepetrolnnpc}'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Unofficial USD Exchange Rate: ${energy.unofficialusdexchangerate}'),
              //Text('Price Petrol Independent: ${energy.pricepetrolindependent}'),
              //Text('Price Petrol NNPC: ${energy.pricePetrolNnpc}'),
              // Text('Price Diesel Independent: ${energy.pricedieselindependent}'),
              // Text('Price Diesel NNPC: ${energy.priceieselNnpc}'),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> uploadAgentSurvey(String url, String? token) async {
    for (int i = 0; i < surveys.length; i++) {
      final survey = surveys[i];
      final data = {
        'market': survey.marketid,
        'food_item': survey.foodId,
        'distribution_type': survey.distributionType,
        'brand': survey.brand,
        'measurement': survey.measurement,
        'user': survey.userId,
        'price': survey.price,
        'location': survey.location,
        'taxes': survey.taxandLevies,
        'rent': survey.shoprent
      };

      try {
        final response = await http.post(
          Uri.parse('https://priceintel.vercel.app/data/market/new'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token}',
          },
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          await DatabaseHelper().deleteSurvey(survey.id);
          ref.read(surveyCountProvider.notifier).refreshSurveyCount();
          ref.read(historyNotifierProvider.notifier).fetchHistory();
          ref.invalidate(gridDataProvider);
          showSnackBar("Uploaded Survey Successfully");
        } else {
          showSnackBar('Failed To Upload Survey');
        }
      } catch (e) {
        showErrorDialog('Error Uploading Survey: $e');
      }

      setState(() {
        uploadProgress = (i + 1) / surveys.length;
      });
    }
    setState(() {
      isUploading = false;
    });
    await _loadData();
  }

  Future<void> uploadMacroeconomics(String url, String? token) async {
    for (int i = 0; i < macroeconomics.length; i++) {
      final survey = macroeconomics[i];

      final data = MacroeconomicsModel(
        officialUsdExchangeRate: survey.officialUsdExchangeRate,
        monetaryPolicyRate: survey.monetaryPolicyRate,
        minimumDiscountRate: survey.minimumDiscountRate,
        interbankCallRate: survey.interbankCallRate,
        treasuryBillRate: survey.treasuryBillRate,
        savingsDepositRate: survey.savingsDepositRate,
        primeLendingRate: survey.primeLendingRate,
        marketCapitalization: survey.marketCapitalization,
        allShareIndex: survey.allShareIndex,
        turnOverRatio: survey.turnOverRatio,
        valueShareTraded: survey.valueShareTraded,
        totalListingStocks: survey.totalListingStocks,
      );
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token}',
          },
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          await DatabaseHelper().deleteMacroeconomics(survey.id!);
          //ref.read(surveyCountProvider.notifier).refreshSurveyCount();
          //ref.read(historyNotifierProvider.notifier).fetchHistory();
          ref.invalidate(gridDataProvider);
          showSnackBar("Uploaded Survey Successfully");
        } else {
          showSnackBar('Failed To Upload Survey');
        }
      } catch (e) {
        showErrorDialog('Error Uploading Survey: $e');
      }

      setState(() {
        uploadProgress = (i + 1) / macroeconomics.length;
      });
    }
    setState(() {
      isUploading = false;
    });
  }

  Future<void> uploadOnlineStore(String url, String? token) async {
    for (int i = 0; i < onlineStores.length; i++) {
      final survey = onlineStores[i];
       final data = {
        'store': survey.store,
        'food_item': survey.foodItem,
        'price':survey.price,
        'brand': survey.brand,
        'measurement':survey.measurement,
      };
       try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token}',
          },
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          await DatabaseHelper().deleteOnlinestore(survey.id!);
          //ref.read(surveyCountProvider.notifier).refreshSurveyCount();
          //ref.read(historyNotifierProvider.notifier).fetchHistory();
          //ref.read(coordinatorHistoryNotifierProvider);
          ref.invalidate(gridDataProvider);
          showSnackBar("Uploaded Survey Successfully");
        } else {
          showSnackBar('Failed To Upload Survey');
        }
      } catch (e) {
        showErrorDialog('Error Uploading Survey: $e');
      }

      setState(() {
        uploadProgress = (i + 1) / onlineStores.length;
      });
    }
    setState(() {
      isUploading = false;
    });
  }


  Future<void> uploadEnergy(String url, String? token) async {
    for (int i = 0; i < energyData.length; i++) {
      final survey = energyData[i];
      final data = {
        'city': survey.city,
        'unofficial_usd_exchange_rate': survey.unofficialusdexchangerate,
        'litre_of_petrol_independent': survey.pricepetrolindependent,
        'litre_of_petrol_nnpc': survey.pricepetrolnnpc,
        'litre_of_diesel_independent': survey.pricedieselindependent,
        'litre_of_diesel_nnpc': survey.pricedieselnnpc,
      };
      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token}',
          },
          body: json.encode(data),
        );

        if (response.statusCode == 200) {
          await DatabaseHelper().deleteEnergy(survey.city);
          //ref.read(surveyCountProvider.notifier).refreshSurveyCount();
          //ref.read(historyNotifierProvider.notifier).fetchHistory();
          ref.read(coordinatorHistoryNotifierProvider);
          ref.invalidate(gridDataProvider);
          showSnackBar("Uploaded Survey Successfully");
        } else {
          showSnackBar('Failed To Upload Survey');
        }
      } catch (e) {
        showErrorDialog('Error Uploading Survey: $e');
      }

      setState(() {
        uploadProgress = (i + 1) / energyData.length;
      });
    }
    setState(() {
      isUploading = false;
    });
  }
}
