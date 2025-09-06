import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

// Модели для аналитики
class InvestmentMetrics {
  final double totalInvested;
  final double totalReturn;
  final double roi;
  final int activeInvestments;
  final int completedInvestments;
  final double averageReturn;
  final DateTime lastUpdated;

  InvestmentMetrics({
    required this.totalInvested,
    required this.totalReturn,
    required this.roi,
    required this.activeInvestments,
    required this.completedInvestments,
    required this.averageReturn,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'totalInvested': totalInvested,
    'totalReturn': totalReturn,
    'roi': roi,
    'activeInvestments': activeInvestments,
    'completedInvestments': completedInvestments,
    'averageReturn': averageReturn,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory InvestmentMetrics.fromJson(Map<String, dynamic> json) => InvestmentMetrics(
    totalInvested: json['totalInvested'].toDouble(),
    totalReturn: json['totalReturn'].toDouble(),
    roi: json['roi'].toDouble(),
    activeInvestments: json['activeInvestments'],
    completedInvestments: json['completedInvestments'],
    averageReturn: json['averageReturn'].toDouble(),
    lastUpdated: DateTime.parse(json['lastUpdated']),
  );
}

class ProjectProgress {
  final String projectId;
  final String projectName;
  final double completionPercentage;
  final double budgetUtilization;
  final int milestonesCompleted;
  final int totalMilestones;
  final DateTime startDate;
  final DateTime? expectedCompletion;
  final String status;

  ProjectProgress({
    required this.projectId,
    required this.projectName,
    required this.completionPercentage,
    required this.budgetUtilization,
    required this.milestonesCompleted,
    required this.totalMilestones,
    required this.startDate,
    this.expectedCompletion,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'projectId': projectId,
    'projectName': projectName,
    'completionPercentage': completionPercentage,
    'budgetUtilization': budgetUtilization,
    'milestonesCompleted': milestonesCompleted,
    'totalMilestones': totalMilestones,
    'startDate': startDate.toIso8601String(),
    'expectedCompletion': expectedCompletion?.toIso8601String(),
    'status': status,
  };

  factory ProjectProgress.fromJson(Map<String, dynamic> json) => ProjectProgress(
    projectId: json['projectId'],
    projectName: json['projectName'],
    completionPercentage: json['completionPercentage'].toDouble(),
    budgetUtilization: json['budgetUtilization'].toDouble(),
    milestonesCompleted: json['milestonesCompleted'],
    totalMilestones: json['totalMilestones'],
    startDate: DateTime.parse(json['startDate']),
    expectedCompletion: json['expectedCompletion'] != null 
        ? DateTime.parse(json['expectedCompletion']) 
        : null,
    status: json['status'],
  );
}

class ChartDataPoint {
  final DateTime date;
  final double value;
  final String label;

  ChartDataPoint({
    required this.date,
    required this.value,
    required this.label,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'value': value,
    'label': label,
  };

  factory ChartDataPoint.fromJson(Map<String, dynamic> json) => ChartDataPoint(
    date: DateTime.parse(json['date']),
    value: json['value'].toDouble(),
    label: json['label'],
  );
}

class PortfolioPerformance {
  final List<ChartDataPoint> roiHistory;
  final List<ChartDataPoint> investmentGrowth;
  final List<ChartDataPoint> monthlyReturns;
  final double volatility;
  final double sharpeRatio;
  final double maxDrawdown;

  PortfolioPerformance({
    required this.roiHistory,
    required this.investmentGrowth,
    required this.monthlyReturns,
    required this.volatility,
    required this.sharpeRatio,
    required this.maxDrawdown,
  });

  Map<String, dynamic> toJson() => {
    'roiHistory': roiHistory.map((e) => e.toJson()).toList(),
    'investmentGrowth': investmentGrowth.map((e) => e.toJson()).toList(),
    'monthlyReturns': monthlyReturns.map((e) => e.toJson()).toList(),
    'volatility': volatility,
    'sharpeRatio': sharpeRatio,
    'maxDrawdown': maxDrawdown,
  };

  factory PortfolioPerformance.fromJson(Map<String, dynamic> json) => PortfolioPerformance(
    roiHistory: (json['roiHistory'] as List)
        .map((e) => ChartDataPoint.fromJson(e))
        .toList(),
    investmentGrowth: (json['investmentGrowth'] as List)
        .map((e) => ChartDataPoint.fromJson(e))
        .toList(),
    monthlyReturns: (json['monthlyReturns'] as List)
        .map((e) => ChartDataPoint.fromJson(e))
        .toList(),
    volatility: json['volatility'].toDouble(),
    sharpeRatio: json['sharpeRatio'].toDouble(),
    maxDrawdown: json['maxDrawdown'].toDouble(),
  );
}

class AnalyticsProvider extends ChangeNotifier {
  InvestmentMetrics? _investmentMetrics;
  List<ProjectProgress> _projectProgress = [];
  PortfolioPerformance? _portfolioPerformance;
  bool _isLoading = false;

  // Геттеры
  InvestmentMetrics? get investmentMetrics => _investmentMetrics;
  List<ProjectProgress> get projectProgress => _projectProgress;
  PortfolioPerformance? get portfolioPerformance => _portfolioPerformance;
  bool get isLoading => _isLoading;

  // Инициализация
  Future<void> initialize() async {
    await _loadData();
    if (_investmentMetrics == null) {
      _createDemoData();
    }
  }

  // Загрузка данных
  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Загрузка метрик инвестиций
      final metricsJson = prefs.getString('investment_metrics');
      if (metricsJson != null) {
        _investmentMetrics = InvestmentMetrics.fromJson(jsonDecode(metricsJson));
      }
      
      // Загрузка прогресса проектов
      final progressJson = prefs.getStringList('project_progress') ?? [];
      _projectProgress = progressJson
          .map((json) => ProjectProgress.fromJson(jsonDecode(json)))
          .toList();
      
      // Загрузка производительности портфолио
      final performanceJson = prefs.getString('portfolio_performance');
      if (performanceJson != null) {
        _portfolioPerformance = PortfolioPerformance.fromJson(jsonDecode(performanceJson));
      }
    } catch (e) {
      debugPrint('Ошибка загрузки аналитических данных: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Сохранение данных
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Сохранение метрик инвестиций
      if (_investmentMetrics != null) {
        await prefs.setString('investment_metrics', jsonEncode(_investmentMetrics!.toJson()));
      }
      
      // Сохранение прогресса проектов
      final progressJson = _projectProgress
          .map((p) => jsonEncode(p.toJson()))
          .toList();
      await prefs.setStringList('project_progress', progressJson);
      
      // Сохранение производительности портфолио
      if (_portfolioPerformance != null) {
        await prefs.setString('portfolio_performance', jsonEncode(_portfolioPerformance!.toJson()));
      }
    } catch (e) {
      debugPrint('Ошибка сохранения аналитических данных: $e');
    }
  }

  // Создание демо-данных
  void _createDemoData() {
    // Демо-метрики инвестиций
    _investmentMetrics = InvestmentMetrics(
      totalInvested: 2500000.0,
      totalReturn: 3750000.0,
      roi: 50.0,
      activeInvestments: 8,
      completedInvestments: 12,
      averageReturn: 25.0,
      lastUpdated: DateTime.now(),
    );

    // Демо-прогресс проектов
    _projectProgress = [
      ProjectProgress(
        projectId: '1',
        projectName: 'DeFi Protocol Alpha',
        completionPercentage: 0.75,
        budgetUtilization: 0.68,
        milestonesCompleted: 6,
        totalMilestones: 8,
        startDate: DateTime.now().subtract(const Duration(days: 90)),
        expectedCompletion: DateTime.now().add(const Duration(days: 30)),
        status: 'В разработке',
      ),
      ProjectProgress(
        projectId: '2',
        projectName: 'NFT Marketplace',
        completionPercentage: 0.45,
        budgetUtilization: 0.52,
        milestonesCompleted: 4,
        totalMilestones: 9,
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        expectedCompletion: DateTime.now().add(const Duration(days: 90)),
        status: 'В разработке',
      ),
      ProjectProgress(
        projectId: '3',
        projectName: 'Blockchain Explorer',
        completionPercentage: 0.90,
        budgetUtilization: 0.85,
        milestonesCompleted: 9,
        totalMilestones: 10,
        startDate: DateTime.now().subtract(const Duration(days: 120)),
        expectedCompletion: DateTime.now().add(const Duration(days: 10)),
        status: 'Завершается',
      ),
    ];

    // Демо-производительность портфолио
    _portfolioPerformance = PortfolioPerformance(
      roiHistory: _generateChartData(12, 15.0, 50.0, 'ROI'),
      investmentGrowth: _generateChartData(12, 2000000.0, 4000000.0, 'Инвестиции'),
      monthlyReturns: _generateChartData(12, -5.0, 15.0, 'Доходность'),
      volatility: 12.5,
      sharpeRatio: 1.8,
      maxDrawdown: -8.2,
    );

    _saveData();
  }

  // Генерация демо-данных для графиков
  List<ChartDataPoint> _generateChartData(int months, double minValue, double maxValue, String label) {
    final random = Random(42); // Фиксированный seed для воспроизводимости
    final List<ChartDataPoint> data = [];
    
    for (int i = months - 1; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i * 30));
      final value = minValue + random.nextDouble() * (maxValue - minValue);
      data.add(ChartDataPoint(
        date: date,
        value: value,
        label: label,
      ));
    }
    
    return data;
  }

  // Обновление метрик
  Future<void> updateInvestmentMetrics(InvestmentMetrics metrics) async {
    _investmentMetrics = metrics;
    await _saveData();
    notifyListeners();
  }

  // Добавление прогресса проекта
  Future<void> addProjectProgress(ProjectProgress progress) async {
    _projectProgress.add(progress);
    await _saveData();
    notifyListeners();
  }

  // Обновление прогресса проекта
  Future<void> updateProjectProgress(ProjectProgress progress) async {
    final index = _projectProgress.indexWhere((p) => p.projectId == progress.projectId);
    if (index != -1) {
      _projectProgress[index] = progress;
      await _saveData();
      notifyListeners();
    }
  }

  // Получение топ проектов по прогрессу
  List<ProjectProgress> getTopProjectsByProgress({int limit = 5}) {
    final sorted = List<ProjectProgress>.from(_projectProgress);
    sorted.sort((a, b) => b.completionPercentage.compareTo(a.completionPercentage));
    return sorted.take(limit).toList();
  }

  // Получение проектов по статусу
  List<ProjectProgress> getProjectsByStatus(String status) {
    return _projectProgress.where((p) => p.status == status).toList();
  }

  // Расчет общего ROI портфолио
  double getPortfolioROI() {
    if (_investmentMetrics == null) return 0.0;
    return _investmentMetrics!.roi;
  }

  // Получение метрик за период
  InvestmentMetrics? getMetricsForPeriod(DateTime startDate, DateTime endDate) {
    // Здесь можно добавить логику фильтрации по датам
    return _investmentMetrics;
  }
}
