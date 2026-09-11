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

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'categoryId': categoryId,
        'amount': amount,
        'date': date.toIso8601String(),
        'accountId': accountId,
        'note': note,
      };

  factory AppTransaction.fromJson(Map<String, dynamic> j) => AppTransaction(
        id: j['id'] as String,
        type: TxType.values.byName(j['type'] as String),
        categoryId: j['categoryId'] as String,
        amount: (j['amount'] as num).toDouble(),
        date: DateTime.parse(j['date'] as String),
        accountId: j['accountId'] as String,
        note: j['note'] as String?,
      );
}

class Account {
  final String id;
  final String name;
  final double balance;

  const Account({required this.id, required this.name, required this.balance});

  Account copyWith({double? balance}) =>
      Account(id: id, name: name, balance: balance ?? this.balance);

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'balance': balance};

  factory Account.fromJson(Map<String, dynamic> j) => Account(
        id: j['id'] as String,
        name: j['name'] as String,
        balance: (j['balance'] as num).toDouble(),
      );
}
