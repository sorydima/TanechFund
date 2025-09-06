import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/intro_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class NavigationGuideScreen extends StatefulWidget {
  const NavigationGuideScreen({super.key});

  @override
  State<NavigationGuideScreen> createState() => _NavigationGuideScreenState();
}

class _NavigationGuideScreenState extends State<NavigationGuideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Руководство по навигации'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<IntroProvider>(
        builder: (context, introProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 20),
              ...introProvider.navigationGuides.map((guide) => _buildGuideCard(guide)),
              const SizedBox(height: 20),
              _buildNavigationTipsCard(),
              const SizedBox(height: 20),
              _buildQuickAccessCard(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.navigation,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            const Text(
              'Навигация по REChain®️ VC Lab',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Изучите, как эффективно перемещаться между 26 разделами приложения',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard(NavigationGuide guide) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    guide.icon,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    guide.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              guide.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      guide.tip,
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildNavigationTipsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tips_and_updates,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Полезные советы',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTipItem(
              'Используйте жесты',
              'Свайпайте влево/вправо для быстрой навигации между вкладками',
              Icons.touch_app,
            ),
            _buildTipItem(
              'Следите за индикатором',
              'Точки внизу показывают вашу текущую позицию среди всех разделов',
              Icons.more_horiz,
            ),
            _buildTipItem(
              'Автоматическая прокрутка',
              'При выборе вкладки происходит автоматическое центрирование',
              Icons.center_focus_strong,
            ),
            _buildTipItem(
              'Быстрый доступ',
              'Основные функции доступны с главной страницы',
              Icons.home,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flash_on,
                  color: Colors.amber,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Быстрый доступ',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildQuickAccessItem(
              'Уведомления',
              'Плавающая кнопка в правом верхнем углу',
              Icons.notifications,
              Colors.blue,
            ),
            _buildQuickAccessItem(
              'Поиск',
              'Доступен в большинстве разделов',
              Icons.search,
              Colors.green,
            ),
            _buildQuickAccessItem(
              'Профиль',
              'Последняя вкладка в навигации',
              Icons.person,
              Colors.purple,
            ),
            _buildQuickAccessItem(
              'Главная',
              'Первая вкладка для быстрого возврата',
              Icons.home,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessItem(String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
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
}
