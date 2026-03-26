import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_bloc.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_event.dart';
import 'package:fondos_btg/features/balance/presentation/widgets/balance_header.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_event.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_state.dart';
import 'package:fondos_btg/features/funds/presentation/widgets/fund_card.dart';
import 'package:fondos_btg/features/funds/presentation/widgets/subscribe_bottom_sheet.dart';

class FundsPage extends StatefulWidget {
  const FundsPage({super.key});

  @override
  State<FundsPage> createState() => _FundsPageState();
}

class _FundsPageState extends State<FundsPage> {
  @override
  void initState() {
    super.initState();
    context.read<FundBloc>().add(const LoadFunds());
    context.read<BalanceBloc>().add(const LoadBalance());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          const BalanceHeader(),
          Expanded(
            child: BlocBuilder<FundBloc, FundState>(
              builder: (context, state) {
                if (state.status == FundStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.blueAccent,
                    ),
                  );
                }

                if (state.status == FundStatus.error) {
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
                          state.errorMessage ?? 'Error al cargar los fondos',
                          style: AppTextStyles.fundMinAmount,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<FundBloc>().add(const LoadFunds());
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (state.funds.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay fondos disponibles',
                      style: AppTextStyles.fundMinAmount,
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.blueAccent,
                  onRefresh: () async {
                    context.read<FundBloc>().add(const LoadFunds());
                    context.read<BalanceBloc>().add(const RefreshBalance());
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemCount: state.funds.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const Padding(
                          padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
                          child: Text(
                            'Fondos disponibles',
                            style: AppTextStyles.sectionHeader,
                          ),
                        );
                      }
                      final fund = state.funds[index - 1];
                      return FundCard(
                        fund: fund,
                        onSubscribe: () => _onSubscribe(context, fund),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSubscribe(BuildContext context, fund) async {
    final balanceState = context.read<BalanceBloc>().state;
    final result = await SubscribeBottomSheet.show(
      context,
      fund: fund,
      currentBalance: balanceState.balance,
    );

    if (result == true && mounted) {
      context.read<BalanceBloc>().add(const RefreshBalance());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Suscripcion realizada exitosamente'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
