import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: isRead ? 1 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: isRead
        ? theme.colorScheme.surface
        : theme.colorScheme.surface.withOpacity(0.95),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isRead
                ? theme.colorScheme.outline.withOpacity(0.2)
                : _getTypeColor(type).withOpacity(0.3),
              width: isRead ? 1 : 2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Иконка типа уведомления
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTypeColor(type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getTypeIcon(type),
                  color: _getTypeColor(type),
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Содержимое уведомления
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                              color: isRead
                                ? theme.colorScheme.onSurface.withOpacity(0.7)
                                : theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _getTypeColor(type),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(timestamp),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // Кнопка закрытия
              if (onDismiss != null)
                IconButton(
                  onPressed: onDismiss,
                  icon: Icon(
                    Icons.close,
                    size: 20,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, duration: 300.ms);
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.event:
        return Colors.purple;
      case NotificationType.challenge:
        return Colors.teal;
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return Icons.info;
      case NotificationType.success:
        return Icons.check_circle;
      case NotificationType.warning:
        return Icons.warning;
      case NotificationType.error:
        return Icons.error;
      case NotificationType.event:
        return Icons.event;
      case NotificationType.challenge:
        return Icons.emoji_events;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Только что';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} мин назад';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ч назад';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн назад';
    } else {
      return '${timestamp.day}.${timestamp.month}.${timestamp.year}';
    }
  }
}

enum NotificationType {
  info,
  success,
  warning,
  error,
  event,
  challenge,
}
