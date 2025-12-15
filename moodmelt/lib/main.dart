import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'data/models/mood_entry.dart';
import 'data/models/practice_session.dart';
import 'data/models/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(MoodEntryAdapter());
  Hive.registerAdapter(PracticeSessionAdapter());
  Hive.registerAdapter(PracticeTypeAdapter());
  Hive.registerAdapter(UserPreferencesAdapter());
  Hive.registerAdapter(TriggerSensitivityAdapter());

  runApp(
    const ProviderScope(
      child: MoodMeltApp(),
    ),
  );
}
