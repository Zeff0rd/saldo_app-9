import 'package:flutter/material.dart';
import 'data/app_data.dart';
import 'screens/root_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SaldoApp());
}

class SaldoApp extends StatefulWidget {
  const SaldoApp({super.key});

  @override
  State<SaldoApp> createState() => _SaldoAppState();
}

class _SaldoAppState extends State<SaldoApp> {
  final AppData data = AppData();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: data,
      builder: (context, _) {
        return MaterialApp(
          title: 'Saldo',
          debugShowCheckedModeBanner: false,
          themeMode: data.themeMode,
          theme: AppTheme.build(brightness: Brightness.light, accent: data.accent),
          darkTheme: AppTheme.build(brightness: Brightness.dark, accent: data.accent),
          home: RootShell(data: data),
        );
      },
    );
  }
}
