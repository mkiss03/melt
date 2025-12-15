import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../domain/providers/mood_provider.dart';

class MoodCheckInCard extends ConsumerStatefulWidget {
  const MoodCheckInCard({super.key});

  @override
  ConsumerState<MoodCheckInCard> createState() => _MoodCheckInCardState();
}

class _MoodCheckInCardState extends ConsumerState<MoodCheckInCard> {
  int? _selectedMood;
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hangulatfelmérés',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            // Mood selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodButton(1, '😖', 'Rossz'),
                _buildMoodButton(2, '😟', 'Nem jó'),
                _buildMoodButton(3, '😐', 'Oké'),
                _buildMoodButton(4, '😊', 'Jó'),
                _buildMoodButton(5, '😄', 'Szuper'),
              ],
            ),
            if (_selectedMood != null) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  hintText: 'Mit szeretnél megjegyezni? (opcionális)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMood,
                  child: const Text('Mentés'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(int level, String emoji, String label) {
    final isSelected = _selectedMood == level;

    return GestureDetector(
      onTap: () => setState(() => _selectedMood = level),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? _getMoodColor(level) : Colors.grey.shade200,
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMoodColor(int level) {
    switch (level) {
      case 1:
        return AppColors.moodTerrible;
      case 2:
        return AppColors.moodBad;
      case 3:
        return AppColors.moodOkay;
      case 4:
        return AppColors.moodGood;
      case 5:
        return AppColors.moodGreat;
      default:
        return AppColors.primary;
    }
  }

  void _saveMood() {
    if (_selectedMood == null) return;

    ref.read(moodProvider.notifier).addMoodEntry(
          moodLevel: _selectedMood!,
          note: _noteController.text.isNotEmpty ? _noteController.text : null,
        );

    setState(() {
      _selectedMood = null;
      _noteController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Elmentve! 💙')),
    );
  }
}
