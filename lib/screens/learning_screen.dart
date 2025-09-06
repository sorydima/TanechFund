import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/learning_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/screens/course_details_screen.dart';
import 'package:rechain_vc_lab/screens/challenge_details_screen.dart';

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _selectedBlockchain = 'Все';
  CourseDifficulty? _selectedDifficulty;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Обучение'),
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
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Курсы'),
            Tab(text: 'Мои курсы'),
            Tab(text: 'Челленджи'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCoursesTab(),
          _buildMyCoursesTab(),
          _buildChallengesTab(),
        ],
      ),
    );
  }

  // Вкладка курсов
  Widget _buildCoursesTab() {
    return Consumer<LearningProvider>(
      builder: (context, learningProvider, child) {
        if (learningProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredCourses = learningProvider.courses;

        // Фильтрация по блокчейну
        if (_selectedBlockchain != 'Все') {
          filteredCourses = filteredCourses
              .where((course) => course.blockchain == _selectedBlockchain)
              .toList();
        }

        // Фильтрация по сложности
        if (_selectedDifficulty != null) {
          filteredCourses = filteredCourses
              .where((course) => course.difficulty == _selectedDifficulty)
              .toList();
        }

        if (filteredCourses.isEmpty) {
          return _buildEmptyState('Курсы не найдены', 'Попробуйте изменить фильтры');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredCourses.length,
          itemBuilder: (context, index) {
            final course = filteredCourses[index];
            return _buildCourseCard(course, learningProvider)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Вкладка моих курсов
  Widget _buildMyCoursesTab() {
    return Consumer<LearningProvider>(
      builder: (context, learningProvider, child) {
        final enrolledCourses = learningProvider.userProgress.values
            .where((progress) => progress.status != CourseStatus.notEnrolled)
            .toList();

        if (enrolledCourses.isEmpty) {
          return _buildEmptyState(
            'Вы не записаны на курсы',
            'Выберите интересующие курсы и начните обучение',
            actionButton: ElevatedButton(
              onPressed: () => _tabController.animateTo(0),
              child: const Text('Перейти к курсам'),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: enrolledCourses.length,
          itemBuilder: (context, index) {
            final progress = enrolledCourses[index];
            final course = learningProvider.getCourseById(progress.courseId);
            if (course == null) return const SizedBox.shrink();

            return _buildEnrolledCourseCard(course, progress, learningProvider)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Вкладка челленджей
  Widget _buildChallengesTab() {
    return Consumer<LearningProvider>(
      builder: (context, learningProvider, child) {
        final challenges = learningProvider.challenges;

        if (challenges.isEmpty) {
          return _buildEmptyState('Челленджи не найдены', 'Попробуйте позже');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
            final course = learningProvider.getCourseById(challenge.courseId);
            if (course == null) return const SizedBox.shrink();

            return _buildChallengeCard(challenge, course, learningProvider)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Карточка курса
  Widget _buildCourseCard(Course course, LearningProvider provider) {
    final progress = provider.getUserProgress(course.id);
    final isEnrolled = progress != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showCourseDetails(course, provider),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и рейтинг
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(course.difficulty),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getDifficultyText(course.difficulty),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  
                  // Метаданные курса
                  Row(
                    children: [
                      _buildCourseMeta(Icons.block, course.blockchain),
                      const SizedBox(width: 16),
                      _buildCourseMeta(Icons.access_time, '${course.durationHours}ч'),
                      const SizedBox(width: 16),
                      _buildCourseMeta(Icons.people, '${course.studentsCount}'),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            course.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Кнопки действий
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showCourseDetails(course, provider),
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Подробнее'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isEnrolled 
                          ? () => _continueCourse(course, provider)
                          : () => _enrollInCourse(course, provider),
                      icon: Icon(isEnrolled ? Icons.play_arrow : Icons.school),
                      label: Text(isEnrolled ? 'Продолжить' : 'Записаться'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Карточка записанного курса
  Widget _buildEnrolledCourseCard(Course course, UserProgress progress, LearningProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showCourseDetails(course, provider),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(progress.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(progress.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Прогресс бар
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Прогресс: ${(progress.progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        '${progress.totalPoints} очков',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress.progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Кнопки действий
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showCourseDetails(course, provider),
                      icon: const Icon(Icons.info_outline),
                      label: const Text('Детали'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _continueCourse(course, provider),
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Продолжить'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Карточка челленджа
  Widget _buildChallengeCard(Challenge challenge, Course course, LearningProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showChallengeDetails(challenge, course, provider),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      challenge.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${challenge.points} очков',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                challenge.description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  _buildCourseMeta(Icons.school, course.title),
                  const SizedBox(width: 16),
                  _buildCourseMeta(Icons.timer, '${challenge.timeLimit.inHours}ч'),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _showChallengeDetails(challenge, course, provider),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Начать'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Метаданные курса
  Widget _buildCourseMeta(IconData icon, String text) {
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
            Icons.school_outlined,
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
        title: const Text('Поиск курсов'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Поиск по названию, описанию или блокчейну',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            // В реальном приложении здесь будет поиск
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
              // Применить поиск
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
            // Фильтр по блокчейну
            DropdownButtonFormField<String>(
              value: _selectedBlockchain,
              decoration: const InputDecoration(
                labelText: 'Блокчейн',
                border: OutlineInputBorder(),
              ),
              items: ['Все', 'Solana', 'Polkadot', 'Polygon', 'Tezos']
                  .map((blockchain) => DropdownMenuItem(
                        value: blockchain,
                        child: Text(blockchain),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBlockchain = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Фильтр по сложности
            DropdownButtonFormField<CourseDifficulty?>(
              value: _selectedDifficulty,
              decoration: const InputDecoration(
                labelText: 'Сложность',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Любая'),
                ),
                ...CourseDifficulty.values.map((difficulty) => DropdownMenuItem(
                      value: difficulty,
                      child: Text(_getDifficultyText(difficulty)),
                    )),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedBlockchain = 'Все';
                _selectedDifficulty = null;
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

  // Показать детали курса
  void _showCourseDetails(Course course, LearningProvider provider) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CourseDetailsScreen(course: course),
      ),
    );
  }

  // Записаться на курс
  void _enrollInCourse(Course course, LearningProvider provider) {
    provider.enrollInCourse(course.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы записались на курс "${course.title}"'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Продолжить курс
  void _continueCourse(Course course, LearningProvider provider) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CourseDetailsScreen(course: course),
      ),
    );
  }

  // Показать детали челленджа
  void _showChallengeDetails(Challenge challenge, Course course, LearningProvider provider) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChallengeDetailsScreen(challenge: challenge, course: course),
      ),
    );
  }

  // Получение цвета сложности
  Color _getDifficultyColor(CourseDifficulty difficulty) {
    switch (difficulty) {
      case CourseDifficulty.beginner:
        return Colors.green;
      case CourseDifficulty.intermediate:
        return Colors.orange;
      case CourseDifficulty.advanced:
        return Colors.red;
      case CourseDifficulty.expert:
        return Colors.purple;
    }
  }

  // Получение текста сложности
  String _getDifficultyText(CourseDifficulty difficulty) {
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

  // Получение цвета статуса
  Color _getStatusColor(CourseStatus status) {
    switch (status) {
      case CourseStatus.notEnrolled:
        return Colors.grey;
      case CourseStatus.enrolled:
        return Colors.blue;
      case CourseStatus.inProgress:
        return Colors.orange;
      case CourseStatus.completed:
        return Colors.green;
      case CourseStatus.certified:
        return Colors.purple;
    }
  }

  // Получение текста статуса
  String _getStatusText(CourseStatus status) {
    switch (status) {
      case CourseStatus.notEnrolled:
        return 'Не записан';
      case CourseStatus.enrolled:
        return 'Записан';
      case CourseStatus.inProgress:
        return 'В процессе';
      case CourseStatus.completed:
        return 'Завершен';
      case CourseStatus.certified:
        return 'Сертифицирован';
    }
  }
}


