import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';
import 'package:khayr__tahajjud_reminder/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsService = context.watch<SettingsService>();
    final settings = settingsService.settings;
    final isEnglish = settings.language == 'en';
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.settings, color: primary, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    isEnglish ? 'Settings' : 'Paramètres',
                    style: context.textStyles.headlineMedium?.bold,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _SettingsCard(
                title: isEnglish ? 'General' : 'Général',
                children: [
                  _SettingsTile(
                    icon: Icons.language,
                    title: isEnglish ? 'Language' : 'Langue',
                    trailing: DropdownButton<String>(
                      value: settings.language,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 'fr', child: Text('Français')),
                        DropdownMenuItem(value: 'en', child: Text('English')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          settingsService.updateLanguage(value);
                        }
                      },
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.dark_mode,
                    title: isEnglish ? 'Dark mode' : 'Mode sombre',
                    trailing: Switch(
                      value: settings.darkMode,
                      onChanged: settingsService.toggleDarkMode,
                      activeColor: primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SettingsCard(
                title: isEnglish ? 'Alarm' : 'Alarme',
                children: [
                  _SettingsTile(
                    icon: Icons.notifications_active,
                    title: isEnglish ? 'Enable alarm' : 'Activer l\'alarme',
                    trailing: Switch(
                      value: settings.alarmEnabled,
                      onChanged: settingsService.toggleAlarm,
                      activeColor: primary,
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.music_note,
                    title: isEnglish ? 'Ringtone' : 'Sonnerie',
                    subtitle: isEnglish
                        ? 'Adhan – spiritual call to wake for Tahajjud'
                        : 'Adhan – appel à la prière pour vous réveiller au Tahajjud',
                    trailing: Text(
                      'Adhan',
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.volume_up,
                    title: isEnglish ? 'Volume' : 'Volume',
                    subtitle: '${(settings.volume * 100).round()}%',
                    trailing: SizedBox(
                      width: 150,
                      child: Slider(
                        value: settings.volume,
                        onChanged: settingsService.updateVolume,
                        activeColor: primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _SettingsCard(
                title: isEnglish ? 'Prayer time calculation' : 'Calcul des heures',
                children: [
                  _SettingsTile(
                    icon: Icons.calculate,
                    title: isEnglish ? 'Calculation method' : 'Méthode de calcul',
                    subtitle: isEnglish
                        ? 'MWL – Standard Europe\nISNA – North America\nEgypt – Arab countries\n(earlier Fajr)\nChanging the method\nautomatically adjusts\nthe Tahajjud alarm.'
                        : 'MWL – Standard Europe\nISNA – Amérique du Nord\nÉgypte – Pays arabes\n(Fajr plus tôt)\nChanger la méthode\najuste automatiquement\nl\'alarme du dernier tiers.',
                    trailing: DropdownButton<String>(
                      value: settings.calculationMethod,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'muslim_world_league',
                          child: Text('MWL'),
                        ),
                        DropdownMenuItem(value: 'isna', child: Text('ISNA')),
                        DropdownMenuItem(
                          value: 'egypt',
                          child: Text('Égypte'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          settingsService.updateCalculationMethod(value);
                        }
                      },
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.location_on,
                     title: isEnglish ? 'Automatic location' : 'Localisation automatique',
                    trailing: Switch(
                      value: settings.autoLocation,
                      onChanged: settingsService.toggleAutoLocation,
                      activeColor: primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsCard({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title,
            style: context.textStyles.titleMedium?.copyWith(
              color: onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
        Card(
          child: Column(
            children: children
                .expand((child) => [
                      child,
                      if (child != children.last)
                        Divider(
                          height: 1,
                          indent: 56,
                          color: onSurface.withValues(alpha: 0.1),
                        ),
                    ])
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyles.bodyLarge,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: context.textStyles.bodySmall?.copyWith(
                      color: onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
