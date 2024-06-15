import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pricesense/utils/sizes.dart';
import 'package:pricesense/providers/connectivity_provider.dart';

class InternetStatus extends ConsumerWidget {
  const InternetStatus({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityResult = ref.watch(connectivityProvider);

    String status;
    if (connectivityResult == ConnectivityResult.mobile) {
      status = "Connected To Server";
    } else if (connectivityResult == ConnectivityResult.wifi) {
      status = "Connected To Server";
    } else {
      status = "No Internet Access";
    }

    return Row(
      children: [
        Icon(
          connectivityResult == ConnectivityResult.none
              ? Icons.signal_wifi_off
              : Icons.signal_wifi_4_bar,
          size: Sizes.iconSize,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Text(
          status,
          style: const TextStyle(fontSize: 16, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
