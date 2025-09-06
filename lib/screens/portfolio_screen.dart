import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/portfolio_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/screens/project_details_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  ProjectCategory? _selectedCategory;
  ProjectStatus? _selectedStatus;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PortfolioProvider>().loadProjects();
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
      appBar: AppBar(
        title: const Text('Портфолио'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProjectDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Все проекты'),
            Tab(text: 'Мои проекты'),
            Tab(text: 'Популярные'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllProjectsTab(),
          _buildMyProjectsTab(),
          _buildPopularProjectsTab(),
        ],
      ),
    );
  }

  // Вкладка всех проектов
  Widget _buildAllProjectsTab() {
    return Consumer<PortfolioProvider>(
      builder: (context, portfolioProvider, child) {
        if (portfolioProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredProjects = portfolioProvider.projects;

        // Применяем фильтры
        if (_selectedCategory != null) {
          filteredProjects = filteredProjects
              .where((project) => project.category == _selectedCategory)
              .toList();
        }

        if (_selectedStatus != null) {
          filteredProjects = filteredProjects
              .where((project) => project.status == _selectedStatus)
              .toList();
        }

        if (_searchQuery.isNotEmpty) {
          filteredProjects = portfolioProvider.searchProjects(_searchQuery);
        }

        if (filteredProjects.isEmpty) {
          return _buildEmptyState('Проекты не найдены', 'Попробуйте изменить фильтры');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredProjects.length,
          itemBuilder: (context, index) {
            final project = filteredProjects[index];
            return _buildProjectCard(project, portfolioProvider)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Вкладка моих проектов
  Widget _buildMyProjectsTab() {
    return Consumer<PortfolioProvider>(
      builder: (context, portfolioProvider, child) {
        final myProjects = portfolioProvider.getUserProjects('current_user_id');

        if (myProjects.isEmpty) {
          return _buildEmptyState(
            'У вас пока нет проектов',
            'Создайте свой первый проект и покажите его миру!',
            actionButton: ElevatedButton(
              onPressed: () => _showAddProjectDialog(),
              child: const Text('Создать проект'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: myProjects.length,
          itemBuilder: (context, index) {
            final project = myProjects[index];
            return _buildProjectCard(project, portfolioProvider)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Вкладка популярных проектов
  Widget _buildPopularProjectsTab() {
    return Consumer<PortfolioProvider>(
      builder: (context, portfolioProvider, child) {
        final popularProjects = portfolioProvider.projects
            .where((project) => project.likes > 10 || project.rating > 4.5)
            .toList()
          ..sort((a, b) => (b.likes + b.rating * 10).compareTo(a.likes + a.rating * 10));

        if (popularProjects.isEmpty) {
          return _buildEmptyState('Популярные проекты не найдены', 'Попробуйте позже');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: popularProjects.length,
          itemBuilder: (context, index) {
            final project = popularProjects[index];
            return _buildProjectCard(project, portfolioProvider)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Карточка проекта
  Widget _buildProjectCard(Project project, PortfolioProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showProjectDetails(project, provider),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение проекта
            if (project.images.isNotEmpty)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(project.images.first),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Статус проекта
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(project.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusText(project.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Категория проекта
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(project.category),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getCategoryText(project.category),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Информация о проекте
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок и рейтинг
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          project.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            project.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Описание
                  Text(
                    project.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Технологии
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: project.technologies.take(3).map((tech) => 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tech,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Метаданные и статистика
                  Row(
                    children: [
                      _buildProjectMeta(Icons.favorite, '${project.likes}'),
                      const SizedBox(width: 16),
                      _buildProjectMeta(Icons.visibility, '${project.views}'),
                      const SizedBox(width: 16),
                      _buildProjectMeta(Icons.calendar_today, _formatDate(project.createdAt)),
                      const Spacer(),
                      if (project.githubUrl != null)
                        IconButton(
                          icon: const Icon(Icons.code),
                          onPressed: () => _openUrl(project.githubUrl!),
                          tooltip: 'GitHub',
                        ),
                      if (project.liveUrl != null)
                        IconButton(
                          icon: const Icon(Icons.launch),
                          onPressed: () => _openUrl(project.liveUrl!),
                          tooltip: 'Live Demo',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Метаданные проекта
  Widget _buildProjectMeta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Пустое состояние
  Widget _buildEmptyState(String title, String subtitle, {Widget? actionButton}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.work_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (actionButton != null) ...[
            const SizedBox(height: 24),
            actionButton,
          ],
        ],
      ),
    );
  }

  // Диалог поиска
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Поиск проектов'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Поиск по названию, описанию или технологиям',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Найти'),
          ),
        ],
      ),
    );
  }

  // Диалог фильтров
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Фильтры'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Фильтр по категории
            DropdownButtonFormField<ProjectCategory?>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Категория',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Все категории'),
                ),
                ...ProjectCategory.values.map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(_getCategoryText(category)),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Фильтр по статусу
            DropdownButtonFormField<ProjectStatus?>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Статус',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Все статусы'),
                ),
                ...ProjectStatus.values.map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(_getStatusText(status)),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedCategory = null;
                _selectedStatus = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Сбросить'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }

  // Диалог добавления проекта
  void _showAddProjectDialog() {
    // Заглушка для добавления проекта
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция добавления проекта будет реализована позже'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Показать детали проекта
  void _showProjectDetails(Project project, PortfolioProvider provider) {
    provider.incrementViews(project.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectDetailsScreen(project: project),
      ),
    );
  }

  // Открыть URL
  void _openUrl(String url) {
    // В реальном приложении здесь будет открытие URL
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открытие: $url'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Получение цвета статуса
  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.inProgress:
        return Colors.orange;
      case ProjectStatus.completed:
        return Colors.green;
      case ProjectStatus.onHold:
        return Colors.yellow[700]!;
      case ProjectStatus.cancelled:
        return Colors.red;
    }
  }

  // Получение текста статуса
  String _getStatusText(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.inProgress:
        return 'В разработке';
      case ProjectStatus.completed:
        return 'Завершен';
      case ProjectStatus.onHold:
        return 'Приостановлен';
      case ProjectStatus.cancelled:
        return 'Отменен';
    }
  }

  // Получение цвета категории
  Color _getCategoryColor(ProjectCategory category) {
    switch (category) {
      case ProjectCategory.defi:
        return Colors.green;
      case ProjectCategory.nft:
        return Colors.purple;
      case ProjectCategory.dao:
        return Colors.orange;
      case ProjectCategory.gaming:
        return Colors.blue;
      case ProjectCategory.infrastructure:
        return Colors.indigo;
      case ProjectCategory.other:
        return Colors.grey;
    }
  }

  // Получение текста категории
  String _getCategoryText(ProjectCategory category) {
    switch (category) {
      case ProjectCategory.defi:
        return 'DeFi';
      case ProjectCategory.nft:
        return 'NFT';
      case ProjectCategory.dao:
        return 'DAO';
      case ProjectCategory.gaming:
        return 'Игры';
      case ProjectCategory.infrastructure:
        return 'Инфраструктура';
      case ProjectCategory.other:
        return 'Другое';
    }
  }

  // Форматирование даты
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} нед. назад';
    } else {
      return '${(difference.inDays / 30).floor()} мес. назад';
    }
  }
}
