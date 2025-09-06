import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class PolkadotScreen extends StatelessWidget {
  const PolkadotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polkadot'),
        backgroundColor: const Color(0xFFE6007A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero секция
            _buildHeroSection(),
            
            // Статистика платформы
            _buildPlatformStats(),
            
            // Челленджи
            _buildChallenges(),
            
            // Обучение
            _buildLearningPath(),
            
            // Инструменты разработки
            _buildDevTools(),
            
            // Сообщество
            _buildCommunity(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE6007A),
            Color(0xFF8B5CF6),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.polygon,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            const Text(
              'Polkadot',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Мультичейн экосистема для Web3',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatChip('49', 'Челленджей'),
                _buildStatChip('97K+', 'Разработчиков'),
                _buildStatChip('100+', 'Парачейнов'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformStats() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Почему Polkadot?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildFeatureCard(
                Icons.link,
                'Интероперабельность',
                'Связь между блокчейнами',
                const Color(0xFFE6007A),
              ),
              _buildFeatureCard(
                Icons.security,
                'Безопасность',
                'Общая безопасность',
                const Color(0xFF8B5CF6),
              ),
              _buildFeatureCard(
                Icons.auto_fix_high,
                'Обновления',
                'Без хардфорков',
                const Color(0xFF10B981),
              ),
              _buildFeatureCard(
                Icons.code,
                'Substrate',
                'Фреймворк разработки',
                const Color(0xFF6366F1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChallenges() {
    final challenges = [
      {
        'title': 'Intro to Polkadot',
        'difficulty': 'Начинающий',
        'duration': '2-3 часа',
        'reward': '50 DOT',
        'participants': 12340,
        'status': 'active',
      },
      {
        'title': 'Build a Parachain',
        'difficulty': 'Средний',
        'duration': '6-8 часов',
        'reward': '150 DOT',
        'participants': 5670,
        'status': 'active',
      },
      {
        'title': 'Cross-Chain Messaging',
        'difficulty': 'Средний',
        'duration': '4-6 часов',
        'reward': '100 DOT',
        'participants': 7890,
        'status': 'active',
      },
      {
        'title': 'Advanced Substrate',
        'difficulty': 'Продвинутый',
        'duration': '8-10 часов',
        'reward': '200 DOT',
        'participants': 3450,
        'status': 'active',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Доступные челленджи',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: challenges.length,
            itemBuilder: (context, index) {
              final challenge = challenges[index];
              return _buildChallengeCard(
                challenge['title'] as String,
                challenge['difficulty'] as String,
                challenge['duration'] as String,
                challenge['reward'] as String,
                challenge['participants'] as int,
                challenge['status'] as String,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeCard(
    String title,
    String difficulty,
    String duration,
    String reward,
    int participants,
    String status,
  ) {
    Color difficultyColor;
    switch (difficulty) {
      case 'Начинающий':
        difficultyColor = Colors.green;
        break;
      case 'Средний':
        difficultyColor = Colors.orange;
        break;
      case 'Продвинутый':
        difficultyColor = Colors.red;
        break;
      default:
        difficultyColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: difficultyColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    difficulty,
                    style: TextStyle(
                      color: difficultyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  duration,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.attach_money, size: 16, color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  reward,
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(Icons.people, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '$participants',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6007A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Начать челлендж'),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, duration: 300.ms);
  }

  Widget _buildLearningPath() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Путь обучения',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildLearningStep(1, 'Основы Polkadot', 'Изучите архитектуру и принципы работы'),
          _buildLearningStep(2, 'Substrate Framework', 'Освойте фреймворк для разработки'),
          _buildLearningStep(3, 'Rust программирование', 'Язык для смарт-контрактов'),
          _buildLearningStep(4, 'Парачейны', 'Создание собственных блокчейнов'),
          _buildLearningStep(5, 'Cross-Chain', 'Межсетевое взаимодействие'),
        ],
      ),
    );
  }

  Widget _buildLearningStep(int step, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE6007A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$step',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevTools() {
    final tools = [
      {'name': 'Substrate', 'description': 'Фреймворк для создания блокчейнов'},
      {'name': 'Polkadot.js', 'description': 'JavaScript библиотека для взаимодействия'},
      {'name': 'Substrate Playground', 'description': 'Онлайн IDE для разработки'},
      {'name': 'Polkadot Apps', 'description': 'Веб-интерфейс для управления сетью'},
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Инструменты разработки',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: tools.length,
            itemBuilder: (context, index) {
              final tool = tools[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.build,
                        color: const Color(0xFFE6007A),
                        size: 24,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        tool['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tool['description']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommunity() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Присоединяйтесь к сообществу',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCommunityCard(
                  Icons.discord,
                  'Discord',
                  '25K+ участников',
                  const Color(0xFF5865F2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCommunityCard(
                  Icons.telegram,
                  'Telegram',
                  '20K+ участников',
                  const Color(0xFF0088CC),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCommunityCard(
                  Icons.code,
                  'GitHub',
                  'Открытые проекты',
                  const Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCommunityCard(
                  Icons.forum,
                  'Форум',
                  'Обсуждения и помощь',
                  const Color(0xFFE6007A),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(IconData icon, String title, String subtitle, Color color) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
