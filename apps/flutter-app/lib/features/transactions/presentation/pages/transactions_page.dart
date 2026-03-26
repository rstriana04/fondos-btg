import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';
import 'package:fondos_btg/features/transactions/domain/entities/transaction.dart';
import 'package:fondos_btg/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:fondos_btg/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:fondos_btg/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:fondos_btg/features/transactions/presentation/widgets/transaction_charts.dart';
import 'package:fondos_btg/features/transactions/presentation/widgets/transaction_filters.dart';
import 'package:fondos_btg/features/transactions/presentation/widgets/transaction_item.dart';
import 'package:fondos_btg/features/transactions/presentation/widgets/transaction_summary_cards.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _searchQuery = '';
  String? _typeFilter;
  String? _categoryFilter;
  String? _notificationFilter;
  bool _showCharts = true;

  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(const LoadTransactions());
  }

  List<FundTransaction> _applyFilters(List<FundTransaction> transactions) {
    return transactions.where((tx) {
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!tx.fundName.toLowerCase().contains(query)) return false;
      }
      if (_typeFilter != null) {
        final typeName =
            tx.isSubscription ? 'subscription' : 'cancellation';
        if (typeName != _typeFilter) return false;
      }
      if (_categoryFilter != null && tx.category != _categoryFilter) {
        return false;
      }
      if (_notificationFilter != null &&
          tx.notification.toLowerCase() !=
              _notificationFilter!.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  bool get _hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _typeFilter != null ||
      _categoryFilter != null ||
      _notificationFilter != null;

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _typeFilter = null;
      _categoryFilter = null;
      _notificationFilter = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Historial', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.navy,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showCharts ? Icons.bar_chart : Icons.bar_chart_outlined,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _showCharts = !_showCharts),
            tooltip: _showCharts ? 'Ocultar graficos' : 'Mostrar graficos',
          ),
        ],
      ),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state.status == TransactionStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.blueAccent,
              ),
            );
          }

          if (state.status == TransactionStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ??
                        'Error al cargar las transacciones',
                    style: AppTextStyles.fundMinAmount,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<TransactionBloc>()
                          .add(const LoadTransactions());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state.transactions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: AppColors.textMuted,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'No hay transacciones',
                    style: AppTextStyles.fundMinAmount,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Las transacciones apareceran aqui',
                    style: AppTextStyles.subscriptionDate,
                  ),
                ],
              ),
            );
          }

          final filtered = _applyFilters(state.transactions);

          return RefreshIndicator(
            color: AppColors.blueAccent,
            onRefresh: () async {
              context
                  .read<TransactionBloc>()
                  .add(const LoadTransactions());
            },
            child: CustomScrollView(
              slivers: [
                // Summary cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 8),
                    child: TransactionSummaryCards(
                      transactions: state.transactions,
                    ),
                  ),
                ),

                // Charts
                if (_showCharts)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TransactionCharts(
                        transactions: state.transactions,
                      ),
                    ),
                  ),

                // Filters
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 8),
                    child: TransactionFilters(
                      searchQuery: _searchQuery,
                      selectedType: _typeFilter,
                      selectedCategory: _categoryFilter,
                      selectedNotification: _notificationFilter,
                      onSearchChanged: (v) =>
                          setState(() => _searchQuery = v),
                      onTypeChanged: (v) =>
                          setState(() => _typeFilter = v),
                      onCategoryChanged: (v) =>
                          setState(() => _categoryFilter = v),
                      onNotificationChanged: (v) =>
                          setState(() => _notificationFilter = v),
                    ),
                  ),
                ),

                // Active filter indicator
                if (_hasActiveFilters)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '${filtered.length} resultado${filtered.length != 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: _clearFilters,
                            child: const Text(
                              'Limpiar filtros',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Section header
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 12, 20, 4),
                    child: Text(
                      'Transacciones recientes',
                      style: AppTextStyles.sectionHeader,
                    ),
                  ),
                ),

                // Transaction list
                if (filtered.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: Text(
                          'No se encontraron transacciones con los filtros seleccionados',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index < filtered.length) {
                          return Column(
                            children: [
                              TransactionItem(
                                  transaction: filtered[index]),
                              if (index < filtered.length - 1)
                                const Divider(
                                  indent: 74,
                                  endIndent: 16,
                                ),
                            ],
                          );
                        }
                        return const SizedBox(height: 16);
                      },
                      childCount: filtered.length + 1,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
