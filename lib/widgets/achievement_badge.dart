import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/providers/achievements_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final VoidCallback? onTap;
  final double size;

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.onTap,
    this.size = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: achievement.isUnlocked 
              ? _getRarityColor(achievement.rarity).withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(size * 0.2),
          border: Border.all(
            color: achievement.isUnlocked 
                ? _getRarityColor(achievement.rarity)
                : Colors.grey,
            width: 2,
          ),
          boxShadow: achievement.isUnlocked ? [
            BoxShadow(
              color: _getRarityColor(achievement.rarity).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Stack(
          children: [
            // Иконка достижения
            Center(
              child: Text(
                achievement.icon,
                style: TextStyle(fontSize: size * 0.4),
              ),
            ),
            // Индикатор разблокировки
            if (achievement.isUnlocked)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: size * 0.25,
                  height: size * 0.25,
                  decoration: BoxDecoration(
                    color: _getRarityColor(achievement.rarity),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: size * 0.15,
                  ),
                ),
              ),
            // Индикатор редкости
            if (achievement.rarity == AchievementRarity.legendary)
              Positioned(
                bottom: 4,
                left: 4,
                child: Container(
                  width: size * 0.2,
                  height: size * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: size * 0.12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return Colors.grey;
      case AchievementRarity.rare:
        return Colors.blue;
      case AchievementRarity.epic:
        return Colors.purple;
      case AchievementRarity.legendary:
        return Colors.orange;
    }
  }
}

class AchievementProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  final double height;

  const AchievementProgressBar({
    super.key,
    required this.progress,
    this.color = AppTheme.primaryColor,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}

class AchievementTooltip extends StatelessWidget {
  final Achievement achievement;
  final Widget child;

  const AchievementTooltip({
    super.key,
    required this.achievement,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: achievement.isUnlocked 
          ? '${achievement.title}\n${achievement.description}\nПолучено: ${_formatDate(achievement.unlockedAt!)}'
          : '${achievement.title}\n${achievement.description}\nНе разблокировано',
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 12,
      ),
      child: child,
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} дн. назад';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ч. назад';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} мин. назад';
    } else {
      return 'только что';
    }
  }
}

class RecentAchievementsWidget extends StatelessWidget {
  final List<Achievement> recentAchievements;
  final VoidCallback? onViewAll;

  const RecentAchievementsWidget({
    super.key,
    required this.recentAchievements,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (recentAchievements.isEmpty) {
      return Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 8),
              Text(
                'Пока нет достижений',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Активно участвуйте в платформе!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Последние достижения',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (onViewAll != null)
                  TextButton(
                    onPressed: onViewAll,
                    child: const Text('Все'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentAchievements.length,
                itemBuilder: (context, index) {
                  final achievement = recentAchievements[index];
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: AchievementTooltip(
                      achievement: achievement,
                      child: AchievementBadge(
                        achievement: achievement,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
