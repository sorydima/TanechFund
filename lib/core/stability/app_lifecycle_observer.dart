import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Наблюдатель за жизненным циклом приложения.
/// 
/// Управляет:
/// - Сохранением состояния при сворачивании
/// - Восстановлением при возврате
/// - Корректным освобождением ресурсов
class AppLifecycleObserver extends WidgetsBindingObserver {
  final List<LifecycleCallback> _onResumeCallbacks = [];
  final List<LifecycleCallback> _onPauseCallbacks = [];
  final List<LifecycleCallback> _onDetachCallbacks = [];
  final List<LifecycleCallback> _onInactiveCallbacks = [];
  final List<LifecycleCallback> _onHiddenCallbacks = [];

  AppLifecycleState? _lastState;
  DateTime? _lastActiveTime;

  AppLifecycleState? get lastState => _lastState;
  DateTime? get lastActiveTime => _lastActiveTime;
  bool get isActive => _lastState == AppLifecycleState.resumed;
  bool get isInactive => _lastState == AppLifecycleState.inactive || 
                         _lastState == AppLifecycleState.paused ||
                         _lastState == AppLifecycleState.hidden;

  /// Регистрация наблюдателя.
  void register() {
    WidgetsBinding.instance.addObserver(this);
    AppLogger.info('AppLifecycleObserver registered');
  }

  /// Отмена регистрации наблюдателя.
  void unregister() {
    WidgetsBinding.instance.removeObserver(this);
    AppLogger.info('AppLifecycleObserver unregistered');
  }

  /// Подписка на событие resume.
  void onResume(LifecycleCallback callback) => _onResumeCallbacks.add(callback);
  
  /// Подписка на событие pause.
  void onPause(LifecycleCallback callback) => _onPauseCallbacks.add(callback);
  
  /// Подписка на событие detach.
  void onDetach(LifecycleCallback callback) => _onDetachCallbacks.add(callback);
  
  /// Подписка на событие inactive.
  void onInactive(LifecycleCallback callback) => _onInactiveCallbacks.add(callback);
  
  /// Подписка на событие hidden.
  void onHidden(LifecycleCallback callback) => _onHiddenCallbacks.add(callback);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _lastState = state;
    AppLogger.info('App lifecycle state changed: ${state.name}');

    switch (state) {
      case AppLifecycleState.resumed:
        _lastActiveTime = DateTime.now();
        _executeCallbacks(_onResumeCallbacks, state);
        break;
      case AppLifecycleState.inactive:
        _executeCallbacks(_onInactiveCallbacks, state);
        break;
      case AppLifecycleState.paused:
        _executeCallbacks(_onPauseCallbacks, state);
        break;
      case AppLifecycleState.detached:
        _executeCallbacks(_onDetachCallbacks, state);
        break;
      case AppLifecycleState.hidden:
        _executeCallbacks(_onHiddenCallbacks, state);
        break;
    }
  }

  void _executeCallbacks(List<LifecycleCallback> callbacks, AppLifecycleState state) {
    for (final callback in callbacks) {
      try {
        callback(state);
      } catch (e, st) {
        AppLogger.error('Lifecycle callback error', e, st);
      }
    }
  }
}

typedef LifecycleCallback = void Function(AppLifecycleState state);
