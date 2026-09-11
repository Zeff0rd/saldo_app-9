import 'package:flutter/material.dart';
import 'data/app_data.dart';
import 'screens/onboarding_screen.dart';
import 'screens/root_shell.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SaldoApp());
}

class SaldoApp extends StatefulWidget {
  const SaldoApp({super.key});

  @override
  State<SaldoApp> createState() => _SaldoAppState();
}

class _SaldoAppState extends State<SaldoApp> {
  AppData? data;

  @override
  void initState() {
    super.initState();
    AppData.load().then((d) => setState(() => data = d));
  }

  @override
  Widget build(BuildContext context) {
    final d = data;
    if (d == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.build(brightness: Brightness.light),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return AnimatedBuilder(
      animation: d,
      builder: (context, _) {
        return MaterialApp(
          title: 'Saldo',
          debugShowCheckedModeBanner: false,
          themeMode: d.themeMode,
          theme: AppTheme.build(brightness: Brightness.light, accent: d.accent),
          darkTheme: AppTheme.build(brightness: Brightness.dark, accent: d.accent),
          home: d.onboarded ? RootShell(data: d) : OnboardingScreen(data: d),
        );
      },
    );
  }
}
