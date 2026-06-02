import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/base/base_provider.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/services/storage_service.dart';

/// Обновлённый AppProvider на базе BaseProvider.
/// Управляет глобальными настройками приложения.
@singleton
class AppProviderV2 extends BaseProvider {
  final StorageService _storage;

  bool _isFirstLaunch = true;
  String _currentLanguage = 'en';
  String _currentCurrency = 'USD';
  bool _isAppInitialized = false;

  // Геттеры
  bool get isFirstLaunch => _isFirstLaunch;
  String get currentLanguage => _currentLanguage;
  String get currentCurrency => _currentCurrency;
  bool get isAppInitialized => _isAppInitialized;

  AppProviderV2(this._storage) {
    _initialize();
  }

  /// Инициализация приложения
  Future<void> _initialize() async {
    await execute(
      () async {
        _isFirstLaunch = _storage.get<bool>(_Keys.isFirstLaunch, true).value ?? true;
        _currentLanguage = _storage.get<String>(_Keys.language, 'en').value ?? 'en';
        _currentCurrency = _storage.get<String>(_Keys.currency, 'USD').value ?? 'USD';
        _isAppInitialized = true;
      },
      onError: (error) => AppLogger.error('AppProviderV2: init failed', Exception(error), null),
    );
  }

  /// Отметка первого запуска как завершённого
  Future<Result<void, AppError>> completeFirstLaunch() async {
    final result = await _storage.set<bool>(_Keys.isFirstLaunch, false);
    
    if (result.isSuccess) {
      _isFirstLaunch = false;
      notifyListeners();
    }
    
    return result;
  }

  /// Установка языка
  Future<Result<void, AppError>> setLanguage(String language) async {
    final result = await _storage.set<String>(_Keys.language, language);
    
    if (result.isSuccess) {
      _currentLanguage = language;
      notifyListeners();
    }
    
    return result;
  }

  /// Установка валюты
  Future<Result<void, AppError>> setCurrency(String currency) async {
    final result = await _storage.set<String>(_Keys.currency, currency);
    
    if (result.isSuccess) {
      _currentCurrency = currency;
      notifyListeners();
    }
    
    return result;
  }

  /// Сброс всех настроек (для logout или reset)
  Future<Result<void, AppError>> resetSettings() async {
    await Future.wait([
      _storage.set<bool>(_Keys.isFirstLaunch, true),
      _storage.set<String>(_Keys.language, 'en'),
      _storage.set<String>(_Keys.currency, 'USD'),
    ]);

    _isFirstLaunch = true;
    _currentLanguage = 'en';
    _currentCurrency = 'USD';
    notifyListeners();

    return const Success(null);
  }

  @override
  void dispose() {
    AppLogger.debug('AppProviderV2 disposed');
    super.dispose();
  }
}

// Ключи хранилища
abstract class _Keys {
  static const String isFirstLaunch = 'isFirstLaunch';
  static const String language = 'language';
  static const String currency = 'currency';
}
