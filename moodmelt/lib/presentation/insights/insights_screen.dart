import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/providers/mood_provider.dart';
import '../../domain/providers/practice_provider.dart';

class InsightsScreen extends ConsumerWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodEntries = ref.watch(moodProvider);
    final streak = ref.watch(streakProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elemzés'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Streak card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Jelenlegi sorozat',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$streak',
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 48,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'nap',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Stats cards
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.mood, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Text(
                          '${moodEntries.length}',
                          style: AppTextStyles.h2,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Bejegyzés',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Icon(Icons.self_improvement,
                            color: AppColors.accent),
                        const SizedBox(height: 8),
                        Text(
                          '${ref.read(practiceSessionProvider.notifier).getTotalPracticeCount()}',
                          style: AppTextStyles.h2,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Gyakorlat',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Mood chart placeholder
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hangulatod alakulása',
                    style: AppTextStyles.h3,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Grafikon hamarosan...',
                        style: AppTextStyles.bodySecondary,
                      ),
                    ),
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
