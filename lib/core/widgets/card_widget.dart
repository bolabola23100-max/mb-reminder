import 'package:flutter/material.dart';
import 'package:mb_reminder/core/constants/app_icons.dart';

class CardWidget extends StatelessWidget {
  final String icons;
  final Function(int) onTap;
  final List<String> items;

  const CardWidget({
    super.key,
    required this.icons,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: 30,
        mainAxisSpacing: 10,
        mainAxisExtent: 120,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onTap(index),

          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: colors.secondary.withValues(alpha: .8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: colors.primary,
                    ),
                    height: 30,
                    width: 30,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SvgOrImg(
                        path: icons,
                        size: 15,
                        color: colors.surface,
                      ).widgetType(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      items[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: colors.surface),
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
