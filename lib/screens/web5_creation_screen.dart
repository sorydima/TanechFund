import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/providers/web5_creation_provider.dart';

class Web5CreationScreen extends StatefulWidget {
  const Web5CreationScreen({super.key});

  @override
  State<Web5CreationScreen> createState() => _Web5CreationScreenState();
}

class _Web5CreationScreenState extends State<Web5CreationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Web5CreationProvider>().initialize();
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
      body: Consumer<Web5CreationProvider>(
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
                    _buildProjectsTab(provider),
                    _buildAICollaboratorsTab(provider),
                    _buildCreativeMomentsTab(provider),
                    _buildCreationStudioTab(provider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateProjectDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Новый Проект'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade600, Colors.pink.shade600],
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
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Web5: Творение',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Создавайте новые миры с помощью AI',
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
    return Consumer<Web5CreationProvider>(
      builder: (context, provider, child) {
        final activeProjects = provider.getActiveProjects();
        final activeCollaborators = provider.getActiveCollaborators();
        final sharedMoments = provider.getSharedMoments();
        
        return Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Активные Проекты',
                activeProjects.length.toString(),
                Icons.rocket_launch,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'AI Помощники',
                activeCollaborators.length.toString(),
                Icons.smart_toy,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Творческие Моменты',
                sharedMoments.length.toString(),
                Icons.lightbulb,
                Colors.yellow,
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
        labelColor: Colors.purple,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.purple,
        tabs: const [
          Tab(text: 'Проекты', icon: Icon(Icons.rocket_launch)),
          Tab(text: 'AI Помощники', icon: Icon(Icons.smart_toy)),
          Tab(text: 'Моменты', icon: Icon(Icons.lightbulb)),
          Tab(text: 'Студия', icon: Icon(Icons.art_track)),
        ],
      ),
    );
  }

  Widget _buildProjectsTab(Web5CreationProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.projects.length,
      itemBuilder: (context, index) {
        final project = provider.projects[index];
        return _buildProjectCard(project, index);
      },
    );
  }

  Widget _buildProjectCard(CreationProject project, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: InkWell(
        onTap: () => _showProjectDetails(project),
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
                      color: _getTypeColor(project.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(project.type),
                      color: _getTypeColor(project.type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          project.description,
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
                  _buildStatusChip(project.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: project.progress / 100,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getTypeColor(project.type),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${project.progress}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${project.collaborators.length}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.smart_toy,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    project.aiAssistant != null ? 'AI' : 'Нет',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: project.tags.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: Colors.purple.withOpacity(0.1),
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

  Widget _buildAICollaboratorsTab(Web5CreationProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.aiCollaborators.length,
      itemBuilder: (context, index) {
        final collaborator = provider.aiCollaborators[index];
        return _buildCollaboratorCard(collaborator, index);
      },
    );
  }

  Widget _buildCollaboratorCard(AICollaborator collaborator, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _getSpecialtyColor(collaborator.specialty).withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                _getSpecialtyIcon(collaborator.specialty),
                color: _getSpecialtyColor(collaborator.specialty),
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        collaborator.name,
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
                          color: collaborator.isActive ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    collaborator.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getSpecialtyColor(collaborator.specialty).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          collaborator.specialty.name,
                          style: TextStyle(
                            color: _getSpecialtyColor(collaborator.specialty),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(collaborator.confidence * 100).round()}%',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _showCollaboratorDetails(collaborator),
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
        .fadeIn()
        .slideX(begin: 0.2);
  }

  Widget _buildCreativeMomentsTab(Web5CreationProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.creativeMoments.length,
      itemBuilder: (context, index) {
        final moment = provider.creativeMoments[index];
        return _buildMomentCard(moment, index);
      },
    );
  }

  Widget _buildMomentCard(CreativeMoment moment, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb,
                  color: Colors.yellow[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    moment.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (moment.isShared)
                  Icon(
                    Icons.share,
                    color: Colors.green[600],
                    size: 20,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              moment.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${moment.timestamp.day}.${moment.timestamp.month}.${moment.timestamp.year}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  '${moment.inspirations.length} вдохновений',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (moment.outcomes.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Результаты: ${moment.outcomes.join(', ')}',
                style: TextStyle(
                  color: Colors.green[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100))
        .fadeIn()
        .slideX(begin: 0.2);
  }

  Widget _buildCreationStudioTab(Web5CreationProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.art_track,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Студия Творения',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Место для совместного творчества с AI',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement creation studio
            },
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Открыть Студию'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(CreationStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case CreationStatus.ideation:
        color = Colors.orange;
        text = 'Идея';
        break;
      case CreationStatus.planning:
        color = Colors.blue;
        text = 'Планирование';
        break;
      case CreationStatus.active:
        color = Colors.green;
        text = 'Активно';
        break;
      case CreationStatus.review:
        color = Colors.purple;
        text = 'Обзор';
        break;
      case CreationStatus.completed:
        color = Colors.grey;
        text = 'Завершено';
        break;
      case CreationStatus.shared:
        color = Colors.pink;
        text = 'Поделено';
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

  Color _getTypeColor(CreationType type) {
    switch (type) {
      case CreationType.digitalArt:
        return Colors.purple;
      case CreationType.music:
        return Colors.orange;
      case CreationType.writing:
        return Colors.blue;
      case CreationType.code:
        return Colors.green;
      case CreationType.business:
        return Colors.yellow;
      case CreationType.social:
        return Colors.pink;
      case CreationType.educational:
        return Colors.indigo;
      case CreationType.scientific:
        return Colors.teal;
      case CreationType.spiritual:
        return Colors.deepPurple;
    }
  }

  IconData _getTypeIcon(CreationType type) {
    switch (type) {
      case CreationType.digitalArt:
        return Icons.palette;
      case CreationType.music:
        return Icons.music_note;
      case CreationType.writing:
        return Icons.edit;
      case CreationType.code:
        return Icons.code;
      case CreationType.business:
        return Icons.business;
      case CreationType.social:
        return Icons.people;
      case CreationType.educational:
        return Icons.school;
      case CreationType.scientific:
        return Icons.science;
      case CreationType.spiritual:
        return Icons.self_improvement;
    }
  }

  Color _getSpecialtyColor(AISpecialty specialty) {
    switch (specialty) {
      case AISpecialty.creative:
        return Colors.purple;
      case AISpecialty.technical:
        return Colors.blue;
      case AISpecialty.analytical:
        return Colors.green;
      case AISpecialty.social:
        return Colors.pink;
      case AISpecialty.strategic:
        return Colors.orange;
      case AISpecialty.artistic:
        return Colors.indigo;
    }
  }

  IconData _getSpecialtyIcon(AISpecialty specialty) {
    switch (specialty) {
      case AISpecialty.creative:
        return Icons.auto_awesome;
      case AISpecialty.technical:
        return Icons.build;
      case AISpecialty.analytical:
        return Icons.analytics;
      case AISpecialty.social:
        return Icons.people;
      case AISpecialty.strategic:
        return Icons.trending_up;
      case AISpecialty.artistic:
        return Icons.palette;
    }
  }

  void _showCreateProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать Новый Проект'),
        content: const Text('Функция создания нового проекта будет реализована в следующих версиях.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showProjectDetails(CreationProject project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(project.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.description),
            const SizedBox(height: 16),
            Text('Прогресс: ${project.progress}%'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: project.progress / 100),
            const SizedBox(height: 16),
            Text('Фазы: ${project.phases.length}'),
            const SizedBox(height: 8),
            Text('Сотрудники: ${project.collaborators.length}'),
            const SizedBox(height: 8),
            Text('AI Помощник: ${project.aiAssistant != null ? 'Да' : 'Нет'}'),
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

  void _showCollaboratorDetails(AICollaborator collaborator) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(collaborator.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(collaborator.description),
            const SizedBox(height: 16),
            Text('Специализация: ${collaborator.specialty.name}'),
            const SizedBox(height: 8),
            Text('Уверенность: ${(collaborator.confidence * 100).round()}%'),
            const SizedBox(height: 8),
            Text('Возможности: ${collaborator.capabilities.join(', ')}'),
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
