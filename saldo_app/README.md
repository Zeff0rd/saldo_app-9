# Saldo — Flutter-приложение

Код приложения (модели, состояние, все экраны из макета) написан и готов.
В этой облачной среде нет доступа к серверам Google (`storage.googleapis.com`,
`dl.google.com`) — оттуда Flutter качает сам движок и Android-инструменты,
поэтому собрать APK прямо здесь нельзя. Нужно один раз выполнить сборку
там, где обычный интернет — на своём Mac или через GitHub Actions.

## Запуск на Mac (проще всего)

1. Установить Flutter: https://docs.flutter.dev/get-started/install/macos
2. В папке `saldo_app`:
   ```
   flutter create . --platforms=android,ios
   flutter pub get
   flutter run
   ```
   Команда `flutter create .` достроит нативные папки `android/` и `ios/`,
   которых здесь нет — они генерируются автоматически, руками их писать
   не нужно и не стоит.
3. Для установки на Android-телефон по USB (включить "Отладку по USB" в
   настройках разработчика):
   ```
   flutter build apk --release
   ```
   Готовый файл: `build/app/outputs/flutter-apk/app-release.apk` —
   его можно скинуть на телефон и установить напрямую.

## Структура проекта

- `lib/models/` — Transaction, Category, Account, Budget, Goal, Tracker
- `lib/data/app_data.dart` — состояние приложения (в памяти, с демо-данными)
- `lib/theme/app_theme.dart` — светлая/тёмная тема + акцентный цвет
- `lib/screens/` — Обзор, Операции, Добавление, Аналитика
  (Обзор/Бюджеты/Цели/Трекер), Категории, Настройки
- `lib/widgets/` — иконки категорий (включая спорткар), кольца прогресса,
  мини-диаграммы, донат-чарт
