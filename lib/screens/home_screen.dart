/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pricesense/components/internet_connect.dart';
import 'package:pricesense/screens/agent_details.dart';
import 'package:pricesense/screens/collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String locationState = "";
  String locationCity = "Fetching Location...";
  StreamSubscription<Position>? locationSubscription;

  Future<void> getLocation() async {
    if (await Permission.location.isGranted) {
      await fetchLocation();
    } else {
      var status = await Permission.location.request();
      if (status.isGranted) {
        await fetchLocation();
      } else {
        _showPermissionDialog();
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
      print('Error fetching location: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission not granted"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // grid list
  final List<Widget> gridItems = [
     _buildGridItem("20", "Collected"),
    _buildGridItem("15", "Commodities Data"),
    _buildGridItem("30", "Uploaded"),
    const InternetStatus()
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
  void initState() {
    super.initState();
    getLocation();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AGENT NAME",
          style: TextStyle(
              color: Color.fromRGBO(76, 194, 201, 1),
              fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AgentDetails()));
            },
            icon:const Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 35,
            )),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help, size: 35, color: Colors.white),
          ),
        ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CollectionScreen()),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLocationInfo(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RefreshIndicator(
                onRefresh: _refreshGrid,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(76, 193, 201, 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.place, color: Colors.white),
              const SizedBox(width: 8),
              Text(locationCity,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(width: 3),
              Text(locationState,
                  style: const TextStyle(fontSize: 16, color: Colors.white))
            ],
          ),
          const Row(
            children: [
              Text("AGENT ID: ",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              Text("74838939944",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }
}

*/

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pricesense/components/internet_connect.dart';
import 'package:pricesense/screens/agent_details.dart';
import 'package:pricesense/screens/collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String locationState = "";
  String locationCity = "Fetching Location...";
  StreamSubscription<Position>? locationSubscription;

  Future<void> getLocation() async {
    if (await Permission.location.isGranted) {
      await fetchLocation();
    } else {
      var status = await Permission.location.request();
      if (status.isGranted) {
        await fetchLocation();
      } else {
        _showPermissionDialog();
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
      print('Error fetching location: $e');
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission not granted"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // Grid list
  final List<Widget> gridItems = [
    _buildGridItem("20", "Collected"),
    _buildGridItem("15", "Commodities Data"),
    _buildGridItem("30", "Uploaded"),
    const InternetStatus(),
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
  void initState() {
    super.initState();
    getLocation();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AGENT NAME",
          style: TextStyle(
              color: Color.fromRGBO(76, 194, 201, 1),
              fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AgentDetails()));
          },
          icon: const Icon(
            Icons.account_circle,
            color: Colors.white,
            size: 35,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help, size: 35, color: Colors.white),
          ),
        ],
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(76, 194, 201, 1),
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CollectionScreen()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLocationInfo(),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refreshGrid,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(76, 193, 201, 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.place, color: Colors.white),
              const SizedBox(width: 8),
              Text(locationCity,
                  style: const TextStyle(fontSize: 16, color: Colors.white)),
              const SizedBox(width: 3),
              Text(locationState,
                  style: const TextStyle(fontSize: 16, color: Colors.white))
            ],
          ),
          const Row(
            children: [
              Text("AGENT ID: ",
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              Text("74838939944",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ],
          )
        ],
      ),
    );
  }
}
