import 'category.dart';

class AppTransaction {
  final String id;
  final TxType type;
  final String categoryId;
  final double amount;
  final DateTime date;
  final String accountId;
  final String? note;

  const AppTransaction({
    required this.id,
    required this.type,
    required this.categoryId,
    required this.amount,
    required this.date,
    required this.accountId,
    this.note,
  });

  AppCategory get category => categoryById(categoryId);
}

class Account {
  final String id;
  final String name;
  final double balance;

  const Account({required this.id, required this.name, required this.balance});
}
