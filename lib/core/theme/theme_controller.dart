import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeMode =
      ValueNotifier(ThemeMode.light);

  static const String _key = 'is_dark_mode';

  static Future<void> load() async {
    final box = Hive.box('mb_reminder_box');

    final isDark = box.get(_key, defaultValue: false);

    themeMode.value = isDark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static Future<void> toggle() async {
    final box = Hive.box('mb_reminder_box');

    final isDark = themeMode.value == ThemeMode.dark;

    themeMode.value = isDark
        ? ThemeMode.light
        : ThemeMode.dark;

    await box.put(_key, !isDark);
  }
}