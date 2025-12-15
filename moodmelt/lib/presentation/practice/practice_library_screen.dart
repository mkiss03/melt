import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/providers/practice_provider.dart';
import '../../data/models/practice_session.dart';

class PracticeLibraryScreen extends ConsumerWidget {
  const PracticeLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final freePractices = ref.watch(freePracticesProvider);
    final premiumPractices = ref.watch(premiumPracticesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gyakorlatok'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Ingyenes gyakorlatok',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 16),
          ...freePractices
              .map((practice) => _buildPracticeCard(context, practice)),
          const SizedBox(height: 32),
          const Text(
            'Prémium gyakorlatok',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 16),
          ...premiumPractices
              .map((practice) => _buildPracticeCard(context, practice)),
        ],
      ),
    );
  }

  Widget _buildPracticeCard(BuildContext context, Practice practice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: _getTypeColor(practice.type).withOpacity(0.2),
          child: Icon(
            _getTypeIcon(practice.type),
            color: _getTypeColor(practice.type),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(practice.name, style: AppTextStyles.h3),
            ),
            if (practice.isPremium)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(practice.description, style: AppTextStyles.caption),
            const SizedBox(height: 8),
            Text(
              '${practice.durationSeconds ~/ 60} perc',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.push('/practice/${practice.id}');
        },
      ),
    );
  }

  Color _getTypeColor(PracticeType type) {
    switch (type) {
      case PracticeType.breathing:
        return AppColors.primary;
      case PracticeType.grounding:
        return AppColors.accent;
      case PracticeType.reframe:
        return AppColors.secondary;
      case PracticeType.physical:
        return AppColors.moodGood;
    }
  }

  IconData _getTypeIcon(PracticeType type) {
    switch (type) {
      case PracticeType.breathing:
        return Icons.air_rounded;
      case PracticeType.grounding:
        return Icons.self_improvement_rounded;
      case PracticeType.reframe:
        return Icons.psychology_rounded;
      case PracticeType.physical:
        return Icons.fitness_center_rounded;
    }
  }
}
