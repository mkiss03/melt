import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_preferences.dart';
import '../../data/repositories/preferences_repository.dart';

final preferencesRepositoryProvider = Provider<PreferencesRepository>((ref) {
  final repo = PreferencesRepository();
  repo.init();
  return repo;
});

final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, UserPreferences>((ref) {
  final repository = ref.watch(preferencesRepositoryProvider);
  return PreferencesNotifier(repository);
});

class PreferencesNotifier extends StateNotifier<UserPreferences> {
  final PreferencesRepository _repository;

  PreferencesNotifier(this._repository) : super(UserPreferences()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    state = _repository.getPreferences();
  }

  Future<void> updateHealthTracking(bool enabled) async {
    await _repository.updateHealthTracking(enabled);
    state = _repository.getPreferences();
  }

  Future<void> updateTriggerSensitivity(TriggerSensitivity sensitivity) async {
    await _repository.updateTriggerSensitivity(sensitivity);
    state = _repository.getPreferences();
  }

  Future<void> updateNotifications(bool enabled) async {
    await _repository.updateNotifications(enabled);
    state = _repository.getPreferences();
  }

  Future<void> completeOnboarding() async {
    await _repository.completeOnboarding();
    state = _repository.getPreferences();
  }

  Future<void> updateLastHealthSync(DateTime time) async {
    await _repository.updateLastHealthSync(time);
    state = _repository.getPreferences();
  }
}
