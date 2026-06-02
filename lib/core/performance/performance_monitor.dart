import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Мониторинг производительности приложения.
/// Отслеживает FPS, build time, memory usage.
@singleton
class PerformanceMonitor {
  final List<PerformanceMetric> _metrics = [];
  Timer? _fpsTimer;
  bool _isMonitoring = false;

  // FPS tracking
  int _frameCount = 0;
  double _currentFps = 0;
  DateTime? _lastFrameTime;

  // Build time tracking
  final Map<String, Duration> _buildTimes = {};
  final Map<String, int> _buildCounts = {};

  // Memory tracking
  int _lastMemoryUsage = 0;

  /// Текущий FPS
  double get currentFps => _currentFps;

  /// Средний build time
  Map<String, Duration> get averageBuildTimes {
    final result = <String, Duration>{};
    for (final entry in _buildTimes.entries) {
      final count = _buildCounts[entry.key] ?? 1;
      result[entry.key] = Duration(
        microseconds: entry.value.inMicroseconds ~/ count,
      );
    }
    return result;
  }

  /// Запускает мониторинг.
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _startFpsTracking();
    _startMemoryTracking();

    AppLogger.info('Performance monitoring started');
  }

  /// Останавливает мониторинг.
  void stopMonitoring() {
    _isMonitoring = false;
    _fpsTimer?.cancel();
    _fpsTimer = null;

    AppLogger.info('Performance monitoring stopped');
  }

  /// Отслеживание FPS.
  void _startFpsTracking() {
    _fpsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _currentFps = _frameCount.toDouble();
      _frameCount = 0;

      if (_currentFps < 30) {
        AppLogger.warning('Low FPS detected: $_currentFps');
      }
    });

    WidgetsBinding.instance.addTimingsCallback((timings) {
      if (!_isMonitoring) return;
      _frameCount += timings.length;
    });
  }

  /// Отслеживание памяти.
  void _startMemoryTracking() {
    Timer.periodic(const Duration(seconds: 10), (_) {
      if (!_isMonitoring) return;
      _checkMemoryUsage();
    });
  }

  void _checkMemoryUsage() {
    try {
      // Note: Работает только в debug mode
      if (kDebugMode) {
        final memoryInfo = developer.Service.getInfo();
        // TODO: Получить реальные данные о памяти
      }
    } catch (e) {
      // Мониторинг памяти недоступен в release
    }
  }

  /// Измеряет время построения виджета.
  Widget trackBuildTime(String widgetName, Widget widget) {
    if (!_isMonitoring) return widget;

    final stopwatch = Stopwatch()..start();

    return Builder(
      builder: (context) {
        stopwatch.stop();
        _recordBuildTime(widgetName, stopwatch.elapsed);
        return widget;
      },
    );
  }

  void _recordBuildTime(String widgetName, Duration duration) {
    _buildTimes[widgetName] = (_buildTimes[widgetName] ?? Duration.zero) + duration;
    _buildCounts[widgetName] = (_buildCounts[widgetName] ?? 0) + 1;

    if (duration.inMilliseconds > 16) { // > 1 frame at 60fps
      AppLogger.warning('Slow build: $widgetName took ${duration.inMilliseconds}ms');
    }
  }

  /// Добавляет метрику.
  void recordMetric(String name, double value, {String? unit}) {
    final metric = PerformanceMetric(
      name: name,
      value: value,
      unit: unit,
      timestamp: DateTime.now(),
    );
    _metrics.add(metric);

    if (_metrics.length > 1000) {
      _metrics.removeAt(0); // Keep last 1000 metrics
    }

    AppLogger.debug('Metric recorded: $name = $value ${unit ?? ''}');
  }

  /// Получает метрики по имени.
  List<PerformanceMetric> getMetrics(String name) {
    return _metrics.where((m) => m.name == name).toList();
  }

  /// Генерирует отчёт о производительности.
  Map<String, dynamic> generateReport() {
    return {
      'fps': {
        'current': _currentFps,
        'status': _currentFps >= 55 ? 'good' : _currentFps >= 30 ? 'fair' : 'poor',
      },
      'build_times': averageBuildTimes.map(
        (key, value) => MapEntry(key, '${value.inMicroseconds / 1000}ms'),
      ),
      'total_metrics': _metrics.length,
      'memory': {
        'last_usage_mb': _lastMemoryUsage ~/ 1024 ~/ 1024,
      },
    };
  }

  /// Очищает все метрики.
  void clearMetrics() {
    _metrics.clear();
    _buildTimes.clear();
    _buildCounts.clear();
    AppLogger.info('Performance metrics cleared');
  }

  void dispose() {
    stopMonitoring();
    clearMetrics();
  }
}

/// Модель метрики производительности.
class PerformanceMetric {
  final String name;
  final double value;
  final String? unit;
  final DateTime timestamp;

  const PerformanceMetric({
    required this.name,
    required this.value,
    this.unit,
    required this.timestamp,
  });

  @override
  String toString() => 'PerformanceMetric($name: $value ${unit ?? ''} @ $timestamp)';
}

/// Widget для отслеживания build time.
class PerformanceWidget extends StatelessWidget {
  final String name;
  final Widget child;
  final PerformanceMonitor? monitor;

  const PerformanceWidget({
    super.key,
    required this.name,
    required this.child,
    this.monitor,
  });

  @override
  Widget build(BuildContext context) {
    final stopwatch = Stopwatch()..start();
    
    return Builder(
      builder: (context) {
        stopwatch.stop();
        
        final perfMonitor = monitor ?? PerformanceMonitor();
        perfMonitor.recordMetric(
          '${name}_build_time',
          stopwatch.elapsedMicroseconds.toDouble(),
          unit: 'μs',
        );
        
        return child;
      },
    );
  }
}
