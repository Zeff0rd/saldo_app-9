import 'package:flutter/material.dart';

enum TxType { expense, income }

/// Категория операции. iconKey соответствует ключу в widgets/category_icons.dart.
class AppCategory {
  final String id;
  final String name;
  final String iconKey;
  final TxType type;

  const AppCategory({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.type,
  });
}

/// Полный набор категорий — как в финальном экране "Категории" макета.
const List<AppCategory> kExpenseCategories = [
  AppCategory(id: 'food', name: 'Продукты', iconKey: 'food', type: TxType.expense),
  AppCategory(id: 'cafe', name: 'Кафе и рестораны', iconKey: 'cafe', type: TxType.expense),
  AppCategory(id: 'transport', name: 'Транспорт', iconKey: 'car', type: TxType.expense),
  AppCategory(id: 'home', name: 'ЖКХ', iconKey: 'home', type: TxType.expense),
  AppCategory(id: 'rent', name: 'Аренда', iconKey: 'key', type: TxType.expense),
  AppCategory(id: 'shopping', name: 'Покупки', iconKey: 'bag', type: TxType.expense),
  AppCategory(id: 'health', name: 'Здоровье', iconKey: 'heart', type: TxType.expense),
  AppCategory(id: 'sport', name: 'Спорт', iconKey: 'dumbbell', type: TxType.expense),
  AppCategory(id: 'entertainment', name: 'Развлечения', iconKey: 'film', type: TxType.expense),
  AppCategory(id: 'travel', name: 'Путешествия', iconKey: 'plane', type: TxType.expense),
  AppCategory(id: 'education', name: 'Образование', iconKey: 'book', type: TxType.expense),
  AppCategory(id: 'subscriptions', name: 'Подписки', iconKey: 'repeat', type: TxType.expense),
  AppCategory(id: 'communication', name: 'Связь и интернет', iconKey: 'wifi', type: TxType.expense),
  AppCategory(id: 'pets', name: 'Питомцы', iconKey: 'paw', type: TxType.expense),
  AppCategory(id: 'gifts', name: 'Подарки', iconKey: 'gift', type: TxType.expense),
  AppCategory(id: 'family', name: 'Семья и дети', iconKey: 'family', type: TxType.expense),
  AppCategory(id: 'beauty', name: 'Красота', iconKey: 'sparkle', type: TxType.expense),
  AppCategory(id: 'taxes', name: 'Налоги', iconKey: 'doc', type: TxType.expense),
  AppCategory(id: 'other', name: 'Другое', iconKey: 'dots', type: TxType.expense),
];

const List<AppCategory> kIncomeCategories = [
  AppCategory(id: 'salary', name: 'Зарплата', iconKey: 'wallet', type: TxType.income),
  AppCategory(id: 'freelance', name: 'Подработка', iconKey: 'laptop', type: TxType.income),
  AppCategory(id: 'investments', name: 'Инвестиции', iconKey: 'chart', type: TxType.income),
  AppCategory(id: 'gift_income', name: 'Подарки', iconKey: 'gift', type: TxType.income),
];

AppCategory categoryById(String id) {
  return [...kExpenseCategories, ...kIncomeCategories]
      .firstWhere((c) => c.id == id, orElse: () => kExpenseCategories.last);
}
