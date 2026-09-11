import 'package:flutter/material.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';
import '../widgets/category_icons.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.bg,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.chevron_left, color: c.text), onPressed: () => Navigator.pop(context)),
        title: Text('Категории', style: TextStyle(color: c.text, fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          Text('Расходы', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.text2)),
          const SizedBox(height: 12),
          _Grid(categories: kExpenseCategories),
          const SizedBox(height: 24),
          Text('Доходы', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c.text2)),
          const SizedBox(height: 12),
          _Grid(categories: kIncomeCategories),
        ],
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  final List<AppCategory> categories;
  const _Grid({required this.categories});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 8,
      childAspectRatio: 0.78,
      children: [
        for (final cat in categories)
          Column(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(color: c.tint(0.14), shape: BoxShape.circle),
                child: Center(child: CategoryIcon(iconKey: cat.iconKey, color: c.accent, size: 22)),
              ),
              const SizedBox(height: 6),
              Text(cat.name, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: c.text2, height: 1.2)),
            ],
          ),
        Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: c.border, width: 1.5, style: BorderStyle.solid),
              ),
              child: Icon(Icons.add, color: c.text3, size: 22),
            ),
            const SizedBox(height: 6),
            Text('Добавить', style: TextStyle(fontSize: 11, color: c.text3)),
          ],
        ),
      ],
    );
  }
}
