import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/network/network_manager.dart';
import 'package:rechain_vc_lab/services/storage_service.dart';

/// Менеджер offline-first стратегии.
/// 
/// - Отслеживает сетевое состояние
/// - Кэширует запросы при отсутствии сети
/// - Синхронизирует при восстановлении соединения
class OfflineFirstManager {
  final NetworkManager _networkManager;
  final StorageService _storage;
  
  StreamSubscription<NetworkState>? _networkSubscription;
  final _pendingOperations = <PendingOperation>[];
  bool _isSyncing = false;

  bool get isOnline => _networkManager.isOnline;
  bool get isOffline => _networkManager.isOffline;
  bool get hasPendingOperations => _pendingOperations.isNotEmpty;
  int get pendingCount => _pendingOperations.length;
  bool get isSyncing => _isSyncing;

  static const _pendingKey = 'offline_pending_operations';

  OfflineFirstManager(this._networkManager, this._storage);

  /// Инициализация менеджера.
  Future<void> initialize() async {
    await _networkManager.initialize();
    await _loadPendingOperations();

    _networkSubscription = _networkManager.stateStream.listen(
      _onNetworkStateChanged,
      onError: (e, st) => AppLogger.error('OfflineFirstManager stream error', e, st),
    );

    AppLogger.info('OfflineFirstManager initialized. Online: $isOnline');
  }

  /// Добавление операции в очередь для синхронизации.
  Future<void> queueOperation({
    required String operationId,
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final operation = PendingOperation(
      id: operationId,
      endpoint: endpoint,
      method: method,
      body: body,
      headers: headers,
      timestamp: DateTime.now(),
      retryCount: 0,
    );

    _pendingOperations.add(operation);
    await _savePendingOperations();
    
    AppLogger.info('Operation queued: $operationId ($method $endpoint)');
  }

  /// Запуск синхронизации отложенных операций.
  Future<SyncResult> sync() async {
    if (_isSyncing) return SyncResult.alreadySyncing;
    if (!isOnline) return SyncResult.noConnection;
    if (_pendingOperations.isEmpty) return SyncResult.nothingToSync;

    _isSyncing = true;
    final results = <String, SyncOperationResult>{};
    var successCount = 0;
    var failureCount = 0;

    try {
      // Копируем список для безопасной итерации
      final operations = List<PendingOperation>.from(_pendingOperations);

      for (final operation in operations) {
        if (!isOnline) break;

        try {
          // TODO: Здесь должен быть реальный API вызов
          await Future.delayed(const Duration(milliseconds: 300));
          
          _pendingOperations.removeWhere((o) => o.id == operation.id);
          results[operation.id] = SyncOperationResult.success;
          successCount++;
          
          AppLogger.info('Operation synced: ${operation.id}');
        } catch (e, st) {
          if (operation.retryCount >= 3) {
            _pendingOperations.removeWhere((o) => o.id == operation.id);
            results[operation.id] = SyncOperationResult.maxRetriesExceeded;
            failureCount++;
            AppLogger.error('Operation failed after max retries: ${operation.id}', e, st);
          } else {
            final index = _pendingOperations.indexWhere((o) => o.id == operation.id);
            if (index != -1) {
              _pendingOperations[index] = operation.incrementRetry();
            }
            results[operation.id] = SyncOperationResult.retryScheduled;
            AppLogger.warning('Operation retry scheduled: ${operation.id}');
          }
        }
      }

      await _savePendingOperations();
      
      return SyncResult.partial(
        successCount: successCount,
        failureCount: failureCount,
        remaining: _pendingOperations.length,
        results: results,
      );
    } finally {
      _isSyncing = false;
    }
  }

  /// Очистка всех отложенных операций.
  Future<void> clearPendingOperations() async {
    _pendingOperations.clear();
    await _savePendingOperations();
    AppLogger.info('All pending operations cleared');
  }

  void dispose() {
    _networkSubscription?.cancel();
    AppLogger.debug('OfflineFirstManager disposed');
  }

  void _onNetworkStateChanged(NetworkState state) {
    if (state == NetworkState.online) {
      AppLogger.info('Network restored, starting sync');
      sync();
    } else {
      AppLogger.warning('Network lost, entering offline mode');
    }
  }

  Future<void> _loadPendingOperations() async {
    final result = _storage.get<String>(_pendingKey, '');
    if (result.isSuccess && result.value!.isNotEmpty) {
      try {
        final List<dynamic> jsonList = json.decode(result.value!);
        _pendingOperations.addAll(
          jsonList.map((json) => PendingOperation.fromJson(json)),
        );
      } catch (e, st) {
        AppLogger.error('Failed to load pending operations', e, st);
      }
    }
  }

  Future<void> _savePendingOperations() async {
    try {
      final jsonList = _pendingOperations.map((o) => o.toJson()).toList();
      await _storage.set<String>(_pendingKey, json.encode(jsonList));
    } catch (e, st) {
      AppLogger.error('Failed to save pending operations', e, st);
    }
  }
}

/// Отложенная операция для синхронизации.
class PendingOperation {
  final String id;
  final String endpoint;
  final String method;
  final Map<String, dynamic>? body;
  final Map<String, String>? headers;
  final DateTime timestamp;
  final int retryCount;

  const PendingOperation({
    required this.id,
    required this.endpoint,
    required this.method,
    this.body,
    this.headers,
    required this.timestamp,
    this.retryCount = 0,
  });

  PendingOperation incrementRetry() => PendingOperation(
        id: id,
        endpoint: endpoint,
        method: method,
        body: body,
        headers: headers,
        timestamp: timestamp,
        retryCount: retryCount + 1,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'endpoint': endpoint,
        'method': method,
        'body': body,
        'headers': headers,
        'timestamp': timestamp.toIso8601String(),
        'retryCount': retryCount,
      };

  factory PendingOperation.fromJson(Map<String, dynamic> json) => PendingOperation(
        id: json['id'],
        endpoint: json['endpoint'],
        method: json['method'],
        body: json['body'] != null ? Map<String, dynamic>.from(json['body']) : null,
        headers: json['headers'] != null ? Map<String, String>.from(json['headers']) : null,
        timestamp: DateTime.parse(json['timestamp']),
        retryCount: json['retryCount'] ?? 0,
      );
}

/// Результат синхронизации.
sealed class SyncResult {
  const SyncResult();

  static const SyncResult alreadySyncing = _AlreadySyncing();
  static const SyncResult noConnection = _NoConnection();
  static const SyncResult nothingToSync = _NothingToSync();

  factory SyncResult.partial({
    required int successCount,
    required int failureCount,
    required int remaining,
    required Map<String, SyncOperationResult> results,
  }) = _PartialSync;
}

final class _AlreadySyncing extends SyncResult {
  const _AlreadySyncing();
}

final class _NoConnection extends SyncResult {
  const _NoConnection();
}

final class _NothingToSync extends SyncResult {
  const _NothingToSync();
}

final class _PartialSync extends SyncResult {
  final int successCount;
  final int failureCount;
  final int remaining;
  final Map<String, SyncOperationResult> results;

  const _PartialSync({
    required this.successCount,
    required this.failureCount,
    required this.remaining,
    required this.results,
  });
}

/// Результат синхронизации отдельной операции.
enum SyncOperationResult {
  success,
  retryScheduled,
  maxRetriesExceeded,
}
