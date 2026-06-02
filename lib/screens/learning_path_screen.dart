import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Learning Path — индивидуальный путь обучения с этапами
class LearningPathScreen extends StatefulWidget {
  const LearningPathScreen({super.key});

  @override
  State<LearningPathScreen> createState() => _LearningPathScreenState();
}

class _LearningPathScreenState extends State<LearningPathScreen> {
  String _selectedPath = 'blockchain';

  final List<Map<String, dynamic>> _learningPaths = [
    {
      'id': 'blockchain',
      'title': 'Блокчейн Разработчик',
      'icon': Icons.code,
      'color': Colors.blue,
      'duration': '6 месяцев',
      'courses': 12,
      'progress': 35,
      'stages': [
        {
          'id': '1',
          'title': 'Основы блокчейна',
          'description': 'Базовые концепции и терминология',
          'icon': Icons.star,
          'completed': true,
          'courses': [
            {'title': 'Введение в блокчейн', 'duration': '4ч', 'completed': true},
            {'title': 'Криптография основы', 'duration': '3ч', 'completed': true},
          ],
        },
        {
          'id': '2',
          'title': 'Смарт-контракты',
          'description': 'Разработка на Solidity',
          'icon': Icons.account_balance_wallet,
          'completed': false,
          'current': true,
          'courses': [
            {'title': 'Solidity основы', 'duration': '8ч', 'completed': true},
            {'title': 'Разработка контрактов', 'duration': '12ч', 'completed': false},
            {'title': 'Тестирование контрактов', 'duration': '6ч', 'completed': false},
          ],
        },
        {
          'id': '3',
          'title': 'DeFi Протоколы',
          'description': 'Децентрализованные финансы',
          'icon': Icons.account_balance,
          'completed': false,
          'courses': [
            {'title': 'DeFi основы', 'duration': '6ч', 'completed': false},
            {'title': 'AMM и DEX', 'duration': '8ч', 'completed': false},
          ],
        },
        {
          'id': '4',
          'title': 'NFT и Метавселенная',
          'description': 'Токены и виртуальные миры',
          'icon': Icons.image,
          'completed': false,
          'courses': [
            {'title': 'NFT стандарты', 'duration': '5ч', 'completed': false},
            {'title': 'Метавселенные', 'duration': '4ч', 'completed': false},
          ],
        },
        {
          'id': '5',
          'title': 'Продвинутые темы',
          'description': 'Масштабирование и оптимизация',
          'icon': Icons.trending_up,
          'completed': false,
          'courses': [
            {'title': 'Layer 2 решения', 'duration': '8ч', 'completed': false},
            {'title': 'Оптимизация газа', 'duration': '6ч', 'completed': false},
          ],
        },
        {
          'id': '6',
          'title': 'Финальный проект',
          'description': 'Полноценное dApp приложение',
          'icon': Icons.work,
          'completed': false,
          'courses': [
            {'title': 'Проектирование dApp', 'duration': '10ч', 'completed': false},
            {'title': 'Реализация проекта', 'duration': '20ч', 'completed': false},
          ],
        },
      ],
    },
    {
      'id': 'investor',
      'title': 'Крипто Инвестор',
      'icon': Icons.trending_up,
      'color': Colors.green,
      'duration': '3 месяца',
      'courses': 8,
      'progress': 60,
      'stages': [
        {
          'id': '1',
          'title': 'Основы инвестирования',
          'description': 'Базовые принципы',
          'icon': Icons.school,
          'completed': true,
          'courses': [
            {'title': 'Введение в криптовалюты', 'duration': '3ч', 'completed': true},
            {'title': 'Управление рисками', 'duration': '4ч', 'completed': true},
          ],
        },
        {
          'id': '2',
          'title': 'Анализ проектов',
          'description': 'Фундаментальный анализ',
          'icon': Icons.analytics,
          'completed': true,
          'current': true,
          'courses': [
            {'title': 'Tokenomics', 'duration': '5ч', 'completed': true},
            {'title': 'Оценка проектов', 'duration': '6ч', 'completed': false},
          ],
        },
        {
          'id': '3',
          'title': 'DeFi Стратегии',
          'description': 'Пассивный доход',
          'icon': Icons.savings,
          'completed': false,
          'courses': [
            {'title': 'Стейкинг', 'duration': '4ч', 'completed': false},
            {'title': 'Фарминг', 'duration': '5ч', 'completed': false},
          ],
        },
        {
          'id': '4',
          'title': 'Портфолио менеджмент',
          'description': 'Управление активами',
          'icon': Icons.pie_chart,
          'completed': false,
          'courses': [
            {'title': 'Диверсификация', 'duration': '4ч', 'completed': false},
            {'title': 'Ребалансировка', 'duration': '3ч', 'completed': false},
          ],
        },
      ],
    },
    {
      'id': 'trader',
      'title': 'Крипто Трейдер',
      'icon': Icons.show_chart,
      'color': Colors.orange,
      'duration': '4 месяца',
      'courses': 10,
      'progress': 15,
      'stages': [
        {
          'id': '1',
          'title': 'Основы трейдинга',
          'description': 'Базовые концепции',
          'icon': Icons.trending_up,
          'completed': true,
          'courses': [
            {'title': 'Введение в трейдинг', 'duration': '4ч', 'completed': true},
            {'title': 'Технический анализ', 'duration': '6ч', 'completed': false},
          ],
        },
        {
          'id': '2',
          'title': 'Торговые стратегии',
          'description': 'Тактики и подходы',
          'icon': Icons.analytics,
          'completed': false,
          'current': true,
          'courses': [
            {'title': 'Day Trading', 'duration': '5ч', 'completed': false},
            {'title': 'Swing Trading', 'duration': '5ч', 'completed': false},
          ],
        },
        {
          'id': '3',
          'title': 'Риск менеджмент',
          'description': 'Управление рисками',
          'icon': Icons.shield,
          'completed': false,
          'courses': [
            {'title': 'Stop Loss', 'duration': '3ч', 'completed': false},
            {'title': 'Position Sizing', 'duration': '4ч', 'completed': false},
          ],
        },
        {
          'id': '4',
          'title': 'Психология трейдинга',
          'description': 'Ментальный аспект',
          'icon': Icons.psychology,
          'completed': false,
          'courses': [
            {'title': 'Эмоции в трейдинге', 'duration': '4ч', 'completed': false},
            {'title': 'Дисциплина', 'duration': '3ч', 'completed': false},
          ],
        },
        {
          'id': '5',
          'title': 'Продвинутые инструменты',
          'description': 'Фьючерсы и опционы',
          'icon': Icons.insights,
          'completed': false,
          'courses': [
            {'title': 'Деривативы', 'duration': '6ч', 'completed': false},
            {'title': 'Хеджирование', 'duration': '5ч', 'completed': false},
          ],
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final currentPath = _learningPaths.firstWhere((p) => p['id'] == _selectedPath);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Путь обучения'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Path Selector
          _buildPathSelector(),

          // Progress Overview
          _buildProgressOverview(currentPath),

          // Timeline
          Expanded(
            child: _buildTimeline(currentPath),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _continueLearning(currentPath),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Продолжить'),
        backgroundColor: currentPath['color'],
      ),
    );
  }

  // Path Selector
  Widget _buildPathSelector() {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: _learningPaths.length,
        itemBuilder: (context, index) {
          final path = _learningPaths[index];
          final isSelected = _selectedPath == path['id'];
          
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPath = path['id'] as String),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSelected
                        ? [
                            (path['color'] as Color).withOpacity(0.8),
                            path['color'] as Color,
                          ]
                        : [Colors.grey[200]!, Colors.grey[100]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? path['color'] : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      path['icon'] as IconData,
                      color: isSelected ? Colors.white : path['color'],
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      path['title'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ).animate()
            .fadeIn(delay: Duration(milliseconds: index * 50))
            .scale(begin: const Offset(0.9, 0.9));
        },
      ),
    );
  }

