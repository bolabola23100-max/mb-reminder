import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mb_reminder/core/constants/app_colors.dart';

class PlatformCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const PlatformCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SvgPicture.asset(
          icon,
          width: 40,
          height: 40,
          colorFilter: const ColorFilter.mode(AppColors.black, BlendMode.srcIn),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
