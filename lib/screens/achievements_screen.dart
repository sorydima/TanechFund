import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/achievements_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  AchievementType? _selectedType;
  AchievementRarity? _selectedRarity;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AchievementsProvider>().initialize();
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
                'Достижения',
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
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: _showFilterDialog,
              ),
            ],
          ),

          // Статистика пользователя
          SliverToBoxAdapter(
            child: Consumer<AchievementsProvider>(
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
                      // Уровень пользователя
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: provider.userLevel.color,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${provider.userLevel.level}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: provider.userLevel.color,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  provider.userLevel.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${provider.userLevel.experience}/${provider.userLevel.experienceToNext} опыта',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: provider.userLevel.experience / provider.userLevel.experienceToNext,
                                  backgroundColor: Colors.white.withOpacity(0.3),
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Статистика достижений
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(
                            '${stats['unlockedAchievements']}/${stats['totalAchievements']}',
                            'Достижения',
                            Icons.emoji_events,
                          ),
                          _buildStatItem(
                            '${stats['totalPoints']}',
                            'Очки',
                            Icons.stars,
                          ),
                          _buildStatItem(
                            '${(stats['progressPercentage'] * 100).toInt()}%',
                            'Прогресс',
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
                  Tab(text: 'Все'),
                  Tab(text: 'Разблокированные'),
                  Tab(text: 'Награды'),
                ],
              ),
            ),
          ),

          // Контент табов
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllAchievementsTab(),
                _buildUnlockedAchievementsTab(),
                _buildRewardsTab(),
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

  Widget _buildAllAchievementsTab() {
    return Consumer<AchievementsProvider>(
      builder: (context, provider, child) {
        var achievements = provider.achievements;

        // Фильтрация по типу
        if (_selectedType != null) {
          achievements = achievements.where((a) => a.type == _selectedType).toList();
        }

        // Фильтрация по редкости
        if (_selectedRarity != null) {
          achievements = achievements.where((a) => a.rarity == _selectedRarity).toList();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return _buildAchievementCard(achievement, provider, index);
          },
        );
      },
    );
  }

  Widget _buildUnlockedAchievementsTab() {
    return Consumer<AchievementsProvider>(
      builder: (context, provider, child) {
        final achievements = provider.unlockedAchievements;
        
        if (achievements.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Пока нет разблокированных достижений',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Активно участвуйте в платформе, чтобы получить достижения!',
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
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return _buildAchievementCard(achievement, provider, index, isUnlocked: true);
          },
        );
      },
    );
  }

  Widget _buildRewardsTab() {
    return Consumer<AchievementsProvider>(
      builder: (context, provider, child) {
        final rewards = provider.availableRewards;
        
        if (rewards.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.card_giftcard_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Пока нет доступных наград',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Разблокируйте достижения, чтобы получить награды!',
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
          itemCount: rewards.length,
          itemBuilder: (context, index) {
            final reward = rewards[index];
            return _buildRewardCard(reward, provider, index);
          },
        );
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement, AchievementsProvider provider, int index, {bool isUnlocked = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isUnlocked 
                ? LinearGradient(
                    colors: [
                      _getRarityColor(achievement.rarity).withOpacity(0.1),
                      _getRarityColor(achievement.rarity).withOpacity(0.05),
                    ],
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Иконка достижения
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isUnlocked 
                        ? _getRarityColor(achievement.rarity).withOpacity(0.2)
                        : Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isUnlocked 
                          ? _getRarityColor(achievement.rarity)
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      achievement.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Информация о достижении
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              achievement.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isUnlocked 
                                    ? AppTheme.textPrimaryColor
                                    : Colors.grey[600],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getRarityColor(achievement.rarity).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getRarityText(achievement.rarity),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: _getRarityColor(achievement.rarity),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        achievement.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: isUnlocked 
                              ? AppTheme.textSecondaryColor
                              : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.stars,
                            size: 16,
                            color: isUnlocked ? Colors.amber : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${achievement.points} очков',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isUnlocked ? Colors.amber : Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          if (isUnlocked && achievement.unlockedAt != null)
                            Text(
                              'Получено ${_formatDate(achievement.unlockedAt!)}',
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
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: (index * 100).ms, duration: 600.ms).slideX(begin: 0.3, end: 0);
  }

  Widget _buildRewardCard(Reward reward, AchievementsProvider provider, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryColor.withOpacity(0.1),
                AppTheme.primaryColor.withOpacity(0.05),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Иконка награды
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      reward.icon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Информация о награде
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reward.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reward.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              reward.type.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              provider.claimReward(reward.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Награда "${reward.title}" получена!'),
                                  backgroundColor: AppTheme.successColor,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            child: const Text('Получить'),
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
      ),
    ).animate().fadeIn(delay: (index * 100).ms, duration: 600.ms).slideX(begin: 0.3, end: 0);
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }

  String _getRarityText(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return 'ОБЫЧНОЕ';
      case AchievementRarity.rare:
        return 'РЕДКОЕ';
      case AchievementRarity.epic:
        return 'ЭПИЧЕСКОЕ';
      case AchievementRarity.legendary:
        return 'ЛЕГЕНДАРНОЕ';
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Фильтры'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Фильтр по типу
            DropdownButtonFormField<AchievementType?>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Тип достижения',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<AchievementType?>(
                  value: null,
                  child: Text('Все типы'),
                ),
                ...AchievementType.values.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(_getTypeText(type)),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
            const SizedBox(height: 16),
            // Фильтр по редкости
            DropdownButtonFormField<AchievementRarity?>(
              value: _selectedRarity,
              decoration: const InputDecoration(
                labelText: 'Редкость',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<AchievementRarity?>(
                  value: null,
                  child: Text('Все редкости'),
                ),
                ...AchievementRarity.values.map((rarity) => DropdownMenuItem(
                  value: rarity,
                  child: Text(_getRarityText(rarity)),
                )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRarity = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedType = null;
                _selectedRarity = null;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Сбросить'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }

  static String _getTypeText(AchievementType type) {
    switch (type) {
      case AchievementType.project:
        return 'Проекты';
      case AchievementType.investment:
        return 'Инвестиции';
      case AchievementType.mentorship:
        return 'Менторство';
      case AchievementType.social:
        return 'Социальные';
      case AchievementType.learning:
        return 'Обучение';
      case AchievementType.hackathon:
        return 'Хакатоны';
      case AchievementType.challenge:
        return 'Челленджи';
      case AchievementType.community:
        return 'Сообщество';
    }
  }
}
