import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mb_reminder/core/widgets/details_item.dart';
import 'package:mb_reminder/features/details/widgets/details_model.dart';

class DetailsScreen extends StatefulWidget {
  final String item;
  final String? sharedLink;

  const DetailsScreen({super.key, required this.item, this.sharedLink});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final Box box = Hive.box('mb_reminder_box');

  List<DetailsModel> items = [];

  final TextEditingController linkController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _loadItems();

    if (widget.sharedLink != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAddDialog();

        linkController.text = widget.sharedLink!;
      });
    }
  }

  void _loadItems() {
    final List? rawItems = box.get('folder_${widget.item}');

    if (rawItems != null) {
      setState(() {
        items = rawItems
            .map(
              (e) => DetailsModel(
                name: e['name'] ?? '',
                link: e['link'] ?? '',
                description: e['description'] ?? '',
              ),
            )
            .toList();
      });
    }
  }

  void _saveItems() {
    final listToSave = items
        .map(
          (e) => {'name': e.name, 'link': e.link, 'description': e.description},
        )
        .toList();

    box.put('folder_${widget.item}', listToSave);
  }

  void showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final colors = Theme.of(context).colorScheme;

        return AlertDialog(
          title: const Text('إضافة عنصر'),

          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: linkController,
                  decoration: const InputDecoration(hintText: 'اللينك'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'اللينك مطلوب';
                    }

                    String urlText = value.trim();

                    if (!urlText.startsWith('http://') &&
                        !urlText.startsWith('https://')) {
                      urlText = 'https://$urlText';
                    }

                    final uri = Uri.tryParse(urlText);

                    if (uri == null ||
                        !uri.hasAbsolutePath ||
                        !uri.host.contains('.')) {
                      return 'ادخل لينك صحيح';
                    }

                    return null;
                  },
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
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                String finalLink = linkController.text.trim();

                if (!finalLink.startsWith('http://') &&
                    !finalLink.startsWith('https://')) {
                  finalLink = 'https://$finalLink';
                }

                setState(() {
                  items.add(
                    DetailsModel(
                      link: finalLink,
                      name: nameController.text.trim(),
                      description: descController.text.trim(),
                    ),
                  );
                });

                _saveItems();

                nameController.clear();
                descController.clear();
                linkController.clear();

                Navigator.pop(context);
              },
              child: Text('إضافة', style: TextStyle(color: colors.primary)),
            ),
          ],
        );
      },
    );
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
        leading: const BackButton(),
        title: Center(child: Text(widget.item)),
      ),

      body: DetailsItem(items: items),

      floatingActionButton: FloatingActionButton(
        heroTag: 'item_fab',

        backgroundColor: colors.primary,

        onPressed: showAddDialog,

        child: Icon(Icons.add, color: colors.surface),
      ),
    );
  }
}
