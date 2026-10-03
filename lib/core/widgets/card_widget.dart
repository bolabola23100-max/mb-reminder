import 'package:flutter/material.dart';
import 'package:mb_reminder/core/constants/app_icons.dart';
import 'package:mb_reminder/features/folders/widgets/folder_model.dart';

class CardWidget extends StatelessWidget {
  final String icons;
  final ValueChanged<int> onTap;
  final ValueChanged<int>? onLongPress;
  final List<FolderModel> items;

  const CardWidget({
    super.key,
    required this.icons,
    required this.onTap,
    required this.items,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisExtent: 125,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final folder = items[index];

        return GestureDetector(
          onTap: () => onTap(index),
          onLongPress: onLongPress == null ? null : () => onLongPress!(index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: colors.secondary.withValues(alpha: .8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: colors.primary,
                  ),
                  height: 32,
                  width: 32,
                  padding: const EdgeInsets.all(6),
                  child: SvgOrImg(
                    path: icons,
                    size: 18,
                    color: colors.surface,
                  ).widgetType(),
                ),
                const SizedBox(height: 10),
                Text(
                  folder.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: colors.surface),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
