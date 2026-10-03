import 'package:flutter/material.dart';
import 'package:mb_reminder/core/services/platform_detector.dart';
import 'package:mb_reminder/features/folders/screens/platform_folders_screen.dart';

class InstagramScreen extends StatelessWidget {
  final String? sharedLink;

  const InstagramScreen({super.key, this.sharedLink});

  @override
  Widget build(BuildContext context) {
    return PlatformFoldersScreen(
      platform: PlatformType.instagram,
      sharedLink: sharedLink,
    );
  }
}
