import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/models/user_model.dart';
import 'package:rechain_vc_lab/services/storage_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  UserModel _user = UserModel.empty;
  DateTime? _lastLogin;

  bool get isAuthenticated => _isAuthenticated;
  UserModel get user => _user;
  String? get userId => _user.id.isNotEmpty ? _user.id : null;
  String? get userName => _user.name.isNotEmpty ? _user.name : null;
  String? get userEmail => _user.email.isNotEmpty ? _user.email : null;
  String? get userAvatar => _user.avatar;
  String? get userRole => _user.role;
  DateTime? get lastLogin => _lastLogin;
  List<String> get permissions => _user.permissions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String? _error;
  String? get error => _error;

  AuthProvider() {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    try {
      final storage = await StorageService.getInstance();

      _isAuthenticated = storage.get<bool>('isAuthenticated', false).value ?? false;
      final userJson = storage.get<String>('userData', '').value ?? '';
      if (userJson.isNotEmpty) {
        _user = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
      }
      final lastLoginStr = storage.get<String>('lastLogin', '').value ?? '';
      if (lastLoginStr.isNotEmpty) {
        _lastLogin = DateTime.tryParse(lastLoginStr);
      }
    } catch (e, st) {
      _error = 'Ошибка загрузки состояния аутентификации';
      AppLogger.error('AuthProvider: failed to load auth state', e, st);
    } finally {
      notifyListeners();
    }
  }

  Future<void> _saveAuthState() async {
    try {
      final storage = await StorageService.getInstance();
      await storage.set<bool>('isAuthenticated', _isAuthenticated);
      await storage.set<String>('userData', jsonEncode(_user.toJson()));
      await storage.set<String>('lastLogin', _lastLogin?.toIso8601String() ?? '');
    } catch (e, st) {
      _error = 'Ошибка сохранения состояния аутентификации';
      AppLogger.error('AuthProvider: failed to save auth state', e, st);
    }
  }

  Future<Result<UserModel, AppError>> signInWithBiometric() async {
    _setLoading(true);
    _clearError();
    
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // Для демо: если пользователь уже был аутентифицирован, возвращаем его
      if (_user.id.isNotEmpty) {
        _isAuthenticated = true;
        _lastLogin = DateTime.now();
        await _saveAuthState();
        notifyListeners();
        return Success(_user);
      }
      
      // Иначе возвращаем демо пользователя
      const user = UserModel(
        id: 'biometric_user_001',
        name: 'Biometric Пользователь',
        email: 'biometric@example.com',
        role: 'user',
        permissions: ['read', 'write', 'participate'],
      );
      await _authenticateUser(user);
      return Success(user);
    } catch (e, st) {
      final error = AuthError('Ошибка биометрического входа', stackTrace: st);
      _error = error.message;
      AppLogger.error('AuthProvider: signInWithBiometric failed', e, st);
      return Failure(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<Result<UserModel, AppError>> signInWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));

      if (email == 'demo@rechain.com' && password == 'password') {
        const user = UserModel(
          id: 'user_001',
          name: 'Демо Пользователь',
          email: 'demo@rechain.com',
          role: 'user',
          permissions: ['read', 'write', 'participate'],
        );
        await _authenticateUser(user);
        return Success(user);
      } else {
        final error = AuthError('Неверный email или пароль', code: 'invalid_credentials');
        _error = error.message;
        return Failure(error);
      }
    } catch (e, st) {
      final error = AuthError('Ошибка входа', stackTrace: st);
      _error = error.message;
      AppLogger.error('AuthProvider: signInWithEmail failed', e, st);
      return Failure(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<Result<UserModel, AppError>> signInWithGoogle() async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      const user = UserModel(
        id: 'google_user_001',
        name: 'Google Пользователь',
        email: 'google@example.com',
        avatar: 'https://via.placeholder.com/150',
        role: 'user',
        permissions: ['read', 'write', 'participate'],
      );
      await _authenticateUser(user);
      return Success(user);
    } catch (e, st) {
      final error = AuthError('Ошибка входа через Google', stackTrace: st);
      _error = error.message;
      AppLogger.error('AuthProvider: signInWithGoogle failed', e, st);
      return Failure(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<Result<UserModel, AppError>> signInWithGitHub() async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      const user = UserModel(
        id: 'github_user_001',
        name: 'GitHub Разработчик',
        email: 'github@example.com',
        avatar: 'https://via.placeholder.com/150',
        role: 'developer',
        permissions: ['read', 'write', 'participate', 'create_projects'],
      );
      await _authenticateUser(user);
      return Success(user);
    } catch (e, st) {
      final error = AuthError('Ошибка входа через GitHub', stackTrace: st);
      _error = error.message;
      AppLogger.error('AuthProvider: signInWithGitHub failed', e, st);
      return Failure(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<Result<UserModel, AppError>> connectWallet(String walletAddress) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      if (walletAddress.length >= 42) {
        const user = UserModel(
          id: 'wallet_user_001',
          name: 'Web3 Пользователь',
          email: 'wallet@web3.com',
          role: 'web3_user',
          permissions: ['read', 'write', 'participate', 'blockchain_operations'],
        );
        await _authenticateUser(user);
        return Success(user);
      } else {
        final error = AuthError('Неверный адрес кошелька', code: 'invalid_wallet');
        _error = error.message;
        return Failure(error);
      }
    } catch (e, st) {
      final error = AuthError('Ошибка подключения кошелька', stackTrace: st);
      _error = error.message;
      AppLogger.error('AuthProvider: connectWallet failed', e, st);
      return Failure(error);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _authenticateUser(UserModel user) async {
    _user = user;
    _lastLogin = DateTime.now();
    _isAuthenticated = true;
    await _saveAuthState();
    notifyListeners();
  }

  Future<void> signOut() async {
    _setLoading(true);

    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _isAuthenticated = false;
      _user = UserModel.empty;
      _lastLogin = null;
      await _saveAuthState();
      notifyListeners();
    } catch (e, st) {
      _error = 'Ошибка выхода';
      AppLogger.error('AuthProvider: signOut failed', e, st);
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<Result<void, AppError>> updateProfile({
    String? name,
    String? email,
    String? avatar,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _user = _user.copyWith(name: name, email: email, avatar: avatar);
      await _saveAuthState();
      notifyListeners();
      return const Success(null);
    } catch (e, st) {
      final error = AuthError('Ошибка обновления профиля', stackTrace: st);
      _error = error.message;
      AppLogger.error('AuthProvider: updateProfile failed', e, st);
      return Failure(error);
    } finally {
      _setLoading(false);
    }
  }

  bool hasPermission(String permission) => _user.permissions.contains(permission);
  bool hasAnyPermission(List<String> perms) => perms.any(_user.permissions.contains);
  bool hasAllPermissions(List<String> perms) => perms.every(_user.permissions.contains);

  Future<Result<void, AppError>> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await Future.delayed(const Duration(seconds: 1));
      return const Success(null);
    } catch (e, st) {
      final error = AuthError('Ошибка сброса пароля', stackTrace: st);
      _error = error.message;
      AppLogger.error('AuthProvider: resetPassword failed', e, st);
      return Failure(error);
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() => _clearError();
}
