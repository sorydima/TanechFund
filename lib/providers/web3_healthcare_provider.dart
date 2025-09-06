import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Healthcare Category
enum HealthcareCategory {
  telemedicine,
  diagnostics,
  treatment,
  prevention,
  mental_health,
  emergency,
  rehabilitation,
  wellness,
  nutrition,
  fitness,
}

// Appointment Status
enum AppointmentStatus {
  scheduled,
  confirmed,
  in_progress,
  completed,
  cancelled,
  no_show,
}

// Payment Status
enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
  disputed,
}

// Insurance Status
enum InsuranceStatus {
  active,
  expired,
  pending,
  rejected,
  suspended,
}

// Healthcare Provider
class HealthcareProvider {
  final String id;
  final String name;
  final String specialization;
  final String licenseNumber;
  final String imageUrl;
  final String description;
  final List<HealthcareCategory> categories;
  final double rating;
  final int totalPatients;
  final int totalAppointments;
  final List<String> languages;
  final Map<String, dynamic> credentials;
  final bool isVerified;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime? updatedAt;

  HealthcareProvider({
    required this.id,
    required this.name,
    required this.specialization,
    required this.licenseNumber,
    required this.imageUrl,
    required this.description,
    required this.categories,
    required this.rating,
    required this.totalPatients,
    required this.totalAppointments,
    required this.languages,
    required this.credentials,
    required this.isVerified,
    required this.isAvailable,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialization': specialization,
      'licenseNumber': licenseNumber,
      'imageUrl': imageUrl,
      'description': description,
      'categories': categories.map((c) => c.name).toList(),
      'rating': rating,
      'totalPatients': totalPatients,
      'totalAppointments': totalAppointments,
      'languages': languages,
      'credentials': credentials,
      'isVerified': isVerified,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory HealthcareProvider.fromJson(Map<String, dynamic> json) {
    return HealthcareProvider(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      licenseNumber: json['licenseNumber'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      categories: (json['categories'] as List).map((c) => HealthcareCategory.values.firstWhere((e) => e.name == c)).toList(),
      rating: json['rating'].toDouble(),
      totalPatients: json['totalPatients'],
      totalAppointments: json['totalAppointments'],
      languages: List<String>.from(json['languages']),
      credentials: Map<String, dynamic>.from(json['credentials']),
      isVerified: json['isVerified'],
      isAvailable: json['isAvailable'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  HealthcareProvider copyWith({
    String? id,
    String? name,
    String? specialization,
    String? licenseNumber,
    String? imageUrl,
    String? description,
    List<HealthcareCategory>? categories,
    double? rating,
    int? totalPatients,
    int? totalAppointments,
    List<String>? languages,
    Map<String, dynamic>? credentials,
    bool? isVerified,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HealthcareProvider(
      id: id ?? this.id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      totalPatients: totalPatients ?? this.totalPatients,
      totalAppointments: totalAppointments ?? this.totalAppointments,
      languages: languages ?? this.languages,
      credentials: credentials ?? this.credentials,
      isVerified: isVerified ?? this.isVerified,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Appointment
class Appointment {
  final String id;
  final String patientId;
  final String providerId;
  final DateTime scheduledAt;
  final int duration; // in minutes
  final String reason;
  final String notes;
  final AppointmentStatus status;
  final PaymentStatus paymentStatus;
  final double cost;
  final String currency;
  final String? meetingLink;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final Map<String, dynamic> metadata;

  Appointment({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.scheduledAt,
    required this.duration,
    required this.reason,
    required this.notes,
    required this.status,
    required this.paymentStatus,
    required this.cost,
    required this.currency,
    this.meetingLink,
    this.startedAt,
    this.completedAt,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'scheduledAt': scheduledAt.toIso8601String(),
      'duration': duration,
      'reason': reason,
      'notes': notes,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'cost': cost,
      'currency': currency,
      'meetingLink': meetingLink,
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      patientId: json['patientId'],
      providerId: json['providerId'],
      scheduledAt: DateTime.parse(json['scheduledAt']),
      duration: json['duration'],
      reason: json['reason'],
      notes: json['notes'],
      status: AppointmentStatus.values.firstWhere((e) => e.name == json['status']),
      paymentStatus: PaymentStatus.values.firstWhere((e) => e.name == json['paymentStatus']),
      cost: json['cost'].toDouble(),
      currency: json['currency'],
      meetingLink: json['meetingLink'],
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Appointment copyWith({
    String? id,
    String? patientId,
    String? providerId,
    DateTime? scheduledAt,
    int? duration,
    String? reason,
    String? notes,
    AppointmentStatus? status,
    PaymentStatus? paymentStatus,
    double? cost,
    String? currency,
    String? meetingLink,
    DateTime? startedAt,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) {
    return Appointment(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      providerId: providerId ?? this.providerId,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      duration: duration ?? this.duration,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
      meetingLink: meetingLink ?? this.meetingLink,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Medical Record
class MedicalRecord {
  final String id;
  final String patientId;
  final String providerId;
  final DateTime date;
  final String diagnosis;
  final String treatment;
  final List<String> medications;
  final List<String> symptoms;
  final List<String> tests;
  final String notes;
  final Map<String, dynamic> vitals;
  final List<String> attachments;
  final bool isPrivate;
  final Map<String, dynamic> metadata;

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.date,
    required this.diagnosis,
    required this.treatment,
    required this.medications,
    required this.symptoms,
    required this.tests,
    required this.notes,
    required this.vitals,
    required this.attachments,
    required this.isPrivate,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'date': date.toIso8601String(),
      'diagnosis': diagnosis,
      'treatment': treatment,
      'medications': medications,
      'symptoms': symptoms,
      'tests': tests,
      'notes': notes,
      'vitals': vitals,
      'attachments': attachments,
      'isPrivate': isPrivate,
      'metadata': metadata,
    };
  }

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
      id: json['id'],
      patientId: json['patientId'],
      providerId: json['providerId'],
      date: DateTime.parse(json['date']),
      diagnosis: json['diagnosis'],
      treatment: json['treatment'],
      medications: List<String>.from(json['medications']),
      symptoms: List<String>.from(json['symptoms']),
      tests: List<String>.from(json['tests']),
      notes: json['notes'],
      vitals: Map<String, dynamic>.from(json['vitals']),
      attachments: List<String>.from(json['attachments']),
      isPrivate: json['isPrivate'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  MedicalRecord copyWith({
    String? id,
    String? patientId,
    String? providerId,
    DateTime? date,
    String? diagnosis,
    String? treatment,
    List<String>? medications,
    List<String>? symptoms,
    List<String>? tests,
    String? notes,
    Map<String, dynamic>? vitals,
    List<String>? attachments,
    bool? isPrivate,
    Map<String, dynamic>? metadata,
  }) {
    return MedicalRecord(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      providerId: providerId ?? this.providerId,
      date: date ?? this.date,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      medications: medications ?? this.medications,
      symptoms: symptoms ?? this.symptoms,
      tests: tests ?? this.tests,
      notes: notes ?? this.notes,
      vitals: vitals ?? this.vitals,
      attachments: attachments ?? this.attachments,
      isPrivate: isPrivate ?? this.isPrivate,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Insurance Plan
class InsurancePlan {
  final String id;
  final String name;
  final String provider;
  final String description;
  final double monthlyPremium;
  final double deductible;
  final double copay;
  final String currency;
  final List<String> coveredServices;
  final List<String> excludedServices;
  final DateTime startDate;
  final DateTime endDate;
  final InsuranceStatus status;
  final Map<String, dynamic> benefits;
  final Map<String, dynamic> metadata;

  InsurancePlan({
    required this.id,
    required this.name,
    required this.provider,
    required this.description,
    required this.monthlyPremium,
    required this.deductible,
    required this.copay,
    required this.currency,
    required this.coveredServices,
    required this.excludedServices,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.benefits,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'provider': provider,
      'description': description,
      'monthlyPremium': monthlyPremium,
      'deductible': deductible,
      'copay': copay,
      'currency': currency,
      'coveredServices': coveredServices,
      'excludedServices': excludedServices,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
      'benefits': benefits,
      'metadata': metadata,
    };
  }

  factory InsurancePlan.fromJson(Map<String, dynamic> json) {
    return InsurancePlan(
      id: json['id'],
      name: json['name'],
      provider: json['provider'],
      description: json['description'],
      monthlyPremium: json['monthlyPremium'].toDouble(),
      deductible: json['deductible'].toDouble(),
      copay: json['copay'].toDouble(),
      currency: json['currency'] ?? 'USD',
      coveredServices: List<String>.from(json['coveredServices']),
      excludedServices: List<String>.from(json['excludedServices']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      status: InsuranceStatus.values.firstWhere((e) => e.name == json['status']),
      benefits: Map<String, dynamic>.from(json['benefits']),
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  InsurancePlan copyWith({
    String? id,
    String? name,
    String? provider,
    String? description,
    double? monthlyPremium,
    double? deductible,
    double? copay,
    String? currency,
    List<String>? coveredServices,
    List<String>? excludedServices,
    DateTime? startDate,
    DateTime? endDate,
    InsuranceStatus? status,
    Map<String, dynamic>? benefits,
    Map<String, dynamic>? metadata,
  }) {
    return InsurancePlan(
      id: id ?? this.id,
      name: name ?? this.name,
      provider: provider ?? this.provider,
      description: description ?? this.description,
      monthlyPremium: monthlyPremium ?? this.monthlyPremium,
      deductible: deductible ?? this.deductible,
      copay: copay ?? this.copay,
      currency: currency ?? this.currency,
      coveredServices: coveredServices ?? this.coveredServices,
      excludedServices: excludedServices ?? this.excludedServices,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      benefits: benefits ?? this.benefits,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Prescription
class Prescription {
  final String id;
  final String patientId;
  final String providerId;
  final DateTime prescribedAt;
  final DateTime? expiresAt;
  final List<Medication> medications;
  final String instructions;
  final String notes;
  final bool isActive;
  final bool requiresRefill;
  final Map<String, dynamic> metadata;

  Prescription({
    required this.id,
    required this.patientId,
    required this.providerId,
    required this.prescribedAt,
    this.expiresAt,
    required this.medications,
    required this.instructions,
    required this.notes,
    required this.isActive,
    required this.requiresRefill,
    required this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'providerId': providerId,
      'prescribedAt': prescribedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'medications': medications.map((m) => m.toJson()).toList(),
      'instructions': instructions,
      'notes': notes,
      'isActive': isActive,
      'requiresRefill': requiresRefill,
      'metadata': metadata,
    };
  }

  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      patientId: json['patientId'],
      providerId: json['providerId'],
      prescribedAt: DateTime.parse(json['prescribedAt']),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt']) : null,
      medications: (json['medications'] as List).map((m) => Medication.fromJson(m)).toList(),
      instructions: json['instructions'],
      notes: json['notes'],
      isActive: json['isActive'],
      requiresRefill: json['requiresRefill'],
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  Prescription copyWith({
    String? id,
    String? patientId,
    String? providerId,
    DateTime? prescribedAt,
    DateTime? expiresAt,
    List<Medication>? medications,
    String? instructions,
    String? notes,
    bool? isActive,
    bool? requiresRefill,
    Map<String, dynamic>? metadata,
  }) {
    return Prescription(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      providerId: providerId ?? this.providerId,
      prescribedAt: prescribedAt ?? this.prescribedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      medications: medications ?? this.medications,
      instructions: instructions ?? this.instructions,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      requiresRefill: requiresRefill ?? this.requiresRefill,
      metadata: metadata ?? this.metadata,
    );
  }
}

// Medication
class Medication {
  final String id;
  final String name;
  final String genericName;
  final String dosage;
  final String frequency;
  final int quantity;
  final String instructions;
  final List<String> sideEffects;
  final List<String> interactions;
  final bool requiresPrescription;
  final double cost;
  final String currency;

  Medication({
    required this.id,
    required this.name,
    required this.genericName,
    required this.dosage,
    required this.frequency,
    required this.quantity,
    required this.instructions,
    required this.sideEffects,
    required this.interactions,
    required this.requiresPrescription,
    required this.cost,
    required this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genericName': genericName,
      'dosage': dosage,
      'frequency': frequency,
      'quantity': quantity,
      'instructions': instructions,
      'sideEffects': sideEffects,
      'interactions': interactions,
      'requiresPrescription': requiresPrescription,
      'cost': cost,
      'currency': currency,
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'],
      name: json['name'],
      genericName: json['genericName'],
      dosage: json['dosage'],
      frequency: json['frequency'],
      quantity: json['quantity'],
      instructions: json['instructions'],
      sideEffects: List<String>.from(json['sideEffects']),
      interactions: List<String>.from(json['interactions']),
      requiresPrescription: json['requiresPrescription'],
      cost: json['cost'].toDouble(),
      currency: json['currency'],
    );
  }

  Medication copyWith({
    String? id,
    String? name,
    String? genericName,
    String? dosage,
    String? frequency,
    int? quantity,
    String? instructions,
    List<String>? sideEffects,
    List<String>? interactions,
    bool? requiresPrescription,
    double? cost,
    String? currency,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      genericName: genericName ?? this.genericName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      quantity: quantity ?? this.quantity,
      instructions: instructions ?? this.instructions,
      sideEffects: sideEffects ?? this.sideEffects,
      interactions: interactions ?? this.interactions,
      requiresPrescription: requiresPrescription ?? this.requiresPrescription,
      cost: cost ?? this.cost,
      currency: currency ?? this.currency,
    );
  }
}

// Web3 Healthcare Provider
class Web3HealthcareProvider extends ChangeNotifier {
  List<HealthcareProvider> _providers = [];
  List<Appointment> _appointments = [];
  List<MedicalRecord> _medicalRecords = [];
  List<InsurancePlan> _insurancePlans = [];
  List<Prescription> _prescriptions = [];
  String _currentUserId = 'current_user';

  // Getters
  List<HealthcareProvider> get providers => _providers;
  List<Appointment> get appointments => _appointments;
  List<MedicalRecord> get medicalRecords => _medicalRecords;
  List<InsurancePlan> get insurancePlans => _insurancePlans;
  List<Prescription> get prescriptions => _prescriptions;
  String get currentUserId => _currentUserId;

  List<HealthcareProvider> get availableProviders => _providers.where((provider) => provider.isAvailable).toList();
  List<HealthcareProvider> get verifiedProviders => _providers.where((provider) => provider.isVerified).toList();

  List<Appointment> getUserAppointments(String userId) {
    return _appointments.where((appointment) => appointment.patientId == userId).toList();
  }

  List<MedicalRecord> getUserMedicalRecords(String userId) {
    return _medicalRecords.where((record) => record.patientId == userId && !record.isPrivate).toList();
  }

  List<Prescription> getUserPrescriptions(String userId) {
    return _prescriptions.where((prescription) => prescription.patientId == userId && prescription.isActive).toList();
  }

  // Initialize
  Future<void> initialize() async {
    await _loadData();
    if (_providers.isEmpty) {
      _createDemoData();
    }
  }

  // Load data from SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    final providersJson = prefs.getString('web3_healthcare_providers');
    if (providersJson != null) {
      final providersList = json.decode(providersJson) as List;
      _providers = providersList.map((json) => HealthcareProvider.fromJson(json)).toList();
    }

    final appointmentsJson = prefs.getString('web3_healthcare_appointments');
    if (appointmentsJson != null) {
      final appointmentsList = json.decode(appointmentsJson) as List;
      _appointments = appointmentsList.map((json) => Appointment.fromJson(json)).toList();
    }

    final medicalRecordsJson = prefs.getString('web3_healthcare_medical_records');
    if (medicalRecordsJson != null) {
      final medicalRecordsList = json.decode(medicalRecordsJson) as List;
      _medicalRecords = medicalRecordsList.map((json) => MedicalRecord.fromJson(json)).toList();
    }

    final insurancePlansJson = prefs.getString('web3_healthcare_insurance_plans');
    if (insurancePlansJson != null) {
      final insurancePlansList = json.decode(insurancePlansJson) as List;
      _insurancePlans = insurancePlansList.map((json) => InsurancePlan.fromJson(json)).toList();
    }

    final prescriptionsJson = prefs.getString('web3_healthcare_prescriptions');
    if (prescriptionsJson != null) {
      final prescriptionsList = json.decode(prescriptionsJson) as List;
      _prescriptions = prescriptionsList.map((json) => Prescription.fromJson(json)).toList();
    }

    notifyListeners();
  }

  // Save data to SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('web3_healthcare_providers', json.encode(_providers.map((p) => p.toJson()).toList()));
    await prefs.setString('web3_healthcare_appointments', json.encode(_appointments.map((a) => a.toJson()).toList()));
    await prefs.setString('web3_healthcare_medical_records', json.encode(_medicalRecords.map((m) => m.toJson()).toList()));
    await prefs.setString('web3_healthcare_insurance_plans', json.encode(_insurancePlans.map((i) => i.toJson()).toList()));
    await prefs.setString('web3_healthcare_prescriptions', json.encode(_prescriptions.map((p) => p.toJson()).toList()));
  }

  // Create demo data
  void _createDemoData() {
    // Create demo healthcare providers
    final doctorSmith = HealthcareProvider(
      id: 'doctor_smith',
      name: 'Доктор Смит',
      specialization: 'Кардиолог',
      licenseNumber: 'MD123456',
      imageUrl: 'https://via.placeholder.com/150x150/4CAF50/FFFFFF?text=Dr.Smith',
      description: 'Опытный кардиолог с 15-летним стажем работы. Специализируется на лечении сердечно-сосудистых заболеваний.',
      categories: [HealthcareCategory.telemedicine, HealthcareCategory.treatment],
      rating: 4.8,
      totalPatients: 1250,
      totalAppointments: 3200,
      languages: ['Русский', 'Английский'],
      credentials: {
        'education': 'Медицинский университет',
        'experience': '15 лет',
        'certifications': ['Кардиология', 'ЭКГ', 'УЗИ сердца'],
      },
      isVerified: true,
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    );

    final doctorJohnson = HealthcareProvider(
      id: 'doctor_johnson',
      name: 'Доктор Джонсон',
      specialization: 'Психиатр',
      licenseNumber: 'MD789012',
      imageUrl: 'https://via.placeholder.com/150x150/2196F3/FFFFFF?text=Dr.Johnson',
      description: 'Специалист по психическому здоровью. Помогает пациентам с депрессией, тревожностью и другими расстройствами.',
      categories: [HealthcareCategory.mental_health, HealthcareCategory.telemedicine],
      rating: 4.9,
      totalPatients: 890,
      totalAppointments: 2100,
      languages: ['Русский', 'Английский', 'Немецкий'],
      credentials: {
        'education': 'Психиатрический институт',
        'experience': '12 лет',
        'certifications': ['Психиатрия', 'Психотерапия', 'Когнитивно-поведенческая терапия'],
      },
      isVerified: true,
      isAvailable: true,
      createdAt: DateTime.now().subtract(const Duration(days: 300)),
    );

    _providers.addAll([doctorSmith, doctorJohnson]);

    // Create demo insurance plans
    final basicPlan = InsurancePlan(
      id: 'basic_plan',
      name: 'Базовый план',
      provider: 'Медицинская страховая компания',
      description: 'Базовое медицинское страхование с покрытием основных услуг',
      monthlyPremium: 50.0,
      deductible: 500.0,
      copay: 25.0,
      currency: 'USD',
      coveredServices: ['Консультации', 'Диагностика', 'Базовое лечение'],
      excludedServices: ['Косметическая хирургия', 'Экспериментальные методы'],
      startDate: DateTime.now(),
      endDate: DateTime.now().add(const Duration(days: 365)),
      status: InsuranceStatus.active,
      benefits: {
        'consultations': '100% покрытие',
        'diagnostics': '80% покрытие',
        'treatment': '70% покрытие',
      },
      metadata: {},
    );

    _insurancePlans.add(basicPlan);

    _saveData();
  }

  // Provider Management
  void createProvider(HealthcareProvider provider) {
    _providers.add(provider);
    _saveData();
    notifyListeners();
  }

  void updateProvider(String providerId, HealthcareProvider updatedProvider) {
    final index = _providers.indexWhere((provider) => provider.id == providerId);
    if (index != -1) {
      _providers[index] = updatedProvider;
      _saveData();
      notifyListeners();
    }
  }

  void deleteProvider(String providerId) {
    _providers.removeWhere((provider) => provider.id == providerId);
    _saveData();
    notifyListeners();
  }

  // Appointment Management
  void createAppointment(Appointment appointment) {
    _appointments.add(appointment);
    _saveData();
    notifyListeners();
  }

  void updateAppointment(String appointmentId, Appointment updatedAppointment) {
    final index = _appointments.indexWhere((appointment) => appointment.id == appointmentId);
    if (index != -1) {
      _appointments[index] = updatedAppointment;
      _saveData();
      notifyListeners();
    }
  }

  void cancelAppointment(String appointmentId) {
    final index = _appointments.indexWhere((appointment) => appointment.id == appointmentId);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        status: AppointmentStatus.cancelled,
      );
      _saveData();
      notifyListeners();
    }
  }

  // Medical Record Management
  void createMedicalRecord(MedicalRecord record) {
    _medicalRecords.add(record);
    _saveData();
    notifyListeners();
  }

  void updateMedicalRecord(String recordId, MedicalRecord updatedRecord) {
    final index = _medicalRecords.indexWhere((record) => record.id == recordId);
    if (index != -1) {
      _medicalRecords[index] = updatedRecord;
      _saveData();
      notifyListeners();
    }
  }

  // Insurance Management
  void createInsurancePlan(InsurancePlan plan) {
    _insurancePlans.add(plan);
    _saveData();
    notifyListeners();
  }

  void updateInsurancePlan(String planId, InsurancePlan updatedPlan) {
    final index = _insurancePlans.indexWhere((plan) => plan.id == planId);
    if (index != -1) {
      _insurancePlans[index] = updatedPlan;
      _saveData();
      notifyListeners();
    }
  }

  // Prescription Management
  void createPrescription(Prescription prescription) {
    _prescriptions.add(prescription);
    _saveData();
    notifyListeners();
  }

  void updatePrescription(String prescriptionId, Prescription updatedPrescription) {
    final index = _prescriptions.indexWhere((prescription) => prescription.id == prescriptionId);
    if (index != -1) {
      _prescriptions[index] = updatedPrescription;
      _saveData();
      notifyListeners();
    }
  }

  // Search and Filter
  List<HealthcareProvider> searchProviders(String query) {
    if (query.isEmpty) return _providers;

    return _providers.where((provider) =>
        provider.name.toLowerCase().contains(query.toLowerCase()) ||
        provider.specialization.toLowerCase().contains(query.toLowerCase()) ||
        provider.description.toLowerCase().contains(query.toLowerCase())).toList();
  }

  List<HealthcareProvider> getProvidersByCategory(HealthcareCategory category) {
    return _providers.where((provider) => provider.categories.contains(category)).toList();
  }

  List<HealthcareProvider> getProvidersByRating(double minRating) {
    return _providers.where((provider) => provider.rating >= minRating).toList();
  }

  // Analytics
  double getProviderAverageRating() {
    if (_providers.isEmpty) return 0.0;
    final totalRating = _providers.fold(0.0, (sum, provider) => sum + provider.rating);
    return totalRating / _providers.length;
  }

  int getTotalAppointments() {
    return _appointments.length;
  }

  int getActiveAppointments() {
    return _appointments.where((appointment) => 
        appointment.status == AppointmentStatus.scheduled || 
        appointment.status == AppointmentStatus.confirmed).length;
  }

  int getCompletedAppointments() {
    return _appointments.where((appointment) => 
        appointment.status == AppointmentStatus.completed).length;
  }

  // Utility methods
  String getHealthcareCategoryName(HealthcareCategory category) {
    switch (category) {
      case HealthcareCategory.telemedicine:
        return 'Телемедицина';
      case HealthcareCategory.diagnostics:
        return 'Диагностика';
      case HealthcareCategory.treatment:
        return 'Лечение';
      case HealthcareCategory.prevention:
        return 'Профилактика';
      case HealthcareCategory.mental_health:
        return 'Психическое здоровье';
      case HealthcareCategory.emergency:
        return 'Экстренная помощь';
      case HealthcareCategory.rehabilitation:
        return 'Реабилитация';
      case HealthcareCategory.wellness:
        return 'Здоровье';
      case HealthcareCategory.nutrition:
        return 'Питание';
      case HealthcareCategory.fitness:
        return 'Фитнес';
    }
  }

  String getAppointmentStatusName(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'Запланировано';
      case AppointmentStatus.confirmed:
        return 'Подтверждено';
      case AppointmentStatus.in_progress:
        return 'В процессе';
      case AppointmentStatus.completed:
        return 'Завершено';
      case AppointmentStatus.cancelled:
        return 'Отменено';
      case AppointmentStatus.no_show:
        return 'Не явился';
    }
  }

  String getPaymentStatusName(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return 'Ожидает оплаты';
      case PaymentStatus.completed:
        return 'Оплачено';
      case PaymentStatus.failed:
        return 'Ошибка оплаты';
      case PaymentStatus.refunded:
        return 'Возвращено';
      case PaymentStatus.disputed:
        return 'Оспорено';
    }
  }

  String getInsuranceStatusName(InsuranceStatus status) {
    switch (status) {
      case InsuranceStatus.active:
        return 'Активно';
      case InsuranceStatus.expired:
        return 'Истекло';
      case InsuranceStatus.pending:
        return 'Ожидает активации';
      case InsuranceStatus.rejected:
        return 'Отклонено';
      case InsuranceStatus.suspended:
        return 'Приостановлено';
    }
  }
}
