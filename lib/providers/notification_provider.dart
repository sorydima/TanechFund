import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum NotificationType {
  info,
  success,
  warning,
  error,
  hackathon,
  challenge,
  portfolio,
  system,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final Map<String, dynamic>? data;
  final String? actionUrl;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.data,
    this.actionUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type.index,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'data': data,
      'actionUrl': actionUrl,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      type: NotificationType.values[json['type']],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
      data: json['data'],
      actionUrl: json['actionUrl'],
    );
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    Map<String, dynamic>? data,
    String? actionUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      data: data ?? this.data,
      actionUrl: actionUrl ?? this.actionUrl,
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;
  String? _error;

  // Геттеры
  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Фильтрованные уведомления
  List<NotificationModel> get unreadNotifications => 
      _notifications.where((n) => !n.isRead).toList();
  
  List<NotificationModel> get readNotifications => 
      _notifications.where((n) => n.isRead).toList();

  NotificationProvider() {
    _loadNotifications();
    _createDemoNotifications();
  }

  // Загрузка уведомлений
  Future<void> _loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = prefs.getStringList('notifications') ?? [];
      
      _notifications = notificationsJson
          .map((json) => NotificationModel.fromJson(jsonDecode(json)))
          .toList();
      
      _updateUnreadCount();
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка загрузки уведомлений: $e';
      notifyListeners();
    }
  }

  // Сохранение уведомлений
  Future<void> _saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = _notifications
          .map((n) => jsonEncode(n.toJson()))
          .toList();
      
      await prefs.setStringList('notifications', notificationsJson);
    } catch (e) {
      _error = 'Ошибка сохранения уведомлений: $e';
      notifyListeners();
    }
  }

  // Создание демо уведомлений
  void _createDemoNotifications() {
    if (_notifications.isEmpty) {
      final demoNotifications = [
        NotificationModel(
          id: 'demo_1',
          title: 'Добро пожаловать в REChain VC Lab!',
          message: 'Начните свой путь в мире блокчейн-разработки',
          type: NotificationType.success,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          data: {'screen': 'home'},
        ),
        NotificationModel(
          id: 'demo_2',
          title: 'Новый хакатон: Solana Builders',
          message: 'Призовой фонд \$50,000. Регистрация открыта!',
          type: NotificationType.hackathon,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          data: {'screen': 'hackathons', 'hackathon_id': 'solana_001'},
          actionUrl: '/hackathons/solana_001',
        ),
        NotificationModel(
          id: 'demo_3',
          title: 'Обновление профиля',
          message: 'Ваш профиль был успешно обновлен',
          type: NotificationType.info,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          data: {'screen': 'profile'},
        ),
        NotificationModel(
          id: 'demo_4',
          title: 'Новый челлендж: DeFi Protocol',
          message: 'Создайте протокол децентрализованных финансов',
          type: NotificationType.challenge,
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          data: {'screen': 'challenges', 'challenge_id': 'defi_001'},
          actionUrl: '/challenges/defi_001',
        ),
      ];
      
      _notifications.addAll(demoNotifications);
      _updateUnreadCount();
      _saveNotifications();
      notifyListeners();
    }
  }

  // Добавление нового уведомления
  Future<void> addNotification({
    required String title,
    required String message,
    required NotificationType type,
    Map<String, dynamic>? data,
    String? actionUrl,
  }) async {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
      timestamp: DateTime.now(),
      data: data,
      actionUrl: actionUrl,
    );

    _notifications.insert(0, notification);
    _updateUnreadCount();
    await _saveNotifications();
    notifyListeners();
  }

  // Отметка уведомления как прочитанного
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      _updateUnreadCount();
      await _saveNotifications();
      notifyListeners();
    }
  }

  // Отметка всех уведомлений как прочитанных
  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    _updateUnreadCount();
    await _saveNotifications();
    notifyListeners();
  }

  // Удаление уведомления
  Future<void> removeNotification(String notificationId) async {
    _notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadCount();
    await _saveNotifications();
    notifyListeners();
  }

  // Очистка всех уведомлений
  Future<void> clearAllNotifications() async {
    _notifications.clear();
    _updateUnreadCount();
    await _saveNotifications();
    notifyListeners();
  }

  // Очистка прочитанных уведомлений
  Future<void> clearReadNotifications() async {
    _notifications.removeWhere((n) => n.isRead);
    _updateUnreadCount();
    await _saveNotifications();
    notifyListeners();
  }

  // Обновление счетчика непрочитанных
  void _updateUnreadCount() {
    _unreadCount = _notifications.where((n) => !n.isRead).length;
  }

  // Получение уведомлений по типу
  List<NotificationModel> getNotificationsByType(NotificationType type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // Поиск уведомлений
  List<NotificationModel> searchNotifications(String query) {
    if (query.isEmpty) return _notifications;
    
    return _notifications.where((n) =>
        n.title.toLowerCase().contains(query.toLowerCase()) ||
        n.message.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Получение уведомлений за период
  List<NotificationModel> getNotificationsInPeriod(DateTime start, DateTime end) {
    return _notifications.where((n) =>
        n.timestamp.isAfter(start) && n.timestamp.isBefore(end)
    ).toList();
  }

  // Получение уведомлений за сегодня
  List<NotificationModel> getTodayNotifications() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return getNotificationsInPeriod(startOfDay, endOfDay);
  }

  // Получение уведомлений за неделю
  List<NotificationModel> getWeekNotifications() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));
    
    return getNotificationsInPeriod(startOfWeek, endOfWeek);
  }

  // Создание системного уведомления
  Future<void> createSystemNotification({
    required String title,
    required String message,
    Map<String, dynamic>? data,
  }) async {
    await addNotification(
      title: title,
      message: message,
      type: NotificationType.system,
      data: data,
    );
  }

  // Создание уведомления о хакатоне
  Future<void> createHackathonNotification({
    required String title,
    required String message,
    required String hackathonId,
    String? actionUrl,
  }) async {
    await addNotification(
      title: title,
      message: message,
      type: NotificationType.hackathon,
      data: {'hackathon_id': hackathonId},
      actionUrl: actionUrl,
    );
  }

  // Создание уведомления о челлендже
  Future<void> createChallengeNotification({
    required String title,
    required String message,
    required String challengeId,
    String? actionUrl,
  }) async {
    await addNotification(
      title: title,
      message: message,
      type: NotificationType.challenge,
      data: {'challenge_id': challengeId},
      actionUrl: actionUrl,
    );
  }

  // Обработка действия уведомления
  void handleNotificationAction(NotificationModel notification) {
    if (notification.actionUrl != null) {
      // В реальном приложении здесь будет навигация
      print('Navigating to: ${notification.actionUrl}');
    }
    
    if (!notification.isRead) {
      markAsRead(notification.id);
    }
  }

  // Получение цвета для типа уведомления
  Color getNotificationTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.hackathon:
        return Colors.purple;
      case NotificationType.challenge:
        return Colors.teal;
      case NotificationType.portfolio:
        return Colors.indigo;
      case NotificationType.system:
        return Colors.grey;
    }
  }

  // Получение иконки для типа уведомления
  IconData getNotificationTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.hackathon:
        return Icons.event;
      case NotificationType.challenge:
        return Icons.emoji_events_outlined;
      case NotificationType.portfolio:
        return Icons.work_outline;
      case NotificationType.system:
        return Icons.settings_outlined;
    }
  }
}
