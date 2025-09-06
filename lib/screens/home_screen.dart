import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:rechain_vc_lab/providers/achievements_provider.dart';
import 'package:rechain_vc_lab/providers/reputation_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/widgets/feature_card.dart';
import 'package:rechain_vc_lab/widgets/stats_card.dart';
import 'package:rechain_vc_lab/widgets/achievement_badge.dart';
import 'package:rechain_vc_lab/widgets/reputation_badge.dart';
import 'package:rechain_vc_lab/screens/achievements_screen.dart';
import 'package:rechain_vc_lab/screens/reputation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'REChain®️ VC Lab',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          
          // Основной контент
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Приветствие
                  if (authProvider.isAuthenticated)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: AppTheme.accentGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.white,
                            child: Text(
                              authProvider.userName?.substring(0, 1).toUpperCase() ?? 'U',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Добро пожаловать!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  authProvider.userName ?? 'Пользователь',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.3, end: 0),
                  
                  const SizedBox(height: 24),
                  
                  // Статистика
                  const Text(
                    'Наша статистика',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      StatsCard(
                        title: 'Проектов',
                        value: '150+',
                        icon: Icons.rocket_launch,
                        color: AppTheme.primaryColor,
                      ),
                      StatsCard(
                        title: 'Инвесторов',
                        value: '500+',
                        icon: Icons.people,
                        color: AppTheme.secondaryColor,
                      ),
                      StatsCard(
                        title: 'Событий',
                        value: '25+',
                        icon: Icons.event,
                        color: AppTheme.accentColor,
                      ),
                      StatsCard(
                        title: 'Страны',
                        value: '30+',
                        icon: Icons.public,
                        color: AppTheme.successColor,
                      ),
                    ],
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms),
                  
                  const SizedBox(height: 32),
                  
                  // Основные возможности
                  const Text(
                    'Наши возможности',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  Column(
                    children: [
                      FeatureCard(
                        title: 'Venture Builder',
                        subtitle: 'Создание венчурных проектов',
                        description: 'Мы помогаем предпринимателям создавать инновационные стартапы с нуля',
                        icon: Icons.rocket_launch,
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      FeatureCard(
                        title: 'Incubator',
                        subtitle: 'Инкубация стартапов',
                        description: 'Предоставляем ресурсы, наставничество и поддержку для развития проектов',
                        icon: Icons.egg_alt,
                        color: AppTheme.secondaryColor,
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      FeatureCard(
                        title: 'Startup Studio',
                        subtitle: 'Студия стартапов',
                        description: 'Создаем экосистему для быстрого запуска и масштабирования',
                        icon: Icons.business,
                        color: AppTheme.accentColor,
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      FeatureCard(
                        title: 'Investment Syndicate',
                        subtitle: 'Инвестиционный синдикат',
                        description: 'Глобальный доступ к инвестициям и поддержка проектов',
                        icon: Icons.trending_up,
                        color: AppTheme.successColor,
                        onTap: () {},
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
                  
                  // Хакатоны и события
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ближайшие хакатоны',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Навигация к экрану хакатонов
                        },
                        child: const Text('Все хакатоны'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final hackathons = [
                          {
                            'title': 'Stacks Bitcoin Hackathon II',
                            'location': 'Harvard, USA',
                            'prize': '\$25,000',
                            'date': '9-10 Ноя',
                            'attendees': 350,
                          },
                          {
                            'title': 'Stellar Meridian Hackathon',
                            'location': 'London, UK',
                            'prize': '\$50,000',
                            'date': '12-13 Окт',
                            'attendees': 0,
                          },
                          {
                            'title': 'VeChain Singapore Hackathon',
                            'location': 'Singapore',
                            'prize': '\$30,000',
                            'date': '14-15 Сен',
                            'attendees': 0,
                          },
                        ];
                        
                        final hackathon = hackathons[index];
                        return Container(
                          width: 280,
                          margin: const EdgeInsets.only(right: 16),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppTheme.primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.event,
                                          color: AppTheme.primaryColor,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          hackathon['title'] as String,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    hackathon['location'] as String,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.attach_money, size: 16, color: Colors.green),
                                      const SizedBox(width: 4),
                                                                              Text(
                                          hackathon['prize'] as String,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green,
                                          ),
                                        ),
                                      const Spacer(),
                                                                              Text(
                                          hackathon['date'] as String,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.people, size: 16, color: Colors.grey[600]),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${hackathon['attendees']} участников',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: const Text('Участвовать'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
                  
                  // Университетские партнеры
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Университетские партнеры',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Навигация к экрану партнеров
                        },
                        child: const Text('Все партнеры'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        final universities = <Map<String, dynamic>>[
                          {'name': 'Harvard', 'color': Colors.red},
                          {'name': 'MIT', 'color': Colors.grey},
                          {'name': 'Cambridge', 'color': Colors.blue},
                          {'name': 'Oxford', 'color': Colors.orange},
                          {'name': 'Yale', 'color': Colors.indigo},
                          {'name': 'Princeton', 'color': Colors.orange},
                          {'name': 'Brown', 'color': Colors.brown},
                          {'name': 'Dartmouth', 'color': Colors.green},
                        ];
                        
                        final uni = universities[index];
                        final color = uni['color'] as Color;
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 16),
                          child: Card(
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    color.withOpacity(0.1),
                                    color.withOpacity(0.05),
                                  ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: color.withOpacity(0.5), width: 1),
                                    ),
                                    child: Center(
                                      child: Text(
                                        uni['name']![0],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: color,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    uni['name']!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
                  
                  // Достижения
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ваши достижения',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AchievementsScreen(),
                            ),
                          );
                        },
                        child: const Text('Все достижения'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<AchievementsProvider>(
                    builder: (context, achievementsProvider, child) {
                      final recentAchievements = achievementsProvider.unlockedAchievements
                          .take(5)
                          .toList();
                      
                      return RecentAchievementsWidget(
                        recentAchievements: recentAchievements,
                        onViewAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AchievementsScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ).animate().fadeIn(delay: 700.ms, duration: 600.ms),
                  
                  // Репутация
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ваша репутация',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ReputationScreen(),
                            ),
                          );
                        },
                        child: const Text('Подробнее'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Consumer<ReputationProvider>(
                    builder: (context, reputationProvider, child) {
                      final recentEvents = reputationProvider.getRecentEvents(limit: 3);
                      
                      return RecentReputationWidget(
                        recentEvents: recentEvents,
                        onViewAll: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ReputationScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
                  
                  const SizedBox(height: 32),
                  
                  // CTA кнопка
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Присоединиться к REChain',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: 600.ms, duration: 600.ms),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
