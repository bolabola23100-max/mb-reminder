import 'package:flutter/material.dart';
import 'package:mb_reminder/features/details/widgets/details_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsItem extends StatelessWidget {
  const DetailsItem({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final List<DetailsModel> items;
  final ValueChanged<DetailsModel> onEdit;
  final ValueChanged<DetailsModel> onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (items.isEmpty) {
      return Center(
        child: Text(
          'مفيش لينكات لسه\nاضغط + لإضافة أول لينك',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: colors.onSurface.withValues(alpha: .65),
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 100),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Card(
            color: colors.primary.withValues(alpha: 0.7),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') onEdit(item);
                          if (value == 'delete') onDelete(item);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('تعديل'),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Text('حذف'),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          item.name.trim().isEmpty ? 'بدون اسم' : item.name,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: colors.surface,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description.trim().isEmpty
                        ? 'لا يوجد وصف'
                        : item.description,
                    style: TextStyle(color: colors.surface, fontSize: 14),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.surface,
                        foregroundColor: colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        final url = Uri.tryParse(item.link);
                        if (url == null || !await canLaunchUrl(url)) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('مش قادر أفتح اللينك')),
                          );
                          return;
                        }

                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: const Icon(Icons.link, size: 18),
                      label: const Text('فتح اللينك'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
