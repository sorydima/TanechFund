import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Web5 Creation Models
class CreationProject {
  final String id;
  final String title;
  final String description;
  final CreationType type;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime? completedAt;
  final CreationStatus status;
  final Map<String, dynamic> metadata;
  final List<CreationPhase> phases;
  final List<String> collaborators;
  final int progress;
  final String? aiAssistant;

  CreationProject({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.tags,
    required this.createdAt,
    this.completedAt,
    required this.status,
    required this.metadata,
    required this.phases,
    required this.collaborators,
    required this.progress,
    this.aiAssistant,
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
      'phases': phases.map((phase) => phase.toJson()).toList(),
      'collaborators': collaborators,
      'progress': progress,
      'aiAssistant': aiAssistant,
    };
  }

  factory CreationProject.fromJson(Map<String, dynamic> json) {
    return CreationProject(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: CreationType.values.firstWhere((e) => e.name == json['type']),
      tags: List<String>.from(json['tags']),
      createdAt: DateTime.parse(json['createdAt']),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      status: CreationStatus.values.firstWhere((e) => e.name == json['status']),
      metadata: Map<String, dynamic>.from(json['metadata']),
      phases: (json['phases'] as List).map((phase) => CreationPhase.fromJson(phase)).toList(),
      collaborators: List<String>.from(json['collaborators']),
      progress: json['progress'],
      aiAssistant: json['aiAssistant'],
    );
  }

  CreationProject copyWith({
    String? id,
    String? title,
    String? description,
    CreationType? type,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? completedAt,
    CreationStatus? status,
    Map<String, dynamic>? metadata,
    List<CreationPhase>? phases,
    List<String>? collaborators,
    int? progress,
    String? aiAssistant,
  }) {
    return CreationProject(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      phases: phases ?? this.phases,
      collaborators: collaborators ?? this.collaborators,
      progress: progress ?? this.progress,
      aiAssistant: aiAssistant ?? this.aiAssistant,
    );
  }
}

class CreationPhase {
  final String id;
  final String title;
  final String description;
  final PhaseType type;
  final bool isCompleted;
  final DateTime? completedAt;
  final Map<String, dynamic> data;
  final List<String> aiSuggestions;
  final List<String> humanInputs;

  CreationPhase({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.isCompleted,
    this.completedAt,
    required this.data,
    required this.aiSuggestions,
    required this.humanInputs,
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
      'aiSuggestions': aiSuggestions,
      'humanInputs': humanInputs,
    };
  }

  factory CreationPhase.fromJson(Map<String, dynamic> json) {
    return CreationPhase(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: PhaseType.values.firstWhere((e) => e.name == json['type']),
      isCompleted: json['isCompleted'],
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      data: Map<String, dynamic>.from(json['data']),
      aiSuggestions: List<String>.from(json['aiSuggestions']),
      humanInputs: List<String>.from(json['humanInputs']),
    );
  }
}

class AICollaborator {
  final String id;
  final String name;
  final String description;
  final AISpecialty specialty;
  final List<String> capabilities;
  final double confidence;
  final bool isActive;
  final Map<String, dynamic> personality;

  AICollaborator({
    required this.id,
    required this.name,
    required this.description,
    required this.specialty,
    required this.capabilities,
    required this.confidence,
    required this.isActive,
    required this.personality,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'specialty': specialty.name,
      'capabilities': capabilities,
      'confidence': confidence,
      'isActive': isActive,
      'personality': personality,
    };
  }

  factory AICollaborator.fromJson(Map<String, dynamic> json) {
    return AICollaborator(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      specialty: AISpecialty.values.firstWhere((e) => e.name == json['specialty']),
      capabilities: List<String>.from(json['capabilities']),
      confidence: json['confidence'],
      isActive: json['isActive'],
      personality: Map<String, dynamic>.from(json['personality']),
    );
  }
}

class CreativeMoment {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final List<String> inspirations;
  final Map<String, dynamic> context;
  final List<String> outcomes;
  final bool isShared;

  CreativeMoment({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.inspirations,
    required this.context,
    required this.outcomes,
    required this.isShared,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'inspirations': inspirations,
      'context': context,
      'outcomes': outcomes,
      'isShared': isShared,
    };
  }

  factory CreativeMoment.fromJson(Map<String, dynamic> json) {
    return CreativeMoment(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      inspirations: List<String>.from(json['inspirations']),
      context: Map<String, dynamic>.from(json['context']),
      outcomes: List<String>.from(json['outcomes']),
      isShared: json['isShared'],
    );
  }
}

enum CreationType {
  digitalArt,
  music,
  writing,
  code,
  business,
  social,
  educational,
  scientific,
  spiritual,
}

enum CreationStatus {
  ideation,
  planning,
  active,
  review,
  completed,
  shared,
}

enum PhaseType {
  inspiration,
  ideation,
  planning,
  creation,
  refinement,
  sharing,
  feedback,
}

