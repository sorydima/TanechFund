import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:rechain_vc_lab/providers/app_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/screens/settings_screen.dart';
import 'package:rechain_vc_lab/screens/payments_screen.dart'; // Added import for SettingsScreen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final appProvider = Provider.of<AppProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Профиль пользователя
            if (authProvider.isAuthenticated)
              _buildUserProfile(authProvider)
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.3, end: 0)
            else
              _buildLoginPrompt(context)
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.3, end: 0),
            
            const SizedBox(height: 24),
            
            // Статистика пользователя
            if (authProvider.isAuthenticated)
              _buildUserStats()
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms),
            
            const SizedBox(height: 24),
            
            // Настройки приложения
            _buildAppSettings(appProvider)
                .animate()
                .fadeIn(delay: 400.ms, duration: 600.ms),
            
            const SizedBox(height: 24),
            
            // Информация о REChain
            _buildRechainInfo()
                .animate()
                .fadeIn(delay: 600.ms, duration: 600.ms),
            
            const SizedBox(height: 24),
            
            // Поддержка и контакты
            _buildSupportSection()
                .animate()
                .fadeIn(delay: 800.ms, duration: 600.ms),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile(AuthProvider authProvider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Аватар
            CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Text(
                authProvider.userName?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Имя пользователя
            Text(
              authProvider.userName ?? 'Пользователь',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Email
            Text(
              authProvider.userEmail ?? 'email@example.com',
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Роль
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                authProvider.userRole?.toUpperCase() ?? 'USER',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Кнопки действий
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Редактировать'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      authProvider.signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                    ),
                    child: const Text('Выйти'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.person_outline,
              size: 80,
              color: AppTheme.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Войдите в аккаунт',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Чтобы получить доступ к полному функционалу REChain VC Lab',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Войти'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserStats() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Моя статистика',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Проектов', '3', Icons.work),
                ),
                Expanded(
                  child: _buildStatItem('Челленджей', '7', Icons.emoji_events),
                ),
                Expanded(
                  child: _buildStatItem('Событий', '12', Icons.event),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildAppSettings(AppProvider appProvider) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Настройки приложения',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Настройки'),
            subtitle: const Text('Управление приложением'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Платежи'),
            subtitle: const Text('Управление финансами'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const PaymentsScreen(),
                ),
              );
            },
          ),
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return SwitchListTile(
                title: const Text('Темная тема'),
                subtitle: const Text('Использовать темную тему'),
                value: appProvider.isDarkMode,
                onChanged: (value) {
                  appProvider.toggleDarkMode();
                },
                secondary: Icon(
                  appProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppTheme.primaryColor,
                ),
              );
            },
          ),
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Язык'),
                subtitle: Text(appProvider.currentLanguage),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Показать диалог выбора языка
                  _showLanguageDialog();
                },
              );
            },
          ),
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Валюта'),
                subtitle: Text(appProvider.currentCurrency),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Показать диалог выбора валюты
                  _showCurrencyDialog();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRechainInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'О REChain®️ VC Lab',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildInfoItem(
              Icons.rocket_launch,
              'Venture Builder',
              'Создаем венчурные проекты с нуля',
            ),
            _buildInfoItem(
              Icons.egg_alt,
              'Incubator',
              'Инкубируем перспективные стартапы',
            ),
            _buildInfoItem(
              Icons.business,
              'Startup Studio',
              'Студия стартапов нового поколения',
            ),
            _buildInfoItem(
              Icons.trending_up,
              'Investment Syndicate',
              'Глобальный доступ к инвестициям',
            ),
            
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'REChain®️ VC Group Lab — это экосистема нового поколения, объединяющая создание венчурных проектов, инкубацию, стартап-студию и модель синдиката.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondaryColor,
                        height: 1.5,
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

  Widget _buildInfoItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
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
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Поддержка и контакты',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildSupportItem(
              Icons.email,
              'Email',
              'support@rechain.network',
              () {},
            ),
            _buildSupportItem(
              Icons.help_outline,
              'Помощь',
              'FAQ и документация',
              () {},
            ),
            _buildSupportItem(
              Icons.bug_report,
              'Сообщить об ошибке',
              'Помогите улучшить приложение',
              () {},
            ),
            _buildSupportItem(
              Icons.feedback,
              'Обратная связь',
              'Ваши предложения',
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppTheme.primaryColor,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  // Диалог выбора языка
  void _showLanguageDialog() {
    final languages = ['Русский', 'English', '中文', 'Español'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите язык'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((language) => 
            ListTile(
              title: Text(language),
              onTap: () {
                context.read<AppProvider>().setLanguage(language);
                Navigator.of(context).pop();
              },
            ),
          ).toList(),
        ),
      ),
    );
  }

  // Диалог выбора валюты
  void _showCurrencyDialog() {
    final currencies = ['RUB', 'USD', 'EUR', 'CNY'];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите валюту'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) => 
            ListTile(
              title: Text(currency),
              onTap: () {
                context.read<AppProvider>().setCurrency(currency);
                Navigator.of(context).pop();
              },
            ),
          ).toList(),
        ),
      ),
    );
  }
}
