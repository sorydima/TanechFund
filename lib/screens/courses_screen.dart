import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Экран курсов — обучение Web3, блокчейн, криптовалютам
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  bool _showCompleted = true;

  final List<Map<String, dynamic>> _courses = [
    {
      'id': '1',
      'title': 'Введение в блокчейн',
      'instructor': 'Алексей Петров',
      'category': 'basics',
      'level': 'beginner',
      'duration': '4 часа',
      'lessons': 12,
      'students': 2450,
      'rating': 4.8,
      'reviews': 320,
      'price': 0,
      'image': '🔗',
      'color': Colors.blue,
      'progress': 100,
      'completed': true,
      'description': 'Основы технологии блокчейн, криптовалюты и децентрализация',
    },
    {
      'id': '2',
      'title': 'DeFi Протоколы',
      'instructor': 'Мария Иванова',
      'category': 'defi',
      'level': 'intermediate',
      'duration': '6 часов',
      'lessons': 18,
      'students': 1820,
      'rating': 4.9,
      'reviews': 245,
      'price': 49.99,
      'image': '💰',
      'color': Colors.green,
      'progress': 65,
      'completed': false,
      'description': 'Децентрализованные финансы: стейкинг, фарминг, ликвидность',
    },
    {
      'id': '3',
      'title': 'NFT: Создание и торговля',
      'instructor': 'Дмитрий Сидоров',
      'category': 'nft',
      'level': 'beginner',
      'duration': '3 часа',
      'lessons': 10,
      'students': 3100,
      'rating': 4.7,
      'reviews': 410,
      'price': 29.99,
      'image': '🎨',
      'color': Colors.purple,
      'progress': 30,
      'completed': false,
      'description': 'Создание, минтинг и торговля NFT на маркетплейсах',
    },
    {
      'id': '4',
      'title': 'Смарт-контракты Solidity',
      'instructor': 'Анна Козлова',
      'category': 'development',
      'level': 'advanced',
      'duration': '12 часов',
      'lessons': 32,
      'students': 980,
      'rating': 4.9,
      'reviews': 156,
      'price': 99.99,
      'image': '💻',
      'color': Colors.orange,
      'progress': 0,
      'completed': false,
      'description': 'Разработка смарт-контрактов на Solidity для Ethereum',
    },
    {
      'id': '5',
      'title': 'Безопасность в Web3',
      'instructor': 'Игорь Волков',
      'category': 'security',
      'level': 'intermediate',
      'duration': '5 часов',
      'lessons': 15,
      'students': 1450,
      'rating': 4.8,
      'reviews': 198,
      'price': 59.99,
      'image': '🔒',
      'color': Colors.red,
      'progress': 0,
      'completed': false,
      'description': 'Защита активов, аудит смарт-контрактов, лучшие практики',
    },
    {
      'id': '6',
      'title': 'DAO Управление',
      'instructor': 'Елена Морозова',
      'category': 'dao',
      'level': 'intermediate',
      'duration': '4 часа',
      'lessons': 14,
      'students': 1120,
      'rating': 4.6,
      'reviews': 142,
      'price': 39.99,
      'image': '🏛️',
      'color': Colors.blue.shade700,
      'progress': 100,
      'completed': true,
      'description': 'Децентрализованные автономные организации и управление',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Курсы'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearch,
            tooltip: 'Поиск',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilters,
            tooltip: 'Фильтры',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Overview
          _buildStatsOverview(),

          // Category Filter
          _buildCategoryFilter(),

          // Courses List
          Expanded(
            child: _buildCoursesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _suggestCourse,
        icon: const Icon(Icons.lightbulb),
        label: const Text('Предложить курс'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }

  // Stats Overview
  Widget _buildStatsOverview() {
    final completed = _courses.where((c) => c['completed'] as bool).length;
    final inProgress = _courses.where((c) => (c['progress'] as int) > 0 && !(c['completed'] as bool)).length;
    final totalHours = _courses.fold<int>(
      0,
      (sum, c) => sum + int.parse((c['duration'] as String).split(' ')[0]),
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.accentColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.school, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REChain Academy',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Ваш прогресс',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Завершено',
                  '$completed',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  'В процессе',
                  '$inProgress',
                  Icons.schedule,
                  Colors.orange,
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildStatItem(
                  'Часов',
                  '$totalHours',
                  Icons.timer,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.9), size: 24),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // Category Filter
  Widget _buildCategoryFilter() {
    final categories = [
      {'id': 'all', 'label': 'Все', 'icon': Icons.view_agenda},
      {'id': 'basics', 'label': 'Основы', 'icon': Icons.star},
      {'id': 'defi', 'label': 'DeFi', 'icon': Icons.account_balance},
      {'id': 'nft', 'label': 'NFT', 'icon': Icons.image},
      {'id': 'development', 'label': 'Разработка', 'icon': Icons.code},
      {'id': 'security', 'label': 'Безопасность', 'icon': Icons.security},
      {'id': 'dao', 'label': 'DAO', 'icon': Icons.groups},
    ];

    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['id'];
          
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              avatar: Icon(category['icon'] as IconData, size: 18),
              label: Text(category['label'] as String),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedCategory = category['id'] as String);
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryColor,
            ),
          );
        },
      ),
    );
  }

  // Courses List
  Widget _buildCoursesList() {
    var filtered = _courses;

    if (_selectedCategory != 'all') {
      filtered = filtered.where((c) => c['category'] == _selectedCategory).toList();
    }

    if (!_showCompleted) {
      filtered = filtered.where((c) => !(c['completed'] as bool)).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((c) {
        final title = (c['title'] as String).toLowerCase();
        final instructor = (c['instructor'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || instructor.contains(query);
      }).toList();
    }

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return _buildCourseCard(filtered[index], index);
      },
    );
  }

  // Course Card
  Widget _buildCourseCard(Map<String, dynamic> course, int index) {
    final isCompleted = course['completed'] as bool;
    final progress = course['progress'] as int;
    final hasProgress = progress > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _openCourse(course),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    (course['color'] as Color).withOpacity(0.2),
                    (course['color'] as Color).withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  // Emoji icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: (course['color'] as Color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        course['image'] as String,
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          course['instructor'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildLevelBadge(course['level'] as String),
                            const SizedBox(width: 8),
                            _buildDurationBadge(course['duration'] as String),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Price or Completed
                  isCompleted
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                        )
                      : course['price'] == 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Бесплатно',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '\$${course['price']}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    course['description'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Stats
                  Row(
                    children: [
                      _buildCourseStat(
                        '${course['lessons']}',
                        'уроков',
                        Icons.play_circle_outline,
                      ),
                      const SizedBox(width: 16),
                      _buildCourseStat(
                        '${course['students']}',
                        'студентов',
                        Icons.people_outline,
                      ),
                      const SizedBox(width: 16),
                      _buildCourseStat(
                        '${course['rating']}',
                        'рейтинг',
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ],
                  ),

                  // Progress bar
                  if (hasProgress) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isCompleted ? Colors.green : AppTheme.primaryColor,
                        ),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$progress% завершено',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _openCourse(course),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: course['color'],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isCompleted ? 'Повторить' : hasProgress ? 'Продолжить' : 'Начать',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50))
      .slideX(begin: 0.2, end: 0);
  }

  Widget _buildLevelBadge(String level) {
    Color color;
    String label;

    switch (level) {
      case 'beginner':
        color = Colors.green;
        label = 'Новичок';
        break;
      case 'intermediate':
        color = Colors.orange;
        label = 'Средний';
        break;
      case 'advanced':
        color = Colors.red;
        label = 'Продвинутый';
        break;
      default:
        color = Colors.grey;
        label = level;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDurationBadge(String duration) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time, size: 10, color: Colors.blue),
          const SizedBox(width: 3),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseStat(String value, String label, IconData icon, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.grey[700],
          ),
        ),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Курсы не найдены',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Измените параметры поиска',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Actions
  void _showSearch() {
    showSearch(
      context: context,
      delegate: CoursesSearchDelegate(_courses),
    );
  }

  void _showFilters() {
    AppLogger.info('Show course filters');
  }

  void _openCourse(Map<String, dynamic> course) {
    AppLogger.info('Open course: ${course['title']}');
    Navigator.pushNamed(
      context,
      '/course-details',
      arguments: course,
    );
  }

  void _suggestCourse() {
    AppLogger.info('Suggest course');
  }
}

// Search Delegate
class CoursesSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> courses;

  CoursesSearchDelegate(this.courses);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = courses.where((c) {
      final title = (c['title'] as String).toLowerCase();
      final instructor = (c['instructor'] as String).toLowerCase();
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery) || instructor.contains(searchQuery);
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text('Ничего не найдено'),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]['title'] as String),
          subtitle: Text(results[index]['instructor'] as String),
          onTap: () {
            close(context, null);
            // Navigate to course details
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