enum AISpecialty {
  creative,
  technical,
  analytical,
  social,
  strategic,
  artistic,
}

class Web5CreationProvider extends ChangeNotifier {
  List<CreationProject> _projects = [];
  List<AICollaborator> _aiCollaborators = [];
  List<CreativeMoment> _creativeMoments = [];
  bool _isLoading = false;
  String? _error;

  List<CreationProject> get projects => _projects;
  List<AICollaborator> get aiCollaborators => _aiCollaborators;
  List<CreativeMoment> get creativeMoments => _creativeMoments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Initialize with demo data
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loadData();
      if (_projects.isEmpty) {
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
    final projectsJson = prefs.getString('web5_projects');
    final collaboratorsJson = prefs.getString('web5_collaborators');
    final momentsJson = prefs.getString('web5_moments');

    if (projectsJson != null) {
      final List<dynamic> projectsList = json.decode(projectsJson);
      _projects = projectsList.map((json) => CreationProject.fromJson(json)).toList();
    }

    if (collaboratorsJson != null) {
      final List<dynamic> collaboratorsList = json.decode(collaboratorsJson);
      _aiCollaborators = collaboratorsList.map((json) => AICollaborator.fromJson(json)).toList();
    }

    if (momentsJson != null) {
      final List<dynamic> momentsList = json.decode(momentsJson);
      _creativeMoments = momentsList.map((json) => CreativeMoment.fromJson(json)).toList();
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('web5_projects', json.encode(_projects.map((p) => p.toJson()).toList()));
    await prefs.setString('web5_collaborators', json.encode(_aiCollaborators.map((c) => c.toJson()).toList()));
    await prefs.setString('web5_moments', json.encode(_creativeMoments.map((m) => m.toJson()).toList()));
  }

  Future<void> _createDemoData() async {
    // Demo AI Collaborators
    _aiCollaborators = [
      AICollaborator(
        id: '1',
        name: 'Creative Muse',
        description: 'AI помощник для творческих проектов',
        specialty: AISpecialty.creative,
        capabilities: ['idea generation', 'artistic feedback', 'inspiration'],
        confidence: 0.92,
        isActive: true,
        personality: {'style': 'inspiring', 'approach': 'collaborative'},
      ),
      AICollaborator(
        id: '2',
        name: 'Tech Architect',
        description: 'AI для технических решений',
        specialty: AISpecialty.technical,
        capabilities: ['code review', 'architecture', 'optimization'],
        confidence: 0.88,
        isActive: true,
        personality: {'style': 'analytical', 'approach': 'systematic'},
      ),
      AICollaborator(
        id: '3',
        name: 'Social Connector',
        description: 'AI для социальных проектов',
        specialty: AISpecialty.social,
        capabilities: ['community building', 'networking', 'engagement'],
        confidence: 0.85,
        isActive: true,
        personality: {'style': 'friendly', 'approach': 'inclusive'},
      ),
    ];

    // Demo projects
    _projects = [
      CreationProject(
        id: '1',
        title: 'Виртуальная Галерея Искусства',
        description: 'Создание интерактивной галереи с AI-куратором',
        type: CreationType.digitalArt,
        tags: ['art', 'ai', 'virtual', 'gallery'],
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        status: CreationStatus.active,
        metadata: {'targetAudience': 'art lovers', 'platform': 'web'},
        phases: [
          CreationPhase(
            id: '1-1',
            title: 'Концепция и вдохновение',
            description: 'Определение концепции галереи',
            type: PhaseType.inspiration,
            isCompleted: true,
            completedAt: DateTime.now().subtract(const Duration(days: 18)),
            data: {'moodboard': 'created', 'references': ['gallery1', 'gallery2']},
            aiSuggestions: ['Consider immersive VR experience', 'Add social interaction features'],
            humanInputs: ['Focus on contemporary art', 'Include educational elements'],
          ),
          CreationPhase(
            id: '1-2',
            title: 'Техническая архитектура',
            description: 'Разработка технической основы',
            type: PhaseType.planning,
            isCompleted: false,
            data: {'techStack': 'flutter', 'backend': 'nodejs'},
            aiSuggestions: ['Use WebGL for 3D rendering', 'Implement real-time collaboration'],
            humanInputs: ['Keep it simple for mobile', 'Focus on performance'],
          ),
        ],
        collaborators: ['user1', 'user2'],
        progress: 30,
        aiAssistant: '1',
      ),
      CreationProject(
        id: '2',
        title: 'Социальная Платформа для Творцов',
        description: 'Платформа для объединения творческих людей',
        type: CreationType.social,
        tags: ['social', 'creativity', 'community', 'collaboration'],
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        status: CreationStatus.ideation,
        metadata: {'targetUsers': 'creators', 'features': ['collaboration', 'showcase']},
        phases: [
          CreationPhase(
            id: '2-1',
            title: 'Исследование потребностей',
            description: 'Изучение потребностей творческого сообщества',
            type: PhaseType.ideation,
            isCompleted: false,
            data: {'surveys': 'planned', 'interviews': 'scheduled'},
            aiSuggestions: ['Analyze existing platforms', 'Identify gaps in current solutions'],
            humanInputs: ['Focus on real user needs', 'Consider monetization'],
          ),
        ],
        collaborators: ['user3', 'user4'],
        progress: 5,
        aiAssistant: '3',
      ),
    ];

    // Demo creative moments
    _creativeMoments = [
      CreativeMoment(
        id: '1',
        title: 'Озарение о Web5',
        description: 'Понимание того, как AI может усилить человеческое творчество',
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        inspirations: ['conversation with AI', 'reading about creativity'],
        context: {'location': 'home', 'mood': 'inspired', 'time': 'evening'},
        outcomes: ['new project idea', 'deeper understanding'],
        isShared: true,
      ),
      CreativeMoment(
        id: '2',
        title: 'Прорыв в коде',
        description: 'Решение сложной технической проблемы',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        inspirations: ['debugging session', 'team discussion'],
        context: {'location': 'office', 'mood': 'focused', 'time': 'afternoon'},
        outcomes: ['working solution', 'new approach'],
        isShared: false,
      ),
    ];

    await _saveData();
  }

  Future<void> addProject(CreationProject project) async {
    _projects.add(project);
    await _saveData();
    notifyListeners();
  }

  Future<void> updateProject(CreationProject project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project;
      await _saveData();
      notifyListeners();
    }
  }

