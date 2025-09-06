import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart'; // Added to fix IconData errors

// Intro Screen Model (Renamed to AppIntroScreen to avoid conflict with widget)
class AppIntroScreen { // Renamed from IntroScreen
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final IconData icon;
  final List<String> features;
  final bool isRequired;
  final int order;

  AppIntroScreen({ // Renamed constructor
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.icon,
    required this.features,
    required this.isRequired,
    required this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'icon': icon.codePoint,
      'features': features,
      'isRequired': isRequired,
      'order': order,
    };
  }

  factory AppIntroScreen.fromJson(Map<String, dynamic> json) { // Renamed factory
    return AppIntroScreen( // Renamed
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      features: List<String>.from(json['features']),
      isRequired: json['isRequired'],
      order: json['order'],
    );
  }
}

// Feature Category
class FeatureCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final List<String> features;
  final int order;

  FeatureCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.features,
    required this.order,
  });
}

// Navigation Guide
class NavigationGuide {
  final String id;
  final String title;
  final String description;
  final String tip;
  final IconData icon;
  final int order;

  NavigationGuide({
    required this.id,
    required this.title,
    required this.description,
    required this.tip,
    required this.icon,
    required this.order,
  });
}

// Intro Provider
class IntroProvider extends ChangeNotifier {
  List<AppIntroScreen> _introScreens = [];
  List<FeatureCategory> _featureCategories = [];
  List<NavigationGuide> _navigationGuides = [];
  bool _isIntroCompleted = false;
  int _currentIntroIndex = 0;

  // Getters
  List<AppIntroScreen> get introScreens => _introScreens;
  List<FeatureCategory> get featureCategories => _featureCategories;
  List<NavigationGuide> get navigationGuides => _navigationGuides;
  bool get isIntroCompleted => _isIntroCompleted;
  int get currentIntroIndex => _currentIntroIndex;

