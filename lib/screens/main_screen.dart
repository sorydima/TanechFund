import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:rechain_vc_lab/providers/notification_provider.dart';
import 'package:rechain_vc_lab/screens/home_screen.dart';
import 'package:rechain_vc_lab/screens/hackathons_screen.dart';
import 'package:rechain_vc_lab/screens/challenges_screen.dart';
import 'package:rechain_vc_lab/screens/portfolio_screen.dart';
import 'package:rechain_vc_lab/screens/profile_screen.dart';
import 'package:rechain_vc_lab/screens/platform_compiler_screen.dart';
import 'package:rechain_vc_lab/screens/notifications_screen.dart';
import 'package:rechain_vc_lab/screens/chat_screen.dart';
import 'package:rechain_vc_lab/screens/learning_screen.dart';
import 'package:rechain_vc_lab/screens/compiler_screen.dart';
import 'package:rechain_vc_lab/screens/investments_screen.dart';
import 'package:rechain_vc_lab/screens/mentorship_screen.dart';
import 'package:rechain_vc_lab/screens/analytics_screen.dart';
import 'package:rechain_vc_lab/screens/social_network_screen.dart';
import 'package:rechain_vc_lab/screens/metaverse_screen.dart';
import 'package:rechain_vc_lab/screens/ai_ml_screen.dart';
import 'package:rechain_vc_lab/screens/achievements_screen.dart';
import 'package:rechain_vc_lab/screens/reputation_screen.dart';
import 'package:rechain_vc_lab/providers/achievements_provider.dart';
import 'package:rechain_vc_lab/providers/reputation_provider.dart';
import 'package:rechain_vc_lab/providers/realtime_notifications_provider.dart';
import 'package:rechain_vc_lab/widgets/realtime_notification_widget.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const HackathonsScreen(),
    const ChallengesScreen(),
    const ChatScreen(),
    const LearningScreen(),
    const PortfolioScreen(),
    const CompilerScreen(),
    const InvestmentsScreen(),
    const MentorshipScreen(),
    const AnalyticsScreen(),
    const SocialNetworkScreen(),
    const MetaverseScreen(),
    const AIMLScreen(),
    const AchievementsScreen(),
    const ReputationScreen(),
    const ProfileScreen(),
  ];

  // Метод для автоматической прокрутки к выбранной вкладке
  void _scrollToSelectedTab(int index) {
    if (_scrollController.hasClients) {
      // Вычисляем позицию для прокрутки
      final double itemWidth = 80.0; // Примерная ширина одной кнопки
      final double screenWidth = MediaQuery.of(context).size.width;
      final double scrollPosition = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);
      
      _scrollController.animateTo(
        scrollPosition.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
    });
  }

  void _initializeProviders() {
    final achievementsProvider = context.read<AchievementsProvider>();
    final reputationProvider = context.read<ReputationProvider>();
    final realtimeNotificationsProvider = context.read<RealtimeNotificationsProvider>();
    
    // Инициализируем провайдеры
    achievementsProvider.initialize();
    reputationProvider.initialize();
    
    // Инициализируем провайдер уведомлений в реальном времени
    realtimeNotificationsProvider.initialize(
      notificationProvider: context.read<NotificationProvider>(),
      reputationProvider: reputationProvider,
      achievementsProvider: achievementsProvider,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RealtimeNotificationsProvider>(
      builder: (context, realtimeProvider, child) {
        return RealtimeNotificationOverlay(
          provider: realtimeProvider,
          child: Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Индикатор текущей вкладки
                    Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: List.generate(16, (index) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 4,
                              decoration: BoxDecoration(
                                color: _currentIndex == index 
                                    ? AppTheme.primaryColor 
                                    : Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Горизонтальный слайдер с навигационными кнопками
                    Stack(
                      children: [
                        SingleChildScrollView(
                          controller: _scrollController,
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              _buildNavItem(0, Icons.home, 'Главная'),
                              _buildNavItem(1, Icons.event, 'Хакатоны'),
                              _buildNavItem(2, Icons.emoji_events, 'Челленджи'),
                              _buildNavItem(3, Icons.chat, 'Чаты'),
                              _buildNavItem(4, Icons.school, 'Обучение'),
                              _buildNavItem(5, Icons.work, 'Портфолио'),
                              _buildNavItem(6, Icons.build, 'Компилятор'),
                              _buildNavItem(7, Icons.trending_up, 'Инвестиции'),
                              _buildNavItem(8, Icons.psychology, 'Менторство'),
                              _buildNavItem(9, Icons.analytics, 'Аналитика'),
                              _buildNavItem(10, Icons.people, 'Соцсеть'),
                              _buildNavItem(11, Icons.view_in_ar, 'Метавселенная'),
                              _buildNavItem(12, Icons.smart_toy, 'ИИ/ML'),
                              _buildNavItem(13, Icons.emoji_events, 'Достижения'),
                              _buildNavItem(14, Icons.stars, 'Репутация'),
                              _buildNavItem(15, Icons.person, 'Профиль'),
                            ],
                          ),
                        ),
                        // Индикатор прокрутки справа
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.chevron_right,
                              color: AppTheme.primaryColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Добавляем плавающую кнопку для уведомлений
            floatingActionButton: _buildNotificationsFAB(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
          ),
        );
      },
    );
  }

  // Плавающая кнопка уведомлений
  Widget _buildNotificationsFAB() {
    return Consumer<NotificationProvider>(
      builder: (context, notificationProvider, child) {
        final unreadCount = notificationProvider.unreadCount;
        
        return FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const NotificationsScreen(),
              ),
            );
          },
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          mini: true,
          child: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              if (unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        // Автоматическая прокрутка к выбранной вкладке
        _scrollToSelectedTab(index);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected 
                    ? AppTheme.primaryColor.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: isSelected 
                    ? Border.all(color: AppTheme.primaryColor.withOpacity(0.3), width: 1)
                    : null,
              ),
              child: Icon(
                icon,
                color: isSelected 
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondaryColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected 
                    ? AppTheme.primaryColor
                    : AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
