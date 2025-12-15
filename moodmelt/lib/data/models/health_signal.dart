enum ActivityLevel {
  sedentary,
  light,
  moderate,
  intense,
  unknown,
}

class HealthSignal {
  final DateTime timestamp;
  final double? heartRate;
  final double? hrv;
  final double? spO2;
  final int? stepCount;
  final ActivityLevel activityLevel;

  HealthSignal({
    required this.timestamp,
    this.heartRate,
    this.hrv,
    this.spO2,
    this.stepCount,
    this.activityLevel = ActivityLevel.unknown,
  });

  HealthSignal copyWith({
    DateTime? timestamp,
    double? heartRate,
    double? hrv,
    double? spO2,
    int? stepCount,
    ActivityLevel? activityLevel,
  }) {
    return HealthSignal(
      timestamp: timestamp ?? this.timestamp,
      heartRate: heartRate ?? this.heartRate,
      hrv: hrv ?? this.hrv,
      spO2: spO2 ?? this.spO2,
      stepCount: stepCount ?? this.stepCount,
      activityLevel: activityLevel ?? this.activityLevel,
    );
  }
}
