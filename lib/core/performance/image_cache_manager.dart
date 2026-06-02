import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Менеджер кэширования изображений.
/// Оптимизирует загрузку и хранение картинок.
class ImageCacheManager {
  static const _maxCacheSize = 100 * 1024 * 1024; // 100 MB
  static const _maxNrOfCacheObjects = 200;
  
  late final CacheManager _cacheManager;

  ImageCacheManager() {
    _initialize();
  }

  void _initialize() {
    _cacheManager = CacheManager(
      Config(
        'rechain_images',
        stalePeriod: const Duration(days: 7),
        maxNrOfCacheObjects: _maxNrOfCacheObjects,
        repo: JsonCacheInfoRepository(databaseName: 'rechain_images'),
        fileService: HttpFileService(),
      ),
    );
    
    AppLogger.info('ImageCacheManager initialized with ${_maxCacheSize ~/ 1024 ~/ 1024}MB limit');
  }

  /// Получает файл из кэша или загружает.
  Future<File?> getCachedImage(String url) async {
    try {
      final file = await _cacheManager.getSingleFile(url);
      AppLogger.debug('Image cached: $url');
      return file;
    } catch (e, st) {
      AppLogger.error('Failed to cache image: $url', e, st);
      return null;
    }
  }

  /// Загружает изображение в кэш.
  Future<bool> cacheImage(String url) async {
    try {
      await _cacheManager.downloadFile(url);
      return true;
    } catch (e, st) {
      AppLogger.error('Failed to download image: $url', e, st);
      return false;
    }
  }

  /// Предварительно кэширует список изображений.
  Future<void> preloadImages(List<String> urls) async {
    try {
      await Future.wait(
        urls.map((url) => cacheImage(url)).toList(),
      );
      AppLogger.info('Preloaded ${urls.length} images');
    } catch (e, st) {
      AppLogger.error('Failed to preload images', e, st);
    }
  }

  /// Получает изображение из кэша или сети.
  Future<File?> getImage(String url, {bool cache = true}) async {
    try {
      if (cache) {
        return await getCachedImage(url);
      } else {
        final file = await _cacheManager.downloadFile(url);
        return file.file;
      }
    } catch (e, st) {
      AppLogger.error('Failed to get image: $url', e, st);
      return null;
    }
  }

  /// Очищает старые изображения.
  Future<void> clearCache() async {
    try {
      await _cacheManager.emptyCache();
      AppLogger.info('Image cache cleared');
    } catch (e, st) {
      AppLogger.error('Failed to clear cache', e, st);
    }
  }

  /// Получает размер кэша в байтах.
  Future<int> getCacheSize() async {
    try {
      final dir = await getTemporaryDirectory();
      final cacheDir = Directory('${dir.path}/libCachedImageData');
      
      if (!await cacheDir.exists()) {
        return 0;
      }

      int totalSize = 0;
      await for (final file in cacheDir.list()) {
        if (file is File) {
          totalSize += await file.length();
        }
      }
      
      return totalSize;
    } catch (e, st) {
      AppLogger.error('Failed to get cache size', e, st);
      return 0;
    }
  }

  /// Сжимает изображение.
  Future<File?> compressImage(File file, {int quality = 80}) async {
    try {
      // TODO: Интеграция с flutter_image_compress
      return file;
    } catch (e, st) {
      AppLogger.error('Failed to compress image', e, st);
      return null;
    }
  }

  /// Удаляет конкретное изображение из кэша.
  Future<void> removeCachedImage(String url) async {
    try {
      await _cacheManager.removeFile(url);
      AppLogger.debug('Removed cached image: $url');
    } catch (e, st) {
      AppLogger.error('Failed to remove cached image: $url', e, st);
    }
  }

  /// Проверяет наличие изображения в кэше.
  Future<bool> isCached(String url) async {
    try {
      final file = await _cacheManager.getFileFromCache(url);
      return file != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> dispose() async {
    await _cacheManager.dispose();
  }
}
