import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/learning_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/screens/challenge_details_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;
  
  const CourseDetailsScreen({super.key, required this.course});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isEnrolled = false;
  UserProgress? _userProgress;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkEnrollmentStatus();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkEnrollmentStatus() {
    final learningProvider = context.read<LearningProvider>();
    _userProgress = learningProvider.getUserProgress(widget.course.id);
    setState(() {
      _isEnrolled = _userProgress != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar с изображением курса
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.course.title,
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
              background: Container(
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
                child: Stack(
                  children: [
                    // Фоновое изображение или иконка
                    Positioned.fill(
                      child: Icon(
                        Icons.school,
                        size: 120,
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    // Информация о курсе
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
                                  color: _getDifficultyColor(widget.course.difficulty),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  _getDifficultyText(widget.course.difficulty),
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
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.course.rating.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
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
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareCourse(),
              ),
            ],
          ),
          
          // Содержимое курса
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Основная информация о курсе
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Описание
                      Text(
                        widget.course.description,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Статистика курса
                      _buildCourseStats(),
                      const SizedBox(height: 24),
                      
                      // Кнопка записи/продолжения
                      _buildEnrollmentButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                
                // Табы с содержимым курса
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
                          Tab(text: 'Уроки'),
                          Tab(text: 'Челленджи'),
                          Tab(text: 'Прогресс'),
                        ],
                      ),
                      Container(
                        height: 400, // Фиксированная высота для TabBarView
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildOverviewTab(),
                            _buildLessonsTab(),
                            _buildChallengesTab(),
                            _buildProgressTab(),
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

  // Статистика курса
  Widget _buildCourseStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            Icons.access_time,
            'Длительность',
            '${widget.course.durationHours} часов',
          ),
        ),
        Expanded(
          child: _buildStatItem(
            Icons.people,
            'Студентов',
            '${widget.course.studentsCount}',
          ),
        ),
        Expanded(
          child: _buildStatItem(
            Icons.block,
            'Блокчейн',
            widget.course.blockchain,
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

  // Кнопка записи/продолжения
  Widget _buildEnrollmentButton() {
    if (_isEnrolled) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _continueLearning(),
          icon: const Icon(Icons.play_arrow),
          label: const Text('Продолжить обучение'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _enrollInCourse(),
          icon: const Icon(Icons.school),
          label: const Text('Записаться на курс'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }
  }

  // Вкладка обзора
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Инструктор
          _buildSection(
            'Инструктор',
            Icons.person,
            widget.course.instructor,
          ),
          
          const SizedBox(height: 24),
          
          // Темы курса
          _buildSection(
            'Темы курса',
            Icons.topic,
            null,
            content: Column(
              children: widget.course.topics.map((topic) => 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text(topic)),
                    ],
                  ),
                ),
              ).toList(),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Предварительные требования
          if (widget.course.prerequisites.isNotEmpty)
            _buildSection(
              'Предварительные требования',
              Icons.assignment,
              null,
              content: Column(
                children: widget.course.prerequisites.map((prereq) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue, size: 20),
                        const SizedBox(width: 12),
                        Expanded(child: Text(prereq)),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ),
        ],
      ),
    );
  }

  // Вкладка уроков
  Widget _buildLessonsTab() {
    // Заглушка для уроков
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Уроки курса',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Здесь будут отображаться уроки курса',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Вкладка челленджей
  Widget _buildChallengesTab() {
    return Consumer<LearningProvider>(
      builder: (context, learningProvider, child) {
        final challenges = learningProvider.getChallengesForCourse(widget.course.id);
        
        if (challenges.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Челленджи не найдены',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Для этого курса пока нет челленджей',
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: challenges.length,
          itemBuilder: (context, index) {
            final challenge = challenges[index];
            return _buildChallengeItem(challenge);
          },
        );
      },
    );
  }

  // Вкладка прогресса
  Widget _buildProgressTab() {
    if (!_isEnrolled) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.trending_up_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Запишитесь на курс',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Чтобы отслеживать прогресс, запишитесь на курс',
              style: TextStyle(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Общий прогресс
          _buildProgressCard(
            'Общий прогресс',
            _userProgress?.progress ?? 0.0,
            '${(_userProgress?.progress ?? 0.0) * 100}%',
          ),
          
          const SizedBox(height: 24),
          
          // Очки
          _buildProgressCard(
            'Заработанные очки',
            (_userProgress?.totalPoints ?? 0) / 1000, // Нормализуем к 0-1
            '${_userProgress?.totalPoints ?? 0} очков',
          ),
          
          const SizedBox(height: 24),
          
          // Завершенные челленджи
          _buildProgressCard(
            'Завершенные челленджи',
            (_userProgress?.completedChallenges.length ?? 0) / 10, // Нормализуем к 0-1
            '${_userProgress?.completedChallenges.length ?? 0} из 10',
          ),
        ],
      ),
    );
  }

  // Карточка прогресса
  Widget _buildProgressCard(String title, double progress, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Элемент челленджа
  Widget _buildChallengeItem(Challenge challenge) {
    final isCompleted = _userProgress?.completedChallenges.contains(challenge.id) ?? false;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isCompleted ? Colors.green : AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isCompleted ? Icons.check : Icons.emoji_events,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          challenge.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${challenge.timeLimit.inHours}ч',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.stars, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  '${challenge.points} очков',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: isCompleted ? null : () => _startChallenge(challenge),
          child: Text(isCompleted ? 'Завершено' : 'Начать'),
        ),
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
  void _enrollInCourse() {
    final learningProvider = context.read<LearningProvider>();
    learningProvider.enrollInCourse(widget.course.id);
    setState(() {
      _isEnrolled = true;
      _checkEnrollmentStatus();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Вы записались на курс "${widget.course.title}"'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _continueLearning() {
    // Переход к первому уроку или челленджу
    _tabController.animateTo(1); // Переход к вкладке уроков
  }

  void _startChallenge(Challenge challenge) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChallengeDetailsScreen(
          challenge: challenge,
          course: widget.course,
        ),
      ),
    );
  }

  void _shareCourse() {
    // Заглушка для шаринга
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция шаринга будет добавлена позже'),
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
}
