import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userId;
  String? _userName;
  String? _userEmail;
  String? _userAvatar;
  String? _userRole;
  DateTime? _lastLogin;
  List<String> _permissions = [];
  
  // Геттеры
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userAvatar => _userAvatar;
  String? get userRole => _userRole;
  DateTime? get lastLogin => _lastLogin;
  List<String> get permissions => _permissions;
  
  // Состояние загрузки
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  // Ошибки
  String? _error;
  String? get error => _error;

  AuthProvider() {
    _loadAuthState();
  }

  // Загрузка состояния аутентификации
  Future<void> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isAuthenticated = prefs.getBool('isAuthenticated') ?? false;
      _userId = prefs.getString('userId');
      _userName = prefs.getString('userName');
      _userEmail = prefs.getString('userEmail');
      _userAvatar = prefs.getString('userAvatar');
      _userRole = prefs.getString('userRole');
      _lastLogin = prefs.getString('lastLogin') != null 
          ? DateTime.parse(prefs.getString('lastLogin')!)
          : null;
      _permissions = prefs.getStringList('permissions') ?? [];
      
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка загрузки состояния аутентификации: $e';
      notifyListeners();
    }
  }

  // Сохранение состояния аутентификации
  Future<void> _saveAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAuthenticated', _isAuthenticated);
      await prefs.setString('userId', _userId ?? '');
      await prefs.setString('userName', _userName ?? '');
      await prefs.setString('userEmail', _userEmail ?? '');
      await prefs.setString('userAvatar', _userAvatar ?? '');
      await prefs.setString('userRole', _userRole ?? '');
      await prefs.setString('lastLogin', _lastLogin?.toIso8601String() ?? '');
      await prefs.setStringList('permissions', _permissions);
    } catch (e) {
      _error = 'Ошибка сохранения состояния аутентификации: $e';
      notifyListeners();
    }
  }

  // Вход с email и паролем
  Future<bool> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Имитация API вызова
      await Future.delayed(const Duration(seconds: 2));
      
      // Проверка учетных данных (в реальном приложении - API)
      if (email == 'demo@rechain.com' && password == 'password') {
        await _authenticateUser({
          'id': 'user_001',
          'name': 'Демо Пользователь',
          'email': email,
          'avatar': null,
          'role': 'user',
          'permissions': ['read', 'write', 'participate'],
        });
        return true;
      } else {
        _error = 'Неверный email или пароль';
        return false;
      }
    } catch (e) {
      _error = 'Ошибка входа: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Вход с Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Имитация Google OAuth
      await Future.delayed(const Duration(seconds: 2));
      
      await _authenticateUser({
        'id': 'google_user_001',
        'name': 'Google Пользователь',
        'email': 'google@example.com',
        'avatar': 'https://via.placeholder.com/150',
        'role': 'user',
        'permissions': ['read', 'write', 'participate'],
      });
      
      return true;
    } catch (e) {
      _error = 'Ошибка входа через Google: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Вход с GitHub
  Future<bool> signInWithGitHub() async {
    _setLoading(true);
    _clearError();
    
    try {
      // Имитация GitHub OAuth
      await Future.delayed(const Duration(seconds: 2));
      
      await _authenticateUser({
        'id': 'github_user_001',
        'name': 'GitHub Разработчик',
        'email': 'github@example.com',
        'avatar': 'https://via.placeholder.com/150',
        'role': 'developer',
        'permissions': ['read', 'write', 'participate', 'create_projects'],
      });
      
      return true;
    } catch (e) {
      _error = 'Ошибка входа через GitHub: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Подключение кошелька
  Future<bool> connectWallet(String walletAddress) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Имитация проверки кошелька
      await Future.delayed(const Duration(seconds: 1));
      
      if (walletAddress.length >= 42) {
        await _authenticateUser({
          'id': 'wallet_user_001',
          'name': 'Web3 Пользователь',
          'email': 'wallet@web3.com',
          'avatar': null,
          'role': 'web3_user',
          'permissions': ['read', 'write', 'participate', 'blockchain_operations'],
        });
        return true;
      } else {
        _error = 'Неверный адрес кошелька';
        return false;
      }
    } catch (e) {
      _error = 'Ошибка подключения кошелька: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Аутентификация пользователя
  Future<void> _authenticateUser(Map<String, dynamic> userData) async {
    _userId = userData['id'];
    _userName = userData['name'];
    _userEmail = userData['email'];
    _userAvatar = userData['avatar'];
    _userRole = userData['role'];
    _permissions = List<String>.from(userData['permissions']);
    _lastLogin = DateTime.now();
    _isAuthenticated = true;
    
    await _saveAuthState();
    notifyListeners();
  }

  // Выход
  Future<void> signOut() async {
    _setLoading(true);
    
    try {
      // Имитация API вызова для выхода
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Очистка данных
      _isAuthenticated = false;
      _userId = null;
      _userName = null;
      _userEmail = null;
      _userAvatar = null;
      _userRole = null;
      _lastLogin = null;
      _permissions = [];
      
      await _saveAuthState();
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка выхода: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Обновление профиля
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? avatar,
  }) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Имитация API вызова
      await Future.delayed(const Duration(seconds: 1));
      
      if (name != null) _userName = name;
      if (email != null) _userEmail = email;
      if (avatar != null) _userAvatar = avatar;
      
      await _saveAuthState();
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Ошибка обновления профиля: $e';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Проверка разрешений
  bool hasPermission(String permission) {
    return _permissions.contains(permission);
  }

  bool hasAnyPermission(List<String> permissions) {
    return permissions.any((permission) => _permissions.contains(permission));
  }

  bool hasAllPermissions(List<String> permissions) {
    return permissions.every((permission) => _permissions.contains(permission));
  }

  // Сброс пароля
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();
    
    try {
      // Имитация API вызова
      await Future.delayed(const Duration(seconds: 2));
      
      // В реальном приложении здесь будет отправка email
      return true;
    } catch (e) {
      _error = 'Ошибка сброса пароля: $e';
      return false;
    } finally {
      _setLoading(false);
    }

  }

  // Вспомогательные методы
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }

  // Хеширование пароля (для демонстрации)
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
