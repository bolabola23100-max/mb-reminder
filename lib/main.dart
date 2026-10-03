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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('mb_reminder_box');
  await ThemeController.load();
  final sharedText = await shareChannel.invokeMethod<String>('getSharedText');

  PlatformType platform = PlatformType.unknown;

  if (sharedText != null) {
    platform = PlatformDetector.detect(sharedText);

    log('🔗 Shared Link: $sharedText');
    log('📱 Platform: $platform');
  }

  runApp(MainApp(sharedText: sharedText, platform: platform));
}

class MainApp extends StatelessWidget {
  final String? sharedText;
  final PlatformType platform;

  const MainApp({
    super.key,
    this.sharedText,
    this.platform = PlatformType.unknown,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, themeMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,

          home: sharedText != null
              ? SharePlatformScreen(sharedLink: sharedText!)
              : SplashScreen(),
        );
      },
    );
  }
}
