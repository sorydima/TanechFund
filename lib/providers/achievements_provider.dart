import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Модели для системы достижений
enum AchievementType {
  project,
  investment,
  mentorship,
  social,
  learning,
  hackathon,
  challenge,
  community,
}

enum AchievementRarity {
  common,
  rare,
  epic,
  legendary,
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final AchievementType type;
  final AchievementRarity rarity;
  final int points;
  final Map<String, dynamic> requirements;
  final DateTime? unlockedAt;
  final bool isUnlocked;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.rarity,
    required this.points,
    required this.requirements,
    this.unlockedAt,
    this.isUnlocked = false,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    AchievementType? type,
    AchievementRarity? rarity,
    int? points,
    Map<String, dynamic>? requirements,
    DateTime? unlockedAt,
    bool? isUnlocked,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      rarity: rarity ?? this.rarity,
      points: points ?? this.points,
      requirements: requirements ?? this.requirements,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'type': type.index,
      'rarity': rarity.index,
      'points': points,
      'requirements': requirements,
      'unlockedAt': unlockedAt?.millisecondsSinceEpoch,
      'isUnlocked': isUnlocked,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      type: AchievementType.values[json['type']],
      rarity: AchievementRarity.values[json['rarity']],
      points: json['points'],
      requirements: Map<String, dynamic>.from(json['requirements']),
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['unlockedAt'])
          : null,
      isUnlocked: json['isUnlocked'] ?? false,
    );
  }
}

class UserLevel {
  final int level;
  final int experience;
  final int experienceToNext;
  final int totalExperience;
  final String title;
  final Color color;

  UserLevel({
    required this.level,
    required this.experience,
    required this.experienceToNext,
    required this.totalExperience,
    required this.title,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'experience': experience,
      'experienceToNext': experienceToNext,
      'totalExperience': totalExperience,
      'title': title,
      'color': color.value,
    };
  }

  factory UserLevel.fromJson(Map<String, dynamic> json) {
    return UserLevel(
      level: json['level'],
      experience: json['experience'],
      experienceToNext: json['experienceToNext'],
      totalExperience: json['totalExperience'],
      title: json['title'],
      color: Color(json['color']),
    );
  }
}

class Reward {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String type; // 'badge', 'title', 'access', 'discount'
  final Map<String, dynamic> data;
  final bool isClaimed;
  final DateTime? claimedAt;

  Reward({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.data,
    this.isClaimed = false,
    this.claimedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'type': type,
      'data': data,
      'isClaimed': isClaimed,
      'claimedAt': claimedAt?.millisecondsSinceEpoch,
    };
  }

  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      type: json['type'],
      data: Map<String, dynamic>.from(json['data']),
      isClaimed: json['isClaimed'] ?? false,
      claimedAt: json['claimedAt'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(json['claimedAt'])
          : null,
    );
  }
}

class AchievementsProvider extends ChangeNotifier {
  List<Achievement> _achievements = [];
  List<Achievement> _unlockedAchievements = [];
  UserLevel _userLevel = UserLevel(
    level: 1,
    experience: 0,
    experienceToNext: 100,
    totalExperience: 0,
    title: 'Новичок',
    color: Colors.grey,
  );
  List<Reward> _rewards = [];
  List<Reward> _availableRewards = [];

  // Getters
  List<Achievement> get achievements => _achievements;
  List<Achievement> get unlockedAchievements => _unlockedAchievements;
  UserLevel get userLevel => _userLevel;
  List<Reward> get rewards => _rewards;
  List<Reward> get availableRewards => _availableRewards;
  
  int get totalPoints => _unlockedAchievements.fold(0, (sum, achievement) => sum + achievement.points);
  int get unlockedCount => _unlockedAchievements.length;
  int get totalCount => _achievements.length;
  double get progressPercentage => totalCount > 0 ? unlockedCount / totalCount : 0.0;

  // Инициализация
  Future<void> initialize() async {
    await _loadData();
    if (_achievements.isEmpty) {
      await _createDefaultAchievements();
    }
    await _checkAchievements();
  }

