/// Core stability components for REChain®️ VC Lab.
/// 
/// Этот модуль предоставляет компоненты для обеспечения стабильности и надёжности приложения:
/// 
/// - [CircuitBreaker] - защита от каскадных сбоев API
/// - [OfflineFirstManager] - offline-first стратегия с синхронизацией
/// - [AppLifecycleObserver] - наблюдение за жизненным циклом приложения
/// - [GracefulShutdownService] - корректное завершение работы
/// - [BaseApiRepository] - базовый репозиторий для API операций
/// 
/// Пример использования:
/// ```dart
/// final circuitBreaker = CircuitBreaker(
///   maxFailures: 5,
///   resetTimeout: Duration(minutes: 1),
/// );
/// 
/// final result = await circuitBreaker.execute(() => apiCall());
/// ```
library stability;

export 'circuit_breaker.dart';
export 'offline_first_manager.dart';
export 'app_lifecycle_observer.dart';
export 'graceful_shutdown.dart';
