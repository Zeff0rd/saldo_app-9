import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Базовая карточка-контейнер — скруглённый угол 20, цвет card, без тени
/// (тень только у акцентных элементов вроде баланса), как в макете.
class SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  const SectionCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: padding,
      decoration: BoxDecoration(color: c.card, borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }
}
