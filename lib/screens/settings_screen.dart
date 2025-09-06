import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/app_provider.dart';
import 'package:rechain_vc_lab/providers/intro_provider.dart';
import 'package:rechain_vc_lab/providers/auth_provider.dart';
import 'package:rechain_vc_lab/providers/notification_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Профиль пользователя
            _buildProfileSection(),
            
            const SizedBox(height: 24),
            
            // Внешний вид
            _buildAppearanceSection(),
            
            const SizedBox(height: 24),
            
            // Уведомления
            _buildNotificationsSection(),
            
            const SizedBox(height: 24),
            
            // Безопасность
            _buildSecuritySection(),
            
            const SizedBox(height: 24),
            
            // О приложении
            _buildAboutSection(),
            
            const SizedBox(height: 24),
            
            // Выход
            _buildLogoutSection(),
          ],
        ),
      ),
    );
  }

  // Секция профиля
  Widget _buildProfileSection() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: authProvider.userAvatar != null
                          ? ClipOval(
                              child: Image.network(
                                authProvider.userAvatar!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.person,
                                  size: 30,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 30,
                              color: AppTheme.primaryColor,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authProvider.userName ?? 'Пользователь',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            authProvider.userEmail ?? 'email@example.com',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          if (authProvider.userRole != null)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                authProvider.userRole!,
                                style: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Редактирование профиля
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Секция внешнего вида
  Widget _buildAppearanceSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Внешний вид',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return Column(
                children: [
                  SwitchListTile(
                    title: const Text('Темная тема'),
                    subtitle: const Text('Использовать темную тему приложения'),
                    value: appProvider.isDarkMode,
                    onChanged: (value) {
                      appProvider.toggleDarkMode();
                    },
                    secondary: Icon(
                      appProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  ListTile(
                    title: const Text('Язык'),
                    subtitle: Text(appProvider.currentLanguage),
                    leading: const Icon(Icons.language),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _showLanguageDialog,
                  ),
                  ListTile(
                    title: const Text('Валюта'),
                    subtitle: Text(appProvider.currentCurrency),
                    leading: const Icon(Icons.attach_money),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: _showCurrencyDialog,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // Секция уведомлений
  Widget _buildNotificationsSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Уведомления',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Column(
            children: [
              SwitchListTile(
                title: const Text('Push уведомления'),
                subtitle: const Text('Получать уведомления на устройство'),
                value: true, // В реальном приложении из настроек
                onChanged: (value) {
                  // Обработка изменения
                },
                secondary: const Icon(Icons.notifications_active),
              ),
              SwitchListTile(
                title: const Text('Email уведомления'),
                subtitle: const Text('Получать уведомления на email'),
                value: false, // В реальном приложении из настроек
                onChanged: (value) {
                  // Обработка изменения
                },
                secondary: const Icon(Icons.email),
              ),
              SwitchListTile(
                title: const Text('Уведомления о хакатонах'),
                subtitle: const Text('Новые хакатоны и обновления'),
                value: true, // В реальном приложении из настроек
                onChanged: (value) {
                  // Обработка изменения
                },
                secondary: const Icon(Icons.event),
              ),
              SwitchListTile(
                title: const Text('Уведомления о челленджах'),
                subtitle: const Text('Новые челленджи и дедлайны'),
                value: true, // В реальном приложении из настроек
                onChanged: (value) {
                  // Обработка изменения
                },
                secondary: const Icon(Icons.emoji_events),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Секция безопасности
  Widget _buildSecuritySection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Безопасность',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Text('Изменить пароль'),
                leading: const Icon(Icons.lock_outline),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: _showChangePasswordDialog,
              ),
              ListTile(
                title: const Text('Двухфакторная аутентификация'),
                subtitle: const Text('Дополнительная защита аккаунта'),
                leading: const Icon(Icons.security),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Настройка 2FA
                },
              ),
              ListTile(
                title: const Text('Подключенные устройства'),
                leading: const Icon(Icons.devices),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Управление устройствами
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Секция о приложении
  Widget _buildAboutSection() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'О приложении',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ),
          Column(
            children: [
              ListTile(
                title: const Text('Версия приложения'),
                subtitle: const Text('1.0.0'),
                leading: const Icon(Icons.info_outline),
              ),
              ListTile(
                title: const Text('Лицензия'),
                leading: const Icon(Icons.description),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Показать лицензию
                },
              ),
              ListTile(
                title: const Text('Политика конфиденциальности'),
                leading: const Icon(Icons.privacy_tip_outlined),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Показать политику
                },
              ),
                        ListTile(
            title: const Text('Условия использования'),
            leading: const Icon(Icons.gavel),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Показать условия
            },
          ),
          ListTile(
            title: const Text('Помощь и обучение'),
            subtitle: const Text('Интро, обзор функций, навигация'),
            leading: const Icon(Icons.help_outline),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              _showHelpOptions(context);
            },
          ),
            ],
          ),
        ],
      ),
    );
  }

  // Секция выхода
  Widget _buildLogoutSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text(
              'Выйти из аккаунта',
              style: TextStyle(color: Colors.red),
            ),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: _showLogoutDialog,
          ),
        ],
      ),
    );
  }

  // Показать опции помощи
  void _showHelpOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Помощь и обучение'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_circle_outline),
              title: const Text('Повторить интро'),
              subtitle: const Text('Обзор основных возможностей'),
              onTap: () {
                Navigator.of(context).pop();
                context.read<IntroProvider>().resetIntro();
                Navigator.of(context).pushReplacementNamed('/intro');
              },
            ),
            ListTile(
              leading: const Icon(Icons.featured_play_list),
              title: const Text('Обзор функций'),
              subtitle: const Text('Подробное описание всех возможностей'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/features-overview');
              },
            ),
            ListTile(
              leading: const Icon(Icons.navigation),
              title: const Text('Руководство по навигации'),
              subtitle: const Text('Как эффективно использовать приложение'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/navigation-guide');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
        ],
      ),
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

  // Диалог смены пароля
  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить пароль'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Текущий пароль',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Новый пароль',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Подтвердите новый пароль',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              // Проверка и смена пароля
              if (newPasswordController.text == confirmPasswordController.text) {
                // Смена пароля
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Пароль успешно изменен'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Пароли не совпадают'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Изменить'),
          ),
        ],
      ),
    );
  }

  // Диалог выхода
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выйти из аккаунта'),
        content: const Text('Вы уверены, что хотите выйти?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await context.read<AuthProvider>().signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
  }
}
