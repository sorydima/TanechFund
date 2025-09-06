import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Web4 Movement Models
class MovementTrajectory {
  final String id;
  final String title;
  final String description;
  final MovementType type;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? completedAt;
  final MovementStatus status;
  final Map<String, dynamic> metadata;
  final List<MovementStep> steps;
  final int progress;

  MovementTrajectory({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.tags,
    required this.createdAt,
    this.completedAt,
    required this.status,
    required this.metadata,
    required this.steps,
    required this.progress,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'status': status.name,
      'metadata': metadata,
      'steps': steps.map((step) => step.toJson()).toList(),
      'progress': progress,
    };
  }

  factory MovementTrajectory.fromJson(Map<String, dynamic> json) {
    return MovementTrajectory(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: MovementType.values.firstWhere((e) => e.name == json['type']),
      tags: List<String>.from(json['tags']),
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      status: MovementStatus.values.firstWhere((e) => e.name == json['status']),
      metadata: Map<String, dynamic>.from(json['metadata']),
      steps: (json['steps'] as List).map((step) => MovementStep.fromJson(step)).toList(),
      progress: json['progress'],
    );
  }

  MovementTrajectory copyWith({
    String? id,
    String? title,
    String? description,
    MovementType? type,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? completedAt,
    MovementStatus? status,
    Map<String, dynamic>? metadata,
    List<MovementStep>? steps,
    int? progress,
  }) {
    return MovementTrajectory(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      steps: steps ?? this.steps,
      progress: progress ?? this.progress,
    );
  }
}

class MovementStep {
  final String id;
  final String title;
  final String description;
  final StepType type;
  final bool isCompleted;
  final DateTime? completedAt;
  final Map<String, dynamic> data;

  MovementStep({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.isCompleted,
    this.completedAt,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type.name,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'data': data,
    };
  }

  factory MovementStep.fromJson(Map<String, dynamic> json) {
    return MovementStep(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: StepType.values.firstWhere((e) => e.name == json['type']),
      isCompleted: json['isCompleted'],
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      data: Map<String, dynamic>.from(json['data']),
    );
  }
}

class DigitalIdentity {
  final String id;
  final String name;
  final String avatar;
  final List<String> skills;
  final Map<String, dynamic> reputation;
  final List<String> connections;
  final DateTime lastActive;
  final bool isActive;

  DigitalIdentity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.skills,
    required this.reputation,
    required this.connections,
    required this.lastActive,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'skills': skills,
      'reputation': reputation,
      'connections': connections,
      'lastActive': lastActive.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory DigitalIdentity.fromJson(Map<String, dynamic> json) {
    return DigitalIdentity(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      skills: List<String>.from(json['skills']),
      reputation: Map<String, dynamic>.from(json['reputation']),
      connections: List<String>.from(json['connections']),
      lastActive: DateTime.parse(json['lastActive']),
      isActive: json['isActive'],
    );
  }
}

enum MovementType {
  personal,
  professional,
  creative,
  social,
  economic,
  spiritual,
}

enum MovementStatus {
  planning,
  active,
  paused,
  completed,
  abandoned,
}

enum StepType {
  learning,
  action,
  reflection,
  connection,
  creation,
  sharing,
}

class Web4MovementProvider extends ChangeNotifier {
  List<MovementTrajectory> _trajectories = [];
  List<DigitalIdentity> _identities = [];
  bool _isLoading = false;
  String? _error;

