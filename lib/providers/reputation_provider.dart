import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Модели для системы репутации
enum ReputationType {
  project,
  investment,
  mentorship,
  social,
  learning,
  hackathon,
  challenge,
  community,
  review,
  feedback,
}

enum ReputationAction {
  created,
  completed,
  helped,
  reviewed,
  invested,
  mentored,
  participated,
  won,
  contributed,
}

class ReputationEvent {
  final String id;
  final ReputationType type;
  final ReputationAction action;
  final int points;
  final String description;
  final DateTime timestamp;
  final String? relatedId; // ID связанного объекта (проект, инвестиция и т.д.)
  final Map<String, dynamic> metadata;

  ReputationEvent({
    required this.id,
    required this.type,
    required this.action,
    required this.points,
    required this.description,
    required this.timestamp,
    this.relatedId,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.index,
      'action': action.index,
      'points': points,
      'description': description,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'relatedId': relatedId,
      'metadata': metadata,
    };
  }

  factory ReputationEvent.fromJson(Map<String, dynamic> json) {
    return ReputationEvent(
      id: json['id'],
      type: ReputationType.values[json['type']],
      action: ReputationAction.values[json['action']],
      points: json['points'],
      description: json['description'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      relatedId: json['relatedId'],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }
}

class ReputationScore {
  final ReputationType type;
  final int totalPoints;
  final int eventCount;
  final double averageRating;
  final DateTime lastUpdated;
  final Map<String, int> actionBreakdown;

  ReputationScore({
    required this.type,
    required this.totalPoints,
    required this.eventCount,
    required this.averageRating,
    required this.lastUpdated,
    this.actionBreakdown = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'totalPoints': totalPoints,
      'eventCount': eventCount,
      'averageRating': averageRating,
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
      'actionBreakdown': actionBreakdown,
    };
  }

  factory ReputationScore.fromJson(Map<String, dynamic> json) {
    return ReputationScore(
      type: ReputationType.values[json['type']],
      totalPoints: json['totalPoints'],
      eventCount: json['eventCount'],
      averageRating: json['averageRating'].toDouble(),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(json['lastUpdated']),
      actionBreakdown: Map<String, int>.from(json['actionBreakdown'] ?? {}),
    );
  }
}

class UserReputation {
  final String userId;
  final int totalReputation;
  final String reputationLevel;
  final Color reputationColor;
  final List<ReputationScore> categoryScores;
  final List<ReputationEvent> recentEvents;
  final DateTime lastUpdated;

  UserReputation({
    required this.userId,
    required this.totalReputation,
    required this.reputationLevel,
    required this.reputationColor,
    required this.categoryScores,
    required this.recentEvents,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalReputation': totalReputation,
      'reputationLevel': reputationLevel,
      'reputationColor': reputationColor.value,
      'categoryScores': categoryScores.map((s) => s.toJson()).toList(),
      'recentEvents': recentEvents.map((e) => e.toJson()).toList(),
      'lastUpdated': lastUpdated.millisecondsSinceEpoch,
    };
  }

  factory UserReputation.fromJson(Map<String, dynamic> json) {
    return UserReputation(
      userId: json['userId'],
      totalReputation: json['totalReputation'],
      reputationLevel: json['reputationLevel'],
      reputationColor: Color(json['reputationColor']),
      categoryScores: (json['categoryScores'] as List)
          .map((s) => ReputationScore.fromJson(s))
          .toList(),
      recentEvents: (json['recentEvents'] as List)
          .map((e) => ReputationEvent.fromJson(e))
          .toList(),
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(json['lastUpdated']),
    );
  }
}

class ReputationProvider extends ChangeNotifier {
  UserReputation? _userReputation;
  List<ReputationEvent> _allEvents = [];
  Map<ReputationType, int> _reputationMultipliers = {};

  // Getters
  UserReputation? get userReputation => _userReputation;
  List<ReputationEvent> get allEvents => _allEvents;
  int get totalReputation => _userReputation?.totalReputation ?? 0;
  String get reputationLevel => _userReputation?.reputationLevel ?? 'Новичок';
  Color get reputationColor => _userReputation?.reputationColor ?? Colors.grey;

  // Инициализация
  Future<void> initialize() async {
    await _loadData();
    await _initializeMultipliers();
    if (_userReputation == null) {
      await _createDefaultReputation();
    }
  }

  // Загрузка данных
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final reputationJson = prefs.getString('user_reputation');
    if (reputationJson != null) {
      _userReputation = UserReputation.fromJson(json.decode(reputationJson));
    }

    final eventsJson = prefs.getString('reputation_events');
    if (eventsJson != null) {
      final List<dynamic> eventsList = json.decode(eventsJson);
      _allEvents = eventsList.map((json) => ReputationEvent.fromJson(json)).toList();
    }

    notifyListeners();
  }

  // Сохранение данных
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    if (_userReputation != null) {
      await prefs.setString('user_reputation', json.encode(_userReputation!.toJson()));
    }
    
    await prefs.setString('reputation_events', json.encode(_allEvents.map((e) => e.toJson()).toList()));
  }

