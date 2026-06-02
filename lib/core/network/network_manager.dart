import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Менеджер сетевого состояния с поддержкой offline/online transitions.
class NetworkManager {
  final Connectivity _connectivity;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  final _controller = StreamController<NetworkState>.broadcast();
  NetworkState _currentState = NetworkState.unknown;

  Stream<NetworkState> get stateStream => _controller.stream;
  NetworkState get currentState => _currentState;
  bool get isOnline => _currentState == NetworkState.online;
  bool get isOffline => _currentState == NetworkState.offline;

  NetworkManager({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  Future<void> initialize() async {
    final results = await _connectivity.checkConnectivity();
    _updateState(results);

    _subscription = _connectivity.onConnectivityChanged.listen(
      _updateState,
      onError: (e, st) => AppLogger.error('NetworkManager stream error', e, st),
    );
  }

  void _updateState(List<ConnectivityResult> results) {
    final newState = results.contains(ConnectivityResult.none)
        ? NetworkState.offline
        : NetworkState.online;

    if (newState != _currentState) {
      _currentState = newState;
      _controller.add(newState);
      AppLogger.info('Network state changed: ${newState.name}');
    }
  }

  Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } catch (e, st) {
      AppLogger.error('Internet check failed', e, st);
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}

enum NetworkState { unknown, online, offline }
