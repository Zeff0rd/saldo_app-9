import 'package:flutter/material.dart';

/// Сопоставление ключей категорий с иконками.
/// Большинство — контурные Material-иконки (совпадают со стилем макета:
/// тонкая линия, stroke-width ~1.6). Спорткар — отдельная кастомная
/// отрисовка (см. CarIcon), т.к. это был ключевой пункт фидбека по дизайну.
const Map<String, IconData> kCategoryIconMap = {
  'food': Icons.shopping_basket_outlined,
  'cafe': Icons.local_cafe_outlined,
  'home': Icons.home_outlined,
  'key': Icons.vpn_key_outlined,
  'bag': Icons.shopping_bag_outlined,
  'heart': Icons.favorite_border,
  'dumbbell': Icons.fitness_center_outlined,
  'film': Icons.movie_outlined,
  'plane': Icons.flight_outlined,
  'book': Icons.menu_book_outlined,
  'repeat': Icons.autorenew,
  'wifi': Icons.wifi,
  'paw': Icons.pets_outlined,
  'gift': Icons.card_giftcard_outlined,
  'family': Icons.family_restroom_outlined,
  'sparkle': Icons.auto_awesome_outlined,
  'doc': Icons.description_outlined,
  'dots': Icons.more_horiz,
  'wallet': Icons.account_balance_wallet_outlined,
  'laptop': Icons.laptop_mac_outlined,
  'chart': Icons.trending_up,
};

/// Отрисовывает иконку категории по ключу. Для 'car' — кастомный
/// силуэт спорткара (CarIcon), для остальных — Material-иконка.
class CategoryIcon extends StatelessWidget {
  final String iconKey;
  final Color color;
  final double size;

  const CategoryIcon({super.key, required this.iconKey, required this.color, this.size = 20});

  @override
  Widget build(BuildContext context) {
    if (iconKey == 'car') {
      return CarIcon(color: color, size: size);
    }
    final icon = kCategoryIconMap[iconKey] ?? Icons.circle_outlined;
    return Icon(icon, color: color, size: size);
  }
}

/// Силуэт низкого спорткара — финальная версия из мокапа, перенесённая
/// из SVG (viewBox 0 0 24 24) в CustomPainter. Кузов + спойлер + лобовое
/// стекло + два колеса с чёткими ступицами (не "два кружка и силуэт").
class CarIcon extends StatelessWidget {
  final Color color;
  final double size;
  const CarIcon({super.key, required this.color, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _CarPainter(color: color)),
    );
  }
}

class _CarPainter extends CustomPainter {
  final Color color;
  _CarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6 * s
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..color = color..style = PaintingStyle.fill;
    final hub = Paint()..color = color.withOpacity(0.35)..style = PaintingStyle.fill;

    // Низкий кузов спорткара со спойлером.
    final body = Path()
      ..moveTo(2 * s, 15.4 * s)
      ..lineTo(2.2 * s, 13.3 * s)
      ..lineTo(3.9 * s, 12.8 * s)
      ..lineTo(5.9 * s, 12.3 * s)
      ..quadraticBezierTo(7.3 * s, 9.9 * s, 9.1 * s, 8.5 * s)
      ..lineTo(11.6 * s, 8.4 * s)
      ..lineTo(14.7 * s, 9.7 * s)
      ..lineTo(18.6 * s, 11.6 * s)
      ..lineTo(21.5 * s, 13 * s)
      ..lineTo(22.3 * s, 15.4 * s)
      ..close();
    canvas.drawPath(body, stroke);

    // Спойлер сзади.
    final spoiler = Path()
      ..moveTo(2.5 * s, 13 * s)
      ..lineTo(2.5 * s, 10.3 * s)
      ..lineTo(5 * s, 9.9 * s);
    canvas.drawPath(spoiler, stroke);

    // Лобовое стекло.
    canvas.drawLine(Offset(9.3 * s, 8.7 * s), Offset(8.3 * s, 11.9 * s), stroke);

    // Передний сплиттер.
    final splitter = Path()
      ..moveTo(21.6 * s, 13.1 * s)
      ..quadraticBezierTo(22.3 * s, 13.1 * s, 22.2 * s, 14.3 * s);
    canvas.drawPath(splitter, stroke);

    // Колёса — заднее и переднее, с чёткой ступицей.
    canvas.drawCircle(Offset(6.2 * s, 15.4 * s), 2.75 * s, fill);
    canvas.drawCircle(Offset(6.2 * s, 15.4 * s), 1.1 * s, hub);
    canvas.drawCircle(Offset(17.9 * s, 15.4 * s), 2.75 * s, fill);
    canvas.drawCircle(Offset(17.9 * s, 15.4 * s), 1.1 * s, hub);
  }

  @override
  bool shouldRepaint(covariant _CarPainter oldDelegate) => oldDelegate.color != color;
}
