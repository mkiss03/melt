import '../models/health_signal.dart';

class HealthRepository {
  // In-memory storage for health signals (consider using Hive if persistence needed)
  final List<HealthSignal> _signals = [];

  void addSignal(HealthSignal signal) {
    _signals.add(signal);
    // Keep only last 7 days of data
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    _signals.removeWhere((s) => s.timestamp.isBefore(sevenDaysAgo));
  }

  Future<List<HealthSignal>> getSignalsInRange(
    DateTime start,
    DateTime end,
  ) async {
    return _signals
        .where((s) => s.timestamp.isAfter(start) && s.timestamp.isBefore(end))
        .toList();
  }

  HealthSignal? getLatestSignal() {
    if (_signals.isEmpty) return null;
    return _signals.reduce((a, b) => a.timestamp.isAfter(b.timestamp) ? a : b);
  }

  void clear() {
    _signals.clear();
  }
}
