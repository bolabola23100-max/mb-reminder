import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:mb_reminder/features/home/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingData(
      image: 'assets/image/WhatsApp Image 2026-10-05 at 6.34.58 PM.jpeg',
      title: 'رتّب روابطك بسهولة',
      description:
          'اعمل مجلدات مخصوصة لروابطك وخلي كل حاجة مرتبة قدامك بدل ما تدور عليها كل مرة.',
    ),
    _OnboardingData(
      image: 'assets/image/WhatsApp Image 2026-10-05 at 6.35.04 PM.jpeg',
      title: 'احفظ أي رابط بسرعة',
      description:
          'احفظ روابط TikTok وYouTube وInstagram، وكمان ابعت أي رابط للتطبيق مباشرة من زر المشاركة.',
    ),
    _OnboardingData(
      image: 'assets/image/WhatsApp Image 2026-10-05 at 6.35.05 PM.jpeg',
      title: 'كل روابطك في مكان واحد',
      description:
          'افتح روابطك وعدّلها أو احذفها بسهولة، وخلّي كل الحاجات المهمة معاك وقت ما تحتاجها.',
    ),
  ];

  Future<void> _finish() async {
    await Hive.box('mb_reminder_box').put('onboarding_completed', true);
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  void _next() {
    if (_currentPage == _pages.length - 1) {
      _finish();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    'تخطي',
                    style: TextStyle(
                      color: colors.onSurface.withValues(alpha: .65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Container(
                              constraints: const BoxConstraints(
                                maxWidth: 330,
                                maxHeight: 430,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors.shadow.withValues(alpha: .12),
                                    blurRadius: 28,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                page.image,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => Container(
                                  color: colors.surfaceContainerHighest,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 64,
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 26),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                height: 1.55,
                                color: colors.onSurface.withValues(alpha: .68),
                              ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 7,
                    width: index == _currentPage ? 28 : 7,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: index == _currentPage
                          ? colors.primary
                          : colors.onSurface.withValues(alpha: .18),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'ابدأ الآن' : 'التالي',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String image;
  final String title;
  final String description;

  const _OnboardingData({
    required this.image,
    required this.title,
    required this.description,
  });
}
