import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rechain_vc_lab/providers/web3_gaming_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class Web3GamingScreen extends StatefulWidget {
  const Web3GamingScreen({super.key});

  @override
  State<Web3GamingScreen> createState() => _Web3GamingScreenState();
}

class _Web3GamingScreenState extends State<Web3GamingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Web3GamingProvider>().initialize();
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
                  'Web3 Gaming',
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
                      Icons.games,
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
                      hintText: 'Поиск игровых миров...',
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
              child: Consumer<Web3GamingProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Игровые миры',
                              '${provider.activeGameWorlds.length}',
                              Icons.public,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Персонажи',
                              '${provider.userCharacters.length}',
                              Icons.person,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Турниры',
                              '${provider.activeTournaments.length}',
                              Icons.emoji_events,
                              Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Заработок',
                              '${_formatNumber(provider.getUserTotalEarnings(provider.currentUserId))}',
                              Icons.monetization_on,
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
                  Tab(text: 'Миры'),
                  Tab(text: 'Персонажи'),
                  Tab(text: 'Турниры'),
                  Tab(text: 'Награды'),
                  Tab(text: 'DeFi'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGameWorldsTab(),
                  _buildCharactersTab(),
                  _buildTournamentsTab(),
                  _buildRewardsTab(),
                  _buildDeFiTab(),
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

  Widget _buildGameWorldsTab() {
    return Consumer<Web3GamingProvider>(
      builder: (context, provider, child) {
        final worlds = _searchQuery.isEmpty
            ? provider.activeGameWorlds
            : provider.searchGameWorlds(_searchQuery);

        if (worlds.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.public, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных игровых миров',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: worlds.length,
          itemBuilder: (context, index) {
            final world = worlds[index];
            return _buildGameWorldCard(world, provider);
          },
        );
      },
    );
  }

  Widget _buildCharactersTab() {
    return Consumer<Web3GamingProvider>(
      builder: (context, provider, child) {
        final characters = provider.userCharacters;

        if (characters.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'У вас пока нет персонажей',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: characters.length,
          itemBuilder: (context, index) {
            final character = characters[index];
            return _buildCharacterCard(character, provider);
          },
        );
      },
    );
  }

  Widget _buildTournamentsTab() {
    return Consumer<Web3GamingProvider>(
      builder: (context, provider, child) {
        final tournaments = provider.tournaments;

        if (tournaments.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных турниров',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tournaments.length,
          itemBuilder: (context, index) {
            final tournament = tournaments[index];
            return _buildTournamentCard(tournament, provider);
          },
        );
      },
    );
  }

  Widget _buildRewardsTab() {
    return Consumer<Web3GamingProvider>(
      builder: (context, provider, child) {
        final rewards = provider.userRewards;

        if (rewards.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'У вас пока нет наград',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
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
            return _buildRewardCard(reward, provider);
          },
        );
      },
    );
  }

  Widget _buildDeFiTab() {
    return Consumer<Web3GamingProvider>(
      builder: (context, provider, child) {
        final integrations = provider.deFiIntegrations;

        if (integrations.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных DeFi интеграций',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: integrations.length,
          itemBuilder: (context, index) {
            final integration = integrations[index];
            return _buildDeFiIntegrationCard(integration, provider);
          },
        );
      },
    );
  }

  Widget _buildGameWorldCard(GameWorld world, Web3GamingProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // World Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(world.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        world.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          provider.getGameWorldTypeName(world.type),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // World Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  world.description,
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
                            'Игроки',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${world.currentPlayers}/${world.maxPlayers}',
                            style: const TextStyle(
                              fontSize: 16,
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
                            'Токен',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${world.tokenSymbol} \$${world.tokenPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
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
                        onPressed: () => _showWorldDetails(world),
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
                        onPressed: () => _showCreateCharacterDialog(world),
                        icon: const Icon(Icons.person_add, size: 16),
                        label: const Text('Создать персонажа'),
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
        ],
      ),
    );
  }

  Widget _buildCharacterCard(GameCharacter character, Web3GamingProvider provider) {
    final world = provider.gameWorlds.firstWhere((w) => w.id == character.worldId);
    
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
                        character.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${provider.getCharacterClassName(character.characterClass)} • Уровень ${character.level}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    world.tokenSymbol,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Здоровье', '${character.health}/${character.maxHealth}', Icons.favorite, Colors.red),
                ),
                Expanded(
                  child: _buildStatItem('Мана', '${character.mana}/${character.maxMana}', Icons.water_drop, Colors.blue),
                ),
                Expanded(
                  child: _buildStatItem('Опыт', '${character.experience}', Icons.star, Colors.amber),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Attributes
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Сила', '${character.strength}', Icons.fitness_center, Colors.orange),
                ),
                Expanded(
                  child: _buildStatItem('Ловкость', '${character.agility}', Icons.directions_run, Colors.green),
                ),
                Expanded(
                  child: _buildStatItem('Интеллект', '${character.intelligence}', Icons.psychology, Colors.purple),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Skills
            if (character.skills.isNotEmpty) ...[
              Text(
                'Навыки:',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: character.skills.map((skill) => Chip(
                  label: Text(skill),
                  backgroundColor: Colors.grey[100],
                  labelStyle: const TextStyle(fontSize: 12),
                )).toList(),
              ),
              const SizedBox(height: 16),
            ],
            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCharacterDetails(character),
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
                    onPressed: () => _showCharacterStats(character),
                    icon: const Icon(Icons.analytics, size: 16),
                    label: const Text('Статистика'),
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

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildTournamentCard(Tournament tournament, Web3GamingProvider provider) {
    final world = provider.gameWorlds.firstWhere((w) => w.id == tournament.worldId);
    
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
                    tournament.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTournamentStatusColor(tournament.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    provider.getTournamentStatusName(tournament.status),
                    style: TextStyle(
                      color: _getTournamentStatusColor(tournament.status),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              tournament.description,
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
                        'Участники',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${tournament.participants.length}/${tournament.maxParticipants}',
                        style: const TextStyle(
                          fontSize: 16,
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
                        'Взнос',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${tournament.entryFee} ${tournament.tokenSymbol}',
                        style: const TextStyle(
                          fontSize: 16,
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
                        'Мир',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        world.name,
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
                    onPressed: () => _showTournamentDetails(tournament),
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
                    onPressed: () => _showJoinTournamentDialog(tournament, provider),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Участвовать'),
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

  Widget _buildRewardCard(GameReward reward, Web3GamingProvider provider) {
    final world = provider.gameWorlds.firstWhere((w) => w.id == reward.worldId);
    final character = provider.characters.firstWhere((c) => c.id == reward.characterId);
    
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
                        reward.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${provider.getRewardTypeName(reward.type)} • ${character.name}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: reward.isClaimed ? Colors.grey.withOpacity(0.1) : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    reward.isClaimed ? 'ПОЛУЧЕНО' : 'ДОСТУПНО',
                    style: TextStyle(
                      color: reward.isClaimed ? Colors.grey : Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              reward.description,
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
                        'Количество',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${reward.amount} ${reward.tokenSymbol}',
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
                        'Получено',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd.MM.yyyy').format(reward.earnedAt),
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
                        'Мир',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        world.name,
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
            if (!reward.isClaimed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _claimReward(reward, provider),
                  icon: const Icon(Icons.card_giftcard, size: 16),
                  label: const Text('Получить награду'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeFiIntegrationCard(DeFiIntegration integration, Web3GamingProvider provider) {
    final world = provider.gameWorlds.firstWhere((w) => w.id == integration.worldId);
    
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
                        integration.protocolName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${provider.getDeFiIntegrationTypeName(integration.type)} • ${world.name}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: integration.isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    integration.isActive ? 'АКТИВЕН' : 'НЕАКТИВЕН',
                    style: TextStyle(
                      color: integration.isActive ? Colors.green : Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDeFiStatItem('APY', '${integration.apy.toStringAsFixed(2)}%', Icons.trending_up, Colors.green),
                ),
                Expanded(
                  child: _buildDeFiStatItem('TVL', '\$${_formatNumber(integration.tvl)}', Icons.account_balance, Colors.blue),
                ),
                Expanded(
                  child: _buildDeFiStatItem('Ваш стейк', '${integration.userStake.toStringAsFixed(2)}', Icons.stacked_line_chart, Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showDeFiDetails(integration),
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
                    onPressed: () => _showDeFiActions(integration, provider),
                    icon: const Icon(Icons.account_balance_wallet, size: 16),
                    label: const Text('Действия'),
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

  Widget _buildDeFiStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // Helper Methods
  String _formatNumber(double number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  Color _getTournamentStatusColor(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.upcoming:
        return Colors.blue;
      case TournamentStatus.active:
        return Colors.green;
      case TournamentStatus.completed:
        return Colors.grey;
      case TournamentStatus.cancelled:
        return Colors.red;
    }
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
              leading: const Icon(Icons.public, color: Colors.blue),
              title: const Text('Игровой мир'),
              subtitle: const Text('Создать новый игровой мир'),
              onTap: () {
                Navigator.pop(context);
                _showCreateGameWorldDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.green),
              title: const Text('Персонаж'),
              subtitle: const Text('Создать нового персонажа'),
              onTap: () {
                Navigator.pop(context);
                _showCreateCharacterDialog(null);
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.amber),
              title: const Text('Турнир'),
              subtitle: const Text('Создать новый турнир'),
              onTap: () {
                Navigator.pop(context);
                _showCreateTournamentDialog();
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

  void _showCreateGameWorldDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageUrlController = TextEditingController();
    final maxPlayersController = TextEditingController();
    final tokenPriceController = TextEditingController();
    final tokenSymbolController = TextEditingController();
    GameWorldType selectedType = GameWorldType.rpg;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать игровой мир'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название мира',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<GameWorldType>(
                value: selectedType,
                decoration: const InputDecoration(
                  labelText: 'Тип игры',
                  border: OutlineInputBorder(),
                ),
                items: GameWorldType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(_getGameWorldTypeName(type)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedType = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'URL изображения',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxPlayersController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Максимум игроков',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tokenPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Цена токена',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tokenSymbolController,
                decoration: const InputDecoration(
                  labelText: 'Символ токена',
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
              if (nameController.text.isNotEmpty) {
                final provider = context.read<Web3GamingProvider>();
                final world = GameWorld(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  description: descriptionController.text,
                  type: selectedType,
                  imageUrl: imageUrlController.text.isNotEmpty ? imageUrlController.text : 'https://via.placeholder.com/300x200',
                  maxPlayers: int.tryParse(maxPlayersController.text) ?? 100,
                  currentPlayers: 0,
                  tokenPrice: double.tryParse(tokenPriceController.text) ?? 1.0,
                  tokenSymbol: tokenSymbolController.text.isNotEmpty ? tokenSymbolController.text : 'GAME',
                  metadata: {},
                  createdAt: DateTime.now(),
                  isActive: true,
                );
                provider.createGameWorld(world);
                Navigator.pop(context);
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showCreateCharacterDialog(GameWorld? world) {
    final nameController = TextEditingController();
    CharacterClass selectedClass = CharacterClass.warrior;
    GameWorld? selectedWorld = world;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать персонажа'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Имя персонажа',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<GameWorld>(
                value: selectedWorld,
                decoration: const InputDecoration(
                  labelText: 'Игровой мир',
                  border: OutlineInputBorder(),
                ),
                items: context.read<Web3GamingProvider>().gameWorlds.map((w) {
                  return DropdownMenuItem(
                    value: w,
                    child: Text(w.name),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedWorld = value;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<CharacterClass>(
                value: selectedClass,
                decoration: const InputDecoration(
                  labelText: 'Класс персонажа',
                  border: OutlineInputBorder(),
                ),
                items: CharacterClass.values.map((characterClass) {
                  return DropdownMenuItem(
                    value: characterClass,
                    child: Text(_getCharacterClassName(characterClass)),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) selectedClass = value;
                },
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
              if (nameController.text.isNotEmpty && selectedWorld != null) {
                final provider = context.read<Web3GamingProvider>();
                final character = GameCharacter(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  userId: provider.currentUserId,
                  worldId: selectedWorld!.id,
                  name: nameController.text,
                  characterClass: selectedClass,
                  level: 1,
                  experience: 0,
                  health: 100,
                  maxHealth: 100,
                  mana: 50,
                  maxMana: 50,
                  strength: 10,
                  agility: 10,
                  intelligence: 10,
                  inventory: [],
                  skills: [],
                  stats: {},
                  createdAt: DateTime.now(),
                  lastPlayed: null,
                );
                provider.createCharacter(character);
                Navigator.pop(context);
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showCreateTournamentDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final maxParticipantsController = TextEditingController();
    final entryFeeController = TextEditingController();
    final tokenSymbolController = TextEditingController();
    GameWorld? selectedWorld;
    DateTime startDate = DateTime.now().add(const Duration(days: 1));
    DateTime endDate = DateTime.now().add(const Duration(days: 2));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать турнир'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название турнира',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<GameWorld>(
                value: selectedWorld,
                decoration: const InputDecoration(
                  labelText: 'Игровой мир',
                  border: OutlineInputBorder(),
                ),
                items: context.read<Web3GamingProvider>().gameWorlds.map((w) {
                  return DropdownMenuItem(
                    value: w,
                    child: Text(w.name),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedWorld = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: maxParticipantsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Максимум участников',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: entryFeeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Вступительный взнос',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tokenSymbolController,
                decoration: const InputDecoration(
                  labelText: 'Символ токена',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Дата начала'),
                subtitle: Text(DateFormat('dd.MM.yyyy HH:mm').format(startDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: startDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(startDate),
                    );
                    if (time != null) {
                      startDate = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    }
                  }
                },
              ),
              ListTile(
                title: const Text('Дата окончания'),
                subtitle: Text(DateFormat('dd.MM.yyyy HH:mm').format(endDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: endDate,
                    firstDate: startDate,
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(endDate),
                    );
                    if (time != null) {
                      endDate = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    }
                  }
                },
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
              if (nameController.text.isNotEmpty && selectedWorld != null) {
                final provider = context.read<Web3GamingProvider>();
                final tournament = Tournament(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  worldId: selectedWorld!.id,
                  name: nameController.text,
                  description: descriptionController.text,
                  status: TournamentStatus.upcoming,
                  startDate: startDate,
                  endDate: endDate,
                  maxParticipants: int.tryParse(maxParticipantsController.text) ?? 32,
                  participants: [],
                  winners: [],
                  rewards: {},
                  entryFee: double.tryParse(entryFeeController.text) ?? 0.0,
                  tokenSymbol: tokenSymbolController.text.isNotEmpty ? tokenSymbolController.text : 'GAME',
                  metadata: {},
                );
                provider.createTournament(tournament);
                Navigator.pop(context);
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showWorldDetails(GameWorld world) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(world.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (world.imageUrl != null)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(world.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              _buildDetailRow('Описание:', world.description),
              _buildDetailRow('Тип:', _getGameWorldTypeName(world.type)),
              _buildDetailRow('Игроков:', '${world.currentPlayers}/${world.maxPlayers}'),
              _buildDetailRow('Цена токена:', '${world.tokenPrice} ${world.tokenSymbol}'),
              _buildDetailRow('Создан:', DateFormat('dd.MM.yyyy').format(world.createdAt)),
              _buildDetailRow('Статус:', world.isActive ? 'Активен' : 'Неактивен'),
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
              _showCreateCharacterDialog(world);
            },
            child: const Text('Создать персонажа'),
          ),
        ],
      ),
    );
  }

  void _showCharacterDetails(GameCharacter character) {
    final world = context.read<Web3GamingProvider>().gameWorlds
        .firstWhere((w) => w.id == character.worldId);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(character.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Мир:', world.name),
              _buildDetailRow('Класс:', _getCharacterClassName(character.characterClass)),
              _buildDetailRow('Уровень:', '${character.level}'),
              _buildDetailRow('Опыт:', '${character.experience}'),
              _buildDetailRow('Здоровье:', '${character.health}/${character.maxHealth}'),
              _buildDetailRow('Мана:', '${character.mana}/${character.maxMana}'),
              _buildDetailRow('Сила:', '${character.strength}'),
              _buildDetailRow('Ловкость:', '${character.agility}'),
              _buildDetailRow('Интеллект:', '${character.intelligence}'),
              _buildDetailRow('Создан:', DateFormat('dd.MM.yyyy').format(character.createdAt)),
              if (character.lastPlayed != null)
                _buildDetailRow('Последняя игра:', DateFormat('dd.MM.yyyy HH:mm').format(character.lastPlayed!)),
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
              _showCharacterStats(character);
            },
            child: const Text('Статистика'),
          ),
        ],
      ),
    );
  }

  void _showCharacterStats(GameCharacter character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Статистика ${character.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatRow('Здоровье', character.health, character.maxHealth, Colors.red),
              _buildStatRow('Мана', character.mana, character.maxMana, Colors.blue),
              _buildStatRow('Сила', character.strength, 100, Colors.orange),
              _buildStatRow('Ловкость', character.agility, 100, Colors.green),
              _buildStatRow('Интеллект', character.intelligence, 100, Colors.purple),
              const SizedBox(height: 16),
              if (character.skills.isNotEmpty) ...[
                const Text('Навыки:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...character.skills.map((skill) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('• $skill'),
                )),
              ],
              if (character.inventory.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Инвентарь:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...character.inventory.map((item) => Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 4),
                  child: Text('• $item'),
                )),
              ],
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

  void _showTournamentDetails(Tournament tournament) {
    final world = context.read<Web3GamingProvider>().gameWorlds
        .firstWhere((w) => w.id == tournament.worldId);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tournament.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Мир:', world.name),
              _buildDetailRow('Описание:', tournament.description),
              _buildDetailRow('Статус:', _getTournamentStatusName(tournament.status)),
              _buildDetailRow('Начало:', DateFormat('dd.MM.yyyy HH:mm').format(tournament.startDate)),
              _buildDetailRow('Окончание:', DateFormat('dd.MM.yyyy HH:mm').format(tournament.endDate)),
              _buildDetailRow('Участники:', '${tournament.participants.length}/${tournament.maxParticipants}'),
              _buildDetailRow('Вступительный взнос:', '${tournament.entryFee} ${tournament.tokenSymbol}'),
              if (tournament.winners.isNotEmpty)
                _buildDetailRow('Победители:', tournament.winners.join(', ')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          if (tournament.status == TournamentStatus.upcoming)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showJoinTournamentDialog(tournament, context.read<Web3GamingProvider>());
              },
              child: const Text('Участвовать'),
            ),
        ],
      ),
    );
  }

  void _showJoinTournamentDialog(Tournament tournament, Web3GamingProvider provider) {
    final userCharacters = provider.userCharacters
        .where((c) => c.worldId == tournament.worldId)
        .toList();
    
    if (userCharacters.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Нет персонажей'),
          content: const Text('Для участия в турнире необходимо создать персонажа в этом игровом мире.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Закрыть'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                final world = provider.gameWorlds.firstWhere((w) => w.id == tournament.worldId);
                _showCreateCharacterDialog(world);
              },
              child: const Text('Создать персонажа'),
            ),
          ],
        ),
      );
      return;
    }

    GameCharacter? selectedCharacter = userCharacters.first;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Участвовать в турнире'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Выберите персонажа для участия:'),
            const SizedBox(height: 16),
            DropdownButtonFormField<GameCharacter>(
              value: selectedCharacter,
              decoration: const InputDecoration(
                labelText: 'Персонаж',
                border: OutlineInputBorder(),
              ),
              items: userCharacters.map((character) {
                return DropdownMenuItem(
                  value: character,
                  child: Text('${character.name} (Ур. ${character.level})'),
                );
              }).toList(),
              onChanged: (value) {
                selectedCharacter = value;
              },
            ),
            const SizedBox(height: 16),
            Text('Вступительный взнос: ${tournament.entryFee} ${tournament.tokenSymbol}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedCharacter != null) {
                provider.joinTournament(tournament.id, selectedCharacter!.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Вы успешно зарегистрировались на турнир!')),
                );
              }
            },
            child: const Text('Участвовать'),
          ),
        ],
      ),
    );
  }

  void _claimReward(GameReward reward, Web3GamingProvider provider) {
    provider.claimReward(reward.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Награда "${reward.name}" получена!')),
    );
  }

  void _showDeFiDetails(DeFiIntegration integration) {
    final world = context.read<Web3GamingProvider>().gameWorlds
        .firstWhere((w) => w.id == integration.worldId);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('DeFi: ${integration.protocolName}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Мир:', world.name),
              _buildDetailRow('Тип:', _getDeFiIntegrationTypeName(integration.type)),
              _buildDetailRow('Протокол:', integration.protocolName),
              _buildDetailRow('APY:', '${integration.apy.toStringAsFixed(2)}%'),
              _buildDetailRow('TVL:', '${_formatNumber(integration.tvl)}'),
              _buildDetailRow('Ваш стейк:', '${_formatNumber(integration.userStake)}'),
              _buildDetailRow('Ваши награды:', '${_formatNumber(integration.userRewards)}'),
              _buildDetailRow('Обновлено:', DateFormat('dd.MM.yyyy HH:mm').format(integration.lastUpdated)),
              _buildDetailRow('Статус:', integration.isActive ? 'Активен' : 'Неактивен'),
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
              _showDeFiActions(integration, context.read<Web3GamingProvider>());
            },
            child: const Text('Действия'),
          ),
        ],
      ),
    );
  }

  void _showDeFiActions(DeFiIntegration integration, Web3GamingProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('DeFi действия'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.trending_up, color: Colors.green),
              title: const Text('Стейкать'),
              subtitle: const Text('Добавить токены в стейкинг'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement staking dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Функция стейкинга в разработке')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_down, color: Colors.red),
              title: const Text('Вывести'),
              subtitle: const Text('Вывести токены из стейкинга'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement unstaking dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Функция вывода в разработке')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.blue),
              title: const Text('Забрать награды'),
              subtitle: const Text('Получить накопленные награды'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement claim rewards dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Функция получения наград в разработке')),
                );
              },
            ),
          ],
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int current, int max, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('$current/$max'),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: max > 0 ? current / max : 0,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  String _getGameWorldTypeName(GameWorldType type) {
    switch (type) {
      case GameWorldType.rpg:
        return 'RPG';
      case GameWorldType.strategy:
        return 'Стратегия';
      case GameWorldType.action:
        return 'Экшен';
      case GameWorldType.simulation:
        return 'Симулятор';
      case GameWorldType.puzzle:
        return 'Головоломка';
      case GameWorldType.racing:
        return 'Гонки';
    }
  }

  String _getCharacterClassName(CharacterClass characterClass) {
    switch (characterClass) {
      case CharacterClass.warrior:
        return 'Воин';
      case CharacterClass.mage:
        return 'Маг';
      case CharacterClass.archer:
        return 'Лучник';
      case CharacterClass.healer:
        return 'Лекарь';
      case CharacterClass.rogue:
        return 'Разбойник';
      case CharacterClass.tank:
        return 'Танк';
    }
  }

  String _getTournamentStatusName(TournamentStatus status) {
    switch (status) {
      case TournamentStatus.upcoming:
        return 'Предстоящий';
      case TournamentStatus.active:
        return 'Активный';
      case TournamentStatus.completed:
        return 'Завершен';
      case TournamentStatus.cancelled:
        return 'Отменен';
    }
  }

  String _getDeFiIntegrationTypeName(DeFiIntegrationType type) {
    switch (type) {
      case DeFiIntegrationType.staking:
        return 'Стейкинг';
      case DeFiIntegrationType.liquidity_providing:
        return 'Ликвидность';
      case DeFiIntegrationType.yield_farming:
        return 'Ферминг';
      case DeFiIntegrationType.lending:
        return 'Кредитование';
      case DeFiIntegrationType.borrowing:
        return 'Заимствование';
    }
  }
}
