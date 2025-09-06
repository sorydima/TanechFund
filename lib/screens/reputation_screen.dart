import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/reputation_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class ReputationScreen extends StatefulWidget {
  const ReputationScreen({super.key});

  @override
  State<ReputationScreen> createState() => _ReputationScreenState();
}

class _ReputationScreenState extends State<ReputationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReputationProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                'Репутация',
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
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  context.read<ReputationProvider>().simulateEvents();
                },
              ),
            ],
          ),

          // Статистика репутации
          SliverToBoxAdapter(
            child: Consumer<ReputationProvider>(
              builder: (context, provider, child) {
                final stats = provider.getStatistics();
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppTheme.accentGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Уровень репутации
                      Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: provider.reputationColor,
                                width: 4,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${stats['totalReputation']}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: provider.reputationColor,
                                    ),
                                  ),
                                  Text(
                                    'RP',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: provider.reputationColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.reputationLevel,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${stats['totalEvents']} событий',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                if (stats['topCategory'] != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Топ: ${_getTypeText(stats['topCategory'])}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Статистика
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            '${stats['totalReputation']}',
                            'Репутация',
                            Icons.stars,
                          ),
                          _buildStatItem(
                            '${stats['totalEvents']}',
                            'События',
                            Icons.timeline,
                          ),
                          _buildStatItem(
                            '${stats['recentActivity']}',
                            'За неделю',
                            Icons.trending_up,
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0);
              },
            ),
          ),

          // Табы
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppTheme.textSecondaryColor,
                tabs: const [
                  Tab(text: 'Категории'),
                  Tab(text: 'События'),
                  Tab(text: 'История'),
                ],
              ),
            ),
          ),

          // Контент табов
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildCategoriesTab(),
                _buildEventsTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesTab() {
    return Consumer<ReputationProvider>(
      builder: (context, provider, child) {
        final topCategories = provider.getTopCategories();
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: topCategories.length,
          itemBuilder: (context, index) {
            final category = topCategories[index];
            return _buildCategoryCard(category, provider, index);
          },
        );
      },
    );
  }

  Widget _buildEventsTab() {
    return Consumer<ReputationProvider>(
      builder: (context, provider, child) {
        final recentEvents = provider.getRecentEvents(limit: 20);
        
        if (recentEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.timeline_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Пока нет событий репутации',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Активно участвуйте в платформе!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recentEvents.length,
          itemBuilder: (context, index) {
            final event = recentEvents[index];
            return _buildEventCard(event, index);
          },
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<ReputationProvider>(
      builder: (context, provider, child) {
        final allEvents = provider.allEvents;
        
        if (allEvents.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'История пуста',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: allEvents.length,
          itemBuilder: (context, index) {
            final event = allEvents[index];
            return _buildEventCard(event, index);
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(ReputationScore category, ReputationProvider provider, int index) {
    final progress = category.totalPoints / 1000.0; // Максимум 1000 очков для прогресса
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _getTypeColor(category.type).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getTypeColor(category.type),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getTypeIcon(category.type),
                        color: _getTypeColor(category.type),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTypeText(category.type),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${category.totalPoints} очков',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(category.type).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${category.eventCount}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getTypeColor(category.type),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(_getTypeColor(category.type)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms, duration: 600.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildEventCard(ReputationEvent event, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _getTypeColor(event.type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    _getTypeIcon(event.type),
                    color: _getTypeColor(event.type),
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(event.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: event.points > 0 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${event.points > 0 ? '+' : ''}${event.points}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: event.points > 0 ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 50).ms, duration: 400.ms).slideX(begin: 0.2, end: 0);
  }

  Color _getTypeColor(ReputationType type) {
    switch (type) {
      case ReputationType.project:
        return Colors.blue;
      case ReputationType.investment:
        return Colors.green;
      case ReputationType.mentorship:
        return Colors.purple;
      case ReputationType.social:
        return Colors.orange;
      case ReputationType.learning:
        return Colors.teal;
      case ReputationType.hackathon:
        return Colors.red;
      case ReputationType.challenge:
        return Colors.amber;
      case ReputationType.community:
        return Colors.pink;
      case ReputationType.review:
        return Colors.indigo;
      case ReputationType.feedback:
        return Colors.cyan;
    }
  }

  IconData _getTypeIcon(ReputationType type) {
    switch (type) {
      case ReputationType.project:
        return Icons.rocket_launch;
      case ReputationType.investment:
        return Icons.trending_up;
      case ReputationType.mentorship:
        return Icons.psychology;
      case ReputationType.social:
        return Icons.people;
      case ReputationType.learning:
        return Icons.school;
      case ReputationType.hackathon:
        return Icons.event;
      case ReputationType.challenge:
        return Icons.emoji_events;
      case ReputationType.community:
        return Icons.group;
      case ReputationType.review:
        return Icons.rate_review;
      case ReputationType.feedback:
        return Icons.feedback;
    }
  }

  String _getTypeText(ReputationType type) {
    switch (type) {
      case ReputationType.project:
        return 'Проекты';
      case ReputationType.investment:
        return 'Инвестиции';
      case ReputationType.mentorship:
        return 'Менторство';
      case ReputationType.social:
        return 'Социальные';
      case ReputationType.learning:
        return 'Обучение';
      case ReputationType.hackathon:
        return 'Хакатоны';
      case ReputationType.challenge:
        return 'Челленджи';
      case ReputationType.community:
        return 'Сообщество';
      case ReputationType.review:
        return 'Отзывы';
      case ReputationType.feedback:
        return 'Обратная связь';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} дн. назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} мин. назад';
    } else {
      return 'только что';
    }
  }
}
