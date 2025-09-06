import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rechain_vc_lab/providers/web3_education_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class Web3EducationScreen extends StatefulWidget {
  const Web3EducationScreen({super.key});

  @override
  State<Web3EducationScreen> createState() => _Web3EducationScreenState();
}

class _Web3EducationScreenState extends State<Web3EducationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  CourseCategory? _selectedCategory;
  CourseDifficulty? _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Web3EducationProvider>().initialize();
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
                  'Web3 Education',
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
                      Icons.school,
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
                      hintText: 'Поиск курсов...',
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
              child: Consumer<Web3EducationProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Мои курсы',
                              '${provider.userEnrolledCourses.length}',
                              Icons.book,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Прогресс',
                              '${provider.getUserTotalProgress().toStringAsFixed(1)}%',
                              Icons.trending_up,
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
                              'Достижения',
                              '${provider.userAchievements.length}',
                              Icons.emoji_events,
                              Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Очки',
                              '${provider.getUserTotalPoints()}',
                              Icons.stars,
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
            // Filters
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<CourseCategory?>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Категория',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Все')),
                        ...CourseCategory.values.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(_getCategoryName(category)),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<CourseDifficulty?>(
                      value: _selectedDifficulty,
                      decoration: const InputDecoration(
                        labelText: 'Сложность',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Все')),
                        ...CourseDifficulty.values.map((difficulty) {
                          return DropdownMenuItem(
                            value: difficulty,
                            child: Text(_getDifficultyName(difficulty)),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedDifficulty = value;
                        });
                      },
                    ),
                  ),
                ],
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
                  Tab(text: 'Курсы'),
                  Tab(text: 'Мои курсы'),
                  Tab(text: 'Достижения'),
                  Tab(text: 'Прогресс'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCoursesTab(),
                  _buildMyCoursesTab(),
                  _buildAchievementsTab(),
                  _buildProgressTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateCourseDialog(),
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

  Widget _buildCoursesTab() {
    return Consumer<Web3EducationProvider>(
      builder: (context, provider, child) {
        var courses = provider.publishedCourses;

        // Apply filters
        if (_selectedCategory != null) {
          courses = courses.where((course) => course.category == _selectedCategory).toList();
        }
        if (_selectedDifficulty != null) {
          courses = courses.where((course) => course.difficulty == _selectedDifficulty).toList();
        }
        if (_searchQuery.isNotEmpty) {
          courses = provider.searchCourses(_searchQuery);
        }

        if (courses.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных курсов',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return _buildCourseCard(course, provider);
          },
        );
      },
    );
  }

  Widget _buildMyCoursesTab() {
    return Consumer<Web3EducationProvider>(
      builder: (context, provider, child) {
        final courses = provider.userEnrolledCourses;

        if (courses.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.book, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Вы не записаны ни на один курс',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Запишитесь на курс, чтобы начать обучение',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];
            return _buildMyCourseCard(course, provider);
          },
        );
      },
    );
  }

  Widget _buildAchievementsTab() {
    return Consumer<Web3EducationProvider>(
      builder: (context, provider, child) {
        final achievements = provider.userAchievements;

        if (achievements.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'У вас пока нет достижений',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Завершайте уроки и курсы, чтобы получить достижения',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
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

  Widget _buildProgressTab() {
    return Consumer<Web3EducationProvider>(
      builder: (context, provider, child) {
        final progress = provider.learningProgress
            .where((p) => p.userId == provider.currentUserId)
            .toList();

        if (progress.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.trending_up, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет данных о прогрессе',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: progress.length,
          itemBuilder: (context, index) {
            final prog = progress[index];
            final course = provider.courses.firstWhere((c) => c.id == prog.courseId);
            return _buildProgressCard(prog, course);
          },
        );
      },
    );
  }

  Widget _buildCourseCard(Course course, Web3EducationProvider provider) {
    final progress = provider.getProgressForCourse(course.id);
    final isEnrolled = progress != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              image: DecorationImage(
                image: NetworkImage(course.imageUrl),
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
                        course.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              provider.getCourseCategoryName(course.category),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              provider.getCourseDifficultyName(course.difficulty),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Course Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.description,
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
                            'Уроки',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${course.totalLessons}',
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
                            'Студенты',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '${course.totalStudents}',
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
                            'Рейтинг',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(
                                '${course.rating}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Skills
                if (course.skills.isNotEmpty) ...[
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
                    children: course.skills.map((skill) => Chip(
                      label: Text(skill),
                      backgroundColor: Colors.blue.withOpacity(0.1),
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
                        onPressed: () => _showCourseDetails(course),
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
                        onPressed: isEnrolled ? null : () => _enrollInCourse(course, provider),
                        icon: Icon(isEnrolled ? Icons.check : Icons.school, size: 16),
                        label: Text(isEnrolled ? 'Записан' : 'Записаться'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEnrolled ? Colors.grey : Colors.green,
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

  Widget _buildMyCourseCard(Course course, Web3EducationProvider provider) {
    final progress = provider.getProgressForCourse(course.id)!;

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
                        course.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${provider.getCourseCategoryName(course.category)} • ${provider.getCourseDifficultyName(course.difficulty)}',
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
                    '${progress.progress.toStringAsFixed(1)}%',
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
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Прогресс',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${progress.completedLessons}/${progress.totalLessons} уроков',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress.progress / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showCourseDetails(course),
                    icon: const Icon(Icons.info, size: 16),
                    label: const Text('Продолжить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showLessonsList(course, provider),
                    icon: const Icon(Icons.list, size: 16),
                    label: const Text('Уроки'),
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
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                image: DecorationImage(
                  image: NetworkImage(achievement.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.stars, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${achievement.points} очков',
                        style: const TextStyle(
                          color: Colors.amber,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (achievement.unlockedAt != null) ...[
                        const SizedBox(width: 16),
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Получено ${DateFormat('dd.MM.yyyy').format(achievement.unlockedAt!)}',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                        ),
                      ],
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

  Widget _buildProgressCard(LearningProgress progress, Course course) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              course.title,
              style: const TextStyle(
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
                        'Начато',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd.MM.yyyy').format(progress.startedAt),
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
                        'Последняя активность',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        progress.lastActivityAt != null
                            ? DateFormat('dd.MM.yyyy').format(progress.lastActivityAt!)
                            : 'Нет',
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
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Прогресс',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${progress.progress.toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress.progress / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Action Methods
  void _showCreateCourseDialog() {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationController = TextEditingController();
    final priceController = TextEditingController();
    CourseCategory selectedCategory = CourseCategory.blockchain;
    CourseDifficulty selectedDifficulty = CourseDifficulty.beginner;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать курс'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название курса',
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
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<CourseCategory>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Категория',
                        border: OutlineInputBorder(),
                      ),
                      items: CourseCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(_getCategoryName(category)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedCategory = value;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<CourseDifficulty>(
                      value: selectedDifficulty,
                      decoration: const InputDecoration(
                        labelText: 'Сложность',
                        border: OutlineInputBorder(),
                      ),
                      items: CourseDifficulty.values.map((difficulty) {
                        return DropdownMenuItem(
                          value: difficulty,
                          child: Text(_getDifficultyName(difficulty)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedDifficulty = value;
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: durationController,
                      decoration: const InputDecoration(
                        labelText: 'Длительность (часы)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        labelText: 'Цена (токены)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
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
                final provider = context.read<Web3EducationProvider>();
                final course = Course(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: nameController.text,
                  description: descriptionController.text,
                  category: selectedCategory,
                  difficulty: selectedDifficulty,
                  imageUrl: 'https://via.placeholder.com/300x200',
                  instructors: ['Текущий пользователь'],
                  totalLessons: 0,
                  completedLessons: 0,
                  rating: 0.0,
                  totalStudents: 0,
                  totalReviews: 0,
                  prerequisites: [],
                  skills: [],
                  metadata: {},
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  isPublished: false,
                  isFree: double.tryParse(priceController.text) == 0.0,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  currency: 'TOKEN',
                );
                provider.createCourse(course);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Курс "${course.title}" создан!')),
                );
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showCourseDetails(Course course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(course.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (course.imageUrl.isNotEmpty)
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(course.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              _buildDetailRow('Описание:', course.description),
              _buildDetailRow('Категория:', _getCategoryName(course.category)),
              _buildDetailRow('Сложность:', _getDifficultyName(course.difficulty)),
              _buildDetailRow('Уроков:', course.totalLessons.toString()),
              _buildDetailRow('Цена:', course.isFree ? 'Бесплатно' : '${course.price} ${course.currency}'),
              _buildDetailRow('Инструкторы:', course.instructors.join(', ')),
              _buildDetailRow('Студентов:', course.totalStudents.toString()),
              _buildDetailRow('Рейтинг:', course.rating.toStringAsFixed(1)),
              _buildDetailRow('Создан:', DateFormat('dd.MM.yyyy').format(course.createdAt)),
              if (course.updatedAt != null)
                _buildDetailRow('Обновлен:', DateFormat('dd.MM.yyyy').format(course.updatedAt!)),
              if (course.skills.isNotEmpty)
                _buildDetailRow('Навыки:', course.skills.join(', ')),
              if (course.totalReviews > 0) ...[
                const SizedBox(height: 16),
                const Text(
                  'Отзывы:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Пользователь',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text('${course.rating}/5'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Отзыв о курсе'),
                    ],
                  ),
                ),
              ],
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
              final provider = context.read<Web3EducationProvider>();
              _enrollInCourse(course, provider);
            },
            child: const Text('Записаться'),
          ),
        ],
      ),
    );
  }

  void _enrollInCourse(Course course, Web3EducationProvider provider) {
    provider.enrollInCourse(course.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Вы успешно записались на курс "${course.title}"!')),
    );
  }

  void _showLessonsList(Course course, Web3EducationProvider provider) {
    final lessons = provider.getLessonsForCourse(course.id);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Уроки курса "${course.title}"'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              Expanded(
                child: lessons.isEmpty
                    ? const Center(
                        child: Text(
                          'Уроки не найдены',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: AppTheme.primaryColor,
                                child: Icon(
                                  _getLessonTypeIcon(lesson.type),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(lesson.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lesson.description),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.timer,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${lesson.duration} мин',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Icon(
                                        Icons.quiz,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                      const SizedBox(width: 4),
                                                                             Text(
                                         lesson.isCompleted ? 'Завершен' : 'В процессе',
                                         style: TextStyle(
                                           color: Colors.grey[600],
                                           fontSize: 12,
                                         ),
                                       ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.play_circle),
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showLessonDetails(lesson, course);
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _showCreateLessonDialog(course);
                },
                icon: const Icon(Icons.add),
                label: const Text('Добавить урок'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
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

  // Helper Methods
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLessonTypeIcon(LessonType type) {
    switch (type) {
      case LessonType.video:
        return Icons.video_library;
      case LessonType.text:
        return Icons.article;
      case LessonType.interactive:
        return Icons.touch_app;
      case LessonType.quiz:
        return Icons.quiz;
      case LessonType.coding:
        return Icons.code;
      case LessonType.project:
        return Icons.work;
    }
  }

  void _showCreateLessonDialog(Course course) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final durationController = TextEditingController();
    final contentController = TextEditingController();
    LessonType selectedType = LessonType.video;
    bool hasQuiz = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать урок'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Название урока',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<LessonType>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Тип урока',
                        border: OutlineInputBorder(),
                      ),
                      items: LessonType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(_getLessonTypeName(type)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          selectedType = value;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: durationController,
                      decoration: const InputDecoration(
                        labelText: 'Длительность (мин)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Содержание урока',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Есть тест'),
                value: hasQuiz,
                onChanged: (value) {
                  setState(() {
                    hasQuiz = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
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
                final provider = context.read<Web3EducationProvider>();
                final lesson = Lesson(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  courseId: course.id,
                  title: nameController.text,
                  description: descriptionController.text,
                  content: contentController.text,
                  type: selectedType,
                  duration: int.tryParse(durationController.text) ?? 15,
                  resources: [],
                  tags: [],
                  order: provider.getLessonsForCourse(course.id).length + 1,
                  isCompleted: false,
                  metadata: {},
                );
                provider.createLesson(lesson);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Урок "${lesson.title}" создан!')),
                );
              }
            },
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showLessonDetails(Lesson lesson, Course course) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(lesson.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Описание:', lesson.description),
              _buildDetailRow('Тип:', _getLessonTypeName(lesson.type)),
              _buildDetailRow('Длительность:', '${lesson.duration} минут'),
              _buildDetailRow('Порядок:', lesson.order.toString()),
              _buildDetailRow('Содержание:', lesson.content),
              _buildDetailRow('Завершен:', lesson.isCompleted ? 'Да' : 'Нет'),
              if (lesson.completedAt != null)
                _buildDetailRow('Завершен:', DateFormat('dd.MM.yyyy').format(lesson.completedAt!)),
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
              _startLesson(lesson);
            },
            child: const Text('Начать урок'),
          ),
        ],
      ),
    );
  }

  void _startLesson(Lesson lesson) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Начинаем урок "${lesson.title}"...')),
    );
    // TODO: Implement lesson player
  }

  String _getCategoryName(CourseCategory category) {
    switch (category) {
      case CourseCategory.blockchain:
        return 'Блокчейн';
      case CourseCategory.defi:
        return 'DeFi';
      case CourseCategory.nft:
        return 'NFT';
      case CourseCategory.smart_contracts:
        return 'Смарт-контракты';
      case CourseCategory.web3_identity:
        return 'Web3 Identity';
      case CourseCategory.metaverse:
        return 'Метавселенная';
      case CourseCategory.gaming:
        return 'Игры';
      case CourseCategory.trading:
        return 'Трейдинг';
      case CourseCategory.security:
        return 'Безопасность';
      case CourseCategory.governance:
        return 'Управление';
    }
  }

  String _getDifficultyName(CourseDifficulty difficulty) {
    switch (difficulty) {
      case CourseDifficulty.beginner:
        return 'Начинающий';
      case CourseDifficulty.intermediate:
        return 'Средний';
      case CourseDifficulty.advanced:
        return 'Продвинутый';
      case CourseDifficulty.expert:
        return 'Эксперт';
    }
  }

  String _getLessonTypeName(LessonType type) {
    switch (type) {
      case LessonType.video:
        return 'Видео';
      case LessonType.text:
        return 'Текст';
      case LessonType.interactive:
        return 'Интерактивный';
      case LessonType.quiz:
        return 'Тест';
      case LessonType.coding:
        return 'Программирование';
      case LessonType.project:
        return 'Проект';
    }
  }
}
