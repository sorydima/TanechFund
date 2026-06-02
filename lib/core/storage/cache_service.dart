import 'dart:async';
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';

/// Кэшированная запись с метаданными.
class CacheEntry<T> {
  final T data;
  final DateTime createdAt;
  final Duration ttl;
  final String? tags;

  CacheEntry({
    required this.data,
    required this.createdAt,
    required this.ttl,
    this.tags,
  });

  bool get isExpired {
    final expiresAt = createdAt.add(ttl);
    return DateTime.now().isAfter(expiresAt);
  }

  Map<String, dynamic> toJson() => {
    'data': _serializeData(data),
    'createdAt': createdAt.toIso8601String(),
    'ttl': ttl.inMilliseconds,
    'tags': tags,
  };

  factory CacheEntry.fromJson(Map<String, dynamic> json, Type type) {
    return CacheEntry<T>(
      data: _deserializeData(json['data'], type) as T,
      createdAt: DateTime.parse(json['createdAt']),
      ttl: Duration(milliseconds: json['ttl']),
      tags: json['tags'],
    );
  }

  static dynamic _serializeData(dynamic data) {
    if (data is Map || data is List) {
      return jsonEncode(data);
    }
    return data;
  }

  static dynamic _deserializeData(dynamic data, Type type) {
    if (data is String) {
      try {
        return jsonDecode(data);
      } catch (_) {
        return data;
      }
    }
    return data;
  }
}

/// Сервис кэширования с TTL поддержкой.
/// 
/// Пример использования:
/// ```dart
/// final cache = CacheService();
/// await cache.initialize();
/// 
/// // Запись в кэш
/// await cache.set('user_profile', userData, ttl: Duration(minutes: 30));
/// 
/// // Чтение из кэша
/// final result = await cache.get<Map<String, dynamic>>('user_profile');
/// if (result.isSuccess) {
///   print('Cached data: ${result.value}');
/// }
/// 
/// // Очистка по тегу
/// await cache.clearByTag('user');
/// ```
class CacheService {
  static const String _boxName = 'app_cache';
  static const String _metadataBoxName = 'cache_metadata';

  Box<dynamic>? _cacheBox;
  Box<dynamic>? _metadataBox;
  Timer? _cleanupTimer;

  bool get isInitialized => _cacheBox != null && _metadataBox != null;

  /// Инициализация кэш сервиса.
  Future<Result<void, AppError>> initialize() async {
    try {
      await Hive.initFlutter();

      _cacheBox = await Hive.openBox(_boxName);
      _metadataBox = await Hive.openBox(_metadataBoxName);

      // Запуск периодической очистки expired записей
      _cleanupTimer = Timer.periodic(const Duration(minutes: 5), (_) => _cleanupExpired());

      AppLogger.info('CacheService initialized');
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('CacheService initialization failed', e, st);
      return Failure(StorageError('Failed to initialize cache', stackTrace: st));
    }
  }

  /// Получение данных из кэша.
  Future<Result<T?, AppError>> get<T>(String key) async {
    try {
      if (!isInitialized) {
        return Failure(StorageError('Cache not initialized'));
      }

      final metadataJson = _metadataBox?.get(key) as String?;
      if (metadataJson == null) {
        return const Success(null);
      }

      final metadata = CacheEntry<T>.fromJson(
        jsonDecode(metadataJson) as Map<String, dynamic>,
        T,
      );

      if (metadata.isExpired) {
        await _remove(key);
        return const Success(null);
      }

      final data = _cacheBox?.get(key) as T?;
      return Success(data);
    } catch (e, st) {
      AppLogger.error('CacheService get error: $key', e, st);
      return Failure(StorageError('Failed to get cache key $key', stackTrace: st));
    }
  }

  /// Запись данных в кэш с TTL.
  Future<Result<void, AppError>> set<T>(
    String key,
    T value, {
    Duration ttl = const Duration(minutes: 30),
    String? tags,
  }) async {
    try {
      if (!isInitialized) {
        return Failure(StorageError('Cache not initialized'));
      }

      final entry = CacheEntry<T>(
        data: value,
        createdAt: DateTime.now(),
        ttl: ttl,
        tags: tags,
      );

      await Future.wait([
        _cacheBox!.put(key, value),
        _metadataBox!.put(key, jsonEncode(entry.toJson())),
      ]);

      AppLogger.debug('CacheService set: $key (TTL: ${ttl.inSeconds}s)');
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('CacheService set error: $key', e, st);
      return Failure(StorageError('Failed to set cache key $key', stackTrace: st));
    }
  }

