import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/providers/realtime_notifications_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class RealtimeNotificationWidget extends StatelessWidget {
  final RealtimeNotification notification;
  final VoidCallback? onDismiss;
  final VoidCallback? onTap;

  const RealtimeNotificationWidget({
    super.key,
    required this.notification,
    this.onDismiss,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getPriorityColor(notification.priority).withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Индикатор приоритета
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: _getPriorityColor(notification.priority),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),
            ),
            // Основной контент
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Иконка категории
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(notification.priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(notification.category),
                      color: _getPriorityColor(notification.priority),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Текст уведомления
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getPriorityColor(notification.priority).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getPriorityText(notification.priority),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: _getPriorityColor(notification.priority),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _getCategoryText(notification.category),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              _formatTime(notification.timestamp),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Кнопка закрытия
                  if (onDismiss != null)
                    IconButton(
                      onPressed: onDismiss,
                      icon: const Icon(Icons.close, size: 18),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 1.0, end: 0.0);
  }

  Color _getPriorityColor(RealtimeNotificationPriority priority) {
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

  IconData _getCategoryIcon(RealtimeNotificationCategory category) {
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

  String _getPriorityText(RealtimeNotificationPriority priority) {
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

  String _getCategoryText(RealtimeNotificationCategory category) {
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

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return 'только что';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}м назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}ч назад';
    } else {
      return '${difference.inDays}д назад';
    }
  }
}

class RealtimeNotificationOverlay extends StatefulWidget {
  final Widget child;
  final RealtimeNotificationsProvider provider;

  const RealtimeNotificationOverlay({
    super.key,
    required this.child,
    required this.provider,
  });

  @override
  State<RealtimeNotificationOverlay> createState() => _RealtimeNotificationOverlayState();
}

class _RealtimeNotificationOverlayState extends State<RealtimeNotificationOverlay> {
  @override
  void initState() {
    super.initState();
    widget.provider.addListener(_onProviderChanged);
  }

  @override
  void dispose() {
    widget.provider.removeListener(_onProviderChanged);
    super.dispose();
  }

  void _onProviderChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Уведомления в реальном времени
        if (widget.provider.isEnabled && widget.provider.activeNotifications.isNotEmpty)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 0,
            right: 0,
            child: Column(
              children: widget.provider.activeNotifications
                  .take(3) // Показываем максимум 3 уведомления
                  .map((notification) => RealtimeNotificationWidget(
                        notification: notification,
                        onDismiss: () {
                          widget.provider.removeNotification(notification.id);
                        },
                        onTap: () {
                          // Обработка нажатия на уведомление
                          if (notification.actionUrl != null) {
                            // В реальном приложении здесь будет навигация
                            print('Navigating to: ${notification.actionUrl}');
                          }
                          widget.provider.removeNotification(notification.id);
                        },
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class RealtimeNotificationSettings extends StatelessWidget {
  final RealtimeNotificationsProvider provider;

  const RealtimeNotificationSettings({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Уведомления в реальном времени',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            // Включение/выключение
            SwitchListTile(
              title: const Text('Включить уведомления'),
              subtitle: const Text('Показывать уведомления в реальном времени'),
              value: provider.isEnabled,
              onChanged: (value) {
                provider.setEnabled(value);
              },
            ),
            // Максимальное количество уведомлений
            ListTile(
              title: const Text('Максимум уведомлений'),
              subtitle: Text('${provider.maxActiveNotifications}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: provider.maxActiveNotifications > 1
                        ? () => provider.setMaxActiveNotifications(provider.maxActiveNotifications - 1)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  Text('${provider.maxActiveNotifications}'),
                  IconButton(
                    onPressed: provider.maxActiveNotifications < 10
                        ? () => provider.setMaxActiveNotifications(provider.maxActiveNotifications + 1)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            // Время автоматического скрытия
            ListTile(
              title: const Text('Автоскрытие'),
              subtitle: Text('${provider.defaultAutoHideDuration.inSeconds} секунд'),
              trailing: DropdownButton<int>(
                value: provider.defaultAutoHideDuration.inSeconds,
                items: const [
                  DropdownMenuItem(value: 3, child: Text('3 сек')),
                  DropdownMenuItem(value: 5, child: Text('5 сек')),
                  DropdownMenuItem(value: 8, child: Text('8 сек')),
                  DropdownMenuItem(value: 10, child: Text('10 сек')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    provider.setDefaultAutoHideDuration(Duration(seconds: value));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
