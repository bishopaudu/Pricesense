// ignore_for_file: unused_result

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/model/agent_history_model.dart';
import 'package:pricesense/model/analyst_history_model.dart';
//import 'package:pricesense/model/analyst_history_model.dart';
//import 'package:pricesense/model/analyst_history_model.dart';
import 'package:pricesense/model/coordinator_history_model.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/analyst_details.dart';
import 'package:pricesense/screens/coordinator_history_details.dart';
import 'package:pricesense/screens/details.dart';
import 'package:pricesense/utils/agent_history_service.dart';
import 'package:pricesense/utils/analyst_history_notifier.dart';
//import 'package:pricesense/utils/analyst_history_notifier.dart';
import 'package:pricesense/utils/capitalize.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/agent_history_notifier.dart';
import 'package:pricesense/utils/coordinator_history_notifier.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> filteredHistoryList = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _filterSearchResults(searchController.text);
  }

  void _filterSearchResults(String query) {
    final user = ref.read(userProvider);
    if (user == null) return;

    if (user.role == 'agent') {
      final historyState = ref.watch(historyNotifierProvider);
      historyState.when(
        data: (historyResponse) {
          final historyList = historyResponse.data.history;
          if (query.isEmpty) {
            setState(() {
              filteredHistoryList = historyList;
            });
            return;
          }

          List<HistoryItem> filteredList = historyList.where((item) {
            return item.foodItem.name
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                item.market.name.toLowerCase().contains(query.toLowerCase());
          }).toList();

          setState(() {
            filteredHistoryList = filteredList;
          });
        },
        loading: () => {},
        error: (error, stack) => {},
      );
    } else if (user.role == 'coordinator') {
      final historyState = ref.watch(coordinatorHistoryNotifierProvider);
      historyState.when(
        data: (historyResponse) {
          final historyList = historyResponse.data?.history;
          if (query.isEmpty) {
            setState(() {
              filteredHistoryList = historyList!;
            });
            return;
          }

          List<EnergyHistory> filteredList = historyList!.where((item) {
            return item.city.name.toLowerCase().contains(query.toLowerCase()) ||
                item.coordinator.firstname
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                item.coordinator.lastname
                    .toLowerCase()
                    .contains(query.toLowerCase());
          }).toList();

          setState(() {
            filteredHistoryList = filteredList;
          });
        },
        loading: () => {},
        error: (error, stack) => {},
      );
    }
    if (user.role == 'analyst') {
      final historyState = ref.watch(analystHistoryNotifierProvider);
      historyState.when(
        data: (historyResponse) {
          final List<AnalystHistoryItem> historyList = historyResponse
              .data.history; // Cast the history to the correct type
          if (query.isEmpty) {
            setState(() {
              filteredHistoryList = historyList;
            });
          } else {
            List<AnalystHistoryItem> filteredList = historyList.where((item) {
              return item.title.toLowerCase().contains(query.toLowerCase()) ||
                  item.type.toLowerCase().contains(query.toLowerCase());
            }).toList();

            setState(() {
              filteredHistoryList = filteredList;
            });
          }
        },
        loading: () => {},
        error: (error, stack) => {},
      );
    }
  }

  void analystNavigate(String type, String id) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AnalystDetailsScreen(type: type, id: id)));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    //final formatter = NumberFormat('#,##0');
    final internetStatus = ref.watch(connectivityProvider);
    // var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("History"),
          centerTitle: true,
        ),
        body: const Center(child: Text("User not logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          internetStatus == ConnectivityResult.mobile ||
                  internetStatus == ConnectivityResult.wifi
              ? "History"
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: mainColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: mainColor),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search, color: mainColor),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      _filterSearchResults('');
                    },
                    icon: const Icon(Icons.cancel, color: mainColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: user.role == 'agent'
                ? buildAgentHistory()
                : user.role == 'coordinator'
                    ? buildCoordinatorHistory()
                    : buildAnalystHistory(),
          ),
        ],
      ),
    );
  }

  Widget buildAgentHistory() {
    final historyState = ref.watch(historyNotifierProvider);
    final formatter = NumberFormat('#,##0');
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");

    return historyState.when(
      data: (historyResponse) {
        final historyList = filteredHistoryList.isEmpty
            ? historyResponse.data.history
            : filteredHistoryList;
        final reversedHistoryList = historyList.reversed.toList();

        return historyList.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(historyNotifierProvider);
                },
                child: ListView.builder(
                  // reverse: true,
                  itemCount: reversedHistoryList.length,
                  itemBuilder: (context, index) {
                    final item = reversedHistoryList[index];

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: mainColor,
                        child: Text(
                          item.foodItem.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        item.brand != "No Brands Available"
                            ? '${Capitalize.capitalizeFirstLetter(item.foodItem.name)} - ${item.brand}'
                            : Capitalize.capitalizeFirstLetter(
                                item.foodItem.name),
                      ),
                      /*  title: Text(
                            '${Capitalize.capitalizeFirstLetter(item.foodItem.name)} - ${item.brand}'),*/
                      subtitle: Text(item.measurement),
                      trailing: Text(
                          '${format.currencySymbol}${formatter.format(item.price)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailsScreen(historyItem: item),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            : const Center(child: Text("No recent history"));
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: mainColor)),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No history available'),
            TextButton(
              onPressed: () {
                ref.refresh(historyNotifierProvider);
              },
              child: const Text("Refresh", style: TextStyle(color: mainColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCoordinatorHistory() {
    final historyState = ref.watch(coordinatorHistoryNotifierProvider);

    return historyState.when(
      data: (historyResponse) {
        final historyList = filteredHistoryList.isNotEmpty
            ? filteredHistoryList
            : historyResponse.data!.history!;
        final reversedHistoryList = historyList.reversed.toList();

        return historyList.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(coordinatorHistoryNotifierProvider);
                },
                child: ListView.builder(
                  itemCount: reversedHistoryList.length,
                  itemBuilder: (context, index) {
                    final historyItem = historyList[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoordinatorDetailsScreen(
                              coordhistoryItem: historyItem,
                            ),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        backgroundColor: mainColor,
                        child: Text(
                          historyItem.coordinator.firstname[0].toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(historyItem.coordinator.firstname),
                      subtitle: Text(historyItem.city.name),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Unofficial Exchange Rate"),
                          const SizedBox(height: 4),
                          Text(
                            historyItem.unofficialUsdExchangeRate.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : const Center(child: Text("No recent history"));
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: mainColor)),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Unable to load history'),
            TextButton(
              onPressed: () {
                ref.refresh(coordinatorHistoryNotifierProvider);
              },
              child: const Text("Refresh", style: TextStyle(color: mainColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnalystHistory() {
    final historyState = ref.watch(analystHistoryNotifierProvider);

    return historyState.when(
      data: (historyResponse) {
        final historyList = filteredHistoryList.isNotEmpty
            ? filteredHistoryList
            : historyResponse.data.history;
        final reversedHistoryList = historyList.reversed.toList();
        return historyList.isNotEmpty
            ? RefreshIndicator(
                onRefresh: () async {
                  ref.refresh(analystHistoryNotifierProvider);
                },
                child: ListView.builder(
                  itemCount: reversedHistoryList.length,
                  itemBuilder: (context, index) {
                    final historyItem = historyList[index];
                    return ListTile(
                      onTap: () {
                        analystNavigate(historyItem.type, historyItem.id);
                      },
                      leading: CircleAvatar(
                        backgroundColor: mainColor,
                        child: Text(
                          historyItem.title.substring(0, 1).toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(historyItem.subtitle),
                      subtitle: Text(historyItem.type),
                      trailing: Text(
                          DateFormat('yyyy-MM-dd').format(historyItem.date)),
                    );
                  },
                ),
              )
            : const Center(child: Text("No recent history"));
      },
      loading: () =>
          const Center(child: CircularProgressIndicator(color: mainColor)),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No recent history'),
            TextButton(
              onPressed: () {
                ref.refresh(analystHistoryNotifierProvider);
              },
              child: const Text("Refresh", style: TextStyle(color: mainColor)),
            ),
          ],
        ),
      ),
    );
  }
}
