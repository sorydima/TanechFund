import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PortfolioProjectCard extends StatelessWidget {
  final String name;
  final String description;
  final String category;
  final String funding;
  final List<String> investors;
  final List<String> teamMembers;
  final String status;
  final VoidCallback? onTap;

  const PortfolioProjectCard({
    super.key,
    required this.name,
    required this.description,
    required this.category,
    required this.funding,
    required this.investors,
    required this.teamMembers,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(category),
                      color: _getCategoryColor(category),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _getStatusColor(status).withOpacity(0.3)),
                    ),
                    child: Text(
                      status,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.category,
                      label: category,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoChip(
                      icon: Icons.attach_money,
                      label: funding,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (investors.isNotEmpty) ...[
                Text(
                  'Инвесторы:',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: investors.map((investor) =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        investor,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ).toList(),
                ),
                const SizedBox(height: 12),
              ],
              if (teamMembers.isNotEmpty) ...[
                Text(
                  'Команда:',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: teamMembers.map((member) =>
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.2)),
                      ),
                      child: Text(
                        member,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 11,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, duration: 300.ms);
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'defi':
        return const Color(0xFF00D4AA);
      case 'nft':
        return const Color(0xFF6366F1);
      case 'gaming':
        return const Color(0xFFF59E0B);
      case 'infrastructure':
        return const Color(0xFF8B5CF6);
      case 'social':
        return const Color(0xFFEC4899);
      default:
        return Colors.blue;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'defi':
        return Icons.account_balance_wallet;
      case 'nft':
        return Icons.image;
      case 'gaming':
        return Icons.sports_esports;
      case 'infrastructure':
        return Icons.build;
      case 'social':
        return Icons.people;
      default:
        return Icons.rocket_launch;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'активный':
        return Colors.green;
      case 'в разработке':
        return Colors.orange;
      case 'завершен':
        return Colors.blue;
      case 'приостановлен':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
