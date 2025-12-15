import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/practice_session.dart';
import '../../data/repositories/practice_repository.dart';

final practiceRepositoryProvider = Provider<PracticeRepository>((ref) {
  final repo = PracticeRepository();
  repo.init();
  return repo;
});

final practiceSessionProvider =
    StateNotifierProvider<PracticeSessionNotifier, List<PracticeSession>>(
        (ref) {
  final repository = ref.watch(practiceRepositoryProvider);
  return PracticeSessionNotifier(repository);
});

class PracticeSessionNotifier extends StateNotifier<List<PracticeSession>> {
  final PracticeRepository _repository;

  PracticeSessionNotifier(this._repository) : super([]) {
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    state = _repository.getAllSessions();
  }

  Future<void> startSession({
    required String practiceId,
    required String practiceName,
    required PracticeType type,
    double? heartRateBefore,
  }) async {
    final session = PracticeSession(
      practiceId: practiceId,
      practiceName: practiceName,
      type: type,
      startTime: DateTime.now(),
      heartRateBefore: heartRateBefore,
    );

    await _repository.addSession(session);
    state = [...state, session];
  }

  Future<void> completeSession({
    required String sessionId,
    required int durationSeconds,
    double? heartRateAfter,
  }) async {
    final sessionIndex = state.indexWhere((s) => s.id == sessionId);
    if (sessionIndex == -1) return;

    final updatedSession = state[sessionIndex].copyWith(
      completed: true,
      endTime: DateTime.now(),
      durationSeconds: durationSeconds,
      heartRateAfter: heartRateAfter,
    );

    await _repository.addSession(updatedSession);
    state = [
      ...state.sublist(0, sessionIndex),
      updatedSession,
      ...state.sublist(sessionIndex + 1),
    ];
  }

  int getTotalPracticeCount() {
    return _repository.getTotalPracticeCount();
  }

  int getTotalPracticeMinutes() {
    return _repository.getTotalPracticeMinutes();
  }
}

// Practice templates provider
final practiceTemplatesProvider = Provider<List<Practice>>((ref) {
  return PracticeRepository.getPracticeTemplates();
});

final freePracticesProvider = Provider<List<Practice>>((ref) {
  final repo = ref.watch(practiceRepositoryProvider);
  return repo.getFreePractices();
});

final premiumPracticesProvider = Provider<List<Practice>>((ref) {
  final repo = ref.watch(practiceRepositoryProvider);
  return repo.getPremiumPractices();
});
