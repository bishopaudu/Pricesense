/*import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class InternetStatus extends StatefulWidget {
  const InternetStatus({Key? key}) : super(key: key);

  @override
  _InternetStatusState createState() => _InternetStatusState();
}

class _InternetStatusState extends State<InternetStatus> {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _connectivityResult = result as ConnectivityResult;
      });
    }) as StreamSubscription<ConnectivityResult>;
  }

  Future<void> _checkConnectivity() async {
    ConnectivityResult result = (await Connectivity().checkConnectivity()) as ConnectivityResult;
    setState(() {
      _connectivityResult = result;
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String status;
    if (_connectivityResult == ConnectivityResult.mobile) {
      status = "Connected to Mobile Network";
    } else if (_connectivityResult == ConnectivityResult.wifi) {
      status = "Connected to WiFi";
    } else {
      status = "No Internet Connection";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _connectivityResult == ConnectivityResult.none
                  ? Icons.signal_wifi_off
                  : Icons.signal_wifi_4_bar,
              size: 50,
              color: Colors.teal,
            ),
            SizedBox(height: 10),
            Text(
              status,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}*/