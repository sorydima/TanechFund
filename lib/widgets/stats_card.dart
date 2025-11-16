import 'package:flutter/material.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Иконка
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            // Значение
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: 'Inter',
              ),
            ),

            const SizedBox(height: 8),

            // Заголовок
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textSecondaryColor,
                fontFamily: 'Inter',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
