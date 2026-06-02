import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// Экран кастомизации аватара для метавселенной
class MetaverseAvatarScreen extends StatefulWidget {
  const MetaverseAvatarScreen({super.key});

  @override
  State<MetaverseAvatarScreen> createState() => _MetaverseAvatarScreenState();
}

class _MetaverseAvatarScreenState extends State<MetaverseAvatarScreen> {
  int _selectedCategory = 0;
  int _selectedItem = 0;
  Color _avatarColor = Colors.blue;
  Map<String, dynamic> _avatarConfig = {
    'body': 0,
    'face': 0,
    'hair': 0,
    'clothes': 0,
    'accessories': 0,
  };

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Body', 'icon': Icons.accessibility, 'items': 5},
    {'name': 'Face', 'icon': Icons.face, 'items': 8},
    {'name': 'Hair', 'icon': Icons.content_cut, 'items': 12},
    {'name': 'Clothes', 'icon': Icons.checkroom, 'items': 15},
    {'name': 'Accessories', 'icon': Icons.star, 'items': 10},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аватар'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _resetAvatar,
            tooltip: 'Сбросить',
          ),
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: _saveAvatar,
            tooltip: 'Сохранить',
          ),
        ],
      ),
      body: Column(
        children: [
          // Avatar preview
          Expanded(
            flex: 3,
            child: _buildAvatarPreview(),
          ),

          // Customization panel
          Expanded(
            flex: 4,
            child: _buildCustomizationPanel(),
          ),
        ],
      ),
    );
  }

  // Avatar preview
  Widget _buildAvatarPreview() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.accentColor.withOpacity(0.1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Background circles
          Positioned.fill(
            child: Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      _avatarColor.withOpacity(0.3),
                      _avatarColor.withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Avatar
          Center(
            child: GestureDetector(
              onTap: _rotateAvatar,
              child: Container(
                width: 200,
                height: 300,
                child: Stack(
                  children: [
                    // Body
                    Positioned(
                      left: 50,
                      top: 80,
                      child: _buildAvatarPart('body'),
                    ),
                    // Head
                    Positioned(
                      left: 60,
                      top: 20,
                      child: _buildAvatarPart('face'),
                    ),
                    // Hair
                    Positioned(
                      left: 55,
                      top: 10,
                      child: _buildAvatarPart('hair'),
                    ),
                    // Clothes
                    Positioned(
                      left: 50,
                      top: 140,
                      child: _buildAvatarPart('clothes'),
                    ),
                    // Accessories
                    Positioned(
                      left: 70,
                      top: 50,
                      child: _buildAvatarPart('accessories'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Color picker
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Цвет кожи',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildColorOption(Colors.brown.shade200),
                    _buildColorOption(Colors.brown.shade300),
                    _buildColorOption(Colors.brown.shade400),
                    _buildColorOption(Colors.orange.shade200),
                    _buildColorOption(Colors.deepOrange.shade200),
                    _buildColorOption(Colors.blue.shade200),
                    _buildColorOption(Colors.purple.shade200),
                    _buildColorOption(Colors.green.shade200),
                  ],
                ),
              ],
            ),
          ),

          // Rotate hint
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.rotate_right, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Нажмите для поворота',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPart(String part) {
    final index = _avatarConfig[part] as int;
    
    switch (part) {
      case 'body':
        return _buildBody(index);
      case 'face':
        return _buildFace(index);
      case 'hair':
        return _buildHair(index);
      case 'clothes':
        return _buildClothes(index);
      case 'accessories':
        return _buildAccessories(index);
      default:
        return const SizedBox();
    }
  }

  Widget _buildBody(int index) {
    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        color: _avatarColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          'Body $index',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildFace(int index) {
    final faces = ['😊', '😎', '🤔', '😄', '🥳', '😇', '🤩', '😋'];
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: _avatarColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          faces[index % faces.length],
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  Widget _buildHair(int index) {
    return Container(
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.brown.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          'Hair $index',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildClothes(int index) {
    return Container(
      width: 110,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
          'Clothes $index',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildAccessories(int index) {
    final accessories = ['🕶️', '🎧', '🎩', '👑', '💍', '⌚', '🎒', '👓', '🧣', '🎀'];
    return Text(
      accessories[index % accessories.length],
      style: const TextStyle(fontSize: 40),
    );
  }

  Widget _buildColorOption(Color color) {
    final isSelected = _avatarColor == color;
    return GestureDetector(
      onTap: () => setState(() => _avatarColor = color),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : null,
      ),
    );
  }

  // Customization panel
  Widget _buildCustomizationPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Categories
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == index;
                
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCategory = index;
                        _selectedItem = 0;
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 70,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            category['icon'] as IconData,
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.grey,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category['name'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate()
                  .scale(delay: Duration(milliseconds: index * 50));
              },
            ),
          ),

          // Items grid
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _categories[_selectedCategory]['name'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1,
                      ),
                      itemCount: _categories[_selectedCategory]['items'] as int,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedItem == index;
                        final categoryName = _categories[_selectedCategory]['name'];
                        
                        return _buildItemCard(
                          index,
                          isSelected,
                          categoryName as String,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _randomizeAvatar,
                    icon: const Icon(Icons.casino),
                    label: const Text('Случайно'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveAvatar,
                    icon: const Icon(Icons.check),
                    label: const Text('Готово'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(int index, bool isSelected, String category) {
    final Map<String, String> categoryMap = {
      'Тело': 'body',
      'Лицо': 'face',
      'Волосы': 'hair',
      'Одежда': 'clothes',
      'Аксессуары': 'accessories',
    };
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedItem = index;
          final key = categoryMap[category] ?? 'body';
          _avatarConfig[key] = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getCategoryIcon(category),
                size: 32,
                color: isSelected ? AppTheme.primaryColor : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                '$index',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppTheme.primaryColor : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final categoryKey = category.toLowerCase();
    if (categoryKey.contains('тело') || categoryKey == 'body') return Icons.accessibility;
    if (categoryKey.contains('лицо') || categoryKey == 'face') return Icons.face;
    if (categoryKey.contains('волосы') || categoryKey == 'hair') return Icons.content_cut;
    if (categoryKey.contains('одежда') || categoryKey == 'clothes') return Icons.checkroom;
    if (categoryKey.contains('аксессуар') || categoryKey == 'accessories') return Icons.star;
    return Icons.category;
  }

  void _rotateAvatar() {
    AppLogger.info('Rotate avatar');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Поворот аватара'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _resetAvatar() {
    setState(() {
      _avatarConfig = {
        'body': 0,
        'face': 0,
        'hair': 0,
        'clothes': 0,
        'accessories': 0,
      };
      _selectedItem = 0;
      _avatarColor = Colors.blue;
    });
  }

  void _randomizeAvatar() {
    setState(() {
      _avatarConfig = {
        'body': DateTime.now().millisecondsSinceEpoch % 5,
        'face': DateTime.now().millisecondsSinceEpoch % 8,
        'hair': DateTime.now().millisecondsSinceEpoch % 12,
        'clothes': DateTime.now().millisecondsSinceEpoch % 15,
        'accessories': DateTime.now().millisecondsSinceEpoch % 10,
      };
      _selectedItem = _avatarConfig['body'] as int;
    });
  }

  void _saveAvatar() {
    AppLogger.info('Save avatar config: $_avatarConfig');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            const Text('Аватар сохранён!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
