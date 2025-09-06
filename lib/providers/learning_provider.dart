import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum CourseDifficulty {
  beginner,
  intermediate,
  advanced,
  expert,
}

enum ChallengeStatus {
  notStarted,
  inProgress,
  completed,
  failed,
}

enum CourseStatus {
  notEnrolled,
  enrolled,
  inProgress,
  completed,
  certified,
}

class Course {
  final String id;
  final String title;
  final String description;
  final String blockchain; // Solana, Polkadot, Polygon, etc.
  final CourseDifficulty difficulty;
  final int durationHours;
  final List<String> topics;
  final String instructor;
  final double rating;
  final int studentsCount;
  final String? imageUrl;
  final List<String> prerequisites;
  final Map<String, dynamic> metadata;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.blockchain,
    required this.difficulty,
    required this.durationHours,
    required this.topics,
    required this.instructor,
    this.rating = 0.0,
    this.studentsCount = 0,
    this.imageUrl,
    this.prerequisites = const [],
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'blockchain': blockchain,
      'difficulty': difficulty.index,
      'durationHours': durationHours,
      'topics': topics,
      'instructor': instructor,
      'rating': rating,
      'studentsCount': studentsCount,
      'imageUrl': imageUrl,
      'prerequisites': prerequisites,
      'metadata': metadata,
    };
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      blockchain: json['blockchain'],
      difficulty: CourseDifficulty.values[json['difficulty']],
      durationHours: json['durationHours'],
      topics: List<String>.from(json['topics']),
      instructor: json['instructor'],
      rating: json['rating']?.toDouble() ?? 0.0,
      studentsCount: json['studentsCount'] ?? 0,
      imageUrl: json['imageUrl'],
      prerequisites: List<String>.from(json['prerequisites'] ?? []),
      metadata: json['metadata'] ?? {},
    );
  }
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final int points;
  final Duration timeLimit;
  final List<String> requirements;
  final String? starterCode;
  final String? solution;
  final Map<String, dynamic> metadata;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    required this.points,
    required this.timeLimit,
    required this.requirements,
    this.starterCode,
    this.solution,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'courseId': courseId,
      'points': points,
      'timeLimit': timeLimit.inMinutes,
      'requirements': requirements,
      'starterCode': starterCode,
      'solution': solution,
      'metadata': metadata,
    };
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      courseId: json['courseId'],
      points: json['points'],
      timeLimit: Duration(minutes: json['timeLimit']),
      requirements: List<String>.from(json['requirements']),
      starterCode: json['starterCode'],
      solution: json['solution'],
      metadata: json['metadata'] ?? {},
    );
  }
}

class UserProgress {
  final String userId;
  final String courseId;
  final CourseStatus status;
  final double progress; // 0.0 to 1.0
  final DateTime? startDate;
  final DateTime? completionDate;
  final List<String> completedChallenges;
  final int totalPoints;
  final Map<String, ChallengeStatus> challengeStatuses;

  UserProgress({
    required this.userId,
    required this.courseId,
    this.status = CourseStatus.notEnrolled,
    this.progress = 0.0,
    this.startDate,
    this.completionDate,
    this.completedChallenges = const [],
    this.totalPoints = 0,
    this.challengeStatuses = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'courseId': courseId,
      'status': status.index,
      'progress': progress,
      'startDate': startDate?.toIso8601String(),
      'completionDate': completionDate?.toIso8601String(),
      'completedChallenges': completedChallenges,
      'totalPoints': totalPoints,
      'challengeStatuses': challengeStatuses.map((key, value) => 
          MapEntry(key, value.index)),
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'],
      courseId: json['courseId'],
      status: CourseStatus.values[json['status']],
      progress: json['progress']?.toDouble() ?? 0.0,
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate'])
          : null,
      completionDate: json['completionDate'] != null 
          ? DateTime.parse(json['completionDate'])
          : null,
      completedChallenges: List<String>.from(json['completedChallenges'] ?? []),
      totalPoints: json['totalPoints'] ?? 0,
      challengeStatuses: (json['challengeStatuses'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(key, ChallengeStatus.values[value])) ?? {},
    );
  }

  UserProgress copyWith({
    String? userId,
    String? courseId,
    CourseStatus? status,
    double? progress,
    DateTime? startDate,
    DateTime? completionDate,
    List<String>? completedChallenges,
    int? totalPoints,
    Map<String, ChallengeStatus>? challengeStatuses,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      courseId: courseId ?? this.courseId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      startDate: startDate ?? this.startDate,
      completionDate: completionDate ?? this.completionDate,
      completedChallenges: completedChallenges ?? this.completedChallenges,
      totalPoints: totalPoints ?? this.totalPoints,
      challengeStatuses: challengeStatuses ?? this.challengeStatuses,
    );
  }
}

class LearningProvider extends ChangeNotifier {
  List<Course> _courses = [];
  List<Challenge> _challenges = [];
  Map<String, UserProgress> _userProgress = {};
  String? _currentCourseId;
  bool _isLoading = false;
  String? _error;