  // Инициализация множителей репутации
  Future<void> _initializeMultipliers() async {
    _reputationMultipliers = {
      ReputationType.project: 10,
      ReputationType.investment: 15,
      ReputationType.mentorship: 20,
      ReputationType.social: 5,
      ReputationType.learning: 8,
      ReputationType.hackathon: 25,
      ReputationType.challenge: 12,
      ReputationType.community: 15,
      ReputationType.review: 3,
      ReputationType.feedback: 5,
    };
  }

  // Создание репутации по умолчанию
  Future<void> _createDefaultReputation() async {
    _userReputation = UserReputation(
      userId: 'current_user',
      totalReputation: 0,
      reputationLevel: 'Новичок',
      reputationColor: Colors.grey,
      categoryScores: ReputationType.values.map((type) => ReputationScore(
        type: type,
        totalPoints: 0,
        eventCount: 0,
        averageRating: 0.0,
        lastUpdated: DateTime.now(),
      )).toList(),
      recentEvents: [],
      lastUpdated: DateTime.now(),
    );
    
    await _saveData();
  }

  // Добавление события репутации
  Future<void> addReputationEvent({
    required ReputationType type,
    required ReputationAction action,
    required String description,
    String? relatedId,
    Map<String, dynamic> metadata = const {},
  }) async {
    final basePoints = _getBasePoints(action);
    final multiplier = _reputationMultipliers[type] ?? 1;
    final finalPoints = (basePoints * multiplier).round();

    final event = ReputationEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      action: action,
      points: finalPoints,
      description: description,
      timestamp: DateTime.now(),
      relatedId: relatedId,
      metadata: metadata,
    );

