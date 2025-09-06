import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum ProjectStatus {
  inProgress,
  completed,
  onHold,
  cancelled,
}

enum ProjectCategory {
  defi,
  nft,
  dao,
  gaming,
  infrastructure,
  other,
}

class Project {
  final String id;
  final String title;
  final String description;
  final String userId;
  final ProjectCategory category;
  final ProjectStatus status;
  final List<String> technologies;
  final List<String> images;
  final String? githubUrl;
  final String? liveUrl;
  final String? documentationUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final int views;
  final double rating;
  final List<String> tags;
  final Map<String, dynamic> metadata;

  Project({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.category,
    required this.status,
    required this.technologies,
    required this.images,
    this.githubUrl,
    this.liveUrl,
    this.documentationUrl,
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.views = 0,
    this.rating = 0.0,
    required this.tags,
    this.metadata = const {},
  });

  Project copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    ProjectCategory? category,
    ProjectStatus? status,
    List<String>? technologies,
    List<String>? images,
    String? githubUrl,
    String? liveUrl,
    String? documentationUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likes,
    int? views,
    double? rating,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return Project(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      status: status ?? this.status,
      technologies: technologies ?? this.technologies,
      images: images ?? this.images,
      githubUrl: githubUrl ?? this.githubUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      documentationUrl: documentationUrl ?? this.documentationUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'category': category.index,
      'status': status.index,
      'technologies': technologies,
      'images': images,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
      'documentationUrl': documentationUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likes': likes,
      'views': views,
      'rating': rating,
      'tags': tags,
      'metadata': metadata,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['userId'],
      category: ProjectCategory.values[json['category']],
      status: ProjectStatus.values[json['status']],
      technologies: List<String>.from(json['technologies']),
      images: List<String>.from(json['images']),
      githubUrl: json['githubUrl'],
      liveUrl: json['liveUrl'],
      documentationUrl: json['documentationUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      likes: json['likes'] ?? 0,
      views: json['views'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      tags: List<String>.from(json['tags']),
      metadata: json['metadata'] ?? {},
    );
  }
}

class PortfolioProvider with ChangeNotifier {
  List<Project> _projects = [];
  bool _isLoading = false;
  String? _currentUserId;

  List<Project> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get currentUserId => _currentUserId;

  // Получить проекты пользователя
  List<Project> getUserProjects(String userId) {
    return _projects.where((project) => project.userId == userId).toList();
  }

  // Получить проекты по категории
  List<Project> getProjectsByCategory(ProjectCategory category) {
    return _projects.where((project) => project.category == category).toList();
  }

  // Получить проекты по статусу
  List<Project> getProjectsByStatus(ProjectStatus status) {
    return _projects.where((project) => project.status == status).toList();
  }

  // Поиск проектов
  List<Project> searchProjects(String query) {
    if (query.isEmpty) return _projects;
    
    final lowercaseQuery = query.toLowerCase();
    return _projects.where((project) {
      return project.title.toLowerCase().contains(lowercaseQuery) ||
             project.description.toLowerCase().contains(lowercaseQuery) ||
             project.technologies.any((tech) => tech.toLowerCase().contains(lowercaseQuery)) ||
             project.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Добавить проект
  Future<void> addProject(Project project) async {
    _projects.add(project);
    await _saveProjects();
    notifyListeners();
  }

  // Обновить проект
  Future<void> updateProject(Project project) async {
    final index = _projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      _projects[index] = project.copyWith(updatedAt: DateTime.now());
      await _saveProjects();
      notifyListeners();
    }
  }

  // Удалить проект
  Future<void> deleteProject(String projectId) async {
    _projects.removeWhere((project) => project.id == projectId);
    await _saveProjects();
    notifyListeners();
  }

  // Лайкнуть проект
  Future<void> likeProject(String projectId) async {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      _projects[index] = _projects[index].copyWith(
        likes: _projects[index].likes + 1,
      );
      await _saveProjects();
      notifyListeners();
    }
  }

  // Увеличить просмотры
  Future<void> incrementViews(String projectId) async {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      _projects[index] = _projects[index].copyWith(
        views: _projects[index].views + 1,
      );
      await _saveProjects();
      notifyListeners();
    }
  }

  // Оценить проект
  Future<void> rateProject(String projectId, double rating) async {
    final index = _projects.indexWhere((p) => p.id == projectId);
    if (index != -1) {
      final currentRating = _projects[index].rating;
      final currentViews = _projects[index].views;
      final newRating = ((currentRating * currentViews) + rating) / (currentViews + 1);
      
      _projects[index] = _projects[index].copyWith(
        rating: newRating,
        views: currentViews + 1,
      );
      await _saveProjects();
      notifyListeners();
    }
  }

  // Загрузить проекты
  Future<void> loadProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = prefs.getStringList('portfolio_projects') ?? [];
      
      _projects = projectsJson
          .map((json) => Project.fromJson(jsonDecode(json)))
          .toList();

