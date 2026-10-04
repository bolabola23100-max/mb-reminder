import 'package:flutter/material.dart';
import 'package:mb_reminder/core/services/ads_service.dart';
import 'package:mb_reminder/core/services/platform_detector.dart';
import 'package:mb_reminder/core/services/reminder_storage.dart';
import 'package:mb_reminder/core/widgets/banner_ad_widget.dart';
import 'package:mb_reminder/core/widgets/details_item.dart';
import 'package:mb_reminder/features/details/widgets/details_model.dart';
import 'package:mb_reminder/features/folders/widgets/folder_model.dart';

class DetailsScreen extends StatefulWidget {
  final PlatformType platform;
  final FolderModel folder;
  final String? sharedLink;

  const DetailsScreen({
    super.key,
    required this.platform,
    required this.folder,
    this.sharedLink,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  List<DetailsModel> items = [];

  final linkController = TextEditingController();
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadItems();

    if (widget.sharedLink != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showItemDialog(initialLink: widget.sharedLink);
      });
    }
  }

  Future<void> _loadItems() async {
    final loaded = await ReminderStorage.loadItems(
      widget.platform,
      widget.folder.id,
    );

    if (!mounted) return;
    setState(() => items = loaded);

    await _saveItems();
  }

  Future<void> _saveItems() {
    return ReminderStorage.saveItems(
      widget.platform,
      widget.folder.id,
      items,
    );
  }

  String? _validateAndNormalizeUrl(String? value) {
    if (value == null || value.trim().isEmpty) return 'اللينك مطلوب';

    var text = value.trim();
    if (!text.contains('://')) {
      text = 'https://$text';
    }

    final uri = Uri.tryParse(text);
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty ||
        uri.host.contains(' ')) {
      return 'ادخل لينك صحيح';
    }

    return null;
  }

  String _normalizeUrl(String value) {
    final text = value.trim();
    return text.contains('://') ? text : 'https://$text';
  }

  Future<void> _showItemDialog({
    DetailsModel? item,
    String? initialLink,
  }) async {
    linkController.text = initialLink ?? item?.link ?? '';
    nameController.text = item?.name ?? '';
    descController.text = item?.description ?? '';

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final colors = Theme.of(dialogContext).colorScheme;

        return AlertDialog(
          title: Text(item == null ? 'إضافة عنصر' : 'تعديل العنصر'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: linkController,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(hintText: 'اللينك'),
                    validator: _validateAndNormalizeUrl,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(hintText: 'الاسم'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الاسم مطلوب';
                      }
                      return null;
                    },
                  ),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(hintText: 'الديسكربشن'),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;

                final updated = DetailsModel(
                  id: item?.id ??
                      DateTime.now().microsecondsSinceEpoch.toString(),
                  link: _normalizeUrl(linkController.text),
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                );

                setState(() {
                  if (item == null) {
                    items.add(updated);
                  } else {
                    final index =
                        items.indexWhere((entry) => entry.id == item.id);
                    if (index != -1) items[index] = updated;
                  }
                });

                await _saveItems();

                if (item == null) {
                  await AdsService.recordLinkAdded();
                }

                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              },
              child: Text(
                item == null ? 'إضافة' : 'حفظ',
                style: TextStyle(color: colors.onPrimary),
              ),
            ),
          ],
        );
      },
    );

    linkController.clear();
    nameController.clear();
    descController.clear();
  }

  Future<void> _deleteItem(DetailsModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف العنصر؟'),
        content: Text('هيتم حذف "${item.name}".'),
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

    setState(() => items.removeWhere((entry) => entry.id == item.id));
    await _saveItems();
  }

  @override
  void dispose() {
    linkController.dispose();
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
        centerTitle: true,
      ),
      body: DetailsItem(
        items: items,
        onEdit: (item) => _showItemDialog(item: item),
        onDelete: _deleteItem,
        onLinkOpened: AdsService.recordLinkOpened,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'items_${widget.folder.id}_fab',
        backgroundColor: colors.primary,
        onPressed: () => _showItemDialog(),
        child: Icon(Icons.add, color: colors.onPrimary),
      ),
      bottomNavigationBar: const SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: BannerAdWidget(),
        ),
      ),
    );
  }
}
