import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Challenge> challenges = [
      Challenge(
        title: 'Intro to Solana',
        platform: 'Solana',
        difficulty: 'Beginner',
        duration: '2-3 weeks',
        participants: 266103,
        isCompleted: false,
        progress: 0,
        description: 'Изучите основы Solana и создайте свой первый dApp',
        rewards: ['NFT Badge', '100 SOL', 'Mentorship'],
      ),
      Challenge(
        title: 'Front-End Build',
        platform: 'Multi-platform',
        difficulty: 'Intermediate',
        duration: '3-4 weeks',
        participants: 150000,
        isCompleted: false,
        progress: 0,
        description: 'Создайте современный фронтенд для Web3 приложения',
        rewards: ['Certificate', '50 USDC', 'Job Opportunities'],
      ),
      Challenge(
        title: 'Deploy Smart Contract',
        platform: 'Ethereum',
        difficulty: 'Advanced',
        duration: '4-5 weeks',
        participants: 98000,
        isCompleted: false,
        progress: 0,
        description: 'Разверните смарт-контракт в основной сети Ethereum',
        rewards: ['Expert Badge', '200 USDC', 'VC Introduction'],
      ),
      Challenge(
        title: 'Polkadot Development',
        platform: 'Polkadot',
        difficulty: 'Intermediate',
        duration: '3-4 weeks',
        participants: 97103,
        isCompleted: false,
        progress: 0,
        description: 'Создайте парачейн для экосистемы Polkadot',
        rewards: ['Polkadot Badge', '75 DOT', 'Community Access'],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Челленджи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Фильтры
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Все', true),
                  const SizedBox(width: 8),
                  _buildFilterChip('Solana', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Ethereum', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Polkadot', false),
                  const SizedBox(width: 8),
                  _buildFilterChip('Polygon', false),
                ],
              ),
            ),
          ),
          
          // Список челленджей
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: challenges.length,
              itemBuilder: (context, index) {
                final challenge = challenges[index];
                return ChallengeCard(challenge: challenge).animate().fadeIn(
                  delay: Duration(milliseconds: index * 100),
                  duration: 600.ms,
                ).slideX(begin: 0.3, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (value) {},
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      checkmarkColor: AppTheme.primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondaryColor,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;

  const ChallengeCard({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок и платформа
            Row(
              children: [
                Expanded(
                  child: Text(
                    challenge.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getPlatformColor(challenge.platform).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    challenge.platform,
                    style: TextStyle(
                      color: _getPlatformColor(challenge.platform),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Описание
            Text(
              challenge.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Детали челленджа
            Row(
              children: [
                _buildChallengeDetail(
                  Icons.speed,
                  challenge.difficulty,
                  _getDifficultyColor(challenge.difficulty),
                ),
                const SizedBox(width: 16),
                _buildChallengeDetail(
                  Icons.access_time,
                  challenge.duration,
                  AppTheme.textSecondaryColor,
                ),
                const SizedBox(width: 16),
                _buildChallengeDetail(
                  Icons.people,
                  '${challenge.participants}',
                  AppTheme.textSecondaryColor,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Прогресс
            if (challenge.progress > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Прогресс',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      Text(
                        '${challenge.progress}%',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: challenge.progress / 100,
                    backgroundColor: AppTheme.borderColor,
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                ],
              ),
            
            const SizedBox(height: 20),
            
            // Награды
            Text(
              'Награды:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: challenge.rewards.map((reward) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    reward,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 20),
            
            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Подробнее'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: challenge.isCompleted ? null : () {},
                    child: Text(
                      challenge.isCompleted ? 'Завершено' : 'Начать',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeDetail(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getPlatformColor(String platform) {
    switch (platform.toLowerCase()) {
      case 'solana':
        return Colors.purple;
      case 'ethereum':
        return Colors.blue;
      case 'polkadot':
        return Colors.pink;
      case 'polygon':
        return Colors.indigo;
      default:
        return AppTheme.primaryColor;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppTheme.successColor;
      case 'intermediate':
        return AppTheme.warningColor;
      case 'advanced':
        return AppTheme.errorColor;
      default:
        return AppTheme.textSecondaryColor;
    }
  }
}

class Challenge {
  final String title;
  final String platform;
  final String difficulty;
  final String duration;
  final int participants;
  final bool isCompleted;
  final int progress;
  final String description;
  final List<String> rewards;

  Challenge({
    required this.title,
    required this.platform,
    required this.difficulty,
    required this.duration,
    required this.participants,
    required this.isCompleted,
    required this.progress,
    required this.description,
    required this.rewards,
  });
}
