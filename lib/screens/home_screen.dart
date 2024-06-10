// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pricesense/components/internet_connect.dart';
import 'package:pricesense/providers/userproviders.dart';
import 'package:pricesense/screens/agent_details.dart';
import 'package:pricesense/screens/category_selection.dart';
import 'package:pricesense/screens/details.dart';
import 'package:pricesense/utils/data.dart';
import 'package:pricesense/utils/sizes.dart';
import 'package:pricesense/screens/history_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String locationState = "";
  String locationCity = "Fetching Location...";
  StreamSubscription<Position>? locationSubscription;
  final ScrollController _scrollController = ScrollController();
  bool _isFabVisible = true;
    Timer? _scrollTimer;


  Future<void> getLocation() async {
    if (await Permission.location.isGranted) {
      await fetchLocation();
    } else {
      var status = await Permission.location.request();
      if (status.isGranted) {
        await fetchLocation();
      } else {
        setState(() {
          locationCity = "Turn on Location Services";
        });
      }
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
        setState(() {
          locationState = placemark.administrativeArea ?? "Error";
          locationCity = placemark.locality ?? "Error";
        });
      }
    } catch (e) {
      setState(() {
        locationCity = "Turn on Location Services";
      });
      print('Error fetching location: $e');
    }
  }

  // Grid list
  final List<Widget> gridItems = [
    _buildGridItem("20", "Completed"),
    _buildGridItem("15", "Pending"),
    _buildGridItem("30", "Report Submitted"),
    _buildGridItem("20", "Uploaded")
  ];

  static Widget _buildGridItem(String number, String label) {
    return Container(
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
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade200,
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
    );
  }

  Future<void> _refreshGrid() async {
    await fetchLocation();
  }

   @override
  void dispose() {
    _scrollController.removeListener(_toggleFabVisibility);
    _scrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
    _scrollController.addListener(_toggleFabVisibility);
  }

    /*void _toggleFabVisibility() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isFabVisible) {
        setState(() {
          _isFabVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isFabVisible) {
        setState(() {
          _isFabVisible = true;
        });
      }
    }
  }*/
   void _toggleFabVisibility() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isFabVisible) {
        setState(() {
          _isFabVisible = false;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isFabVisible) {
        setState(() {
          _isFabVisible = true;
        });
      }
    }

    _scrollTimer?.cancel();
    _scrollTimer = Timer(Duration(milliseconds: 200), () {
      if (_scrollController.position.userScrollDirection == ScrollDirection.idle) {
        setState(() {
          _isFabVisible = true;
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "PriceIntel",
          style: TextStyle(
              color: Color.fromRGBO(76, 194, 201, 1),
              fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AgentDetails()));
          },
          icon: const Icon(
            Icons.account_circle,
            color: Colors.grey,
            size: Sizes.iconSize,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(76, 194, 201, 1), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      floatingActionButton: AnimatedBuilder(
        animation:_scrollController,
        builder: (context,child){
          return _isFabVisible? FloatingActionButton(
                  backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
                  child: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategorySelectionScreen()),
                    );
                  },
                ) : Container();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh:_refreshGrid,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildLocationInfo(ref),
                const SizedBox(height: 10),
                SizedBox(
                  height: 230, // Set a fixed height for the grid view
                  child: GridView.builder(
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable grid scrolling
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 3 / 2,
                    ),
                    itemCount: gridItems.length,
                    itemBuilder: (context, index) {
                      return gridItems[index];
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
                        // widget.onSeeAllPressed();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HistoryScreen()));
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Data.surveyHistory.length,
                  itemBuilder: (context, index) {
                    final item = Data.surveyHistory[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.teal.shade200,
                        child: Text(
                          item['title']!.substring(0, 1),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(item['title']!),
                      subtitle: Text(item['subtitle']!),
                      trailing: Text(item['date']!),
                      onTap: () {
                        // Handle item tap
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const Details()));
                      },
                    );
                  },
                ),
               
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo(WidgetRef ref) {
    final agentUsername = ref.watch(userProvider);
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(76, 193, 201, 1),
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
                  Text('${locationCity},',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white)),
                  const SizedBox(width: 3),
                  Text(locationState,
                      style: const TextStyle(fontSize: 16, color: Colors.white))
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
