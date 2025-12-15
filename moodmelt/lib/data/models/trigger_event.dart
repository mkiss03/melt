enum TriggerReason {
  elevatedHeartRate,
  lowHRV,
  userManual,
}

class TriggerEvent {
  final DateTime timestamp;
  final TriggerReason reason;
  final double? heartRate;
  final double? baseline;

  TriggerEvent({
    required this.timestamp,
    required this.reason,
    this.heartRate,
    this.baseline,
  });
}
