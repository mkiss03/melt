import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/repositories/practice_repository.dart';

class PracticeDetailScreen extends ConsumerWidget {
  final String practiceId;

  const PracticeDetailScreen({super.key, required this.practiceId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final practice = PracticeRepository().getPracticeById(practiceId);

    if (practice == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Practice not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(practice.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: AppColors.meltGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.self_improvement,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Title and duration
            Text(practice.name, style: AppTextStyles.h1),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${practice.durationSeconds ~/ 60} perc',
                  style: AppTextStyles.caption,
                ),
                if (practice.isPremium) ...[
                  const SizedBox(width: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'PRO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),
            // Description
            const Text('Leírás', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(practice.description, style: AppTextStyles.body),
            const SizedBox(height: 24),
            // Instructions
            const Text('Útmutató', style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(practice.instruction, style: AppTextStyles.body),
            const SizedBox(height: 24),
            // Steps
            const Text('Lépések', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            ...practice.steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(step.instruction, style: AppTextStyles.body),
                          Text(
                            '${step.durationSeconds}s',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 32),
            // Start button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/practice/$practiceId/active');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Kezdjük!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
