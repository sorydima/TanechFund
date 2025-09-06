import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rechain_vc_lab/providers/hardware_wallet_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class HardwareWalletScreen extends StatefulWidget {
  const HardwareWalletScreen({super.key});

  @override
  State<HardwareWalletScreen> createState() => _HardwareWalletScreenState();
}

class _HardwareWalletScreenState extends State<HardwareWalletScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HardwareWalletProvider>().initialize();
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
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Hardware Wallet',
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
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.security,
                      size: 60,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Поиск устройств, аккаунтов...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: 'Устройства'),
                  Tab(text: 'Аккаунты'),
                  Tab(text: 'Транзакции'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDevicesTab(),
                  _buildAccountsTab(),
                  _buildTransactionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevicesTab() {
    return Consumer<HardwareWalletProvider>(
      builder: (context, provider, child) {
        final devices = _searchQuery.isEmpty
            ? provider.devices
            : provider.searchDevices(_searchQuery);

        if (devices.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет устройств',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];
            return _buildDeviceCard(device, provider);
          },
        );
      },
    );
  }

  Widget _buildDeviceCard(HardwareWalletDevice device, HardwareWalletProvider provider) {
    final statusColor = _getStatusColor(device.status);
    final statusIcon = _getStatusIcon(device.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getWalletTypeColor(device.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getWalletTypeIcon(device.type),
                    color: _getWalletTypeColor(device.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${device.model} • ${device.firmwareVersion}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            _getStatusText(device.status),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (device.isLocked)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'ЗАБЛОКИРОВАН',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (device.errorMessage != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        device.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildCapabilityChip('Ethereum', device.capabilities['ethereum'] ?? false),
                ),
                Expanded(
                  child: _buildCapabilityChip('Bitcoin', device.capabilities['bitcoin'] ?? false),
                ),
                Expanded(
                  child: _buildCapabilityChip('Multisig', device.capabilities['multisig'] ?? false),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (device.status == ConnectionStatus.disconnected)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _connectDevice(device.id, provider),
                      icon: const Icon(Icons.link, size: 16),
                      label: const Text('Подключить'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (device.status == ConnectionStatus.connected)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _disconnectDevice(device.id, provider),
                      icon: const Icon(Icons.link_off, size: 16),
                      label: const Text('Отключить'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                if (device.isLocked)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showUnlockDialog(device, provider),
                      icon: const Icon(Icons.lock_open, size: 16),
                      label: const Text('Разблокировать'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showDeviceDetails(device),
                  icon: const Icon(Icons.info),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountsTab() {
    return Consumer<HardwareWalletProvider>(
      builder: (context, provider, child) {
        final accounts = _searchQuery.isEmpty
            ? provider.accounts
            : provider.searchAccounts(_searchQuery);

        if (accounts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет аккаунтов',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final account = accounts[index];
            return _buildAccountCard(account, provider);
          },
        );
      },
    );
  }

  Widget _buildAccountCard(HardwareWalletAccount account, HardwareWalletProvider provider) {
    final device = provider.devices.firstWhere((d) => d.id == account.walletId);
    final isConnected = device.status == ConnectionStatus.connected;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getCurrencyColor(account.currency).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCurrencyIcon(account.currency),
                    color: _getCurrencyColor(account.currency),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        account.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        account.address,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${account.balance.toStringAsFixed(4)} ${account.currency}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (isConnected ? Colors.green : Colors.grey).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isConnected ? 'ПОДКЛЮЧЕН' : 'ОТКЛЮЧЕН',
                        style: TextStyle(
                          color: isConnected ? Colors.green : Colors.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Путь: ${account.derivationPath}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isConnected ? () => _showCreateTransactionDialog(account, provider) : null,
                    icon: const Icon(Icons.send, size: 16),
                    label: const Text('Отправить'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isConnected ? AppTheme.primaryColor : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showAccountDetails(account),
                    icon: const Icon(Icons.info, size: 16),
                    label: const Text('Детали'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      foregroundColor: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return Consumer<HardwareWalletProvider>(
      builder: (context, provider, child) {
        final transactions = provider.pendingTransactions;

        if (transactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет транзакций',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionCard(transaction, provider);
          },
        );
      },
    );
  }

  Widget _buildTransactionCard(TransactionToSign transaction, HardwareWalletProvider provider) {
    final account = provider.accounts.firstWhere((acc) => acc.id == transaction.accountId);
    final isSigned = transaction.isSigned;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getTransactionTypeColor(transaction.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getTransactionTypeIcon(transaction.type),
                    color: _getTransactionTypeColor(transaction.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTransactionTypeText(transaction.type),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        account.name,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isSigned ? Colors.green : Colors.orange).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isSigned ? 'ПОДПИСАНА' : 'ОЖИДАЕТ',
                    style: TextStyle(
                      color: isSigned ? Colors.green : Colors.orange,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (transaction.message != null) ...[
              const SizedBox(height: 12),
              Text(
                transaction.message!,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Создана: ${DateFormat('dd.MM.yyyy HH:mm').format(transaction.createdAt)}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            if (!isSigned)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showSignTransactionDialog(transaction, provider),
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Подписать'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showTransactionDetails(transaction),
                      icon: const Icon(Icons.info, size: 16),
                      label: const Text('Детали'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.1),
                        foregroundColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            if (isSigned && transaction.txHash != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'TX: ${transaction.txHash}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontFamily: 'monospace',
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

  // Helper methods
  Widget _buildCapabilityChip(String label, bool isSupported) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isSupported ? Colors.green : Colors.grey).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSupported ? Colors.green : Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return Colors.green;
      case ConnectionStatus.connecting:
        return Colors.orange;
      case ConnectionStatus.disconnected:
        return Colors.grey;
      case ConnectionStatus.error:
        return Colors.red;
      case ConnectionStatus.locked:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return Icons.check_circle;
      case ConnectionStatus.connecting:
        return Icons.sync;
      case ConnectionStatus.disconnected:
        return Icons.link_off;
      case ConnectionStatus.error:
        return Icons.error;
      case ConnectionStatus.locked:
        return Icons.lock;
    }
  }

  String _getStatusText(ConnectionStatus status) {
    switch (status) {
      case ConnectionStatus.connected:
        return 'ПОДКЛЮЧЕН';
      case ConnectionStatus.connecting:
        return 'ПОДКЛЮЧЕНИЕ';
      case ConnectionStatus.disconnected:
        return 'ОТКЛЮЧЕН';
      case ConnectionStatus.error:
        return 'ОШИБКА';
      case ConnectionStatus.locked:
        return 'ЗАБЛОКИРОВАН';
    }
  }

  Color _getWalletTypeColor(HardwareWalletType type) {
    switch (type) {
      case HardwareWalletType.ledger:
        return Colors.blue;
      case HardwareWalletType.trezor:
        return Colors.green;
      case HardwareWalletType.keystone:
        return Colors.purple;
      case HardwareWalletType.bitbox:
        return Colors.orange;
      case HardwareWalletType.coldcard:
        return Colors.red;
    }
  }

  IconData _getWalletTypeIcon(HardwareWalletType type) {
    switch (type) {
      case HardwareWalletType.ledger:
        return Icons.security;
      case HardwareWalletType.trezor:
        return Icons.phone_android;
      case HardwareWalletType.keystone:
        return Icons.qr_code;
      case HardwareWalletType.bitbox:
        return Icons.smartphone;
      case HardwareWalletType.coldcard:
        return Icons.credit_card;
    }
  }

  Color _getCurrencyColor(String currency) {
    switch (currency.toUpperCase()) {
      case 'ETH':
        return Colors.blue;
      case 'BTC':
        return Colors.orange;
      case 'USDC':
        return Colors.green;
      case 'USDT':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCurrencyIcon(String currency) {
    switch (currency.toUpperCase()) {
      case 'ETH':
        return Icons.currency_bitcoin;
      case 'BTC':
        return Icons.currency_bitcoin;
      case 'USDC':
        return Icons.attach_money;
      case 'USDT':
        return Icons.attach_money;
      default:
        return Icons.currency_exchange;
    }
  }

  Color _getTransactionTypeColor(String type) {
    switch (type) {
      case 'send':
        return Colors.red;
      case 'swap':
        return Colors.blue;
      case 'stake':
        return Colors.green;
      case 'unstake':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransactionTypeIcon(String type) {
    switch (type) {
      case 'send':
        return Icons.send;
      case 'swap':
        return Icons.swap_horiz;
      case 'stake':
        return Icons.lock;
      case 'unstake':
        return Icons.lock_open;
      default:
        return Icons.receipt;
    }
  }

  String _getTransactionTypeText(String type) {
    switch (type) {
      case 'send':
        return 'Отправка';
      case 'swap':
        return 'Обмен';
      case 'stake':
        return 'Стейкинг';
      case 'unstake':
        return 'Вывод из стейкинга';
      default:
        return 'Транзакция';
    }
  }

  // Action methods
  Future<void> _connectDevice(String deviceId, HardwareWalletProvider provider) async {
    final success = await provider.connectDevice(deviceId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Устройство успешно подключено')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка подключения устройства')),
      );
    }
  }

  Future<void> _disconnectDevice(String deviceId, HardwareWalletProvider provider) async {
    final success = await provider.disconnectDevice(deviceId);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Устройство отключено')),
      );
    }
  }

  void _showUnlockDialog(HardwareWalletDevice device, HardwareWalletProvider provider) {
    final pinController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Разблокировать ${device.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Введите PIN-код для разблокировки устройства'),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              decoration: const InputDecoration(
                labelText: 'PIN-код',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await provider.unlockDevice(device.id, pinController.text);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Устройство разблокировано')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Неверный PIN-код')),
                );
              }
            },
            child: const Text('Разблокировать'),
          ),
        ],
      ),
    );
  }

  void _showDeviceDetails(HardwareWalletDevice device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(device.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Модель', device.model),
              _buildDetailRow('Тип', device.type.name.toUpperCase()),
              _buildDetailRow('Версия прошивки', device.firmwareVersion),
              _buildDetailRow('Статус', _getStatusText(device.status)),
              _buildDetailRow('Последнее подключение', 
                  DateFormat('dd.MM.yyyy HH:mm').format(device.lastConnected)),
              _buildDetailRow('Заблокировано', device.isLocked ? 'Да' : 'Нет'),
              if (device.errorMessage != null)
                _buildDetailRow('Ошибка', device.errorMessage!),
              const SizedBox(height: 16),
              const Text('Возможности:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...device.capabilities.entries.map((entry) => 
                  _buildDetailRow(entry.key.toUpperCase(), entry.value.toString())),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showAccountDetails(HardwareWalletAccount account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(account.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Адрес', account.address),
              _buildDetailRow('Путь деривации', account.derivationPath),
              _buildDetailRow('Баланс', '${account.balance} ${account.currency}'),
              _buildDetailRow('Валюта', account.currency),
              _buildDetailRow('Активен', account.isActive ? 'Да' : 'Нет'),
              _buildDetailRow('Последнее использование', 
                  DateFormat('dd.MM.yyyy HH:mm').format(account.lastUsed)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  void _showCreateTransactionDialog(HardwareWalletAccount account, HardwareWalletProvider provider) {
    // TODO: Implement transaction creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Создание транзакции - в разработке')),
    );
  }

  void _showSignTransactionDialog(TransactionToSign transaction, HardwareWalletProvider provider) {
    // TODO: Implement transaction signing dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Подписание транзакции - в разработке')),
    );
  }

  void _showTransactionDetails(TransactionToSign transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getTransactionTypeText(transaction.type)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Тип', _getTransactionTypeText(transaction.type)),
              _buildDetailRow('Создана', 
                  DateFormat('dd.MM.yyyy HH:mm').format(transaction.createdAt)),
              _buildDetailRow('Подписана', transaction.isSigned ? 'Да' : 'Нет'),
              if (transaction.message != null)
                _buildDetailRow('Сообщение', transaction.message!),
              if (transaction.signature != null)
                _buildDetailRow('Подпись', transaction.signature!),
              if (transaction.txHash != null)
                _buildDetailRow('Хеш транзакции', transaction.txHash!),
              const SizedBox(height: 16),
              const Text('Данные транзакции:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...transaction.transactionData.entries.map((entry) => 
                  _buildDetailRow(entry.key, entry.value.toString())),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
