import 'package:flutter/material.dart';
import 'package:mb_reminder/core/constants/app_icons.dart';
import 'package:mb_reminder/core/services/platform_detector.dart';
import 'package:mb_reminder/features/folders/screens/platform_folders_screen.dart';
import 'package:mb_reminder/features/share/widgets/platform_card.dart';

class SharePlatformScreen extends StatefulWidget {
  final String sharedLink;
  final PlatformType detectedPlatform;

  const SharePlatformScreen({
    super.key,
    required this.sharedLink,
    this.detectedPlatform = PlatformType.unknown,
  });

  @override
  State<SharePlatformScreen> createState() => _SharePlatformScreenState();
}

class _SharePlatformScreenState extends State<SharePlatformScreen> {
  @override
  void initState() {
    super.initState();

    if (widget.detectedPlatform != PlatformType.unknown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _openPlatform(widget.detectedPlatform, replace: true);
      });
    }
  }

  void _openPlatform(PlatformType platform, {bool replace = false}) {
    final page = PlatformFoldersScreen(
      platform: platform,
      sharedLink: widget.sharedLink,
    );

    final route = MaterialPageRoute(builder: (_) => page);
    if (replace) {
      Navigator.pushReplacement(context, route);
    } else {
      Navigator.push(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اختار المنصة'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'عاوز تحفظ اللينك فين؟',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            PlatformCard(
              title: 'TikTok',
              icon: AppIcons.tiktok,
              onTap: () => _openPlatform(PlatformType.tiktok),
            ),
            const SizedBox(height: 12),
            PlatformCard(
              title: 'YouTube',
              icon: AppIcons.youtube,
              onTap: () => _openPlatform(PlatformType.youtube),
            ),
            const SizedBox(height: 12),
            PlatformCard(
              title: 'Instagram',
              icon: AppIcons.instagram,
              onTap: () => _openPlatform(PlatformType.instagram),
            ),
          ],
        ),
      ),
    );
  }
}
