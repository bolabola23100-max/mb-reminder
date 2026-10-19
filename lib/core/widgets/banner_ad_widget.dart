import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mb_reminder/core/services/ads_service.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (!AdsService.adsEnabled ||
        defaultTargetPlatform != TargetPlatform.android) {
      return const SizedBox.shrink();
    }

    // Do not create the native banner before Unity Ads has initialized.
    // The notifier rebuilds this widget as soon as initialization succeeds.
    return ValueListenableBuilder<bool>(
      valueListenable: AdsService.initializationNotifier,
      builder: (context, initialized, child) {
        if (!initialized) return const SizedBox.shrink();

        return UnityBannerAd(
          placementId: AdsService.bannerAdUnitId,
          onLoad: (placementId) {
            debugPrint('Unity banner loaded: $placementId');
          },
          onClick: (placementId) {
            debugPrint('Unity banner clicked: $placementId');
          },
          onShown: (placementId) {
            debugPrint('Unity banner shown: $placementId');
          },
          onFailed: (placementId, error, message) {
            debugPrint('Unity banner failed: $error - $message');
          },
        );
      },
    );
  }
}
