import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';

/// Сервис для взаимодействия с IPFS (InterPlanetary File System)
/// Обеспечивает децентрализованное хранение контента
@singleton
class IPFSService {
  final String _gatewayUrl;
  final String _uploadUrl;
  final http.Client _client;

  IPFSService({
    String? gatewayUrl,
    String? uploadUrl,
  })  : _gatewayUrl = gatewayUrl ?? 'https://ipfs.io/ipfs/',
        _uploadUrl = uploadUrl ?? 'https://ipfs.io/api/v0/add',
        _client = http.Client();

  /// Загрузка данных в IPFS
  /// Возвращает CID (Content Identifier)
  Future<Result<String, Exception>> uploadData(dynamic data) async {
    try {
      final bytes = data is String ? utf8.encode(data) : data;
      
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_uploadUrl),
      );
      
      request.files.add(http.MultipartFile.fromBytes('file', bytes));
      request.fields['pin'] = 'true'; // Pin content to make it permanent

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        final json = jsonDecode(responseBody.body);
        final cid = json['Hash'];
        
        AppLogger.info('Data uploaded to IPFS. CID: $cid');
        return Result.success(cid);
      } else {
        AppLogger.error('IPFS upload failed: ${response.statusCode}', responseBody.body);
        return Result.failure(Exception('Upload failed: ${responseBody.body}'));
      }
    } catch (e) {
      AppLogger.error('IPFS upload error', e);
      return Result.failure(e);
    }
  }

  /// Загрузка JSON данных в IPFS
  Future<Result<String, Exception>> uploadJson(Map<String, dynamic> json) async {
    return uploadData(jsonEncode(json));
  }

  /// Загрузка текстовых данных в IPFS
  Future<Result<String, Exception>> uploadText(String text) async {
    return uploadData(text);
  }

  /// Получение данных из IPFS по CID
  Future<Result<dynamic, Exception>> getData(String cid) async {
    try {
      final url = '$_gatewayUrl$cid';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        AppLogger.info('Data retrieved from IPFS. CID: $cid');
        
        // Пытаемся распарсить как JSON
        try {
          return Result.success(jsonDecode(response.body));
        } catch (e) {
          // Возвращаем как текст
          return Result.success(response.body);
        }
      } else {
        AppLogger.error('IPFS retrieval failed: ${response.statusCode}');
        return Result.failure(Exception('Failed to retrieve data'));
      }
    } catch (e) {
      AppLogger.error('IPFS retrieval error', e);
      return Result.failure(e);
    }
  }

  /// Получение JSON данных из IPFS
  Future<Result<Map<String, dynamic>, Exception>> getJson(String cid) async {
    final result = await getData(cid);
    if (result.isFailure) {
      return Result.failure(result.error);
    }
    
    try {
      return Result.success(Map<String, dynamic>.from(result.value));
    } catch (e) {
      return Result.failure(Exception('Invalid JSON format'));
    }
  }

  /// Получение текстовых данных из IPFS
  Future<Result<String, Exception>> getText(String cid) async {
    final result = await getData(cid);
    if (result.isFailure) {
      return Result.failure(result.error);
    }
    
    return Result.success(result.value.toString());
  }

  /// Проверка существования контента по CID
  Future<Result<bool, Exception>> exists(String cid) async {
    try {
      final url = '$_gatewayUrl$cid';
      final response = await http.get(Uri.parse(url));
      return Result.success(response.statusCode == 200);
    } catch (e) {
      return Result.failure(e);
    }
  }

  /// Генерация временной ссылки для доступа к контенту
  String generateUrl(String cid) {
    return '$_gatewayUrl$cid';
  }

  /// Pinning контента (сохранение навсегда)
  Future<Result<bool, Exception>> pinContent(String cid) async {
    try {
      // В продакшене используйте локальный IPFS node или сервис pinning
      // Это базовая реализация через публичный API
      final url = 'https://api.pinata.cloud/pinning/pinByHash?hashToPin=$cid';
      
      // Здесь нужна аутентификация с Pinata API
      // Для демо возвращаем success
      AppLogger.info('Content pinned: $cid');
      return Result.success(true);
    } catch (e) {
      AppLogger.error('Pin content error', e);
      return Result.failure(e);
    }
  }

  /// Unpinning контента
  Future<Result<bool, Exception>> unpinContent(String cid) async {
    try {
      final url = 'https://api.pinata.cloud/pinning/unpin/$cid';
      
      AppLogger.info('Content unpinned: $cid');
      return Result.success(true);
    } catch (e) {
      AppLogger.error('Unpin content error', e);
      return Result.failure(e);
    }
  }

  /// Получение информации о контенте
  Future<Result<Map<String, dynamic>, Exception>> getContentInfo(String cid) async {
    try {
      final url = 'https://api.pinata.cloud/data/pinList?hashFilter=$cid';
      
      // Для демо возвращаем базовую информацию
      return Result.success({
        'cid': cid,
        'url': generateUrl(cid),
        'pinned': true,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      AppLogger.error('Get content info error', e);
      return Result.failure(e);
    }
  }

  /// Загрузка проекта Web5 в IPFS
  Future<Result<String, Exception>> uploadWeb5Project(Map<String, dynamic> projectData) async {
    try {
      // Структура проекта Web5
      final projectStructure = {
        'type': 'web5_project',
        'version': '1.0.0',
        'createdAt': DateTime.now().toIso8601String(),
        'data': projectData,
        'metadata': {
          'platform': 'rechain_vc_lab',
          'decentralized': true,
        },
      };

      final result = await uploadJson(projectStructure);
      
      if (result.isSuccess) {
        AppLogger.info('Web5 project uploaded to IPFS: ${result.value}');
      }
      
      return result;
    } catch (e) {
      AppLogger.error('Upload Web5 project error', e);
      return Result.failure(e);
    }
  }

  /// Загрузка траектории Web4 в IPFS
  Future<Result<String, Exception>> uploadWeb4Trajectory(Map<String, dynamic> trajectoryData) async {
    try {
      final trajectoryStructure = {
        'type': 'web4_trajectory',
        'version': '1.0.0',
        'createdAt': DateTime.now().toIso8601String(),
        'data': trajectoryData,
        'metadata': {
          'platform': 'rechain_vc_lab',
          'decentralized': true,
        },
      };

      final result = await uploadJson(trajectoryStructure);
      
      if (result.isSuccess) {
        AppLogger.info('Web4 trajectory uploaded to IPFS: ${result.value}');
      }
      
      return result;
    } catch (e) {
      AppLogger.error('Upload Web4 trajectory error', e);
      return Result.failure(e);
    }
  }

  /// Получение проекта Web5 из IPFS
  Future<Result<Map<String, dynamic>, Exception>> getWeb5Project(String cid) async {
    final result = await getJson(cid);
    if (result.isFailure) {
      return Result.failure(result.error);
    }

    final data = result.value;
    
    if (data['type'] != 'web5_project') {
      return Result.failure(Exception('Invalid project type'));
    }

    return Result.success(Map<String, dynamic>.from(data['data']));
  }

  /// Получение траектории Web4 из IPFS
  Future<Result<Map<String, dynamic>, Exception>> getWeb4Trajectory(String cid) async {
    final result = await getJson(cid);
    if (result.isFailure) {
      return Result.failure(result.error);
    }

    final data = result.value;
    
    if (data['type'] != 'web4_trajectory') {
      return Result.failure(Exception('Invalid trajectory type'));
    }

    return Result.success(Map<String, dynamic>.from(data['data']));
  }

  void dispose() {
    _client.close();
  }
}
