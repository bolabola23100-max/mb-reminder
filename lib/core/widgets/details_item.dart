import 'package:flutter/material.dart';
import 'package:mb_reminder/features/details/widgets/details_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsItem extends StatelessWidget {
  const DetailsItem({super.key, required this.items});

  final List<DetailsModel> items;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  items[index].name.trim().isEmpty
                      ? 'بدون اسم'
                      : items[index].name,
                  style: TextStyle(
                    color: colors.surface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  items[index].description.trim().isEmpty
                      ? 'لا يوجد وصف'
                      : items[index].description,
                  style: TextStyle(color: colors.surface, fontSize: 14),
                  textAlign: TextAlign.right,
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.surface,
                        foregroundColor: colors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () async {
                        final Uri url = Uri.parse(items[index].link);

                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      icon: const Icon(Icons.link, size: 18),
                      label: const Text('Open Link'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