  // Progress Overview
  Widget _buildProgressOverview(Map<String, dynamic> path) {
    final progress = path['progress'] as int;
    final courses = path['courses'] as int;
    final duration = path['duration'] as String;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            (path['color'] as Color).withOpacity(0.1),
            (path['color'] as Color).withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (path['color'] as Color).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (path['color'] as Color).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  path['icon'],
                  color: path['color'],
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      path['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$duration • $courses курсов',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Прогресс',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$progress%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: path['color'],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(path['color']),
                    minHeight: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .slideY(begin: 0.2, end: 0);
  }

  // Timeline
  Widget _buildTimeline(Map<String, dynamic> path) {
    final stages = path['stages'] as List<Map<String, dynamic>>;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stages.length,
      itemBuilder: (context, index) {
        final stage = stages[index];
        final isLast = index == stages.length - 1;
        
        return _buildTimelineStage(stage, index, isLast);
      },
    );
  }

  Widget _buildTimelineStage(Map<String, dynamic> stage, int index, bool isLast) {
    final isCompleted = stage['completed'] as bool;
    final isCurrent = stage['current'] as bool? ?? false;
    final courses = stage['courses'] as List<Map<String, dynamic>>;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line
        Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isCompleted
                    ? Colors.green
                    : isCurrent
                        ? AppTheme.primaryColor
                        : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Icon(
                        stage['icon'] as IconData,
                        color: isCurrent ? Colors.white : Colors.grey[500],
                        size: 20,
                      ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isCompleted ? Colors.green : Colors.grey[300],
              ),
          ],
        ),
        const SizedBox(width: 16),
        // Stage content
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCurrent ? AppTheme.primaryColor.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isCurrent
                    ? AppTheme.primaryColor.withOpacity(0.3)
                    : Colors.grey[200]!,
                width: isCurrent ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stage['title'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                              color: isCompleted
                                  ? Colors.green
                                  : isCurrent
                                      ? AppTheme.primaryColor
                                      : Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stage['description'] as String,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Текущий',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Courses
                ...courses.map((course) => _buildCourseItem(course)).toList(),
              ],
            ),
          ),
        ).animate()
          .fadeIn(delay: Duration(milliseconds: index * 100))
          .slideX(begin: 0.2, end: 0),
      ],
    );
  }

  Widget _buildCourseItem(Map<String, dynamic> course) {
    final isCompleted = course['completed'] as bool;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: isCompleted ? Colors.green : Colors.grey[400],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              course['title'] as String,
              style: TextStyle(
                fontSize: 13,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted ? Colors.grey[400] : Colors.black87,
              ),
            ),
          ),
          Text(
            course['duration'] as String,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Actions
  void _continueLearning(Map<String, dynamic> path) {
    AppLogger.info('Continue learning: ${path['title']}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Продолжаем: ${path['title']}'),
        backgroundColor: path['color'],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
