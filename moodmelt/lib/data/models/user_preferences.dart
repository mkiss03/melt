import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 4)
enum TriggerSensitivity {
  @HiveField(0)
  rare,

  @HiveField(1)
  normal,

  @HiveField(2)
  frequent,
}

@HiveType(typeId: 3)
class UserPreferences extends HiveObject {
  @HiveField(0)
  bool healthTrackingEnabled;

  @HiveField(1)
  TriggerSensitivity triggerSensitivity;

  @HiveField(2)
  bool notificationsEnabled;

  @HiveField(3)
  List<String> doNotDisturbHours; // ["22:00-07:00"]

  @HiveField(4)
  bool onboardingCompleted;

  @HiveField(5)
  DateTime? lastHealthSync;

  @HiveField(6)
  bool isPro;

  UserPreferences({
    this.healthTrackingEnabled = false,
    this.triggerSensitivity = TriggerSensitivity.normal,
    this.notificationsEnabled = true,
    List<String>? doNotDisturbHours,
    this.onboardingCompleted = false,
    this.lastHealthSync,
    this.isPro = false,
  }) : doNotDisturbHours = doNotDisturbHours ?? [];
}
