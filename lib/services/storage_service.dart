import 'package:shared_preferences/shared_preferences.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Абстракция над SharedPreferences с обработкой ошибок.
class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  static Future<void> initialize() async {
    await getInstance();
  }

  Result<T, AppError> get<T>(String key, T defaultValue) {
    try {
      final prefs = _prefs;
      if (prefs == null) {
        return const Failure(StorageError('SharedPreferences not initialized'));
      }

      final value = switch (T) {
        const (bool) => prefs.getBool(key) as T?,
        const (int) => prefs.getInt(key) as T?,
        const (double) => prefs.getDouble(key) as T?,
        const (String) => prefs.getString(key) as T?,
        const (List<String>) => prefs.getStringList(key) as T?,
        _ => null,
      };

      return Success(value ?? defaultValue);
    } catch (e, st) {
      AppLogger.error('Storage get error: $key', e, st);
      return Failure(StorageError('Failed to read $key', stackTrace: st));
    }
  }

  Future<Result<void, AppError>> set<T>(String key, T value) async {
    try {
      final prefs = _prefs;
      if (prefs == null) {
        return const Failure(StorageError('SharedPreferences not initialized'));
      }

      final success = switch (value) {
        final bool v => await prefs.setBool(key, v),
        final int v => await prefs.setInt(key, v),
        final double v => await prefs.setDouble(key, v),
        final String v => await prefs.setString(key, v),
        final List<String> v => await prefs.setStringList(key, v),
        _ => false,
      };

      if (!success && value is! List<String> && value is! String && value is! bool && value is! int && value is! double) {
        return Failure(StorageError('Unsupported type ${value.runtimeType} for key $key'));
      }

      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Storage set error: $key', e, st);
      return Failure(StorageError('Failed to write $key', stackTrace: st));
    }
  }

  Future<Result<void, AppError>> remove(String key) async {
    try {
      final prefs = _prefs;
      if (prefs == null) {
        return const Failure(StorageError('SharedPreferences not initialized'));
      }
      await prefs.remove(key);
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Storage remove error: $key', e, st);
      return Failure(StorageError('Failed to remove $key', stackTrace: st));
    }
  }

  Future<Result<void, AppError>> clear() async {
    try {
      final prefs = _prefs;
      if (prefs == null) {
        return const Failure(StorageError('SharedPreferences not initialized'));
      }
      await prefs.clear();
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Storage clear error', e, st);
      return Failure(StorageError('Failed to clear storage', stackTrace: st));
    }
  }
}
