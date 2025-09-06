import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rechain_vc_lab/providers/governance_dao_provider.dart';
import 'package:rechain_vc_lab/utils/theme.dart';

class GovernanceDAOScreen extends StatefulWidget {
  const GovernanceDAOScreen({super.key});

  @override
  State<GovernanceDAOScreen> createState() => _GovernanceDAOScreenState();
}

class _GovernanceDAOScreenState extends State<GovernanceDAOScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GovernanceDAOProvider>().initialize();
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
                  'Governance & DAO',
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
                      Icons.account_balance,
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
                      hintText: 'Поиск предложений...',
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
            // Overview Cards
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Consumer<GovernanceDAOProvider>(
                builder: (context, provider, child) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Активные предложения',
                              '${provider.activeProposals.length}',
                              Icons.how_to_vote,
                              Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Всего голосов',
                              '${provider.votes.length}',
                              Icons.poll,
                              Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildOverviewCard(
                              'Делегирования',
                              '${provider.delegations.where((d) => d.isActive).length}',
                              Icons.people,
                              Colors.orange,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildOverviewCard(
                              'Моя сила голоса',
                              '${_formatNumber(provider.getUserVotingPower(provider.currentUserId))}',
                              Icons.power,
                              Colors.purple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppTheme.primaryColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppTheme.primaryColor,
                tabs: const [
                  Tab(text: 'Предложения'),
                  Tab(text: 'Голосование'),
                  Tab(text: 'Делегирование'),
                  Tab(text: 'Токеномика'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildProposalsTab(),
                  _buildVotingTab(),
                  _buildDelegationTab(),
                  _buildTokenomicsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProposalDialog(),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildOverviewCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProposalsTab() {
    return Consumer<GovernanceDAOProvider>(
      builder: (context, provider, child) {
        final proposals = _searchQuery.isEmpty
            ? provider.proposals
            : provider.searchProposals(_searchQuery);

        if (proposals.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.description, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет доступных предложений',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: proposals.length,
          itemBuilder: (context, index) {
            final proposal = proposals[index];
            return _buildProposalCard(proposal, provider);
          },
        );
      },
    );
  }

  Widget _buildVotingTab() {
    return Consumer<GovernanceDAOProvider>(
      builder: (context, provider, child) {
        final activeProposals = provider.activeProposals;

        if (activeProposals.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.how_to_vote, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Нет активных предложений для голосования',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activeProposals.length,
          itemBuilder: (context, index) {
            final proposal = activeProposals[index];
            return _buildVotingCard(proposal, provider);
          },
        );
      },
    );
  }

  Widget _buildDelegationTab() {
    return Consumer<GovernanceDAOProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // My Delegations
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people_outline, color: Colors.blue),
                          const SizedBox(width: 8),
                          const Text(
                            'Мои делегирования',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () => _showDelegateDialog(provider),
                            icon: const Icon(Icons.add, size: 16),
                            label: const Text('Делегировать'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (provider.userDelegations.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              'У вас нет активных делегирований',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ...provider.userDelegations.map((delegation) {
                          return _buildDelegationCard(delegation, provider);
                        }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Received Delegations
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.people, color: Colors.green),
                          const SizedBox(width: 8),
                          const Text(
                            'Полученные делегирования',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (provider.receivedDelegations.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text(
                              'Вам не делегировали голоса',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ...provider.receivedDelegations.map((delegation) {
                          return _buildReceivedDelegationCard(delegation);
                        }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTokenomicsTab() {
    return Consumer<GovernanceDAOProvider>(
      builder: (context, provider, child) {
        final tokenomics = provider.tokenomics;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Token Overview
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.token, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text(
                            '${tokenomics.tokenName} (${tokenomics.tokenSymbol})',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTokenomicsCard(
                              'Общее предложение',
                              _formatNumber(tokenomics.totalSupply),
                              Icons.account_balance_wallet,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTokenomicsCard(
                              'В обращении',
                              _formatNumber(tokenomics.circulatingSupply),
                              Icons.currency_exchange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTokenomicsCard(
                              'Застейкано',
                              _formatNumber(tokenomics.stakedSupply),
                              Icons.lock,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTokenomicsCard(
                              'Делегировано',
                              _formatNumber(tokenomics.delegatedSupply),
                              Icons.people,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Distribution Chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Распределение токенов',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...tokenomics.distribution.entries.map((entry) {
                        final percentage = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                '${percentage.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Rates
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Текущие ставки',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTokenomicsCard(
                              'Инфляция',
                              '${tokenomics.inflationRate.toStringAsFixed(1)}%',
                              Icons.trending_up,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildTokenomicsCard(
                              'Награды за стейкинг',
                              '${tokenomics.stakingRewardRate.toStringAsFixed(1)}%',
                              Icons.monetization_on,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProposalCard(GovernanceProposal proposal, GovernanceDAOProvider provider) {
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
                Expanded(
                  child: Text(
                    proposal.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getProposalTypeColor(proposal.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getProposalTypeName(proposal.type),
                    style: TextStyle(
                      color: _getProposalTypeColor(proposal.type),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              proposal.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
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
                        'Статус',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(proposal.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusName(proposal.status),
                          style: TextStyle(
                            color: _getStatusColor(proposal.status),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
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
                        'Кворум',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${proposal.currentQuorum.toStringAsFixed(1)}% / ${proposal.quorumRequired.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
                        'Голоса',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${proposal.totalVotes}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
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
                  child: ElevatedButton.icon(
                    onPressed: () => _showProposalDetails(proposal),
                    icon: const Icon(Icons.info, size: 16),
                    label: const Text('Детали'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (proposal.status == ProposalStatus.active)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showVoteDialog(proposal, provider),
                      icon: const Icon(Icons.how_to_vote, size: 16),
                      label: const Text('Голосовать'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
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

  Widget _buildVotingCard(GovernanceProposal proposal, GovernanceDAOProvider provider) {
    final hasVoted = provider.votes.any((v) => 
        v.proposalId == proposal.id && v.voterAddress == provider.currentUserId);
    
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
                Expanded(
                  child: Text(
                    proposal.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (hasVoted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'ГОЛОСОВАЛ',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              proposal.description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
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
                        'Время голосования',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'До ${DateFormat('dd.MM.yyyy').format(proposal.votingEnd)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
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
                        'Прогресс кворума',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      LinearProgressIndicator(
                        value: proposal.currentQuorum / proposal.quorumRequired,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          proposal.currentQuorum >= proposal.quorumRequired 
                              ? Colors.green 
                              : Colors.orange,
                        ),
                      ),
                      Text(
                        '${proposal.currentQuorum.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (!hasVoted)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showVoteDialog(proposal, provider),
                  icon: const Icon(Icons.how_to_vote, size: 16),
                  label: const Text('Проголосовать'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDelegationCard(Delegation delegation, GovernanceDAOProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.people, color: Colors.white),
        ),
        title: Text(
          'Делегировано: ${_formatNumber(delegation.amount)} REW',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Кому: ${delegation.delegateAddress.substring(0, 8)}...',
        ),
        trailing: IconButton(
          onPressed: () => _revokeDelegation(delegation.id, provider),
          icon: const Icon(Icons.cancel, color: Colors.red),
          tooltip: 'Отозвать',
        ),
      ),
    );
  }

  Widget _buildReceivedDelegationCard(Delegation delegation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.people, color: Colors.white),
        ),
        title: Text(
          'Получено: ${_formatNumber(delegation.amount)} REW',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'От: ${delegation.delegatorAddress.substring(0, 8)}...',
        ),
      ),
    );
  }

  Widget _buildTokenomicsCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  String _formatNumber(double number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toStringAsFixed(0);
  }

  String _getProposalTypeName(ProposalType type) {
    switch (type) {
      case ProposalType.general:
        return 'Общее';
      case ProposalType.treasury:
        return 'Казна';
      case ProposalType.protocol:
        return 'Протокол';
      case ProposalType.governance:
        return 'Управление';
      case ProposalType.emergency:
        return 'Экстренное';
    }
  }

  Color _getProposalTypeColor(ProposalType type) {
    switch (type) {
      case ProposalType.general:
        return Colors.blue;
      case ProposalType.treasury:
        return Colors.green;
      case ProposalType.protocol:
        return Colors.orange;
      case ProposalType.governance:
        return Colors.purple;
      case ProposalType.emergency:
        return Colors.red;
    }
  }

  String _getStatusName(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.draft:
        return 'Черновик';
      case ProposalStatus.active:
        return 'Активно';
      case ProposalStatus.passed:
        return 'Принято';
      case ProposalStatus.rejected:
        return 'Отклонено';
      case ProposalStatus.executed:
        return 'Выполнено';
      case ProposalStatus.expired:
        return 'Истекло';
    }
  }

  Color _getStatusColor(ProposalStatus status) {
    switch (status) {
      case ProposalStatus.draft:
        return Colors.grey;
      case ProposalStatus.active:
        return Colors.blue;
      case ProposalStatus.passed:
        return Colors.green;
      case ProposalStatus.rejected:
        return Colors.red;
      case ProposalStatus.executed:
        return Colors.purple;
      case ProposalStatus.expired:
        return Colors.orange;
    }
  }

  // Action Methods
  void _showCreateProposalDialog() {
    // TODO: Implement create proposal dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Создание предложения - в разработке')),
    );
  }

  void _showProposalDetails(GovernanceProposal proposal) {
    // TODO: Implement proposal details dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Детали предложения - в разработке')),
    );
  }

  void _showVoteDialog(GovernanceProposal proposal, GovernanceDAOProvider provider) {
    // TODO: Implement vote dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Диалог голосования - в разработке')),
    );
  }

  void _showDelegateDialog(GovernanceDAOProvider provider) {
    // TODO: Implement delegate dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Диалог делегирования - в разработке')),
    );
  }

  Future<void> _revokeDelegation(String delegationId, GovernanceDAOProvider provider) async {
    await provider.revokeDelegation(delegationId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Делегирование отозвано')),
    );
  }
}
