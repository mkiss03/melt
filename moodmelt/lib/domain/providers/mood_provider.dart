import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/mood_entry.dart';
import '../../data/repositories/mood_repository.dart';

final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  final repo = MoodRepository();
  repo.init();
  return repo;
});

final moodProvider =
    StateNotifierProvider<MoodNotifier, List<MoodEntry>>((ref) {
  final repository = ref.watch(moodRepositoryProvider);
  return MoodNotifier(repository);
});

class MoodNotifier extends StateNotifier<List<MoodEntry>> {
  final MoodRepository _repository;

  MoodNotifier(this._repository) : super([]) {
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    state = _repository.getAllMoodEntries();
  }

  Future<void> addMoodEntry({
    required int moodLevel,
    String? note,
    List<String>? tags,
  }) async {
    final entry = MoodEntry(
      timestamp: DateTime.now(),
      moodLevel: moodLevel,
      note: note,
      tags: tags,
    );

    await _repository.addMoodEntry(entry);
    state = [...state, entry];
  }

  int getCurrentStreak() {
    return _repository.getCurrentStreak();
  }

  Future<void> deleteMoodEntry(String id) async {
    await _repository.deleteMoodEntry(id);
    state = state.where((entry) => entry.id != id).toList();
  }
}

// Streak provider
final streakProvider = Provider<int>((ref) {
  final moodNotifier = ref.watch(moodProvider.notifier);
  return moodNotifier.getCurrentStreak();
});