  /// Удаление записи из кэша.
  Future<Result<void, AppError>> remove(String key) async {
    try {
      await _remove(key);
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('CacheService remove error: $key', e, st);
      return Failure(StorageError('Failed to remove cache key $key', stackTrace: st));
    }
  }

  /// Очистка кэша по тегу.
  Future<Result<int, AppError>> clearByTag(String tag) async {
    try {
      if (!isInitialized) {
        return Failure(StorageError('Cache not initialized'));
      }

      int removedCount = 0;
      final keysToRemove = <String>[];

      for (final key in _metadataBox!.keys) {
        final metadataJson = _metadataBox!.get(key) as String?;
        if (metadataJson != null) {
          try {
            final metadata = jsonDecode(metadataJson) as Map<String, dynamic>;
            if (metadata['tags'] == tag) {
              keysToRemove.add(key.toString());
            }
          } catch (_) {
            // Пропускаем невалидные записи
          }
        }
      }

      for (final key in keysToRemove) {
        await _remove(key);
        removedCount++;
      }

      AppLogger.info('CacheService cleared $removedCount entries with tag: $tag');
      return Success(removedCount);
    } catch (e, st) {
      AppLogger.error('CacheService clearByTag error: $tag', e, st);
      return Failure(StorageError('Failed to clear cache by tag', stackTrace: st));
    }
  }

  /// Полная очистка кэша.
  Future<Result<void, AppError>> clearAll() async {
    try {
      final futures = <Future<void>>[];
      if (_cacheBox != null) futures.add(_cacheBox!.clear());
      if (_metadataBox != null) futures.add(_metadataBox!.clear());
      
      await Future.wait(futures);

      AppLogger.info('CacheService cleared all entries');
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('CacheService clearAll error', e, st);
      return Failure(StorageError('Failed to clear all cache', stackTrace: st));
    }
  }

  /// Получение статистики кэша.
  CacheStats getStats() {
    if (!isInitialized) {
      return CacheStats(total: 0, expired: 0, sizeBytes: 0);
    }

    int total = _metadataBox!.length;
    int expired = 0;
    int sizeBytes = 0;

    for (final key in _metadataBox!.keys) {
      final metadataJson = _metadataBox!.get(key) as String?;
      if (metadataJson != null) {
        try {
          final metadata = jsonDecode(metadataJson) as Map<String, dynamic>;
          final entry = CacheEntry.fromJson(metadata, Map);
          if (entry.isExpired) {
            expired++;
          }
        } catch (_) {
          // Пропускаем невалидные записи
        }
      }

      final data = _cacheBox!.get(key);
      if (data != null) {
        sizeBytes += utf8.encode(jsonEncode(data)).length;
      }
    }

    return CacheStats(total: total, expired: expired, sizeBytes: sizeBytes);
  }

  /// Очистка ресурсов.
  void dispose() {
    _cleanupTimer?.cancel();
    _cacheBox?.close();
    _metadataBox?.close();
    AppLogger.debug('CacheService disposed');
  }

  // Private helpers

  Future<void> _remove(String key) async {
    final futures = <Future<void>>[];
    if (_cacheBox != null) futures.add(_cacheBox!.delete(key));
    if (_metadataBox != null) futures.add(_metadataBox!.delete(key));
    
    await Future.wait(futures);
  }

  void _cleanupExpired() {
    if (!isInitialized) return;

    int cleanedCount = 0;
    final keysToCheck = _metadataBox!.keys.toList();

    for (final key in keysToCheck) {
      final metadataJson = _metadataBox!.get(key) as String?;
      if (metadataJson != null) {
        try {
          final metadata = jsonDecode(metadataJson) as Map<String, dynamic>;
          final entry = CacheEntry.fromJson(metadata, Map);
          if (entry.isExpired) {
            _remove(key.toString());
            cleanedCount++;
          }
        } catch (_) {
          // Удаляем невалидные записи
          _remove(key.toString());
          cleanedCount++;
        }
      }
    }

    if (cleanedCount > 0) {
      AppLogger.debug('CacheService cleaned $cleanedCount expired entries');
    }
  }
}

/// Статистика кэша.
class CacheStats {
  final int total;
  final int expired;
  final int sizeBytes;

  const CacheStats({
    required this.total,
    required this.expired,
    required this.sizeBytes,
  });

  String get sizeFormatted {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) return '${(sizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  double get hitRatePercent => total > 0 ? ((total - expired) / total * 100) : 0;
}
