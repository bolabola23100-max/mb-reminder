import 'package:flutter/material.dart';
import 'package:mb_reminder/core/constants/app_icons.dart';
import 'package:mb_reminder/features/instagram/screens/instagram_screen.dart';
import 'package:mb_reminder/features/share/widgets/platform_card.dart';
import 'package:mb_reminder/features/tiktok/screens/tiktok_screen.dart';
import 'package:mb_reminder/features/youtube/screens/youtube_screen.dart';

class SharePlatformScreen extends StatelessWidget {
  final String sharedLink;

  const SharePlatformScreen({super.key, required this.sharedLink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('اختار المنصة'))),
      body: SingleChildScrollView(
        child: Padding(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TiktokScreen(sharedLink: sharedLink),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              PlatformCard(
                title: 'YouTube',
                icon: AppIcons.youtube,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          YoutubeScreen(sharedLink: sharedLink),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              PlatformCard(
                title: 'Instagram',
                icon: AppIcons.instagram,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InstagramScreen(sharedLink: sharedLink),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
