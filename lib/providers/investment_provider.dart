import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Статус инвестиционного раунда
enum InvestmentRoundStatus {
  planning,      // Планирование
  open,          // Открыт для инвестиций
  dueDiligence,  // Due Diligence
  closed,        // Закрыт
  funded,        // Финансирован
  completed      // Завершен
}

// Тип инвестиции
enum InvestmentType {
  seed,          // Seed
  seriesA,       // Series A
  seriesB,       // Series B
  seriesC,       // Series C
  growth,        // Growth
  bridge,        // Bridge
  strategic      // Стратегическая
}

// Статус синдиката
enum SyndicateStatus {
  forming,       // Формируется
  active,        // Активен
  closed,        // Закрыт
  dissolved      // Распущен
}

// Модель инвестиционного раунда
class InvestmentRound {
  final String id;
  final String startupName;
  final String description;
  final double targetAmount;
  final double currentAmount;
  final double minimumInvestment;
  final double maximumInvestment;
  final InvestmentType type;
  final InvestmentRoundStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> tags;
  final String blockchain;
  final double valuation;
  final double equityOffered;
  final List<String> documents;
  final DateTime createdAt;
  final DateTime updatedAt;

  InvestmentRound({
    required this.id,
    required this.startupName,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    required this.minimumInvestment,
    required this.maximumInvestment,
    required this.type,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.tags,
    required this.blockchain,
    required this.valuation,
    required this.equityOffered,
    required this.documents,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'startupName': startupName,
    'description': description,
    'targetAmount': targetAmount,
    'currentAmount': currentAmount,
    'minimumInvestment': minimumInvestment,
    'maximumInvestment': maximumInvestment,
    'type': type.name,
    'status': status.name,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'tags': tags,
    'blockchain': blockchain,
    'valuation': valuation,
    'equityOffered': equityOffered,
    'documents': documents,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory InvestmentRound.fromJson(Map<String, dynamic> json) => InvestmentRound(
    id: json['id'],
    startupName: json['startupName'],
    description: json['description'],
    targetAmount: json['targetAmount'].toDouble(),
    currentAmount: json['currentAmount'].toDouble(),
    minimumInvestment: json['minimumInvestment'].toDouble(),
    maximumInvestment: json['maximumInvestment'].toDouble(),
    type: InvestmentType.values.firstWhere((e) => e.name == json['type']),
    status: InvestmentRoundStatus.values.firstWhere((e) => e.name == json['status']),
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    tags: List<String>.from(json['tags']),
    blockchain: json['blockchain'],
    valuation: json['valuation'].toDouble(),
    equityOffered: json['equityOffered'].toDouble(),
    documents: List<String>.from(json['documents']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  InvestmentRound copyWith({
    String? id,
    String? startupName,
    String? description,
    double? targetAmount,
    double? currentAmount,
    double? minimumInvestment,
    double? maximumInvestment,
    InvestmentType? type,
    InvestmentRoundStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    List<String>? tags,
    String? blockchain,
    double? valuation,
    double? equityOffered,
    List<String>? documents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return InvestmentRound(
      id: id ?? this.id,
      startupName: startupName ?? this.startupName,
      description: description ?? this.description,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      minimumInvestment: minimumInvestment ?? this.minimumInvestment,
      maximumInvestment: maximumInvestment ?? this.maximumInvestment,
      type: type ?? this.type,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      tags: tags ?? this.tags,
      blockchain: blockchain ?? this.blockchain,
      valuation: valuation ?? this.valuation,
      equityOffered: equityOffered ?? this.equityOffered,
      documents: documents ?? this.documents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Модель синдиката
class Syndicate {
  final String id;
  final String name;
  final String description;
  final String leadInvestor;
  final List<String> members;
  final double totalCapital;
  final double committedCapital;
  final SyndicateStatus status;
  final DateTime formationDate;
  final DateTime? closingDate;
  final List<String> investmentRounds;
  final List<String> documents;
  final DateTime createdAt;
  final DateTime updatedAt;

  Syndicate({
    required this.id,
    required this.name,
    required this.description,
    required this.leadInvestor,
    required this.members,
    required this.totalCapital,
    required this.committedCapital,
    required this.status,
    required this.formationDate,
    this.closingDate,
    required this.investmentRounds,
    required this.documents,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'leadInvestor': leadInvestor,
    'members': members,
    'totalCapital': totalCapital,
    'committedCapital': committedCapital,
    'status': status.name,
    'formationDate': formationDate.toIso8601String(),
    'closingDate': closingDate?.toIso8601String(),
    'investmentRounds': investmentRounds,
    'documents': documents,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Syndicate.fromJson(Map<String, dynamic> json) => Syndicate(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    leadInvestor: json['leadInvestor'],
    members: List<String>.from(json['members']),
    totalCapital: json['totalCapital'].toDouble(),
    committedCapital: json['committedCapital'].toDouble(),
    status: SyndicateStatus.values.firstWhere((e) => e.name == json['status']),
    formationDate: DateTime.parse(json['formationDate']),
    closingDate: json['closingDate'] != null ? DateTime.parse(json['closingDate']) : null,
    investmentRounds: List<String>.from(json['investmentRounds']),
    documents: List<String>.from(json['documents']),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Syndicate copyWith({
    String? id,
    String? name,
    String? description,
    String? leadInvestor,
    List<String>? members,
    double? totalCapital,
    double? committedCapital,
    SyndicateStatus? status,
    DateTime? formationDate,
    DateTime? closingDate,
    List<String>? investmentRounds,
    List<String>? documents,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Syndicate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      leadInvestor: leadInvestor ?? this.leadInvestor,
      members: members ?? this.members,
      totalCapital: totalCapital ?? this.totalCapital,
      committedCapital: committedCapital ?? this.committedCapital,
      status: status ?? this.status,
      formationDate: formationDate ?? this.formationDate,
      closingDate: closingDate ?? this.closingDate,
      investmentRounds: investmentRounds ?? this.investmentRounds,
      documents: documents ?? this.documents,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Модель инвестиции
class Investment {
  final String id;
  final String roundId;
  final String investorId;
  final double amount;
  final DateTime date;
  final String status; // pending, confirmed, rejected
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Investment({
    required this.id,
    required this.roundId,
    required this.investorId,
    required this.amount,
    required this.date,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'roundId': roundId,
    'investorId': investorId,
    'amount': amount,
    'date': date.toIso8601String(),
    'status': status,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
    id: json['id'],
    roundId: json['roundId'],
    investorId: json['investorId'],
    amount: json['amount'].toDouble(),
    date: DateTime.parse(json['date']),
    status: json['status'],
    notes: json['notes'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );
}

// Провайдер инвестиций
class InvestmentProvider extends ChangeNotifier {
  List<InvestmentRound> _investmentRounds = [];
  List<Syndicate> _syndicates = [];
  List<Investment> _investments = [];
  bool _isLoading = false;

  List<InvestmentRound> get investmentRounds => _investmentRounds;
  List<Syndicate> get syndicates => _syndicates;
  List<Investment> get investments => _investments;
  bool get isLoading => _isLoading;

  // Получить раунды по статусу
  List<InvestmentRound> getRoundsByStatus(InvestmentRoundStatus status) {
    return _investmentRounds.where((round) => round.status == status).toList();
  }

  // Получить раунды по типу
  List<InvestmentRound> getRoundsByType(InvestmentType type) {
    return _investmentRounds.where((round) => round.type == type).toList();
  }

  // Получить активные синдикаты
  List<Syndicate> get activeSyndicates {
    return _syndicates.where((syndicate) => 
      syndicate.status == SyndicateStatus.active || 
      syndicate.status == SyndicateStatus.forming
    ).toList();
  }

  // Поиск раундов
  List<InvestmentRound> searchRounds(String query) {
    if (query.isEmpty) return _investmentRounds;
    
    return _investmentRounds.where((round) =>
      round.startupName.toLowerCase().contains(query.toLowerCase()) ||
      round.description.toLowerCase().contains(query.toLowerCase()) ||
      round.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase())) ||
      round.blockchain.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Поиск синдикатов
  List<Syndicate> searchSyndicates(String query) {
    if (query.isEmpty) return _syndicates;
    
    return _syndicates.where((syndicate) =>
      syndicate.name.toLowerCase().contains(query.toLowerCase()) ||
      syndicate.description.toLowerCase().contains(query.toLowerCase()) ||
      syndicate.leadInvestor.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  // Добавить инвестиционный раунд
  Future<void> addInvestmentRound(InvestmentRound round) async {
    _investmentRounds.add(round);
    await _saveInvestmentRounds();
    notifyListeners();
  }

  // Обновить инвестиционный раунд
  Future<void> updateInvestmentRound(InvestmentRound round) async {
    final index = _investmentRounds.indexWhere((r) => r.id == round.id);
    if (index != -1) {
      _investmentRounds[index] = round;
      await _saveInvestmentRounds();
      notifyListeners();
    }
  }

  // Добавить синдикат
  Future<void> addSyndicate(Syndicate syndicate) async {
    _syndicates.add(syndicate);
    await _saveSyndicates();
    notifyListeners();
  }

  // Обновить синдикат
  Future<void> updateSyndicate(Syndicate syndicate) async {
    final index = _syndicates.indexWhere((s) => s.id == syndicate.id);
    if (index != -1) {
      _syndicates[index] = syndicate;
      await _saveSyndicates();
      notifyListeners();
    }
  }

  // Добавить инвестицию
  Future<void> addInvestment(Investment investment) async {
    _investments.add(investment);
    await _saveInvestments();
    notifyListeners();
  }

  // Загрузить данные
  Future<void> loadData() async {
    _setLoading(true);
    await Future.wait([
      _loadInvestmentRounds(),
      _loadSyndicates(),
      _loadInvestments(),
    ]);
    _setLoading(false);
  }

  // Создать демо данные
  Future<void> createDemoData() async {
    if (_investmentRounds.isNotEmpty) return;

    final now = DateTime.now();
    
    // Демо инвестиционные раунды
    _investmentRounds = [
      InvestmentRound(
        id: '1',
        startupName: 'DeFi Protocol X',
        description: 'Инновационный DeFi протокол для ликвидности и стейкинга',
        targetAmount: 5000000,
        currentAmount: 3200000,
        minimumInvestment: 10000,
        maximumInvestment: 500000,
        type: InvestmentType.seriesA,
        status: InvestmentRoundStatus.open,
        startDate: now.subtract(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 60)),
        tags: ['DeFi', 'Liquidity', 'Staking', 'Ethereum'],
        blockchain: 'Ethereum',
        valuation: 25000000,
        equityOffered: 20.0,
        documents: ['pitch_deck.pdf', 'financial_model.xlsx'],
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now,
      ),
      InvestmentRound(
        id: '2',
        startupName: 'NFT Marketplace Pro',
        description: 'Платформа для торговли NFT с AI-рекомендациями',
        targetAmount: 2000000,
        currentAmount: 1500000,
        minimumInvestment: 5000,
        maximumInvestment: 200000,
        type: InvestmentType.seed,
        status: InvestmentRoundStatus.dueDiligence,
        startDate: now.subtract(const Duration(days: 15)),
        endDate: now.add(const Duration(days: 45)),
        tags: ['NFT', 'Marketplace', 'AI', 'Polygon'],
        blockchain: 'Polygon',
        valuation: 8000000,
        equityOffered: 25.0,
        documents: ['business_plan.pdf', 'market_analysis.pdf'],
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now,
      ),
      InvestmentRound(
        id: '3',
        startupName: 'Cross-Chain Bridge',
        description: 'Решение для межсетевого взаимодействия блокчейнов',
        targetAmount: 8000000,
        currentAmount: 0,
        minimumInvestment: 25000,
        maximumInvestment: 1000000,
        type: InvestmentType.seriesB,
        status: InvestmentRoundStatus.planning,
        startDate: now.add(const Duration(days: 30)),
        endDate: now.add(const Duration(days: 120)),
        tags: ['Cross-Chain', 'Bridge', 'Interoperability', 'Multi-Chain'],
        blockchain: 'Multi-Chain',
        valuation: 40000000,
        equityOffered: 20.0,
        documents: ['technical_whitepaper.pdf'],
        createdAt: now,
        updatedAt: now,
      ),
    ];

    // Демо синдикаты
    _syndicates = [
      Syndicate(
        id: '1',
        name: 'Crypto Ventures Syndicate',
        description: 'Синдикат для инвестиций в криптопроекты',
        leadInvestor: 'Crypto Capital Partners',
        members: ['investor1', 'investor2', 'investor3'],
        totalCapital: 10000000,
        committedCapital: 7500000,
        status: SyndicateStatus.active,
        formationDate: now.subtract(const Duration(days: 90)),
        investmentRounds: ['1', '2'],
        documents: ['syndicate_agreement.pdf'],
        createdAt: now.subtract(const Duration(days: 90)),
        updatedAt: now,
      ),
      Syndicate(
        id: '2',
        name: 'DeFi Innovation Fund',
        description: 'Фокус на DeFi и DeFi-протоколах',
        leadInvestor: 'DeFi Ventures',
        members: ['investor4', 'investor5'],
        totalCapital: 5000000,
        committedCapital: 3000000,
        status: SyndicateStatus.forming,
        formationDate: now.subtract(const Duration(days: 30)),
        investmentRounds: ['1'],
        documents: ['term_sheet.pdf'],
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now,
      ),
    ];

    // Демо инвестиции
    _investments = [
      Investment(
        id: '1',
        roundId: '1',
        investorId: 'investor1',
        amount: 100000,
        date: now.subtract(const Duration(days: 25)),
        status: 'confirmed',
        notes: 'Стратегическая инвестиция',
        createdAt: now.subtract(const Duration(days: 25)),
        updatedAt: now.subtract(const Duration(days: 25)),
      ),
      Investment(
        id: '2',
        roundId: '1',
        investorId: 'investor2',
        amount: 250000,
        date: now.subtract(const Duration(days: 20)),
        status: 'confirmed',
        notes: 'Крупная инвестиция от институционального инвестора',
        createdAt: now.subtract(const Duration(days: 20)),
        updatedAt: now.subtract(const Duration(days: 20)),
      ),
    ];

    await Future.wait([
      _saveInvestmentRounds(),
      _saveSyndicates(),
      _saveInvestments(),
    ]);
    
    notifyListeners();
  }

  // Приватные методы для загрузки/сохранения
  Future<void> _loadInvestmentRounds() async {
    final prefs = await SharedPreferences.getInstance();
    final roundsJson = prefs.getStringList('investment_rounds') ?? [];
    _investmentRounds = roundsJson
        .map((json) => InvestmentRound.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveInvestmentRounds() async {
    final prefs = await SharedPreferences.getInstance();
    final roundsJson = _investmentRounds
        .map((round) => jsonEncode(round.toJson()))
        .toList();
    await prefs.setStringList('investment_rounds', roundsJson);
  }

  Future<void> _loadSyndicates() async {
    final prefs = await SharedPreferences.getInstance();
    final syndicatesJson = prefs.getStringList('syndicates') ?? [];
    _syndicates = syndicatesJson
        .map((json) => Syndicate.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveSyndicates() async {
    final prefs = await SharedPreferences.getInstance();
    final syndicatesJson = _syndicates
        .map((syndicate) => jsonEncode(syndicate.toJson()))
        .toList();
    await prefs.setStringList('syndicates', syndicatesJson);
  }

  Future<void> _loadInvestments() async {
    final prefs = await SharedPreferences.getInstance();
    final investmentsJson = prefs.getStringList('investments') ?? [];
    _investments = investmentsJson
        .map((json) => Investment.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<void> _saveInvestments() async {
    final prefs = await SharedPreferences.getInstance();
    final investmentsJson = _investments
        .map((investment) => jsonEncode(investment.toJson()))
        .toList();
    await prefs.setStringList('investments', investmentsJson);
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
