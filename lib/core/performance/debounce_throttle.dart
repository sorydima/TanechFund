import 'dart:async';
import 'package:rechain_vc_lab/core/logger.dart';

/// Debounce: откладывает выполнение пока не пройдёт период без новых вызовов.
/// 
/// Полезно для:
/// - Поля поиска (запросы после остановки ввода)
/// - Изменение размера окна (пересчёт layout)
/// - Автосохранение (после паузы в редактировании)
/// 
/// Пример:
/// ```dart
/// final debouncer = Debouncer(delay: Duration(milliseconds: 300));
/// 
/// searchController.addListener(() {
///   debouncer.run(() => search(query));
/// });
/// ```
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  /// Запускает действие с debounce.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, () {
      action();
    });
  }

  /// Запускает async действие с debounce.
  Future<void> runAsync(Future<void> Function() action) async {
    _timer?.cancel();
    final completer = Completer<void>();

    _timer = Timer(delay, () async {
      try {
        await action();
        completer.complete();
      } catch (e, st) {
        completer.completeError(e, st);
      }
    });

    return completer.future;
  }

  /// Немедленная отмена pending действия.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Выполняет действие немедленно и сбрасывает таймер.
  void runNow(VoidCallback action) {
    cancel();
    action();
  }

  void dispose() {
    cancel();
  }
}

/// Throttle: ограничивает выполнение до одного раза за период.
/// 
/// Полезно для:
/// - Скролл события (параллакс, lazy loading)
/// - Клик по кнопкам (защита от double tap)
/// - Rate limiting на клиенте
/// 
/// Пример:
/// ```dart
/// final throttler = Throttler(delay: Duration(milliseconds: 200));
/// 
/// scrollController.addListener(() {
///   throttler.run(() => loadMoreItems());
/// });
/// ```
class Throttler {
  final Duration delay;
  final bool leading; // Выполнять ли сразу при первом вызове

  Timer? _timer;
  bool _canExecute = true;
  Future<void> Function()? _queuedAction;

  Throttler({
    required this.delay,
    this.leading = true,
  });

  /// Запускает действие с throttle.
  void run(VoidCallback action) {
    if (_canExecute) {
      if (leading) {
        action();
        _canExecute = false;
        _timer = Timer(delay, () {
          _canExecute = true;
          // Выполняем queued action если есть
          if (_queuedAction != null) {
            final queued = _queuedAction;
            _queuedAction = null;
            run(queued!);
          }
        });
      } else {
        // Trailing throttle - выполняем в конце периода
        _queuedAction = () async => action();
        if (_timer == null) {
          _timer = Timer(delay, () async {
            if (_queuedAction != null) {
              await _queuedAction!();
              _queuedAction = null;
            }
            _timer = null;
          });
        }
      }
    } else if (!leading) {
      _queuedAction = () async => action();
    }
  }

  /// Запускает async действие с throttle.
  Future<void> runAsync(Future<void> Function() action) async {
    if (_canExecute) {
      if (leading) {
        _canExecute = false;
        try {
          await action();
        } catch (e, st) {
          AppLogger.error('Throttler async action failed', e, st);
        }
        _timer = Timer(delay, () {
          _canExecute = true;
        });
      } else {
        _queuedAction = () async => action();
        if (_timer == null) {
          _timer = Timer(delay, () async {
            if (_queuedAction != null) {
              try {
                await _queuedAction!();
              } catch (e, st) {
                AppLogger.error('Throttler queued async action failed', e, st);
              }
              _queuedAction = null;
            }
            _timer = null;
          });
        }
      }
    }
  }

  /// Немедленная отмена pending действия.
  void cancel() {
    _timer?.cancel();
    _timer = null;
    _queuedAction = null;
  }

  void dispose() {
    cancel();
  }
}

/// RateLimiter на основе timestamp (альтернатива Throttler).
/// 
/// Пример:
/// ```dart
/// final limiter = TimestampRateLimiter(minInterval: Duration(seconds: 1));
/// 
/// button.onPressed = () {
///   if (limiter.canExecute) {
///     performAction();
///   }
/// };
/// ```
class TimestampRateLimiter {
  final Duration minInterval;
  DateTime? _lastExecution;

  TimestampRateLimiter({required this.minInterval});

  /// Можно ли выполнить действие.
  bool get canExecute {
    if (_lastExecution == null) return true;
    return DateTime.now().difference(_lastExecution!) >= minInterval;
  }

  /// Время до следующего доступного выполнения.
  Duration get timeUntilNext => canExecute
      ? Duration.zero
      : minInterval - DateTime.now().difference(_lastExecution!);

  /// Выполняет действие если возможно.
  bool execute(VoidCallback action) {
    if (canExecute) {
      _lastExecution = DateTime.now();
      action();
      return true;
    }
    return false;
  }

  /// Сброс лимитера.
  void reset() {
    _lastExecution = null;
  }
}

/// BatchProcessor: группирует несколько вызовов в один batch.
/// 
/// Полезно для:
/// - Пакетная отправка аналитики
/// - Группировка API запросов
/// - Оптимизация записи в БД
/// 
/// Пример:
/// ```dart
/// final batchProcessor = BatchProcessor<AnalyticsEvent>(
///   maxBatchSize: 10,
///   flushInterval: Duration(seconds: 5),
///   processor: (events) => sendToServer(events),
/// );
/// 
/// batchProcessor.add(event);
/// ```
class BatchProcessor<T> {
  final int maxBatchSize;
  final Duration flushInterval;
  final Future<void> Function(List<T> items) processor;

  final List<T> _buffer = [];
  Timer? _timer;
  bool _isProcessing = false;

  BatchProcessor({
    required this.maxBatchSize,
    required this.flushInterval,
    required this.processor,
  }) {
    _startTimer();
  }

  /// Добавляет элемент в batch.
  void add(T item) {
    _buffer.add(item);

    if (_buffer.length >= maxBatchSize) {
      _flush();
    } else if (_timer == null || !_timer!.isActive) {
      _startTimer();
    }
  }

  /// Добавляет несколько элементов.
  void addAll(Iterable<T> items) {
    _buffer.addAll(items);

    if (_buffer.length >= maxBatchSize) {
      _flush();
    } else if (_timer == null || !_timer!.isActive) {
      _startTimer();
    }
  }

  /// Принудительная отправка batch.
  Future<void> flush() async {
    if (_buffer.isNotEmpty && !_isProcessing) {
      await _flush();
    }
  }

  /// Очистка буфера без отправки.
  void clear() {
    _buffer.clear();
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(flushInterval, () {
      if (!_isProcessing && _buffer.isNotEmpty) {
        _flush();
      }
    });
  }

  Future<void> _flush() async {
    if (_buffer.isEmpty || _isProcessing) return;

    _isProcessing = true;
    final batch = List<T>.from(_buffer);
    _buffer.clear();
    _timer?.cancel();

    try {
      await processor(batch);
    } catch (e, st) {
      AppLogger.error('BatchProcessor: flush failed', e, st);
      // Возвращаем элементы в буфер при ошибке
      _buffer.insertAll(0, batch);
      rethrow;
    } finally {
      _isProcessing = false;
      if (_buffer.isNotEmpty) {
        _startTimer();
      }
    }
  }
}

typedef VoidCallback = void Function();