  // Геттеры
  List<Course> get courses => _courses;
  List<Challenge> get challenges => _challenges;
  Map<String, UserProgress> get userProgress => _userProgress;
  String? get currentCourseId => _currentCourseId;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Получение курса по ID
  Course? getCourseById(String id) {
    try {
      return _courses.firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }

  // Получение челленджей для курса
  List<Challenge> getChallengesForCourse(String courseId) {
    return _challenges.where((challenge) => challenge.courseId == courseId).toList();
  }

  // Получение прогресса пользователя для курса
  UserProgress? getUserProgress(String courseId) {
    return _userProgress[courseId];
  }

  // Получение курсов по блокчейну
  List<Course> getCoursesByBlockchain(String blockchain) {
    return _courses.where((course) => course.blockchain == blockchain).toList();
  }

  // Получение курсов по сложности
  List<Course> getCoursesByDifficulty(CourseDifficulty difficulty) {
    return _courses.where((course) => course.difficulty == difficulty).toList();
  }

  LearningProvider() {
    _loadLearningData();
    _createDemoCourses();
  }

  // Загрузка данных обучения
  Future<void> _loadLearningData() async {
    try {
      _isLoading = true;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      
      // Загрузка курсов
      final coursesJson = prefs.getStringList('learning_courses') ?? [];
      _courses = coursesJson
          .map((json) => Course.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка челленджей
      final challengesJson = prefs.getStringList('learning_challenges') ?? [];
      _challenges = challengesJson
          .map((json) => Challenge.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка прогресса пользователя
      final progressJson = prefs.getString('learning_user_progress') ?? '{}';
      final progressMap = jsonDecode(progressJson) as Map<String, dynamic>;
      
      _userProgress = progressMap.map((courseId, progressJson) {
        final progress = UserProgress.fromJson(progressJson);
        return MapEntry(courseId, progress);
      });
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Ошибка загрузки данных обучения: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Сохранение данных обучения
  Future<void> _saveLearningData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Сохранение курсов
      final coursesJson = _courses
          .map((course) => jsonEncode(course.toJson()))
          .toList();
      await prefs.setStringList('learning_courses', coursesJson);
      
      // Сохранение челленджей
      final challengesJson = _challenges
          .map((challenge) => jsonEncode(challenge.toJson()))
          .toList();
      await prefs.setStringList('learning_challenges', challengesJson);
      
      // Сохранение прогресса пользователя
      final progressMap = _userProgress.map((courseId, progress) {
        return MapEntry(courseId, progress.toJson());
      });
      await prefs.setString('learning_user_progress', jsonEncode(progressMap));
    } catch (e) {
      _error = 'Ошибка сохранения данных обучения: $e';
      notifyListeners();
    }
  }

  // Создание демо курсов (основано на TanechFund)
  void _createDemoCourses() {
    if (_courses.isEmpty) {
      _courses = [
        Course(
          id: 'solana_basics',
          title: 'Intro to Solana',
          description: 'Изучите основы Solana блокчейна, создание смарт-контрактов на Rust и разработку dApps',
          blockchain: 'Solana',
          difficulty: CourseDifficulty.beginner,
          durationHours: 20,
          topics: ['Rust Basics', 'Solana Architecture', 'Smart Contracts', 'dApp Development'],
          instructor: 'Dr. Alex Chen',
          rating: 4.8,
          studentsCount: 15420,
          prerequisites: [],
        ),
        Course(
          id: 'polkadot_advanced',
          title: 'Polkadot Parachain Development',
          description: 'Продвинутый курс по разработке парачейнов в экосистеме Polkadot',
          blockchain: 'Polkadot',
          difficulty: CourseDifficulty.advanced,
          durationHours: 35,
          topics: ['Substrate Framework', 'Parachain Development', 'Cross-chain Communication', 'Governance'],
          instructor: 'Prof. Sarah Johnson',
          rating: 4.9,
          studentsCount: 8230,
          prerequisites: ['blockchain_basics', 'rust_intermediate'],
        ),
        Course(
          id: 'polygon_defi',
          title: 'DeFi Protocol Development on Polygon',
          description: 'Создание DeFi протоколов на Polygon с использованием Solidity',
          blockchain: 'Polygon',
          difficulty: CourseDifficulty.intermediate,
          durationHours: 25,
          topics: ['Solidity', 'DeFi Protocols', 'Liquidity Pools', 'Yield Farming'],
          instructor: 'Mike Rodriguez',
          rating: 4.7,
          studentsCount: 11200,
          prerequisites: ['ethereum_basics', 'solidity_basics'],
        ),
        Course(
          id: 'tezos_smart_contracts',
          title: 'Tezos Smart Contracts with Michelson',
          description: 'Разработка смарт-контрактов на Tezos с использованием Michelson',
          blockchain: 'Tezos',
          difficulty: CourseDifficulty.intermediate,
          durationHours: 18,
          topics: ['Michelson Language', 'Tezos Architecture', 'Smart Contracts', 'Formal Verification'],
          instructor: 'Dr. Elena Petrova',
          rating: 4.6,
          studentsCount: 5670,
          prerequisites: ['blockchain_basics'],
        ),
      ];

      // Создание демо челленджей
      _createDemoChallenges();
      
      _saveLearningData();
      notifyListeners();
    }
  }

  // Создание демо челленджей
  void _createDemoChallenges() {
    if (_challenges.isEmpty) {
      _challenges = [
        Challenge(
          id: 'solana_hello_world',
          title: 'Hello World Smart Contract',
          description: 'Создайте простой смарт-контракт на Solana, который выводит "Hello World"',
          courseId: 'solana_basics',
          points: 100,
          timeLimit: const Duration(hours: 2),
          requirements: [
            'Используйте Rust',
            'Используйте Solana Program Framework',
            'Контракт должен выводить "Hello World"',
            'Добавьте тесты'
          ],
          starterCode: '''
use solana_program::{
    account_info::AccountInfo,
    entrypoint,
    pubkey::Pubkey,
    msg,
};

entrypoint!(process_instruction);

pub fn process_instruction(
    program_id: &Pubkey,
    accounts: &[AccountInfo],
    instruction_data: &[u8],
) -> ProgramResult {
    // TODO: Implement your logic here
    
    Ok(())
}
          ''',
        ),
        Challenge(
          id: 'polkadot_parachain',
          title: 'Custom Parachain',
          description: 'Создайте кастомный парачейн с использованием Substrate Framework',
          courseId: 'polkadot_advanced',
          points: 250,
          timeLimit: const Duration(hours: 6),
          requirements: [
            'Используйте Substrate Framework',
            'Добавьте кастомную палетту',
            'Реализуйте cross-chain transfer',
            'Добавьте governance механизм'
          ],
        ),
        Challenge(
          id: 'polygon_liquidity_pool',
          title: 'Liquidity Pool Contract',
          description: 'Создайте контракт ликвидности для DeFi протокола',
          courseId: 'polygon_defi',
          points: 200,
          timeLimit: const Duration(hours: 4),
          requirements: [
            'Используйте Solidity',
            'Реализуйте add/remove liquidity',
            'Добавьте swap функционал',
            'Включите fee механизм'
          ],
        ),
      ];
    }
  }

  // Запись на курс
  Future<void> enrollInCourse(String courseId) async {
    if (_userProgress.containsKey(courseId)) return;

    final progress = UserProgress(
      userId: 'user_001', // В реальном приложении из AuthProvider
      courseId: courseId,
      status: CourseStatus.enrolled,
      startDate: DateTime.now(),
    );

    _userProgress[courseId] = progress;
    await _saveLearningData();
    notifyListeners();
  }

  // Отмена записи на курс
  Future<void> unenrollFromCourse(String courseId) async {
    _userProgress.remove(courseId);
    await _saveLearningData();
    notifyListeners();
  }

  // Обновление прогресса курса
  Future<void> updateCourseProgress(String courseId, double progress) async {
    final userProgress = _userProgress[courseId];
    if (userProgress == null) return;

    final updatedProgress = userProgress.copyWith(
      progress: progress,
      status: progress >= 1.0 ? CourseStatus.completed : CourseStatus.inProgress,
      completionDate: progress >= 1.0 ? DateTime.now() : null,
    );

    _userProgress[courseId] = updatedProgress;
    await _saveLearningData();
    notifyListeners();
  }

  // Завершение челленджа
  Future<void> completeChallenge(String courseId, String challengeId) async {
    final userProgress = _userProgress[courseId];
    if (userProgress == null) return;

    final challenge = _challenges.firstWhere((c) => c.id == challengeId);
    final updatedChallengeStatuses = Map<String, ChallengeStatus>.from(userProgress.challengeStatuses);
    updatedChallengeStatuses[challengeId] = ChallengeStatus.completed;

    final updatedProgress = userProgress.copyWith(
      completedChallenges: [...userProgress.completedChallenges, challengeId],
      totalPoints: userProgress.totalPoints + challenge.points,
      challengeStatuses: updatedChallengeStatuses,
    );

    _userProgress[courseId] = updatedProgress;
    
    // Обновление общего прогресса курса
    final totalChallenges = _challenges.where((c) => c.courseId == courseId).length;
    final completedChallenges = updatedProgress.completedChallenges.length;
    final courseProgress = completedChallenges / totalChallenges;
    
    await updateCourseProgress(courseId, courseProgress);
  }

  // Поиск курсов
  List<Course> searchCourses(String query) {
    if (query.isEmpty) return _courses;
    
    return _courses.where((course) =>
        course.title.toLowerCase().contains(query.toLowerCase()) ||
        course.description.toLowerCase().contains(query.toLowerCase()) ||
        course.blockchain.toLowerCase().contains(query.toLowerCase()) ||
        course.topics.any((topic) => topic.toLowerCase().contains(query.toLowerCase()))
    ).toList();
  }

  // Получение топ курсов
  List<Course> getTopCourses({int limit = 10}) {
    final sortedCourses = List<Course>.from(_courses);
    sortedCourses.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedCourses.take(limit).toList();
  }

  // Получение курсов по рейтингу
  List<Course> getCoursesByRating(double minRating) {
    return _courses.where((course) => course.rating >= minRating).toList();
  }

  // Очистка ошибки
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