  Future<void> deleteProject(String projectId) async {
    _projects.removeWhere((p) => p.id == projectId);
    await _saveData();
    notifyListeners();
  }

  Future<void> completePhase(String projectId, String phaseId) async {
    final projectIndex = _projects.indexWhere((p) => p.id == projectId);
    if (projectIndex != -1) {
      final phaseIndex = _projects[projectIndex].phases.indexWhere((ph) => ph.id == phaseId);
      if (phaseIndex != -1) {
        final updatedPhase = CreationPhase(
          id: _projects[projectIndex].phases[phaseIndex].id,
          title: _projects[projectIndex].phases[phaseIndex].title,
          description: _projects[projectIndex].phases[phaseIndex].description,
          type: _projects[projectIndex].phases[phaseIndex].type,
          isCompleted: true,
          completedAt: DateTime.now(),
          data: _projects[projectIndex].phases[phaseIndex].data,
          aiSuggestions: _projects[projectIndex].phases[phaseIndex].aiSuggestions,
          humanInputs: _projects[projectIndex].phases[phaseIndex].humanInputs,
        );

        final updatedPhases = List<CreationPhase>.from(_projects[projectIndex].phases);
        updatedPhases[phaseIndex] = updatedPhase;

        final completedPhases = updatedPhases.where((p) => p.isCompleted).length;
        final progress = (completedPhases / updatedPhases.length * 100).round();

        final updatedProject = _projects[projectIndex].copyWith(
          phases: updatedPhases,
          progress: progress,
        );

        _projects[projectIndex] = updatedProject;
        await _saveData();
        notifyListeners();
      }
    }
  }

  Future<void> addCreativeMoment(CreativeMoment moment) async {
    _creativeMoments.add(moment);
    await _saveData();
    notifyListeners();
  }

  Future<void> shareCreativeMoment(String momentId) async {
    final index = _creativeMoments.indexWhere((m) => m.id == momentId);
    if (index != -1) {
      final updatedMoment = CreativeMoment(
        id: _creativeMoments[index].id,
        title: _creativeMoments[index].title,
        description: _creativeMoments[index].description,
        timestamp: _creativeMoments[index].timestamp,
        inspirations: _creativeMoments[index].inspirations,
        context: _creativeMoments[index].context,
        outcomes: _creativeMoments[index].outcomes,
        isShared: true,
      );
      _creativeMoments[index] = updatedMoment;
      await _saveData();
      notifyListeners();
    }
  }

  List<CreationProject> getProjectsByType(CreationType type) {
    return _projects.where((p) => p.type == type).toList();
  }

  List<CreationProject> getActiveProjects() {
    return _projects.where((p) => p.status == CreationStatus.active).toList();
  }

  List<AICollaborator> getActiveCollaborators() {
    return _aiCollaborators.where((c) => c.isActive).toList();
  }

  List<CreativeMoment> getSharedMoments() {
    return _creativeMoments.where((m) => m.isShared).toList();
  }

  Future<List<String>> getAISuggestions(String projectId, String phaseId) async {
    // Simulate AI suggestions
    await Future.delayed(const Duration(seconds: 1));
    return [
      'Consider user feedback integration',
      'Add real-time collaboration features',
      'Implement progressive enhancement',
      'Focus on accessibility',
    ];
  }
}