    _allEvents.add(event);
    await _updateReputation(event);
    await _saveData();
    notifyListeners();
  }

  // Получение базовых очков за действие
  int _getBasePoints(ReputationAction action) {
    switch (action) {
      case ReputationAction.created:
        return 5;
      case ReputationAction.completed:
        return 10;
      case ReputationAction.helped:
        return 8;
      case ReputationAction.reviewed:
        return 3;
      case ReputationAction.invested:
        return 15;
      case ReputationAction.mentored:
        return 12;
      case ReputationAction.participated:
        return 6;
      case ReputationAction.won:
        return 20;
      case ReputationAction.contributed:
        return 7;
    }
  }

  // Обновление репутации
  Future<void> _updateReputation(ReputationEvent event) async {
    if (_userReputation == null) return;

    // Обновляем общую репутацию
    final newTotalReputation = _userReputation!.totalReputation + event.points;

    // Обновляем счет по категории
    final categoryIndex = _userReputation!.categoryScores.indexWhere(
      (score) => score.type == event.type,
    );

    if (categoryIndex != -1) {
      final oldScore = _userReputation!.categoryScores[categoryIndex];
      final newScore = ReputationScore(
        type: event.type,
        totalPoints: oldScore.totalPoints + event.points,
        eventCount: oldScore.eventCount + 1,
        averageRating: (oldScore.totalPoints + event.points) / (oldScore.eventCount + 1),
        lastUpdated: DateTime.now(),
        actionBreakdown: {
          ...oldScore.actionBreakdown,
          event.action.name: (oldScore.actionBreakdown[event.action.name] ?? 0) + 1,
        },
      );

      _userReputation!.categoryScores[categoryIndex] = newScore;
    }

    // Добавляем событие в недавние
    _userReputation!.recentEvents.insert(0, event);
    if (_userReputation!.recentEvents.length > 20) {
      _userReputation!.recentEvents.removeLast();
    }

    // Обновляем уровень репутации
    final newLevel = _calculateReputationLevel(newTotalReputation);
    final newColor = _getReputationColor(newLevel);

    _userReputation = UserReputation(
      userId: _userReputation!.userId,
      totalReputation: newTotalReputation,
      reputationLevel: newLevel,
      reputationColor: newColor,
      categoryScores: _userReputation!.categoryScores,
      recentEvents: _userReputation!.recentEvents,
      lastUpdated: DateTime.now(),
    );
  }

  // Расчет уровня репутации
  String _calculateReputationLevel(int totalReputation) {
    if (totalReputation < 100) return 'Новичок';
    if (totalReputation < 500) return 'Участник';
    if (totalReputation < 1000) return 'Активный';
    if (totalReputation < 2500) return 'Опытный';
    if (totalReputation < 5000) return 'Эксперт';
    if (totalReputation < 10000) return 'Мастер';
    if (totalReputation < 25000) return 'Гуру';
    return 'Легенда';
  }

  // Получение цвета репутации
  Color _getReputationColor(String level) {
    switch (level) {
      case 'Новичок':
        return Colors.grey;
      case 'Участник':
        return Colors.green;
      case 'Активный':
        return Colors.blue;
      case 'Опытный':
        return Colors.purple;
      case 'Эксперт':
        return Colors.orange;
      case 'Мастер':
        return Colors.red;
      case 'Гуру':
        return Colors.pink;
      case 'Легенда':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  // Получение репутации по категории
  ReputationScore? getReputationByType(ReputationType type) {
    return _userReputation?.categoryScores.firstWhere(
      (score) => score.type == type,
      orElse: () => ReputationScore(
        type: type,
        totalPoints: 0,
        eventCount: 0,
        averageRating: 0.0,
        lastUpdated: DateTime.now(),
      ),
    );
  }

  // Получение топ категорий
  List<ReputationScore> getTopCategories({int limit = 5}) {
    if (_userReputation == null) return [];
    
    final sortedScores = List<ReputationScore>.from(_userReputation!.categoryScores);
    sortedScores.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
    
    return sortedScores.take(limit).toList();
  }

  // Получение недавних событий
  List<ReputationEvent> getRecentEvents({int limit = 10}) {
    return _allEvents.take(limit).toList();
  }

  // Получение событий по типу
  List<ReputationEvent> getEventsByType(ReputationType type) {
    return _allEvents.where((event) => event.type == type).toList();
  }

  // Получение статистики
  Map<String, dynamic> getStatistics() {
    if (_userReputation == null) {
      return {
        'totalReputation': 0,
        'reputationLevel': 'Новичок',
        'totalEvents': 0,
        'topCategory': null,
        'recentActivity': 0,
      };
    }

    final topCategory = getTopCategories(limit: 1).isNotEmpty 
        ? getTopCategories(limit: 1).first 
        : null;

    final recentActivity = _allEvents.where(
      (event) => event.timestamp.isAfter(DateTime.now().subtract(const Duration(days: 7))),
    ).length;

    return {
      'totalReputation': _userReputation!.totalReputation,
      'reputationLevel': _userReputation!.reputationLevel,
      'totalEvents': _allEvents.length,
      'topCategory': topCategory?.type.name,
      'recentActivity': recentActivity,
    };
  }

  // Симуляция событий для демонстрации
  Future<void> simulateEvents() async {
    final events = [
      {
        'type': ReputationType.project,
        'action': ReputationAction.created,
        'description': 'Создан проект "DeFi Analytics Platform"',
        'relatedId': 'project_1',
      },
      {
        'type': ReputationType.mentorship,
        'action': ReputationAction.mentored,
        'description': 'Проведена сессия менторства',
        'relatedId': 'session_1',
      },
      {
        'type': ReputationType.hackathon,
        'action': ReputationAction.won,
        'description': 'Победа в хакатоне "Blockchain Innovation"',
        'relatedId': 'hackathon_1',
      },
      {
        'type': ReputationType.community,
        'action': ReputationAction.helped,
        'description': 'Помощь новому участнику',
        'relatedId': 'user_123',
      },
      {
        'type': ReputationType.investment,
        'action': ReputationAction.invested,
        'description': 'Инвестиция в проект "NFT Marketplace"',
        'relatedId': 'investment_1',
      },
    ];

    for (final eventData in events) {
      await addReputationEvent(
        type: eventData['type'] as ReputationType,
        action: eventData['action'] as ReputationAction,
        description: eventData['description'] as String,
        relatedId: eventData['relatedId'] as String?,
      );
    }
  }
}
