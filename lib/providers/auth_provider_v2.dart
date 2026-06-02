import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/base/base_provider.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/core/security/biometric_auth.dart';
import 'package:rechain_vc_lab/models/user_model.dart';
import 'package:rechain_vc_lab/domain/repositories/auth_repository.dart';

/// Обновлённый AuthProvider на базе BaseProvider + IAuthRepository.
/// Использует DI для репозитория, что упрощает тестирование.
@singleton
class AuthProviderV2 extends BaseProvider {
  final IAuthRepository _authRepository;
  final BiometricAuthService _biometricAuth;

  bool _isAuthenticated = false;
  UserModel _user = UserModel.empty;
  DateTime? _lastLogin;
  bool _isBiometricEnabled = false;

  // Геттеры
  bool get isAuthenticated => _isAuthenticated;
  UserModel get user => _user;
  String? get userId => _user.id.isNotEmpty ? _user.id : null;
  String? get userName => _user.name.isNotEmpty ? _user.name : null;
  String? get userEmail => _user.email.isNotEmpty ? _user.email : null;
  String? get userAvatar => _user.avatar;
  String? get userRole => _user.role;
  DateTime? get lastLogin => _lastLogin;
  List<String> get permissions => _user.permissions;
  bool get isBiometricEnabled => _isBiometricEnabled;

  AuthProviderV2(this._authRepository, this._biometricAuth) {
    _loadAuthState();
  }

  /// Загрузка состояния аутентификации
  Future<void> _loadAuthState() async {
    setLoading(true);
    try {
      final authResult = await _authRepository.isAuthenticated();
      _isAuthenticated = authResult;

      if (_isAuthenticated) {
        final userResult = await _authRepository.getCurrentUser();
        if (userResult.isSuccess) {
          _user = userResult.value!;
        }
      }
    } catch (e, st) {
      AppLogger.error('AuthProviderV2: failed to load auth state', e, st);
      setError('Ошибка загрузки состояния');
    } finally {
      setLoading(false);
    }
  }

  /// Вход по email/password
  Future<Result<UserModel, AppError>> signInWithEmail(
    String email,
    String password,
  ) async {
    final result = await _authRepository.signInWithEmail(email, password);

    if (result.isSuccess) {
      _user = result.value!;
      _lastLogin = DateTime.now();
      _isAuthenticated = true;
      clearError();
      notifyListeners();
    } else {
      setError(result.error?.message ?? 'Произошла ошибка');
    }

    return result;
  }

  /// Вход через Google
  Future<Result<UserModel, AppError>> signInWithGoogle() async {
    final result = await _authRepository.signInWithGoogle();

    if (result.isSuccess) {
      _user = result.value!;
      _lastLogin = DateTime.now();
      _isAuthenticated = true;
      clearError();
      notifyListeners();
    } else {
      setError(result.error?.message ?? 'Произошла ошибка');
    }

    return result;
  }

  /// Вход через GitHub
  Future<Result<UserModel, AppError>> signInWithGitHub() async {
    final result = await _authRepository.signInWithGitHub();

    if (result.isSuccess) {
      _user = result.value!;
      _lastLogin = DateTime.now();
      _isAuthenticated = true;
      clearError();
      notifyListeners();
    } else {
      setError(result.error?.message ?? 'Произошла ошибка');
    }

    return result;
  }

  /// Подключение Web3 кошелька
  Future<Result<UserModel, AppError>> connectWallet(String walletAddress) async {
    final result = await _authRepository.connectWallet(walletAddress);

    if (result.isSuccess) {
      _user = result.value!;
      _lastLogin = DateTime.now();
      _isAuthenticated = true;
      clearError();
      notifyListeners();
    } else {
      setError(result.error?.message ?? 'Произошла ошибка');
    }

    return result;
  }

  /// Биометрический вход
  Future<Result<UserModel, AppError>> signInWithBiometric() async {
    // Сначала проверяем доступность биометрии
    final isAvailable = await _biometricAuth.isAvailable;
    if (!isAvailable) {
      return Failure(AuthError(
        'Биометрия недоступна на этом устройстве',
        code: 'biometric_unavailable',
      ));
    }

    // Аутентифицируем через биометрию
    final authResult = await _biometricAuth.authenticate(
      localizedReason: 'Войдите в REChain VC Lab',
    );

    if (authResult.isFailure) {
      setError(authResult.error?.message ?? 'Биометрическая аутентификация отменена');
      return Failure(authResult.error ?? AuthError('Аутентификация отменена'));
    }

    // После успешной биометрии получаем сохранённого пользователя
    final userResult = await _authRepository.getCurrentUser();
    if (userResult.isSuccess) {
      _user = userResult.value!;
      _lastLogin = DateTime.now();
      _isAuthenticated = true;
      clearError();
      notifyListeners();
      return Success(_user);
    } else {
      setError('Пользователь не найден. Выполните вход через email.');
      return Failure(AuthError('Пользователь не найден'));
    }
  }

  /// Включение биометрической аутентификации
  Future<Result<bool, AppError>> enableBiometric() async {
    final isAvailable = await _biometricAuth.isAvailable;
    if (!isAvailable) {
      return Failure(AuthError(
        'Биометрия недоступна на этом устройстве',
        code: 'biometric_unavailable',
      ));
    }

    final result = await _biometricAuth.authenticate(
      localizedReason: 'Включить биометрический вход',
    );

    if (result.isSuccess) {
      _isBiometricEnabled = true;
      notifyListeners();
      return const Success(true);
    } else {
      return Failure(result.error ?? AuthError('Не удалось включить биометрию'));
    }
  }

  /// Выключение биометрической аутентификации
  Future<Result<bool, AppError>> disableBiometric() async {
    _isBiometricEnabled = false;
    notifyListeners();
    return const Success(false);
  }

  /// Выход
  Future<Result<void, AppError>> signOut() async {
    final result = await _authRepository.signOut();

    if (result.isSuccess) {
      _isAuthenticated = false;
      _user = UserModel.empty;
      _lastLogin = null;
      clearError();
      notifyListeners();
    } else {
      setError(result.error?.message ?? 'Ошибка выхода');
    }

    return result;
  }

  /// Обновление профиля
  Future<Result<UserModel, AppError>> updateProfile({
    String? name,
    String? email,
    String? avatar,
  }) async {
    final result = await _authRepository.updateProfile(
      name: name,
      email: email,
      avatar: avatar,
    );

    if (result.isSuccess) {
      _user = result.value!;
      notifyListeners();
    } else {
      setError(result.error?.message ?? 'Ошибка обновления профиля');
    }

    return result;
  }

  /// Сброс пароля
  Future<Result<void, AppError>> resetPassword(String email) async {
    return await _authRepository.resetPassword(email);
  }

  /// Проверка прав доступа
  bool hasPermission(String permission) => _user.permissions.contains(permission);

  bool hasAnyPermission(List<String> perms) => perms.any(_user.permissions.contains);

  bool hasAllPermissions(List<String> perms) => perms.every(_user.permissions.contains);

  /// Обновление токена (для refresh flow)
  Future<Result<void, AppError>> refreshToken() async {
    final result = await _authRepository.refreshToken();
    if (result.isFailure) {
      setError(result.error?.message ?? 'Ошибка обновления токена');
    }
    return result;
  }

  @override
  void dispose() {
    AppLogger.debug('AuthProviderV2 disposed');
    super.dispose();
  }
}
