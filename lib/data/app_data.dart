import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/budget.dart';

/// Состояние приложения (ChangeNotifier), сохраняется на устройство через
/// SharedPreferences в виде одного JSON-блока. Никаких демо-данных —
/// пользователь начинает с чистого состояния и стартового баланса,
/// который указывает при первом запуске (см. OnboardingScreen).
class AppData extends ChangeNotifier {
  static const _prefsKey = 'saldo_data_v1';

  bool onboarded = false;
  ThemeMode themeMode = ThemeMode.system;
  Color accent = const Color(0xFF1CA7A0);
  int paydayDayOfMonth = 5;

  final List<Account> accounts = [];
  final List<AppTransaction> transactions = [];
  final List<Budget> budgets = [];
  final List<Goal> goals = [];
  final List<Tracker> trackers = [];

  SharedPreferences? _prefs;

  static Future<AppData> load() async {
    final data = AppData._();
    await data._load();
    return data;
  }

  AppData._();

  Future<void> _load() async {
    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs?.getString(_prefsKey);
    if (raw == null) return;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      onboarded = j['onboarded'] as bool? ?? false;
      themeMode = ThemeMode.values.byName(j['themeMode'] as String? ?? 'system');
      accent = Color(j['accent'] as int? ?? accent.value);
      paydayDayOfMonth = j['paydayDayOfMonth'] as int? ?? 5;
      accounts
        ..clear()
        ..addAll((j['accounts'] as List? ?? []).map((e) => Account.fromJson(e as Map<String, dynamic>)));
      transactions
        ..clear()
        ..addAll((j['transactions'] as List? ?? []).map((e) => AppTransaction.fromJson(e as Map<String, dynamic>)));
      budgets
        ..clear()
        ..addAll((j['budgets'] as List? ?? []).map((e) => Budget.fromJson(e as Map<String, dynamic>)));
      goals
        ..clear()
        ..addAll((j['goals'] as List? ?? []).map((e) => Goal.fromJson(e as Map<String, dynamic>)));
      trackers
        ..clear()
        ..addAll((j['trackers'] as List? ?? []).map((e) => Tracker.fromJson(e as Map<String, dynamic>)));
    } catch (_) {
      // Повреждённые данные — начинаем с чистого состояния, ничего не роняем.
    }
  }

  Future<void> _save() async {
    final j = {
      'onboarded': onboarded,
      'themeMode': themeMode.name,
      'accent': accent.value,
      'paydayDayOfMonth': paydayDayOfMonth,
      'accounts': accounts.map((e) => e.toJson()).toList(),
      'transactions': transactions.map((e) => e.toJson()).toList(),
      'budgets': budgets.map((e) => e.toJson()).toList(),
      'goals': goals.map((e) => e.toJson()).toList(),
      'trackers': trackers.map((e) => e.toJson()).toList(),
    };
    await _prefs?.setString(_prefsKey, jsonEncode(j));
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

  /// Первый запуск: пользователь указывает стартовый баланс.
  void completeOnboarding(double startingBalance) {
    accounts.add(Account(id: 'main', name: 'Основной счёт', balance: startingBalance));
    onboarded = true;
    notifyListeners();
    _save();
  }

  void addTransaction(AppTransaction t) {
    transactions.insert(0, t);

    final accIdx = accounts.indexWhere((a) => a.id == t.accountId);
    if (accIdx != -1) {
      final delta = t.type == TxType.income ? t.amount : -t.amount;
      accounts[accIdx] = accounts[accIdx].copyWith(balance: accounts[accIdx].balance + delta);
    }

    if (t.type == TxType.expense) {
      final idx = budgets.indexWhere((b) => b.categoryId == t.categoryId);
      if (idx != -1) {
        budgets[idx] = budgets[idx].copyWith(spent: budgets[idx].spent + t.amount);
      }
    }
    notifyListeners();
    _save();
  }

  void addGoal(Goal g) {
    goals.add(g);
    notifyListeners();
    _save();
  }

  void topUpGoal(String id, double amount) {
    final idx = goals.indexWhere((g) => g.id == id);
    if (idx == -1) return;
    goals[idx] = goals[idx].copyWith(current: goals[idx].current + amount);
    notifyListeners();
    _save();
  }

  void addBudget(Budget b) {
    budgets.add(b);
    notifyListeners();
    _save();
  }

  void addTracker(Tracker t) {
    trackers.add(t);
    notifyListeners();
    _save();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
    _save();
  }

  void setAccent(Color c) {
    accent = c;
    notifyListeners();
    _save();
  }
}
