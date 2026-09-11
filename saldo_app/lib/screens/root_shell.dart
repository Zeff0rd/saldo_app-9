import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../theme/app_theme.dart';
import 'add_transaction_screen.dart';
import 'analytics_screen.dart';
import 'dashboard_screen.dart';
import 'settings_screen.dart';
import 'transactions_screen.dart';

/// Каркас с нижней навигацией и центральной кнопкой добавления операции —
/// как в макете (таб-бар с FAB по центру).
class RootShell extends StatefulWidget {
  final AppData data;
  const RootShell({super.key, required this.data});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int index = 0;

  void openAddTransaction() {
    Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => AddTransactionScreen(data: widget.data),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final screens = [
      DashboardScreen(data: widget.data),
      TransactionsScreen(data: widget.data),
      AnalyticsScreen(data: widget.data),
      SettingsScreen(data: widget.data),
    ];

    return AnimatedBuilder(
      animation: widget.data,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: c.bg,
          extendBody: true,
          body: SafeArea(bottom: false, child: IndexedStack(index: index, children: screens)),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: openAddTransaction,
            backgroundColor: c.accent,
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
          bottomNavigationBar: BottomAppBar(
            color: c.card,
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            height: 68,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Обзор', selected: index == 0, onTap: () => setState(() => index = 0)),
                _NavItem(icon: Icons.receipt_long_outlined, activeIcon: Icons.receipt_long, label: 'Операции', selected: index == 1, onTap: () => setState(() => index = 1)),
                const SizedBox(width: 48),
                _NavItem(icon: Icons.pie_chart_outline, activeIcon: Icons.pie_chart, label: 'Аналитика', selected: index == 2, onTap: () => setState(() => index = 2)),
                _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings, label: 'Настройки', selected: index == 3, onTap: () => setState(() => index = 3)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = selected ? c.accent : c.text3;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? activeIcon : icon, color: color, size: 23),
            const SizedBox(height: 3),
            Text(label, style: TextStyle(color: color, fontSize: 10.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
