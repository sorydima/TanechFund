import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/portfolio_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;
  
  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          // App Bar с изображением проекта
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.project.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: Stack(
                children: [
                  // Фоновое изображение
                  if (widget.project.images.isNotEmpty)
                    Positioned.fill(
                      child: Image.network(
                        widget.project.images.first,
                        fit: BoxFit.cover,
                      ),
                    )
                  else
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.primaryColor.withOpacity(0.7),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.work,
                          size: 120,
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  
                  // Градиент поверх изображения
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Информация о проекте
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(widget.project.status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getStatusText(widget.project.status),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(widget.project.category),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getCategoryText(widget.project.category),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  widget.project.rating.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.white,
                ),
                onPressed: () => _toggleLike(),
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareProject(),
              ),
            ],
          ),
          
          // Содержимое проекта
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Основная информация о проекте
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Описание
                      Text(
                        widget.project.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Статистика проекта
                      _buildProjectStats(),
                      const SizedBox(height: 24),
                      
                      // Кнопки действий
                      _buildActionButtons(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                
                // Табы с содержимым проекта
                Container(
                  color: Colors.grey[50],
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        labelColor: AppTheme.primaryColor,
                        unselectedLabelColor: Colors.grey[600],
                        indicatorColor: AppTheme.primaryColor,
                        tabs: const [
                          Tab(text: 'Обзор'),
                          Tab(text: 'Технологии'),
                          Tab(text: 'Метаданные'),
                          Tab(text: 'Комментарии'),
                        ],
                      ),
                      Container(
                        height: 400, // Фиксированная высота для TabBarView
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildOverviewTab(),
                            _buildTechnologiesTab(),
                            _buildMetadataTab(),
                            _buildCommentsTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Статистика проекта
  Widget _buildProjectStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            Icons.favorite,
            'Лайки',
            '${widget.project.likes}',
          ),
        ),
        Expanded(
          child: _buildStatItem(
            Icons.visibility,
            'Просмотры',
            '${widget.project.views}',
          ),
        ),
        Expanded(
          child: _buildStatItem(
            Icons.calendar_today,
            'Создан',
            _formatDate(widget.project.createdAt),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Кнопки действий
  Widget _buildActionButtons() {
    return Row(
      children: [
        if (widget.project.githubUrl != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _openUrl(widget.project.githubUrl!),
              icon: const Icon(Icons.code),
              label: const Text('GitHub'),
            ),
          ),
        if (widget.project.githubUrl != null && widget.project.liveUrl != null)
          const SizedBox(width: 12),
        if (widget.project.liveUrl != null)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _openUrl(widget.project.liveUrl!),
              icon: const Icon(Icons.launch),
              label: const Text('Live Demo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  // Вкладка обзора
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Теги
          _buildSection(
            'Теги',
            Icons.label,
            null,
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.project.tags.map((tag) => 
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Изображения
          if (widget.project.images.length > 1)
            _buildSection(
              'Галерея',
              Icons.photo_library,
              null,
              content: SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.project.images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(widget.project.images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Вкладка технологий
  Widget _buildTechnologiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Используемые технологии',
            Icons.build,
            null,
            content: Column(
              children: widget.project.technologies.map((tech) => 
                ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text(tech),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showTechnologyInfo(tech),
                ),
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Вкладка метаданных
  Widget _buildMetadataTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.project.metadata.isNotEmpty)
            _buildSection(
              'Метаданные',
              Icons.info,
              null,
              content: Column(
                children: widget.project.metadata.entries.map((entry) => 
                  ListTile(
                    leading: Icon(Icons.data_usage, color: AppTheme.primaryColor),
                    title: Text(_formatMetadataKey(entry.key)),
                    subtitle: Text(entry.value.toString()),
                  ),
                ).toList(),
              ),
            ),
          
          const SizedBox(height: 24),
          
          // Ссылки
          if (widget.project.documentationUrl != null)
            _buildSection(
              'Документация',
              Icons.description,
              widget.project.documentationUrl,
            ),
        ],
      ),
    );
  }

  // Вкладка комментариев
  Widget _buildCommentsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.comment_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Комментарии',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Система комментариев будет добавлена позже',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Секция с заголовком
  Widget _buildSection(String title, IconData icon, String? subtitle, {Widget? content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryColor, size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
        if (content != null) ...[
          const SizedBox(height: 16),
          content,
        ],
      ],
    );
  }

  // Действия
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    
    final portfolioProvider = context.read<PortfolioProvider>();
    if (_isLiked) {
      portfolioProvider.likeProject(widget.project.id);
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLiked ? 'Проект добавлен в избранное' : 'Проект убран из избранного'),
        backgroundColor: _isLiked ? Colors.green : Colors.orange,
      ),
    );
  }

  void _shareProject() {
    // Заглушка для шаринга
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция шаринга будет добавлена позже'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _openUrl(String url) {
    // В реальном приложении здесь будет открытие URL
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Открытие: $url'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showTechnologyInfo(String technology) {
    // Заглушка для информации о технологии
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Информация о $technology будет добавлена позже'),
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

  // Форматирование ключа метаданных
  String _formatMetadataKey(String key) {
    switch (key) {
      case 'totalValueLocked':
        return 'Общая заблокированная стоимость';
      case 'apy':
        return 'APY';
      case 'users':
        return 'Пользователи';
      case 'nftsListed':
        return 'NFT в листинге';
      case 'tradingVolume':
        return 'Объем торгов';
      case 'artists':
        return 'Художники';
      case 'proposals':
        return 'Предложения';
      case 'voters':
        return 'Голосующие';
      case 'treasury':
        return 'Казна';
      case 'games':
        return 'Игры';
      case 'players':
        return 'Игроки';
      case 'transactions':
        return 'Транзакции';
      default:
        return key.replaceAll(RegExp(r'([A-Z])'), ' \$1').toLowerCase();
    }
  }
}
