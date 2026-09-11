import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/category_icons.dart';
import '../widgets/section_card.dart';

class TransactionsScreen extends StatefulWidget {
  final AppData data;
  const TransactionsScreen({super.key, required this.data});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tx = widget.data.transactions
        .where((t) => query.isEmpty || t.category.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    final Map<String, List<AppTransaction>> byDay = {};
    for (final t in tx) {
      byDay.putIfAbsent(formatDay(t.date), () => []).add(t);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 110),
      children: [
        Text('Операции', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: c.text)),
        const SizedBox(height: 16),
        TextField(
          onChanged: (v) => setState(() => query = v),
          style: TextStyle(color: c.text),
          decoration: InputDecoration(
            hintText: 'Поиск по категории',
            hintStyle: TextStyle(color: c.text3),
            prefixIcon: Icon(Icons.search, color: c.text3),
            filled: true,
            fillColor: c.card,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 18),
        if (byDay.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Center(
              child: Text('Операций пока нет', style: TextStyle(fontSize: 14, color: c.text2)),
            ),
          ),
        for (final entry in byDay.entries) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c.text2)),
                Text(
                  formatMoneySigned(entry.value.fold(0.0, (a, t) => a + (t.type == TxType.income ? t.amount : -t.amount))),
                  style: TextStyle(fontSize: 12.5, color: c.text3),
                ),
              ],
            ),
          ),
          SectionCard(
            child: Column(
              children: [
                for (int i = 0; i < entry.value.length; i++) ...[
                  _Row(tx: entry.value[i]),
                  if (i != entry.value.length - 1) Divider(height: 1, color: c.border),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final AppTransaction tx;
  const _Row({required this.tx});

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
                if (tx.note != null) Text(tx.note!, style: TextStyle(fontSize: 12.5, color: c.text2)),
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
