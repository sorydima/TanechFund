import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class UniversityPartnersScreen extends StatelessWidget {
  const UniversityPartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Университетские партнеры'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок
            Text(
              'Наши университетские партнеры',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Мы сотрудничаем с ведущими университетами мира для создания инновационных образовательных программ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Список университетов
            _buildUniversitiesGrid(),
            
            const SizedBox(height: 32),
            
            // Статистика
            _buildStatistics(),
            
            const SizedBox(height: 32),
            
            // Отзывы студентов
            _buildTestimonials(),
            
            const SizedBox(height: 32),
            
            // Статистика загрузок
            _buildDownloadStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildUniversitiesGrid() {
    final universities = [
      {'name': 'Harvard University', 'logo': 'H', 'color': Colors.red},
      {'name': 'Cambridge University', 'logo': 'C', 'color': Colors.blue},
      {'name': 'Brown University', 'logo': 'B', 'color': Colors.brown},
      {'name': 'Dartmouth College', 'logo': 'D', 'color': Colors.green},
      {'name': 'Yale University', 'logo': 'Y', 'color': Colors.indigo},
      {'name': 'University of Oxford', 'logo': 'O', 'color': Colors.orange},
      {'name': 'MIT', 'logo': 'M', 'color': Colors.grey},
      {'name': 'Princeton University', 'logo': 'P', 'color': Colors.orange},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: universities.length,
      itemBuilder: (context, index) {
        final uni = universities[index];
        return _buildUniversityCard(
          uni['name'] as String,
          uni['logo'] as String,
          uni['color'] as Color,
        );
      },
    );
  }

  Widget _buildUniversityCard(String name, String logo, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.5), width: 2),
              ),
              child: Center(
                child: Text(
                  logo,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: 0.8, duration: 300.ms);
  }

  Widget _buildStatistics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Статистика партнерства',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Университетов',
                    '8',
                    Icons.school,
                    AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Студентов',
                    '1M+',
                    Icons.people,
                    AppTheme.secondaryColor,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Хакатонов',
                    '50+',
                    Icons.event,
                    AppTheme.accentColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTestimonials() {
    final testimonials = [
      {
        'name': 'Jeremy',
        'university': 'Harvard University',
        'text': 'On behalf of the entire team here, we wanted to extend a sincere thank you for all of your support during the earliest stages of the Lockbox. The two hackathons we did last semester were monumental in turning a random late-night idea into a functional MVP.',
        'icon': Icons.school,
      },
      {
        'name': 'Vivian',
        'university': 'MIT',
        'text': 'Thanks for the incredible event to bring together people from different backgrounds and provide a platform for stimulating discussions and ideas! 🙌',
        'icon': Icons.science,
      },
      {
        'name': 'Kashyab',
        'university': 'Northeastern University',
        'text': 'It all started with an TanechFund Hackathon',
        'icon': Icons.engineering,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Отзывы студентов',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: testimonials.length,
          itemBuilder: (context, index) {
            final testimonial = testimonials[index];
            return _buildTestimonialCard(
              testimonial['name'] as String,
              testimonial['university'] as String,
              testimonial['text'] as String,
              testimonial['icon'] as IconData,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTestimonialCard(String name, String university, String text, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: AppTheme.primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        university,
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
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2, duration: 300.ms);
  }

  Widget _buildDownloadStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Статистика загрузок',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.download,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Более 29 миллионов загрузок',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Приложения доступны в App Store, Google Play Market и REChain.Store',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
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
}
