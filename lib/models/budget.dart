enum BudgetPeriod { day, week, month, year }

extension BudgetPeriodX on BudgetPeriod {
  String get label => switch (this) {
        BudgetPeriod.day => 'День',
        BudgetPeriod.week => 'Неделя',
        BudgetPeriod.month => 'Месяц',
        BudgetPeriod.year => 'Год',
      };
}

class Budget {
  final String id;
  final String categoryId;
  final BudgetPeriod period;
  final double limit;
  final double spent;

  const Budget({
    required this.id,
    required this.categoryId,
    required this.period,
    required this.limit,
    required this.spent,
  });

  double get progress => limit == 0 ? 0 : (spent / limit).clamp(0, 2);
  bool get isOverBudget => spent > limit;

  Budget copyWith({double? spent}) => Budget(
        id: id,
        categoryId: categoryId,
        period: period,
        limit: limit,
        spent: spent ?? this.spent,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'period': period.name,
        'limit': limit,
        'spent': spent,
      };

  factory Budget.fromJson(Map<String, dynamic> j) => Budget(
        id: j['id'] as String,
        categoryId: j['categoryId'] as String,
        period: BudgetPeriod.values.byName(j['period'] as String),
        limit: (j['limit'] as num).toDouble(),
        spent: (j['spent'] as num).toDouble(),
      );
}

class Goal {
  final String id;
  final String name;
  final String iconKey;
  final double target;
  final double current;

  const Goal({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.target,
    required this.current,
  });

  double get progress => target == 0 ? 0 : (current / target).clamp(0, 1);

  Goal copyWith({double? current}) =>
      Goal(id: id, name: name, iconKey: iconKey, target: target, current: current ?? this.current);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iconKey': iconKey,
        'target': target,
        'current': current,
      };

  factory Goal.fromJson(Map<String, dynamic> j) => Goal(
        id: j['id'] as String,
        name: j['name'] as String,
        iconKey: j['iconKey'] as String,
        target: (j['target'] as num).toDouble(),
        current: (j['current'] as num).toDouble(),
      );
}

enum TrackerType { dailyBudget, savings, weeklyLimit }

/// Трекер — отдельная сущность от Goal: отслеживает соблюдение
/// дневного/недельного/месячного ритма (бюджет, накопления, лимит).
class Tracker {
  final String id;
  final String name;
  final String subtitle;
  final TrackerType type;
  final BudgetPeriod period;
  final double target;
  final double progress; // сколько уже сделано за текущий период
  final int streak; // дней/недель подряд с выполненной целью
  final List<double> weekly; // 7 значений 0..1 — для мини-диаграммы (пн..вс)

  const Tracker({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.type,
    required this.period,
    required this.target,
    required this.progress,
    required this.streak,
    required this.weekly,
  });

  double get progressPct => target == 0 ? 0 : (progress / target).clamp(0, 1);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'subtitle': subtitle,
        'type': type.name,
        'period': period.name,
        'target': target,
        'progress': progress,
        'streak': streak,
        'weekly': weekly,
      };

  factory Tracker.fromJson(Map<String, dynamic> j) => Tracker(
        id: j['id'] as String,
        name: j['name'] as String,
        subtitle: j['subtitle'] as String,
        type: TrackerType.values.byName(j['type'] as String),
        period: BudgetPeriod.values.byName(j['period'] as String),
        target: (j['target'] as num).toDouble(),
        progress: (j['progress'] as num).toDouble(),
        streak: j['streak'] as int,
        weekly: (j['weekly'] as List).map((e) => (e as num).toDouble()).toList(),
      );
}
