import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/providers/mentorship_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class MentorCard extends StatelessWidget {
  final Mentor mentor;
  final VoidCallback onTap;

  const MentorCard({
    super.key,
    required this.mentor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Заголовок карточки
              Row(
                children: [
                  // Аватар
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(mentor.avatarUrl),
                    backgroundColor: Colors.grey[300],
                    child: mentor.avatarUrl.isEmpty
                        ? Text(
                            mentor.name.split(' ').map((n) => n[0]).join(''),
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  // Информация о менторе
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mentor.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mentor.title,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mentor.company,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Статус доступности
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: mentor.isAvailable ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      mentor.isAvailable ? 'Доступен' : 'Недоступен',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Биография
              Text(
                mentor.bio,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Экспертиза
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: mentor.expertise.take(5).map((expertise) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    expertise,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),

              const SizedBox(height: 16),

              // Статистика и рейтинг
              Row(
                children: [
                  // Рейтинг
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        mentor.rating.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' (${mentor.sessionsCompleted} сессий)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Опыт
                  Row(
                    children: [
                      Icon(
                        Icons.work,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${mentor.yearsExperience} лет',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Языки
              Row(
                children: [
                  Icon(
                    Icons.language,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 8,
                      children: mentor.languages.map((language) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          language,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )).toList(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Кнопка действия
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: mentor.isAvailable ? onTap : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    mentor.isAvailable ? 'Записаться на сессию' : 'Недоступен',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
