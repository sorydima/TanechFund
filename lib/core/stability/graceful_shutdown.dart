import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Сервис корректного завершения работы приложения.
/// 
/// Гарантирует:
/// - Сохранение критических данных
/// - Освобождение ресурсов
/// - Корректное закрытие соединений
class GracefulShutdownService {
  final List<ShutdownTask> _tasks = [];
  final Duration _taskTimeout;
  
  bool _isShuttingDown = false;
  DateTime? _shutdownStartTime;

  GracefulShutdownService({
    Duration taskTimeout = const Duration(seconds: 5),
  }) : _taskTimeout = taskTimeout;

  /// Регистрация задачи для выполнения при завершении.
  void registerTask({
    required String name,
    required Future<void> Function() task,
    bool isCritical = false,
  }) {
    _tasks.add(ShutdownTask(
      name: name,
      task: task,
      isCritical: isCritical,
    ));
  }

  /// Завершение работы с выполнением всех задач.
  Future<ShutdownResult> shutdown() async {
    if (_isShuttingDown) {
      return ShutdownResult.alreadyShuttingDown;
    }

    _isShuttingDown = true;
    _shutdownStartTime = DateTime.now();
    final results = <String, TaskResult>{};
    var criticalFailure = false;

    AppLogger.info('Graceful shutdown started. Tasks: ${_tasks.length}');

    try {
      for (final task in _tasks) {
        if (criticalFailure && !task.isCritical) {
          results[task.name] = TaskResult.skipped;
          continue;
        }

        try {
          await task.task().timeout(_taskTimeout);
          results[task.name] = TaskResult.success;
          AppLogger.debug('Task completed: ${task.name}');
        } on TimeoutException {
          results[task.name] = TaskResult.timeout;
          AppLogger.error('Task timeout: ${task.name}');
          if (task.isCritical) criticalFailure = true;
        } catch (e, st) {
          results[task.name] = TaskResult.failure(e.toString());
          AppLogger.error('Task failed: ${task.name}', e, st);
          if (task.isCritical) criticalFailure = true;
        }
      }

      final duration = DateTime.now().difference(_shutdownStartTime!);
      AppLogger.info('Graceful shutdown completed in ${duration.inMilliseconds}ms');

      return ShutdownResult.completed(
        results: results,
        duration: duration,
        hasCriticalFailure: criticalFailure,
      );
    } finally {
      _isShuttingDown = false;
    }
  }

  /// Принудительное завершение работы.
  void forceExit() {
    AppLogger.warning('Force exit triggered');
    _tasks.clear();
  }
}

/// Задача для выполнения при завершении.
class ShutdownTask {
  final String name;
  final Future<void> Function() task;
  final bool isCritical;

  ShutdownTask({
    required this.name,
    required this.task,
    this.isCritical = false,
  });
}

/// Результат завершения задачи.
sealed class TaskResult {
  const TaskResult();
  
  static const TaskResult success = _Success();
  static const TaskResult skipped = _Skipped();
  static const TaskResult timeout = _Timeout();
  const factory TaskResult.failure(String error) = _Failure;
}

final class _Success extends TaskResult {
  const _Success();
}

final class _Skipped extends TaskResult {
  const _Skipped();
}

final class _Timeout extends TaskResult {
  const _Timeout();
}

final class _Failure extends TaskResult {
  final String error;
  const _Failure(this.error);
}

/// Результат завершения работы.
sealed class ShutdownResult {
  const ShutdownResult();
  
  static const ShutdownResult alreadyShuttingDown = _AlreadyShuttingDown();
  
  const factory ShutdownResult.completed({
    required Map<String, TaskResult> results,
    required Duration duration,
    required bool hasCriticalFailure,
  }) = _Completed;
}

final class _AlreadyShuttingDown extends ShutdownResult {
  const _AlreadyShuttingDown();
}

final class _Completed extends ShutdownResult {
  final Map<String, TaskResult> results;
  final Duration duration;
  final bool hasCriticalFailure;

  const _Completed({
    required this.results,
    required this.duration,
    required this.hasCriticalFailure,
  });
}
