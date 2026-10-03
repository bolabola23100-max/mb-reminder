import 'package:flutter/material.dart';
import 'package:mb_reminder/core/constants/app_icons.dart';
import 'package:mb_reminder/features/home/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
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
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.bookmark_rounded, size: 100),
        ),
      ),
    );
  }
}
