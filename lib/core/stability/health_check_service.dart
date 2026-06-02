import 'dart:async';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/network/network_manager.dart';
import 'package:rechain_vc_lab/core/storage/cache_service.dart';
import 'package:rechain_vc_lab/services/storage_service.dart';

/// Статус компонента.
enum ComponentStatus {
  /// Компонент работает нормально
  healthy,

  /// Компонент деградировал (работает с ограничениями)
  degraded,

  /// Компонент неработоспособен
  unhealthy,

  /// Статус неизвестен
  unknown,
}

/// Результат проверки здоровья компонента.
class HealthCheckResult {
  final String componentName;
  final ComponentStatus status;
  final String? message;
  final Duration responseTime;
  final DateTime timestamp;

  const HealthCheckResult({
    required this.componentName,
    required this.status,
    this.message,
    required this.responseTime,
    required this.timestamp,
  });

  bool get isHealthy => status == ComponentStatus.healthy;
  bool get isDegraded => status == ComponentStatus.degraded;
  bool get isUnhealthy => status == ComponentStatus.unhealthy;

  Map<String, dynamic> toJson() => {
    'component': componentName,
    'status': status.name,
    'message': message,
    'responseTimeMs': responseTime.inMilliseconds,
    'timestamp': timestamp.toIso8601String(),
  };
}

/// Общий статус здоровья приложения.
class HealthStatus {
  final ComponentStatus overallStatus;
  final List<HealthCheckResult> componentResults;
  final DateTime timestamp;

  const HealthStatus({
    required this.overallStatus,
    required this.componentResults,
    required this.timestamp,
  });

  bool get isHealthy => overallStatus == ComponentStatus.healthy;
  bool get isDegraded => overallStatus == ComponentStatus.degraded;
  bool get isUnhealthy => overallStatus == ComponentStatus.unhealthy;

  int get healthyComponents => componentResults.where((r) => r.isHealthy).length;
  int get totalComponents => componentResults.length;

  Map<String, dynamic> toJson() => {
    'overallStatus': overallStatus.name,
    'healthyComponents': healthyComponents,
    'totalComponents': totalComponents,
    'timestamp': timestamp.toIso8601String(),
    'components': componentResults.map((r) => r.toJson()).toList(),
  };
}

/// Чекер здоровья компонента.
typedef HealthChecker = Future<HealthCheckResult> Function();

/// Сервис мониторинга здоровья приложения.
/// 
/// Пример использования:
/// ```dart
/// final healthCheck = HealthCheckService(networkManager, storageService, cacheService);
/// await healthCheck.initialize();
/// 
/// // Получение текущего статуса
/// final status = await healthCheck.checkHealth();
/// if (!status.isHealthy) {
///   print('App health degraded: ${status.componentResults}');
/// }
/// 
/// // Подписка на изменения статуса
/// healthCheck.statusStream.listen((status) {
///   print('Health status changed: ${status.overallStatus}');
/// });
/// ```
class HealthCheckService {
  final NetworkManager _networkManager;
  final StorageService _storageService;
  final CacheService? _cacheService;

  final Map<String, HealthChecker> _customCheckers = {};
  final _statusController = StreamController<HealthStatus>.broadcast();
  Timer? _periodicCheckTimer;

  Stream<HealthStatus> get statusStream => _statusController.stream;
  HealthStatus? _lastStatus;

  HealthCheckService(
    this._networkManager,
    this._storageService,
    this._cacheService,
  );

  /// Инициализация сервиса.
  Future<void> initialize({Duration? checkInterval}) async {
    AppLogger.info('HealthCheckService initialized');

    if (checkInterval != null) {
      _periodicCheckTimer = Timer.periodic(checkInterval, (_) => _performHealthCheck());
    }

    // Первая проверка
    await _performHealthCheck();
  }

  /// Регистрация кастомного чекера.
  void registerChecker(String componentName, HealthChecker checker) {
    _customCheckers[componentName] = checker;
    AppLogger.debug('HealthCheckService: registered checker for $componentName');
  }

  /// Удаление кастомного чекера.
  void unregisterChecker(String componentName) {
    _customCheckers.remove(componentName);
  }

  /// Выполнение проверки здоровья всех компонентов.
  Future<HealthStatus> checkHealth() async {
    return await _performHealthCheck();
  }

  /// Очистка ресурсов.
  void dispose() {
    _periodicCheckTimer?.cancel();
    _statusController.close();
    AppLogger.debug('HealthCheckService disposed');
  }

  // Private

