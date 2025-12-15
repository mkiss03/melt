import 'package:health/health.dart';
import '../../data/models/health_signal.dart';

class HealthService {
  final Health _health = Health();

  // Data types to request
  static final types = [
    HealthDataType.HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_SDNN,
    HealthDataType.STEPS,
    // HealthDataType.BLOOD_OXYGEN, // Optional, not all devices
  ];

  Future<bool> requestPermissions() async {
    bool granted = false;

    // Request permissions
    granted = await _health.requestAuthorization(types);

    return granted;
  }

  Future<HealthSignal?> getCurrentSignal() async {
    final now = DateTime.now();
    final fiveMinutesAgo = now.subtract(const Duration(minutes: 5));

    try {
      // Fetch heart rate
      final heartRateData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: fiveMinutesAgo,
        endTime: now,
      );

      // Fetch steps
      final stepsData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: fiveMinutesAgo,
        endTime: now,
      );

      if (heartRateData.isEmpty) return null;

      // Get most recent values
      final latestHR = heartRateData.last.value as num?;
      final totalSteps = stepsData.fold<int>(
        0,
        (sum, data) => sum + (data.value as num).toInt(),
      );

      final activityLevel = _inferActivityLevel(totalSteps);

      return HealthSignal(
        timestamp: now,
        heartRate: latestHR?.toDouble(),
        stepCount: totalSteps,
        activityLevel: activityLevel,
      );
    } catch (e) {
      print('Error fetching health data: $e');
      return null;
    }
  }

  Future<List<HealthSignal>> getSignalsInRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final data = await _health.getHealthDataFromTypes(
        types: types,
        startTime: start,
        endTime: end,
      );

      // Group by timestamp (rounded to nearest minute)
      final Map<DateTime, HealthSignal> signalMap = {};

      for (var point in data) {
        final roundedTime = DateTime(
          point.dateFrom.year,
          point.dateFrom.month,
          point.dateFrom.day,
          point.dateFrom.hour,
          point.dateFrom.minute,
        );

        signalMap.putIfAbsent(
          roundedTime,
          () => HealthSignal(timestamp: roundedTime),
        );

        if (point.type == HealthDataType.HEART_RATE) {
          signalMap[roundedTime] = signalMap[roundedTime]!.copyWith(
            heartRate: (point.value as num).toDouble(),
          );
        } else if (point.type == HealthDataType.STEPS) {
          signalMap[roundedTime] = signalMap[roundedTime]!.copyWith(
            stepCount: (point.value as num).toInt(),
          );
        }
      }

      return signalMap.values.toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } catch (e) {
      print('Error fetching health range: $e');
      return [];
    }
  }

  ActivityLevel _inferActivityLevel(int stepsInFiveMinutes) {
    if (stepsInFiveMinutes < 10) return ActivityLevel.sedentary;
    if (stepsInFiveMinutes < 50) return ActivityLevel.light;
    if (stepsInFiveMinutes < 150) return ActivityLevel.moderate;
    return ActivityLevel.intense;
  }
}
