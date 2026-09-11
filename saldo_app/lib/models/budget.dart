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
  final double progress; // сколько уже сделано за текущий период (0..1 доля от target для savings — сумма)
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
}
