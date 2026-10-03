import 'package:flutter/material.dart';
import 'package:mb_reminder/core/services/platform_detector.dart';
import 'package:mb_reminder/core/services/reminder_storage.dart';
import 'package:mb_reminder/core/widgets/card_widget.dart';
import 'package:mb_reminder/features/details/screens/details_screen.dart';
import 'package:mb_reminder/features/folders/widgets/folder_model.dart';

class PlatformFoldersScreen extends StatefulWidget {
  final PlatformType platform;
  final String? sharedLink;

  const PlatformFoldersScreen({
    super.key,
    required this.platform,
    this.sharedLink,
  });

  @override
  State<PlatformFoldersScreen> createState() => _PlatformFoldersScreenState();
}

class _PlatformFoldersScreenState extends State<PlatformFoldersScreen> {
  List<FolderModel> folders = [];
  final controller = TextEditingController();
  String? pendingSharedLink;

  String get title => widget.platform.displayName;
  String get icon => widget.platform.iconPath;

  @override
  void initState() {
    super.initState();
    pendingSharedLink = widget.sharedLink;
    _loadFolders();
  }

  Future<void> _loadFolders() async {
    final loaded = await ReminderStorage.loadFolders(widget.platform);
    if (!mounted) return;
    setState(() => folders = loaded);
  }

  Future<void> _save() => ReminderStorage.saveFolders(widget.platform, folders);

  Future<void> _addFolder() async {
    controller.clear();

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('اسم الملف'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(hintText: 'اكتب الاسم هنا'),
          onSubmitted: (_) => Navigator.pop(dialogContext, controller.text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );

    if (!mounted || name == null) return;
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    final duplicate = folders.any(
      (folder) => folder.name.toLowerCase() == cleanName.toLowerCase(),
    );
    if (duplicate) {
      _showMessage('الاسم موجود بالفعل');
      return;
    }

    final folder = FolderModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: cleanName,
    );

    setState(() => folders.add(folder));
    await _save();
  }

  Future<void> _renameFolder(FolderModel folder) async {
    controller.text = folder.name;

    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تعديل اسم الملف'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'اسم الملف'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (!mounted || name == null) return;
    final cleanName = name.trim();
    if (cleanName.isEmpty) return;

    final duplicate = folders.any(
      (item) => item.id != folder.id &&
          item.name.toLowerCase() == cleanName.toLowerCase(),
    );
    if (duplicate) {
      _showMessage('الاسم موجود بالفعل');
      return;
    }

    setState(() {
      final index = folders.indexWhere((item) => item.id == folder.id);
      if (index != -1) {
        folders[index] = FolderModel(id: folder.id, name: cleanName);
      }
    });
    await _save();
  }

  Future<void> _deleteFolder(FolderModel folder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف الملف؟'),
        content: Text('هيتم حذف "' + folder.name + '" وكل اللينكات اللي جواه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;

    await ReminderStorage.deleteFolder(widget.platform, folder.id);
    if (!mounted) return;
    setState(() => folders.removeWhere((item) => item.id == folder.id));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _openFolder(FolderModel folder) {
    final link = pendingSharedLink;
    pendingSharedLink = null;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetailsScreen(
          platform: widget.platform,
          folder: folder,
          sharedLink: link,
        ),
      ),
    );
  }

  Future<void> _showFolderMenu(FolderModel folder) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('تعديل الاسم'),
              onTap: () => Navigator.pop(context, 'rename'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('حذف الملف'),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );

    if (!mounted) return;
    if (action == 'rename') await _renameFolder(folder);
    if (action == 'delete') await _deleteFolder(folder);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(title), centerTitle: true),
      body: folders.isEmpty
          ? Center(
              child: Text(
                'مفيش ملفات لسه\nاضغط + واعمل أول ملف',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colors.onSurface.withValues(alpha: .65),
                  fontSize: 16,
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: CardWidget(
                icons: icon,
                items: folders,
                onTap: (index) => _openFolder(folders[index]),
                onLongPress: (index) => _showFolderMenu(folders[index]),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'folder_' + widget.platform.storageKey + '_fab',
        backgroundColor: colors.primary,
        onPressed: _addFolder,
        child: Icon(Icons.add, color: colors.onPrimary),
      ),
    );
  }
}
