import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/compiler_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class CompilerScreen extends StatefulWidget {
  const CompilerScreen({super.key});

  @override
  State<CompilerScreen> createState() => _CompilerScreenState();
}

class _CompilerScreenState extends State<CompilerScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompilerProvider>().loadTemplates();
      context.read<CompilerProvider>().loadCompilationHistory();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Блокчейн Компилятор'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTemplateDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Редактор'),
            Tab(text: 'Шаблоны'),
            Tab(text: 'История'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEditorTab(),
          _buildTemplatesTab(),
          _buildHistoryTab(),
        ],
      ),
    );
  }

  // Вкладка редактора
  Widget _buildEditorTab() {
    return Consumer<CompilerProvider>(
      builder: (context, compilerProvider, child) {
        return Column(
          children: [
            // Панель инструментов
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  // Выбор языка
                  Expanded(
                    child: DropdownButtonFormField<CompilerLanguage>(
                      value: compilerProvider.selectedLanguage,
                      decoration: const InputDecoration(
                        labelText: 'Язык программирования',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: CompilerLanguage.values.map((language) => 
                        DropdownMenuItem(
                          value: language,
                          child: Text(_getLanguageName(language)),
                        ),
                      ).toList(),
                      onChanged: (language) {
                        if (language != null) {
                          compilerProvider.setLanguage(language);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Кнопки действий
                  ElevatedButton.icon(
                    onPressed: compilerProvider.status == CompilerStatus.compiling 
                        ? null 
                        : () => _compileCode(compilerProvider),
                    icon: compilerProvider.status == CompilerStatus.compiling
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(_getCompileButtonText(compilerProvider.status)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () => _clearCode(compilerProvider),
                    icon: const Icon(Icons.clear),
                    label: const Text('Очистить'),
                  ),
                ],
              ),
            ),
            
            // Редактор кода
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _codeController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: _getCodeHint(compilerProvider.selectedLanguage),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontFamily: 'monospace',
                    ),
                  ),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                    height: 1.5,
                  ),
                  onChanged: (code) {
                    compilerProvider.setCode(code);
                  },
                ),
              ),
            ),
            
            // Результат компиляции
            if (compilerProvider.lastResult != null)
              _buildCompilationResult(compilerProvider.lastResult!),
          ],
        );
      },
    );
  }

  // Вкладка шаблонов
  Widget _buildTemplatesTab() {
    return Consumer<CompilerProvider>(
      builder: (context, compilerProvider, child) {
        if (compilerProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var filteredTemplates = compilerProvider.templates;
        if (_searchQuery.isNotEmpty) {
          filteredTemplates = compilerProvider.searchTemplates(_searchQuery);
        }

        if (filteredTemplates.isEmpty) {
          return _buildEmptyState('Шаблоны не найдены', 'Попробуйте изменить поиск');
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredTemplates.length,
          itemBuilder: (context, index) {
            final template = filteredTemplates[index];
            return _buildTemplateCard(template, compilerProvider)
                .animate()
                .fadeIn(delay: Duration(milliseconds: index * 100))
                .slideX(begin: 0.3, end: 0);
          },
        );
      },
    );
  }

  // Вкладка истории
  Widget _buildHistoryTab() {
    return Consumer<CompilerProvider>(
      builder: (context, compilerProvider, child) {
        if (compilerProvider.compilationHistory.isEmpty) {
          return _buildEmptyState(
            'История компиляций пуста',
            'Скомпилируйте код, чтобы увидеть историю',
          );
        }

        return Column(
          children: [
            // Заголовок с кнопкой очистки
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    'История компиляций',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton.icon(
                    onPressed: () => _clearHistory(compilerProvider),
                    icon: const Icon(Icons.clear_all),
                    label: const Text('Очистить'),
                  ),
                ],
              ),
            ),
            
            // Список результатов
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: compilerProvider.compilationHistory.length,
                itemBuilder: (context, index) {
                  final result = compilerProvider.compilationHistory[index];
                  return _buildHistoryItem(result, index)
                      .animate()
                      .fadeIn(delay: Duration(milliseconds: index * 50))
                      .slideX(begin: 0.3, end: 0);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Карточка шаблона
  Widget _buildTemplateCard(CompilerTemplate template, CompilerProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getLanguageColor(template.language).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getLanguageIcon(template.language),
            color: _getLanguageColor(template.language),
            size: 24,
          ),
        ),
        title: Text(
          template.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(template.description),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: [
                _buildTagChip(template.blockchain),
                ...template.tags.map((tag) => _buildTagChip(tag)),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _loadTemplate(template, provider),
          child: const Text('Загрузить'),
        ),
      ),
    );
  }

  // Элемент истории
  Widget _buildHistoryItem(CompilerResult result, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: result.success ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            result.success ? Icons.check_circle : Icons.error,
            color: result.success ? Colors.green : Colors.red,
            size: 24,
          ),
        ),
        title: Text(
          result.success ? 'Успешная компиляция' : 'Ошибка компиляции',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: result.success ? Colors.green : Colors.red,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              result.success ? result.output : (result.error ?? 'Неизвестная ошибка'),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${_formatDate(result.timestamp)} • ${result.compilationTime.inMilliseconds}ms',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.visibility),
          onPressed: () => _showResultDetails(result),
        ),
      ),
    );
  }

  // Результат компиляции
  Widget _buildCompilationResult(CompilerResult result) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: result.success ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        border: Border.all(
          color: result.success ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.success ? Icons.check_circle : Icons.error,
                color: result.success ? Colors.green : Colors.red,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                result.success ? 'Компиляция успешна!' : 'Ошибка компиляции',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: result.success ? Colors.green : Colors.red,
                ),
              ),
              const Spacer(),
              Text(
                '${result.compilationTime.inMilliseconds}ms',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            result.success ? result.output : (result.error ?? 'Неизвестная ошибка'),
            style: const TextStyle(fontSize: 14),
          ),
          if (result.success && result.bytecode != null) ...[
            const SizedBox(height: 16),
            _buildExpandableSection('Байткод', result.bytecode!),
          ],
          if (result.success && result.abi != null) ...[
            const SizedBox(height: 8),
            _buildExpandableSection('ABI', result.abi!),
          ],
        ],
      ),
    );
  }

  // Раскрывающаяся секция
  Widget _buildExpandableSection(String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(4),
          ),
          child: SelectableText(
            content,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  // Тег
  Widget _buildTagChip(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tag,
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // Пустое состояние
  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Диалог поиска
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Поиск шаблонов'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Поиск по названию, описанию или тегам',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {});
            },
            child: const Text('Найти'),
          ),
        ],
      ),
    );
  }

  // Диалог добавления шаблона
  void _showAddTemplateDialog() {
    // Заглушка для добавления шаблона
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Функция добавления шаблона будет реализована позже'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  // Компилировать код
  void _compileCode(CompilerProvider provider) {
    provider.compileCode();
  }

  // Очистить код
  void _clearCode(CompilerProvider provider) {
    provider.clearCode();
    _codeController.clear();
  }

  // Загрузить шаблон
  void _loadTemplate(CompilerTemplate template, CompilerProvider provider) {
    provider.loadTemplate(template);
    _codeController.text = template.code;
  }

  // Очистить историю
  void _clearHistory(CompilerProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Очистить историю'),
        content: const Text('Вы уверены, что хотите очистить всю историю компиляций?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.clearHistory();
            },
            child: const Text('Очистить'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  // Показать детали результата
  void _showResultDetails(CompilerResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          result.success ? 'Результат компиляции' : 'Ошибка компиляции',
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                result.success ? result.output : (result.error ?? 'Неизвестная ошибка'),
              ),
              if (result.success && result.bytecode != null) ...[
                const SizedBox(height: 16),
                const Text(
                  'Байткод:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SelectableText(
                    result.bytecode!,
                    style: const TextStyle(
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  // Получить название языка
  String _getLanguageName(CompilerLanguage language) {
    switch (language) {
      case CompilerLanguage.solidity:
        return 'Solidity';
      case CompilerLanguage.rust:
        return 'Rust';
      case CompilerLanguage.typescript:
        return 'TypeScript';
      case CompilerLanguage.javascript:
        return 'JavaScript';
      case CompilerLanguage.python:
        return 'Python';
    }
  }

  // Получить цвет языка
  Color _getLanguageColor(CompilerLanguage language) {
    switch (language) {
      case CompilerLanguage.solidity:
        return Colors.orange;
      case CompilerLanguage.rust:
        return Colors.red[700]!;
      case CompilerLanguage.typescript:
        return Colors.blue;
      case CompilerLanguage.javascript:
        return Colors.yellow[700]!;
      case CompilerLanguage.python:
        return Colors.blue[600]!;
    }
  }

  // Получить иконку языка
  IconData _getLanguageIcon(CompilerLanguage language) {
    switch (language) {
      case CompilerLanguage.solidity:
        return Icons.code;
      case CompilerLanguage.rust:
        return Icons.memory;
      case CompilerLanguage.typescript:
        return Icons.type_specimen;
      case CompilerLanguage.javascript:
        return Icons.javascript;
              case CompilerLanguage.python:
          return Icons.code;
    }
  }

  // Получить подсказку для кода
  String _getCodeHint(CompilerLanguage language) {
    switch (language) {
      case CompilerLanguage.solidity:
        return '// Напишите ваш Solidity контракт здесь\npragma solidity ^0.8.0;\n\ncontract MyContract {\n    // Ваш код\n}';
      case CompilerLanguage.rust:
        return '// Напишите ваш Rust код здесь\nfn main() {\n    println!("Hello, World!");\n}';
      case CompilerLanguage.typescript:
        return '// Напишите ваш TypeScript код здесь\nfunction hello() {\n    console.log("Hello, World!");\n}';
      case CompilerLanguage.javascript:
        return '// Напишите ваш JavaScript код здесь\nfunction hello() {\n    console.log("Hello, World!");\n}';
      case CompilerLanguage.python:
        return '# Напишите ваш Python код здесь\ndef hello():\n    print("Hello, World!")';
    }
  }

  // Получить текст кнопки компиляции
  String _getCompileButtonText(CompilerStatus status) {
    switch (status) {
      case CompilerStatus.idle:
        return 'Компилировать';
      case CompilerStatus.compiling:
        return 'Компиляция...';
      case CompilerStatus.success:
        return 'Перекомпилировать';
      case CompilerStatus.error:
        return 'Повторить';
    }
  }

  // Форматирование даты
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} нед. назад';
    } else {
      return '${(difference.inDays / 30).floor()} мес. назад';
    }
  }
}
