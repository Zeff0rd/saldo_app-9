import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../theme/app_theme.dart';

/// Экран первого запуска: пользователь указывает стартовый баланс,
/// от которого приложение будет вести учёт.
class OnboardingScreen extends StatefulWidget {
  final AppData data;
  const OnboardingScreen({super.key, required this.data});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final ctrl = TextEditingController();

  void start() {
    final value = double.tryParse(ctrl.text.replaceAll(',', '.')) ?? 0;
    widget.data.completeOnboarding(value);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(color: c.accent, borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.savings_outlined, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 28),
              Text('Добро пожаловать в Saldo',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: c.text)),
              const SizedBox(height: 10),
              Text(
                'Укажи, сколько у тебя денег сейчас — это будет точка отсчёта. Дальше все операции будут пересчитывать баланс от неё.',
                style: TextStyle(fontSize: 14.5, color: c.text2, height: 1.4),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: ctrl,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: c.text),
                decoration: InputDecoration(
                  hintText: '0',
                  suffixText: '₽',
                  suffixStyle: TextStyle(fontSize: 22, color: c.text2),
                  filled: true,
                  fillColor: c.card,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: start,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Начать', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
