import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mb_reminder/core/services/platform_detector.dart';
import 'package:mb_reminder/core/theme/app_theme.dart';
import 'package:mb_reminder/core/theme/theme_controller.dart';
import 'package:mb_reminder/features/intro/splash_screen.dart';
import 'package:mb_reminder/features/share/screens/share_platform_screen.dart';

const MethodChannel shareChannel = MethodChannel('mb_reminder/share');

final ValueNotifier<String?> sharedTextNotifier = ValueNotifier<String?>(null);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('mb_reminder_box');
  await ThemeController.load();

  final initialSharedText =
      await shareChannel.invokeMethod<String>('getSharedText');

  if (initialSharedText != null && initialSharedText.trim().isNotEmpty) {
    sharedTextNotifier.value = initialSharedText.trim();
    log('Shared link received on launch');
  }

  shareChannel.setMethodCallHandler((call) async {
    if (call.method != 'sharedText') return;

    final value = call.arguments?.toString().trim();
    if (value == null || value.isEmpty) return;

    sharedTextNotifier.value = value;
    log('Shared link received while app is running');
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, themeMode, child) {
        return ValueListenableBuilder<String?>(
          valueListenable: sharedTextNotifier,
          builder: (context, sharedText, child) {
            final platform = sharedText == null
                ? PlatformType.unknown
                : PlatformDetector.detect(sharedText);

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              home: sharedText == null
                  ? const SplashScreen()
                  : SharePlatformScreen(
                      sharedLink: sharedText,
                      detectedPlatform: platform,
                    ),
            );
          },
        );
      },
    );
  }
}