  List<MovementTrajectory> get trajectories => _trajectories;
  List<DigitalIdentity> get identities => _identities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with demo data
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadData();
      if (_trajectories.isEmpty) {
        await _createDemoData();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final trajectoriesJson = prefs.getString('web4_trajectories');
    final identitiesJson = prefs.getString('web4_identities');

    if (trajectoriesJson != null) {
      final List<dynamic> trajectoriesList = json.decode(trajectoriesJson);
      _trajectories = trajectoriesList.map((json) => MovementTrajectory.fromJson(json)).toList();
    }

    if (identitiesJson != null) {
      final List<dynamic> identitiesList = json.decode(identitiesJson);
      _identities = identitiesList.map((json) => DigitalIdentity.fromJson(json)).toList();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('web4_trajectories', json.encode(_trajectories.map((t) => t.toJson()).toList()));
    await prefs.setString('web4_identities', json.encode(_identities.map((i) => i.toJson()).toList()));
  }

  Future<void> _createDemoData() async {
    // Demo trajectories
    _trajectories = [
      MovementTrajectory(
        id: '1',
        title: 'Путь к Web3 Мастерству',
        description: 'Изучение блокчейн технологий и создание собственных проектов',
        type: MovementType.professional,
        tags: ['blockchain', 'web3', 'development'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        status: MovementStatus.active,
        metadata: {'difficulty': 'intermediate', 'estimatedDays': 90},
        steps: [
          MovementStep(
            id: '1-1',
            title: 'Изучение основ блокчейна',
            description: 'Понять принципы работы блокчейна',
            type: StepType.learning,
            isCompleted: true,
            completedAt: DateTime.now().subtract(const Duration(days: 25)),
            data: {'resources': ['book1', 'video1']},
          ),
          MovementStep(
            id: '1-2',
            title: 'Создание первого смарт-контракта',
            description: 'Написать и развернуть простой смарт-контракт',
            type: StepType.creation,
            isCompleted: false,
            data: {'language': 'solidity'},
          ),
        ],
        progress: 25,
      ),
      MovementTrajectory(
        id: '2',
        title: 'Творческий Проект NFT',
        description: 'Создание коллекции NFT и построение сообщества',
        type: MovementType.creative,
        tags: ['nft', 'art', 'community'],
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        status: MovementStatus.planning,
        metadata: {'artStyle': 'digital', 'targetAudience': 'artists'},
        steps: [
          MovementStep(
            id: '2-1',
            title: 'Разработка концепции',
            description: 'Определить стиль и тематику коллекции',
            type: StepType.creation,
            isCompleted: false,
            data: {'moodboard': 'created'},
          ),
        ],
        progress: 0,
      ),
    ];

    // Demo identities
    _identities = [
      DigitalIdentity(
        id: '1',
        name: 'Alex Web3',
        avatar: 'https://via.placeholder.com/100',
        skills: ['Solidity', 'React', 'Node.js', 'Blockchain'],
        reputation: {'web3': 85, 'development': 90, 'community': 75},
        connections: ['user2', 'user3', 'user4'],
        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
        isActive: true,
      ),
      DigitalIdentity(
        id: '2',
        name: 'Creative Mind',
        avatar: 'https://via.placeholder.com/100',
        skills: ['Digital Art', 'NFT', 'Community Building'],
        reputation: {'art': 95, 'nft': 88, 'social': 82},
        connections: ['user1', 'user5', 'user6'],
        lastActive: DateTime.now().subtract(const Duration(minutes: 30)),
        isActive: true,
      ),
    ];

    await _saveData();
  }

  Future<void> addTrajectory(MovementTrajectory trajectory) async {
    _trajectories.add(trajectory);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateTrajectory(MovementTrajectory trajectory) async {
    final index = _trajectories.indexWhere((t) => t.id == trajectory.id);
    if (index != -1) {
      _trajectories[index] = trajectory;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteTrajectory(String trajectoryId) async {
    _trajectories.removeWhere((t) => t.id == trajectoryId);
    await _saveData();
    notifyListeners();
  }

  Future<void> completeStep(String trajectoryId, String stepId) async {
    final trajectoryIndex = _trajectories.indexWhere((t) => t.id == trajectoryId);
    if (trajectoryIndex != -1) {
      final stepIndex = _trajectories[trajectoryIndex].steps.indexWhere((s) => s.id == stepId);
      if (stepIndex != -1) {
        final updatedStep = MovementStep(
          id: _trajectories[trajectoryIndex].steps[stepIndex].id,
          title: _trajectories[trajectoryIndex].steps[stepIndex].title,
          description: _trajectories[trajectoryIndex].steps[stepIndex].description,
          type: _trajectories[trajectoryIndex].steps[stepIndex].type,
          isCompleted: true,
          completedAt: DateTime.now(),
          data: _trajectories[trajectoryIndex].steps[stepIndex].data,
        );

        final updatedSteps = List<MovementStep>.from(_trajectories[trajectoryIndex].steps);
        updatedSteps[stepIndex] = updatedStep;

        final completedSteps = updatedSteps.where((s) => s.isCompleted).length;
        final progress = (completedSteps / updatedSteps.length * 100).round();

        final updatedTrajectory = _trajectories[trajectoryIndex].copyWith(
          steps: updatedSteps,
          progress: progress,
        );

        _trajectories[trajectoryIndex] = updatedTrajectory;
        await _saveData();
        notifyListeners();
      }
    }
  }

  Future<void> addIdentity(DigitalIdentity identity) async {
    _identities.add(identity);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateIdentity(DigitalIdentity identity) async {
    final index = _identities.indexWhere((i) => i.id == identity.id);
    if (index != -1) {
      _identities[index] = identity;
      await _saveData();
      notifyListeners();
    }
  }

  List<MovementTrajectory> getTrajectoriesByType(MovementType type) {
    return _trajectories.where((t) => t.type == type).toList();
  }

  List<MovementTrajectory> getActiveTrajectories() {
    return _trajectories.where((t) => t.status == MovementStatus.active).toList();
  }

  List<DigitalIdentity> getActiveIdentities() {
    return _identities.where((i) => i.isActive).toList();
  }
}
