import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'widgets/mood_check_in_card.dart';
import 'widgets/quick_practice_button.dart';
import 'widgets/streak_counter.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MoodMelt',
          style: AppTextStyles.h2.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              _getGreeting(),
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 8),
            const Text(
              'Hogy érzed magad ma?',
              style: AppTextStyles.bodySecondary,
            ),
            const SizedBox(height: 24),
            // Mood Check-in Card
            const MoodCheckInCard(),
            const SizedBox(height: 20),
            // Streak Counter
            const StreakCounter(),
            const SizedBox(height: 20),
            // Quick Practice Button
            const QuickPracticeButton(),
            const SizedBox(height: 32),
            // Section: Today's Practices
            const Text(
              'Mai gyakorlataid',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 12),
            // Practice cards (placeholder)
            _buildPracticePreview(
              context,
              'box_breathing',
              'Box Breathing',
              '1 perc',
              Icons.air_rounded,
            ),
            const SizedBox(height: 12),
            _buildPracticePreview(
              context,
              'five_senses',
              '5-4-3-2-1 Grounding',
              '2 perc',
              Icons.self_improvement_rounded,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              context.push('/practices');
              break;
            case 2:
              context.push('/insights');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Otthon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement),
            label: 'Gyakorlatok',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Elemzés',
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Jó reggelt! ☀️';
    if (hour < 18) return 'Szép napot! 👋';
    return 'Jó estét! 🌙';
  }

  Widget _buildPracticePreview(
    BuildContext context,
    String practiceId,
    String name,
    String duration,
    IconData icon,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(name, style: AppTextStyles.body),
        subtitle: Text(duration, style: AppTextStyles.caption),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_outline),
          onPressed: () {
            context.push('/practice/$practiceId/active');
          },
        ),
      ),
    );
  }
}
