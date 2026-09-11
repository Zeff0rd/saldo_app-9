import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/budget.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/category_icons.dart';
import '../widgets/donut_chart.dart';
import '../widgets/mini_bars.dart';
import '../widgets/progress_ring.dart';
import '../widgets/section_card.dart';

class AnalyticsScreen extends StatefulWidget {
  final AppData data;
  const AnalyticsScreen({super.key, required this.data});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int tab = 0; // 0 Обзор, 1 Бюджеты, 2 Цели, 3 Трекер
  static const tabs = ['Обзор', 'Бюджеты', 'Цели', 'Трекер'];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 110),
      children: [
        Text('Аналитика', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: c.text)),
        const SizedBox(height: 16),
        _Seg(tab: tab, tabs: tabs, onChanged: (i) => setState(() => tab = i)),
        const SizedBox(height: 18),
        if (tab == 0) _OverviewTab(data: widget.data),
        if (tab == 1) _BudgetsTab(data: widget.data),
        if (tab == 2) _GoalsTab(data: widget.data),
        if (tab == 3) _TrackerTab(data: widget.data),
      ],
    );
  }
}

class _Seg extends StatelessWidget {
  final int tab;
  final List<String> tabs;
  final ValueChanged<int> onChanged;
  const _Seg({required this.tab, required this.tabs, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: c.card2, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [
        for (int i = 0; i < tabs.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: Container(
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: tab == i ? c.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Text(tabs[i], style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: tab == i ? Colors.white : c.text2,
                )),
              ),
            ),
          ),
      ]),
    );
  }
}

// ---------- Обзор: донат + столбики доходы/расходы ----------

class _OverviewTab extends StatelessWidget {
  final AppData data;
  const _OverviewTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final expenses = data.transactions.where((t) => t.type == TxType.expense).toList();
    final Map<String, double> byCat = {};
    for (final t in expenses) {
      byCat.update(t.categoryId, (v) => v + t.amount, ifAbsent: () => t.amount);
    }
    final entries = byCat.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final palette = [c.accent, c.positive, c.negative, Colors.orange, Colors.purple, Colors.blueGrey];
    final segments = [
      for (int i = 0; i < entries.length; i++)
        DonutSegment(label: categoryById(entries[i].key).name, value: entries[i].value, color: palette[i % palette.length]),
    ];
    final total = byCat.values.fold(0.0, (a, b) => a + b);

    return Column(
      children: [
        SectionCard(
          child: Column(
            children: [
              DonutChart(
                segments: segments,
                track: c.card2,
                center: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Расходы', style: TextStyle(fontSize: 12, color: c.text2)),
                    Text(formatMoney(total), style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: c.text)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 14,
                runSpacing: 8,
                children: [
                  for (final s in segments)
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(width: 9, height: 9, decoration: BoxDecoration(color: s.color, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(s.label, style: TextStyle(fontSize: 12.5, color: c.text2)),
                    ]),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Доходы и расходы', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: c.text)),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _Bar(label: 'Доход', value: data.monthIncome, max: 150000, color: c.positive),
                    const SizedBox(width: 18),
                    _Bar(label: 'Расход', value: data.monthExpense, max: 150000, color: c.negative),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final Color color;
  const _Bar({required this.label, required this.value, required this.max, required this.color});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final h = (value / max).clamp(0.05, 1.0) * 90;
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(formatMoney(value), style: TextStyle(fontSize: 11.5, color: c.text2)),
          const SizedBox(height: 6),
          Container(
            height: h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 12, color: c.text2)),
        ],
      ),
    );
  }
}

// ---------- Бюджеты ----------

class _BudgetsTab extends StatelessWidget {
  final AppData data;
  const _BudgetsTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        for (final b in data.budgets) ...[
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: c.tint(0.14), shape: BoxShape.circle),
                      child: Center(child: CategoryIcon(iconKey: categoryById(b.categoryId).iconKey, color: c.accent, size: 17)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(categoryById(b.categoryId).name, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: c.text)),
                    ),
                    Text(b.period.label, style: TextStyle(fontSize: 12, color: c.text3)),
                    if (b.isOverBudget) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: c.negative.withOpacity(0.14), borderRadius: BorderRadius.circular(20)),
                        child: Text('Превышен', style: TextStyle(fontSize: 10.5, color: c.negative, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (b.spent / b.limit).clamp(0, 1),
                    minHeight: 8,
                    backgroundColor: c.card2,
                    color: b.isOverBudget ? c.negative : c.accent,
                  ),
                ),
                const SizedBox(height: 8),
                Text('${formatMoney(b.spent)} из ${formatMoney(b.limit)}', style: TextStyle(fontSize: 12.5, color: c.text2)),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

// ---------- Цели ----------

class _GoalsTab extends StatelessWidget {
  final AppData data;
  const _GoalsTab({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        for (final g in data.goals) ...[
          SectionCard(
            child: Row(
              children: [
                ProgressRing(progress: g.progress, color: c.accent, track: c.card2, size: 52, stroke: 5),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(g.name, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: c.text)),
                      const SizedBox(height: 3),
                      Text('${formatMoney(g.current)} из ${formatMoney(g.target)}', style: TextStyle(fontSize: 12.5, color: c.text2)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(backgroundColor: c.tint(0.14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  child: Text('Пополнить', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: c.accent)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        DottedAddTile(label: 'Добавить цель'),
      ],
    );
  }
}

class DottedAddTile extends StatelessWidget {
  final String label;
  const DottedAddTile({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: c.text3, size: 18),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: c.text3, fontWeight: FontWeight.w600, fontSize: 13.5)),
        ],
      ),
    );
  }
}

// ---------- Трекер ----------

class _TrackerTab extends StatefulWidget {
  final AppData data;
  const _TrackerTab({required this.data});

  @override
  State<_TrackerTab> createState() => _TrackerTabState();
}

class _TrackerTabState extends State<_TrackerTab> {
  final Set<String> open = {'tr1'};

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        for (final t in widget.data.trackers) ...[
          SectionCard(
            child: Column(
              children: [
                InkWell(
                  onTap: () => setState(() => open.contains(t.id) ? open.remove(t.id) : open.add(t.id)),
                  child: Row(
                    children: [
                      Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(color: c.tint(0.14), shape: BoxShape.circle),
                        child: Icon(
                          t.type == TrackerType.savings ? Icons.savings_outlined : Icons.speed_outlined,
                          color: c.accent, size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.name, style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: c.text)),
                            Text(t.subtitle, style: TextStyle(fontSize: 12.5, color: c.text2)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: c.tint(0.14), borderRadius: BorderRadius.circular(20)),
                        child: Text('🔥 ${t.streak}', style: TextStyle(fontSize: 11.5, color: c.text)),
                      ),
                      const SizedBox(width: 6),
                      Icon(open.contains(t.id) ? Icons.expand_less : Icons.expand_more, color: c.text3),
                    ],
                  ),
                ),
                if (open.contains(t.id)) ...[
                  const SizedBox(height: 14),
                  Divider(height: 1, color: c.border),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      ProgressRing(progress: t.progressPct, color: c.accent, track: c.card2, size: 64, stroke: 6),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${formatMoney(t.progress)} из ${formatMoney(t.target)}',
                                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: c.text)),
                            const SizedBox(height: 3),
                            Text(
                              t.type == TrackerType.savings ? 'Отложено сегодня' : 'Использовано за период',
                              style: TextStyle(fontSize: 12, color: c.text2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (t.weekly.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    MiniBars(values: t.weekly, color: c.accent, track: c.text3),
                  ],
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
        DottedAddTile(label: 'Добавить трекер'),
      ],
    );
  }
}
