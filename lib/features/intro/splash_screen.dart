import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mb_reminder/core/constants/app_icons.dart';
import 'package:mb_reminder/features/home/screens/home_screen.dart';
import 'package:mb_reminder/features/intro/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 900), () async {
      if (!mounted) return;

      final completed = Hive.box('mb_reminder_box').get(
        'onboarding_completed',
        defaultValue: false,
      ) as bool;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => completed
              ? const HomeScreen()
              : const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppIcons.mb,
          height: 250,
          width: 250,
          errorBuilder: (_, _, _) =>
              const Icon(Icons.bookmark_rounded, size: 100),
        ),
      ),
    );
  }
}
