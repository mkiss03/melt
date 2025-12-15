import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/providers/settings_provider.dart';
import '../../data/models/user_preferences.dart';

class HealthSettingsScreen extends ConsumerWidget {
  const HealthSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Beállítások'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Trigger érzékenység',
            style: AppTextStyles.h3,
          ),
          const SizedBox(height: 8),
          const Text(
            'Mennyire gyakran szeretnél értesítéseket kapni stresszes helyzetek esetén?',
            style: AppTextStyles.bodySecondary,
          ),
          const SizedBox(height: 24),
          RadioListTile<TriggerSensitivity>(
            title: const Text('Ritka'),
            subtitle: const Text(
              'Csak súlyos esetekben (35% emelkedés, 10 perc)',
            ),
            value: TriggerSensitivity.rare,
            groupValue: prefs.triggerSensitivity,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(preferencesProvider.notifier)
                    .updateTriggerSensitivity(value);
              }
            },
          ),
          RadioListTile<TriggerSensitivity>(
            title: const Text('Normál (ajánlott)'),
            subtitle: const Text(
              'Kiegyensúlyozott (25% emelkedés, 5 perc)',
            ),
            value: TriggerSensitivity.normal,
            groupValue: prefs.triggerSensitivity,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(preferencesProvider.notifier)
                    .updateTriggerSensitivity(value);
              }
            },
          ),
          RadioListTile<TriggerSensitivity>(
            title: const Text('Gyakori'),
            subtitle: const Text(
              'Érzékenyebb (20% emelkedés, 3 perc)',
            ),
            value: TriggerSensitivity.frequent,
            groupValue: prefs.triggerSensitivity,
            onChanged: (value) {
              if (value != null) {
                ref
                    .read(preferencesProvider.notifier)
                    .updateTriggerSensitivity(value);
              }
            },
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      const Text(
                        'Hogyan működik?',
                        style: AppTextStyles.h3,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Az alkalmazás figyeli a szívritmust és értesítést küld, ha stressz jeleket észlel. Az érzékenység határozza meg, hogy milyen gyorsan reagáljon.',
                    style: AppTextStyles.bodySecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
