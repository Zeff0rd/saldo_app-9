import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/budget.dart';

/// Простое in-memory хранилище состояния приложения (ChangeNotifier).
/// Для первой версии — без персистентности/БД; при необходимости
/// заменяется на Hive/Isar без изменения экранов (они читают только
/// через AppData).
class AppData extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  Color accent = const Color(0xFF1CA7A0);
  int paydayDayOfMonth = 5; // день зарплаты — для расчёта "До зарплаты N дней"

  final List<Account> accounts = [
    const Account(id: 'card', name: 'Основная карта', balance: 184_320),
    const Account(id: 'cash', name: 'Наличные', balance: 6_400),
    const Account(id: 'save', name: 'Накопительный счёт', balance: 152_000),
  ];

  final List<AppTransaction> transactions = [];
  final List<Budget> budgets = [];
  final List<Goal> goals = [];
  final List<Tracker> trackers = [];

  AppData() {
    _seed();
  }

  double get totalBalance => accounts.fold(0, (a, b) => a + b.balance);

  double get monthIncome => transactions
      .where((t) => t.type == TxType.income && _isThisMonth(t.date))
      .fold(0, (a, t) => a + t.amount);

  double get monthExpense => transactions
      .where((t) => t.type == TxType.expense && _isThisMonth(t.date))
      .fold(0, (a, t) => a + t.amount);

  bool _isThisMonth(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month;
  }

  int get daysUntilPayday {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, paydayDayOfMonth);
    if (!next.isAfter(now)) {
      next = DateTime(now.year, now.month + 1, paydayDayOfMonth);
    }
    return next.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  void addTransaction(AppTransaction t) {
    transactions.insert(0, t);
    // Обновляем "потрачено" для бюджетов той же категории.
    if (t.type == TxType.expense) {
      final idx = budgets.indexWhere((b) => b.categoryId == t.categoryId);
      if (idx != -1) {
        final b = budgets[idx];
        budgets[idx] = Budget(
          id: b.id,
          categoryId: b.categoryId,
          period: b.period,
          limit: b.limit,
          spent: b.spent + t.amount,
        );
      }
    }
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }

  void setAccent(Color c) {
    accent = c;
    notifyListeners();
  }

  void _seed() {
    final now = DateTime.now();
    DateTime d(int daysAgo) => now.subtract(Duration(days: daysAgo));

    transactions.addAll([
      AppTransaction(id: 't1', type: TxType.expense, categoryId: 'cafe', amount: 640, date: d(0), accountId: 'card', note: 'Кофе и завтрак'),
      AppTransaction(id: 't2', type: TxType.expense, categoryId: 'transport', amount: 1200, date: d(0), accountId: 'card', note: 'Заправка'),
      AppTransaction(id: 't3', type: TxType.income, categoryId: 'freelance', amount: 15000, date: d(1), accountId: 'card', note: 'Подработка'),
      AppTransaction(id: 't4', type: TxType.expense, categoryId: 'food', amount: 3480, date: d(1), accountId: 'card', note: 'Продукты на неделю'),
      AppTransaction(id: 't5', type: TxType.expense, categoryId: 'home', amount: 6200, date: d(2), accountId: 'card', note: 'ЖКХ за месяц'),
      AppTransaction(id: 't6', type: TxType.expense, categoryId: 'entertainment', amount: 890, date: d(3), accountId: 'cash', note: 'Кино'),
      AppTransaction(id: 't7', type: TxType.income, categoryId: 'salary', amount: 120000, date: d(5), accountId: 'card', note: 'Зарплата'),
      AppTransaction(id: 't8', type: TxType.expense, categoryId: 'shopping', amount: 4750, date: d(6), accountId: 'card', note: 'Одежда'),
    ]);

    budgets.addAll([
      const Budget(id: 'b1', categoryId: 'food', period: BudgetPeriod.month, limit: 25000, spent: 14800),
      const Budget(id: 'b2', categoryId: 'home', period: BudgetPeriod.month, limit: 8000, spent: 8800),
      const Budget(id: 'b3', categoryId: 'transport', period: BudgetPeriod.month, limit: 6000, spent: 3100),
      const Budget(id: 'b4', categoryId: 'entertainment', period: BudgetPeriod.week, limit: 3000, spent: 1450),
    ]);

    goals.addAll([
      const Goal(id: 'g1', name: 'Отпуск на море', iconKey: 'plane', target: 180000, current: 111600),
      const Goal(id: 'g2', name: 'Новый ноутбук', iconKey: 'laptop', target: 95000, current: 83600),
      const Goal(id: 'g3', name: 'Подушка безопасности', iconKey: 'wallet', target: 300000, current: 102000),
    ]);

    trackers.addAll([
      Tracker(
        id: 'tr1',
        name: 'Дневной бюджет',
        subtitle: 'до 1 500 ₽ в день',
        type: TrackerType.dailyBudget,
        period: BudgetPeriod.day,
        target: 1500,
        progress: 980,
        streak: 4,
        weekly: [0.9, 0.6, 1.1, 0.4, 0.7, 0.65, 0.3],
      ),
      Tracker(
        id: 'tr2',
        name: 'Копилка',
        subtitle: '300 ₽ в день',
        type: TrackerType.savings,
        period: BudgetPeriod.day,
        target: 300,
        progress: 300,
        streak: 11,
        weekly: [1, 1, 1, 0.6, 1, 1, 1],
      ),
      Tracker(
        id: 'tr3',
        name: 'Кафе: лимит недели',
        subtitle: 'до 2 500 ₽ в неделю',
        type: TrackerType.weeklyLimit,
        period: BudgetPeriod.week,
        target: 2500,
        progress: 1610,
        streak: 2,
        weekly: [],
      ),
    ]);
  }
}
