import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Перечисления для системы менторства
enum MentorshipStatus {
  pending,
  active,
  completed,
  cancelled,
}

enum SessionType {
  individual,
  group,
  workshop,
  review,
}

enum SessionStatus {
  scheduled,
  completed,
  cancelled,
}

enum PlanLevel {
  beginner,
  intermediate,
  advanced,
  expert,
}

enum FeedbackRating {
  poor,
  fair,
  good,
  excellent,
}

// Модель ментора
class Mentor {
  final String id;
  final String name;
  final String title;
  final String company;
  final String bio;
  final List<String> expertise;
  final List<String> languages;
  final double rating;
  final int sessionsCompleted;
  final int yearsExperience;
  final String avatarUrl;
  final bool isAvailable;
  final List<String> specializations;

  // Getters for compatibility
  int get sessionsCount => sessionsCompleted;
  int get experienceYears => yearsExperience;
  String get availability => isAvailable ? 'Доступен' : 'Недоступен';

  Mentor({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.bio,
    required this.expertise,
    required this.languages,
    required this.rating,
    required this.sessionsCompleted,
    required this.yearsExperience,
    required this.avatarUrl,
    required this.isAvailable,
    required this.specializations,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'company': company,
      'bio': bio,
      'expertise': expertise,
      'languages': languages,
      'rating': rating,
      'sessionsCompleted': sessionsCompleted,
      'yearsExperience': yearsExperience,
      'avatarUrl': avatarUrl,
      'isAvailable': isAvailable,
      'specializations': specializations,
    };
  }

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      company: json['company'],
      bio: json['bio'],
      expertise: List<String>.from(json['expertise']),
      languages: List<String>.from(json['languages']),
      rating: json['rating'].toDouble(),
      sessionsCompleted: json['sessionsCompleted'],
      yearsExperience: json['yearsExperience'],
      avatarUrl: json['avatarUrl'],
      isAvailable: json['isAvailable'],
      specializations: List<String>.from(json['specializations']),
    );
  }

  Mentor copyWith({
    String? id,
    String? name,
    String? title,
    String? company,
    String? bio,
    List<String>? expertise,
    List<String>? languages,
    double? rating,
    int? sessionsCompleted,
    int? yearsExperience,
    String? avatarUrl,
    bool? isAvailable,
    List<String>? specializations,
  }) {
    return Mentor(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      company: company ?? this.company,
      bio: bio ?? this.bio,
      expertise: expertise ?? this.expertise,
      languages: languages ?? this.languages,
      rating: rating ?? this.rating,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      specializations: specializations ?? this.specializations,
    );
  }
}

// Модель сессии наставничества
class MentorshipSession {
  final String id;
  final String mentorId;
  final String menteeId;
  final String title;
  final String description;
  final SessionType type;
  final DateTime scheduledAt;
  final int durationMinutes;
  final SessionStatus status;
  final String? notes;
  final DateTime? completedAt;
  final double? rating;
  final String? feedback;

  // Getters for compatibility
  DateTime get scheduledDate => scheduledAt;
  int get duration => durationMinutes;
  Mentor? get mentor => null; // This would need to be resolved from mentorId

  MentorshipSession({
    required this.id,
    required this.mentorId,
    required this.menteeId,
    required this.title,
    required this.description,
    required this.type,
    required this.scheduledAt,
    required this.durationMinutes,
    required this.status,
    this.notes,
    this.completedAt,
    this.rating,
    this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentorId': mentorId,
      'menteeId': menteeId,
      'title': title,
      'description': description,
      'type': type.index,
      'scheduledAt': scheduledAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'status': status.index,
      'notes': notes,
      'completedAt': completedAt?.toIso8601String(),
      'rating': rating,
      'feedback': feedback,
    };
  }

  factory MentorshipSession.fromJson(Map<String, dynamic> json) {
    return MentorshipSession(
      id: json['id'],
      mentorId: json['mentorId'],
      menteeId: json['menteeId'],
      title: json['title'],
      description: json['description'],
      type: SessionType.values[json['type']],
      scheduledAt: DateTime.parse(json['scheduledAt']),
      durationMinutes: json['durationMinutes'],
      status: SessionStatus.values[json['status']],
      notes: json['notes'],
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      rating: json['rating']?.toDouble(),
      feedback: json['feedback'],
    );
  }

