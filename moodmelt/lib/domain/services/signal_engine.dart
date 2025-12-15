import '../../data/models/health_signal.dart';
import '../../data/models/trigger_event.dart';
import '../../data/models/user_preferences.dart';
import '../../data/repositories/health_repository.dart';

class SignalEngine {
  final HealthRepository _healthRepo;

  // Configurable thresholds
  double heartRateIncreaseThreshold = 0.25; // 25% above baseline
  int elevatedDurationMinutes = 5;
  int cooldownMinutes = 30;

  DateTime? _lastTriggerTime;

  SignalEngine(this._healthRepo);

  /// Calculate 7-day baseline heart rate
  Future<double?> calculateHeartRateBaseline() async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final signals = await _healthRepo.getSignalsInRange(
      sevenDaysAgo,
      now,
    );

    if (signals.isEmpty) return null;

    // Filter out exercise/sleep (if activity level available)
    final restingSignals = signals
        .where((s) =>
            s.activityLevel == ActivityLevel.sedentary ||
            s.activityLevel == ActivityLevel.light)
        .toList();

    if (restingSignals.isEmpty) return null;

    // Calculate median (more robust than mean)
    final heartRates = restingSignals
        .where((s) => s.heartRate != null)
        .map((s) => s.heartRate!)
        .toList()
      ..sort();

    if (heartRates.isEmpty) return null;

    return heartRates[heartRates.length ~/ 2];
  }

  /// Check if current signal should trigger notification
  Future<TriggerEvent?> checkTrigger(HealthSignal currentSignal) async {
    // 1. Check cooldown
    if (_isInCooldown()) {
      return null;
    }

    // 2. Check activity level (don't trigger during exercise)
    if (currentSignal.activityLevel == ActivityLevel.moderate ||
        currentSignal.activityLevel == ActivityLevel.intense) {
      return null;
    }

    // 3. Get baseline
    final baseline = await calculateHeartRateBaseline();
    if (baseline == null || currentSignal.heartRate == null) {
      return null;
    }

    // 4. Check if heart rate elevated
    final threshold = baseline * (1 + heartRateIncreaseThreshold);
    if (currentSignal.heartRate! < threshold) {
      return null;
    }

    // 5. Check if elevated for sustained period
    final isElevatedLongEnough = await _checkSustainedElevation(
      threshold,
      elevatedDurationMinutes,
    );

    if (!isElevatedLongEnough) {
      return null;
    }

    // 6. TRIGGER!
    _lastTriggerTime = DateTime.now();

    return TriggerEvent(
      timestamp: DateTime.now(),
      reason: TriggerReason.elevatedHeartRate,
      heartRate: currentSignal.heartRate,
      baseline: baseline,
    );
  }

  bool _isInCooldown() {
    if (_lastTriggerTime == null) return false;

    final timeSinceLastTrigger = DateTime.now().difference(_lastTriggerTime!);
    return timeSinceLastTrigger.inMinutes < cooldownMinutes;
  }

  Future<bool> _checkSustainedElevation(
    double threshold,
    int minutes,
  ) async {
    final now = DateTime.now();
    final checkStart = now.subtract(Duration(minutes: minutes));

    final recentSignals = await _healthRepo.getSignalsInRange(
      checkStart,
      now,
    );

    if (recentSignals.length < 2) return false;

    // Check if majority of signals are above threshold
    final elevatedCount = recentSignals
        .where((s) => s.heartRate != null && s.heartRate! > threshold)
        .length;

    return elevatedCount >= (recentSignals.length * 0.7); // 70% threshold
  }

  /// Adjust sensitivity based on user preference
  void setSensitivity(TriggerSensitivity sensitivity) {
    switch (sensitivity) {
      case TriggerSensitivity.rare:
        heartRateIncreaseThreshold = 0.35; // 35%
        elevatedDurationMinutes = 10;
        cooldownMinutes = 60;
        break;
      case TriggerSensitivity.normal:
        heartRateIncreaseThreshold = 0.25; // 25%
        elevatedDurationMinutes = 5;
        cooldownMinutes = 30;
        break;
      case TriggerSensitivity.frequent:
        heartRateIncreaseThreshold = 0.20; // 20%
        elevatedDurationMinutes = 3;
        cooldownMinutes = 20;
        break;
    }
  }
}
