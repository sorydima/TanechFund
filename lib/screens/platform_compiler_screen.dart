import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class PlatformCompilerScreen extends StatefulWidget {
  const PlatformCompilerScreen({super.key});

  @override
  State<PlatformCompilerScreen> createState() => _PlatformCompilerScreenState();
}

class _PlatformCompilerScreenState extends State<PlatformCompilerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPlatform = 'Android';
  bool _isCompiling = false;
  double _compilationProgress = 0.0;

  final List<Map<String, dynamic>> _platforms = [
    {
      'name': 'Android',
      'icon': Icons.android,
      'color': const Color(0xFF3DDC84),
      'description': 'Мобильные приложения для Android',
      'extensions': ['.apk', '.aab'],
      'commands': [
        'flutter build apk --release',
        'flutter build appbundle --release',
        'flutter build apk --debug',
      ],
      'requirements': [
        'Android SDK',
        'Java Development Kit',
        'Gradle',
      ],
    },
    {
      'name': 'iOS',
      'icon': Icons.phone_iphone,
      'color': const Color(0xFF000000),
      'description': 'Мобильные приложения для iOS',
      'extensions': ['.ipa'],
      'commands': [
        'flutter build ios --release',
        'flutter build ios --debug',
        'flutter build ipa --release',
      ],
      'requirements': [
        'Xcode',
        'macOS',
        'iOS Simulator',
      ],
    },
    {
      'name': 'Web',
      'icon': Icons.web,
      'color': const Color(0xFF4285F4),
      'description': 'Веб-приложения',
      'extensions': ['.html', '.js', '.css'],
      'commands': [
        'flutter build web --release',
        'flutter build web --debug',
        'flutter build web --web-renderer html',
      ],
      'requirements': [
        'Chrome/Edge',
        'Web Server',
        'Modern Browser',
      ],
    },
    {
      'name': 'Windows',
      'icon': Icons.desktop_windows,
      'color': const Color(0xFF0078D4),
      'description': 'Десктопные приложения для Windows',
      'extensions': ['.exe'],
      'commands': [
        'flutter build windows --release',
        'flutter build windows --debug',
      ],
      'requirements': [
        'Visual Studio',
        'Windows 10+',
        'CMake',
      ],
    },
    {
      'name': 'macOS',
      'icon': Icons.desktop_mac,
      'color': const Color(0xFF000000),
      'description': 'Десктопные приложения для macOS',
      'extensions': ['.app', '.dmg'],
      'commands': [
        'flutter build macos --release',
        'flutter build macos --debug',
      ],
      'requirements': [
        'Xcode',
        'macOS 10.14+',
        'CocoaPods',
      ],
    },
    {
      'name': 'Linux',
      'icon': Icons.desktop_mac,
      'color': const Color(0xFFFCC624),
      'description': 'Десктопные приложения для Linux',
      'extensions': ['.deb', '.rpm', '.AppImage'],
      'commands': [
        'flutter build linux --release',
        'flutter build linux --debug',
      ],
      'requirements': [
        'GCC',
        'CMake',
        'pkg-config',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Компилятор платформ'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Платформы'),
            Tab(text: 'Компиляция'),
            Tab(text: 'Настройки'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlatformsTab(),
          _buildCompilationTab(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  Widget _buildPlatformsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Выберите платформу для компиляции',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Каждая платформа имеет свои особенности и требования',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _platforms.length,
            itemBuilder: (context, index) {
              final platform = _platforms[index];
              return _buildPlatformCard(platform);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlatformCard(Map<String, dynamic> platform) {
    final isSelected = _selectedPlatform == platform['name'];
    
    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected 
          ? BorderSide(color: platform['color'], width: 2)
          : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPlatform = platform['name'];
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                platform['color'].withOpacity(0.1),
                platform['color'].withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: platform['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      platform['icon'],
                      color: platform['color'],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      platform['name'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: platform['color'],
                      size: 24,
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Text(
                platform['description'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Spacer(),
              
              // Расширения файлов
              Text(
                'Форматы: ${platform['extensions'].join(', ')}',
                style: TextStyle(
                  fontSize: 12,
                  color: platform['color'],
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Требования
              Text(
                'Требования: ${platform['requirements'].length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.8, 0.8), duration: 300.ms);
  }

  Widget _buildCompilationTab() {
    final selectedPlatform = _platforms.firstWhere(
      (p) => p['name'] == _selectedPlatform,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Компиляция для $_selectedPlatform',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedPlatform['description'],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          
          // Прогресс компиляции
          if (_isCompiling) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              selectedPlatform['color'],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Компиляция...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _compilationProgress,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        selectedPlatform['color'],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(_compilationProgress * 100).toInt()}%',
                      style: TextStyle(
                        color: selectedPlatform['color'],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          
          // Команды компиляции
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Команды компиляции',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...selectedPlatform['commands'].map<Widget>((command) => 
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              command,
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 12,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Копирование команды в буфер обмена
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Команда скопирована'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.copy, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ).toList(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Требования
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Системные требования',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...selectedPlatform['requirements'].map<Widget>((requirement) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(requirement),
                        ],
                      ),
                    ),
                  ).toList(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _isCompiling ? null : _startCompilation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPlatform['color'],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isCompiling ? 'Компиляция...' : 'Начать компиляцию',
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton(
                  onPressed: _isCompiling ? null : _stopCompilation,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Остановить'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Настройки компилятора',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Общие настройки
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Общие настройки',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  SwitchListTile(
                    title: const Text('Автоматическая очистка'),
                    subtitle: const Text('Очищать кэш после компиляции'),
                    value: true,
                    onChanged: (value) {},
                  ),
                  
                  SwitchListTile(
                    title: const Text('Параллельная компиляция'),
                    subtitle: const Text('Использовать несколько ядер'),
                    value: false,
                    onChanged: (value) {},
                  ),
                  
                  SwitchListTile(
                    title: const Text('Оптимизация размера'),
                    subtitle: const Text('Минимизировать размер приложения'),
                    value: true,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Настройки платформ
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Настройки платформ',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ListTile(
                    leading: const Icon(Icons.android, color: Color(0xFF3DDC84)),
                    title: const Text('Android'),
                    subtitle: const Text('API Level 21+, ARM64'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.phone_iphone, color: Color(0xFF000000)),
                    title: const Text('iOS'),
                    subtitle: const Text('iOS 12.0+, Universal'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.web, color: Color(0xFF4285F4)),
                    title: const Text('Web'),
                    subtitle: const Text('HTML, Canvas, WebGL'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.desktop_windows, color: Color(0xFF0078D4)),
                    title: const Text('Windows'),
                    subtitle: const Text('Windows 10+, x64'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.desktop_mac, color: Color(0xFF000000)),
                    title: const Text('macOS'),
                    subtitle: const Text('macOS 10.14+, Universal'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  
                  ListTile(
                    leading: const Icon(Icons.desktop_mac, color: Color(0xFFFCC624)),
                    title: const Text('Linux'),
                    subtitle: const Text('Ubuntu 18.04+, x64'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startCompilation() {
    setState(() {
      _isCompiling = true;
      _compilationProgress = 0.0;
    });

    // Симуляция процесса компиляции
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _compilationProgress = 0.1;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _compilationProgress = 0.3;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _compilationProgress = 0.6;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _compilationProgress = 0.9;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _compilationProgress = 1.0;
          _isCompiling = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Компиляция для $_selectedPlatform завершена!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _stopCompilation() {
    setState(() {
      _isCompiling = false;
      _compilationProgress = 0.0;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Компиляция остановлена'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
