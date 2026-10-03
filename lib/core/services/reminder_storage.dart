import 'package:hive_flutter/hive_flutter.dart';
import 'package:mb_reminder/core/services/platform_detector.dart';
import 'package:mb_reminder/features/details/widgets/details_model.dart';
import 'package:mb_reminder/features/folders/widgets/folder_model.dart';

class ReminderStorage {
  static const String boxName = 'mb_reminder_box';

  static Box get box => Hive.box(boxName);

  static String foldersKey(PlatformType platform) =>
      '${platform.storageKey}_folders';

  static String itemsKey(PlatformType platform, String folderId) =>
      'folder_${platform.storageKey}_$folderId';

  static Future<List<FolderModel>> loadFolders(PlatformType platform) async {
    final key = foldersKey(platform);
    final raw = box.get(key);

    if (raw is List && raw.isNotEmpty && raw.first is String) {
      final legacyNames = raw.whereType<String>().toList();
      final migrated = <FolderModel>[];

      for (var index = 0; index < legacyNames.length; index++) {
        final name = legacyNames[index].trim();
        if (name.isEmpty) continue;

        final id = 'migrated_${DateTime.now().microsecondsSinceEpoch}_$index';
        final folder = FolderModel(id: id, name: name);
        migrated.add(folder);

        final legacyItems = box.get('folder_$name');
        if (legacyItems != null) {
          await box.put(itemsKey(platform, id), legacyItems);
        }
      }

      await saveFolders(platform, migrated);
      return migrated;
    }

    if (raw is! List) return [];

    return raw
        .whereType<Map>()
        .map(FolderModel.fromMap)
        .where((folder) => folder.id.isNotEmpty && folder.name.trim().isNotEmpty)
        .toList();
  }

  static Future<void> saveFolders(
    PlatformType platform,
    List<FolderModel> folders,
  ) {
    return box.put(
      foldersKey(platform),
      folders.map((folder) => folder.toMap()).toList(),
    );
  }

  static Future<List<DetailsModel>> loadItems(
    PlatformType platform,
    String folderId,
  ) async {
    final raw = box.get(itemsKey(platform, folderId));
    if (raw is! List) return [];

    return List.generate(raw.length, (index) {
      final value = raw[index];
      if (value is Map) {
        return DetailsModel.fromMap(
          Map<dynamic, dynamic>.from(value),
          fallbackId: 'legacy_${DateTime.now().microsecondsSinceEpoch}_$index',
        );
      }

      return DetailsModel(
        id: 'invalid_${DateTime.now().microsecondsSinceEpoch}_$index',
        name: '',
        link: '',
        description: '',
      );
    });
  }

  static Future<void> saveItems(
    PlatformType platform,
    String folderId,
    List<DetailsModel> items,
  ) {
    return box.put(
      itemsKey(platform, folderId),
      items.map((item) => item.toMap()).toList(),
    );
  }

  static Future<void> deleteFolder(
    PlatformType platform,
    String folderId,
  ) async {
    await box.delete(itemsKey(platform, folderId));
    final folders = await loadFolders(platform);
    folders.removeWhere((folder) => folder.id == folderId);
    await saveFolders(platform, folders);
  }
}