  Future<HealthStatus> _performHealthCheck() async {
    final timestamp = DateTime.now();
    final results = <HealthCheckResult>[];

    // Проверка сети
    results.add(await _checkNetwork());

    // Проверка storage
    results.add(await _checkStorage());

    // Проверка cache (если доступен)
    if (_cacheService != null) {
      results.add(await _checkCache());
    }

    // Проверка кастомных чекеров
    for (final entry in _customCheckers.entries) {
      try {
        results.add(await entry.value());
      } catch (e, st) {
        AppLogger.error('HealthCheckService: custom checker ${entry.key} failed', e, st);
        results.add(HealthCheckResult(
          componentName: entry.key,
          status: ComponentStatus.unhealthy,
          message: 'Checker failed: $e',
          responseTime: Duration.zero,
          timestamp: timestamp,
        ));
      }
    }

    // Определение общего статуса
    final overallStatus = _calculateOverallStatus(results);

    _lastStatus = HealthStatus(
      overallStatus: overallStatus,
      componentResults: results,
      timestamp: timestamp,
    );

    _statusController.add(_lastStatus!);

    if (!_lastStatus!.isHealthy) {
      AppLogger.warning('HealthCheckService: Overall status is ${overallStatus.name}');
      for (final result in results) {
        if (!result.isHealthy) {
          AppLogger.warning('  - ${result.componentName}: ${result.status.name} (${result.message})');
        }
      }
    }

    return _lastStatus!;
  }

  Future<HealthCheckResult> _checkNetwork() async {
    final stopwatch = Stopwatch()..start();

    try {
      final hasAccess = await _networkManager.hasInternetAccess();
      final responseTime = stopwatch.elapsed;

      if (hasAccess && _networkManager.isOnline) {
        return HealthCheckResult(
          componentName: 'Network',
          status: ComponentStatus.healthy,
          message: 'Network available',
          responseTime: responseTime,
          timestamp: DateTime.now(),
        );
      } else if (_networkManager.isOnline) {
        return HealthCheckResult(
          componentName: 'Network',
          status: ComponentStatus.degraded,
          message: 'Connected but no internet access',
          responseTime: responseTime,
          timestamp: DateTime.now(),
        );
      } else {
        return HealthCheckResult(
          componentName: 'Network',
          status: ComponentStatus.unhealthy,
          message: 'No network connection',
          responseTime: responseTime,
          timestamp: DateTime.now(),
        );
      }
    } catch (e, st) {
      return HealthCheckResult(
        componentName: 'Network',
        status: ComponentStatus.unhealthy,
        message: 'Check failed: $e',
        responseTime: stopwatch.elapsed,
        timestamp: DateTime.now(),
      );
    }
  }

  Future<HealthCheckResult> _checkStorage() async {
    final stopwatch = Stopwatch()..start();

    try {
      const testKey = '_health_check_storage';
      const testValue = 'health_check';

      await _storageService.set<String>(testKey, testValue);
      final result = _storageService.get<String>(testKey, '');
      await _storageService.remove(testKey);

      final responseTime = stopwatch.elapsed;

      if (result.isSuccess && result.value == testValue) {
        return HealthCheckResult(
          componentName: 'Storage',
          status: ComponentStatus.healthy,
          message: 'Storage operational',
          responseTime: responseTime,
          timestamp: DateTime.now(),
        );
      } else {
        return HealthCheckResult(
          componentName: 'Storage',
          status: ComponentStatus.degraded,
          message: 'Storage read/write inconsistency',
          responseTime: responseTime,
          timestamp: DateTime.now(),
        );
      }
    } catch (e, st) {
      return HealthCheckResult(
        componentName: 'Storage',
        status: ComponentStatus.unhealthy,
        message: 'Storage check failed: $e',
        responseTime: stopwatch.elapsed,
        timestamp: DateTime.now(),
      );
    }
  }

  Future<HealthCheckResult> _checkCache() async {
    final stopwatch = Stopwatch()..start();

    try {
      if (_cacheService == null || !_cacheService!.isInitialized) {
        return HealthCheckResult(
          componentName: 'Cache',
          status: ComponentStatus.unknown,
          message: 'Cache not initialized',
          responseTime: stopwatch.elapsed,
          timestamp: DateTime.now(),
        );
      }

      const testKey = '_health_check_cache';
      const testValue = 'health_check';

      await _cacheService!.set(testKey, testValue, ttl: const Duration(seconds: 1));
      final result = await _cacheService!.get<String>(testKey);
      await _cacheService!.remove(testKey);

      final responseTime = stopwatch.elapsed;

      if (result.isSuccess && result.value == testValue) {
        return HealthCheckResult(
          componentName: 'Cache',
          status: ComponentStatus.healthy,
          message: 'Cache operational',
          responseTime: responseTime,
          timestamp: DateTime.now(),
        );
      } else {
        return HealthCheckResult(
          componentName: 'Cache',
          status: ComponentStatus.degraded,
          message: 'Cache read/write inconsistency',
          responseTime: responseTime,
          timestamp: DateTime.now(),
        );
      }
    } catch (e, st) {
      return HealthCheckResult(
        componentName: 'Cache',
        status: ComponentStatus.unhealthy,
        message: 'Cache check failed: $e',
        responseTime: stopwatch.elapsed,
        timestamp: DateTime.now(),
      );
    }
  }

  ComponentStatus _calculateOverallStatus(List<HealthCheckResult> results) {
    if (results.isEmpty) return ComponentStatus.unknown;

    final hasUnhealthy = results.any((r) => r.isUnhealthy);
    final hasDegraded = results.any((r) => r.isDegraded);
    final allHealthy = results.every((r) => r.isHealthy);

    if (hasUnhealthy) return ComponentStatus.unhealthy;
    if (hasDegraded) return ComponentStatus.degraded;
    if (allHealthy) return ComponentStatus.healthy;

    return ComponentStatus.unknown;
  }
}
