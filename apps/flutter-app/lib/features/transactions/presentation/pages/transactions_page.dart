import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';
import 'package:fondos_btg/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:fondos_btg/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:fondos_btg/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:fondos_btg/features/transactions/presentation/widgets/transaction_item.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(const LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title:
            const Text('Historial', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.navy,
        elevation: 0,
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

          return RefreshIndicator(
            color: AppColors.blueAccent,
            onRefresh: () async {
              context
                  .read<TransactionBloc>()
                  .add(const LoadTransactions());
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: state.transactions.length + 1,
              separatorBuilder: (_, index) {
                if (index == 0) return const SizedBox.shrink();
                return const Divider(
                  indent: 74,
                  endIndent: 16,
                );
              },
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Padding(
                    padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Text(
                      'Transacciones recientes',
                      style: AppTextStyles.sectionHeader,
                    ),
                  );
                }
                return TransactionItem(
                  transaction: state.transactions[index - 1],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
