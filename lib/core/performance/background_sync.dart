import 'dart:async';
import 'dart:isolate';
import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/network/network_manager.dart';

/// Сервис фоновой синхронизации данных.
/// Синхронизирует данные в background при наличии сети.
@singleton
class BackgroundSyncService {
  final NetworkManager _networkManager;
  
  Timer? _syncTimer;
  bool _isSyncing = false;
  bool _isEnabled = true;

  // Callback для синхронизации
  final List<Future<void> Function()> _syncCallbacks = [];

  BackgroundSyncService(this._networkManager) {
    _initialize();
  }

  void _initialize() {
    // Подписываемся на изменения сети
    _networkManager.stateStream.listen((state) {
      if (state == NetworkState.online && _isEnabled) {
        syncNow();
      }
    });

    AppLogger.info('BackgroundSyncService initialized');
  }

  /// Запускает периодическую синхронизацию.
  void startPeriodicSync({Duration interval = const Duration(minutes: 5)}) {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(interval, (_) => _performSync());
    AppLogger.info('Periodic sync started with interval: ${interval.inMinutes}min');
  }

  /// Запланировать синхронизацию (вызывается при восстановлении сети).
  void _scheduleSync() {
    if (!_isSyncing) {
      syncNow();
    }
  }

  /// Останавливает периодическую синхронизацию.
  void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    AppLogger.info('Periodic sync stopped');
  }

  /// Добавляет callback для синхронизации.
  void addSyncCallback(Future<void> Function() callback) {
    _syncCallbacks.add(callback);
    AppLogger.debug('Added sync callback. Total: ${_syncCallbacks.length}');
  }

  /// Удаляет callback синхронизации.
  void removeSyncCallback(Future<void> Function() callback) {
    _syncCallbacks.remove(callback);
    AppLogger.debug('Removed sync callback. Total: ${_syncCallbacks.length}');
  }

  /// Выполняет синхронизацию.
  Future<void> _performSync() async {
    if (_isSyncing || !_isEnabled) return;
    
    if (_networkManager.isOffline) {
      AppLogger.info('Sync skipped: offline');
      return;
    }

    _isSyncing = true;
    AppLogger.info('Starting background sync...');

    try {
      for (final callback in _syncCallbacks) {
        try {
          await callback();
        } catch (e, st) {
          AppLogger.error('Sync callback failed', e, st);
        }
      }
      AppLogger.info('Background sync completed');
    } catch (e, st) {
      AppLogger.error('Background sync failed', e, st);
    } finally {
      _isSyncing = false;
    }
  }

  /// Немедленная синхронизация.
  Future<void> syncNow() async {
    await _performSync();
  }

  /// Включение/выключение синхронизации.
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (!enabled) {
      stopPeriodicSync();
    } else {
      startPeriodicSync();
    }
    AppLogger.info('Background sync enabled: $enabled');
  }

  /// Статус синхронизации.
  bool get isSyncing => _isSyncing;
  bool get isEnabled => _isEnabled;

  void dispose() {
    stopPeriodicSync();
    _syncCallbacks.clear();
  }
}
