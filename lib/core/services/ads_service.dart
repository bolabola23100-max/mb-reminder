import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AdsService {
  static const String _folderAddsKey = 'ads_folder_adds';
  static const String _linkAddsKey = 'ads_link_adds';
  static const String _linkOpensKey = 'ads_link_opens';
  static const String _lastInterstitialKey = 'ads_last_interstitial';
  static const int _triggerEvery = 4;
  static const Duration _cooldown = Duration(minutes: 3);

  static InterstitialAd? _interstitialAd;
  static bool _initialized = false;
  static bool _loadingInterstitial = false;

  static Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await MobileAds.instance.initialize();
    _loadInterstitial();
  }

  static Box get _box => Hive.box('mb_reminder_box');

  static Future<void> recordFolderAdded() async {
    await _record(_folderAddsKey);
  }

  static Future<void> recordLinkAdded() async {
    await _record(_linkAddsKey);
  }

  static Future<void> recordLinkOpened() async {
    await _record(_linkOpensKey);
  }

  static Future<void> _record(String key) async {
    final count = (_box.get(key, defaultValue: 0) as int) + 1;
    await _box.put(key, count);
    await _tryShowFor(key, count);
  }

  static Future<void> _tryShowFor(String key, int count) async {
    if (count < _triggerEvery) return;

    final lastShown = _box.get(_lastInterstitialKey);
    if (lastShown is int) {
      final elapsed = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(lastShown),
      );
      if (elapsed < _cooldown) return;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      _loadInterstitial();
      return;
    }

    _interstitialAd = null;
    var shown = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) async {
        shown = true;
        await _box.put(
          _lastInterstitialKey,
          DateTime.now().millisecondsSinceEpoch,
        );
        await _box.put(key, 0);
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial failed to show: $error');
        ad.dispose();
        if (!shown) {
          _loadInterstitial();
        }
      },
    );

    try {
      await ad.show();
    } catch (error) {
      debugPrint('Interstitial show error: $error');
      ad.dispose();
      _loadInterstitial();
    }
  }

  static void _loadInterstitial() {
    if (_loadingInterstitial || _interstitialAd != null) return;
    _loadingInterstitial = true;

    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingInterstitial = false;
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _loadingInterstitial = false;
          debugPrint('Interstitial failed to load: $error');
        },
      ),
    );
  }

  static void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _loadingInterstitial = false;
  }
}

class AdConfig {
  // Google test IDs are used until the app has its own AdMob ad units.
  // Replace these IDs with the real MB Reminder IDs before production.
  static const String bannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  static const String interstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
}
