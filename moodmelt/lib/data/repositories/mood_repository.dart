import 'package:hive/hive.dart';
import '../models/mood_entry.dart';

class MoodRepository {
  static const String _boxName = 'mood_entries';
  Box<MoodEntry>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<MoodEntry>(_boxName);
  }

  Future<void> addMoodEntry(MoodEntry entry) async {
    await _box?.put(entry.id, entry);
  }

  List<MoodEntry> getAllMoodEntries() {
    return _box?.values.toList() ?? [];
  }

  List<MoodEntry> getMoodEntriesInRange(DateTime start, DateTime end) {
    return _box?.values
            .where((entry) =>
                entry.timestamp.isAfter(start) && entry.timestamp.isBefore(end))
            .toList() ??
        [];
  }

  MoodEntry? getLatestMoodEntry() {
    final entries = _box?.values.toList() ?? [];
    if (entries.isEmpty) return null;
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries.first;
  }

  Future<void> deleteMoodEntry(String id) async {
    await _box?.delete(id);
  }

  int getCurrentStreak() {
    final entries = getAllMoodEntries();
    if (entries.isEmpty) return 0;

    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    int streak = 0;
    DateTime checkDate = DateTime.now();

    for (var entry in entries) {
      final entryDate = DateTime(
        entry.timestamp.year,
        entry.timestamp.month,
        entry.timestamp.day,
      );

      final currentCheck = DateTime(
        checkDate.year,
        checkDate.month,
        checkDate.day,
      );

      if (entryDate == currentCheck) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else if (entryDate.isBefore(currentCheck)) {
        break;
      }
    }

    return streak;
  }
}
