import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_bloc.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_event.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_state.dart';
import 'package:fondos_btg/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:fondos_btg/features/portfolio/presentation/bloc/portfolio_event.dart';
import 'package:fondos_btg/features/portfolio/presentation/bloc/portfolio_state.dart';
import 'package:fondos_btg/features/portfolio/presentation/widgets/portfolio_summary_card.dart';
import 'package:fondos_btg/features/portfolio/presentation/widgets/subscription_card.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  void initState() {
    super.initState();
    context.read<PortfolioBloc>().add(const LoadPortfolio());
    context.read<BalanceBloc>().add(const RefreshBalance());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Mis fondos', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.navy,
        elevation: 0,
      ),
      body: BlocListener<PortfolioBloc, PortfolioState>(
        listener: (context, state) {
          if (state.cancellationStatus == CancellationStatus.success) {
            context.read<BalanceBloc>().add(const RefreshBalance());
            context.read<PortfolioBloc>().add(const ClearCancellationResult());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Suscripcion cancelada exitosamente'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state.cancellationStatus == CancellationStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.cancellationError ??
                      'Error al cancelar la suscripcion',
                ),
                backgroundColor: AppColors.error,
              ),
            );
            context.read<PortfolioBloc>().add(const ClearCancellationResult());
          }
        },
        child: BlocBuilder<PortfolioBloc, PortfolioState>(
          builder: (context, portfolioState) {
            if (portfolioState.status == PortfolioStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.blueAccent,
                ),
              );
            }

            if (portfolioState.status == PortfolioStatus.error) {
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
                      portfolioState.errorMessage ??
                          'Error al cargar el portafolio',
                      style: AppTextStyles.fundMinAmount,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<PortfolioBloc>()
                            .add(const LoadPortfolio());
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              color: AppColors.blueAccent,
              onRefresh: () async {
                context.read<PortfolioBloc>().add(const LoadPortfolio());
                context.read<BalanceBloc>().add(const RefreshBalance());
              },
              child: ListView(
                children: [
                  BlocBuilder<BalanceBloc, BalanceState>(
                    builder: (context, balanceState) {
                      return PortfolioSummaryCard(
                        balance: balanceState.balance,
                        investedAmount: portfolioState.totalInvested,
                      );
                    },
                  ),
                  if (portfolioState.subscriptions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.account_balance_wallet_outlined,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No tienes fondos activos',
                              style: AppTextStyles.fundMinAmount,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Suscribete a un fondo para comenzar',
                              style: AppTextStyles.subscriptionDate,
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: Text(
                        'Fondos activos',
                        style: AppTextStyles.sectionHeader,
                      ),
                    ),
                    ...portfolioState.subscriptions.map(
                      (subscription) => SubscriptionCard(
                        subscription: subscription,
                        isCancelling: portfolioState.cancellationStatus ==
                            CancellationStatus.loading,
                        onCancel: () => _onCancel(context, subscription.id),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onCancel(BuildContext context, int subscriptionId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancelar suscripcion'),
        content: const Text(
          'Esta seguro que desea cancelar esta suscripcion? El monto sera devuelto a su saldo.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<PortfolioBloc>().add(
                    CancelSubscriptionEvent(subscriptionId: subscriptionId),
                  );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Si, cancelar'),
          ),
        ],
      ),
    );
  }
}
