import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/providers/notification_provider.dart';
import 'package:rechain_vc_lab/providers/reputation_provider.dart';
import 'package:rechain_vc_lab/providers/achievements_provider.dart';

// Модели для уведомлений в реальном времени
enum RealtimeNotificationPriority {
  low,
  medium,
  high,
  critical,
}

enum RealtimeNotificationCategory {
  achievement,
  reputation,
  hackathon,
  challenge,
  investment,
  mentorship,
  social,
  system,
  security,
}

class RealtimeNotification {
  final String id;
  final String title;
  final String message;
  final RealtimeNotificationPriority priority;
  final RealtimeNotificationCategory category;
  final DateTime timestamp;
  final Map<String, dynamic>? data;
  final String? actionUrl;
  final bool isPersistent;
  final Duration? autoHideDuration;

  RealtimeNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.priority,
    required this.category,
    required this.timestamp,
    this.data,
    this.actionUrl,
    this.isPersistent = false,
    this.autoHideDuration,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'priority': priority.index,
      'category': category.index,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'data': data,
      'actionUrl': actionUrl,
      'isPersistent': isPersistent,
      'autoHideDuration': autoHideDuration?.inMilliseconds,
    };
  }

  factory RealtimeNotification.fromJson(Map<String, dynamic> json) {
    return RealtimeNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      priority: RealtimeNotificationPriority.values[json['priority']],
      category: RealtimeNotificationCategory.values[json['category']],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      data: json['data'],
      actionUrl: json['actionUrl'],
      isPersistent: json['isPersistent'] ?? false,
      autoHideDuration: json['autoHideDuration'] != null 
          ? Duration(milliseconds: json['autoHideDuration'])
          : null,
    );
  }
}

class RealtimeNotificationsProvider extends ChangeNotifier {
  final List<RealtimeNotification> _activeNotifications = [];
  final List<RealtimeNotification> _notificationHistory = [];
  final Map<String, Timer> _autoHideTimers = {};
  
  // Настройки
  bool _isEnabled = true;
  int _maxActiveNotifications = 5;
  Duration _defaultAutoHideDuration = const Duration(seconds: 5);
  
  // Провайдеры
  late NotificationProvider _notificationProvider;
  late ReputationProvider _reputationProvider;
  late AchievementsProvider _achievementsProvider;
  
  // Таймеры для симуляции
  Timer? _simulationTimer;
  final Random _random = Random();

  // Getters
  List<RealtimeNotification> get activeNotifications => _activeNotifications;
  List<RealtimeNotification> get notificationHistory => _notificationHistory;
  bool get isEnabled => _isEnabled;
  int get maxActiveNotifications => _maxActiveNotifications;
  Duration get defaultAutoHideDuration => _defaultAutoHideDuration;

  // Инициализация
  void initialize({
    required NotificationProvider notificationProvider,
    required ReputationProvider reputationProvider,
    required AchievementsProvider achievementsProvider,
  }) {
    _notificationProvider = notificationProvider;
    _reputationProvider = reputationProvider;
    _achievementsProvider = achievementsProvider;
    
    _startSimulation();
  }

