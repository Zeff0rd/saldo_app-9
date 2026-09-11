import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../theme/app_theme.dart';
import '../widgets/category_icons.dart';

class AddTransactionScreen extends StatefulWidget {
  final AppData data;
  const AddTransactionScreen({super.key, required this.data});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  TxType type = TxType.expense;
  String amount = '0';
  AppCategory? selectedCategory;
  String accountId = 'card';
  final noteCtrl = TextEditingController();

  List<AppCategory> get categories => type == TxType.expense ? kExpenseCategories : kIncomeCategories;

  void tapKey(String k) {
    setState(() {
      if (k == '⌫') {
        amount = amount.length > 1 ? amount.substring(0, amount.length - 1) : '0';
      } else if (k == '.') {
        if (!amount.contains('.')) amount += '.';
      } else {
        amount = amount == '0' ? k : amount + k;
      }
    });
  }

  void save() {
    final value = double.tryParse(amount) ?? 0;
    if (value <= 0 || selectedCategory == null) return;
    widget.data.addTransaction(AppTransaction(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type,
      categoryId: selectedCategory!.id,
      amount: value,
      date: DateTime.now(),
      accountId: accountId,
      note: noteCtrl.text.isEmpty ? null : noteCtrl.text,
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.bg,
      appBar: AppBar(
        backgroundColor: c.bg,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.close, color: c.text), onPressed: () => Navigator.pop(context)),
        title: Text('Новая операция', style: TextStyle(color: c.text, fontSize: 17, fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _Segmented(type: type, onChanged: (t) => setState(() { type = t; selectedCategory = null; })),
          ),
          const SizedBox(height: 18),
          Text(
            '$amount ₽',
            style: TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: c.text, letterSpacing: -1),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 96,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: [
                for (final cat in categories) _CategoryChip(
                  category: cat,
                  selected: selectedCategory?.id == cat.id,
                  onTap: () => setState(() => selectedCategory = cat),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: noteCtrl,
              style: TextStyle(color: c.text),
              decoration: InputDecoration(
                hintText: 'Заметка (необязательно)',
                hintStyle: TextStyle(color: c.text3),
                filled: true,
                fillColor: c.card,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const Spacer(),
          _Keypad(onKey: tapKey),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: c.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Сохранить', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segmented extends StatelessWidget {
  final TxType type;
  final ValueChanged<TxType> onChanged;
  const _Segmented({required this.type, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget seg(String label, TxType t) {
      final active = type == t;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(t),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? c.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(label, style: TextStyle(
              color: active ? Colors.white : c.text2,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            )),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: c.card2, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [seg('Расход', TxType.expense), seg('Доход', TxType.income)]),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final AppCategory category;
  final bool selected;
  final VoidCallback onTap;
  const _CategoryChip({required this.category, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: selected ? c.accent : c.tint(0.14),
                shape: BoxShape.circle,
                border: selected ? Border.all(color: c.accent, width: 2) : null,
              ),
              child: Center(
                child: CategoryIcon(iconKey: category.iconKey, color: selected ? Colors.white : c.accent, size: 22),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 64,
              child: Text(category.name, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 11, color: c.text2)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onKey;
  const _Keypad({required this.onKey});

  static const keys = ['1','2','3','4','5','6','7','8','9','.','0','⌫'];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 2.0,
        children: [
          for (final k in keys)
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onKey(k),
              child: Center(
                child: Text(k, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: c.text)),
              ),
            ),
        ],
      ),
    );
  }
}
