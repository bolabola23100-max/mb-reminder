import 'package:flutter/material.dart';
import 'package:mb_reminder/core/constants/app_icons.dart';
import 'package:mb_reminder/core/theme/theme_controller.dart';
import 'package:mb_reminder/features/instagram/screens/instagram_screen.dart';
import 'package:mb_reminder/features/reminder/screens/reminder_screen.dart';
import 'package:mb_reminder/features/tiktok/screens/tiktok_screen.dart';
import 'package:mb_reminder/features/youtube/screens/youtube_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> screens = [
    YoutubeScreen(),
    InstagramScreen(),
    TiktokScreen(),
    ReminderScreen(),
  ];

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required String icon,
  }) {
    final colors = Theme.of(context).colorScheme;

    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: SvgOrImg(
            path: icon,
            size: 22,
            color: isSelected
                ? colors.surface
                : colors.surface.withValues(alpha: 0.6),
          ).widgetType(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MB Reminder'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ThemeController.toggle();
            },
            icon: ValueListenableBuilder<ThemeMode>(
              valueListenable: ThemeController.themeMode,
              builder: (context, mode, child) {
                return Icon(
                  mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                );
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: IndexedStack(index: selectedIndex, children: screens),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: colors.secondary,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    context: context,
                    index: 0,
                    icon: AppIcons.youtube,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 1,
                    icon: AppIcons.instagram,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 2,
                    icon: AppIcons.tiktok,
                  ),
                  _buildNavItem(
                    context: context,
                    index: 3,
                    icon: AppIcons.reminder,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