  // Включение/выключение уведомлений
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
    if (!enabled) {
      _clearAllNotifications();
    }
    notifyListeners();
  }

  // Установка максимального количества активных уведомлений
  void setMaxActiveNotifications(int max) {
    _maxActiveNotifications = max;
    _trimActiveNotifications();
    notifyListeners();
  }

  // Установка времени автоматического скрытия
  void setDefaultAutoHideDuration(Duration duration) {
    _defaultAutoHideDuration = duration;
    notifyListeners();
  }

  // Добавление уведомления
  void addNotification(RealtimeNotification notification) {
    if (!_isEnabled) return;

    _activeNotifications.insert(0, notification);
    _notificationHistory.insert(0, notification);
    
    // Ограничиваем количество активных уведомлений
    _trimActiveNotifications();
    
    // Ограничиваем историю
    if (_notificationHistory.length > 100) {
      _notificationHistory.removeRange(100, _notificationHistory.length);
    }

    // Автоматическое скрытие
    if (!notification.isPersistent) {
      final duration = notification.autoHideDuration ?? _defaultAutoHideDuration;
      _autoHideTimers[notification.id] = Timer(duration, () {
        removeNotification(notification.id);
      });
    }

    notifyListeners();
  }

  // Удаление уведомления
  void removeNotification(String notificationId) {
    _activeNotifications.removeWhere((n) => n.id == notificationId);
    
    // Отменяем таймер автоскрытия
    _autoHideTimers[notificationId]?.cancel();
    _autoHideTimers.remove(notificationId);
    
    notifyListeners();
  }

  // Очистка всех активных уведомлений
  void _clearAllNotifications() {
    for (final timer in _autoHideTimers.values) {
      timer.cancel();
    }
    _autoHideTimers.clear();
    _activeNotifications.clear();
    notifyListeners();
  }

  // Ограничение количества активных уведомлений
  void _trimActiveNotifications() {
    while (_activeNotifications.length > _maxActiveNotifications) {
      final removed = _activeNotifications.removeLast();
      _autoHideTimers[removed.id]?.cancel();
      _autoHideTimers.remove(removed.id);
    }
  }

  // Создание уведомления о достижении
  void createAchievementNotification({
    required String title,
    required String message,
    required String achievementId,
    RealtimeNotificationPriority priority = RealtimeNotificationPriority.medium,
  }) {
    final notification = RealtimeNotification(
      id: 'achievement_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      priority: priority,
      category: RealtimeNotificationCategory.achievement,
      timestamp: DateTime.now(),
      data: {'achievement_id': achievementId},
      isPersistent: priority == RealtimeNotificationPriority.critical,
      autoHideDuration: priority == RealtimeNotificationPriority.high 
          ? const Duration(seconds: 8)
          : const Duration(seconds: 5),
    );

    addNotification(notification);
  }

  // Создание уведомления о репутации
  void createReputationNotification({
    required String title,
    required String message,
    required ReputationType type,
    required int points,
    RealtimeNotificationPriority priority = RealtimeNotificationPriority.low,
  }) {
    final notification = RealtimeNotification(
      id: 'reputation_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      priority: priority,
      category: RealtimeNotificationCategory.reputation,
      timestamp: DateTime.now(),
      data: {
        'type': type.name,
        'points': points,
      },
      autoHideDuration: const Duration(seconds: 4),
    );

    addNotification(notification);
  }

  // Создание уведомления о хакатоне
  void createHackathonNotification({
    required String title,
    required String message,
    required String hackathonId,
    RealtimeNotificationPriority priority = RealtimeNotificationPriority.medium,
  }) {
    final notification = RealtimeNotification(
      id: 'hackathon_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      priority: priority,
      category: RealtimeNotificationCategory.hackathon,
      timestamp: DateTime.now(),
      data: {'hackathon_id': hackathonId},
      actionUrl: '/hackathons/$hackathonId',
      isPersistent: priority == RealtimeNotificationPriority.high,
    );

    addNotification(notification);
  }

  // Создание уведомления о челлендже
  void createChallengeNotification({
    required String title,
    required String message,
    required String challengeId,
    RealtimeNotificationPriority priority = RealtimeNotificationPriority.medium,
  }) {
    final notification = RealtimeNotification(
      id: 'challenge_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      priority: priority,
      category: RealtimeNotificationCategory.challenge,
      timestamp: DateTime.now(),
      data: {'challenge_id': challengeId},
      actionUrl: '/challenges/$challengeId',
    );

    addNotification(notification);
  }

  // Создание системного уведомления
  void createSystemNotification({
    required String title,
    required String message,
    RealtimeNotificationPriority priority = RealtimeNotificationPriority.medium,
    bool isPersistent = false,
  }) {
    final notification = RealtimeNotification(
      id: 'system_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      priority: priority,
      category: RealtimeNotificationCategory.system,
      timestamp: DateTime.now(),
      isPersistent: isPersistent,
      autoHideDuration: isPersistent ? null : const Duration(seconds: 6),
    );

    addNotification(notification);
  }

  // Создание уведомления о безопасности
  void createSecurityNotification({
    required String title,
    required String message,
    RealtimeNotificationPriority priority = RealtimeNotificationPriority.critical,
  }) {
    final notification = RealtimeNotification(
      id: 'security_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      priority: priority,
      category: RealtimeNotificationCategory.security,
      timestamp: DateTime.now(),
      isPersistent: true,
    );

    addNotification(notification);
  }

  // Получение цвета приоритета
  Color getPriorityColor(RealtimeNotificationPriority priority) {
    switch (priority) {
      case RealtimeNotificationPriority.low:
        return Colors.grey;
      case RealtimeNotificationPriority.medium:
        return Colors.blue;
      case RealtimeNotificationPriority.high:
        return Colors.orange;
      case RealtimeNotificationPriority.critical:
        return Colors.red;
    }
  }

  // Получение иконки категории
  IconData getCategoryIcon(RealtimeNotificationCategory category) {
    switch (category) {
      case RealtimeNotificationCategory.achievement:
        return Icons.emoji_events;
      case RealtimeNotificationCategory.reputation:
        return Icons.stars;
      case RealtimeNotificationCategory.hackathon:
        return Icons.event;
      case RealtimeNotificationCategory.challenge:
        return Icons.emoji_events_outlined;
      case RealtimeNotificationCategory.investment:
        return Icons.trending_up;
      case RealtimeNotificationCategory.mentorship:
        return Icons.psychology;
      case RealtimeNotificationCategory.social:
        return Icons.people;
      case RealtimeNotificationCategory.system:
        return Icons.settings;
      case RealtimeNotificationCategory.security:
        return Icons.security;
    }
  }

  // Получение текста приоритета
  String getPriorityText(RealtimeNotificationPriority priority) {
    switch (priority) {
      case RealtimeNotificationPriority.low:
        return 'Низкий';
      case RealtimeNotificationPriority.medium:
        return 'Средний';
      case RealtimeNotificationPriority.high:
        return 'Высокий';
      case RealtimeNotificationPriority.critical:
        return 'Критический';
    }
  }

  // Получение текста категории
  String getCategoryText(RealtimeNotificationCategory category) {
    switch (category) {
      case RealtimeNotificationCategory.achievement:
        return 'Достижение';
      case RealtimeNotificationCategory.reputation:
        return 'Репутация';
      case RealtimeNotificationCategory.hackathon:
        return 'Хакатон';
      case RealtimeNotificationCategory.challenge:
        return 'Челлендж';
      case RealtimeNotificationCategory.investment:
        return 'Инвестиция';
      case RealtimeNotificationCategory.mentorship:
        return 'Менторство';
      case RealtimeNotificationCategory.social:
        return 'Социальное';
      case RealtimeNotificationCategory.system:
        return 'Система';
      case RealtimeNotificationCategory.security:
        return 'Безопасность';
    }
  }

  // Симуляция уведомлений для демонстрации
  void _startSimulation() {
    _simulationTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (!_isEnabled) return;
      
      _simulateRandomNotification();
    });
  }

  void _simulateRandomNotification() {
    final types = [
      'achievement',
      'reputation',
      'hackathon',
      'challenge',
      'system',
    ];
    
    final type = types[_random.nextInt(types.length)];
    
    switch (type) {
      case 'achievement':
        _simulateAchievementNotification();
        break;
      case 'reputation':
        _simulateReputationNotification();
        break;
      case 'hackathon':
        _simulateHackathonNotification();
        break;
      case 'challenge':
        _simulateChallengeNotification();
        break;
      case 'system':
        _simulateSystemNotification();
        break;
    }
  }

  void _simulateAchievementNotification() {
    final achievements = [
      'Первый проект',
      'Мастер проектов',
      'Гуру инвестиций',
      'Эксперт-ментор',
      'Социальная бабочка',
    ];
    
    final achievement = achievements[_random.nextInt(achievements.length)];
    
    createAchievementNotification(
      title: '🎉 Новое достижение!',
      message: 'Вы получили достижение "$achievement"',
      achievementId: 'demo_${_random.nextInt(1000)}',
      priority: RealtimeNotificationPriority.medium,
    );
  }

  void _simulateReputationNotification() {
    final types = [
      (ReputationType.project, 'Создание проекта'),
      (ReputationType.mentorship, 'Помощь участнику'),
      (ReputationType.community, 'Активность в сообществе'),
    ];
    
    final (type, description) = types[_random.nextInt(types.length)];
    final points = 10 + _random.nextInt(50);
    
    createReputationNotification(
      title: '⭐ Репутация обновлена',
      message: '$description: +$points очков',
      type: type,
      points: points,
      priority: RealtimeNotificationPriority.low,
    );
  }

  void _simulateHackathonNotification() {
    final hackathons = [
      'Solana Builders',
      'Ethereum Hackathon',
      'Polygon DeFi',
      'Avalanche Innovation',
    ];
    
    final hackathon = hackathons[_random.nextInt(hackathons.length)];
    
    createHackathonNotification(
      title: '🚀 Новый хакатон!',
      message: '$hackathon - призовой фонд \$50,000',
      hackathonId: 'demo_${_random.nextInt(1000)}',
      priority: RealtimeNotificationPriority.medium,
    );
  }

  void _simulateChallengeNotification() {
    final challenges = [
      'DeFi Protocol',
      'NFT Marketplace',
      'DAO Governance',
      'Cross-chain Bridge',
    ];
    
    final challenge = challenges[_random.nextInt(challenges.length)];
    
    createChallengeNotification(
      title: '⚔️ Новый челлендж!',
      message: 'Создайте $challenge и получите награду',
      challengeId: 'demo_${_random.nextInt(1000)}',
      priority: RealtimeNotificationPriority.medium,
    );
  }

  void _simulateSystemNotification() {
    final messages = [
      'Система обновлена до версии 2.1.0',
      'Добавлены новые функции в портфолио',
      'Улучшена производительность приложения',
      'Исправлены мелкие ошибки',
    ];
    
    final message = messages[_random.nextInt(messages.length)];
    
    createSystemNotification(
      title: '🔧 Обновление системы',
      message: message,
      priority: RealtimeNotificationPriority.low,
    );
  }

  // Остановка симуляции
  void stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
  }

  @override
  void dispose() {
    stopSimulation();
    for (final timer in _autoHideTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }
}
