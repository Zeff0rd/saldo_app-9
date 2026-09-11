import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../theme/app_theme.dart';
import 'categories_screen.dart';

class SettingsScreen extends StatefulWidget {
  final AppData data;
  const SettingsScreen({super.key, required this.data});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const accents = [
    Color(0xFF1CA7A0), Color(0xFF3D7DFF), Color(0xFFB25CFF),
    Color(0xFFFF7A45), Color(0xFFE0503C), Color(0xFF17A672),
  ];

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final data = widget.data;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 110),
      children: [
        Text('Настройки', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: c.text)),
        const SizedBox(height: 20),
        _ProfileCard(),
        const SizedBox(height: 18),
        _Group(title: 'Внешний вид', children: [
          _Row(
            label: 'Тема',
            trailing: _ThemeSegmented(
              mode: data.themeMode,
              onChanged: (m) => setState(() => data.setThemeMode(m)),
            ),
          ),
          const Divider(height: 24),
          _Row(
            label: 'Акцентный цвет',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final a in accents)
                  GestureDetector(
                    onTap: () => setState(() => data.setAccent(a)),
                    child: Container(
                      margin: const EdgeInsets.only(left: 6),
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: a,
                        shape: BoxShape.circle,
                        border: data.accent == a ? Border.all(color: c.text, width: 2) : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ]),
        const SizedBox(height: 16),
        _Group(title: 'Основное', children: [
          _NavRow(icon: Icons.category_outlined, label: 'Категории',
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesScreen()))),
          const Divider(height: 24),
          _NavRow(icon: Icons.language, label: 'Язык', value: 'Русский', onTap: () {}),
          const Divider(height: 24),
          _NavRow(icon: Icons.notifications_none, label: 'Уведомления', onTap: () {}),
        ]),
        const SizedBox(height: 16),
        _BankPromo(),
        const SizedBox(height: 16),
        _Group(title: 'Данные', children: [
          _NavRow(icon: Icons.ios_share, label: 'Экспорт данных', onTap: () {}),
          const Divider(height: 24),
          _NavRow(icon: Icons.workspace_premium_outlined, label: 'Подписка Saldo Pro', onTap: () {}),
        ]),
        const SizedBox(height: 16),
        _NavRow(icon: Icons.logout, label: 'Выйти', onTap: () {}, danger: true),
        const SizedBox(height: 24),
        Center(child: Text('Saldo · версия 0.1.0', style: TextStyle(fontSize: 12, color: c.text3))),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: c.card, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(radius: 26, backgroundColor: c.accent, child: const Text('Л', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Лидия', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: c.text)),
                Text('karevalidia25@gmail.com', style: TextStyle(fontSize: 12.5, color: c.text2)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: c.text3),
        ],
      ),
    );
  }
}

class _BankPromo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [c.accent.withOpacity(0.16), c.accent.withOpacity(0.05)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.accent.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_outlined, color: c.accent, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Автосинхронизация с банком', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: c.text)),
                const SizedBox(height: 2),
                Text('Скоро — операции будут добавляться сами', style: TextStyle(fontSize: 12.5, color: c.text2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Group({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.only(left: 4, bottom: 8), child: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: c.text2))),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: c.card, borderRadius: BorderRadius.circular(20)),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final Widget trailing;
  const _Row({required this.label, required this.trailing});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14.5, color: c.text)),
        trailing,
      ],
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;
  final bool danger;
  const _NavRow({required this.icon, required this.label, this.value, required this.onTap, this.danger = false});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = danger ? c.negative : c.text;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 14.5, color: color, fontWeight: danger ? FontWeight.w600 : FontWeight.w500))),
          if (value != null) Text(value!, style: TextStyle(fontSize: 13.5, color: c.text2)),
          if (!danger) Icon(Icons.chevron_right, color: c.text3, size: 20),
        ],
      ),
    );
  }
}

class _ThemeSegmented extends StatelessWidget {
  final ThemeMode mode;
  final ValueChanged<ThemeMode> onChanged;
  const _ThemeSegmented({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    Widget seg(IconData icon, ThemeMode m) {
      final active = mode == m;
      return GestureDetector(
        onTap: () => onChanged(m),
        child: Container(
          width: 34, height: 30,
          decoration: BoxDecoration(
            color: active ? c.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 16, color: active ? Colors.white : c.text2),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: c.card2, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        seg(Icons.light_mode_outlined, ThemeMode.light),
        seg(Icons.dark_mode_outlined, ThemeMode.dark),
        seg(Icons.smartphone, ThemeMode.system),
      ]),
    );
  }
}
