import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';

/// Менеджер локального кэша на базе Hive.
/// Поддерживает TTL (time-to-live) для записей.
@singleton
class CacheManager {
  static const _defaultBoxName = 'app_cache';
  static const _metadataPrefix = '__meta__';

  Box<dynamic>? _box;

  Future<void> initialize() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_defaultBoxName);
    AppLogger.info('CacheManager initialized');
  }

  /// Сохраняет данные с опциональным TTL.
  Future<Result<void, AppError>> put<T>(
    String key,
    T value, {
    Duration? ttl,
  }) async {
    try {
      if (_box == null) {
        return const Failure(StorageError('Cache not initialized'));
      }

      await _box!.put(key, value);

      if (ttl != null) {
        final expiry = DateTime.now().add(ttl);
        await _box!.put('$_metadataPrefix$key', expiry.toIso8601String());
      }

      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Cache put error: $key', e, st);
      return Failure(StorageError('Failed to cache $key', stackTrace: st));
    }
  }

  /// Получает данные из кэша. Возвращает null если TTL истёк.
  Result<T?, AppError> get<T>(String key) {
    try {
      if (_box == null) {
        return const Failure(StorageError('Cache not initialized'));
      }

      // Проверяем TTL
      final metaKey = '$_metadataPrefix$key';
      final expiryStr = _box!.get(metaKey) as String?;

      if (expiryStr != null) {
        final expiry = DateTime.tryParse(expiryStr);
        if (expiry != null && DateTime.now().isAfter(expiry)) {
          // TTL истёк — удаляем
          _box!.delete(key);
          _box!.delete(metaKey);
          return const Success(null);
        }
      }

      final value = _box!.get(key);
      return Success(value is T ? value : null);
    } catch (e, st) {
      AppLogger.error('Cache get error: $key', e, st);
      return Failure(StorageError('Failed to read cache $key', stackTrace: st));
    }
  }

  /// Проверяет наличие актуальных данных в кэше.
  bool hasValid(String key) {
    final result = get<dynamic>(key);
    return result.isSuccess && result.value != null;
  }

  /// Удаляет запись из кэша.
  Future<Result<void, AppError>> delete(String key) async {
    try {
      if (_box == null) {
        return const Failure(StorageError('Cache not initialized'));
      }
      await _box!.delete(key);
      await _box!.delete('$_metadataPrefix$key');
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Cache delete error: $key', e, st);
      return Failure(StorageError('Failed to delete cache $key', stackTrace: st));
    }
  }

  /// Очищает весь кэш.
  Future<Result<void, AppError>> clear() async {
    try {
      if (_box == null) {
        return const Failure(StorageError('Cache not initialized'));
      }
      await _box!.clear();
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('Cache clear error', e, st);
      return Failure(StorageError('Failed to clear cache', stackTrace: st));
    }
  }

  /// Получает или вычисляет данные (cache-aside pattern).
  Future<Result<T, AppError>> getOrFetch<T>(
    String key,
    Future<T> Function() fetch, {
    Duration? ttl,
  }) async {
    final cached = get<T>(key);
    if (cached.isSuccess && cached.value != null) {
      AppLogger.debug('Cache HIT: $key');
      return Success(cached.value as T);
    }

    AppLogger.debug('Cache MISS: $key');
    try {
      final data = await fetch();
      await put(key, data, ttl: ttl);
      return Success(data);
    } catch (e, st) {
      AppLogger.error('Fetch error for key: $key', e, st);
      return Failure(NetworkError('Failed to fetch $key', stackTrace: st));
    }
  }

  Future<void> dispose() async {
    await _box?.close();
  }
}
