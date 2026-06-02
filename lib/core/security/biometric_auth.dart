import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';

/// Сервис биометрической аутентификации.
/// Обёртка над local_auth с единым API для всех платформ.
class BiometricAuthService {
  final LocalAuthentication _localAuth;

  BiometricAuthService([LocalAuthentication? localAuth])
      : _localAuth = localAuth ?? LocalAuthentication();

  /// Проверяет доступность биометрии на устройстве.
  Future<bool> get isAvailable async {
    try {
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;
      return isDeviceSupported && canCheckBiometrics;
    } on PlatformException catch (e) {
      AppLogger.error('BiometricAuth: availability check failed', e);
      return false;
    }
  }

  /// Возвращает список доступных биометрических типов.
  Future<List<BiometricType>> get availableTypes async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      AppLogger.error('BiometricAuth: failed to get biometrics', e);
      return [];
    }
  }

  /// Проверяет, включена ли биометрия в настройках приложения.
  /// Требует SecureStorage для проверки флага.
  Future<bool> isEnabled() async {
    // TODO: Реализовать через SecureStorage после интеграции
    return false;
  }

  /// Аутентифицирует пользователя через биометрию.
  ///
  /// [localizedReason] — сообщение, показываемое пользователю.
  /// [useErrorDialogs] — показывать системные диалоги ошибок.
  /// [stickyAuth] — не сбрасывать аутентификацию при сворачивании.
  Future<Result<bool, AppError>> authenticate({
    String localizedReason = 'Подтвердите свою личность',
    bool useErrorDialogs = true,
    bool stickyAuth = false,
  }) async {
    try {
      final isAvailable = await this.isAvailable;
      if (!isAvailable) {
        return Failure(AuthError(
          'Биометрия недоступна на этом устройстве',
          code: 'biometric_unavailable',
        ));
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        authMessages: const [
          AndroidAuthMessages(
            signInTitle: 'Биометрическая аутентификация',
            cancelButton: 'Отмена',
            biometricHint: 'Подтвердите свою личность',
            biometricNotRecognized: 'Не распознано, попробуйте снова',
            biometricRequiredTitle: 'Требуется биометрия',
            deviceCredentialsRequiredTitle: 'Требуются учётные данные устройства',
            deviceCredentialsSetupDescription: 'Настройте PIN/пароль для продолжения',
            goToSettingsButton: 'В настройки',
            goToSettingsDescription: 'Настройте биометрию в системных настройках',
          ),
          IOSAuthMessages(
            cancelButton: 'Отмена',
            goToSettingsButton: 'В настройки',
            goToSettingsDescription: 'Настройте Face ID/Touch ID в системных настройках',
            lockOut: 'Пожалуйста, повторите попытку',
          ),
        ],
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: false, // Разрешаем PIN/пароль как fallback
        ),
      );

      if (didAuthenticate) {
        AppLogger.info('BiometricAuth: authentication successful');
        return const Success(true);
      } else {
        return Failure(AuthError(
          'Аутентификация отменена',
          code: 'biometric_cancelled',
        ));
      }
    } on PlatformException catch (e) {
      AppLogger.error('BiometricAuth: authentication failed', e);
      return Failure(AuthError(
        'Ошибка биометрии: ${e.message}',
        code: 'biometric_error',
      ));
    }
  }

  /// Аутентификация только биометрией (без PIN/пароля).
  Future<Result<bool, AppError>> authenticateWithBiometricOnly({
    String localizedReason = 'Подтвердите свою личность',
  }) async {
    try {
      final isAvailable = await this.isAvailable;
      if (!isAvailable) {
        return Failure(AuthError(
          'Биометрия недоступна',
          code: 'biometric_unavailable',
        ));
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: false,
          biometricOnly: true,
        ),
      );

      return Success(didAuthenticate);
    } on PlatformException catch (e) {
      AppLogger.error('BiometricAuth: biometric-only auth failed', e);
      return Failure(AuthError(
        'Ошибка биометрии: ${e.message}',
        code: 'biometric_error',
      ));
    }
  }

  /// Останавливает текущую аутентификацию.
  Future<bool> stopAuthentication() async {
    try {
      return await _localAuth.stopAuthentication();
    } on PlatformException catch (e) {
      AppLogger.error('BiometricAuth: stop failed', e);
      return false;
    }
  }
}

/// Расширение для удобного отображения типов биометрии.
extension BiometricTypeX on BiometricType {
  String get displayName {
    switch (this) {
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.fingerprint:
        return 'Отпечаток пальца';
      case BiometricType.iris:
        return 'Сканер радужки';
      case BiometricType.strong:
        return 'Сильная биометрия';
      case BiometricType.weak:
        return 'Слабая биометрия';
      default:
        return 'Биометрия';
    }
  }

  IconData get icon {
    switch (this) {
      case BiometricType.face:
        return Icons.face;
      case BiometricType.fingerprint:
        return Icons.fingerprint;
      case BiometricType.iris:
        return Icons.visibility;
      default:
        return Icons.security;
    }
  }
}
