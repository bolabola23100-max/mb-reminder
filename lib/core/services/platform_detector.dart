import 'package:mb_reminder/core/constants/app_icons.dart';

enum PlatformType { tiktok, youtube, instagram, reminder, unknown }

extension PlatformTypeX on PlatformType {
  String get storageKey {
    switch (this) {
      case PlatformType.tiktok:
        return 'tiktok';
      case PlatformType.youtube:
        return 'youtube';
      case PlatformType.instagram:
        return 'instagram';
      case PlatformType.reminder:
        return 'reminder';
      case PlatformType.unknown:
        return 'unknown';
    }
  }

  String get displayName {
    switch (this) {
      case PlatformType.tiktok:
        return 'TikTok';
      case PlatformType.youtube:
        return 'YouTube';
      case PlatformType.instagram:
        return 'Instagram';
      case PlatformType.reminder:
        return 'Reminder';
      case PlatformType.unknown:
        return 'Unknown';
    }
  }

  String get iconPath {
    switch (this) {
      case PlatformType.tiktok:
        return AppIcons.tiktok;
      case PlatformType.youtube:
        return AppIcons.youtube;
      case PlatformType.instagram:
        return AppIcons.instagram;
      case PlatformType.reminder:
        return AppIcons.reminder;
      case PlatformType.unknown:
        return AppIcons.reminder;
    }
  }
}

class PlatformDetector {
  static PlatformType detect(String url) {
    var value = url.trim();
    if (value.isEmpty) return PlatformType.unknown;

    if (!value.contains('://')) {
      value = 'https://$value';
    }

    final uri = Uri.tryParse(value);
    if (uri == null || uri.host.isEmpty) return PlatformType.unknown;

    final host = uri.host.toLowerCase().replaceFirst('www.', '');

    if (host == 'tiktok.com' || host.endsWith('.tiktok.com')) {
      return PlatformType.tiktok;
    }

    if (host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtu.be') {
      return PlatformType.youtube;
    }

    if (host == 'instagram.com' || host.endsWith('.instagram.com')) {
      return PlatformType.instagram;
    }

    return PlatformType.unknown;
  }
}
