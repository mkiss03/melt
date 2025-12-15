import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 0)
class MoodEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final int moodLevel; // 1-5 (terrible, bad, okay, good, great)

  @HiveField(3)
  final String? note;

  @HiveField(4)
  final List<String> tags;

  MoodEntry({
    String? id,
    required this.timestamp,
    required this.moodLevel,
    this.note,
    List<String>? tags,
  })  : id = id ?? const Uuid().v4(),
        tags = tags ?? [];

  MoodEntry copyWith({
    String? id,
    DateTime? timestamp,
    int? moodLevel,
    String? note,
    List<String>? tags,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      moodLevel: moodLevel ?? this.moodLevel,
      note: note ?? this.note,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'moodLevel': moodLevel,
      'note': note,
      'tags': tags,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      moodLevel: json['moodLevel'],
      note: json['note'],
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}
