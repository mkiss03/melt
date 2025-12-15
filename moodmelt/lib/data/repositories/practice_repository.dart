import 'package:hive/hive.dart';
import '../models/practice_session.dart';

class PracticeRepository {
  static const String _boxName = 'practice_sessions';
  Box<PracticeSession>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<PracticeSession>(_boxName);
  }

  Future<void> addSession(PracticeSession session) async {
    await _box?.put(session.id, session);
  }

  List<PracticeSession> getAllSessions() {
    return _box?.values.toList() ?? [];
  }

  List<PracticeSession> getSessionsInRange(DateTime start, DateTime end) {
    return _box?.values
            .where((session) =>
                session.startTime.isAfter(start) &&
                session.startTime.isBefore(end))
            .toList() ??
        [];
  }

  int getTotalPracticeCount() {
    return _box?.values.where((s) => s.completed).length ?? 0;
  }

  int getTotalPracticeMinutes() {
    return _box?.values
            .where((s) => s.completed)
            .fold<int>(0, (sum, s) => sum + (s.durationSeconds ~/ 60)) ??
        0;
  }

  // Practice Templates (hardcoded for MVP)
  static List<Practice> getPracticeTemplates() {
    return [
      // FREE PRACTICES
      Practice(
        id: 'box_breathing',
        name: 'Box Breathing',
        description: 'Egyszerű 4-4-4-4 légzés a nyugalom érdekében',
        type: PracticeType.breathing,
        durationSeconds: 64, // 4 cycles
        instruction: 'Kövesd a négyzetet: belégzés, tartás, kilégzés, tartás',
        steps: [
          PracticeStep(
              instruction: 'Lélegezz be',
              durationSeconds: 4,
              soundCue: 'breath_in'),
          PracticeStep(instruction: 'Tartsd', durationSeconds: 4),
          PracticeStep(
              instruction: 'Lélegezz ki',
              durationSeconds: 4,
              soundCue: 'breath_out'),
          PracticeStep(instruction: 'Tartsd', durationSeconds: 4),
        ],
      ),

      Practice(
        id: 'five_senses',
        name: '5-4-3-2-1 Grounding',
        description: 'Érzékszervi visszatérés a jelenbe',
        type: PracticeType.grounding,
        durationSeconds: 120,
        instruction: 'Figyeld meg a környezeted érzékszervi elemeit',
        steps: [
          PracticeStep(instruction: '5 dolgot amit látsz', durationSeconds: 25),
          PracticeStep(instruction: '4 dolgot amit érzel', durationSeconds: 25),
          PracticeStep(
              instruction: '3 dolgot amit hallasz', durationSeconds: 25),
          PracticeStep(
              instruction: '2 dolgot amit érzel szagban', durationSeconds: 25),
          PracticeStep(
              instruction: '1 dolgot amit érzel ízben', durationSeconds: 20),
        ],
      ),

      Practice(
        id: 'quick_body_scan',
        name: 'Quick Body Scan',
        description: 'Gyors testtudatosság 60 másodpercben',
        type: PracticeType.grounding,
        durationSeconds: 60,
        instruction: 'Pásztázd végig a tested fentről lefelé',
        steps: [
          PracticeStep(instruction: 'Fej és nyak', durationSeconds: 15),
          PracticeStep(instruction: 'Vállak és karok', durationSeconds: 15),
          PracticeStep(instruction: 'Mellkas és has', durationSeconds: 15),
          PracticeStep(instruction: 'Lábak és talp', durationSeconds: 15),
        ],
      ),

      // PREMIUM PRACTICES
      Practice(
        id: '478_breathing',
        name: '4-7-8 Breathing',
        description: 'Mély relaxáció Andrew Weil módszerével',
        type: PracticeType.breathing,
        durationSeconds: 90,
        instruction: 'Belégzés 4, tartás 7, kilégzés 8 számra',
        steps: [
          PracticeStep(
              instruction: 'Lélegezz be (4)',
              durationSeconds: 4,
              soundCue: 'breath_in'),
          PracticeStep(instruction: 'Tartsd (7)', durationSeconds: 7),
          PracticeStep(
              instruction: 'Lélegezz ki (8)',
              durationSeconds: 8,
              soundCue: 'breath_out'),
        ],
        isPremium: true,
      ),

      Practice(
        id: 'progressive_relaxation',
        name: 'Progressive Muscle Relaxation',
        description: 'Izomcsoportok megfeszítése és ellazítása',
        type: PracticeType.physical,
        durationSeconds: 180,
        instruction: 'Feszítsd meg, majd engedd el az izmokat',
        steps: [
          PracticeStep(instruction: 'Feszítsd meg a kezed', durationSeconds: 10),
          PracticeStep(instruction: 'Engedd el', durationSeconds: 10),
          PracticeStep(instruction: 'Feszítsd meg a karod', durationSeconds: 10),
          PracticeStep(instruction: 'Engedd el', durationSeconds: 10),
          // ... további izmok
        ],
        isPremium: true,
      ),
    ];
  }

  Practice? getPracticeById(String id) {
    try {
      return getPracticeTemplates().firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Practice> getFreePractices() {
    return getPracticeTemplates().where((p) => !p.isPremium).toList();
  }

  List<Practice> getPremiumPractices() {
    return getPracticeTemplates().where((p) => p.isPremium).toList();
  }
}
