import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_text_styles.dart';
import 'package:fondos_btg/core/utils/currency_formatter.dart';
import 'package:fondos_btg/core/utils/fund_name_formatter.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_bloc.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_event.dart';
import 'package:fondos_btg/features/funds/domain/entities/fund.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_event.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_state.dart';

class SubscribeBottomSheet extends StatefulWidget {
  final Fund fund;
  final double currentBalance;

  const SubscribeBottomSheet({
    super.key,
    required this.fund,
    required this.currentBalance,
  });

  static Future<bool?> show(
    BuildContext context, {
    required Fund fund,
    required double currentBalance,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<FundBloc>(),
        child: SubscribeBottomSheet(
          fund: fund,
          currentBalance: currentBalance,
        ),
      ),
    );
  }

  @override
  State<SubscribeBottomSheet> createState() => _SubscribeBottomSheetState();
}

class _SubscribeBottomSheetState extends State<SubscribeBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  String _notificationMethod = 'email';
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: _formatNumber(widget.fund.minAmount.toInt().toString()),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _parsedAmount {
    final raw = _amountController.text.replaceAll('.', '');
    return double.tryParse(raw) ?? 0;
  }

  String _formatNumber(String digits) {
    if (digits.isEmpty) return '';
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese un monto';
    }
    final raw = value.replaceAll('.', '');
    if (raw.isEmpty || int.tryParse(raw) == null) {
      return 'Solo se permiten numeros';
    }
    final amount = double.parse(raw);
    if (amount < widget.fund.minAmount) {
      return 'El monto minimo es ${CurrencyFormatter.format(widget.fund.minAmount)}';
    }
    if (amount > widget.currentBalance) {
      return 'Saldo insuficiente. Disponible: ${CurrencyFormatter.format(widget.currentBalance)}';
    }
    return null;
  }

  void _onAmountChanged(String value) {
    final raw = value.replaceAll('.', '');
    if (raw.isEmpty) {
      setState(() => _amountError = null);
      return;
    }

    final formatted = _formatNumber(raw);
    if (formatted != value) {
      _amountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    if (_amountError != null) {
      setState(() {
        _amountError = _validateAmount(formatted);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FundBloc, FundState>(
      listener: (context, state) {
        if (state.subscriptionStatus == SubscriptionStatus.success) {
          context.read<BalanceBloc>().add(const RefreshBalance());
          context.read<FundBloc>().add(const ClearSubscriptionResult());
          Navigator.of(context).pop(true);
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Title
                  Text(
                    'Suscribirse a fondo',
                    style: AppTextStyles.sheetTitle,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          FundNameFormatter.formatWithHyphens(widget.fund.name),
                          style: AppTextStyles.sheetSubtitle,
                        ),
                      ),
                      Text(
                        'Min. ${CurrencyFormatter.format(widget.fund.minAmount)}',
                        style: AppTextStyles.fundMinAmount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // API error banner
                  BlocBuilder<FundBloc, FundState>(
                    buildWhen: (prev, curr) =>
                        prev.subscriptionStatus != curr.subscriptionStatus ||
                        prev.subscriptionError != curr.subscriptionError,
                    builder: (context, state) {
                      if (state.subscriptionStatus !=
                              SubscriptionStatus.error ||
                          state.subscriptionError == null) {
                        return const SizedBox.shrink();
                      }

                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.subscriptionError!,
                                style: AppTextStyles.errorBanner,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Amount field
                  const Text(
                    'Monto de suscripcion',
                    style: AppTextStyles.inputLabel,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
                    ],
                    onChanged: _onAmountChanged,
                    style: AppTextStyles.inputValue,
                    decoration: InputDecoration(
                      prefixText: '\$ ',
                      prefixStyle: AppTextStyles.inputValue,
                      suffixText: 'COP',
                      suffixStyle: AppTextStyles.fundMinAmount,
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.divider),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _amountError != null
                              ? AppColors.error
                              : AppColors.divider,
                          width: _amountError != null ? 2 : 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _amountError != null
                              ? AppColors.error
                              : AppColors.blueAccent,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 2,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  if (_amountError != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _amountError!,
                            style: AppTextStyles.transactionDate.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),

                  // Notification method
                  const Text(
                    'Metodo de notificacion',
                    style: AppTextStyles.inputLabel,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _NotificationRadioCard(
                          label: 'Email',
                          icon: Icons.email_outlined,
                          isSelected: _notificationMethod == 'email',
                          onTap: () =>
                              setState(() => _notificationMethod = 'email'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _NotificationRadioCard(
                          label: 'SMS',
                          icon: Icons.sms_outlined,
                          isSelected: _notificationMethod == 'sms',
                          onTap: () =>
                              setState(() => _notificationMethod = 'sms'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Confirm button
                  BlocBuilder<FundBloc, FundState>(
                    buildWhen: (prev, curr) =>
                        prev.subscriptionStatus != curr.subscriptionStatus,
                    builder: (context, state) {
                      final isLoading =
                          state.subscriptionStatus == SubscriptionStatus.loading;

                      return SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueAccent,
                            foregroundColor: AppColors.white,
                            disabledBackgroundColor: AppColors.disabled,
                            disabledForegroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Confirmar suscripcion',
                                  style: AppTextStyles.buttonPrimary,
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onConfirm() {
    final error = _validateAmount(_amountController.text);
    if (error != null) {
      setState(() => _amountError = error);
      return;
    }
    setState(() => _amountError = null);

    context.read<FundBloc>().add(SubscribeToFund(
          fund: widget.fund,
          amount: _parsedAmount,
          currentBalance: widget.currentBalance,
          notificationMethod: _notificationMethod,
        ));
  }
}

class _NotificationRadioCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NotificationRadioCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.blueAccent.withOpacity(0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.blueAccent : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? AppColors.blueAccent
                  : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.blueAccent
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
