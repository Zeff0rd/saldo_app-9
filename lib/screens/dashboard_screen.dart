import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/category.dart' show TxType;
import '../models/transaction.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/category_icons.dart';
import '../widgets/section_card.dart';

class DashboardScreen extends StatelessWidget {
  final AppData data;
  const DashboardScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final recent = data.transactions.take(5).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 110),
      children: [
        Text('Обзор', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: c.text)),
        const SizedBox(height: 18),
        _BalanceCard(data: data),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: 'Доходы за месяц',
                value: formatMoney(data.monthIncome),
                color: c.positive,
                icon: Icons.arrow_downward_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                label: 'Расходы за месяц',
                value: formatMoney(data.monthExpense),
                color: c.negative,
                icon: Icons.arrow_upward_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Последние операции', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: c.text)),
            Text('Все', style: TextStyle(fontSize: 14, color: c.accent, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 10),
        SectionCard(
          child: recent.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text('Пока нет операций — добавь первую кнопкой "+"',
                      style: TextStyle(fontSize: 13.5, color: c.text2)),
                )
              : Column(
                  children: [
                    for (int i = 0; i < recent.length; i++) ...[
                      _TxRow(tx: recent[i]),
                      if (i != recent.length - 1) Divider(height: 1, color: c.border),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final AppData data;
  const _BalanceCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.accent, Color.lerp(c.accent, Colors.black, 0.25)!],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [BoxShadow(color: c.accent.withOpacity(0.35), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Общий баланс', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14)),
          const SizedBox(height: 6),
          Text(
            formatMoney(data.totalBalance),
            style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -0.5),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Pill(
                icon: Icons.trending_up_rounded,
                text: '${formatMoneySigned(data.monthIncome - data.monthExpense)} за месяц',
              ),
              _Pill(
                icon: Icons.calendar_today_rounded,
                text: 'До зарплаты ${data.daysUntilPayday} дн.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: c.card, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: color.withOpacity(0.14), shape: BoxShape.circle),
            child: Icon(icon, size: 17, color: color),
          ),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(fontSize: 12.5, color: c.text2)),
          const SizedBox(height: 3),
          Text(value, style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: c.text)),
        ],
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  final AppTransaction tx;
  const _TxRow({required this.tx});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final cat = tx.category;
    final isIncome = tx.type == TxType.income;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: c.tint(0.16), shape: BoxShape.circle),
            child: Center(child: CategoryIcon(iconKey: cat.iconKey, color: c.accent, size: 19)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cat.name, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: c.text)),
                Text(tx.note ?? formatDay(tx.date), style: TextStyle(fontSize: 12.5, color: c.text2)),
              ],
            ),
          ),
          Text(
            (isIncome ? '+' : '-') + formatMoney(tx.amount).replaceAll('-', ''),
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: isIncome ? c.positive : c.text),
          ),
        ],
      ),
    );
  }
}