  MentorshipSession copyWith({
    String? id,
    String? mentorId,
    String? menteeId,
    String? title,
    String? description,
    SessionType? type,
    DateTime? scheduledAt,
    int? durationMinutes,
    SessionStatus? status,
    String? notes,
    DateTime? completedAt,
    double? rating,
    String? feedback,
  }) {
    return MentorshipSession(
      id: id ?? this.id,
      mentorId: mentorId ?? this.mentorId,
      menteeId: menteeId ?? this.menteeId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      completedAt: completedAt ?? this.completedAt,
      rating: rating ?? this.rating,
      feedback: feedback ?? this.feedback,
    );
  }
}

// Модель плана развития
class DevelopmentPlan {
  final String id;
  final String title;
  final String description;
  final List<String> goals;
  final List<String> milestones;
  final DateTime startDate;
  final DateTime? endDate;
  final String mentorId;
  final String menteeId;
  final bool isActive;
  final double progress;

  // Getters for compatibility
  PlanLevel get level => PlanLevel.beginner; // Default level
  int get duration => 3; // Default duration in months

  DevelopmentPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.goals,
    required this.milestones,
    required this.startDate,
    this.endDate,
    required this.mentorId,
    required this.menteeId,
    required this.isActive,
    required this.progress,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'goals': goals,
      'milestones': milestones,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'mentorId': mentorId,
      'menteeId': menteeId,
      'isActive': isActive,
      'progress': progress,
    };
  }

  factory DevelopmentPlan.fromJson(Map<String, dynamic> json) {
    return DevelopmentPlan(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      goals: List<String>.from(json['goals']),
      milestones: List<String>.from(json['milestones']),
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      mentorId: json['mentorId'],
      menteeId: json['menteeId'],
      isActive: json['isActive'],
      progress: json['progress'].toDouble(),
    );
  }

  DevelopmentPlan copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? goals,
    List<String>? milestones,
    DateTime? startDate,
    DateTime? endDate,
    String? mentorId,
    String? menteeId,
    bool? isActive,
    double? progress,
  }) {
    return DevelopmentPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      goals: goals ?? this.goals,
      milestones: milestones ?? this.milestones,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      mentorId: mentorId ?? this.mentorId,
      menteeId: menteeId ?? this.menteeId,
      isActive: isActive ?? this.isActive,
      progress: progress ?? this.progress,
    );
  }
}

// Модель обратной связи
class MentorshipFeedback {
  final String id;
  final String sessionId;
  final String fromUserId;
  final String toUserId;
  final FeedbackRating rating;
  final String comment;
  final DateTime createdAt;
  final List<String> tags;

  // Getters for compatibility
  String get sessionTitle => 'Сессия $sessionId';
  String get mentorName => 'Ментор $toUserId';

  MentorshipFeedback({
    required this.id,
    required this.sessionId,
    required this.fromUserId,
    required this.toUserId,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.tags,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionId': sessionId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'rating': rating.index,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
    };
  }

  factory MentorshipFeedback.fromJson(Map<String, dynamic> json) {
    return MentorshipFeedback(
      id: json['id'],
      sessionId: json['sessionId'],
      fromUserId: json['fromUserId'],
      toUserId: json['toUserId'],
      rating: FeedbackRating.values[json['rating']],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
      tags: List<String>.from(json['tags']),
    );
  }

  MentorshipFeedback copyWith({
    String? id,
    String? sessionId,
    String? fromUserId,
    String? toUserId,
    FeedbackRating? rating,
    String? comment,
    DateTime? createdAt,
    List<String>? tags,
  }) {
    return MentorshipFeedback(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      fromUserId: fromUserId ?? this.fromUserId,
      toUserId: toUserId ?? this.toUserId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
    );
  }
}

// Провайдер для системы менторства
class MentorshipProvider extends ChangeNotifier {
  List<Mentor> _mentors = [];
  List<MentorshipSession> _sessions = [];
  List<DevelopmentPlan> _plans = [];
                List<MentorshipFeedback> _feedbacks = [];
  bool _isLoading = false;

  // Геттеры
  List<Mentor> get mentors => _mentors;
  List<MentorshipSession> get sessions => _sessions;
  List<DevelopmentPlan> get plans => _plans;
                List<MentorshipFeedback> get feedbacks => _feedbacks;
  bool get isLoading => _isLoading;

