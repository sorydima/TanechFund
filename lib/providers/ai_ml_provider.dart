import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// AI Assistant Model
class AIAssistant {
  final String id;
  final String name;
  final String description;
  final String avatar;
  final List<String> capabilities;
  final String status; // 'online', 'offline', 'busy'
  final DateTime lastActive;
  final int totalConversations;
  final double rating;

  AIAssistant({
    required this.id,
    required this.name,
    required this.description,
    required this.avatar,
    required this.capabilities,
    required this.status,
    required this.lastActive,
    required this.totalConversations,
    required this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar': avatar,
      'capabilities': capabilities,
      'status': status,
      'lastActive': lastActive.toIso8601String(),
      'totalConversations': totalConversations,
      'rating': rating,
    };
  }

  factory AIAssistant.fromJson(Map<String, dynamic> json) {
    return AIAssistant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      avatar: json['avatar'],
      capabilities: List<String>.from(json['capabilities']),
      status: json['status'],
      lastActive: DateTime.parse(json['lastActive']),
      totalConversations: json['totalConversations'],
      rating: json['rating'].toDouble(),
    );
  }

  AIAssistant copyWith({
    String? id,
    String? name,
    String? description,
    String? avatar,
    List<String>? capabilities,
    String? status,
    DateTime? lastActive,
    int? totalConversations,
    double? rating,
  }) {
    return AIAssistant(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      avatar: avatar ?? this.avatar,
      capabilities: capabilities ?? this.capabilities,
      status: status ?? this.status,
      lastActive: lastActive ?? this.lastActive,
      totalConversations: totalConversations ?? this.totalConversations,
      rating: rating ?? this.rating,
    );
  }
}

// AI Conversation Model
class AIConversation {
  final String id;
  final String assistantId;
  final String userId;
  final String title;
  final List<AIMessage> messages;
  final DateTime createdAt;
  DateTime lastUpdated;
  String status; // 'active', 'archived', 'deleted'

  AIConversation({
    required this.id,
    required this.assistantId,
    required this.userId,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.lastUpdated,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assistantId': assistantId,
      'userId': userId,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'status': status,
    };
  }

  factory AIConversation.fromJson(Map<String, dynamic> json) {
    return AIConversation(
      id: json['id'],
      assistantId: json['assistantId'],
      userId: json['userId'],
      title: json['title'],
      messages: (json['messages'] as List)
          .map((m) => AIMessage.fromJson(m))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      lastUpdated: DateTime.parse(json['lastUpdated']),
      status: json['status'],
    );
  }

  AIConversation copyWith({
    String? id,
    String? assistantId,
    String? userId,
    String? title,
    List<AIMessage>? messages,
    DateTime? createdAt,
    DateTime? lastUpdated,
    String? status,
  }) {
    return AIConversation(
      id: id ?? this.id,
      assistantId: assistantId ?? this.assistantId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      status: status ?? this.status,
    );
  }
}

// AI Message Model
class AIMessage {
  final String id;
  final String content;
  final String sender; // 'user' or 'assistant'
  final DateTime timestamp;
  final Map<String, dynamic>? metadata; // For attachments, links, etc.

  AIMessage({
    required this.id,
    required this.content,
    required this.sender,
    required this.timestamp,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory AIMessage.fromJson(Map<String, dynamic> json) {
    return AIMessage(
      id: json['id'],
      content: json['content'],
      sender: json['sender'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
    );
  }

  AIMessage copyWith({
    String? id,
    String? content,
    String? sender,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return AIMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }
}

// ML Model for Project Analysis
class MLModel {
  final String id;
  final String name;
  final String description;
  final String type; // 'classification', 'regression', 'clustering', 'nlp'
  String status; // 'training', 'ready', 'deployed', 'archived'
  double accuracy;
  DateTime lastTrained;
  final int totalPredictions;
  final Map<String, dynamic> parameters;

  MLModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.status,
    required this.accuracy,
    required this.lastTrained,
    required this.totalPredictions,
    required this.parameters,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'status': status,
      'accuracy': accuracy,
      'lastTrained': lastTrained.toIso8601String(),
      'totalPredictions': totalPredictions,
      'parameters': parameters,
    };
  }

  factory MLModel.fromJson(Map<String, dynamic> json) {
    return MLModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      status: json['status'],
      accuracy: json['accuracy'].toDouble(),
      lastTrained: DateTime.parse(json['lastTrained']),
      totalPredictions: json['totalPredictions'],
      parameters: Map<String, dynamic>.from(json['parameters']),
    );
  }

  MLModel copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    String? status,
    double? accuracy,
    DateTime? lastTrained,
    int? totalPredictions,
    Map<String, dynamic>? parameters,
  }) {
    return MLModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      accuracy: accuracy ?? this.accuracy,
      lastTrained: lastTrained ?? this.lastTrained,
      totalPredictions: totalPredictions ?? this.totalPredictions,
      parameters: parameters ?? this.parameters,
    );
  }
}

