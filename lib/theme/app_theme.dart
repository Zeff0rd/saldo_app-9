import 'package:flutter/material.dart';

/// Дизайн-система Saldo — светлая и тёмная тема + акцентный цвет.
/// Соответствует финальному макету (.dc.html), где токены заданы в oklch.
class AppColors extends ThemeExtension<AppColors> {
  final Color bg;
  final Color card;
  final Color card2;
  final Color text;
  final Color text2;
  final Color text3;
  final Color border;
  final Color accent;
  final Color positive;
  final Color negative;
  final bool isDark;

  const AppColors({
    required this.bg,
    required this.card,
    required this.card2,
    required this.text,
    required this.text2,
    required this.text3,
    required this.border,
    required this.accent,
    required this.positive,
    required this.negative,
    required this.isDark,
  });

  static AppColors light(Color accent) => AppColors(
        bg: const Color(0xFFF4F4F6),
        card: const Color(0xFFFFFFFF),
        card2: const Color(0xFFF0F0F3),
        text: const Color(0xFF1B1C1E),
        text2: const Color(0xFF6B6D75),
        text3: const Color(0xFFA5A7B0),
        border: const Color(0xFFE6E6EA),
        accent: accent,
        positive: const Color(0xFF17A672),
        negative: const Color(0xFFE0503C),
        isDark: false,
      );

  static AppColors dark(Color accent) => AppColors(
        bg: const Color(0xFF0E0F11),
        card: const Color(0xFF191B1E),
        card2: const Color(0xFF212327),
        text: const Color(0xFFF2F2F4),
        text2: const Color(0xFFA0A2AA),
        text3: const Color(0xFF6C6E76),
        border: const Color(0xFF2A2C31),
        accent: accent,
        positive: const Color(0xFF34C98A),
        negative: const Color(0xFFF06B57),
        isDark: true,
      );

  /// Мягкий оттеночный цвет под иконку/чип категории (amount 0..1 — доля акцента).
  Color tint(double amount) {
    final mix = isDark ? Colors.black : Colors.white;
    return Color.lerp(mix, accent, amount) ?? accent;
  }

  @override
  AppColors copyWith({Color? accent}) =>
      isDark ? AppColors.dark(accent ?? this.accent) : AppColors.light(accent ?? this.accent);

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return t < 0.5 ? this : other;
  }
}

const kDefaultAccent = Color(0xFF1CA7A0); // тёмная бирюза, как в макете

class AppTheme {
  static ThemeData build({required Brightness brightness, Color accent = kDefaultAccent}) {
    final isDark = brightness == Brightness.dark;
    final c = isDark ? AppColors.dark(accent) : AppColors.light(accent);

    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: c.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: accent,
        brightness: brightness,
      ).copyWith(
        primary: accent,
        surface: c.card,
      ),
      cardColor: c.card,
      dividerColor: c.border,
      textTheme: Typography.material2021(platform: TargetPlatform.iOS)
          .black
          .apply(bodyColor: c.text, displayColor: c.text),
    );

    return base.copyWith(extensions: [c]);
  }
}

extension AppColorsX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
