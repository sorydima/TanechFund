import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/services/storage_service.dart';

class AppProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool _isFirstLaunch = true;
  String _currentLanguage = 'en';
  String _currentCurrency = 'USD';
  bool _isLoading = true;
  
  bool get isDarkMode => _isDarkMode;
  bool get isFirstLaunch => _isFirstLaunch;
  String get currentLanguage => _currentLanguage;
  String get currentCurrency => _currentCurrency;
  bool get isLoading => _isLoading;

  AppProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final storage = await StorageService.getInstance();

      _isDarkMode = storage.get<bool>('isDarkMode', false).value ?? false;
      _isFirstLaunch = storage.get<bool>('isFirstLaunch', true).value ?? true;
      _currentLanguage = storage.get<String>('language', 'en').value ?? 'en';
      _currentCurrency = storage.get<String>('currency', 'USD').value ?? 'USD';
    } catch (e, st) {
      AppLogger.error('AppProvider: failed to load settings', e, st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final storage = await StorageService.getInstance();
    await storage.set<bool>('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    final storage = await StorageService.getInstance();
    await storage.set<String>('language', language);
    notifyListeners();
  }

  Future<void> setCurrency(String currency) async {
    _currentCurrency = currency;
    final storage = await StorageService.getInstance();
    await storage.set<String>('currency', currency);
    notifyListeners();
  }

  Future<void> setFirstLaunchComplete() async {
    _isFirstLaunch = false;
    final storage = await StorageService.getInstance();
    await storage.set<bool>('isFirstLaunch', false);
    notifyListeners();
  }
}
