import 'package:hive/hive.dart';
import '../models/user_preferences.dart';

class PreferencesRepository {
  static const String _boxName = 'user_preferences';
  static const String _prefsKey = 'prefs';
  Box<UserPreferences>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<UserPreferences>(_boxName);
  }

  UserPreferences getPreferences() {
    return _box?.get(_prefsKey) ?? UserPreferences();
  }

  Future<void> savePreferences(UserPreferences prefs) async {
    await _box?.put(_prefsKey, prefs);
  }

  Future<void> updateHealthTracking(bool enabled) async {
    final prefs = getPreferences();
    prefs.healthTrackingEnabled = enabled;
    await savePreferences(prefs);
  }

  Future<void> updateTriggerSensitivity(TriggerSensitivity sensitivity) async {
    final prefs = getPreferences();
    prefs.triggerSensitivity = sensitivity;
    await savePreferences(prefs);
  }

  Future<void> updateNotifications(bool enabled) async {
    final prefs = getPreferences();
    prefs.notificationsEnabled = enabled;
    await savePreferences(prefs);
  }

  Future<void> completeOnboarding() async {
    final prefs = getPreferences();
    prefs.onboardingCompleted = true;
    await savePreferences(prefs);
  }

  Future<void> updateLastHealthSync(DateTime time) async {
    final prefs = getPreferences();
    prefs.lastHealthSync = time;
    await savePreferences(prefs);
  }
}
