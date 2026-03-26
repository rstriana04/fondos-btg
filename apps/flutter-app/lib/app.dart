import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fondos_btg/core/di/injection.dart';
import 'package:fondos_btg/core/theme/app_colors.dart';
import 'package:fondos_btg/core/theme/app_theme.dart';
import 'package:fondos_btg/features/balance/presentation/bloc/balance_bloc.dart';
import 'package:fondos_btg/features/funds/presentation/bloc/fund_bloc.dart';
import 'package:fondos_btg/features/funds/presentation/pages/funds_page.dart';
import 'package:fondos_btg/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:fondos_btg/features/portfolio/presentation/pages/portfolio_page.dart';
import 'package:fondos_btg/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:fondos_btg/features/transactions/presentation/pages/transactions_page.dart';

class FondosBtgApp extends StatelessWidget {
  const FondosBtgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BalanceBloc>(create: (_) => sl<BalanceBloc>()),
        BlocProvider<FundBloc>(create: (_) => sl<FundBloc>()),
        BlocProvider<PortfolioBloc>(create: (_) => sl<PortfolioBloc>()),
        BlocProvider<TransactionBloc>(create: (_) => sl<TransactionBloc>()),
      ],
      child: MaterialApp.router(
        title: 'FondosBTG',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => _ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FundsPage(),
          ),
        ),
        GoRoute(
          path: '/portfolio',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PortfolioPage(),
          ),
        ),
        GoRoute(
          path: '/transactions',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TransactionsPage(),
          ),
        ),
      ],
    ),
  ],
);

class _ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const _ScaffoldWithNavBar({required this.child});

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/portfolio')) return 1;
    if (location.startsWith('/transactions')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            switch (index) {
              case 0:
                context.go('/');
                break;
              case 1:
                context.go('/portfolio');
                break;
              case 2:
                context.go('/transactions');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              activeIcon: Icon(Icons.account_balance),
              label: 'Fondos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline),
              activeIcon: Icon(Icons.pie_chart),
              label: 'Mis fondos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Historial',
            ),
          ],
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.blueAccent,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedFontSize: 12,
          unselectedFontSize: 12,
        ),
      ),
    );
  }
}
