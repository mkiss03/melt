import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'practice_session.g.dart';

@HiveType(typeId: 5)
enum PracticeType {
  @HiveField(0)
  breathing,

  @HiveField(1)
  grounding,

  @HiveField(2)
  reframe,

  @HiveField(3)
  physical,
}

@HiveType(typeId: 1)
class PracticeSession extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String practiceId; // Reference to practice template

  @HiveField(2)
  final String practiceName;

  @HiveField(3)
  final PracticeType type;

  @HiveField(4)
  final DateTime startTime;

  @HiveField(5)
  final DateTime? endTime;

  @HiveField(6)
  final bool completed;

  @HiveField(7)
  final int durationSeconds;

  @HiveField(8)
  final double? heartRateBefore;

  @HiveField(9)
  final double? heartRateAfter;

  PracticeSession({
    String? id,
    required this.practiceId,
    required this.practiceName,
    required this.type,
    required this.startTime,
    this.endTime,
    this.completed = false,
    this.durationSeconds = 0,
    this.heartRateBefore,
    this.heartRateAfter,
  }) : id = id ?? const Uuid().v4();

  PracticeSession copyWith({
    String? id,
    String? practiceId,
    String? practiceName,
    PracticeType? type,
    DateTime? startTime,
    DateTime? endTime,
    bool? completed,
    int? durationSeconds,
    double? heartRateBefore,
    double? heartRateAfter,
  }) {
    return PracticeSession(
      id: id ?? this.id,
      practiceId: practiceId ?? this.practiceId,
      practiceName: practiceName ?? this.practiceName,
      type: type ?? this.type,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      completed: completed ?? this.completed,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      heartRateBefore: heartRateBefore ?? this.heartRateBefore,
      heartRateAfter: heartRateAfter ?? this.heartRateAfter,
    );
  }
}

// Practice Template (not stored in Hive, just in-memory)
class Practice {
  final String id;
  final String name;
  final String description;
  final PracticeType type;
  final int durationSeconds;
  final String instruction;
  final List<PracticeStep> steps;
  final bool isPremium;

  Practice({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.durationSeconds,
    required this.instruction,
    required this.steps,
    this.isPremium = false,
  });
}

class PracticeStep {
  final String instruction;
  final int durationSeconds;
  final String? soundCue; // breath_in, breath_out, etc.

  PracticeStep({
    required this.instruction,
    required this.durationSeconds,
    this.soundCue,
  });
}
