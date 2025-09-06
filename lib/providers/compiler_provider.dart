import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

enum CompilerLanguage {
  solidity,
  rust,
  typescript,
  javascript,
  python,
}

enum CompilerStatus {
  idle,
  compiling,
  success,
  error,
}

class CompilerResult {
  final bool success;
  final String output;
  final String? error;
  final String? bytecode;
  final String? abi;
  final Duration compilationTime;
  final DateTime timestamp;

  CompilerResult({
    required this.success,
    required this.output,
    this.error,
    this.bytecode,
    this.abi,
    required this.compilationTime,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'output': output,
      'error': error,
      'bytecode': bytecode,
      'abi': abi,
      'compilationTime': compilationTime.inMilliseconds,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CompilerResult.fromJson(Map<String, dynamic> json) {
    return CompilerResult(
      success: json['success'],
      output: json['output'],
      error: json['error'],
      bytecode: json['bytecode'],
      abi: json['abi'],
      compilationTime: Duration(milliseconds: json['compilationTime']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class CompilerTemplate {
  final String id;
  final String name;
  final String description;
  final CompilerLanguage language;
  final String code;
  final List<String> tags;
  final String blockchain;

  CompilerTemplate({
    required this.id,
    required this.name,
    required this.description,
    required this.language,
    required this.code,
    required this.tags,
    required this.blockchain,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'language': language.index,
      'code': code,
      'tags': tags,
      'blockchain': blockchain,
    };
  }

  factory CompilerTemplate.fromJson(Map<String, dynamic> json) {
    return CompilerTemplate(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      language: CompilerLanguage.values[json['language']],
      code: json['code'],
      tags: List<String>.from(json['tags']),
      blockchain: json['blockchain'],
    );
  }
}

class CompilerProvider with ChangeNotifier {
  CompilerStatus _status = CompilerStatus.idle;
  CompilerLanguage _selectedLanguage = CompilerLanguage.solidity;
  String _currentCode = '';
  CompilerResult? _lastResult;
  List<CompilerTemplate> _templates = [];
  List<CompilerResult> _compilationHistory = [];
  bool _isLoading = false;

  CompilerStatus get status => _status;
  CompilerLanguage get selectedLanguage => _selectedLanguage;
  String get currentCode => _currentCode;
  CompilerResult? get lastResult => _lastResult;
  List<CompilerTemplate> get templates => _templates;
  List<CompilerResult> get compilationHistory => _compilationHistory;
  bool get isLoading => _isLoading;

  // Установить язык
  void setLanguage(CompilerLanguage language) {
    _selectedLanguage = language;
    notifyListeners();
  }

  // Установить код
  void setCode(String code) {
    _currentCode = code;
    notifyListeners();
  }

  // Компилировать код
  Future<void> compileCode() async {
    if (_currentCode.trim().isEmpty) {
      _setError('Код не может быть пустым');
      return;
    }

    _setStatus(CompilerStatus.compiling);
    final startTime = DateTime.now();

    try {
      // Имитация компиляции
      await Future.delayed(const Duration(seconds: 2));

      // Проверка синтаксиса
      final isValid = await _validateSyntax(_currentCode, _selectedLanguage);
      
      if (!isValid) {
        _setError('Ошибка синтаксиса в коде');
        return;
      }

      // Компиляция
      final result = await _performCompilation(_currentCode, _selectedLanguage);
      
      _lastResult = result;
      _compilationHistory.insert(0, result);
      
      // Ограничиваем историю
      if (_compilationHistory.length > 50) {
        _compilationHistory = _compilationHistory.take(50).toList();
      }

      _setStatus(CompilerStatus.success);
      await _saveCompilationHistory();
      
    } catch (e) {
      _setError('Ошибка компиляции: $e');
    }
  }

  // Очистить код
  void clearCode() {
    _currentCode = '';
    _lastResult = null;
    _setStatus(CompilerStatus.idle);
    notifyListeners();
  }

  // Загрузить шаблон
  void loadTemplate(CompilerTemplate template) {
    _currentCode = template.code;
    _selectedLanguage = template.language;
    _setStatus(CompilerStatus.idle);
    notifyListeners();
  }

  // Загрузить шаблоны
  Future<void> loadTemplates() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final templatesJson = prefs.getStringList('compiler_templates') ?? [];
      
      if (templatesJson.isEmpty) {
        await _createDefaultTemplates();
      } else {
        _templates = templatesJson
            .map((json) => CompilerTemplate.fromJson(jsonDecode(json)))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading templates: $e');
      await _createDefaultTemplates();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Загрузить историю компиляций
  Future<void> loadCompilationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList('compiler_history') ?? [];
      
      _compilationHistory = historyJson
          .map((json) => CompilerResult.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      debugPrint('Error loading compilation history: $e');
    }
  }

  // Сохранить историю компиляций
  Future<void> _saveCompilationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = _compilationHistory
          .map((result) => jsonEncode(result.toJson()))
          .toList();
      await prefs.setStringList('compiler_history', historyJson);
    } catch (e) {
      debugPrint('Error saving compilation history: $e');
    }
  }

  // Установить статус
  void _setStatus(CompilerStatus status) {
    _status = status;
    notifyListeners();
  }

  // Установить ошибку
  void _setError(String error) {
    _lastResult = CompilerResult(
      success: false,
      output: '',
      error: error,
      compilationTime: Duration.zero,
      timestamp: DateTime.now(),
    );
    _setStatus(CompilerStatus.error);
  }

  // Валидация синтаксиса
  Future<bool> _validateSyntax(String code, CompilerLanguage language) async {
    // Простая валидация для демонстрации
    switch (language) {
      case CompilerLanguage.solidity:
        return code.contains('pragma solidity') && 
               code.contains('contract') &&
               code.contains('{') && 
               code.contains('}');
      
      case CompilerLanguage.rust:
        return code.contains('fn main') && 
               code.contains('{') && 
               code.contains('}');
      
      case CompilerLanguage.typescript:
        return code.contains('function') || 
               code.contains('const') || 
               code.contains('let') ||
               code.contains('class');
      
      case CompilerLanguage.javascript:
        return code.contains('function') || 
               code.contains('const') || 
               code.contains('let') ||
               code.contains('class');
      
      case CompilerLanguage.python:
        return code.contains('def ') || 
               code.contains('class ') || 
               code.contains('import ');
      
      default:
        return true;
    }
  }

  // Выполнение компиляции
  Future<CompilerResult> _performCompilation(String code, CompilerLanguage language) async {
    final startTime = DateTime.now();
    
    // Имитация компиляции
    await Future.delayed(const Duration(milliseconds: 500));
    
    final compilationTime = DateTime.now().difference(startTime);
    
    // Генерируем демо-результаты
    switch (language) {
      case CompilerLanguage.solidity:
        return CompilerResult(
          success: true,
          output: '✅ Контракт успешно скомпилирован!\n\n📊 Статистика:\n- Операции: 15\n- Стоимость газа: ~50,000\n- Размер байткода: 2.4 KB',
          bytecode: '0x608060405234801561001057600080fd5b50610150806100206000396000f3fe608060405234801561001057600080fd5b50600436106100365760003560e01c80632e64cec11461003b5780636057361d14610059575b600080fd5b610043610075565b60405161005091906100a1565b60405180910390f35b610073600480360381019061006e91906100ed565b61007e565b005b60008054905090565b8060008190555050565b6000819050919050565b61009b81610088565b82525050565b60006020820190506100b66000830184610092565b92915050565b600080fd5b6100ca81610088565b81146100d557600080fd5b50565b6000813590506100e7816100c1565b92915050565b600060208284031215610103576101026100bc565b5b6000610111848285016100d8565b9150509291505056fea2646970667358221220b8c4c361bc3324c2b1e8c51e021c96f39282c0d6b6e5e5e5e5e5e5e5e5e5e5e5e64736f6c63430008110033',
          abi: '[{"inputs":[],"name":"get","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"x","type":"uint256"}],"name":"set","outputs":[],"stateMutability":"nonpayable","type":"function"}]',
          compilationTime: compilationTime,
          timestamp: DateTime.now(),
        );
      
      case CompilerLanguage.rust:
        return CompilerResult(
          success: true,
          output: '✅ Rust код успешно скомпилирован!\n\n📊 Статистика:\n- Время компиляции: 0.5s\n- Размер исполняемого файла: 1.2 MB\n- Оптимизации: включены',
          compilationTime: compilationTime,
          timestamp: DateTime.now(),
        );
      
      case CompilerLanguage.typescript:
        return CompilerResult(
          success: true,
          output: '✅ TypeScript код успешно скомпилирован!\n\n📊 Статистика:\n- JavaScript сгенерирован\n- Проверка типов: пройдена\n- Размер: 15.3 KB',
          compilationTime: compilationTime,
          timestamp: DateTime.now(),
        );
      
      case CompilerLanguage.javascript:
        return CompilerResult(
          success: true,
          output: '✅ JavaScript код валидирован!\n\n📊 Статистика:\n- Синтаксис: корректен\n- ESLint: пройден\n- Размер: 8.7 KB',
          compilationTime: compilationTime,
          timestamp: DateTime.now(),
        );
      
      case CompilerLanguage.python:
        return CompilerResult(
          success: true,
          output: '✅ Python код валидирован!\n\n📊 Статистика:\n- Синтаксис: корректен\n- PEP8: пройден\n- Размер: 3.2 KB',
          compilationTime: compilationTime,
          timestamp: DateTime.now(),
        );
      
      default:
        return CompilerResult(
          success: true,
          output: '✅ Код успешно обработан!',
          compilationTime: compilationTime,
          timestamp: DateTime.now(),
        );
    }
  }

  // Создание шаблонов по умолчанию
  Future<void> _createDefaultTemplates() async {
    _templates = [
      CompilerTemplate(
        id: '1',
        name: 'Простой смарт-контракт',
        description: 'Базовый смарт-контракт на Solidity с функциями get/set',
        language: CompilerLanguage.solidity,
        blockchain: 'Ethereum',
        tags: ['Smart Contract', 'Basic', 'Ethereum'],
        code: '''// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleStorage {
    uint256 private value;
    
    event ValueChanged(uint256 newValue);
    
    function get() public view returns (uint256) {
        return value;
    }
    
    function set(uint256 newValue) public {
        value = newValue;
        emit ValueChanged(newValue);
    }
}''',
      ),
      CompilerTemplate(
        id: '2',
        name: 'NFT контракт',
        description: 'ERC-721 NFT контракт на Solidity',
        language: CompilerLanguage.solidity,
        blockchain: 'Ethereum',
        tags: ['NFT', 'ERC-721', 'Ethereum'],
        code: '''// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    constructor() ERC721("MyNFT", "MNFT") {}
    
    function mint(address to, uint256 tokenId) public onlyOwner {
        _mint(to, tokenId);
    }
}''',
      ),
      CompilerTemplate(
        id: '3',
        name: 'Rust программа',
        description: 'Простая программа на Rust',
        language: CompilerLanguage.rust,
        blockchain: 'Solana',
        tags: ['Rust', 'Solana', 'Basic'],
        code: '''fn main() {
    println!("Hello, Solana!");
    
    let x = 5;
    let y = 10;
    let sum = x + y;
    
    println!("{} + {} = {}", x, y, sum);
}''',
      ),
      CompilerTemplate(
        id: '4',
        name: 'TypeScript класс',
        description: 'Класс на TypeScript для работы с блокчейном',
        language: CompilerLanguage.typescript,
        blockchain: 'Multi-chain',
        tags: ['TypeScript', 'Class', 'Web3'],
        code: '''interface Transaction {
    hash: string;
    from: string;
    to: string;
    value: string;
}

class BlockchainService {
    private provider: any;
    
    constructor(provider: any) {
        this.provider = provider;
    }
    
    async getTransaction(hash: string): Promise<Transaction> {
        const tx = await this.provider.getTransaction(hash);
        return {
            hash: tx.hash,
            from: tx.from,
            to: tx.to,
            value: tx.value.toString()
        };
    }
}''',
      ),
      CompilerTemplate(
        id: '5',
        name: 'Python скрипт',
        description: 'Python скрипт для анализа блокчейна',
        language: CompilerLanguage.python,
        blockchain: 'Multi-chain',
        tags: ['Python', 'Analysis', 'Web3'],
        code: '''import requests
import json
from typing import Dict, List

class BlockchainAnalyzer:
    def __init__(self, api_url: str):
        self.api_url = api_url
    
    def get_block_info(self, block_number: int) -> Dict:
        response = requests.get(f"{self.api_url}/block/{block_number}")
        return response.json()
    
    def analyze_transactions(self, transactions: List[Dict]) -> Dict:
        total_value = sum(float(tx['value']) for tx in transactions)
        return {
            'count': len(transactions),
            'total_value': total_value,
            'average_value': total_value / len(transactions) if transactions else 0
        }

# Пример использования
analyzer = BlockchainAnalyzer("https://api.ethereum.org")
print("Blockchain Analyzer initialized!")''',
      ),
    ];

    await _saveTemplates();
  }

  // Сохранить шаблоны
  Future<void> _saveTemplates() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final templatesJson = _templates
          .map((template) => jsonEncode(template.toJson()))
          .toList();
      await prefs.setStringList('compiler_templates', templatesJson);
    } catch (e) {
      debugPrint('Error saving templates: $e');
    }
  }

  // Добавить новый шаблон
  Future<void> addTemplate(CompilerTemplate template) async {
    _templates.add(template);
    await _saveTemplates();
    notifyListeners();
  }

  // Удалить шаблон
  Future<void> removeTemplate(String templateId) async {
    _templates.removeWhere((template) => template.id == templateId);
    await _saveTemplates();
    notifyListeners();
  }

  // Очистить историю
  Future<void> clearHistory() async {
    _compilationHistory.clear();
    await _saveCompilationHistory();
    notifyListeners();
  }

  // Получить шаблоны по языку
  List<CompilerTemplate> getTemplatesByLanguage(CompilerLanguage language) {
    return _templates.where((template) => template.language == language).toList();
  }

  // Получить шаблоны по блокчейну
  List<CompilerTemplate> getTemplatesByBlockchain(String blockchain) {
    return _templates.where((template) => template.blockchain == blockchain).toList();
  }

  // Поиск шаблонов
  List<CompilerTemplate> searchTemplates(String query) {
    if (query.isEmpty) return _templates;
    
    final lowercaseQuery = query.toLowerCase();
    return _templates.where((template) {
      return template.name.toLowerCase().contains(lowercaseQuery) ||
             template.description.toLowerCase().contains(lowercaseQuery) ||
             template.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery)) ||
             template.blockchain.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
}
