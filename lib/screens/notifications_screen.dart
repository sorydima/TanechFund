import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/notification_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  NotificationType? _selectedType;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.mark_email_read),
            onPressed: _markAllAsRead,
            tooltip: 'Отметить все как прочитанные',
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _showClearDialog,
            tooltip: 'Очистить уведомления',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Все'),
            Tab(text: 'Непрочитанные'),
            Tab(text: 'Прочитанные'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Поиск и фильтры
          _buildSearchAndFilters(),
          
          // Список уведомлений
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList(_getFilteredNotifications()),
                _buildNotificationsList(_getUnreadNotifications()),
                _buildNotificationsList(_getReadNotifications()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Поиск и фильтры
  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Поиск
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Поиск уведомлений...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (value) {
              setState(() => _searchQuery = value);
            },
          ),
          
          const SizedBox(height: 16),
          
          // Фильтры по типу
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTypeFilterChip(null, 'Все'),
                const SizedBox(width: 8),
                ...NotificationType.values.map((type) => 
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _buildTypeFilterChip(type, _getTypeName(type)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Чип фильтра по типу
  Widget _buildTypeFilterChip(NotificationType? type, String label) {
    final isSelected = _selectedType == type;
    final color = type != null 
        ? context.read<NotificationProvider>().getNotificationTypeColor(type)
        : AppTheme.primaryColor;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedType = selected ? type : null;
        });
      },
      selectedColor: color.withOpacity(0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      backgroundColor: Colors.grey[100],
      side: BorderSide(
        color: isSelected ? color : Colors.grey[300]!,
        width: isSelected ? 2 : 1,
      ),
    );
  }

  // Список уведомлений
  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification)
            .animate()
            .fadeIn(delay: (index * 50).ms, duration: 300.ms)
            .slideX(begin: 0.3, end: 0);
      },
    );
  }

  // Карточка уведомления
  Widget _buildNotificationCard(NotificationModel notification) {
    final provider = context.read<NotificationProvider>();
    final typeColor = provider.getNotificationTypeColor(notification.type);
    final typeIcon = provider.getNotificationTypeIcon(notification.type);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: notification.isRead ? 1 : 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: notification.isRead 
              ? Colors.grey[300]! 
              : typeColor.withOpacity(0.3),
          width: notification.isRead ? 1 : 2,
        ),
      ),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Иконка типа
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  typeIcon,
                  color: typeColor,
                  size: 20,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Содержимое
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: notification.isRead 
                                  ? FontWeight.w500 
                                  : FontWeight.w600,
                              color: notification.isRead 
                                  ? Colors.grey[700] 
                                  : Colors.black,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: typeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Сообщение
                    Text(
                      notification.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Время и действия
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Действия
                        if (notification.actionUrl != null)
                          TextButton(
                            onPressed: () => _handleNotificationAction(notification),
                            child: const Text('Открыть'),
                          ),
                        
                        IconButton(
                          icon: Icon(
                            notification.isRead 
                                ? Icons.mark_email_unread 
                                : Icons.mark_email_read,
                            size: 18,
                          ),
                          onPressed: () => _toggleReadStatus(notification),
                          tooltip: notification.isRead 
                              ? 'Отметить как непрочитанное' 
                              : 'Отметить как прочитанное',
                        ),
                        
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () => _deleteNotification(notification),
                          tooltip: 'Удалить',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Пустое состояние
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Уведомлений нет',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Здесь будут появляться новые уведомления',
            style: TextStyle(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Получение отфильтрованных уведомлений
  List<NotificationModel> _getFilteredNotifications() {
    final provider = context.read<NotificationProvider>();
    List<NotificationModel> notifications = provider.notifications;
    
    // Фильтр по поиску
    if (_searchQuery.isNotEmpty) {
      notifications = provider.searchNotifications(_searchQuery);
    }
    
    // Фильтр по типу
    if (_selectedType != null) {
      notifications = notifications.where((n) => n.type == _selectedType).toList();
    }
    
    return notifications;
  }

  // Получение непрочитанных уведомлений
  List<NotificationModel> _getUnreadNotifications() {
    final provider = context.read<NotificationProvider>();
    List<NotificationModel> notifications = provider.unreadNotifications;
    
    // Применяем дополнительные фильтры
    if (_searchQuery.isNotEmpty) {
      notifications = provider.searchNotifications(_searchQuery)
          .where((n) => !n.isRead)
          .toList();
    }
    
    if (_selectedType != null) {
      notifications = notifications.where((n) => n.type == _selectedType).toList();
    }
    
    return notifications;
  }

  // Получение прочитанных уведомлений
  List<NotificationModel> _getReadNotifications() {
    final provider = context.read<NotificationProvider>();
    List<NotificationModel> notifications = provider.readNotifications;
    
    // Применяем дополнительные фильтры
    if (_searchQuery.isNotEmpty) {
      notifications = provider.searchNotifications(_searchQuery)
          .where((n) => n.isRead)
          .toList();
    }
    
    if (_selectedType != null) {
      notifications = notifications.where((n) => n.type == _selectedType).toList();
    }
    
    return notifications;
  }

  // Обработка нажатия на уведомление
  void _handleNotificationTap(NotificationModel notification) {
    if (!notification.isRead) {
      context.read<NotificationProvider>().markAsRead(notification.id);
    }
    
    if (notification.actionUrl != null) {
      _handleNotificationAction(notification);
    }
  }

  // Обработка действия уведомления
  void _handleNotificationAction(NotificationModel notification) {
    // В реальном приложении здесь будет навигация
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открытие: ${notification.actionUrl}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Переключение статуса прочтения
  void _toggleReadStatus(NotificationModel notification) {
    if (notification.isRead) {
      // Отметить как непрочитанное
      final provider = context.read<NotificationProvider>();
      final index = provider.notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        provider.notifications[index] = notification.copyWith(isRead: false);
        provider.notifyListeners();
      }
    } else {
      // Отметить как прочитанное
      context.read<NotificationProvider>().markAsRead(notification.id);
    }
  }

  // Удаление уведомления
  void _deleteNotification(NotificationModel notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить уведомление'),
        content: Text('Вы уверены, что хотите удалить "${notification.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<NotificationProvider>().removeNotification(notification.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  // Отметить все как прочитанные
  void _markAllAsRead() {
    context.read<NotificationProvider>().markAllAsRead();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Все уведомления отмечены как прочитанные'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Диалог очистки
  void _showClearDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить уведомления'),
        content: const Text('Выберите, что хотите очистить:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<NotificationProvider>().clearReadNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Прочитанные уведомления очищены'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: const Text('Прочитанные'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<NotificationProvider>().clearAllNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Все уведомления очищены'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Все'),
          ),
        ],
      ),
    );
  }

  // Форматирование времени
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 0) {
      return DateFormat('dd.MM.yy').format(timestamp);
    } else if (difference.inHours > 0) {
      return '${difference.inHours}ч назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}м назад';
    } else {
      return 'Только что';
    }
  }

  // Получение названия типа
  String _getTypeName(NotificationType type) {
    switch (type) {
      case NotificationType.info:
        return 'Инфо';
      case NotificationType.success:
        return 'Успех';
      case NotificationType.warning:
        return 'Предупреждение';
      case NotificationType.error:
        return 'Ошибка';
      case NotificationType.hackathon:
        return 'Хакатон';
      case NotificationType.challenge:
        return 'Челлендж';
      case NotificationType.portfolio:
        return 'Портфолио';
      case NotificationType.system:
        return 'Система';
    }
  }
}
