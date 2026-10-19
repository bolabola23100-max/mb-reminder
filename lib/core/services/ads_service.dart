import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class AdsService {
  static const bool adsEnabled = true;

  // Production Android configuration. Ads still depend on Unity dashboard approval/fill.
  static const String _androidGameId = '6208907';
  static const String bannerAdUnitId = 'Banner_Android';
  static const String interstitialAdUnitId = 'Interstitial_Android';

  static const String _folderAddsKey = 'ads_folder_adds';
  static const String _linkAddsKey = 'ads_link_adds';
  static const String _linkOpensKey = 'ads_link_opens';
  static const String _lastInterstitialKey = 'ads_last_interstitial';
  static const int _triggerEvery = 4;
  static const Duration _cooldown = Duration(minutes: 3);

  static bool _initialized = false;
  static bool _initializationStarted = false;
  static bool _loadingInterstitial = false;
  static bool _interstitialLoaded = false;
  static bool _showingInterstitial = false;
  static String? _pendingTriggerKey;

  static Future<void> initialize() async {
    if (!adsEnabled ||
        defaultTargetPlatform != TargetPlatform.android ||
        _initializationStarted) {
      return;
    }

    _initializationStarted = true;
    UnityAds.init(
      gameId: _androidGameId,
      testMode: false,
      onComplete: () {
        _initialized = true;
        debugPrint('Unity Ads initialized for Android (production mode).');
        _loadInterstitial();
      },
      onFailed: (error, message) {
        _initialized = false;
        _initializationStarted = false;
        debugPrint('Unity Ads initialization failed: $error - $message');
      },
    );
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
    if (!adsEnabled ||
        defaultTargetPlatform != TargetPlatform.android ||
        !_initialized) {
      return;
    }

    final count = (_box.get(key, defaultValue: 0) as int) + 1;
    await _box.put(key, count);
    await _tryShowFor(key, count);
  }

  static Future<void> _tryShowFor(String key, int count) async {
    if (!_initialized ||
        !_interstitialLoaded ||
        _showingInterstitial ||
        count < _triggerEvery) {
      if (_initialized && !_interstitialLoaded) {
        _loadInterstitial();
      }
      return;
    }

    final lastShown = _box.get(_lastInterstitialKey);
    if (lastShown is int) {
      final elapsed = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(lastShown),
      );
      if (elapsed < _cooldown) return;
    }

    _showingInterstitial = true;
    _interstitialLoaded = false;
    _pendingTriggerKey = key;

    UnityAds.showVideoAd(
      placementId: interstitialAdUnitId,
      onStart: (placementId) async {
        await _box.put(
          _lastInterstitialKey,
          DateTime.now().millisecondsSinceEpoch,
        );
        final triggerKey = _pendingTriggerKey;
        if (triggerKey != null) {
          await _box.put(triggerKey, 0);
        }
      },
      onClick: (placementId) {
        debugPrint('Unity interstitial clicked: $placementId');
      },
      onComplete: (placementId) {
        _finishInterstitial();
      },
      onSkipped: (placementId) {
        _finishInterstitial();
      },
      onFailed: (placementId, error, message) {
        debugPrint('Unity interstitial failed: $error - $message');
        _finishInterstitial();
      },
    );
  }

  static void _finishInterstitial() {
    _showingInterstitial = false;
    _pendingTriggerKey = null;
    _loadInterstitial();
  }

  static void _loadInterstitial() {
    if (!_initialized || _loadingInterstitial || _interstitialLoaded) return;

    _loadingInterstitial = true;
    UnityAds.load(
      placementId: interstitialAdUnitId,
      onComplete: (placementId) {
        _loadingInterstitial = false;
        _interstitialLoaded = true;
        debugPrint('Unity interstitial loaded: $placementId');
      },
      onFailed: (placementId, error, message) {
        _loadingInterstitial = false;
        _interstitialLoaded = false;
        debugPrint('Unity interstitial load failed: $error - $message');
      },
    );
  }

  static void dispose() {
    // UnityAds is managed by its SDK; do not dispose the global SDK here.
    _interstitialLoaded = false;
    _loadingInterstitial = false;
    _showingInterstitial = false;
    _pendingTriggerKey = null;
  }
}
