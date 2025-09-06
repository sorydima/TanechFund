import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rechain_vc_lab/providers/web3_identity_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class Web3IdentityScreen extends StatefulWidget {
  const Web3IdentityScreen({super.key});

  @override
  State<Web3IdentityScreen> createState() => _Web3IdentityScreenState();
}

class _Web3IdentityScreenState extends State<Web3IdentityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Web3IdentityProvider>().initialize();
    });
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Web3 Identity',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.verified_user,
                      size: 60,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Поиск идентификаторов...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            // Overview Cards
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Consumer<Web3IdentityProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Активные DID',
                              '${provider.activeIdentities.length}',
                              Icons.fingerprint,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Достижения',
                              '${provider.achievements.length}',
                              Icons.emoji_events,
                              Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Репутация',
                              '${_formatNumber(provider.getUserTotalReputation(provider.currentUserId))}',
                              Icons.star,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Навыки',
                              '${provider.userSkillVerifications.length}',
                              Icons.psychology,
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'DID'),
                  Tab(text: 'Достижения'),
                  Tab(text: 'Репутация'),
                  Tab(text: 'Навыки'),
                  Tab(text: 'Аналитика'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDIDTab(),
                  _buildAchievementsTab(),
                  _buildReputationTab(),
                  _buildSkillsTab(),
                  _buildAnalyticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateItemDialog(),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDIDTab() {
    return Consumer<Web3IdentityProvider>(
      builder: (context, provider, child) {
        final identities = _searchQuery.isEmpty
            ? provider.identities
            : provider.searchIdentities(_searchQuery);

        if (identities.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fingerprint, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных DID',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: identities.length,
          itemBuilder: (context, index) {
            final identity = identities[index];
            return _buildDIDCard(identity, provider);
          },
        );
      },
    );
  }

  Widget _buildAchievementsTab() {
    return Consumer<Web3IdentityProvider>(
      builder: (context, provider, child) {
        final achievements = _searchQuery.isEmpty
            ? provider.achievements
            : provider.searchAchievements(_searchQuery);

        if (achievements.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных достижений',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
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
            return _buildAchievementCard(achievement);
          },
        );
      },
    );
  }

  Widget _buildReputationTab() {
    return Consumer<Web3IdentityProvider>(
      builder: (context, provider, child) {
        final userScores = provider.userReputationScores;

        if (userScores.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'У вас пока нет оценок репутации',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: userScores.length,
          itemBuilder: (context, index) {
            final score = userScores[index];
            return _buildReputationCard(score);
          },
        );
      },
    );
  }

  Widget _buildSkillsTab() {
    return Consumer<Web3IdentityProvider>(
      builder: (context, provider, child) {
        final userSkills = provider.userSkillVerifications;

        if (userSkills.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'У вас пока нет верифицированных навыков',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: userSkills.length,
          itemBuilder: (context, index) {
            final skill = userSkills[index];
            return _buildSkillCard(skill);
          },
        );
      },
    );
  }

  Widget _buildAnalyticsTab() {
    return Consumer<Web3IdentityProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Achievement Distribution
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Распределение достижений',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...provider.getAchievementTypeDistribution().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _getAchievementTypeName(entry.key),
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '${entry.value}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Skill Categories
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Категории навыков',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...provider.getSkillCategoryDistribution().entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '${entry.value}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Top Achievements
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Топ достижения',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...provider.getTopAchievements().take(5).map((achievement) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  achievement.title,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '${achievement.points} pts',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDIDCard(Web3Identity identity, Web3IdentityProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        identity.metadata['name'] ?? 'Unnamed Identity',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        identity.did,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDIDStatusColor(identity.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getDIDStatusName(identity.status),
                    style: TextStyle(
                      color: _getDIDStatusColor(identity.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (identity.metadata['bio'] != null)
              Text(
                identity.metadata['bio'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Контроллер',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${identity.controller.substring(0, 8)}...',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Создан',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd.MM.yyyy').format(identity.createdAt),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showDIDDetails(identity),
                    icon: const Icon(Icons.info, size: 16),
                    label: const Text('Детали'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showVerificationMethods(identity),
                    icon: const Icon(Icons.security, size: 16),
                    label: const Text('Ключи'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    achievement.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getAchievementTypeColor(achievement.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getAchievementTypeName(achievement.type.name),
                    style: TextStyle(
                      color: _getAchievementTypeColor(achievement.type),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              achievement.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Очки',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${achievement.points}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Выдано',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd.MM.yyyy').format(achievement.issuedAt),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Кем',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        achievement.issuer,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReputationCard(ReputationScore score) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _getReputationSourceName(score.source),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScoreColor(score.score).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${score.score.toStringAsFixed(1)}',
                    style: TextStyle(
                      color: _getScoreColor(score.score),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              score.reason,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Источник',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        score.sourceId,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Оценка',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd.MM.yyyy').format(score.scoredAt),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCard(SkillVerification skill) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    skill.skillName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'ВЕРИФИЦИРОВАН',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              skill.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Категория',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        skill.skillCategory,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Верифицирован',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd.MM.yyyy').format(skill.verifiedAt),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Верификаторы',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${skill.verifiers.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  String _formatNumber(double number) {
    if (number >= 100) {
      return '${number.toStringAsFixed(0)}';
    } else if (number >= 10) {
      return '${number.toStringAsFixed(1)}';
    }
    return number.toStringAsFixed(1);
  }

  String _getDIDStatusName(DIDStatus status) {
    switch (status) {
      case DIDStatus.active:
        return 'Активен';
      case DIDStatus.suspended:
        return 'Приостановлен';
      case DIDStatus.revoked:
        return 'Отозван';
      case DIDStatus.expired:
        return 'Истек';
    }
  }

  Color _getDIDStatusColor(DIDStatus status) {
    switch (status) {
      case DIDStatus.active:
        return Colors.green;
      case DIDStatus.suspended:
        return Colors.orange;
      case DIDStatus.revoked:
        return Colors.red;
      case DIDStatus.expired:
        return Colors.grey;
    }
  }

  String _getAchievementTypeName(String type) {
    switch (type) {
      case 'skill':
        return 'Навык';
      case 'contribution':
        return 'Вклад';
      case 'community':
        return 'Сообщество';
      case 'innovation':
        return 'Инновация';
      case 'leadership':
        return 'Лидерство';
      default:
        return type;
    }
  }

  Color _getAchievementTypeColor(AchievementType type) {
    switch (type) {
      case AchievementType.skill:
        return Colors.blue;
      case AchievementType.contribution:
        return Colors.green;
      case AchievementType.community:
        return Colors.orange;
      case AchievementType.innovation:
        return Colors.purple;
      case AchievementType.leadership:
        return Colors.red;
    }
  }

  String _getReputationSourceName(ReputationSource source) {
    switch (source) {
      case ReputationSource.peer_review:
        return 'Оценка коллег';
      case ReputationSource.project_success:
        return 'Успех проектов';
      case ReputationSource.community_votes:
        return 'Голоса сообщества';
      case ReputationSource.skill_verification:
        return 'Верификация навыков';
      case ReputationSource.contribution_impact:
        return 'Влияние вкладов';
    }
  }

  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green;
    if (score >= 70) return Colors.blue;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  // Action Methods
  void _showCreateItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать новый элемент'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.fingerprint, color: Colors.blue),
              title: const Text('DID (Decentralized Identifier)'),
              subtitle: const Text('Создать новую децентрализованную идентичность'),
              onTap: () {
                Navigator.pop(context);
                _showCreateDIDDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.amber),
              title: const Text('Достижение'),
              subtitle: const Text('Выдать новое достижение'),
              onTap: () {
                Navigator.pop(context);
                _showCreateAchievementDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.star, color: Colors.green),
              title: const Text('Репутация'),
              subtitle: const Text('Добавить оценку репутации'),
              onTap: () {
                Navigator.pop(context);
                _showCreateReputationDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.psychology, color: Colors.purple),
              title: const Text('Навык'),
              subtitle: const Text('Верифицировать новый навык'),
              onTap: () {
                Navigator.pop(context);
                _showCreateSkillDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _showCreateDIDDialog() {
    final didController = TextEditingController();
    final controllerController = TextEditingController();
    final nameController = TextEditingController();
    final bioController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать DID'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: didController,
                decoration: const InputDecoration(
                  labelText: 'DID',
                  hintText: 'did:rechain:example123',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controllerController,
                decoration: const InputDecoration(
                  labelText: 'Контроллер (адрес)',
                  hintText: '0x1234...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Имя',
                  hintText: 'Ваше имя',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Биография',
                  hintText: 'Краткое описание',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (didController.text.isNotEmpty && controllerController.text.isNotEmpty) {
                final provider = context.read<Web3IdentityProvider>();
                provider.createIdentity(
                  did: didController.text,
                  controller: controllerController.text,
                  verificationMethods: [
                    VerificationMethod(
                      id: '${didController.text}#key-1',
                      type: 'Ed25519VerificationKey2020',
                      controller: didController.text,
                      publicKeyMultibase: 'z6Mkf5rGM4rBp9ETQGm1YcGxjff3bevVVwRz9iZaB3oL4Zw5',
                      verificationMethodType: VerificationMethodType.ed25519,
                      metadata: {'curve': 'ed25519', 'keySize': 256},
                    ),
                  ],
                  services: [
                    'ipfs://QmYwAPJzv5CZsnA625s3Xf2nemtYgPpHdWEz79ojWnPbdG',
                  ],
                  metadata: {
                    'name': nameController.text.isNotEmpty ? nameController.text : 'Unnamed',
                    'bio': bioController.text.isNotEmpty ? bioController.text : null,
                  },
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('DID успешно создан!')),
                );
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showCreateAchievementDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final pointsController = TextEditingController();
    final recipientController = TextEditingController();
    AchievementType selectedType = AchievementType.skill;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать достижение'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Название',
                  hintText: 'Название достижения',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  hintText: 'Описание достижения',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<AchievementType>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Тип',
                  border: OutlineInputBorder(),
                ),
                items: AchievementType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getAchievementTypeName(type.name)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedType = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pointsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Очки',
                  hintText: '100',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: recipientController,
                decoration: const InputDecoration(
                  labelText: 'Получатель',
                  hintText: 'ID пользователя',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && 
                  descriptionController.text.isNotEmpty &&
                  pointsController.text.isNotEmpty) {
                final provider = context.read<Web3IdentityProvider>();
                provider.issueAchievement(
                  title: titleController.text,
                  description: descriptionController.text,
                  type: selectedType,
                  points: int.tryParse(pointsController.text) ?? 100,
                  recipient: recipientController.text.isNotEmpty ? recipientController.text : 'current_user',
                  evidence: ['ipfs://QmEvidence...'],
                  metadata: {
                    'category': selectedType.name,
                    'difficulty': 'medium',
                  },
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Достижение успешно создано!')),
                );
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showCreateReputationDialog() {
    final userIdController = TextEditingController();
    final sourceIdController = TextEditingController();
    final scoreController = TextEditingController();
    final reasonController = TextEditingController();
    ReputationSource selectedSource = ReputationSource.peer_review;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Добавить репутацию'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userIdController,
                decoration: const InputDecoration(
                  labelText: 'ID пользователя',
                  hintText: 'ID пользователя',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: sourceIdController,
                decoration: const InputDecoration(
                  labelText: 'Источник',
                  hintText: 'ID проекта или источника',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ReputationSource>(
                value: selectedSource,
                decoration: const InputDecoration(
                  labelText: 'Тип источника',
                  border: OutlineInputBorder(),
                ),
                items: ReputationSource.values.map((source) {
                  return DropdownMenuItem(
                    value: source,
                    child: Text(_getReputationSourceName(source)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedSource = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: scoreController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Оценка (0-100)',
                  hintText: '85.5',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Причина',
                  hintText: 'Обоснование оценки',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (userIdController.text.isNotEmpty && 
                  scoreController.text.isNotEmpty &&
                  reasonController.text.isNotEmpty) {
                final provider = context.read<Web3IdentityProvider>();
                provider.addReputationScore(
                  userId: userIdController.text,
                  sourceId: sourceIdController.text.isNotEmpty ? sourceIdController.text : 'unknown',
                  source: selectedSource,
                  score: double.tryParse(scoreController.text) ?? 0.0,
                  reason: reasonController.text,
                  metadata: {
                    'source_type': selectedSource.name,
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Репутация успешно добавлена!')),
                );
              }
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );
  }

  void _showCreateSkillDialog() {
    final userIdController = TextEditingController();
    final skillNameController = TextEditingController();
    final categoryController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Верифицировать навык'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userIdController,
                decoration: const InputDecoration(
                  labelText: 'ID пользователя',
                  hintText: 'ID пользователя',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: skillNameController,
                decoration: const InputDecoration(
                  labelText: 'Название навыка',
                  hintText: 'Solidity Development',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Категория',
                  hintText: 'Blockchain',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  hintText: 'Описание навыка',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (userIdController.text.isNotEmpty && 
                  skillNameController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty) {
                final provider = context.read<Web3IdentityProvider>();
                provider.verifySkill(
                  userId: userIdController.text,
                  skillName: skillNameController.text,
                  skillCategory: categoryController.text,
                  description: descriptionController.text.isNotEmpty ? descriptionController.text : 'Навык верифицирован',
                  evidence: ['ipfs://QmSkillEvidence...'],
                  metadata: {
                    'verification_method': 'manual',
                    'verifier_id': provider.currentUserId,
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Навык успешно верифицирован!')),
                );
              }
            },
            child: const Text('Верифицировать'),
          ),
        ],
      ),
    );
  }

  void _showDIDDetails(Web3Identity identity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(identity.metadata['name'] ?? 'DID Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('DID:', identity.did),
              _buildDetailRow('Контроллер:', '${identity.controller.substring(0, 8)}...'),
              _buildDetailRow('Статус:', _getDIDStatusName(identity.status)),
              _buildDetailRow('Создан:', DateFormat('dd.MM.yyyy HH:mm').format(identity.createdAt)),
                             if (identity.updatedAt != null)
                 _buildDetailRow('Обновлен:', DateFormat('dd.MM.yyyy HH:mm').format(identity.updatedAt!)),
               if (identity.expiresAt != null)
                 _buildDetailRow('Истекает:', DateFormat('dd.MM.yyyy HH:mm').format(identity.expiresAt!)),
              if (identity.metadata['bio'] != null)
                _buildDetailRow('Биография:', identity.metadata['bio']),
              const SizedBox(height: 16),
              const Text('Сервисы:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...identity.services.map((service) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(service, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showVerificationMethods(identity);
            },
            child: const Text('Ключи'),
          ),
        ],
      ),
    );
  }

  void _showVerificationMethods(Web3Identity identity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Методы верификации'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ...identity.verificationMethods.map((method) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('ID:', method.id),
                      _buildDetailRow('Тип:', method.type),
                      _buildDetailRow('Контроллер:', method.controller),
                      _buildDetailRow('Ключ:', '${method.publicKeyMultibase.substring(0, 20)}...'),
                      _buildDetailRow('Алгоритм:', method.verificationMethodType.name),
                      if (method.metadata.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        const Text('Метаданные:', style: TextStyle(fontWeight: FontWeight.bold)),
                        ...method.metadata.entries.map((entry) => Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text('${entry.key}: ${entry.value}'),
                        )),
                      ],
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}
