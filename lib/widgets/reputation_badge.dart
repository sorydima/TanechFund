import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/providers/reputation_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class ReputationBadge extends StatelessWidget {
  final UserReputation? reputation;
  final VoidCallback? onTap;
  final double size;

  const ReputationBadge({
    super.key,
    this.reputation,
    this.onTap,
    this.size = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    if (reputation == null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(size * 0.2),
          border: Border.all(color: Colors.grey, width: 2),
        ),
        child: const Center(
          child: Icon(Icons.stars, color: Colors.grey),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: reputation!.reputationColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(size * 0.2),
          border: Border.all(
            color: reputation!.reputationColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: reputation!.reputationColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Иконка репутации
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.stars,
                    color: reputation!.reputationColor,
                    size: size * 0.3,
                  ),
                  Text(
                    '${reputation!.totalReputation}',
                    style: TextStyle(
                      fontSize: size * 0.15,
                      fontWeight: FontWeight.bold,
                      color: reputation!.reputationColor,
                    ),
                  ),
                ],
              ),
            ),
            // Индикатор уровня
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                  color: reputation!.reputationColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getLevelIcon(reputation!.reputationLevel),
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

  IconData _getLevelIcon(String level) {
    switch (level) {
      case 'Новичок':
        return Icons.star_border;
      case 'Участник':
        return Icons.star_half;
      case 'Активный':
        return Icons.star;
      case 'Опытный':
        return Icons.star;
      case 'Эксперт':
        return Icons.star;
      case 'Мастер':
        return Icons.star;
      case 'Гуру':
        return Icons.star;
      case 'Легенда':
        return Icons.star;
      default:
        return Icons.star_border;
    }
  }
}

class ReputationProgressBar extends StatelessWidget {
  final int currentReputation;
  final String currentLevel;
  final Color color;
  final double height;

  const ReputationProgressBar({
    super.key,
    required this.currentReputation,
    required this.currentLevel,
    this.color = AppTheme.primaryColor,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final levelThresholds = _getLevelThresholds();
    final currentIndex = levelThresholds.indexWhere((level) => level['name'] == currentLevel);
    
    if (currentIndex == -1 || currentIndex >= levelThresholds.length - 1) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      );
    }

    final currentThreshold = levelThresholds[currentIndex]['threshold'] as int;
    final nextThreshold = levelThresholds[currentIndex + 1]['threshold'] as int;
    final progress = (currentReputation - currentThreshold) / (nextThreshold - currentThreshold);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              currentLevel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Text(
              '${currentReputation}/${nextThreshold}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
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
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getLevelThresholds() {
    return [
      {'name': 'Новичок', 'threshold': 0},
      {'name': 'Участник', 'threshold': 100},
      {'name': 'Активный', 'threshold': 500},
      {'name': 'Опытный', 'threshold': 1000},
      {'name': 'Эксперт', 'threshold': 2500},
      {'name': 'Мастер', 'threshold': 5000},
      {'name': 'Гуру', 'threshold': 10000},
      {'name': 'Легенда', 'threshold': 25000},
    ];
  }
}

class ReputationTooltip extends StatelessWidget {
  final UserReputation? reputation;
  final Widget child;

  const ReputationTooltip({
    super.key,
    this.reputation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (reputation == null) {
      return Tooltip(
        message: 'Репутация не загружена',
        child: child,
      );
    }

    return Tooltip(
      message: '${reputation!.reputationLevel}\n${reputation!.totalReputation} очков репутации',
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
}

class RecentReputationWidget extends StatelessWidget {
  final List<ReputationEvent> recentEvents;
  final VoidCallback? onViewAll;

  const RecentReputationWidget({
    super.key,
    required this.recentEvents,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (recentEvents.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.stars_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Пока нет событий репутации',
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
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Последние события',
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
          ...recentEvents.take(3).map((event) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _getTypeColor(event.type),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '+${event.points}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Color _getTypeColor(ReputationType type) {
    switch (type) {
      case ReputationType.project:
        return Colors.blue;
      case ReputationType.investment:
        return Colors.green;
      case ReputationType.mentorship:
        return Colors.purple;
      case ReputationType.social:
        return Colors.orange;
      case ReputationType.learning:
        return Colors.teal;
      case ReputationType.hackathon:
        return Colors.red;
      case ReputationType.challenge:
        return Colors.amber;
      case ReputationType.community:
        return Colors.pink;
      case ReputationType.review:
        return Colors.indigo;
      case ReputationType.feedback:
        return Colors.cyan;
    }
  }
}