// Predictive Analytics Result
class PredictiveResult {
  final String id;
  final String modelId;
  final String projectId;
  final String predictionType; // 'success_probability', 'market_fit', 'funding_needs'
  final double confidence;
  final Map<String, dynamic> predictions;
  final DateTime createdAt;
  String status; // 'processing', 'completed', 'failed'

  PredictiveResult({
    required this.id,
    required this.modelId,
    required this.projectId,
    required this.predictionType,
    required this.confidence,
    required this.predictions,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelId': modelId,
      'projectId': projectId,
      'predictionType': predictionType,
      'confidence': confidence,
      'predictions': predictions,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory PredictiveResult.fromJson(Map<String, dynamic> json) {
    return PredictiveResult(
      id: json['id'],
      modelId: json['modelId'],
      projectId: json['projectId'],
      predictionType: json['predictionType'],
      confidence: json['confidence'].toDouble(),
      predictions: Map<String, dynamic>.from(json['predictions']),
      createdAt: DateTime.parse(json['createdAt']),
      status: json['status'],
    );
  }

  PredictiveResult copyWith({
    String? id,
    String? modelId,
    String? projectId,
    String? predictionType,
    double? confidence,
    Map<String, dynamic>? predictions,
    DateTime? createdAt,
    String? status,
  }) {
    return PredictiveResult(
      id: id ?? this.id,
      modelId: modelId ?? this.modelId,
      projectId: projectId ?? this.projectId,
      predictionType: predictionType ?? this.predictionType,
      confidence: confidence ?? this.confidence,
      predictions: predictions ?? this.predictions,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}

// Automation Workflow
class AutomationWorkflow {
  final String id;
  final String name;
  final String description;
  final List<String> triggers;
  final List<String> actions;
  String status; // 'active', 'paused', 'archived'
  final DateTime createdAt;
  DateTime lastExecuted;
  int totalExecutions;
  bool isEnabled;

  AutomationWorkflow({
    required this.id,
    required this.name,
    required this.description,
    required this.triggers,
    required this.actions,
    required this.status,
    required this.createdAt,
    required this.lastExecuted,
    required this.totalExecutions,
    required this.isEnabled,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'triggers': triggers,
      'actions': actions,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'lastExecuted': lastExecuted.toIso8601String(),
      'totalExecutions': totalExecutions,
      'isEnabled': isEnabled,
    };
  }

  factory AutomationWorkflow.fromJson(Map<String, dynamic> json) {
    return AutomationWorkflow(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      triggers: List<String>.from(json['triggers']),
      actions: List<String>.from(json['actions']),
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      lastExecuted: DateTime.parse(json['lastExecuted']),
      totalExecutions: json['totalExecutions'],
      isEnabled: json['isEnabled'],
    );
  }

  AutomationWorkflow copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? triggers,
    List<String>? actions,
    String? status,
    DateTime? createdAt,
    DateTime? lastExecuted,
    int? totalExecutions,
    bool? isEnabled,
  }) {
    return AutomationWorkflow(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      triggers: triggers ?? this.triggers,
      actions: actions ?? this.actions,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastExecuted: lastExecuted ?? this.lastExecuted,
      totalExecutions: totalExecutions ?? this.totalExecutions,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

// AI/ML Provider
class AIMLProvider extends ChangeNotifier {
  List<AIAssistant> _assistants = [];
  List<AIConversation> _conversations = [];
  List<MLModel> _models = [];
  List<PredictiveResult> _predictions = [];
  List<AutomationWorkflow> _workflows = [];
  String _currentUserId = 'current_user';

  // Getters
  List<AIAssistant> get assistants => _assistants;
  List<AIConversation> get conversations => _conversations;
  List<MLModel> get models => _models;
  List<PredictiveResult> get predictions => _predictions;
  List<AutomationWorkflow> get workflows => _workflows;

  // Initialize provider
  Future<void> initialize() async {
    await _loadData();
    if (_assistants.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final assistantsJson = prefs.getStringList('ai_assistants') ?? [];
      _assistants = assistantsJson
          .map((json) => AIAssistant.fromJson(jsonDecode(json)))
          .toList();

      final conversationsJson = prefs.getStringList('ai_conversations') ?? [];
      _conversations = conversationsJson
          .map((json) => AIConversation.fromJson(jsonDecode(json)))
          .toList();

      final modelsJson = prefs.getStringList('ml_models') ?? [];
      _models = modelsJson
          .map((json) => MLModel.fromJson(jsonDecode(json)))
          .toList();

      final predictionsJson = prefs.getStringList('predictions') ?? [];
      _predictions = predictionsJson
          .map((json) => PredictiveResult.fromJson(jsonDecode(json)))
          .toList();

      final workflowsJson = prefs.getStringList('automation_workflows') ?? [];
      _workflows = workflowsJson
          .map((json) => AutomationWorkflow.fromJson(jsonDecode(json)))
          .toList();

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading AI/ML data: $e');
      }
    }
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setStringList('ai_assistants', 
          _assistants.map((a) => jsonEncode(a.toJson())).toList());
      
      await prefs.setStringList('ai_conversations', 
          _conversations.map((c) => jsonEncode(c.toJson())).toList());
      
      await prefs.setStringList('ml_models', 
          _models.map((m) => jsonEncode(m.toJson())).toList());
      
      await prefs.setStringList('predictions', 
          _predictions.map((p) => jsonEncode(p.toJson())).toList());
      
      await prefs.setStringList('automation_workflows', 
          _workflows.map((w) => jsonEncode(w.toJson())).toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error saving AI/ML data: $e');
      }
    }
  }

  // Create demo data
  void _createDemoData() {
    // Create AI Assistants
    _assistants = [
      AIAssistant(
        id: '1',
        name: 'Алексей',
        description: 'AI-ассистент для анализа стартапов и инвестиционных возможностей',
        avatar: '🤖',
        capabilities: ['Анализ проектов', 'Финансовое моделирование', 'Рыночные исследования'],
        status: 'online',
        lastActive: DateTime.now(),
        totalConversations: 1247,
        rating: 4.8,
      ),
      AIAssistant(
        id: '2',
        name: 'Мария',
        description: 'Специалист по машинному обучению и предиктивной аналитике',
        avatar: '🧠',
        capabilities: ['ML модели', 'Предиктивная аналитика', 'Автоматизация'],
        status: 'online',
        lastActive: DateTime.now().subtract(const Duration(minutes: 5)),
        totalConversations: 892,
        rating: 4.9,
      ),
      AIAssistant(
        id: '3',
        name: 'Дмитрий',
        description: 'Эксперт по блокчейну и Web3 технологиям',
        avatar: '🔗',
        capabilities: ['Блокчейн анализ', 'Smart contracts', 'DeFi проекты'],
        status: 'busy',
        lastActive: DateTime.now().subtract(const Duration(minutes: 15)),
        totalConversations: 567,
        rating: 4.7,
      ),
    ];

    // Create ML Models
    _models = [
      MLModel(
        id: '1',
        name: 'Startup Success Predictor',
        description: 'Модель для предсказания успеха стартапов на основе множества факторов',
        type: 'classification',
        status: 'deployed',
        accuracy: 0.87,
        lastTrained: DateTime.now().subtract(const Duration(days: 7)),
        totalPredictions: 15420,
        parameters: {
          'algorithm': 'Random Forest',
          'features': 45,
          'training_samples': 50000,
        },
      ),
      MLModel(
        id: '2',
        name: 'Market Fit Analyzer',
        description: 'Анализ соответствия продукта рынку с использованием NLP',
        type: 'nlp',
        status: 'ready',
        accuracy: 0.82,
        lastTrained: DateTime.now().subtract(const Duration(days: 3)),
        totalPredictions: 8230,
        parameters: {
          'algorithm': 'BERT',
          'vocabulary_size': 50000,
          'max_length': 512,
        },
      ),
      MLModel(
        id: '3',
        name: 'Funding Needs Estimator',
        description: 'Оценка потребностей в финансировании для стартапов',
        type: 'regression',
        status: 'training',
        accuracy: 0.79,
        lastTrained: DateTime.now().subtract(const Duration(hours: 2)),
        totalPredictions: 0,
        parameters: {
          'algorithm': 'Gradient Boosting',
          'features': 28,
          'training_samples': 25000,
        },
      ),
    ];

    // Create Automation Workflows
    _workflows = [
      AutomationWorkflow(
        id: '1',
        name: 'Автоматический анализ новых проектов',
        description: 'Автоматически анализирует новые проекты и создает отчеты',
        triggers: ['Новый проект добавлен', 'Обновление проекта'],
        actions: ['Запуск ML анализа', 'Создание отчета', 'Уведомление команды'],
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastExecuted: DateTime.now().subtract(const Duration(hours: 2)),
        totalExecutions: 156,
        isEnabled: true,
      ),
      AutomationWorkflow(
        id: '2',
        name: 'Мониторинг рыночных трендов',
        description: 'Отслеживает рыночные тренды и обновляет рекомендации',
        triggers: ['Ежедневно в 9:00', 'Изменение трендов >10%'],
        actions: ['Сбор данных', 'Анализ трендов', 'Обновление рекомендаций'],
        status: 'active',
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
        lastExecuted: DateTime.now().subtract(const Duration(hours: 8)),
        totalExecutions: 89,
        isEnabled: true,
      ),
      AutomationWorkflow(
        id: '3',
        name: 'Автоматическое создание отчетов',
        description: 'Генерирует еженедельные отчеты по портфелю проектов',
        triggers: ['Каждое воскресенье в 18:00'],
        actions: ['Сбор данных', 'Генерация отчета', 'Отправка email'],
        status: 'paused',
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        lastExecuted: DateTime.now().subtract(const Duration(days: 7)),
        totalExecutions: 12,
        isEnabled: false,
      ),
    ];

    // Create sample conversations
    _conversations = [
      AIConversation(
        id: '1',
        assistantId: '1',
        userId: _currentUserId,
        title: 'Анализ проекта DeFi протокола',
        messages: [
          AIMessage(
            id: '1',
            content: 'Привет! Мне нужно проанализировать новый DeFi проект. Можешь помочь?',
            sender: 'user',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          AIMessage(
            id: '2',
            content: 'Конечно! Я помогу вам проанализировать DeFi проект. Расскажите подробнее о проекте: какую проблему он решает, какая у него токеномика, и есть ли уже MVP?',
            sender: 'assistant',
            timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 1)),
          ),
        ],
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2, minutes: 1)),
        status: 'active',
      ),
    ];

    // Create sample predictions
    _predictions = [
      PredictiveResult(
        id: '1',
        modelId: '1',
        projectId: 'sample_project_1',
        predictionType: 'success_probability',
        confidence: 0.87,
        predictions: {
          'success_probability': 0.73,
          'time_to_market': '8-12 месяцев',
          'funding_needs': '500K-1M USD',
          'risk_factors': ['Конкуренция', 'Регулятивные риски'],
        },
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        status: 'completed',
      ),
    ];

    _saveData();
    notifyListeners();
  }