      // Если проектов нет, создаем демо-данные
      if (_projects.isEmpty) {
        await _createDemoProjects();
      }
    } catch (e) {
      debugPrint('Error loading projects: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Сохранить проекты
  Future<void> _saveProjects() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final projectsJson = _projects
          .map((project) => jsonEncode(project.toJson()))
          .toList();
      await prefs.setStringList('portfolio_projects', projectsJson);
    } catch (e) {
      debugPrint('Error saving projects: $e');
    }
  }

  // Создать демо-проекты
  Future<void> _createDemoProjects() async {
    final demoProjects = [
      Project(
        id: '1',
        title: 'DeFi Yield Aggregator',
        description: 'Инновационный агрегатор доходности для DeFi протоколов с автоматической ребалансировкой портфеля и оптимизацией APY.',
        userId: 'demo_user_1',
        category: ProjectCategory.defi,
        status: ProjectStatus.completed,
        technologies: ['Solidity', 'React', 'Web3.js', 'Hardhat'],
        images: ['https://via.placeholder.com/400x300/4CAF50/FFFFFF?text=DeFi+Project'],
        githubUrl: 'https://github.com/demo/defi-yield-aggregator',
        liveUrl: 'https://defi-demo.app',
        documentationUrl: 'https://docs.defi-demo.app',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        tags: ['DeFi', 'Yield Farming', 'Smart Contracts', 'React'],
        metadata: {
          'totalValueLocked': '1000000',
          'apy': '15.5',
          'users': '1250',
        },
        likes: 45,
        views: 1200,
        rating: 4.8,
      ),
      Project(
        id: '2',
        title: 'NFT Marketplace on Solana',
        description: 'Высокопроизводительная NFT платформа на блокчейне Solana с поддержкой метавселенных и игровых активов.',
        userId: 'demo_user_2',
        category: ProjectCategory.nft,
        status: ProjectStatus.inProgress,
        technologies: ['Rust', 'Solana', 'React', 'TypeScript'],
        images: ['https://via.placeholder.com/400x300/2196F3/FFFFFF?text=NFT+Marketplace'],
        githubUrl: 'https://github.com/demo/solana-nft-marketplace',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        tags: ['NFT', 'Solana', 'Rust', 'Metaverse'],
        metadata: {
          'nftsListed': '5000',
          'tradingVolume': '250000',
          'artists': '150',
        },
        likes: 23,
        views: 800,
        rating: 4.6,
      ),
      Project(
        id: '3',
        title: 'DAO Governance Platform',
        description: 'Децентрализованная платформа управления для DAO с голосованием, предложениями и исполнением решений.',
        userId: 'demo_user_3',
        category: ProjectCategory.dao,
        status: ProjectStatus.completed,
        technologies: ['Solidity', 'Vue.js', 'IPFS', 'The Graph'],
        images: ['https://via.placeholder.com/400x300/FF9800/FFFFFF?text=DAO+Platform'],
        githubUrl: 'https://github.com/demo/dao-governance',
        liveUrl: 'https://dao-demo.app',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        tags: ['DAO', 'Governance', 'Voting', 'IPFS'],
        metadata: {
          'proposals': '25',
          'voters': '500',
          'treasury': '500000',
        },
        likes: 67,
        views: 2100,
        rating: 4.9,
      ),
      Project(
        id: '4',
        title: 'Blockchain Gaming Infrastructure',
        description: 'Инфраструктурное решение для игр на блокчейне с поддержкой скинов, внутриигровой экономики и кросс-чейн совместимости.',
        userId: 'demo_user_4',
        category: ProjectCategory.gaming,
        status: ProjectStatus.onHold,
        technologies: ['Unity', 'Solidity', 'Polygon', 'Web3'],
        images: ['https://via.placeholder.com/400x300/9C27B0/FFFFFF?text=Gaming+Infra'],
        githubUrl: 'https://github.com/demo/blockchain-gaming-infra',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        tags: ['Gaming', 'Unity', 'Polygon', 'Cross-chain'],
        metadata: {
          'games': '3',
          'players': '10000',
          'transactions': '50000',
        },
        likes: 34,
        views: 950,
        rating: 4.4,
      ),
    ];

    _projects.addAll(demoProjects);
    await _saveProjects();
  }

  // Установить текущего пользователя
  void setCurrentUser(String userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  // Получить статистику пользователя
  Map<String, dynamic> getUserStats(String userId) {
    final userProjects = getUserProjects(userId);
    
    if (userProjects.isEmpty) {
      return {
        'totalProjects': 0,
        'completedProjects': 0,
        'totalLikes': 0,
        'totalViews': 0,
        'averageRating': 0.0,
        'totalValue': 0.0,
      };
    }

    final completedProjects = userProjects.where((p) => p.status == ProjectStatus.completed).length;
    final totalLikes = userProjects.fold(0, (sum, p) => sum + p.likes);
    final totalViews = userProjects.fold(0, (sum, p) => sum + p.views);
    final averageRating = userProjects.fold(0.0, (sum, p) => sum + p.rating) / userProjects.length;

    return {
      'totalProjects': userProjects.length,
      'completedProjects': completedProjects,
      'totalLikes': totalLikes,
      'totalViews': totalViews,
      'averageRating': averageRating,
      'totalValue': 0.0, // В реальном приложении здесь будет расчет стоимости
    };
  }
}