  // Фильтрованные списки
  List<Mentor> get availableMentors => _mentors.where((m) => m.isAvailable).toList();
  List<MentorshipSession> get activeSessions => _sessions.where((s) => s.status == SessionStatus.scheduled).toList();
  List<DevelopmentPlan> get activePlans => _plans.where((p) => p.isActive).toList();

  // Инициализация
  Future<void> initialize() async {
    await _loadData();
    if (_mentors.isEmpty) {
      _createDemoData();
    }
  }

  // Загрузка данных
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Загрузка менторов
      final mentorsJson = prefs.getStringList('mentors') ?? [];
      _mentors = mentorsJson.map((json) => Mentor.fromJson(jsonDecode(json))).toList();
      
      // Загрузка сессий
      final sessionsJson = prefs.getStringList('sessions') ?? [];
      _sessions = sessionsJson.map((json) => MentorshipSession.fromJson(jsonDecode(json))).toList();
      
      // Загрузка планов
      final plansJson = prefs.getStringList('development_plans') ?? [];
      _plans = plansJson.map((json) => DevelopmentPlan.fromJson(jsonDecode(json))).toList();
      
      // Загрузка обратной связи
                        final feedbacksJson = prefs.getStringList('feedbacks') ?? [];
                  _feedbacks = feedbacksJson.map((json) => MentorshipFeedback.fromJson(jsonDecode(json))).toList();
    } catch (e) {
      debugPrint('Ошибка загрузки данных менторства: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Сохранение данных
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Сохранение менторов
      final mentorsJson = _mentors.map((m) => jsonEncode(m.toJson())).toList();
      await prefs.setStringList('mentors', mentorsJson);
      
      // Сохранение сессий
      final sessionsJson = _sessions.map((s) => jsonEncode(s.toJson())).toList();
      await prefs.setStringList('sessions', sessionsJson);
      
      // Сохранение планов
      final plansJson = _plans.map((p) => jsonEncode(p.toJson())).toList();
      await prefs.setStringList('development_plans', plansJson);
      
      // Сохранение обратной связи
      final feedbacksJson = _feedbacks.map((f) => jsonEncode(f.toJson())).toList();
      await prefs.setStringList('feedbacks', feedbacksJson);
    } catch (e) {
      debugPrint('Ошибка сохранения данных менторства: $e');
    }
  }

  // Создание демо-данных
  void _createDemoData() {
    // Демо-менторы
    _mentors = [
      Mentor(
        id: '1',
        name: 'Александр Петров',
        title: 'CTO & Blockchain Architect',
        company: 'REChain Labs',
        bio: 'Эксперт в области блокчейн-технологий с 8-летним опытом. Специализируется на DeFi, NFT и смарт-контрактах.',
        expertise: ['Blockchain', 'DeFi', 'Smart Contracts', 'Solidity', 'Rust'],
        languages: ['Русский', 'Английский'],
        rating: 4.9,
        sessionsCompleted: 127,
        yearsExperience: 8,
        avatarUrl: 'https://via.placeholder.com/150/4CAF50/FFFFFF?text=AP',
        isAvailable: true,
        specializations: ['DeFi Protocols', 'NFT Marketplaces', 'Layer 2 Solutions'],
      ),
      Mentor(
        id: '2',
        name: 'Мария Сидорова',
        title: 'Venture Capital Partner',
        company: 'TanechFund Ventures',
        bio: 'Инвестиционный партнер с опытом в венчурном капитале и развитии стартапов. Помогла более 50 проектам привлечь финансирование.',
        expertise: ['Venture Capital', 'Startup Funding', 'Business Development', 'Pitch Decks'],
        languages: ['Русский', 'Английский', 'Китайский'],
        rating: 4.8,
        sessionsCompleted: 89,
        yearsExperience: 12,
        avatarUrl: 'https://via.placeholder.com/150/2196F3/FFFFFF?text=MS',
        isAvailable: true,
        specializations: ['Seed Funding', 'Series A', 'International Expansion'],
      ),
      Mentor(
        id: '3',
        name: 'Дмитрий Козлов',
        title: 'Product Manager & Growth Hacker',
        company: 'TechGrowth Studio',
        bio: 'Специалист по продуктовому менеджменту и росту пользователей. Опыт работы с B2B и B2C продуктами в сфере Web3.',
        expertise: ['Product Management', 'Growth Hacking', 'User Acquisition', 'Analytics'],
        languages: ['Русский', 'Английский'],
        rating: 4.7,
        sessionsCompleted: 156,
        yearsExperience: 6,
        avatarUrl: 'https://via.placeholder.com/150/FF9800/FFFFFF?text=DK',
        isAvailable: true,
        specializations: ['Web3 Products', 'B2B SaaS', 'Community Building'],
      ),
      Mentor(
        id: '4',
        name: 'Елена Волкова',
        title: 'Legal Counsel & Compliance',
        company: 'CryptoLegal Partners',
        bio: 'Юрист-консультант по криптовалютному праву и регулированию. Специализируется на ICO, STO и DeFi проектах.',
        expertise: ['Crypto Law', 'Regulatory Compliance', 'Token Sales', 'AML/KYC'],
        languages: ['Русский', 'Английский', 'Немецкий'],
        rating: 4.6,
        sessionsCompleted: 73,
        yearsExperience: 9,
        avatarUrl: 'https://via.placeholder.com/150/9C27B0/FFFFFF?text=EV',
        isAvailable: true,
        specializations: ['Regulatory Compliance', 'Token Economics', 'International Law'],
      ),
      Mentor(
        id: '5',
        name: 'Сергей Морозов',
        title: 'Marketing & Community Manager',
        company: 'Web3 Marketing Agency',
        bio: 'Эксперт по маркетингу в Web3 и управлению сообществами. Помог более 30 проектам построить сильные сообщества.',
        expertise: ['Web3 Marketing', 'Community Management', 'Social Media', 'Content Strategy'],
        languages: ['Русский', 'Английский', 'Испанский'],
        rating: 4.5,
        sessionsCompleted: 94,
        yearsExperience: 5,
        avatarUrl: 'https://via.placeholder.com/150/F44336/FFFFFF?text=SM',
        isAvailable: true,
        specializations: ['Community Building', 'Influencer Marketing', 'Event Management'],
      ),
    ];

    // Демо-сессии
    _sessions = [
      MentorshipSession(
        id: '1',
        mentorId: '1',
        menteeId: 'user1',
        title: 'Архитектура DeFi протокола',
        description: 'Обсуждение технической архитектуры нового DeFi протокола и выбор оптимального стека технологий.',
        type: SessionType.individual,
        scheduledAt: DateTime.now().add(const Duration(days: 2)),
        durationMinutes: 60,
        status: SessionStatus.scheduled,
      ),
      MentorshipSession(
        id: '2',
        mentorId: '2',
        menteeId: 'user2',
        title: 'Подготовка к питчу инвесторам',
        description: 'Репетиция презентации проекта для потенциальных инвесторов и подготовка ответов на вопросы.',
        type: SessionType.individual,
        scheduledAt: DateTime.now().add(const Duration(days: 5)),
        durationMinutes: 90,
        status: SessionStatus.scheduled,
      ),
    ];

    // Демо-планы развития
    _plans = [
      DevelopmentPlan(
        id: '1',
        title: 'Путь к успешному ICO',
        description: 'Комплексный план подготовки и проведения успешного ICO проекта.',
        goals: [
          'Изучить требования регуляторов',
          'Подготовить техническую документацию',
          'Создать маркетинговую стратегию',
          'Провести аудит безопасности',
        ],
        milestones: [
          'Завершение юридической подготовки',
          'Завершение технической разработки',
          'Запуск маркетинговой кампании',
          'Проведение ICO',
        ],
        startDate: DateTime.now().subtract(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 60)),
        mentorId: '4',
        menteeId: 'user1',
        isActive: true,
        progress: 0.4,
      ),
    ];

                    // Демо-обратная связь
                _feedbacks = [
                  MentorshipFeedback(
        id: '1',
        sessionId: '1',
        fromUserId: 'user1',
        toUserId: '1',
        rating: FeedbackRating.excellent,
        comment: 'Очень полезная сессия! Александр помог разобраться в сложных технических вопросах.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        tags: ['Техническая экспертиза', 'Практические советы'],
      ),
    ];

    _saveData();
  }

  // Методы для менторов
  Future<void> addMentor(Mentor mentor) async {
    _mentors.add(mentor);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateMentor(Mentor mentor) async {
    final index = _mentors.indexWhere((m) => m.id == mentor.id);
    if (index != -1) {
      _mentors[index] = mentor;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteMentor(String mentorId) async {
    _mentors.removeWhere((m) => m.id == mentorId);
    await _saveData();
    notifyListeners();
  }

  List<Mentor> searchMentors(String query, {List<String>? expertise, List<String>? languages}) {
    return _mentors.where((mentor) {
      bool matchesQuery = mentor.name.toLowerCase().contains(query.toLowerCase()) ||
          mentor.title.toLowerCase().contains(query.toLowerCase()) ||
          mentor.company.toLowerCase().contains(query.toLowerCase()) ||
          mentor.bio.toLowerCase().contains(query.toLowerCase());
      
      bool matchesExpertise = expertise == null || expertise.isEmpty ||
          expertise.any((e) => mentor.expertise.contains(e));
      
      bool matchesLanguages = languages == null || languages.isEmpty ||
          languages.any((l) => mentor.languages.contains(l));
      
      return matchesQuery && matchesExpertise && matchesLanguages;
    }).toList();
  }

  // Методы для сессий
  Future<void> createSession(MentorshipSession session) async {
    _sessions.add(session);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateSession(MentorshipSession session) async {
    final index = _sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      _sessions[index] = session;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> cancelSession(String sessionId) async {
    final index = _sessions.indexWhere((s) => s.id == sessionId);
    if (index != -1) {
      _sessions[index] = _sessions[index].copyWith(status: SessionStatus.cancelled);
      await _saveData();
      notifyListeners();
    }
  }

  List<MentorshipSession> getUserSessions(String userId) {
    return _sessions.where((s) => s.mentorId == userId || s.menteeId == userId).toList();
  }

  // Методы для планов развития
  Future<void> createDevelopmentPlan(DevelopmentPlan plan) async {
    _plans.add(plan);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateDevelopmentPlan(DevelopmentPlan plan) async {
    final index = _plans.indexWhere((p) => p.id == plan.id);
    if (index != -1) {
      _plans[index] = plan;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteDevelopmentPlan(String planId) async {
    _plans.removeWhere((p) => p.id == planId);
    await _saveData();
    notifyListeners();
  }

  List<DevelopmentPlan> getUserPlans(String userId) {
    return _plans.where((p) => p.mentorId == userId || p.menteeId == userId).toList();
  }

  // Методы для обратной связи
                Future<void> addFeedback(MentorshipFeedback feedback) async {
    _feedbacks.add(feedback);
    await _saveData();
    notifyListeners();
  }

                List<MentorshipFeedback> getMentorFeedback(String mentorId) {
    return _feedbacks.where((f) => f.toUserId == mentorId).toList();
  }

                List<MentorshipFeedback> getSessionFeedback(String sessionId) {
    return _feedbacks.where((f) => f.sessionId == sessionId).toList();
  }

  // Вспомогательные методы
  String getSessionTypeName(SessionType type) {
    switch (type) {
      case SessionType.individual:
        return 'Индивидуальная';
      case SessionType.group:
        return 'Групповая';
      case SessionType.workshop:
        return 'Воркшоп';
      case SessionType.review:
        return 'Ревью';
    }
  }

  String getStatusName(SessionStatus status) {
    switch (status) {
      case SessionStatus.scheduled:
        return 'Запланирована';
      case SessionStatus.completed:
        return 'Завершена';
      case SessionStatus.cancelled:
        return 'Отменена';
    }
  }

  String getRatingName(FeedbackRating rating) {
    switch (rating) {
      case FeedbackRating.poor:
        return 'Плохо';
      case FeedbackRating.fair:
        return 'Удовлетворительно';
      case FeedbackRating.good:
        return 'Хорошо';
      case FeedbackRating.excellent:
        return 'Отлично';
    }
  }

  Color getStatusColor(SessionStatus status) {
    switch (status) {
      case SessionStatus.scheduled:
        return Colors.orange;
      case SessionStatus.completed:
        return Colors.green;
      case SessionStatus.cancelled:
        return Colors.red;
    }
  }

  Color getRatingColor(FeedbackRating rating) {
    switch (rating) {
      case FeedbackRating.poor:
        return Colors.red;
      case FeedbackRating.fair:
        return Colors.orange;
      case FeedbackRating.good:
        return Colors.yellow;
      case FeedbackRating.excellent:
        return Colors.green;
    }
  }
}
