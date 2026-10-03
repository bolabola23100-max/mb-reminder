import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PlatformCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const PlatformCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      child: ListTile(
        leading: SvgPicture.asset(
          icon,
          width: 40,
          height: 40,
          colorFilter: ColorFilter.mode(
            colors.onSurface,
            BlendMode.srcIn,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: colors.onSurface,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }
}
