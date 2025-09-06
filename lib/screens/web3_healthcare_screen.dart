import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rechain_vc_lab/providers/web3_healthcare_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class Web3HealthcareScreen extends StatefulWidget {
  const Web3HealthcareScreen({super.key});

  @override
  State<Web3HealthcareScreen> createState() => _Web3HealthcareScreenState();
}

class _Web3HealthcareScreenState extends State<Web3HealthcareScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  HealthcareCategory? _selectedCategory;
  double _minRating = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Web3HealthcareProvider>().initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  '🏥 Web3 Healthcare',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.8),
                        AppTheme.secondaryColor,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.medical_services,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Поиск врачей, специализаций...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            // Overview Cards
            Container(
              padding: const EdgeInsets.all(16),
              child: Consumer<Web3HealthcareProvider>(
                builder: (context, provider, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildOverviewCard(
                          'Врачи',
                          provider.providers.length.toString(),
                          Icons.medical_services,
                          Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOverviewCard(
                          'Приемы',
                          provider.getTotalAppointments().toString(),
                          Icons.calendar_today,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOverviewCard(
                          'Рейтинг',
                          provider.getProviderAverageRating().toStringAsFixed(1),
                          Icons.star,
                          Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildOverviewCard(
                          'Страховки',
                          provider.insurancePlans.length.toString(),
                          Icons.security,
                          Colors.purple,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // Filters
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<HealthcareCategory>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Категория',
                        border: OutlineInputBorder(),
                      ),
                      items: HealthcareCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(
                            context.read<Web3HealthcareProvider>().getHealthcareCategoryName(category),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Мин. рейтинг: ${_minRating.toStringAsFixed(1)}'),
                        Slider(
                          value: _minRating,
                          min: 0.0,
                          max: 5.0,
                          divisions: 10,
                          onChanged: (value) {
                            setState(() {
                              _minRating = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Tab Bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Врачи'),
                Tab(text: 'Приемы'),
                Tab(text: 'Медицинские записи'),
                Tab(text: 'Страховки'),
                Tab(text: 'Рецепты'),
              ],
            ),
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProvidersTab(),
                  _buildAppointmentsTab(),
                  _buildMedicalRecordsTab(),
                  _buildInsuranceTab(),
                  _buildPrescriptionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateItemDialog(),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProvidersTab() {
    return Consumer<Web3HealthcareProvider>(
      builder: (context, provider, child) {
        var filteredProviders = provider.providers;

        // Apply search filter
        if (_searchController.text.isNotEmpty) {
          filteredProviders = provider.searchProviders(_searchController.text);
        }

        // Apply category filter
        if (_selectedCategory != null) {
          filteredProviders = filteredProviders.where((p) => p.categories.contains(_selectedCategory)).toList();
        }

        // Apply rating filter
        filteredProviders = filteredProviders.where((p) => p.rating >= _minRating).toList();

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredProviders.length,
          itemBuilder: (context, index) {
            final providerItem = filteredProviders[index];
            return _buildProviderCard(providerItem, provider);
          },
        );
      },
    );
  }

  Widget _buildProviderCard(HealthcareProvider providerItem, Web3HealthcareProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(providerItem.imageUrl),
          backgroundColor: Colors.grey[300],
        ),
        title: Row(
          children: [
            Text(providerItem.name),
            if (providerItem.isVerified)
              const Icon(Icons.verified, color: Colors.blue, size: 20),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(providerItem.specialization),
            Row(
              children: [
                Icon(Icons.star, color: Colors.orange, size: 16),
                Text('${providerItem.rating} (${providerItem.totalPatients} пациентов)'),
              ],
            ),
            Wrap(
              spacing: 4,
              children: providerItem.categories.take(3).map((category) {
                return Chip(
                  label: Text(
                    provider.getHealthcareCategoryName(category),
                    style: const TextStyle(fontSize: 10),
                  ),
                  backgroundColor: Colors.blue[100],
                );
              }).toList(),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showProviderDetails(providerItem, provider),
        ),
        onTap: () => _showProviderDetails(providerItem, provider),
      ),
    );
  }

  Widget _buildAppointmentsTab() {
    return Consumer<Web3HealthcareProvider>(
      builder: (context, provider, child) {
        final userAppointments = provider.getUserAppointments(provider.currentUserId);
        
        if (userAppointments.isEmpty) {
          return const Center(
            child: Text('У вас пока нет записей на прием'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: userAppointments.length,
          itemBuilder: (context, index) {
            final appointment = userAppointments[index];
            final providerItem = provider.providers.firstWhere(
              (p) => p.id == appointment.providerId,
              orElse: () => HealthcareProvider(
                id: 'unknown',
                name: 'Неизвестный врач',
                specialization: 'Неизвестно',
                licenseNumber: '',
                imageUrl: '',
                description: '',
                categories: [],
                rating: 0.0,
                totalPatients: 0,
                totalAppointments: 0,
                languages: [],
                credentials: {},
                isVerified: false,
                isAvailable: false,
                createdAt: DateTime.now(),
              ),
            );

            return _buildAppointmentCard(appointment, providerItem, provider);
          },
        );
      },
    );
  }

  Widget _buildAppointmentCard(Appointment appointment, HealthcareProvider providerItem, Web3HealthcareProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(providerItem.imageUrl),
          backgroundColor: Colors.grey[300],
        ),
        title: Text('Прием у ${providerItem.name}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Дата: ${DateFormat('dd.MM.yyyy HH:mm').format(appointment.scheduledAt)}'),
            Text('Длительность: ${appointment.duration} мин'),
            Text('Причина: ${appointment.reason}'),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(appointment.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    provider.getAppointmentStatusName(appointment.status),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPaymentStatusColor(appointment.paymentStatus),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    provider.getPaymentStatusName(appointment.paymentStatus),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showAppointmentDetails(appointment, providerItem, provider),
        ),
        onTap: () => _showAppointmentDetails(appointment, providerItem, provider),
      ),
    );
  }

  Widget _buildMedicalRecordsTab() {
    return Consumer<Web3HealthcareProvider>(
      builder: (context, provider, child) {
        final userRecords = provider.getUserMedicalRecords(provider.currentUserId);
        
        if (userRecords.isEmpty) {
          return const Center(
            child: Text('У вас пока нет медицинских записей'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: userRecords.length,
          itemBuilder: (context, index) {
            final record = userRecords[index];
            final providerItem = provider.providers.firstWhere(
              (p) => p.id == record.providerId,
              orElse: () => HealthcareProvider(
                id: 'unknown',
                name: 'Неизвестный врач',
                specialization: 'Неизвестно',
                licenseNumber: '',
                imageUrl: '',
                description: '',
                categories: [],
                rating: 0.0,
                totalPatients: 0,
                totalAppointments: 0,
                languages: [],
                credentials: {},
                isVerified: false,
                isAvailable: false,
                createdAt: DateTime.now(),
              ),
            );

            return _buildMedicalRecordCard(record, providerItem, provider);
          },
        );
      },
    );
  }

  Widget _buildMedicalRecordCard(MedicalRecord record, HealthcareProvider providerItem, Web3HealthcareProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.green[100],
          child: const Icon(Icons.medical_information, color: Colors.green),
        ),
        title: Text('Запись от ${DateFormat('dd.MM.yyyy').format(record.date)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Врач: ${providerItem.name}'),
            Text('Диагноз: ${record.diagnosis}'),
            if (record.medications.isNotEmpty)
              Text('Лекарства: ${record.medications.take(2).join(', ')}${record.medications.length > 2 ? '...' : ''}'),
            if (record.symptoms.isNotEmpty)
              Text('Симптомы: ${record.symptoms.take(2).join(', ')}${record.symptoms.length > 2 ? '...' : ''}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showMedicalRecordDetails(record, providerItem, provider),
        ),
        onTap: () => _showMedicalRecordDetails(record, providerItem, provider),
      ),
    );
  }

  Widget _buildInsuranceTab() {
    return Consumer<Web3HealthcareProvider>(
      builder: (context, provider, child) {
        if (provider.insurancePlans.isEmpty) {
          return const Center(
            child: Text('У вас пока нет страховых планов'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.insurancePlans.length,
          itemBuilder: (context, index) {
            final plan = provider.insurancePlans[index];
            return _buildInsuranceCard(plan, provider);
          },
        );
      },
    );
  }

  Widget _buildInsuranceCard(InsurancePlan plan, Web3HealthcareProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.purple[100],
          child: const Icon(Icons.security, color: Colors.purple),
        ),
        title: Text(plan.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Провайдер: ${plan.provider}'),
            Text('Ежемесячный взнос: ${plan.monthlyPremium} ${plan.currency}'),
            Text('Франшиза: ${plan.deductible} ${plan.currency}'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getInsuranceStatusColor(plan.status),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                provider.getInsuranceStatusName(plan.status),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showInsuranceDetails(plan, provider),
        ),
        onTap: () => _showInsuranceDetails(plan, provider),
      ),
    );
  }

  Widget _buildPrescriptionsTab() {
    return Consumer<Web3HealthcareProvider>(
      builder: (context, provider, child) {
        final userPrescriptions = provider.getUserPrescriptions(provider.currentUserId);
        
        if (userPrescriptions.isEmpty) {
          return const Center(
            child: Text('У вас пока нет рецептов'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: userPrescriptions.length,
          itemBuilder: (context, index) {
            final prescription = userPrescriptions[index];
            final providerItem = provider.providers.firstWhere(
              (p) => p.id == prescription.providerId,
              orElse: () => HealthcareProvider(
                id: 'unknown',
                name: 'Неизвестный врач',
                specialization: 'Неизвестно',
                licenseNumber: '',
                imageUrl: '',
                description: '',
                categories: [],
                rating: 0.0,
                totalPatients: 0,
                totalAppointments: 0,
                languages: [],
                credentials: {},
                isVerified: false,
                isAvailable: false,
                createdAt: DateTime.now(),
              ),
            );

            return _buildPrescriptionCard(prescription, providerItem, provider);
          },
        );
      },
    );
  }

  Widget _buildPrescriptionCard(Prescription prescription, HealthcareProvider providerItem, Web3HealthcareProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.orange[100],
          child: const Icon(Icons.medication, color: Colors.orange),
        ),
        title: Text('Рецепт от ${DateFormat('dd.MM.yyyy').format(prescription.prescribedAt)}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Врач: ${providerItem.name}'),
            Text('Лекарств: ${prescription.medications.length}'),
            Text('Инструкции: ${prescription.instructions}'),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: prescription.isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    prescription.isActive ? 'Активен' : 'Неактивен',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                if (prescription.requiresRefill) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Требует пополнения',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showPrescriptionDetails(prescription, providerItem, provider),
        ),
        onTap: () => _showPrescriptionDetails(prescription, providerItem, provider),
      ),
    );
  }

  // Helper methods for status colors
  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Colors.blue;
      case AppointmentStatus.confirmed:
        return Colors.green;
      case AppointmentStatus.in_progress:
        return Colors.orange;
      case AppointmentStatus.completed:
        return Colors.grey;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.no_show:
        return Colors.purple;
    }
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.completed:
        return Colors.green;
      case PaymentStatus.failed:
        return Colors.red;
      case PaymentStatus.refunded:
        return Colors.blue;
      case PaymentStatus.disputed:
        return Colors.purple;
    }
  }

  Color _getInsuranceStatusColor(InsuranceStatus status) {
    switch (status) {
      case InsuranceStatus.active:
        return Colors.green;
      case InsuranceStatus.expired:
        return Colors.red;
      case InsuranceStatus.pending:
        return Colors.orange;
      case InsuranceStatus.rejected:
        return Colors.red;
      case InsuranceStatus.suspended:
        return Colors.orange;
    }
  }

  // Dialog methods
  void _showCreateItemDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать новый элемент'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Записаться на прием'),
              onTap: () {
                Navigator.pop(context);
                _showCreateAppointmentDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_information),
              title: const Text('Создать медицинскую запись'),
              onTap: () {
                Navigator.pop(context);
                _showCreateMedicalRecordDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.security),
              title: const Text('Добавить страховой план'),
              onTap: () {
                Navigator.pop(context);
                _showCreateInsuranceDialog();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  void _showCreateAppointmentDialog() {
    // TODO: Implement create appointment dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Функция создания записи на прием будет добавлена позже')),
    );
  }

  void _showCreateMedicalRecordDialog() {
    // TODO: Implement create medical record dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Функция создания медицинской записи будет добавлена позже')),
    );
  }

  void _showCreateInsuranceDialog() {
    // TODO: Implement create insurance dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Функция создания страхового плана будет добавлена позже')),
    );
  }

  void _showProviderDetails(HealthcareProvider providerItem, Web3HealthcareProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(providerItem.imageUrl),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(providerItem.name)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Специализация:', providerItem.specialization),
              _buildDetailRow('Лицензия:', providerItem.licenseNumber),
              _buildDetailRow('Описание:', providerItem.description),
              _buildDetailRow('Рейтинг:', '${providerItem.rating}/5'),
              _buildDetailRow('Пациентов:', providerItem.totalPatients.toString()),
              _buildDetailRow('Приемов:', providerItem.totalAppointments.toString()),
              _buildDetailRow('Языки:', providerItem.languages.join(', ')),
              _buildDetailRow('Верифицирован:', providerItem.isVerified ? 'Да' : 'Нет'),
              _buildDetailRow('Доступен:', providerItem.isAvailable ? 'Да' : 'Нет'),
              const SizedBox(height: 16),
              const Text('Категории:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: providerItem.categories.map((category) {
                  return Chip(
                    label: Text(provider.getHealthcareCategoryName(category)),
                    backgroundColor: Colors.blue[100],
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const Text('Образование:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...providerItem.credentials.entries.map((entry) {
                if (entry.value is List) {
                  return _buildDetailRow('${entry.key}:', (entry.value as List).join(', '));
                } else {
                  return _buildDetailRow('${entry.key}:', entry.value.toString());
                }
              }),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showCreateAppointmentDialog();
            },
            child: const Text('Записаться'),
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetails(Appointment appointment, HealthcareProvider providerItem, Web3HealthcareProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Прием у ${providerItem.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Дата:', DateFormat('dd.MM.yyyy HH:mm').format(appointment.scheduledAt)),
              _buildDetailRow('Длительность:', '${appointment.duration} минут'),
              _buildDetailRow('Причина:', appointment.reason),
              _buildDetailRow('Заметки:', appointment.notes),
              _buildDetailRow('Статус:', provider.getAppointmentStatusName(appointment.status)),
              _buildDetailRow('Статус оплаты:', provider.getPaymentStatusName(appointment.paymentStatus)),
              _buildDetailRow('Стоимость:', '${appointment.cost} ${appointment.currency}'),
              if (appointment.meetingLink != null)
                _buildDetailRow('Ссылка на встречу:', appointment.meetingLink!),
              if (appointment.startedAt != null)
                _buildDetailRow('Начало:', DateFormat('dd.MM.yyyy HH:mm').format(appointment.startedAt!)),
              if (appointment.completedAt != null)
                _buildDetailRow('Завершение:', DateFormat('dd.MM.yyyy HH:mm').format(appointment.completedAt!)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Закрыть'),
          ),
          if (appointment.status == AppointmentStatus.scheduled)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement join meeting functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Функция присоединения к встрече будет добавлена позже')),
                );
              },
              child: const Text('Присоединиться'),
            ),
        ],
      ),
    );
  }

  void _showMedicalRecordDetails(MedicalRecord record, HealthcareProvider providerItem, Web3HealthcareProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Медицинская запись от ${DateFormat('dd.MM.yyyy').format(record.date)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Врач:', providerItem.name),
              _buildDetailRow('Диагноз:', record.diagnosis),
              _buildDetailRow('Лечение:', record.treatment),
              _buildDetailRow('Лекарства:', record.medications.join(', ')),
              _buildDetailRow('Симптомы:', record.symptoms.join(', ')),
              _buildDetailRow('Анализы:', record.tests.join(', ')),
              _buildDetailRow('Заметки:', record.notes),
              _buildDetailRow('Приватная:', record.isPrivate ? 'Да' : 'Нет'),
              if (record.vitals.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Показатели:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...record.vitals.entries.map((entry) {
                  return _buildDetailRow('${entry.key}:', entry.value.toString());
                }),
              ],
              if (record.attachments.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Вложения:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...record.attachments.map((attachment) {
                  return ListTile(
                    leading: const Icon(Icons.attachment),
                    title: Text(attachment),
                    onTap: () {
                      // TODO: Implement attachment viewing
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Функция просмотра вложений будет добавлена позже')),
                      );
                    },
                  );
                }),
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

  void _showInsuranceDetails(InsurancePlan plan, Web3HealthcareProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(plan.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Провайдер:', plan.provider),
              _buildDetailRow('Описание:', plan.description),
              _buildDetailRow('Ежемесячный взнос:', '${plan.monthlyPremium} ${plan.currency}'),
              _buildDetailRow('Франшиза:', '${plan.deductible} ${plan.currency}'),
              _buildDetailRow('Совместная оплата:', '${plan.copay} ${plan.currency}'),
              _buildDetailRow('Дата начала:', DateFormat('dd.MM.yyyy').format(plan.startDate)),
              _buildDetailRow('Дата окончания:', DateFormat('dd.MM.yyyy').format(plan.endDate)),
              _buildDetailRow('Статус:', provider.getInsuranceStatusName(plan.status)),
              const SizedBox(height: 16),
              const Text('Покрываемые услуги:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...plan.coveredServices.map((service) {
                return ListTile(
                  leading: const Icon(Icons.check, color: Colors.green),
                  title: Text(service),
                  dense: true,
                );
              }),
              const SizedBox(height: 16),
              const Text('Исключенные услуги:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...plan.excludedServices.map((service) {
                return ListTile(
                  leading: const Icon(Icons.close, color: Colors.red),
                  title: Text(service),
                  dense: true,
                );
              }),
              const SizedBox(height: 16),
              const Text('Преимущества:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...plan.benefits.entries.map((entry) {
                return _buildDetailRow('${entry.key}:', entry.value.toString());
              }),
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

  void _showPrescriptionDetails(Prescription prescription, HealthcareProvider providerItem, Web3HealthcareProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Рецепт от ${DateFormat('dd.MM.yyyy').format(prescription.prescribedAt)}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Врач:', providerItem.name),
              _buildDetailRow('Инструкции:', prescription.instructions),
              _buildDetailRow('Заметки:', prescription.notes),
              _buildDetailRow('Активен:', prescription.isActive ? 'Да' : 'Нет'),
              _buildDetailRow('Требует пополнения:', prescription.requiresRefill ? 'Да' : 'Нет'),
              if (prescription.expiresAt != null)
                _buildDetailRow('Истекает:', DateFormat('dd.MM.yyyy').format(prescription.expiresAt!)),
              const SizedBox(height: 16),
              const Text('Лекарства:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...prescription.medications.map((medication) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(medication.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Дозировка: ${medication.dosage}'),
                        Text('Частота: ${medication.frequency}'),
                        Text('Количество: ${medication.quantity}'),
                        Text('Инструкции: ${medication.instructions}'),
                        Text('Стоимость: ${medication.cost} ${medication.currency}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.info),
                      onPressed: () => _showMedicationDetails(medication),
                    ),
                  ),
                );
              }),
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

  void _showMedicationDetails(Medication medication) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(medication.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Генерическое название:', medication.genericName),
              _buildDetailRow('Дозировка:', medication.dosage),
              _buildDetailRow('Частота:', medication.frequency),
              _buildDetailRow('Количество:', medication.quantity.toString()),
              _buildDetailRow('Инструкции:', medication.instructions),
              _buildDetailRow('Требует рецепт:', medication.requiresPrescription ? 'Да' : 'Нет'),
              _buildDetailRow('Стоимость:', '${medication.cost} ${medication.currency}'),
              if (medication.sideEffects.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Побочные эффекты:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...medication.sideEffects.map((effect) {
                  return ListTile(
                    leading: const Icon(Icons.warning, color: Colors.orange),
                    title: Text(effect),
                    dense: true,
                  );
                }),
              ],
              if (medication.interactions.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Взаимодействия:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...medication.interactions.map((interaction) {
                  return ListTile(
                    leading: const Icon(Icons.info, color: Colors.blue),
                    title: Text(interaction),
                    dense: true,
                  );
                }),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