  // AI Assistant methods
  Future<void> startConversation(String assistantId, String title) async {
    final conversation = AIConversation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      assistantId: assistantId,
      userId: _currentUserId,
      title: title,
      messages: [],
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      status: 'active',
    );

    _conversations.add(conversation);
    await _saveData();
    notifyListeners();
  }

  Future<void> sendMessage(String conversationId, String content) async {
    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex == -1) return;

    final userMessage = AIMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      sender: 'user',
      timestamp: DateTime.now(),
    );

    _conversations[conversationIndex].messages.add(userMessage);

    // Simulate AI response
    final assistantResponse = AIMessage(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      content: _generateAIResponse(content),
      sender: 'assistant',
      timestamp: DateTime.now().add(const Duration(seconds: 1)),
    );

    _conversations[conversationIndex].messages.add(assistantResponse);
    _conversations[conversationIndex].lastUpdated = DateTime.now();

    await _saveData();
    notifyListeners();
  }

  String _generateAIResponse(String userMessage) {
    // Simple response generation logic
    final responses = [
      'Отличный вопрос! Давайте разберем это подробнее.',
      'Это интересная тема. У меня есть несколько рекомендаций...',
      'Спасибо за вопрос. Позвольте мне проанализировать ситуацию...',
      'Отличная идея! Давайте рассмотрим возможные варианты реализации.',
      'Это важный аспект. Позвольте поделиться своим опытом...',
    ];
    
    return responses[Random().nextInt(responses.length)];
  }

  Future<void> archiveConversation(String conversationId) async {
    final conversationIndex = _conversations.indexWhere((c) => c.id == conversationId);
    if (conversationIndex == -1) return;

    _conversations[conversationIndex].status = 'archived';
    await _saveData();
    notifyListeners();
  }

  // ML Model methods
  Future<void> trainModel(String modelId) async {
    final modelIndex = _models.indexWhere((m) => m.id == modelId);
    if (modelIndex == -1) return;

    _models[modelIndex].status = 'training';
    notifyListeners();

    // Simulate training process
    await Future.delayed(const Duration(seconds: 2));
    
    _models[modelIndex].status = 'ready';
    _models[modelIndex].lastTrained = DateTime.now();
    _models[modelIndex].accuracy = 0.79 + Random().nextDouble() * 0.15;
    
    await _saveData();
    notifyListeners();
  }

  Future<void> deployModel(String modelId) async {
    final modelIndex = _models.indexWhere((m) => m.id == modelId);
    if (modelIndex == -1) return;

    _models[modelIndex].status = 'deployed';
    await _saveData();
    notifyListeners();
  }

  // Predictive Analytics methods
  Future<PredictiveResult> runPrediction(String modelId, String projectId, String predictionType) async {
    final prediction = PredictiveResult(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      modelId: modelId,
      projectId: projectId,
      predictionType: predictionType,
      confidence: 0.75 + Random().nextDouble() * 0.2,
      predictions: _generatePredictions(predictionType),
      createdAt: DateTime.now(),
      status: 'processing',
    );

    _predictions.add(prediction);
    notifyListeners();

    // Simulate processing
    await Future.delayed(const Duration(seconds: 3));
    
    prediction.status = 'completed';
    await _saveData();
    notifyListeners();

    return prediction;
  }

  Map<String, dynamic> _generatePredictions(String predictionType) {
    switch (predictionType) {
      case 'success_probability':
        return {
          'success_probability': 0.6 + Random().nextDouble() * 0.3,
          'time_to_market': '${6 + Random().nextInt(12)} месяцев',
          'funding_needs': '${100 + Random().nextInt(900)}K USD',
          'risk_factors': ['Конкуренция', 'Регулятивные риски', 'Технические вызовы'],
        };
      case 'market_fit':
        return {
          'market_fit_score': 0.7 + Random().nextDouble() * 0.25,
          'target_audience_size': '${100 + Random().nextInt(900)}K пользователей',
          'market_growth_rate': '${15 + Random().nextInt(35)}% в год',
          'competitive_advantage': 'Уникальная технология',
          'patent_protection': 'Патентная защита',
        };
      default:
        return {
          'prediction': 'Данные анализируются...',
          'confidence': 0.8,
        };
    }
  }

  // Automation Workflow methods
  Future<void> toggleWorkflow(String workflowId) async {
    final workflowIndex = _workflows.indexWhere((w) => w.id == workflowId);
    if (workflowIndex == -1) return;

    _workflows[workflowIndex].isEnabled = !_workflows[workflowIndex].isEnabled;
    _workflows[workflowIndex].status = _workflows[workflowIndex].isEnabled ? 'active' : 'paused';
    
    await _saveData();
    notifyListeners();
  }

  Future<void> executeWorkflow(String workflowId) async {
    final workflowIndex = _workflows.indexWhere((w) => w.id == workflowId);
    if (workflowIndex == -1) return;

    _workflows[workflowIndex].lastExecuted = DateTime.now();
    _workflows[workflowIndex].totalExecutions++;
    
    await _saveData();
    notifyListeners();
  }

  // Search methods
  List<AIAssistant> searchAssistants(String query) {
    if (query.isEmpty) return _assistants;
    
    return _assistants.where((assistant) =>
        assistant.name.toLowerCase().contains(query.toLowerCase()) ||
        assistant.description.toLowerCase().contains(query.toLowerCase()) ||
        assistant.capabilities.any((capability) =>
            capability.toLowerCase().contains(query.toLowerCase()))).toList();
  }

  List<MLModel> searchModels(String query) {
    if (query.isEmpty) return _models;
    
    return _models.where((model) =>
        model.name.toLowerCase().contains(query.toLowerCase()) ||
        model.description.toLowerCase().contains(query.toLowerCase()) ||
        model.type.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<AutomationWorkflow> searchWorkflows(String query) {
    if (query.isEmpty) return _workflows;
    
    return _workflows.where((workflow) =>
        workflow.name.toLowerCase().contains(query.toLowerCase()) ||
        workflow.description.toLowerCase().contains(query.toLowerCase()) ||
        workflow.triggers.any((trigger) =>
            trigger.toLowerCase().contains(query.toLowerCase()))).toList();
  }

  // Utility methods
  void setCurrentUser(String userId) {
    _currentUserId = userId;
  }

  List<AIConversation> getUserConversations(String userId) {
    return _conversations.where((c) => c.userId == userId).toList();
  }

  List<PredictiveResult> getProjectPredictions(String projectId) {
    return _predictions.where((p) => p.projectId == projectId).toList();
  }
}
