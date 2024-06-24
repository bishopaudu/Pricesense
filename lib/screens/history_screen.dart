import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pricesense/model/agent_history_model.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/screens/details.dart';
import 'package:pricesense/utils/capitalize.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/agent_history_notifier.dart';
import 'package:pricesense/utils/agent_history_service.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final TextEditingController searchController = TextEditingController();
  List<HistoryItem> filteredHistoryList = [];

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
    //final historyAsyncValue = ref.read(historyProvider);
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
  }

  @override
  Widget build(BuildContext context) {
    // final historyAsyncValue = ref.watch(historyProvider);

    final formatter = NumberFormat('#,##0');
    final historyState = ref.watch(historyNotifierProvider);

    final internetStatus = ref.watch(connectivityProvider);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");

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
                    borderSide: const BorderSide(
                      color: mainColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: mainColor,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Search",
                  prefixIcon: const Icon(
                    Icons.search,
                    color: mainColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.clear();
                      _filterSearchResults('');
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: mainColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: historyState.when(
              data: (historyResponse) {
                final historyList = filteredHistoryList.isEmpty
                    ? historyResponse.data.history
                    : filteredHistoryList;
                final reversedHistoryList = historyList.reversed.toList();
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.read(historyProvider);
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
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator(color: mainColor)),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Unable to load history'),
                    TextButton(
                      onPressed: () {
                        ref.read(historyProvider);
                      },
                      child:
                          const Text("Refresh", style: TextStyle(color: mainColor)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