  // Загрузка данных
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Загрузка достижений
    final achievementsJson = prefs.getString('achievements');
    if (achievementsJson != null) {
      final List<dynamic> achievementsList = json.decode(achievementsJson);
      _achievements = achievementsList.map((json) => Achievement.fromJson(json)).toList();
    }

    // Загрузка разблокированных достижений
    final unlockedJson = prefs.getString('unlocked_achievements');
    if (unlockedJson != null) {
      final List<dynamic> unlockedList = json.decode(unlockedJson);
      _unlockedAchievements = unlockedList.map((json) => Achievement.fromJson(json)).toList();
    }

    // Загрузка уровня пользователя
    final levelJson = prefs.getString('user_level');
    if (levelJson != null) {
      _userLevel = UserLevel.fromJson(json.decode(levelJson));
    }

    // Загрузка наград
    final rewardsJson = prefs.getString('rewards');
    if (rewardsJson != null) {
      final List<dynamic> rewardsList = json.decode(rewardsJson);
      _rewards = rewardsList.map((json) => Reward.fromJson(json)).toList();
    }

    notifyListeners();
  }

  // Сохранение данных
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('achievements', json.encode(_achievements.map((a) => a.toJson()).toList()));
    await prefs.setString('unlocked_achievements', json.encode(_unlockedAchievements.map((a) => a.toJson()).toList()));
    await prefs.setString('user_level', json.encode(_userLevel.toJson()));
    await prefs.setString('rewards', json.encode(_rewards.map((r) => r.toJson()).toList()));
  }

  // Создание стандартных достижений
  Future<void> _createDefaultAchievements() async {
    _achievements = [
      // Проектные достижения
      Achievement(
        id: 'first_project',
        title: 'Первый проект',
        description: 'Создайте свой первый проект',
        icon: '🚀',
        type: AchievementType.project,
        rarity: AchievementRarity.common,
        points: 50,
        requirements: {'projects_created': 1},
      ),
      Achievement(
        id: 'project_master',
        title: 'Мастер проектов',
        description: 'Создайте 10 проектов',
        icon: '🏆',
        type: AchievementType.project,
        rarity: AchievementRarity.rare,
        points: 200,
        requirements: {'projects_created': 10},
      ),
      Achievement(
        id: 'project_legend',
        title: 'Легенда проектов',
        description: 'Создайте 50 проектов',
        icon: '👑',
        type: AchievementType.project,
        rarity: AchievementRarity.legendary,
        points: 1000,
        requirements: {'projects_created': 50},
      ),

      // Инвестиционные достижения
      Achievement(
        id: 'first_investment',
        title: 'Первый инвестор',
        description: 'Сделайте первую инвестицию',
        icon: '💰',
        type: AchievementType.investment,
        rarity: AchievementRarity.common,
        points: 100,
        requirements: {'investments_made': 1},
      ),
      Achievement(
        id: 'investment_guru',
        title: 'Гуру инвестиций',
        description: 'Сделайте 25 инвестиций',
        icon: '💎',
        type: AchievementType.investment,
        rarity: AchievementRarity.epic,
        points: 500,
        requirements: {'investments_made': 25},
      ),

      // Менторские достижения
      Achievement(
        id: 'first_mentor',
        title: 'Первый ментор',
        description: 'Станьте ментором',
        icon: '🎓',
        type: AchievementType.mentorship,
        rarity: AchievementRarity.common,
        points: 75,
        requirements: {'mentor_sessions': 1},
      ),
      Achievement(
        id: 'mentor_expert',
        title: 'Эксперт-ментор',
        description: 'Проведите 50 сессий менторства',
        icon: '🧠',
        type: AchievementType.mentorship,
        rarity: AchievementRarity.epic,
        points: 400,
        requirements: {'mentor_sessions': 50},
      ),

      // Социальные достижения
      Achievement(
        id: 'social_butterfly',
        title: 'Социальная бабочка',
        description: 'Создайте 100 постов',
        icon: '🦋',
        type: AchievementType.social,
        rarity: AchievementRarity.rare,
        points: 150,
        requirements: {'posts_created': 100},
      ),
      Achievement(
        id: 'influencer',
        title: 'Инфлюенсер',
        description: 'Получите 1000 лайков',
        icon: '⭐',
        type: AchievementType.social,
        rarity: AchievementRarity.epic,
        points: 300,
        requirements: {'total_likes': 1000},
      ),

      // Образовательные достижения
      Achievement(
        id: 'knowledge_seeker',
        title: 'Искатель знаний',
        description: 'Завершите 10 курсов',
        icon: '📚',
        type: AchievementType.learning,
        rarity: AchievementRarity.rare,
        points: 200,
        requirements: {'courses_completed': 10},
      ),
      Achievement(
        id: 'scholar',
        title: 'Ученый',
        description: 'Завершите 50 курсов',
        icon: '🎓',
        type: AchievementType.learning,
        rarity: AchievementRarity.legendary,
        points: 800,
        requirements: {'courses_completed': 50},
      ),

      // Хакатонские достижения
      Achievement(
        id: 'hackathon_rookie',
        title: 'Новичок хакатонов',
        description: 'Участвуйте в первом хакатоне',
        icon: '🏃',
        type: AchievementType.hackathon,
        rarity: AchievementRarity.common,
        points: 100,
        requirements: {'hackathons_participated': 1},
      ),
      Achievement(
        id: 'hackathon_champion',
        title: 'Чемпион хакатонов',
        description: 'Выиграйте хакатон',
        icon: '🥇',
        type: AchievementType.hackathon,
        rarity: AchievementRarity.epic,
        points: 500,
        requirements: {'hackathons_won': 1},
      ),

      // Челленджи
      Achievement(
        id: 'challenge_accepter',
        title: 'Принимающий вызовы',
        description: 'Примите участие в 5 челленджах',
        icon: '⚔️',
        type: AchievementType.challenge,
        rarity: AchievementRarity.rare,
        points: 250,
        requirements: {'challenges_completed': 5},
      ),

      // Сообщество
      Achievement(
        id: 'community_builder',
        title: 'Строитель сообщества',
        description: 'Помогите 100 пользователям',
        icon: '🤝',
        type: AchievementType.community,
        rarity: AchievementRarity.epic,
        points: 400,
        requirements: {'users_helped': 100},
      ),
    ];

    await _saveData();
  }

  // Проверка достижений
  Future<void> _checkAchievements() async {
    bool hasNewAchievements = false;
    
    for (final achievement in _achievements) {
      if (!achievement.isUnlocked && _checkAchievementRequirements(achievement)) {
        await _unlockAchievement(achievement);
        hasNewAchievements = true;
      }
    }

    if (hasNewAchievements) {
      notifyListeners();
    }
  }

  // Проверка требований достижения
  bool _checkAchievementRequirements(Achievement achievement) {
    // Здесь должна быть логика проверки требований
    // Пока что возвращаем false для демонстрации
    return false;
  }

  // Разблокировка достижения
  Future<void> _unlockAchievement(Achievement achievement) async {
    final unlockedAchievement = achievement.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );

    _unlockedAchievements.add(unlockedAchievement);
    
    // Обновляем в основном списке
    final index = _achievements.indexWhere((a) => a.id == achievement.id);
    if (index != -1) {
      _achievements[index] = unlockedAchievement;
    }

    // Добавляем опыт
    await _addExperience(achievement.points);

    // Создаем награду
    await _createReward(achievement);

    await _saveData();
  }

  // Добавление опыта
  Future<void> _addExperience(int points) async {
    _userLevel = UserLevel(
      level: _userLevel.level,
      experience: _userLevel.experience + points,
      experienceToNext: _userLevel.experienceToNext,
      totalExperience: _userLevel.totalExperience + points,
      title: _userLevel.title,
      color: _userLevel.color,
    );

    // Проверяем повышение уровня
    while (_userLevel.experience >= _userLevel.experienceToNext) {
      await _levelUp();
    }

    await _saveData();
  }

  // Повышение уровня
  Future<void> _levelUp() async {
    final newLevel = _userLevel.level + 1;
    final newExperience = _userLevel.experience - _userLevel.experienceToNext;
    final newExperienceToNext = (newLevel * 100).toInt();
    
    String newTitle;
    Color newColor;
    
    if (newLevel <= 5) {
      newTitle = 'Новичок';
      newColor = Colors.grey;
    } else if (newLevel <= 10) {
      newTitle = 'Ученик';
      newColor = Colors.green;
    } else if (newLevel <= 20) {
      newTitle = 'Специалист';
      newColor = Colors.blue;
    } else if (newLevel <= 35) {
      newTitle = 'Эксперт';
      newColor = Colors.purple;
    } else if (newLevel <= 50) {
      newTitle = 'Мастер';
      newColor = Colors.orange;
    } else {
      newTitle = 'Легенда';
      newColor = Colors.red;
    }

    _userLevel = UserLevel(
      level: newLevel,
      experience: newExperience,
      experienceToNext: newExperienceToNext,
      totalExperience: _userLevel.totalExperience,
      title: newTitle,
      color: newColor,
    );
  }

  // Создание награды
  Future<void> _createReward(Achievement achievement) async {
    final reward = Reward(
      id: 'reward_${achievement.id}',
      title: 'Награда за ${achievement.title}',
      description: 'Вы получили награду за достижение: ${achievement.description}',
      icon: achievement.icon,
      type: 'badge',
      data: {
        'achievement_id': achievement.id,
        'points': achievement.points,
        'rarity': achievement.rarity.index,
      },
    );

    _rewards.add(reward);
    _availableRewards.add(reward);
  }

  // Получение достижений по типу
  List<Achievement> getAchievementsByType(AchievementType type) {
    return _achievements.where((a) => a.type == type).toList();
  }

  // Получение достижений по редкости
  List<Achievement> getAchievementsByRarity(AchievementRarity rarity) {
    return _achievements.where((a) => a.rarity == rarity).toList();
  }

  // Получение прогресса по типу
  Map<AchievementType, double> getProgressByType() {
    final Map<AchievementType, double> progress = {};
    
    for (final type in AchievementType.values) {
      final typeAchievements = getAchievementsByType(type);
      final unlockedTypeAchievements = typeAchievements.where((a) => a.isUnlocked).length;
      progress[type] = typeAchievements.isNotEmpty 
          ? unlockedTypeAchievements / typeAchievements.length 
          : 0.0;
    }
    
    return progress;
  }

  // Получение статистики
  Map<String, dynamic> getStatistics() {
    return {
      'totalAchievements': _achievements.length,
      'unlockedAchievements': _unlockedAchievements.length,
      'totalPoints': totalPoints,
      'currentLevel': _userLevel.level,
      'currentTitle': _userLevel.title,
      'experience': _userLevel.experience,
      'experienceToNext': _userLevel.experienceToNext,
      'progressPercentage': progressPercentage,
      'progressByType': getProgressByType(),
    };
  }

  // Ручная разблокировка достижения (для тестирования)
  Future<void> unlockAchievementManually(String achievementId) async {
    final achievement = _achievements.firstWhere((a) => a.id == achievementId);
    if (!achievement.isUnlocked) {
      await _unlockAchievement(achievement);
      notifyListeners();
    }
  }

  // Получение награды
  Future<void> claimReward(String rewardId) async {
    final rewardIndex = _rewards.indexWhere((r) => r.id == rewardId);
    if (rewardIndex != -1 && !_rewards[rewardIndex].isClaimed) {
      _rewards[rewardIndex] = Reward(
        id: _rewards[rewardIndex].id,
        title: _rewards[rewardIndex].title,
        description: _rewards[rewardIndex].description,
        icon: _rewards[rewardIndex].icon,
        type: _rewards[rewardIndex].type,
        data: _rewards[rewardIndex].data,
        isClaimed: true,
        claimedAt: DateTime.now(),
      );
      
      _availableRewards.removeWhere((r) => r.id == rewardId);
      await _saveData();
      notifyListeners();
    }
  }
}
