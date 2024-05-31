// ignore_for_file: use_super_parameters

/*import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class InternetStatus extends StatefulWidget {
  const InternetStatus({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
        _connectivityResult = result;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    ConnectivityResult result = (await Connectivity().checkConnectivity());
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
      status = "Connected To Server";
    } else if (_connectivityResult == ConnectivityResult.wifi) {
      status = "Connected to WiFi";
    } else {
      status = "No Internet Access";
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(2, 2),
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
              size: 20,
              color: const Color.fromRGBO(76, 194, 201, 1),
            ),
            const SizedBox(height: 10),
            Text(
              status,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'package:pricesense/utils/sizes.dart';

class InternetStatus extends StatefulWidget {
  const InternetStatus({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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
        _connectivityResult = result;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    ConnectivityResult result = (await Connectivity().checkConnectivity());
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
      status = "Connected To Server";
    } else if (_connectivityResult == ConnectivityResult.wifi) {
      status = "Connected To Server";
    } else {
      status = "No Internet Access";
    }

    return Row(
     // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _connectivityResult == ConnectivityResult.none
              ? Icons.signal_wifi_off
              : Icons.signal_wifi_4_bar,
          size: Sizes.iconSize,
          color:Colors.white,
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: const TextStyle(fontSize: 16,color:Colors.white,),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}