  // Initialize
  Future<void> initialize() async {
    await _loadData();
    if (_introScreens.isEmpty) {
      _createIntroData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final introCompleted = prefs.getBool('intro_completed') ?? false;
    _isIntroCompleted = introCompleted;

    final currentIndex = prefs.getInt('current_intro_index') ?? 0;
    _currentIntroIndex = currentIndex;

    notifyListeners();
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_completed', _isIntroCompleted);
    await prefs.setInt('current_intro_index', _currentIntroIndex);
  }

  // Create intro data
  void _createIntroData() {
    // Intro Screens
    _introScreens = [
      AppIntroScreen(
        id: 'welcome',
        title: 'Добро пожаловать в REChain®️ VC Lab',
        description: 'Экосистема нового поколения для создания венчурных проектов, инкубации и стартап-студии',
        imageUrl: 'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Welcome',
        icon: Icons.rocket_launch,
        features: [
          'Создание венчурных проектов',
          'Инкубация стартапов',
          'Стартап-студия',
          'Модель синдиката',
          'Блокчейн-решения',
          'Индивидуальное наставничество',
          'Инновационное финансирование',
        ],
        isRequired: true,
        order: 1,
      ),
      AppIntroScreen(
        id: 'navigation',
        title: 'Навигация по приложению',
        description: 'Изучите основные разделы и функции платформы',
        imageUrl: 'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Navigation',
        icon: Icons.navigation,
        features: [
          'Горизонтальная прокрутка вкладок',
          '26 основных разделов',
          'Быстрый доступ к функциям',
          'Индикатор текущей вкладки',
          'Автоматическая прокрутка',
        ],
        isRequired: true,
        order: 2,
      ),
      AppIntroScreen(
        id: 'core_features',
        title: 'Основные возможности',
        description: 'Ключевые функции для работы с проектами и инвестициями',
        imageUrl: 'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=Features',
        icon: Icons.star,
        features: [
          'Управление портфолио',
          'Инвестиционные раунды',
          'Менторство и обучение',
          'Аналитика и отчеты',
          'Социальная сеть',
          'Хакатоны и челленджи',
        ],
        isRequired: true,
        order: 3,
      ),
      AppIntroScreen(
        id: 'web3_features',
        title: 'Web3 & DeFi функции',
        description: 'Продвинутые возможности блокчейн-технологий',
        imageUrl: 'https://via.placeholder.com/300x200/9C27B0/FFFFFF?text=Web3',
        icon: Icons.block,
        features: [
          'NFT Marketplace',
          'DeFi протоколы',
          'Cross-chain мосты',
          'Hardware кошельки',
          'DEX торговля',
          'Yield Farming',
          'DAO управление',
        ],
        isRequired: false,
        order: 4,
      ),
      AppIntroScreen(
        id: 'advanced_features',
        title: 'Продвинутые функции',
        description: 'Специализированные платформы для различных отраслей',
        imageUrl: 'https://via.placeholder.com/300x200/F44336/FFFFFF?text=Advanced',
        icon: Icons.psychology,
        features: [
          'AI/ML платформа',
          'Метавселенная',
          'Web3 Identity',
          'Gaming & Play-to-Earn',
          'Образование',
          'Здравоохранение',
        ],
        isRequired: false,
        order: 5,
      ),
    ];

    // Feature Categories
    _featureCategories = [
      FeatureCategory(
        id: 'core',
        name: 'Основные функции',
        description: 'Базовые возможности для работы с проектами',
        icon: Icons.home,
        features: [
          'Главная страница',
          'Портфолио проектов',
          'Инвестиционные раунды',
          'Менторство',
          'Обучение',
          'Хакатоны',
          'Челленджи',
        ],
        order: 1,
      ),
      FeatureCategory(
        id: 'analytics',
        name: 'Аналитика и отчеты',
        description: 'Инструменты для анализа и мониторинга',
        icon: Icons.analytics,
        features: [
          'Аналитика проектов',
          'Социальная сеть',
          'Метавселенная',
          'AI/ML платформа',
        ],
        order: 2,
      ),
      FeatureCategory(
        id: 'blockchain',
        name: 'Блокчейн и DeFi',
        description: 'Web3 технологии и децентрализованные финансы',
        icon: Icons.block,
        features: [
          'Блокчейн DeFi',
          'NFT Marketplace',
          'Cross-chain мосты',
          'Hardware кошельки',
          'DEX торговля',
          'Yield Farming',
          'DAO управление',
        ],
        order: 3,
      ),
      FeatureCategory(
        id: 'specialized',
        name: 'Специализированные платформы',
        description: 'Отраслевые решения и нишевые функции',
        icon: Icons.psychology,
        features: [
          'Web3 Identity',
          'Gaming & Play-to-Earn',
          'Образование',
          'Здравоохранение',
        ],
        order: 4,
      ),
    ];

    // Navigation Guides
    _navigationGuides = [
      NavigationGuide(
        id: 'horizontal_scroll',
        title: 'Горизонтальная прокрутка',
        description: 'Используйте горизонтальную прокрутку для навигации между вкладками',
        tip: '💡 Прокручивайте влево/вправо для доступа ко всем разделам',
        icon: Icons.swap_horiz,
        order: 1,
      ),
      NavigationGuide(
        id: 'tab_indicator',
        title: 'Индикатор вкладок',
        description: 'Следите за текущей позицией с помощью индикатора внизу',
        tip: '💡 Точки показывают общее количество разделов (26)',
        icon: Icons.more_horiz,
        order: 2,
      ),
      NavigationGuide(
        id: 'auto_scroll',
        title: 'Автоматическая прокрутка',
        description: 'При выборе вкладки происходит автоматическая прокрутка к ней',
        tip: '💡 Выбранная вкладка автоматически центрируется на экране',
        icon: Icons.center_focus_strong,
        order: 3,
      ),
      NavigationGuide(
        id: 'quick_access',
        title: 'Быстрый доступ',
        description: 'Основные функции доступны с главной страницы',
        tip: '💡 Используйте плавающую кнопку уведомлений для быстрого доступа',
        icon: Icons.notifications,
        order: 4,
      ),
      NavigationGuide(
        id: 'search_function',
        title: 'Поиск и фильтрация',
        description: 'Во многих разделах доступен поиск и фильтрация',
        tip: '💡 Используйте поиск для быстрого нахождения нужной информации',
        icon: Icons.search,
        order: 5,
      ),
    ];

    notifyListeners();
  }

  // Intro Management
  void nextIntro() {
    if (_currentIntroIndex < _introScreens.length - 1) {
      _currentIntroIndex++;
      _saveData();
      notifyListeners();
    }
  }

  void previousIntro() {
    if (_currentIntroIndex > 0) {
      _currentIntroIndex--;
      _saveData();
      notifyListeners();
    }
  }

  void goToIntro(int index) {
    if (index >= 0 && index < _introScreens.length) {
      _currentIntroIndex = index;
      _saveData();
      notifyListeners();
    }
  }

  void completeIntro() {
    _isIntroCompleted = true;
    _saveData();
    notifyListeners();
  }

  void resetIntro() {
    _isIntroCompleted = false;
    _currentIntroIndex = 0;
    _saveData();
    notifyListeners();
  }

  // Get current intro screen
  AppIntroScreen? get currentIntroScreen {
    if (_currentIntroIndex >= 0 && _currentIntroIndex < _introScreens.length) {
      return _introScreens[_currentIntroIndex];
    }
    return null;
  }

  // Check if intro is at the beginning
  bool get isAtBeginning => _currentIntroIndex == 0;

  // Check if intro is at the end
  bool get isAtEnd => _currentIntroIndex == _introScreens.length - 1;

  // Get progress percentage
  double get progressPercentage {
    if (_introScreens.isEmpty) return 0.0;
    return (_currentIntroIndex + 1) / _introScreens.length;
  }

  // Get intro count
  int get totalIntroScreens => _introScreens.length;

  // Get required intro screens
  List<AppIntroScreen> get requiredIntroScreens {
    return _introScreens.where((screen) => screen.isRequired).toList();
  }

  // Get optional intro screens
  List<AppIntroScreen> get optionalIntroScreens {
    return _introScreens.where((screen) => !screen.isRequired).toList();
  }
}
