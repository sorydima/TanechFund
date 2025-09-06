import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Course Category
enum CourseCategory {
  blockchain,
  defi,
  nft,
  smart_contracts,
  web3_identity,
  metaverse,
  gaming,
  trading,
  security,
  governance,
}

// Lesson Type
enum LessonType {
  video,
  text,
  interactive,
  quiz,
  coding,
  project,
}

// Achievement Type
enum AchievementType {
  course_completion,
  lesson_completion,
  quiz_perfect_score,
  streak_days,
  mentor_help,
  community_contribution,
  skill_verification,
}

// Course Difficulty
enum CourseDifficulty {
  beginner,
  intermediate,
  advanced,
  expert,
}

// Course
class Course {
  final String id;
  final String title;
  final String description;
  final CourseCategory category;
  final CourseDifficulty difficulty;
  final String imageUrl;
  final List<String> instructors;
  final int totalLessons;
  final int completedLessons;
  final double rating;
  final int totalStudents;
  final int totalReviews;
  final List<String> prerequisites;
  final List<String> skills;
  final Map<String, dynamic> metadata;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isPublished;
  final bool isFree;
  final double price;
  final String currency;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.imageUrl,
    required this.instructors,
    required this.totalLessons,
    required this.completedLessons,
    required this.rating,
    required this.totalStudents,
    required this.totalReviews,
    required this.prerequisites,
    required this.skills,
    required this.metadata,
    required this.createdAt,
    this.updatedAt,
    required this.isPublished,
    required this.isFree,
    required this.price,
    required this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.name,
      'difficulty': difficulty.name,
      'imageUrl': imageUrl,
      'instructors': instructors,
      'totalLessons': totalLessons,
      'completedLessons': completedLessons,
      'rating': rating,
      'totalStudents': totalStudents,
      'totalReviews': totalReviews,
      'prerequisites': prerequisites,
      'skills': skills,
      'metadata': metadata,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isPublished': isPublished,
      'isFree': isFree,
      'price': price,
      'currency': currency,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: CourseCategory.values.firstWhere((e) => e.name == json['category']),
      difficulty: CourseDifficulty.values.firstWhere((e) => e.name == json['difficulty']),
      imageUrl: json['imageUrl'],
      instructors: List<String>.from(json['instructors']),
      totalLessons: json['totalLessons'],
      completedLessons: json['completedLessons'],
      rating: json['rating'].toDouble(),
      totalStudents: json['totalStudents'],
      totalReviews: json['totalReviews'],
      prerequisites: List<String>.from(json['prerequisites']),
      skills: List<String>.from(json['skills']),
      metadata: Map<String, dynamic>.from(json['metadata']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      isPublished: json['isPublished'],
      isFree: json['isFree'],
      price: json['price'].toDouble(),
      currency: json['currency'],
    );
  }

  Course copyWith({
    String? id,
    String? title,
    String? description,
    CourseCategory? category,
    CourseDifficulty? difficulty,
    String? imageUrl,
    List<String>? instructors,
    int? totalLessons,
    int? completedLessons,
    double? rating,
    int? totalStudents,
    int? totalReviews,
    List<String>? prerequisites,
    List<String>? skills,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
    bool? isFree,
    double? price,
    String? currency,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      imageUrl: imageUrl ?? this.imageUrl,
      instructors: instructors ?? this.instructors,
      totalLessons: totalLessons ?? this.totalLessons,
      completedLessons: completedLessons ?? this.completedLessons,
      rating: rating ?? this.rating,
      totalStudents: totalStudents ?? this.totalStudents,
      totalReviews: totalReviews ?? this.totalReviews,
      prerequisites: prerequisites ?? this.prerequisites,
      skills: skills ?? this.skills,
      metadata: metadata ?? this.metadata,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
      isFree: isFree ?? this.isFree,
      price: price ?? this.price,
      currency: currency ?? this.currency,
    );
  }
}

// Lesson
class Lesson {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final LessonType type;
  final String content;
  final int duration; // in minutes
  final List<String> resources;
  final List<String> tags;
  final int order;
  final bool isCompleted;
  final DateTime? completedAt;
  final Map<String, dynamic> metadata;

