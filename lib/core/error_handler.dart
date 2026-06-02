import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Централизованный обработчик ошибок Flutter.
class ErrorHandler {
  static void initialize() {
    // Перехват ошибок во Flutter-фреймворке
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _reportError(details.exception, details.stack);
    };

    // Перехват асинхронных ошибок в зоне приложения
    PlatformDispatcher.instance.onError = (error, stack) {
      _reportError(error, stack);
      return true;
    };
  }

  static void _reportError(Object error, StackTrace? stackTrace) {
    final message = error.toString();
    if (error is AppError) {
      AppLogger.error('[AppError] ${error.message}', error, stackTrace ?? error.stackTrace);
    } else {
      AppLogger.error('[Unhandled] $message', error, stackTrace);
    }
  }

  /// Оборачивает виджет в ErrorWidget с кастомным UI.
  static Widget buildErrorWidget(FlutterErrorDetails details) {
    return Material(
      child: Container(
        color: const Color(0xFF0F0F23),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 64),
              const SizedBox(height: 16),
              Text(
                'Что-то пошло не так',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                kDebugMode
                    ? details.exception.toString()
                    : 'Мы уже работаем над исправлением. Попробуйте перезапустить приложение.',
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => WidgetsBinding.instance.reassembleApplication(),
                icon: const Icon(Icons.refresh),
                label: const Text('Перезагрузить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
