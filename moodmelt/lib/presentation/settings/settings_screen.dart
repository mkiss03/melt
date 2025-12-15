import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_text_styles.dart';
import '../../domain/providers/settings_provider.dart';
import '../../data/models/user_preferences.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beállítások'),
      ),
      body: ListView(
        children: [
          _buildSection('Értesítések'),
          SwitchListTile(
            title: const Text('Értesítések engedélyezése'),
            subtitle: const Text('Gentle nudge-ok amikor szükséges'),
            value: prefs.notificationsEnabled,
            onChanged: (value) {
              ref
                  .read(preferencesProvider.notifier)
                  .updateNotifications(value);
            },
          ),
          const Divider(),
          _buildSection('Egészségügyi Adatok'),
          SwitchListTile(
            title: const Text('Health tracking'),
            subtitle: const Text('Szívverés alapú javaslatok'),
            value: prefs.healthTrackingEnabled,
            onChanged: (value) {
              ref
                  .read(preferencesProvider.notifier)
                  .updateHealthTracking(value);
            },
          ),
          ListTile(
            title: const Text('Érzékenység beállítása'),
            subtitle: Text(_getSensitivityLabel(prefs.triggerSensitivity)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              context.push('/settings/health');
            },
          ),
          const Divider(),
          _buildSection('Alkalmazás'),
          ListTile(
            title: const Text('Verzió'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            title: const Text('Adatvédelem'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to privacy policy
            },
          ),
          ListTile(
            title: const Text('Feltételek'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // TODO: Navigate to terms
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: AppTextStyles.h3,
      ),
    );
  }

  String _getSensitivityLabel(TriggerSensitivity sensitivity) {
    switch (sensitivity) {
      case TriggerSensitivity.rare:
        return 'Ritka (csak súlyos esetekben)';
      case TriggerSensitivity.normal:
        return 'Normál (ajánlott)';
      case TriggerSensitivity.frequent:
        return 'Gyakori (érzékenyebb)';
    }
  }
}