  Lesson({
    required this.id,
    required this.courseId,
    required this.title,
    required this.description,
    required this.type,
    required this.content,
    required this.duration,
    required this.resources,
    required this.tags,
    required this.order,
    required this.isCompleted,
    this.completedAt,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'title': title,
      'description': description,
      'type': type.name,
      'content': content,
      'duration': duration,
      'resources': resources,
      'tags': tags,
      'order': order,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      courseId: json['courseId'],
      title: json['title'],
      description: json['description'],
      type: LessonType.values.firstWhere((e) => e.name == json['type']),
      content: json['content'],
      duration: json['duration'],
      resources: List<String>.from(json['resources']),
      tags: List<String>.from(json['tags']),
      order: json['order'],
      isCompleted: json['isCompleted'],
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Lesson copyWith({
    String? id,
    String? courseId,
    String? title,
    String? description,
    LessonType? type,
    String? content,
    int? duration,
    List<String>? resources,
    List<String>? tags,
    int? order,
    bool? isCompleted,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Lesson(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      content: content ?? this.content,
      duration: duration ?? this.duration,
      resources: resources ?? this.resources,
      tags: tags ?? this.tags,
      order: order ?? this.order,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Quiz
class Quiz {
  final String id;
  final String lessonId;
  final String title;
  final String description;
  final List<QuizQuestion> questions;
  final int timeLimit; // in minutes
  final int passingScore;
  final bool isCompleted;
  final int? score;
  final DateTime? completedAt;

  Quiz({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.description,
    required this.questions,
    required this.timeLimit,
    required this.passingScore,
    required this.isCompleted,
    this.score,
    this.completedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lessonId': lessonId,
      'title': title,
      'description': description,
      'questions': questions.map((q) => q.toJson()).toList(),
      'timeLimit': timeLimit,
      'passingScore': passingScore,
      'isCompleted': isCompleted,
      'score': score,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      lessonId: json['lessonId'],
      title: json['title'],
      description: json['description'],
      questions: (json['questions'] as List).map((q) => QuizQuestion.fromJson(q)).toList(),
      timeLimit: json['timeLimit'],
      passingScore: json['passingScore'],
      isCompleted: json['isCompleted'],
      score: json['score'],
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }

  Quiz copyWith({
    String? id,
    String? lessonId,
    String? title,
    String? description,
    List<QuizQuestion>? questions,
    int? timeLimit,
    int? passingScore,
    bool? isCompleted,
    int? score,
    DateTime? completedAt,
  }) {
    return Quiz(
      id: id ?? this.id,
      lessonId: lessonId ?? this.lessonId,
      title: title ?? this.title,
      description: description ?? this.description,
      questions: questions ?? this.questions,
      timeLimit: timeLimit ?? this.timeLimit,
      passingScore: passingScore ?? this.passingScore,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

// Quiz Question
class QuizQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
    };
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
    );
  }
}

// Achievement
class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementType type;
  final String imageUrl;
  final int points;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final Map<String, dynamic> metadata;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.imageUrl,
    required this.points,
    required this.isUnlocked,
    this.unlockedAt,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'imageUrl': imageUrl,
      'points': points,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: AchievementType.values.firstWhere((e) => e.name == json['type']),
      imageUrl: json['imageUrl'],
      points: json['points'],
      isUnlocked: json['isUnlocked'],
      unlockedAt: json['unlockedAt'] != null ? DateTime.parse(json['unlockedAt']) : null,
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    AchievementType? type,
    String? imageUrl,
    int? points,
    bool? isUnlocked,
    DateTime? unlockedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      points: points ?? this.points,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Learning Progress
class LearningProgress {
  final String id;
  final String userId;
  final String courseId;
  final int completedLessons;
  final int totalLessons;
  final double progress; // percentage
  final DateTime startedAt;
  final DateTime? lastActivityAt;
  final DateTime? completedAt;
  final Map<String, dynamic> metadata;

  LearningProgress({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.completedLessons,
    required this.totalLessons,
    required this.progress,
    required this.startedAt,
    this.lastActivityAt,
    this.completedAt,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'courseId': courseId,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'progress': progress,
      'startedAt': startedAt.toIso8601String(),
      'lastActivityAt': lastActivityAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory LearningProgress.fromJson(Map<String, dynamic> json) {
    return LearningProgress(
      id: json['id'],
      userId: json['userId'],
      courseId: json['courseId'],
      completedLessons: json['completedLessons'],
      totalLessons: json['totalLessons'],
      progress: json['progress'].toDouble(),
      startedAt: DateTime.parse(json['startedAt']),
      lastActivityAt: json['lastActivityAt'] != null ? DateTime.parse(json['lastActivityAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  LearningProgress copyWith({
    String? id,
    String? userId,
    String? courseId,
    int? completedLessons,
    int? totalLessons,
    double? progress,
    DateTime? startedAt,
    DateTime? lastActivityAt,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) {
    return LearningProgress(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      completedLessons: completedLessons ?? this.completedLessons,
      totalLessons: totalLessons ?? this.totalLessons,
      progress: progress ?? this.progress,
      startedAt: startedAt ?? this.startedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Web3 Education Provider
class Web3EducationProvider extends ChangeNotifier {
  List<Course> _courses = [];
  List<Lesson> _lessons = [];
  List<Quiz> _quizzes = [];
  List<Achievement> _achievements = [];
  List<LearningProgress> _learningProgress = [];
  String _currentUserId = 'current_user';

  // Getters
  List<Course> get courses => _courses;
  List<Lesson> get lessons => _lessons;
  List<Quiz> get quizzes => _quizzes;
  List<Achievement> get achievements => _achievements;
  List<LearningProgress> get learningProgress => _learningProgress;
  String get currentUserId => _currentUserId;

  List<Course> get publishedCourses => _courses.where((course) => course.isPublished).toList();
  List<Course> get freeCourses => _courses.where((course) => course.isFree).toList();
  List<Course> get userEnrolledCourses => _learningProgress
      .where((progress) => progress.userId == _currentUserId)
      .map((progress) => _courses.firstWhere((course) => course.id == progress.courseId))
      .toList();

  List<Lesson> getLessonsForCourse(String courseId) {
    return _lessons.where((lesson) => lesson.courseId == courseId).toList();
  }

  List<Quiz> getQuizzesForLesson(String lessonId) {
    return _quizzes.where((quiz) => quiz.lessonId == lessonId).toList();
  }

  List<Achievement> get userAchievements => _achievements
      .where((achievement) => achievement.isUnlocked)
      .toList();

  LearningProgress? getProgressForCourse(String courseId) {
    try {
      return _learningProgress.firstWhere(
        (progress) => progress.userId == _currentUserId && progress.courseId == courseId,
      );
    } catch (e) {
      return null;
    }
  }

  // Initialize
  Future<void> initialize() async {
    await _loadData();
    if (_courses.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final coursesJson = prefs.getString('web3_education_courses');
    if (coursesJson != null) {
      final coursesList = json.decode(coursesJson) as List;
      _courses = coursesList.map((json) => Course.fromJson(json)).toList();
    }

    final lessonsJson = prefs.getString('web3_education_lessons');
    if (lessonsJson != null) {
      final lessonsList = json.decode(lessonsJson) as List;
      _lessons = lessonsList.map((json) => Lesson.fromJson(json)).toList();
    }

    final quizzesJson = prefs.getString('web3_education_quizzes');
    if (quizzesJson != null) {
      final quizzesList = json.decode(quizzesJson) as List;
      _quizzes = quizzesList.map((json) => Quiz.fromJson(json)).toList();
    }

    final achievementsJson = prefs.getString('web3_education_achievements');
    if (achievementsJson != null) {
      final achievementsList = json.decode(achievementsJson) as List;
      _achievements = achievementsList.map((json) => Achievement.fromJson(json)).toList();
    }

    final progressJson = prefs.getString('web3_education_progress');
    if (progressJson != null) {
      final progressList = json.decode(progressJson) as List;
      _learningProgress = progressList.map((json) => LearningProgress.fromJson(json)).toList();
    }

    notifyListeners();
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('web3_education_courses', json.encode(_courses.map((c) => c.toJson()).toList()));
    await prefs.setString('web3_education_lessons', json.encode(_lessons.map((l) => l.toJson()).toList()));
    await prefs.setString('web3_education_quizzes', json.encode(_quizzes.map((q) => q.toJson()).toList()));
    await prefs.setString('web3_education_achievements', json.encode(_achievements.map((a) => a.toJson()).toList()));
    await prefs.setString('web3_education_progress', json.encode(_learningProgress.map((p) => p.toJson()).toList()));
  }

  // Create demo data
  void _createDemoData() {
    // Create demo courses
    final blockchainCourse = Course(
      id: 'blockchain_basics',
      title: 'Основы блокчейна',
      description: 'Изучите фундаментальные концепции блокчейна, включая децентрализацию, консенсус и криптографию.',
      category: CourseCategory.blockchain,
      difficulty: CourseDifficulty.beginner,
      imageUrl: 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Blockchain',
      instructors: ['Доктор Смирнов', 'Профессор Иванов'],
      totalLessons: 12,
      completedLessons: 0,
      rating: 4.8,
      totalStudents: 1250,
      totalReviews: 89,
      prerequisites: [],
      skills: ['Блокчейн', 'Криптография', 'Децентрализация'],
      metadata: {},
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      isPublished: true,
      isFree: true,
      price: 0.0,
      currency: 'USD',
    );

    final defiCourse = Course(
      id: 'defi_mastery',
      title: 'DeFi Мастерство',
      description: 'Освойте децентрализованные финансы: смарт-контракты, ликвидность, стейкинг и yield farming.',
      category: CourseCategory.defi,
      difficulty: CourseDifficulty.intermediate,
      imageUrl: 'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=DeFi',
      instructors: ['Алексей Петров', 'Мария Сидорова'],
      totalLessons: 18,
      completedLessons: 0,
      rating: 4.9,
      totalStudents: 890,
      totalReviews: 67,
      prerequisites: ['blockchain_basics'],
      skills: ['DeFi', 'Смарт-контракты', 'Yield Farming'],
      metadata: {},
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      isPublished: true,
      isFree: false,
      price: 99.99,
      currency: 'USD',
    );

    final nftCourse = Course(
      id: 'nft_creation',
      title: 'Создание NFT',
      description: 'Научитесь создавать, продавать и торговать NFT на различных блокчейн-платформах.',
      category: CourseCategory.nft,
      difficulty: CourseDifficulty.beginner,
      imageUrl: 'https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=NFT',
      instructors: ['Анна Козлова', 'Дмитрий Волков'],
      totalLessons: 15,
      completedLessons: 0,
      rating: 4.7,
      totalStudents: 2100,
      totalReviews: 156,
      prerequisites: ['blockchain_basics'],
      skills: ['NFT', 'Метаданные', 'IPFS'],
      metadata: {},
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      isPublished: true,
      isFree: false,
      price: 79.99,
      currency: 'USD',
    );

    _courses.addAll([blockchainCourse, defiCourse, nftCourse]);

    // Create demo lessons for blockchain course
    final lesson1 = Lesson(
      id: 'blockchain_lesson_1',
      courseId: 'blockchain_basics',
      title: 'Что такое блокчейн?',
      description: 'Введение в концепцию блокчейна и его основные принципы.',
      type: LessonType.video,
      content: 'https://example.com/video/blockchain-intro.mp4',
      duration: 15,
      resources: ['https://example.com/docs/blockchain-intro.pdf'],
      tags: ['блокчейн', 'введение', 'основы'],
      order: 1,
      isCompleted: false,
      metadata: {},
    );

    final lesson2 = Lesson(
      id: 'blockchain_lesson_2',
      courseId: 'blockchain_basics',
      title: 'Децентрализация',
      description: 'Понятие децентрализации и почему это важно для блокчейна.',
      type: LessonType.text,
      content: 'Децентрализация - это ключевая концепция блокчейна...',
      duration: 20,
      resources: ['https://example.com/docs/decentralization.pdf'],
      tags: ['децентрализация', 'архитектура'],
      order: 2,
      isCompleted: false,
      metadata: {},
    );

    _lessons.addAll([lesson1, lesson2]);

    // Create demo achievements
    final firstLessonAchievement = Achievement(
      id: 'first_lesson',
      title: 'Первый урок',
      description: 'Завершите свой первый урок',
      type: AchievementType.lesson_completion,
      imageUrl: 'https://via.placeholder.com/100x100/FFD700/000000?text=1',
      points: 10,
      isUnlocked: false,
      metadata: {},
    );

    final courseCompletionAchievement = Achievement(
      id: 'course_completion',
      title: 'Завершение курса',
      description: 'Завершите полный курс',
      type: AchievementType.course_completion,
      imageUrl: 'https://via.placeholder.com/100x100/4CAF50/FFFFFF?text=✓',
      points: 100,
      isUnlocked: false,
      metadata: {},
    );

    _achievements.addAll([firstLessonAchievement, courseCompletionAchievement]);

    _saveData();
  }

  // Course Management
  void createCourse(Course course) {
    _courses.add(course);
    _saveData();
    notifyListeners();
  }

  void updateCourse(String courseId, Course updatedCourse) {
    final index = _courses.indexWhere((course) => course.id == courseId);
    if (index != -1) {
      _courses[index] = updatedCourse;
      _saveData();
      notifyListeners();
    }
  }

  void deleteCourse(String courseId) {
    _courses.removeWhere((course) => course.id == courseId);
    _lessons.removeWhere((lesson) => lesson.courseId == courseId);
    _quizzes.removeWhere((quiz) => _lessons.any((lesson) => lesson.id == quiz.lessonId && lesson.courseId == courseId));
    _saveData();
    notifyListeners();
  }

  // Lesson Management
  void createLesson(Lesson lesson) {
    _lessons.add(lesson);
    _saveData();
    notifyListeners();
  }

  void updateLesson(String lessonId, Lesson updatedLesson) {
    final index = _lessons.indexWhere((lesson) => lesson.id == lessonId);
    if (index != -1) {
      _lessons[index] = updatedLesson;
      _saveData();
      notifyListeners();
    }
  }

  void deleteLesson(String lessonId) {
    _lessons.removeWhere((lesson) => lesson.id == lessonId);
    _quizzes.removeWhere((quiz) => quiz.lessonId == lessonId);
    _saveData();
    notifyListeners();
  }

  List<Lesson> getLessonsByCourse(String courseId) {
    return _lessons.where((lesson) => lesson.courseId == courseId).toList();
  }

  // Quiz Management
  void createQuiz(Quiz quiz) {
    _quizzes.add(quiz);
    _saveData();
    notifyListeners();
  }

  void updateQuiz(String quizId, Quiz updatedQuiz) {
    final index = _quizzes.indexWhere((quiz) => quiz.id == quizId);
    if (index != -1) {
      _quizzes[index] = updatedQuiz;
      _saveData();
      notifyListeners();
    }
  }

  void deleteQuiz(String quizId) {
    _quizzes.removeWhere((quiz) => quiz.id == quizId);
    _saveData();
    notifyListeners();
  }

  // Learning Progress Management
  void enrollInCourse(String courseId) {
    final course = _courses.firstWhere((c) => c.id == courseId);
    final existingProgress = getProgressForCourse(courseId);
    
    if (existingProgress == null) {
      final progress = LearningProgress(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: _currentUserId,
        courseId: courseId,
        completedLessons: 0,
        totalLessons: course.totalLessons,
        progress: 0.0,
        startedAt: DateTime.now(),
        metadata: {},
      );
      _learningProgress.add(progress);
      _saveData();
      notifyListeners();
    }
  }

  void completeLesson(String lessonId) {
    final lesson = _lessons.firstWhere((l) => l.id == lessonId);
    final progress = getProgressForCourse(lesson.courseId);
    
    if (progress != null) {
      final updatedProgress = progress.copyWith(
        completedLessons: progress.completedLessons + 1,
        progress: ((progress.completedLessons + 1) / progress.totalLessons) * 100,
        lastActivityAt: DateTime.now(),
      );
      
      final index = _learningProgress.indexWhere((p) => p.id == progress.id);
      if (index != -1) {
        _learningProgress[index] = updatedProgress;
      }

      // Update lesson completion status
      final lessonIndex = _lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex != -1) {
        _lessons[lessonIndex] = _lessons[lessonIndex].copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
        );
      }

      // Check for achievements
      _checkAchievements();

      _saveData();
      notifyListeners();
    }
  }

  void completeQuiz(String quizId, int score) {
    final quiz = _quizzes.firstWhere((q) => q.id == quizId);
    final quizIndex = _quizzes.indexWhere((q) => q.id == quizId);
    
    if (quizIndex != -1) {
      _quizzes[quizIndex] = _quizzes[quizIndex].copyWith(
        isCompleted: true,
        score: score,
        completedAt: DateTime.now(),
      );

      // Check for perfect score achievement
      if (score == 100) {
        _unlockAchievement('perfect_quiz');
      }

      _saveData();
      notifyListeners();
    }
  }

  // Achievement Management
  void _checkAchievements() {
    // Check first lesson achievement
    final completedLessons = _lessons.where((lesson) => lesson.isCompleted).length;
    if (completedLessons >= 1) {
      _unlockAchievement('first_lesson');
    }

    // Check course completion achievement
    final completedCourses = _learningProgress
        .where((progress) => progress.userId == _currentUserId && progress.progress >= 100)
        .length;
    if (completedCourses >= 1) {
      _unlockAchievement('course_completion');
    }
  }

  void _unlockAchievement(String achievementId) {
    final achievementIndex = _achievements.indexWhere((a) => a.id == achievementId);
    if (achievementIndex != -1 && !_achievements[achievementIndex].isUnlocked) {
      _achievements[achievementIndex] = _achievements[achievementIndex].copyWith(
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      _saveData();
      notifyListeners();
    }
  }

  // Search and Filter
  List<Course> searchCourses(String query) {
    if (query.isEmpty) return _courses;

    return _courses.where((course) =>
        course.title.toLowerCase().contains(query.toLowerCase()) ||
        course.description.toLowerCase().contains(query.toLowerCase()) ||
        course.skills.any((skill) => skill.toLowerCase().contains(query.toLowerCase()))).toList();
  }

  List<Course> getCoursesByCategory(CourseCategory category) {
    return _courses.where((course) => course.category == category).toList();
  }

  List<Course> getCoursesByDifficulty(CourseDifficulty difficulty) {
    return _courses.where((course) => course.difficulty == difficulty).toList();
  }

  List<Course> getRecommendedCourses() {
    // Simple recommendation algorithm based on user progress and ratings
    final userProgress = _learningProgress.where((p) => p.userId == _currentUserId).toList();
    final completedCategories = userProgress
        .map((p) => _courses.firstWhere((c) => c.id == p.courseId).category)
        .toSet();

    return _courses
        .where((course) => 
            course.isPublished && 
            !userProgress.any((p) => p.courseId == course.id) &&
            (completedCategories.contains(course.category) || course.difficulty == CourseDifficulty.beginner))
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
  }

  // Analytics
  double getUserTotalProgress() {
    final userProgress = _learningProgress.where((p) => p.userId == _currentUserId);
    if (userProgress.isEmpty) return 0.0;
    
    final totalProgress = userProgress.fold(0.0, (sum, progress) => sum + progress.progress);
    return totalProgress / userProgress.length;
  }

  int getUserTotalPoints() {
    return _achievements
        .where((a) => a.isUnlocked)
        .fold(0, (sum, achievement) => sum + achievement.points);
  }

  int getUserCompletedCourses() {
    return _learningProgress
        .where((p) => p.userId == _currentUserId && p.progress >= 100)
        .length;
  }

  int getUserCompletedLessons() {
    return _lessons
        .where((lesson) => lesson.isCompleted)
        .length;
  }

  // Utility methods
  String getCourseCategoryName(CourseCategory category) {
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

  String getCourseDifficultyName(CourseDifficulty difficulty) {
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

  String getLessonTypeName(LessonType type) {
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

  String getAchievementTypeName(AchievementType type) {
    switch (type) {
      case AchievementType.course_completion:
        return 'Завершение курса';
      case AchievementType.lesson_completion:
        return 'Завершение урока';
      case AchievementType.quiz_perfect_score:
        return 'Отличный результат теста';
      case AchievementType.streak_days:
        return 'Серия дней';
      case AchievementType.mentor_help:
        return 'Помощь ментора';
      case AchievementType.community_contribution:
        return 'Вклад в сообщество';
      case AchievementType.skill_verification:
        return 'Верификация навыков';
    }
  }
}
