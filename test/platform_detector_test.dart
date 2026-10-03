import 'package:flutter_test/flutter_test.dart';
import 'package:mb_reminder/core/services/platform_detector.dart';

void main() {
  group('PlatformDetector', () {
    test('detects YouTube domains', () {
      expect(
        PlatformDetector.detect('https://www.youtube.com/watch?v=123'),
        PlatformType.youtube,
      );
      expect(
        PlatformDetector.detect('youtu.be/123'),
        PlatformType.youtube,
      );
    });

    test('detects Instagram and TikTok domains', () {
      expect(
        PlatformDetector.detect('https://www.instagram.com/reel/123'),
        PlatformType.instagram,
      );
      expect(
        PlatformDetector.detect('https://www.tiktok.com/@user/video/123'),
        PlatformType.tiktok,
      );
    });

    test('rejects unknown domains', () {
      expect(
        PlatformDetector.detect('https://example.com/video'),
        PlatformType.unknown,
      );
      expect(PlatformDetector.detect('not a url'), PlatformType.unknown);
    });
  });
}
