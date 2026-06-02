import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/models/project_model.dart';
import 'package:rechain_vc_lab/services/storage_service.dart';

class PortfolioProvider with ChangeNotifier {
  List<ProjectModel> _projects = [];
  bool _isLoading = false;
  String? _currentUserId;

  List<ProjectModel> get projects => _projects;
  bool get isLoading => _isLoading;
  String? get currentUserId => _currentUserId;

  List<ProjectModel> getUserProjects(String userId) {
    return _projects.where((project) => project.userId == userId).toList();
  }

  List<ProjectModel> getProjectsByCategory(ProjectCategory category) {
    return _projects.where((project) => project.category == category).toList();
  }

  List<ProjectModel> getProjectsByStatus(ProjectStatus status) {
    return _projects.where((project) => project.status == status).toList();
  }

  List<ProjectModel> searchProjects(String query) {
    if (query.isEmpty) return _projects;
    
    final lowercaseQuery = query.toLowerCase();
    return _projects.where((project) {
      return project.title.toLowerCase().contains(lowercaseQuery) ||
          project.description.toLowerCase().contains(lowercaseQuery) ||
          project.technologies.any((tech) => tech.toLowerCase().contains(lowercaseQuery)) ||
          project.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  Future<Result<ProjectModel, AppError>> addProject(ProjectModel project) async {
    try {
      _projects.add(project);
      await _saveProjects();
      notifyListeners();
      return Success(project);
    } catch (e, st) {
      AppLogger.error('PortfolioProvider: addProject failed', e, st);
      return Failure(StorageError('Не удалось добавить проект', stackTrace: st));
    }
  }

  Future<Result<void, AppError>> updateProject(ProjectModel project) async {
    try {
      final index = _projects.indexWhere((p) => p.id == project.id);
      if (index == -1) {
        return Failure(ValidationError('Проект не найден'));
      }
      _projects[index] = project.copyWith(updatedAt: DateTime.now());
      await _saveProjects();
      notifyListeners();
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('PortfolioProvider: updateProject failed', e, st);
      return Failure(StorageError('Не удалось обновить проект', stackTrace: st));
    }
  }

  Future<Result<void, AppError>> deleteProject(String projectId) async {
    try {
      _projects.removeWhere((project) => project.id == projectId);
      await _saveProjects();
      notifyListeners();
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('PortfolioProvider: deleteProject failed', e, st);
      return Failure(StorageError('Не удалось удалить проект', stackTrace: st));
    }
  }

  Future<Result<void, AppError>> likeProject(String projectId) async {
    try {
      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index == -1) {
        return Failure(ValidationError('Проект не найден'));
      }
      _projects[index] = _projects[index].copyWith(likes: _projects[index].likes + 1);
      await _saveProjects();
      notifyListeners();
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('PortfolioProvider: likeProject failed', e, st);
      return Failure(StorageError('Не удалось поставить лайк', stackTrace: st));
    }
  }

  Future<Result<void, AppError>> incrementViews(String projectId) async {
    try {
      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index == -1) {
        return Failure(ValidationError('Проект не найден'));
      }
      _projects[index] = _projects[index].copyWith(views: _projects[index].views + 1);
      await _saveProjects();
      notifyListeners();
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('PortfolioProvider: incrementViews failed', e, st);
      return Failure(StorageError('Не удалось увеличить счетчик просмотров', stackTrace: st));
    }
  }

  Future<Result<void, AppError>> rateProject(String projectId, double rating) async {
    try {
      if (rating < 0.0 || rating > 5.0) {
        return Failure(ValidationError('Рейтинг должен быть от 0 до 5'));
      }
      
      final index = _projects.indexWhere((p) => p.id == projectId);
      if (index == -1) {
        return Failure(ValidationError('Проект не найден'));
      }
      
      final currentRating = _projects[index].rating;
      final currentViews = _projects[index].views;
      final newRating = ((currentRating * currentViews) + rating) / (currentViews + 1);
      
      _projects[index] = _projects[index].copyWith(
        rating: newRating,
        views: currentViews + 1,
      );
      await _saveProjects();
      notifyListeners();
      return const Success(null);
    } catch (e, st) {
      AppLogger.error('PortfolioProvider: rateProject failed', e, st);
      return Failure(StorageError('Не удалось оценить проект', stackTrace: st));
    }
  }

  Future<Result<List<ProjectModel>, AppError>> loadProjects() async {
    _isLoading = true;
    notifyListeners();

    try {
      final storage = await StorageService.getInstance();
      final projectsResult = storage.get<List<String>>('portfolio_projects', []);
      final projectsJson = projectsResult.value ?? [];

      _projects = projectsJson
          .map((json) => ProjectModel.fromJson(jsonDecode(json) as Map<String, dynamic>))
          .toList();

      if (_projects.isEmpty) {
        await _createDemoProjects();
      }
      
      notifyListeners();
      return Success(_projects);
    } catch (e, st) {
      AppLogger.error('PortfolioProvider: error loading projects', e, st);
      return Failure(StorageError('Ошибка загрузки проектов', stackTrace: st));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveProjects() async {
    try {
      final storage = await StorageService.getInstance();
      final projectsJson = _projects
          .map((project) => jsonEncode(project.toJson()))
          .toList();
      await storage.set<List<String>>('portfolio_projects', projectsJson);
    } catch (e, st) {
      AppLogger.error('PortfolioProvider: error saving projects', e, st);
    }
  }

  Future<void> _createDemoProjects() async {
    final demoProjects = [
      ProjectModel(
        id: '1',
        title: 'DeFi Yield Aggregator',
        description: 'Инновационный агрегатор доходности для DeFi протоколов с автоматической ребалансировкой портфеля и оптимизацией APY.',
        userId: 'demo_user_1',
        category: ProjectCategory.defi,
        status: ProjectStatus.completed,
        technologies: const ['Solidity', 'React', 'Web3.js', 'Hardhat'],
        images: const ['https://via.placeholder.com/400x300/4CAF50/FFFFFF?text=DeFi+Project'],
        githubUrl: 'https://github.com/demo/defi-yield-aggregator',
        liveUrl: 'https://defi-demo.app',
        documentationUrl: 'https://docs.defi-demo.app',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        tags: const ['DeFi', 'Yield Farming', 'Smart Contracts', 'React'],
        metadata: const {
          'totalValueLocked': '1000000',
          'apy': '15.5',
          'users': '1250',
        },
        likes: 45,
        views: 1200,
        rating: 4.8,
      ),
      ProjectModel(
        id: '2',
        title: 'NFT Marketplace on Solana',
        description: 'Высокопроизводительная NFT платформа на блокчейне Solana с поддержкой метавселенных и игровых активов.',
        userId: 'demo_user_2',
        category: ProjectCategory.nft,
        status: ProjectStatus.inProgress,
        technologies: const ['Rust', 'Solana', 'React', 'TypeScript'],
        images: const ['https://via.placeholder.com/400x300/2196F3/FFFFFF?text=NFT+Marketplace'],
        githubUrl: 'https://github.com/demo/solana-nft-marketplace',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        tags: const ['NFT', 'Solana', 'Rust', 'Metaverse'],
        metadata: const {
          'nftsListed': '5000',
          'tradingVolume': '250000',
          'artists': '150',
        },
        likes: 23,
        views: 800,
        rating: 4.6,
      ),
      ProjectModel(
        id: '3',
        title: 'DAO Governance Platform',
        description: 'Децентрализованная платформа управления для DAO с голосованием, предложениями и исполнением решений.',
        userId: 'demo_user_3',
        category: ProjectCategory.dao,
        status: ProjectStatus.completed,
        technologies: const ['Solidity', 'Vue.js', 'IPFS', 'The Graph'],
        images: const ['https://via.placeholder.com/400x300/FF9800/FFFFFF?text=DAO+Platform'],
        githubUrl: 'https://github.com/demo/dao-governance',
        liveUrl: 'https://dao-demo.app',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        tags: const ['DAO', 'Governance', 'Voting', 'IPFS'],
        metadata: const {
          'proposals': '25',
          'voters': '500',
          'treasury': '500000',
        },
        likes: 67,
        views: 2100,
        rating: 4.9,
      ),
      ProjectModel(
        id: '4',
        title: 'Blockchain Gaming Infrastructure',
        description: 'Инфраструктурное решение для игр на блокчейне с поддержкой скинов, внутриигровой экономики и кросс-чейн совместимости.',
        userId: 'demo_user_4',
        category: ProjectCategory.gaming,
        status: ProjectStatus.onHold,
        technologies: const ['Unity', 'Solidity', 'Polygon', 'Web3'],
        images: const ['https://via.placeholder.com/400x300/9C27B0/FFFFFF?text=Gaming+Infra'],
        githubUrl: 'https://github.com/demo/blockchain-gaming-infra',
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        tags: const ['Gaming', 'Unity', 'Polygon', 'Cross-chain'],
        metadata: const {
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

  void setCurrentUser(String userId) {
    _currentUserId = userId;
    notifyListeners();
  }

  Map<String, dynamic> getUserStats(String userId) {
    final userProjects = getUserProjects(userId);
    
    if (userProjects.isEmpty) {
      return const {
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
      'totalValue': 0.0,
    };
  }
}
