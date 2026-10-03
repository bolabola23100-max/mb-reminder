import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mb_reminder/core/constants/app_colors.dart';

class AppIcons {
  static const String instagram = 'assets/svg/instagram.svg';
  static const String youtube = 'assets/svg/youtube.svg';
  static const String tiktok = 'assets/svg/tiktok.svg';
  static const String reminder = 'assets/svg/reminder.svg';
  static const String m = 'assets/image/m.png';
  static const String black = 'assets/image/b.jpeg';
  static const String mb = 'assets/image/mb.png';
}

class SvgOrImg {
  final String path;
  final double size;
  final Color color;

  SvgOrImg({
    required this.path,
    required this.size,
    this.color = AppColors.black,
  });

  Widget widgetType() {
    if (path.contains(".svg")) {
      return SvgPicture.asset(
        path,
        height: size,
        width: size,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else if (path.contains(".jpeg") || path.contains(".png")) {
      return Image.asset(path, height: size, width: size);
    } else {
      return const SizedBox.shrink();
    }
  }
}
