import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:rechain_vc_lab/utils/theme.dart';
import 'package:rechain_vc_lab/core/logger.dart';

/// DEX Trading — децентрализованная биржа, свап токенов, ликвидность
class DEXTradingScreen extends StatefulWidget {
  const DEXTradingScreen({super.key});

  @override
  State<DEXTradingScreen> createState() => _DEXTradingScreenState();
}

class _DEXTradingScreenState extends State<DEXTradingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _fromToken = 'ETH';
  String _toToken = 'USDC';
  double _slippage = 0.5;
  bool _isLoading = false;

  final Map<String, double> _tokenBalances = {
    'ETH': 2.5,
    'USDC': 5420.50,
    'WBTC': 0.15,
    'UNI': 250.0,
    'LINK': 180.0,
  };

  final Map<String, double> _tokenPrices = {
    'ETH': 1850.00,
    'USDC': 1.00,
    'WBTC': 29500.00,
    'UNI': 6.50,
    'LINK': 7.20,
  };

  final List<Map<String, dynamic>> _liquidityPools = [
    {
      'id': '1',
      'pair': 'ETH/USDC',
      'tvl': 285000000,
      'apr': 12.5,
      'volume24h': 45000000,
      'fee': 0.3,
      'token0': 'ETH',
      'token1': 'USDC',
      'color': Colors.blue,
    },
    {
      'id': '2',
      'pair': 'WBTC/ETH',
      'tvl': 420000000,
      'apr': 8.3,
      'volume24h': 62000000,
      'fee': 0.3,
      'token0': 'WBTC',
      'token1': 'ETH',
      'color': Colors.orange,
    },
    {
      'id': '3',
      'pair': 'UNI/ETH',
      'tvl': 95000000,
      'apr': 18.7,
      'volume24h': 18000000,
      'fee': 0.3,
      'token0': 'UNI',
      'token1': 'ETH',
      'color': Colors.pink,
    },
    {
      'id': '4',
      'pair': 'LINK/ETH',
      'tvl': 68000000,
      'apr': 15.2,
      'volume24h': 12000000,
      'fee': 0.3,
      'token0': 'LINK',
      'token1': 'ETH',
      'color': Colors.blue.shade700,
    },
  ];

  final List<Map<String, dynamic>> _recentTrades = [
    {'id': '1', 'type': 'buy', 'pair': 'ETH/USDC', 'amount': '2.5 ETH', 'price': '\$1,850', 'time': '2м назад'},
    {'id': '2', 'type': 'sell', 'pair': 'WBTC/ETH', 'amount': '0.15 WBTC', 'price': '\$29,500', 'time': '5м назад'},
    {'id': '3', 'type': 'buy', 'pair': 'UNI/ETH', 'amount': '100 UNI', 'price': '\$6.50', 'time': '8м назад'},
    {'id': '4', 'type': 'sell', 'pair': 'LINK/ETH', 'amount': '50 LINK', 'price': '\$7.20', 'time': '12м назад'},
    {'id': '5', 'type': 'buy', 'pair': 'ETH/USDC', 'amount': '5.0 ETH', 'price': '\$1,848', 'time': '15м назад'},
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
        title: const Text('DEX Trading'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettings,
            tooltip: 'Настройки',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Обновить',
          ),
        ],
      ),
      body: Column(
        children: [
          // Portfolio Summary
          _buildPortfolioSummary(),

          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[700],
              indicator: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: const [
                Tab(text: 'Свап'),
                Tab(text: 'Ликвидность'),
                Tab(text: 'История'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSwapTab(),
                _buildLiquidityTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Portfolio Summary
  Widget _buildPortfolioSummary() {
    final totalBalance = _tokenBalances.entries.fold<double>(
      0,
      (sum, entry) => sum + (entry.value * (_tokenPrices[entry.key] ?? 0)),
    );

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.accentColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Общий баланс',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${totalBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPortfolioToken('ETH', _tokenBalances['ETH'] ?? 0),
              _buildPortfolioToken('USDC', _tokenBalances['USDC'] ?? 0),
              _buildPortfolioToken('WBTC', _tokenBalances['WBTC'] ?? 0),
              _buildPortfolioToken('UNI', _tokenBalances['UNI'] ?? 0),
            ],
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 500.ms)
      .scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildPortfolioToken(String symbol, double balance) {
    final price = _tokenPrices[symbol] ?? 0;
    final value = balance * price;
    
    return Column(
      children: [
        Text(
          symbol,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          balance.toStringAsFixed(symbol == 'ETH' || symbol == 'WBTC' ? 4 : 2),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(0)}',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // Swap Tab
  Widget _buildSwapTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSwapCard(),
          const SizedBox(height: 16),
          _buildPriceChart(),
          const SizedBox(height: 16),
          _buildRecentTradesMini(),
        ],
      ),
    );
  }

  Widget _buildSwapCard() {
    final fromPrice = _tokenPrices[_fromToken] ?? 0;
    final toPrice = _tokenPrices[_toToken] ?? 0;
    final rate = fromPrice / toPrice;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // From Token
            _buildTokenInput(
              label: 'Отдаёте',
              token: _fromToken,
              balance: _tokenBalances[_fromToken] ?? 0,
              onTokenSelect: (token) => setState(() => _fromToken = token),
              onAmountChange: (amount) {},
            ),

            // Swap Button
            Center(
              child: GestureDetector(
                onTap: _swapTokens,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: const Icon(
                    Icons.swap_vert,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),

            // To Token
            _buildTokenInput(
              label: 'Получаете',
              token: _toToken,
              balance: _tokenBalances[_toToken] ?? 0,
              onTokenSelect: (token) => setState(() => _toToken = token),
              onAmountChange: (amount) {},
              isOutput: true,
            ),

            const SizedBox(height: 16),

            // Rate Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Курс: 1 $_fromToken = ${rate.toStringAsFixed(4)} $_toToken',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Slippage: $_slippage%',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Swap Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _executeSwap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Свапнуть',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTokenInput({
    required String label,
    required String token,
    required double balance,
    required Function(String) onTokenSelect,
    required Function(double) onAmountChange,
    bool isOutput = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'Баланс: ${balance.toStringAsFixed(4)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (!isOutput)
                Expanded(
                  child: TextField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) => onAmountChange(double.tryParse(value) ?? 0),
                  ),
                ),
              if (isOutput)
                Expanded(
                  child: Text(
                    '0.00',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        token[0],
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      token,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.expand_more, size: 16, color: Colors.grey[600]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Price Chart (simplified)
  Widget _buildPriceChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'График цены',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    _buildTimeframeButton('1H'),
                    _buildTimeframeButton('1D', isSelected: true),
                    _buildTimeframeButton('1W'),
                    _buildTimeframeButton('1M'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Simplified chart visualization
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor.withOpacity(0.2),
                    AppTheme.primaryColor.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: ChartPainter(),
                child: Center(
                  child: Text(
                    '\$${_tokenPrices[_toToken]}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeButton(String label, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppTheme.primaryColor : Colors.grey[200],
          foregroundColor: isSelected ? Colors.white : Colors.grey[700],
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(0, 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 11)),
      ),
    );
  }

  // Recent Trades Mini
  Widget _buildRecentTradesMini() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Последние сделки',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentTrades.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final trade = _recentTrades[index];
                return _buildTradeRow(trade);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeRow(Map<String, dynamic> trade) {
    final isBuy = trade['type'] == 'buy';
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isBuy ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isBuy ? Icons.arrow_downward : Icons.arrow_upward,
              size: 16,
              color: isBuy ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${isBuy ? 'Покупка' : 'Продажа'} ${trade['pair']}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  trade['time'] as String,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trade['amount'] as String,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(
                trade['price'] as String,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Liquidity Tab
  Widget _buildLiquidityTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _liquidityPools.length,
      itemBuilder: (context, index) {
        return _buildLiquidityPoolCard(_liquidityPools[index], index);
      },
    );
  }

  Widget _buildLiquidityPoolCard(Map<String, dynamic> pool, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: (pool['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      pool['pair'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: pool['color'],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pool['pair'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'APR: ${(pool['apr'] as double).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TVL: \$${_formatTVL(pool['tvl'] as int)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      'Fee: ${(pool['fee'] as double).toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _addLiquidity(pool),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('Добавить'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _removeLiquidity(pool),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text('Убрать'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 50))
      .slideX(begin: 0.2, end: 0);
  }

  // History Tab
  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _recentTrades.length * 3,
      itemBuilder: (context, index) {
        final trade = _recentTrades[index % _recentTrades.length];
        return _buildHistoryItem(trade, index);
      },
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> trade, int index) {
    final isBuy = trade['type'] == 'buy';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isBuy ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isBuy ? Icons.arrow_downward : Icons.arrow_upward,
            color: isBuy ? Colors.green : Colors.red,
          ),
        ),
        title: Text('${isBuy ? 'Покупка' : 'Продажа'} ${trade['pair']}'),
        subtitle: Text(trade['time'] as String),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              trade['amount'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              trade['price'] as String,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(delay: Duration(milliseconds: index * 30));
  }

  // Actions
  void _swapTokens() {
    setState(() {
      final temp = _fromToken;
      _fromToken = _toToken;
      _toToken = temp;
    });
  }

  void _executeSwap() {
    AppLogger.info('Execute swap: $_fromToken -> $_toToken');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Свап выполнен успешно'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Настройки свапа'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Slippage Tolerance'),
            const SizedBox(height: 8),
            StatefulBuilder(
              builder: (context, setDialogState) => Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _slippage,
                      min: 0.1,
                      max: 5.0,
                      divisions: 49,
                      label: '$_slippage%',
                      onChanged: (value) {
                        setDialogState(() => _slippage = value);
                      },
                    ),
                  ),
                  Text('$_slippage%'),
                ],
              ),
            ),
          ],
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

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() => _isLoading = false);
  }

  void _addLiquidity(Map<String, dynamic> pool) {
    AppLogger.info('Add liquidity: ${pool['pair']}');
  }

  void _removeLiquidity(Map<String, dynamic> pool) {
    AppLogger.info('Remove liquidity: ${pool['pair']}');
  }

  String _formatTVL(int tvl) {
    if (tvl >= 1e9) return '${(tvl / 1e9).toStringAsFixed(1)}B';
    if (tvl >= 1e6) return '${(tvl / 1e6).toStringAsFixed(1)}M';
    return '${(tvl / 1e3).toStringAsFixed(1)}K';
  }
}

// Simple chart painter
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.primaryColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.1, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.65),
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.55),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.7, size.height * 0.35),
      Offset(size.width * 0.8, size.height * 0.3),
      Offset(size.width * 0.9, size.height * 0.25),
      Offset(size.width, size.height * 0.2),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
