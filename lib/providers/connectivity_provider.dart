import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, ConnectivityResult>(
  (ref) => ConnectivityNotifier(),
);

class ConnectivityNotifier extends StateNotifier<ConnectivityResult> {
  late StreamSubscription<ConnectivityResult> _subscription;

  ConnectivityNotifier() : super(ConnectivityResult.none) {
    _checkConnectivity();
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      state = result;
    });
  }

  Future<void> _checkConnectivity() async {
    ConnectivityResult result = await Connectivity().checkConnectivity();
    state = result;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
