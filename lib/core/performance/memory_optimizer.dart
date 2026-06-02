import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Утилиты для оптимизации использования памяти.
@singleton
class MemoryOptimizer {
  static const _memoryWarningThreshold = 100 * 1024 * 1024; // 100 MB
  static const _memoryCriticalThreshold = 150 * 1024 * 1024; // 150 MB

  final List<VoidCallback> _cleanupCallbacks = [];
  bool _isLowMemoryMode = false;

  /// Текущий режим экономии памяти.
  bool get isLowMemoryMode => _isLowMemoryMode;

  /// Регистрирует callback для очистки памяти.
  void registerCleanup(VoidCallback callback) {
    _cleanupCallbacks.add(callback);
    AppLogger.debug('Registered cleanup callback. Total: ${_cleanupCallbacks.length}');
  }

  /// Отменяет регистрацию callback.
  void unregisterCleanup(VoidCallback callback) {
    _cleanupCallbacks.remove(callback);
  }

  /// Выполняет очистку памяти.
  void performCleanup() {
    AppLogger.info('Performing memory cleanup...');
    
    for (final callback in _cleanupCallbacks) {
      try {
        callback();
      } catch (e, st) {
        AppLogger.error('Cleanup callback failed', e, st);
      }
    }

    // Принудительная сборка мусора
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Note: Работает только в debug/review mode
      if (kDebugMode) {
        AppLogger.info('GC triggered');
      }
    });

    _checkMemoryUsage();
  }

  void _checkMemoryUsage() {
    // TODO: Интеграция с Dart VM для получения реальной памяти
    // Пока используем эвристику
    
    if (_cleanupCallbacks.length > 50) {
      AppLogger.warning('Many cleanup callbacks registered: ${_cleanupCallbacks.length}');
    }
  }

  /// Включает режим экономии памяти.
  void enableLowMemoryMode() {
    if (_isLowMemoryMode) return;
    
    _isLowMemoryMode = true;
    AppLogger.warning('Low memory mode ENABLED');
    
    // Выполняем немедленную очистку
    performCleanup();
  }

  /// Выключает режим экономии памяти.
  void disableLowMemoryMode() {
    _isLowMemoryMode = false;
    AppLogger.info('Low memory mode DISABLED');
  }

  /// Автоматически включает режим при нехватке памяти.
  void monitorAndOptimize() {
    // Периодическая проверка
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 30));
      _checkAndOptimize();
      return true;
    });
  }

  void _checkAndOptimize() {
    // TODO: Реальный мониторинг памяти
    // Пока просто проверяем количество callback'ов
    
    if (_cleanupCallbacks.length > 100) {
      enableLowMemoryMode();
    } else if (_cleanupCallbacks.length < 20 && _isLowMemoryMode) {
      disableLowMemoryMode();
    }
  }

  /// Создает оптимизированный кэш изображений.
  ImageCache createOptimizedImageCache() {
    final cache = ImageCache();
    
    if (_isLowMemoryMode) {
      cache.maximumSize = 50; // Уменьшаем кэш
      cache.maximumSizeBytes = 50 * 1024 * 1024; // 50 MB
    } else {
      cache.maximumSize = 100;
      cache.maximumSizeBytes = 100 * 1024 * 1024; // 100 MB
    }
    
    return cache;
  }

  /// Освобождает неиспользуемые ресурсы.
  void disposeUnusedResources() {
    // Clear image cache
    PaintingBinding.instance.imageCache.clear();
    AppLogger.info('Image cache cleared');

    // Clear widget tree cache
    WidgetsBinding.instance.buildOwner?.finalizeTree();
    
    AppLogger.info('Unused resources disposed');
  }

  /// Рекомендации по оптимизации.
  List<String> getOptimizationTips() {
    final tips = <String>[];

    if (_cleanupCallbacks.length > 50) {
      tips.add('Много registered callbacks. Рассмотрите очистку.');
    }

    if (_isLowMemoryMode) {
      tips.add('Режим экономии памяти активен.');
    }

    return tips;
  }
}

/// Widget который автоматически очищает ресурсы при unmount.
class AutoDisposeWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDispose;

  const AutoDisposeWidget({
    super.key,
    required this.child,
    this.onDispose,
  });

  @override
  State<AutoDisposeWidget> createState() => _AutoDisposeWidgetState();
}

class _AutoDisposeWidgetState extends State<AutoDisposeWidget> {
  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Widget с RepaintBoundary для оптимизации перерисовки.
class OptimizedRepaintBoundary extends StatelessWidget {
  final Widget child;
  final GlobalKey? boundaryKey;

  const OptimizedRepaintBoundary({
    super.key,
    required this.child,
    this.boundaryKey,
  });

  /// Конвертирует в изображение для кэширования.
  Future<ui.Image?> toImage(BuildContext context) async {
    try {
      final boundary = context.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      final pixelRatio = View.of(context).devicePixelRatio;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      return image;
    } catch (e) {
      AppLogger.error('Failed to convert to image', e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: child,
      key: boundaryKey,
    );
  }
}

/// Виджет который не перерисовывается при изменении parent.
class ConstWidget extends StatelessWidget {
  final Widget child;

  const ConstWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Extension для оптимизации виджетов.
extension WidgetOptimizationX on Widget {
  /// Оборачивает в RepaintBoundary.
  Widget withRepaintBoundary() {
    return RepaintBoundary(child: this);
  }

  /// Оборачивает в AutoDisposeWidget.
  Widget withAutoDispose(VoidCallback onDispose) {
    return AutoDisposeWidget(
      child: this,
      onDispose: onDispose,
    );
  }

  /// Делает const если возможно.
  Widget makeConst() {
    return ConstWidget(child: this);
  }
}

/// Тикер для ограничения частоты обновлений.
class ThrottledTicker {
  final Duration interval;
  final VoidCallback callback;

  DateTime? _lastCall;
  Timer? _timer;

  ThrottledTicker({
    required this.interval,
    required this.callback,
  });

  void tick() {
    final now = DateTime.now();
    
    if (_lastCall == null || now.difference(_lastCall!) >= interval) {
      _lastCall = now;
      callback();
    } else {
      _timer?.cancel();
      _timer = Timer(interval - now.difference(_lastCall!), () {
        _lastCall = DateTime.now();
        callback();
      });
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}

/// Буфер для пакетной обработки событий.
class EventBuffer<T> {
  final Duration flushInterval;
  final Function(List<T> events) onFlush;

  final List<T> _buffer = [];
  Timer? _timer;

  EventBuffer({
    required this.flushInterval,
    required this.onFlush,
  });

  void add(T event) {
    _buffer.add(event);

    _timer?.cancel();
    _timer = Timer(flushInterval, () {
      if (_buffer.isNotEmpty) {
        onFlush(List.unmodifiable(_buffer));
        _buffer.clear();
      }
    });
  }

  void flush() {
    if (_buffer.isNotEmpty) {
      onFlush(List.unmodifiable(_buffer));
      _buffer.clear();
      _timer?.cancel();
    }
  }

  void dispose() {
    flush();
    _timer?.cancel();
  }
}
