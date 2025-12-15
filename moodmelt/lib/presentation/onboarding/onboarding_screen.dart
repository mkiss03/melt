import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/providers/settings_provider.dart';
import '../../domain/services/notification_service.dart';
import '../../domain/services/health_service.dart';
import '../../domain/providers/health_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                  _buildPage4(),
                  _buildPage5(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Melt character placeholder (replace with Rive animation)
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              gradient: AppColors.meltGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '💧',
                style: TextStyle(fontSize: 80),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Szia! Melt vagyok 👋',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Az érzelmi társad, aki figyel rád és segít, amikor szükséges.',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_rounded,
            size: 120,
            color: AppColors.primary,
          ),
          const SizedBox(height: 40),
          const Text(
            'Nem vagyok tracker',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Figyelek, és segítek, amikor érzem, hogy kell. Nem csak számokat mutatok.',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.self_improvement_rounded,
            size: 120,
            color: AppColors.accent,
          ),
          const SizedBox(height: 40),
          const Text(
            'Micro-terápia, amikor kell',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            '30-60 másodperces gyakorlatok, amik azonnal segítenek. Nincs időigényes program.',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage4() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_active_rounded,
            size: 120,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 40),
          const Text(
            'Engedélyek',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Szükségem lesz értesítésekre, hogy időben segíthessek. Egészségügyi adatok (opcionális) még jobbá teszik az élményt.',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _requestNotificationPermission,
            icon: const Icon(Icons.notifications),
            label: const Text('Értesítések engedélyezése'),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _requestHealthPermission,
            icon: const Icon(Icons.favorite_border),
            label: const Text('Egészségügyi adatok (később is)'),
          ),
        ],
      ),
    );
  }

  Widget _buildPage5() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              gradient: AppColors.meltGradient,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '✨',
                style: TextStyle(fontSize: 80),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Készen állsz?',
            style: AppTextStyles.h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Kezdjük egy gyors hangulatfelméréssel, aztán indulhat a közös út!',
            style: AppTextStyles.bodySecondary,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _completeOnboarding,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            ),
            child: const Text('Kezdjük!'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            TextButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Vissza'),
            )
          else
            const SizedBox(width: 80),
          // Page indicators
          Row(
            children: List.generate(
              5,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.primary
                      : AppColors.textHint,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          if (_currentPage < 4)
            TextButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Tovább'),
            )
          else
            const SizedBox(width: 80),
        ],
      ),
    );
  }

  void _requestNotificationPermission() async {
    final notificationService = NotificationService();
    await notificationService.requestPermissions();
  }

  void _requestHealthPermission() async {
    final healthService = ref.read(healthServiceProvider);
    await healthService.requestPermissions();
  }

  void _completeOnboarding() async {
    await ref.read(preferencesProvider.notifier).completeOnboarding();
    if (mounted) {
      context.go('/home');
    }
  }
}
