import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/learning_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class ChallengeDetailsScreen extends StatefulWidget {
  final Challenge challenge;
  final Course course;
  
  const ChallengeDetailsScreen({
    super.key, 
    required this.challenge, 
    required this.course,
  });

  @override
  State<ChallengeDetailsScreen> createState() => _ChallengeDetailsScreenState();
}

class _ChallengeDetailsScreenState extends State<ChallengeDetailsScreen> {
  bool _isStarted = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkChallengeStatus();
  }

  void _checkChallengeStatus() {
    final learningProvider = context.read<LearningProvider>();
    final progress = learningProvider.getUserProgress(widget.course.id);
    if (progress != null) {
      setState(() {
        _isStarted = progress.challengeStatuses[widget.challenge.id] == ChallengeStatus.inProgress;
        _isCompleted = progress.challengeStatuses[widget.challenge.id] == ChallengeStatus.completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.challenge.title),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и описание
            Text(
              widget.challenge.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.challenge.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // Информация о челлендже
            _buildChallengeInfo(),
            const SizedBox(height: 24),

            // Требования
            _buildRequirementsSection(),
            const SizedBox(height: 24),

            // Стартовый код
            if (widget.challenge.starterCode != null)
              _buildStarterCodeSection(),
            if (widget.challenge.starterCode != null)
              const SizedBox(height: 24),

            // Кнопки действий
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // Информация о челлендже
  Widget _buildChallengeInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    Icons.school,
                    'Курс',
                    widget.course.title,
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    Icons.timer,
                    'Время',
                    '${widget.challenge.timeLimit.inHours}ч',
                  ),
                ),
                Expanded(
                  child: _buildInfoItem(
                    Icons.stars,
                    'Очки',
                    '${widget.challenge.points}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Секция требований
  Widget _buildRequirementsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.checklist, color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Требования',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...widget.challenge.requirements.map((requirement) => 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        requirement,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ],
        ),
      ),
    );
  }

  // Секция стартового кода
  Widget _buildStarterCodeSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code, color: AppTheme.primaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Стартовый код',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getLanguageName(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, color: Colors.white70, size: 20),
                        onPressed: () => _copyCode(),
                        tooltip: 'Копировать код',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    widget.challenge.starterCode!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Кнопки действий
  Widget _buildActionButtons() {
    if (_isCompleted) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.check_circle),
          label: const Text('Челлендж завершен'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }

    if (_isStarted) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _resetChallenge(),
              icon: const Icon(Icons.refresh),
              label: const Text('Начать заново'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _submitSolution(),
              icon: const Icon(Icons.send),
              label: const Text('Отправить решение'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _startChallenge(),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Начать челлендж'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // Действия
  void _startChallenge() {
    setState(() {
      _isStarted = true;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Челлендж начат! Время пошло...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetChallenge() {
    setState(() {
      _isStarted = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Челлендж сброшен'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _submitSolution() {
    // В реальном приложении здесь будет отправка решения
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Отправить решение'),
        content: const Text(
          'Вы уверены, что хотите отправить решение? '
          'После отправки вы не сможете его изменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _completeChallenge();
            },
            child: const Text('Отправить'),
          ),
        ],
      ),
    );
  }

  void _completeChallenge() {
    final learningProvider = context.read<LearningProvider>();
    learningProvider.completeChallenge(widget.course.id, widget.challenge.id);
    
    setState(() {
      _isCompleted = true;
      _isStarted = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Поздравляем! Вы завершили челлендж и заработали ${widget.challenge.points} очков!',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _copyCode() {
    // В реальном приложении здесь будет копирование в буфер обмена
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Код скопирован в буфер обмена'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  String _getLanguageName() {
    // Определяем язык по расширению или содержимому кода
    final code = widget.challenge.starterCode ?? '';
    if (code.contains('use solana_program')) {
      return 'Rust (Solana)';
    } else if (code.contains('pragma solidity')) {
      return 'Solidity';
    } else if (code.contains('fn main')) {
      return 'Rust';
    } else if (code.contains('function')) {
      return 'JavaScript';
    } else {
      return 'Code';
    }
  }
}
