import 'package:intl/intl.dart';

final _rub = NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0);
final _rubSigned = NumberFormat.currency(locale: 'ru_RU', symbol: '₽', decimalDigits: 0);

String formatMoney(double v) => _rub.format(v);

String formatMoneySigned(double v) {
  final s = _rubSigned.format(v.abs());
  return v >= 0 ? '+$s' : '-$s';
}

String formatDay(DateTime d) {
  const months = [
    'янв', 'фев', 'мар', 'апр', 'мая', 'июн',
    'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
  ];
  final now = DateTime.now();
  final isToday = d.year == now.year && d.month == now.month && d.day == now.day;
  final yesterday = now.subtract(const Duration(days: 1));
  final isYesterday = d.year == yesterday.year && d.month == yesterday.month && d.day == yesterday.day;
  if (isToday) return 'Сегодня';
  if (isYesterday) return 'Вчера';
  return '${d.day} ${months[d.month - 1]}';
}
