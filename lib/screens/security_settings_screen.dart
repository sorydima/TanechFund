import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rechain_vc_lab/core/logger.dart';
import 'package:rechain_vc_lab/core/security/biometric_auth.dart';

/// Экран настроек безопасности приложения.
class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final BiometricAuthService _biometricAuth = BiometricAuthService();
  
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;
  List<BiometricType> _availableTypes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBiometricSettings();
  }

  Future<void> _loadBiometricSettings() async {
    setState(() => _isLoading = true);

    try {
      _isBiometricAvailable = await _biometricAuth.isAvailable;
      _availableTypes = await _biometricAuth.availableTypes;
      _isBiometricEnabled = await _biometricAuth.isEnabled();

      AppLogger.info('Biometric available: $_isBiometricAvailable');
      AppLogger.info('Biometric types: ${_availableTypes.map((t) => t.displayName).join(', ')}');
    } catch (e, st) {
      AppLogger.error('Failed to load biometric settings', e, st);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleBiometric() async {
    if (!_isBiometricAvailable) return;

    if (!_isBiometricEnabled) {
      // Включение биометрии — требуется аутентификация
      final result = await _biometricAuth.authenticate(
        localizedReason: 'Включить биометрическую аутентификацию',
      );

      if (result.isSuccess) {
        setState(() => _isBiometricEnabled = true);
        _showSuccessSnackbar('Биометрическая аутентификация включена');
      } else if (result.isFailure) {
        _showErrorSnackbar(result.error?.message ?? 'Ошибка аутентификации');
      }
    } else {
      // Выключение биометрии
      setState(() => _isBiometricEnabled = false);
      _showSuccessSnackbar('Биометрическая аутентификация выключена');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Безопасность'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 24),
                  _buildBiometricSection(),
                  const SizedBox(height: 24),
                  _buildSecurityTips(),
                ].animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
              ),
            ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.security,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Безопасность',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Управляйте настройками безопасности и аутентификации',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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

  Widget _buildBiometricSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.fingerprint,
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Биометрическая аутентификация',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Вход с помощью Face ID, Touch ID или отпечатка пальца',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            
            // Статус доступности
            _buildStatusRow(
              'Доступно',
              _isBiometricAvailable ? 'Да' : 'Нет',
              _isBiometricAvailable ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 8),
            _buildStatusRow(
              'Включено',
              _isBiometricEnabled ? 'Да' : 'Нет',
              _isBiometricEnabled ? Colors.green : Colors.orange,
            ),
            
            // Типы биометрии
            if (_availableTypes.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Доступные методы:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTypes
                    .map((type) => Chip(
                          avatar: Icon(type.icon, size: 18),
                          label: Text(type.displayName),
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                        ))
                    .toList(),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Переключатель
            SwitchListTile(
              title: const Text('Использовать биометрию'),
              subtitle: Text(
                _isBiometricAvailable
                    ? _isBiometricEnabled
                        ? 'Биометрия включена'
                        : 'Биометрия выключена'
                    : 'Недоступно на этом устройстве',
              ),
              value: _isBiometricEnabled,
              onChanged: _isBiometricAvailable
                  ? (value) => _toggleBiometric()
                  : null,
              secondary: const Icon(Icons.touch_app),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityTips() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Советы по безопасности',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTip(
              Icons.lock_outline,
              'Используйте биометрию для быстрого и безопасного входа',
            ),
            _buildTip(
              Icons.refresh,
              'Регулярно обновляйте пароль',
            ),
            _buildTip(
              Icons.devices,
              'Не входите с незнакомых устройств',
            ),
            _buildTip(
              Icons.warning_amber,
              'Проверяйте историю активности аккаунта',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
