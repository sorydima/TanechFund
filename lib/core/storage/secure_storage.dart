import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';

/// Абстракция над secure storage для sensitive data (токены, ключи).
abstract class ISecureStorage {
  Future<Result<String?, AppError>> read(String key);
  Future<Result<void, AppError>> write(String key, String value);
  Future<Result<void, AppError>> delete(String key);
  Future<Result<void, AppError>> deleteAll();
}

/// Реализация secure storage с обработкой ошибок.
class SecureStorage implements ISecureStorage {
  static const _options = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock_this_device,
    accountName: 'rechain_secure_storage',
  );

  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
    keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_PKCS1Padding,
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
  );

  final FlutterSecureStorage _storage;

  SecureStorage({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              iOptions: _options,
              aOptions: _androidOptions,
            );

  @override
  Future<Result<String?, AppError>> read(String key) async {
    try {
      final value = await _storage.read(key: key);
      return Success(value);
    } catch (e, st) {
      AppLogger.error('SecureStorage read error: $key', e, st);
      return Failure(StorageError('Failed to read secure key $key', stackTrace: st));
    }
  }

  @override
  Future<Result<void, AppError>> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('SecureStorage write error: $key', e, st);
      return Failure(StorageError('Failed to write secure key $key', stackTrace: st));
    }
  }

  @override
  Future<Result<void, AppError>> delete(String key) async {
    try {
      await _storage.delete(key: key);
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('SecureStorage delete error: $key', e, st);
      return Failure(StorageError('Failed to delete secure key $key', stackTrace: st));
    }
  }

  @override
  Future<Result<void, AppError>> deleteAll() async {
    try {
      await _storage.deleteAll();
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('SecureStorage deleteAll error', e, st);
      return Failure(StorageError('Failed to clear secure storage', stackTrace: st));
    }
  }
}
