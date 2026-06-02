import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/models/project_model.dart';
import 'package:rechain_vc_lab/providers/portfolio_provider.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/screens/project_details_screen.dart';
import 'package:rechain_vc_lab/core/logger.dart';

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
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProjects();
    });
  }

  Future<void> _loadProjects() async {
    setState(() => _isRefreshing = true);
    final provider = context.read<PortfolioProvider>();
    final result = await provider.loadProjects();
    if (result.isFailure) {
      _showErrorSnackBar(result.error?.message ?? 'Ошибка загрузки');
    }
    if (mounted) setState(() => _isRefreshing = false);
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
            tooltip: 'Поиск',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
            tooltip: 'Фильтры',
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () => _showAddProjectDialog(),
            tooltip: 'Добавить проект',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(icon: Icon(Icons.grid_view), text: 'Все'),
            Tab(icon: Icon(Icons.person), text: 'Мои'),
            Tab(icon: Icon(Icons.trending_up), text: 'Популярные'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProjects,
        color: AppTheme.primaryColor,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildAllProjectsTab(),
            _buildMyProjectsTab(),
            _buildPopularProjectsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProjectDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Проект'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  // Вкладка всех проектов
  Widget _buildAllProjectsTab() {
    return Consumer<PortfolioProvider>(
      builder: (context, portfolioProvider, child) {
        if (portfolioProvider.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Загрузка проектов...', style: TextStyle(fontSize: 16)),
              ],
            ),
          );
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
          return _buildEmptyState(
            'Проекты не найдены',
            _searchQuery.isNotEmpty 
                ? 'Попробуйте изменить поисковый запрос или фильтры'
                : 'Будьте первым, кто создаст проект!',
            icon: _searchQuery.isNotEmpty ? Icons.search_off : Icons.folder_open,
            actionButton: _searchQuery.isEmpty
                ? ElevatedButton.icon(
                    onPressed: () => _showAddProjectDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Создать проект'),
                  )
                : null,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredProjects.length,
          itemBuilder: (context, index) {
            final project = filteredProjects[index];
            return _buildProjectCard(project, portfolioProvider)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 50))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Вкладка моих проектов
  Widget _buildMyProjectsTab() {
    return Consumer2<PortfolioProvider, AuthProvider>(
      builder: (context, portfolioProvider, authProvider, child) {
        final userId = authProvider.userId ?? 'current_user_id';
        final myProjects = portfolioProvider.getUserProjects(userId);

        if (myProjects.isEmpty) {
          return _buildEmptyState(
            'У вас пока нет проектов',
            'Создайте свой первый проект и покажите его миру!',
            icon: Icons.article_outlined,
            actionButton: ElevatedButton.icon(
              onPressed: () => _showAddProjectDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Создать проект'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
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
                .fadeIn(delay: Duration(milliseconds: index * 50))
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
        if (portfolioProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final popularProjects = portfolioProvider.projects
            .where((project) => project.likes > 5 || project.rating > 4.0)
            .toList()
          ..sort((a, b) {
            final scoreA = a.likes * 10 + a.rating * 20 + a.views;
            final scoreB = b.likes * 10 + b.rating * 20 + b.views;
            return scoreB.compareTo(scoreA);
          });

        if (popularProjects.isEmpty) {
          return _buildEmptyState(
            'Популярные проекты не найдены',
            'Станьте первым, кто наберёт популярность!',
            icon: Icons.emoji_events_outlined,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: popularProjects.length,
          itemBuilder: (context, index) {
            final project = popularProjects[index];
            return _buildProjectCard(project, portfolioProvider, showRank: true, rank: index + 1)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 50))
                .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0));
          },
        );
      },
    );
  }

  // Карточка проекта
  Widget _buildProjectCard(ProjectModel project, PortfolioProvider provider, {bool showRank = false, int rank = 0}) {
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
            // Изображение проекта с рангом
            Stack(
              children: [
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
                        onError: (_, __) => null,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Градиент overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        // Статус проекта
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _getStatusColor(project.status),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
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
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(project.category),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
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
                  )
                else
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.7),
                          AppTheme.accentColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.code, size: 64, color: Colors.white.withOpacity(0.8)),
                          const SizedBox(height: 8),
                          Text(
                            'Нет изображения',
                            style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                        ],
                      ),
                    ),
                  ),
                // Rank badge для популярных проектов
                if (showRank)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: rank <= 3 ? Colors.amber : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '#$rank',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: rank <= 3 ? Colors.white : AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Информация о проекте
            Padding(
              padding: const EdgeInsets.all(16),
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
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              project.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Описание
                  Text(
                    project.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Технологии
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: project.technologies.take(5).map((tech) => 
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          tech,
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Разделитель
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 12),

                  // Метаданные и статистика
                  Row(
                    children: [
                      _buildProjectMeta(Icons.favorite, '${project.likes}', Colors.red),
                      const SizedBox(width: 16),
                      _buildProjectMeta(Icons.visibility, '${project.views}', Colors.blue),
                      const SizedBox(width: 16),
                      _buildProjectMeta(Icons.calendar_today, _formatDate(project.createdAt), Colors.grey),
                      const Spacer(),
                      // Кнопки действий
                      if (project.githubUrl != null)
                        IconButton(
                          icon: const Icon(Icons.code, size: 22),
                          onPressed: () => _openUrl(project.githubUrl!),
                          tooltip: 'GitHub',
                          color: Colors.grey[700],
                        ),
                      if (project.liveUrl != null)
                        IconButton(
                          icon: const Icon(Icons.launch, size: 22),
                          onPressed: () => _openUrl(project.liveUrl!),
                          tooltip: 'Live Demo',
                          color: Colors.grey[700],
                        ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, size: 22),
                        onPressed: () => _likeProject(project, provider),
                        tooltip: 'Лайк',
                        color: Colors.grey[700],
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
  Widget _buildProjectMeta(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Пустое состояние
  Widget _buildEmptyState(String title, String subtitle, {Widget? actionButton, IconData icon = Icons.work_outline}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppTheme.primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionButton != null) ...[
              const SizedBox(height: 32),
              actionButton,
            ],
          ],
        ),
      ),
    );
  }

  // Лайк проекта
  Future<void> _likeProject(ProjectModel project, PortfolioProvider provider) async {
    final result = await provider.likeProject(project.id);
    if (mounted) {
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.white),
                const SizedBox(width: 8),
                Text('Вы оценили проект "${project.title}"'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        _showErrorSnackBar(result.error?.message ?? 'Ошибка');
      }
    }
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
    final titleController = TextEditingController();
    final descController = TextEditingController();
    ProjectCategory selectedCategory = ProjectCategory.defi;
    ProjectStatus selectedStatus = ProjectStatus.inProgress;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Новый проект'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Название',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ProjectCategory>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Категория',
                    border: OutlineInputBorder(),
                  ),
                  items: ProjectCategory.values.map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(_getCategoryText(cat)),
                  )).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedCategory = value!);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ProjectStatus>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Статус',
                    border: OutlineInputBorder(),
                  ),
                  items: ProjectStatus.values.map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(_getStatusText(status)),
                  )).toList(),
                  onChanged: (value) {
                    setDialogState(() => selectedStatus = value!);
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
              onPressed: () async {
                Navigator.pop(context);
                await _createProject(
                  titleController.text,
                  descController.text,
                  selectedCategory,
                  selectedStatus,
                );
              },
              child: const Text('Создать'),
            ),
          ],
        ),
      ),
    );
  }

  // Создание проекта
  Future<void> _createProject(
    String title,
    String description,
    ProjectCategory category,
    ProjectStatus status,
  ) async {
    if (title.isEmpty || description.isEmpty) {
      _showErrorSnackBar('Заполните название и описание');
      return;
    }

    final provider = context.read<PortfolioProvider>();
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.userId ?? 'current_user_id';

    final project = ProjectModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      userId: userId,
      category: category,
      status: status,
      technologies: const ['Flutter'],
      images: const [],
      createdAt: DateTime.now(),
      tags: const [],
    );

    final result = await provider.addProject(project);
    if (mounted) {
      if (result.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Проект успешно создан!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        _showErrorSnackBar(result.error?.message ?? 'Ошибка создания');
      }
    }
  }

  // Показать детали проекта
  void _showProjectDetails(ProjectModel project, PortfolioProvider provider) {
    provider.incrementViews(project.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectDetailsScreen(project: project),
      ),
    );
  }

  // Открыть URL
  void _openUrl(String url) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открытие: $url'),
        backgroundColor: AppTheme.primaryColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Уведомления
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
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
