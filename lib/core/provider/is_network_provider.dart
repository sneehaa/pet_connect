import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/legacy.dart';

enum ConnectivityStatus { notDetermined, isConnected, isDisconnected }

final connectivityStatusProvider =
    StateNotifierProvider<ConnectivityStatusNotifier, ConnectivityStatus>(
      (ref) => ConnectivityStatusNotifier(),
    );

class ConnectivityStatusNotifier extends StateNotifier<ConnectivityStatus> {
  late ConnectivityStatus lastResult;
  late ConnectivityStatus newState;

  ConnectivityStatusNotifier() : super(ConnectivityStatus.isConnected) {
    lastResult = state;

    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      bool isConnected = results.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi,
      );
      newState = isConnected
          ? ConnectivityStatus.isConnected
          : ConnectivityStatus.isDisconnected;
      if (newState != lastResult) {
        state = newState;
        lastResult = newState;
      }
    });
  }
}
