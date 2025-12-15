import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/health_signal.dart';
import '../../data/repositories/health_repository.dart';
import '../services/health_service.dart';

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository();
});

final healthServiceProvider = Provider<HealthService>((ref) {
  return HealthService();
});

final currentHealthSignalProvider = FutureProvider<HealthSignal?>((ref) async {
  final healthService = ref.watch(healthServiceProvider);
  return await healthService.getCurrentSignal();
});

final healthSignalsProvider =
    StateNotifierProvider<HealthSignalNotifier, List<HealthSignal>>((ref) {
  final repository = ref.watch(healthRepositoryProvider);
  return HealthSignalNotifier(repository);
});

class HealthSignalNotifier extends StateNotifier<List<HealthSignal>> {
  final HealthRepository _repository;

  HealthSignalNotifier(this._repository) : super([]);

  void addSignal(HealthSignal signal) {
    _repository.addSignal(signal);
    state = [...state, signal];
  }

  Future<List<HealthSignal>> getSignalsInRange(
    DateTime start,
    DateTime end,
  ) async {
    return await _repository.getSignalsInRange(start, end);
  }
}
