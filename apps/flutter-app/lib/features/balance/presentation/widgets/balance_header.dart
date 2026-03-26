import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';
import 'package:fondos_btg/core/utils/currency_formatter.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_bloc.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_state.dart';

class BalanceHeader extends StatelessWidget {
  const BalanceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.navy, AppColors.blueDark],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FondosBTG',
                style: AppTextStyles.appBarTitle,
              ),
              const SizedBox(height: 20),
              const Text(
                'Tu saldo disponible',
                style: AppTextStyles.balanceLabel,
              ),
              const SizedBox(height: 4),
              BlocBuilder<BalanceBloc, BalanceState>(
                builder: (context, state) {
                  if (state.status == BalanceStatus.loading) {
                    return const SizedBox(
                      height: 34,
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return Text(
                    CurrencyFormatter.format(state.balance),
                    style: AppTextStyles.balanceAmount,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
