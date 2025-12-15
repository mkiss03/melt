import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/practice/practice_library_screen.dart';
import '../../presentation/practice/practice_detail_screen.dart';
import '../../presentation/practice/active_practice_screen.dart';
import '../../presentation/insights/insights_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/settings/health_settings_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Check if onboarding is completed
  // final onboardingCompleted = ref.watch(preferencesProvider.select(
  //   (prefs) => prefs.onboardingCompleted,
  // ));

  return GoRouter(
    initialLocation: '/onboarding', // Change to '/home' after onboarding
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/practices',
        name: 'practices',
        builder: (context, state) => const PracticeLibraryScreen(),
      ),
      GoRoute(
        path: '/practice/:id',
        name: 'practice-detail',
        builder: (context, state) {
          final practiceId = state.pathParameters['id']!;
          return PracticeDetailScreen(practiceId: practiceId);
        },
      ),
      GoRoute(
        path: '/practice/:id/active',
        name: 'active-practice',
        builder: (context, state) {
          final practiceId = state.pathParameters['id']!;
          return ActivePracticeScreen(practiceId: practiceId);
        },
      ),
      GoRoute(
        path: '/insights',
        name: 'insights',
        builder: (context, state) => const InsightsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/health',
        name: 'health-settings',
        builder: (context, state) => const HealthSettingsScreen(),
      ),
    ],
  );
});
