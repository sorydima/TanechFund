import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/providers/web4_movement_provider.dart';

class Web4MovementScreen extends StatefulWidget {
  const Web4MovementScreen({super.key});

  @override
  State<Web4MovementScreen> createState() => _Web4MovementScreenState();
}

class _Web4MovementScreenState extends State<Web4MovementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Web4MovementProvider>().initialize();
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
      body: Consumer<Web4MovementProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTrajectoriesTab(provider),
                    _buildIdentitiesTab(provider),
                    _buildMovementMapTab(provider),
                    _buildProgressTab(provider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTrajectoryDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Новый Путь'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.purple.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Web4: Движение',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Создавайте новые траектории в цифровом мире',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatsCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Consumer<Web4MovementProvider>(
      builder: (context, provider, child) {
        final activeTrajectories = provider.getActiveTrajectories();
        final activeIdentities = provider.getActiveIdentities();
        
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Активные Пути',
                activeTrajectories.length.toString(),
                Icons.route,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Цифровые Идентичности',
                activeIdentities.length.toString(),
                Icons.person,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Прогресс',
                '${activeTrajectories.fold(0, (sum, t) => sum + t.progress) ~/ (activeTrajectories.isEmpty ? 1 : activeTrajectories.length)}%',
                Icons.trending_up,
                Colors.purple,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.blue,
        tabs: const [
          Tab(text: 'Пути', icon: Icon(Icons.route)),
          Tab(text: 'Идентичности', icon: Icon(Icons.person)),
          Tab(text: 'Карта Движения', icon: Icon(Icons.map)),
          Tab(text: 'Прогресс', icon: Icon(Icons.analytics)),
        ],
      ),
    );
  }

  Widget _buildTrajectoriesTab(Web4MovementProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.trajectories.length,
      itemBuilder: (context, index) {
        final trajectory = provider.trajectories[index];
        return _buildTrajectoryCard(trajectory, index);
      },
    );
  }

  Widget _buildTrajectoryCard(MovementTrajectory trajectory, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: InkWell(
        onTap: () => _showTrajectoryDetails(trajectory),
        borderRadius: BorderRadius.circular(12),
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
                      color: _getTypeColor(trajectory.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(trajectory.type),
                      color: _getTypeColor(trajectory.type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trajectory.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          trajectory.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(trajectory.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: trajectory.progress / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getTypeColor(trajectory.type),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${trajectory.progress}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: trajectory.tags.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  labelStyle: const TextStyle(fontSize: 12),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
        .fadeIn()
        .slideX(begin: 0.2);
  }

  Widget _buildIdentitiesTab(Web4MovementProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.identities.length,
      itemBuilder: (context, index) {
        final identity = provider.identities[index];
        return _buildIdentityCard(identity, index);
      },
    );
  }

  Widget _buildIdentityCard(DigitalIdentity identity, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(identity.avatar),
              child: identity.avatar.isEmpty
                  ? const Icon(Icons.person, size: 30)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        identity.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: identity.isActive ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${identity.skills.length} навыков • ${identity.connections.length} связей',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: identity.skills.take(3).map((skill) => Chip(
                      label: Text(skill),
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      labelStyle: const TextStyle(fontSize: 10),
                    )).toList(),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showIdentityDetails(identity),
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
        .fadeIn()
        .slideX(begin: 0.2);
  }

  Widget _buildMovementMapTab(Web4MovementProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.map,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Карта Движения',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Визуализация ваших путей и связей',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement movement map
            },
            icon: const Icon(Icons.explore),
            label: const Text('Открыть Карту'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTab(Web4MovementProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildProgressOverview(provider),
        const SizedBox(height: 16),
        _buildRecentActivity(provider),
      ],
    );
  }

  Widget _buildProgressOverview(Web4MovementProvider provider) {
    final activeTrajectories = provider.getActiveTrajectories();
    final totalProgress = activeTrajectories.isEmpty 
        ? 0 
        : activeTrajectories.fold(0, (sum, t) => sum + t.progress) / activeTrajectories.length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Общий Прогресс',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
                        '${totalProgress.round()}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const Text('Завершено'),
                    ],
                  ),
                ),
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: totalProgress / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(Web4MovementProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Недавняя Активность',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.trajectories.take(3).length,
              itemBuilder: (context, index) {
                final trajectory = provider.trajectories[index];
                return ListTile(
                  leading: Icon(
                    _getTypeIcon(trajectory.type),
                    color: _getTypeColor(trajectory.type),
                  ),
                  title: Text(trajectory.title),
                  subtitle: Text('Прогресс: ${trajectory.progress}%'),
                  trailing: Text(
                    '${DateTime.now().difference(trajectory.createdAt).inDays}д',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(MovementStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case MovementStatus.planning:
        color = Colors.orange;
        text = 'Планирование';
        break;
      case MovementStatus.active:
        color = Colors.green;
        text = 'Активно';
        break;
      case MovementStatus.paused:
        color = Colors.yellow;
        text = 'Приостановлено';
        break;
      case MovementStatus.completed:
        color = Colors.blue;
        text = 'Завершено';
        break;
      case MovementStatus.abandoned:
        color = Colors.red;
        text = 'Заброшено';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getTypeColor(MovementType type) {
    switch (type) {
      case MovementType.personal:
        return Colors.purple;
      case MovementType.professional:
        return Colors.blue;
      case MovementType.creative:
        return Colors.orange;
      case MovementType.social:
        return Colors.green;
      case MovementType.economic:
        return Colors.yellow;
      case MovementType.spiritual:
        return Colors.indigo;
    }
  }

  IconData _getTypeIcon(MovementType type) {
    switch (type) {
      case MovementType.personal:
        return Icons.person;
      case MovementType.professional:
        return Icons.work;
      case MovementType.creative:
        return Icons.palette;
      case MovementType.social:
        return Icons.people;
      case MovementType.economic:
        return Icons.attach_money;
      case MovementType.spiritual:
        return Icons.self_improvement;
    }
  }

  void _showCreateTrajectoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать Новый Путь'),
        content: const Text('Функция создания нового пути будет реализована в следующих версиях.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTrajectoryDetails(MovementTrajectory trajectory) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(trajectory.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(trajectory.description),
            const SizedBox(height: 16),
            Text('Прогресс: ${trajectory.progress}%'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: trajectory.progress / 100),
            const SizedBox(height: 16),
            Text('Шаги: ${trajectory.steps.length}'),
            const SizedBox(height: 8),
            Text('Создано: ${trajectory.createdAt.day}.${trajectory.createdAt.month}.${trajectory.createdAt.year}'),
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

  void _showIdentityDetails(DigitalIdentity identity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(identity.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Навыки: ${identity.skills.join(', ')}'),
            const SizedBox(height: 8),
            Text('Связи: ${identity.connections.length}'),
            const SizedBox(height: 8),
            Text('Последняя активность: ${identity.lastActive.day}.${identity.lastActive.month}.${identity.lastActive.year}'),
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
}
