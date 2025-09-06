import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/ai_ml_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:intl/intl.dart';

class AIMLScreen extends StatefulWidget {
  const AIMLScreen({super.key});

  @override
  State<AIMLScreen> createState() => _AIMLScreenState();
}

class _AIMLScreenState extends State<AIMLScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AIMLProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'ИИ и Машинное обучение',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Поиск по ИИ и ML...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: 'Ассистенты', icon: Icon(Icons.smart_toy)),
                  Tab(text: 'ML Модели', icon: Icon(Icons.psychology)),
                  Tab(text: 'Аналитика', icon: Icon(Icons.analytics)),
                  Tab(text: 'Автоматизация', icon: Icon(Icons.auto_awesome)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAssistantsTab(),
                  _buildModelsTab(),
                  _buildAnalyticsTab(),
                  _buildAutomationTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement create new AI/ML item dialog
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAssistantsTab() {
    return Consumer<AIMLProvider>(
      builder: (context, provider, child) {
        final assistants = provider.searchAssistants(_searchController.text);
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: assistants.length,
          itemBuilder: (context, index) {
            final assistant = assistants[index];
            return _buildAssistantCard(assistant, provider);
          },
        );
      },
    );
  }

  Widget _buildAssistantCard(AIAssistant assistant, AIMLProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Text(
                      assistant.avatar,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assistant.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(assistant.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(assistant.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          Text(
                            ' ${assistant.rating.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              assistant.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: assistant.capabilities.map((capability) {
                return Chip(
                  label: Text(
                    capability,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: AppTheme.primaryColor),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${assistant.totalConversations} разговоров',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showStartConversationDialog(assistant, provider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Начать разговор'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelsTab() {
    return Consumer<AIMLProvider>(
      builder: (context, provider, child) {
        final models = provider.searchModels(_searchController.text);
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: models.length,
          itemBuilder: (context, index) {
            final model = models[index];
            return _buildModelCard(model, provider);
          },
        );
      },
    );
  }

  Widget _buildModelCard(MLModel model, AIMLProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getModelTypeColor(model.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Icon(
                      _getModelTypeIcon(model.type),
                      color: _getModelTypeColor(model.type),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getModelStatusColor(model.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getModelStatusText(model.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(model.accuracy * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              model.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(
                    model.type.toUpperCase(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: _getModelTypeColor(model.type).withOpacity(0.1),
                  labelStyle: TextStyle(color: _getModelTypeColor(model.type)),
                ),
                const SizedBox(width: 8),
                Text(
                  '${model.totalPredictions} предсказаний',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Обучен: ${DateFormat('dd.MM.yyyy').format(model.lastTrained)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    if (model.status == 'ready')
                      ElevatedButton(
                        onPressed: () {
                          provider.deployModel(model.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Развернуть'),
                      ),
                    if (model.status == 'deployed')
                      ElevatedButton(
                        onPressed: () {
                          _showPredictionDialog(model, provider);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Предсказание'),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return Consumer<AIMLProvider>(
      builder: (context, provider, child) {
        final predictions = provider.predictions;
        
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Предиктивная аналитика',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Запустите ML модели для анализа ваших проектов и получения предсказаний',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        _showNewPredictionDialog(provider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Новое предсказание'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (predictions.isNotEmpty) ...[
              const Text(
                'Последние предсказания',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...predictions.map((prediction) => _buildPredictionCard(prediction)),
            ],
          ],
        );
      },
    );
  }

  Widget _buildPredictionCard(PredictiveResult prediction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getPredictionStatusColor(prediction.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getPredictionStatusText(prediction.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${(prediction.confidence * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Тип: ${_getPredictionTypeText(prediction.predictionType)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Создано: ${DateFormat('dd.MM.yyyy HH:mm').format(prediction.createdAt)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            if (prediction.status == 'completed') ...[
              const SizedBox(height: 16),
              const Text(
                'Результаты:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              ...prediction.predictions.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Text(
                        '${entry.key}: ',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        entry.value.toString(),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAutomationTab() {
    return Consumer<AIMLProvider>(
      builder: (context, provider, child) {
        final workflows = provider.searchWorkflows(_searchController.text);
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: workflows.length,
          itemBuilder: (context, index) {
            final workflow = workflows[index];
            return _buildWorkflowCard(workflow, provider);
          },
        );
      },
    );
  }

  Widget _buildWorkflowCard(AutomationWorkflow workflow, AIMLProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: workflow.isEnabled 
                        ? Colors.green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Icon(
                      workflow.isEnabled ? Icons.play_arrow : Icons.pause,
                      color: workflow.isEnabled ? Colors.green : Colors.grey,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        workflow.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getWorkflowStatusColor(workflow.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getWorkflowStatusText(workflow.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              workflow.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Триггеры:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: workflow.triggers.map((trigger) {
                return Chip(
                  label: Text(
                    trigger,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  labelStyle: const TextStyle(color: Colors.blue),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Действия:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: workflow.actions.map((action) {
                return Chip(
                  label: Text(
                    action,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  labelStyle: const TextStyle(color: Colors.orange),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Выполнений: ${workflow.totalExecutions}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Последний запуск: ${DateFormat('dd.MM.yyyy HH:mm').format(workflow.lastExecuted)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: workflow.isEnabled,
                      onChanged: (value) {
                        provider.toggleWorkflow(workflow.id);
                      },
                      activeColor: AppTheme.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        provider.executeWorkflow(workflow.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Запустить'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'offline':
        return Colors.grey;
      case 'busy':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'online':
        return 'Онлайн';
      case 'offline':
        return 'Оффлайн';
      case 'busy':
        return 'Занят';
      default:
        return 'Неизвестно';
    }
  }

  Color _getModelTypeColor(String type) {
    switch (type) {
      case 'classification':
        return Colors.blue;
      case 'regression':
        return Colors.green;
      case 'clustering':
        return Colors.purple;
      case 'nlp':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getModelTypeIcon(String type) {
    switch (type) {
      case 'classification':
        return Icons.category;
      case 'regression':
        return Icons.trending_up;
      case 'clustering':
        return Icons.group_work;
      case 'nlp':
        return Icons.text_fields;
      default:
        return Icons.psychology;
    }
  }

  Color _getModelStatusColor(String status) {
    switch (status) {
      case 'training':
        return Colors.orange;
      case 'ready':
        return Colors.blue;
      case 'deployed':
        return Colors.green;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getModelStatusText(String status) {
    switch (status) {
      case 'training':
        return 'Обучение';
      case 'ready':
        return 'Готов';
      case 'deployed':
        return 'Развернут';
      case 'archived':
        return 'Архив';
      default:
        return 'Неизвестно';
    }
  }

  Color _getPredictionStatusColor(String status) {
    switch (status) {
      case 'processing':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getPredictionStatusText(String status) {
    switch (status) {
      case 'processing':
        return 'Обработка';
      case 'completed':
        return 'Завершено';
      case 'failed':
        return 'Ошибка';
      default:
        return 'Неизвестно';
    }
  }

  String _getPredictionTypeText(String type) {
    switch (type) {
      case 'success_probability':
        return 'Вероятность успеха';
      case 'market_fit':
        return 'Соответствие рынку';
      case 'funding_needs':
        return 'Потребности в финансировании';
      default:
        return type;
    }
  }

  Color _getWorkflowStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'paused':
        return Colors.orange;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getWorkflowStatusText(String status) {
    switch (status) {
      case 'active':
        return 'Активен';
      case 'paused':
        return 'Приостановлен';
      case 'archived':
        return 'Архив';
      default:
        return 'Неизвестно';
    }
  }

  // Dialog methods
  void _showStartConversationDialog(AIAssistant assistant, AIMLProvider provider) {
    final titleController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Начать разговор с ${assistant.name}'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Тема разговора',
            hintText: 'Введите тему разговора...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                provider.startConversation(assistant.id, titleController.text);
                Navigator.of(context).pop();
                // TODO: Navigate to conversation screen
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Начать'),
          ),
        ],
      ),
    );
  }

  void _showPredictionDialog(MLModel model, AIMLProvider provider) {
    final projectIdController = TextEditingController();
    String selectedType = 'success_probability';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Запустить ${model.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: projectIdController,
              decoration: const InputDecoration(
                labelText: 'ID проекта',
                hintText: 'Введите ID проекта для анализа...',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: 'Тип предсказания',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'success_probability',
                  child: Text('Вероятность успеха'),
                ),
                DropdownMenuItem(
                  value: 'market_fit',
                  child: Text('Соответствие рынку'),
                ),
                DropdownMenuItem(
                  value: 'funding_needs',
                  child: Text('Потребности в финансировании'),
                ),
              ],
              onChanged: (value) {
                selectedType = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (projectIdController.text.isNotEmpty) {
                provider.runPrediction(
                  model.id,
                  projectIdController.text,
                  selectedType,
                );
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Запустить'),
          ),
        ],
      ),
    );
  }

  void _showNewPredictionDialog(AIMLProvider provider) {
    final projectIdController = TextEditingController();
    String selectedModel = provider.models.isNotEmpty ? provider.models.first.id : '';
    String selectedType = 'success_probability';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Новое предсказание'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: selectedModel,
              decoration: const InputDecoration(
                labelText: 'ML модель',
              ),
              items: provider.models.map((model) {
                return DropdownMenuItem(
                  value: model.id,
                  child: Text(model.name),
                );
              }).toList(),
              onChanged: (value) {
                selectedModel = value!;
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: projectIdController,
              decoration: const InputDecoration(
                labelText: 'ID проекта',
                hintText: 'Введите ID проекта для анализа...',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: 'Тип предсказания',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'success_probability',
                  child: Text('Вероятность успеха'),
                ),
                DropdownMenuItem(
                  value: 'market_fit',
                  child: Text('Соответствие рынку'),
                ),
                DropdownMenuItem(
                  value: 'funding_needs',
                  child: Text('Потребности в финансировании'),
                ),
              ],
              onChanged: (value) {
                selectedType = value!;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              if (projectIdController.text.isNotEmpty && selectedModel.isNotEmpty) {
                provider.runPrediction(
                  selectedModel,
                  projectIdController.text,
                  selectedType,
                );
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Запустить'),
          ),
        ],
      ),
    );
  }
}
