import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/providers/mood_provider.dart';
import '../../../domain/providers/practice_provider.dart';

class RecentActivityList extends ConsumerWidget {
  const RecentActivityList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodEntries = ref.watch(moodProvider);
    final practiceSessions = ref.watch(practiceSessionProvider);

    // Combine and sort by timestamp
    final recentMoods = moodEntries.take(5).toList();
    final recentPractices = practiceSessions.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Legutóbbi aktivitás',
          style: AppTextStyles.h3,
        ),
        const SizedBox(height: 12),
        if (recentMoods.isEmpty && recentPractices.isEmpty)
          const Text(
            'Még nincs aktivitás. Kezdd egy hangulatfelméréssel!',
            style: AppTextStyles.bodySecondary,
          )
        else
          ...recentMoods.map((mood) => ListTile(
                leading: const Icon(Icons.mood),
                title: Text(_getMoodLabel(mood.moodLevel)),
                subtitle: Text(_formatTime(mood.timestamp)),
              )),
      ],
    );
  }

  String _getMoodLabel(int level) {
    switch (level) {
      case 1:
        return 'Rossz hangulat';
      case 2:
        return 'Nem túl jó';
      case 3:
        return 'Oké';
      case 4:
        return 'Jó';
      case 5:
        return 'Szuper!';
      default:
        return '';
    }
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} perce';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} órája';
    } else {
      return '${diff.inDays} napja';
    }
  }
}
