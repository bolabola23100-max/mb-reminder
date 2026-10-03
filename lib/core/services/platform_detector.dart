enum PlatformType { tiktok, youtube, instagram, unknown }

class PlatformDetector {
  static PlatformType detect(String url) {
    final uri = Uri.tryParse(url);

    if (uri == null) {
      return PlatformType.unknown;
    }

    final host = uri.host.toLowerCase();

    if (host.contains('tiktok.com')) {
      return PlatformType.tiktok;
    }

    if (host.contains('youtube.com') || host.contains('youtu.be')) {
      return PlatformType.youtube;
    }

    if (host.contains('instagram.com')) {
      return PlatformType.instagram;
    }

    return PlatformType.unknown;
  }
}
