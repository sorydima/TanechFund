import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rechain_vc_lab/providers/blockchain_defi_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:intl/intl.dart';

class BlockchainDeFiScreen extends StatefulWidget {
  const BlockchainDeFiScreen({super.key});

  @override
  State<BlockchainDeFiScreen> createState() => _BlockchainDeFiScreenState();
}

class _BlockchainDeFiScreenState extends State<BlockchainDeFiScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BlockchainDeFiProvider>().initialize();
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
      backgroundColor: AppTheme.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  'Блокчейн и DeFi',
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
                      hintText: 'Поиск по блокчейн и DeFi...',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.white30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
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
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                isScrollable: true,
                tabs: const [
                  Tab(text: 'Кошельки', icon: Icon(Icons.account_balance_wallet)),
                  Tab(text: 'DeFi Протоколы', icon: Icon(Icons.account_balance)),
                  Tab(text: 'Smart Контракты', icon: Icon(Icons.code)),
                  Tab(text: 'Токены', icon: Icon(Icons.monetization_on)),
                  Tab(text: 'Транзакции', icon: Icon(Icons.swap_horiz)),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildWalletsTab(),
                  _buildProtocolsTab(),
                  _buildContractsTab(),
                  _buildTokensTab(),
                  _buildTransactionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateWalletDialog();
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildWalletsTab() {
    return Consumer<BlockchainDeFiProvider>(
      builder: (context, provider, child) {
        final wallets = provider.searchWallets(_searchController.text);
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: wallets.length,
          itemBuilder: (context, index) {
            final wallet = wallets[index];
            return _buildWalletCard(wallet, provider);
          },
        );
      },
    );
  }

  Widget _buildWalletCard(BlockchainWallet wallet, BlockchainDeFiProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getBlockchainColor(wallet.blockchain).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Icon(
                      _getBlockchainIcon(wallet.blockchain),
                      color: _getBlockchainColor(wallet.blockchain),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wallet.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: wallet.isActive ? Colors.green : Colors.grey,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              wallet.isActive ? 'Активен' : 'Неактивен',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            wallet.blockchain.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getBlockchainColor(wallet.blockchain),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Адрес: ${wallet.address}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Баланс: ${wallet.balance.toStringAsFixed(4)} ${wallet.blockchain == 'ethereum' ? 'ETH' : wallet.blockchain.toUpperCase()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Поддерживаемые токены:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: wallet.supportedTokens.map((token) {
                return Chip(
                  label: Text(
                    token,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  labelStyle: TextStyle(color: AppTheme.primaryColor),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Создан: ${DateFormat('dd.MM.yyyy').format(wallet.createdAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _showWalletDetails(wallet);
                      },
                      icon: const Icon(Icons.info_outline),
                      color: AppTheme.primaryColor,
                    ),
                    IconButton(
                      onPressed: () {
                        _showDeleteWalletDialog(wallet, provider);
                      },
                      icon: const Icon(Icons.delete_outline),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolsTab() {
    return Consumer<BlockchainDeFiProvider>(
      builder: (context, provider, child) {
        final protocols = provider.searchProtocols(_searchController.text);
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: protocols.length,
          itemBuilder: (context, index) {
            final protocol = protocols[index];
            return _buildProtocolCard(protocol);
          },
        );
      },
    );
  }

  Widget _buildProtocolCard(DeFiProtocol protocol) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getProtocolTypeColor(protocol.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Icon(
                      _getProtocolTypeIcon(protocol.type),
                      color: _getProtocolTypeColor(protocol.type),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        protocol.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getProtocolTypeColor(protocol.type),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getProtocolTypeText(protocol.type),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            protocol.blockchain.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getBlockchainColor(protocol.blockchain),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              protocol.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TVL',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\$${(protocol.tvl / 1000000).toStringAsFixed(1)}M',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'APY',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${protocol.apy.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Поддерживаемые токены:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: protocol.supportedTokens.map((token) {
                return Chip(
                  label: Text(
                    token,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  labelStyle: const TextStyle(color: Colors.blue),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractsTab() {
    return Consumer<BlockchainDeFiProvider>(
      builder: (context, provider, child) {
        final contracts = provider.searchContracts(_searchController.text);
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: contracts.length,
          itemBuilder: (context, index) {
            final contract = contracts[index];
            return _buildContractCard(contract);
          },
        );
      },
    );
  }

  Widget _buildContractCard(SmartContract contract) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getContractTypeColor(contract.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Icon(
                      _getContractTypeIcon(contract.type),
                      color: _getContractTypeColor(contract.type),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contract.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getContractStatusColor(contract.status),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getContractStatusText(contract.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            contract.blockchain.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getBlockchainColor(contract.blockchain),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              contract.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Адрес: ${contract.address}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Развернут: ${DateFormat('dd.MM.yyyy').format(contract.deployedAt)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokensTab() {
    return Consumer<BlockchainDeFiProvider>(
      builder: (context, provider, child) {
        final tokens = provider.searchTokens(_searchController.text);
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: tokens.length,
          itemBuilder: (context, index) {
            final token = tokens[index];
            return _buildTokenCard(token);
          },
        );
      },
    );
  }

  Widget _buildTokenCard(Token token) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getTokenTypeColor(token.tokenType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Icon(
                      _getTokenTypeIcon(token.tokenType),
                      color: _getTokenTypeColor(token.tokenType),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        token.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            token.symbol,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getTokenTypeColor(token.tokenType),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getTokenTypeText(token.tokenType),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Цена',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\$${token.price.toStringAsFixed(4)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Рыночная капитализация',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '\$${(token.marketCap / 1000000).toStringAsFixed(1)}M',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Объем 24ч: \$${(token.volume24h / 1000000).toStringAsFixed(1)}M',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return Consumer<BlockchainDeFiProvider>(
      builder: (context, provider, child) {
        final transactions = provider.transactions;
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return _buildTransactionCard(transaction);
          },
        );
      },
    );
  }

  Widget _buildTransactionCard(BlockchainTransaction transaction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getTransactionStatusColor(transaction.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Center(
                    child: Icon(
                      _getTransactionStatusIcon(transaction.status),
                      color: _getTransactionStatusColor(transaction.status),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${transaction.amount.toStringAsFixed(4)} ${transaction.tokenSymbol}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getTransactionStatusColor(transaction.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getTransactionStatusText(transaction.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'От: ${transaction.fromAddress}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'К: ${transaction.toAddress}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Комиссия',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '${(transaction.gasPrice * transaction.gasUsed / 1000000000).toStringAsFixed(6)} ETH',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Время',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        DateFormat('HH:mm').format(transaction.timestamp),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Color _getBlockchainColor(String blockchain) {
    switch (blockchain.toLowerCase()) {
      case 'ethereum':
        return Colors.purple;
      case 'polygon':
        return Colors.purple;
      case 'bsc':
        return Colors.orange;
      case 'solana':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  IconData _getBlockchainIcon(String blockchain) {
    switch (blockchain.toLowerCase()) {
      case 'ethereum':
        return Icons.currency_bitcoin;
      case 'polygon':
        return Icons.hexagon;
      case 'bsc':
        return Icons.currency_bitcoin;
      case 'solana':
        return Icons.currency_bitcoin;
      default:
        return Icons.currency_bitcoin;
    }
  }

  Color _getProtocolTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'dex':
        return Colors.blue;
      case 'lending':
        return Colors.green;
      case 'yield_farming':
        return Colors.orange;
      case 'staking':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getProtocolTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'dex':
        return Icons.swap_horiz;
      case 'lending':
        return Icons.account_balance;
      case 'yield_farming':
        return Icons.trending_up;
      case 'staking':
        return Icons.lock;
      default:
        return Icons.account_balance;
    }
  }

  String _getProtocolTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'dex':
        return 'DEX';
      case 'lending':
        return 'Лендинг';
      case 'yield_farming':
        return 'Yield Farming';
      case 'staking':
        return 'Стейкинг';
      default:
        return type;
    }
  }

  Color _getContractTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'token':
        return Colors.green;
      case 'nft':
        return Colors.purple;
      case 'defi':
        return Colors.blue;
      case 'governance':
        return Colors.orange;
      case 'custom':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getContractTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'token':
        return Icons.monetization_on;
      case 'nft':
        return Icons.image;
      case 'defi':
        return Icons.account_balance;
      case 'governance':
        return Icons.how_to_vote;
      case 'custom':
        return Icons.code;
      default:
        return Icons.code;
    }
  }

  Color _getContractStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'deployed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      case 'upgraded':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getContractStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'deployed':
        return 'Развернут';
      case 'pending':
        return 'В процессе';
      case 'failed':
        return 'Ошибка';
      case 'upgraded':
        return 'Обновлен';
      default:
        return status;
    }
  }

  Color _getTokenTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'erc20':
        return Colors.blue;
      case 'erc721':
        return Colors.purple;
      case 'erc1155':
        return Colors.pink;
      case 'native':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTokenTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'erc20':
        return Icons.monetization_on;
      case 'erc721':
        return Icons.image;
      case 'erc1155':
        return Icons.collections;
      case 'native':
        return Icons.currency_bitcoin;
      default:
        return Icons.monetization_on;
    }
  }

  String _getTokenTypeText(String type) {
    switch (type.toLowerCase()) {
      case 'erc20':
        return 'ERC-20';
      case 'erc721':
        return 'ERC-721';
      case 'erc1155':
        return 'ERC-1155';
      case 'native':
        return 'Нативный';
      default:
        return type;
    }
  }

  Color _getTransactionStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransactionStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.schedule;
      case 'failed':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  String _getTransactionStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Подтверждена';
      case 'pending':
        return 'В обработке';
      case 'failed':
        return 'Ошибка';
      default:
        return status;
    }
  }

  // Dialog methods
  void _showCreateWalletDialog() {
    final nameController = TextEditingController();
    String selectedBlockchain = 'ethereum';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Создать кошелек'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Название кошелька',
                hintText: 'Введите название...',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedBlockchain,
              decoration: const InputDecoration(
                labelText: 'Блокчейн',
              ),
              items: const [
                DropdownMenuItem(
                  value: 'ethereum',
                  child: Text('Ethereum'),
                ),
                DropdownMenuItem(
                  value: 'polygon',
                  child: Text('Polygon'),
                ),
                DropdownMenuItem(
                  value: 'bsc',
                  child: Text('BSC'),
                ),
                DropdownMenuItem(
                  value: 'solana',
                  child: Text('Solana'),
                ),
              ],
              onChanged: (value) {
                selectedBlockchain = value!;
              },
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
              if (nameController.text.isNotEmpty) {
                context.read<BlockchainDeFiProvider>().createWallet(
                  nameController.text,
                  selectedBlockchain,
                );
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Создать'),
          ),
        ],
      ),
    );
  }

  void _showWalletDetails(BlockchainWallet wallet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Детали кошелька: ${wallet.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Адрес: ${wallet.address}'),
            Text('Блокчейн: ${wallet.blockchain}'),
            Text('Баланс: ${wallet.balance}'),
            Text('Создан: ${DateFormat('dd.MM.yyyy HH:mm').format(wallet.createdAt)}'),
            Text('Тип: ${wallet.metadata['wallet_type']}'),
            if (wallet.metadata['derivation_path'] != 'imported')
              Text('Путь: ${wallet.metadata['derivation_path']}'),
          ],
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

  void _showDeleteWalletDialog(BlockchainWallet wallet, BlockchainDeFiProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить кошелек'),
        content: Text('Вы уверены, что хотите удалить кошелек "${wallet.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.deleteWallet(wallet.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
