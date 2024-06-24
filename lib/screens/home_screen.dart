import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pricesense/components/internet_connect.dart';
import 'package:pricesense/providers/connectivity_provider.dart';
import 'package:pricesense/providers/survey_count_provider.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/analyst_details.dart';
import 'package:pricesense/screens/coordinator_history_details.dart';
import 'package:pricesense/screens/details.dart';
import 'package:pricesense/screens/local_store.dart';
import 'package:pricesense/utils/analyst_history_notifier.dart';
import 'package:pricesense/utils/bottombar_notifier.dart';
import 'package:pricesense/utils/capitalize.dart';
import 'package:pricesense/utils/colors.dart';
import 'package:pricesense/utils/agent_history_notifier.dart';
import 'package:pricesense/utils/coordinator_history_notifier.dart';
import 'package:pricesense/utils/grid_data_service.dart';
import 'package:pricesense/utils/sizes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String locationState = "";
  String locationCity = "Fetching Location...";
  StreamSubscription<Position>? locationSubscription;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  int pendingSurveyCount = 0;
  bool hasFetchedLocation = false;

  Future<void> getLocation() async {
    if (!hasFetchedLocation) {
      // Check if location is already fetched
      if (await Permission.location.isGranted) {
        await fetchLocation();
      } else {
        var status = await Permission.location.request();
        if (status.isGranted) {
          await fetchLocation();
        } else {
          if (mounted) {
            setState(() {
              locationState = "Turn on Location Services";
            });
          }
        }
      }
      hasFetchedLocation = true; // Set flag to true after fetching location
    }
  }

  Future<void> fetchLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        if (mounted) {
          setState(() {
            locationState = placemark.administrativeArea ?? "Error";
            locationCity = placemark.locality ?? "Error";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          locationCity = "Turn on Location Services";
        });
      }
      print('Error fetching location: $e');
    }
  }

  static Widget _buildGridItem(String number, String label) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refreshGrid() async {
    await fetchLocation();
    ref.read(historyNotifierProvider.notifier).fetchHistory();
    ref.invalidate(gridDataProvider);
    ref.refresh(coordinatorHistoryNotifierProvider);
  }

  @override
  void initState() {
    super.initState();
    getLocation();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        ref.read(historyNotifierProvider.notifier).fetchHistory();
        ref.refresh(coordinatorHistoryNotifierProvider);
        ref.invalidate(gridDataProvider);
        print('fetching again hsitory');
      }
    });
    Connectivity().checkConnectivity().then((result) {
      if (result != ConnectivityResult.none) {
        ref.invalidate(gridDataProvider);
        print('fetching again');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0');
    final gridDataState = ref.watch(gridDataProvider);
    final internetStatus = ref.watch(connectivityProvider);
    final user = ref.watch(userProvider);

    final historyState = ref.watch(historyNotifierProvider);
    final coordHistory = ref.watch(coordinatorHistoryNotifierProvider);
    final analystHistory = ref.watch(analystHistoryNotifierProvider);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: "NGN");

    ref.listen<int>(surveyCountProvider, (previous, next) {
      setState(() {
        pendingSurveyCount = next;
      });
    });
    final List<Widget> gridItems = [
      _buildGridItem("0", "Completed"),
      _buildGridItem('0', "Review Submitted"),
      _buildGridItem("0", "Uploaded"),
      _buildGridItem('$pendingSurveyCount', "Pending")
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PriceSenseNG",
          style: TextStyle(color: mainColor, fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            ref.read(bottomNavProvider.notifier).setIndex(3);
          },
          icon: const Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: Sizes.iconSize,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SurveyListScreen()),
              );
            },
            icon: const Icon(
              Icons.pending_actions,
              color: Colors.grey,
              size: Sizes.iconSize,
            ),
          ),
        ],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [mainColor, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          ref.read(bottomNavProvider.notifier).setIndex(1);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            _refreshGrid;
            await ref.read(historyNotifierProvider.notifier).fetchHistory();
            ref.invalidate(gridDataProvider);
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildLocationInfo(ref),
                    const SizedBox(height: 18),
                    internetStatus == ConnectivityResult.mobile ||
                            internetStatus == ConnectivityResult.wifi
                        ? gridDataState.when(
                            data: (gridData) {
                              return SizedBox(
                                height: constraints.maxWidth > 600
                                    ? constraints.maxHeight * 0.4
                                    : constraints.maxHeight *
                                        0.4, // Adjust based on screen size
                                child: GridView(
                                  physics:
                                      const NeverScrollableScrollPhysics(), // Disable grid scrolling
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        constraints.maxWidth > 600 ? 4 : 2,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio:
                                        constraints.maxWidth > 600 ? 1 : 3 / 2,
                                  ),
                                  children: [
                                    _buildGridItem(
                                        gridData.completed.toString(),
                                        "Completed"),
                                    _buildGridItem(
                                        gridData.submitted.toString(),
                                        "Review Submitted"),
                                    _buildGridItem(gridData.uploaded.toString(),
                                        "Uploaded"),
                                    _buildGridItem(
                                        '$pendingSurveyCount', "Pending"),
                                  ],
                                ),
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: mainColor,
                              ),
                            ),
                            error: (err, stack) => Center(
                              child: Text('Error: $err'),
                            ),
                          )
                        : SizedBox(
                            height: constraints.maxWidth > 600
                                ? constraints.maxHeight * 0.4
                                : constraints.maxHeight *
                                    0.4, // Adjust based on screen size
                            child: GridView.builder(
                              physics:
                                  const NeverScrollableScrollPhysics(), // Disable grid scrolling
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    constraints.maxWidth > 600 ? 4 : 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio:
                                    constraints.maxWidth > 600 ? 1 : 3 / 2,
                              ),
                              itemCount: gridItems.length,
                              itemBuilder: (context, index) {
                                return gridItems[index];
                              },
                            ),
                          ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recents',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(bottomNavProvider.notifier).setIndex(2);
                          },
                          child: const Text('See All',
                              style: TextStyle(color: mainColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    user!.role == "agent"
                        ? historyState.when(
                            data: (historyResponse) {
                              final reversedHistoryList = historyResponse
                                  .data.history.reversed
                                  .toList();
                              final historyList =
                                  reversedHistoryList.take(3).toList();
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: historyList.length,
                                itemBuilder: (context, index) {
                                  final item = historyList[index];

                                  return reversedHistoryList.isEmpty
                                      ? const Center(
                                          child: Text("No history avaliable"))
                                      : ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: mainColor,
                                            child: Text(
                                              item.foodItem.name
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          title: Text(
                                            item.brand != "No Brands Available"
                                                ? '${Capitalize.capitalizeFirstLetter(item.foodItem.name)} - ${item.brand}'
                                                : Capitalize
                                                    .capitalizeFirstLetter(
                                                        item.foodItem.name),
                                          ),
                                          subtitle: Text(item.measurement),
                                          trailing: Text(
                                              '${format.currencySymbol}${formatter.format(item.price)}'),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsScreen(
                                                        historyItem: item),
                                              ),
                                            );
                                          },
                                        );
                                },
                              );
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator(
                                    color: mainColor)),
                            error: (error, stack) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('No history available'),
                                  TextButton(
                                    onPressed: () {
                                      ref.refresh(historyNotifierProvider);
                                    },
                                    child: const Text("Refresh",
                                        style: TextStyle(color: mainColor)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : user.role == 'coordinator' ? coordHistory.when(
                            data: (historyResponse) {
                              final reversedHistoryList = historyResponse
                                  .data!.history!.reversed
                                  .toList();
                              final historyList =
                                  reversedHistoryList.take(3).toList();
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: historyList.length,
                                itemBuilder: (context, index) {
                                  final item = historyList[index];

                                  return reversedHistoryList.isEmpty
                                      ? const Center(
                                          child: Text("No history avaliable"))
                                      : ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: mainColor,
                                            child: Text(
                                              item.city.name
                                                  .substring(0, 1)
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          title: Text(
                                              '${item.coordinator.firstname} ${item.coordinator.lastname}'),
                                          subtitle: Text(item
                                              .unofficialUsdExchangeRate
                                              .toString()),
                                          trailing:
                                              Text('city-${item.city.name}'),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CoordinatorDetailsScreen(
                                                  coordhistoryItem: item,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                },
                              );
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator(
                                    color: mainColor)),
                            error: (error, stack) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Unable to load history'),
                                  TextButton(
                                    onPressed: () {
                                      ref.refresh(
                                          coordinatorHistoryNotifierProvider);
                                    },
                                    child: const Text("Refresh",
                                        style: TextStyle(color: mainColor)),
                                  ),
                                ],
                              ),
                            ),
                          ) : analystHistory.when(
                            data: (historyResponse) {
                              final reversedHistoryList = historyResponse
                                  .data!.history!.reversed
                                  .toList();
                              final historyList =
                                  reversedHistoryList.take(3).toList();
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: historyList.length,
                                itemBuilder: (context, index) {
                                  final item = historyList[index];

                                  return reversedHistoryList.isEmpty
                                      ? const Center(
                                          child: Text("No history avaliable"))
                                      : ListTile(
                                          title: Text(item.title),
                                          subtitle: Text(item.subtitle
                                              ),
                                          trailing:
                                              Text( DateFormat('yyyy-MM-dd').format(item.date)),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                   AnalystDetailsScreen(
                                                  id: item.id,type: item.type,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                        
                                },
                              );
                            },
                            loading: () => const Center(
                                child: CircularProgressIndicator(
                                    color: mainColor)),
                            error: (error, stack) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('No history availiable'),
                                  TextButton(
                                    onPressed: () {
                                      ref.refresh(
                                          coordinatorHistoryNotifierProvider);
                                    },
                                    child: const Text("Refresh",
                                        style: TextStyle(color: mainColor)),
                                  ),
                                ],
                              ),
                            ),
                          )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo(WidgetRef ref) {
    final agentUsername = ref.watch(userProvider);
    String formattedLocation;
    if (locationCity.isNotEmpty && locationState.isNotEmpty) {
      formattedLocation = '$locationCity, $locationState State';
    } else {
      formattedLocation =
          locationCity.isNotEmpty ? locationCity : locationState;
    }
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: mainColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.place,
                      color: Colors.white, size: Sizes.iconSize),
                  const SizedBox(width: 8),
                  Text(formattedLocation,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
              const SizedBox(width: 8),
              const InternetStatus(),
              const SizedBox(width: 8),
              Row(children: [
                const Text("Agent ID:",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
                const SizedBox(width: 3),
                Text(agentUsername!.username,
                    style: const TextStyle(fontSize: 16, color: Colors.white))
              ]),
            ],
          ),
        ],
      ),
    );
  }
}
