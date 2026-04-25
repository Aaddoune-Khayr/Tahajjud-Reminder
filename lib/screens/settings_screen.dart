import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:khayr__tahajjud_reminder/services/alarm_service.dart';
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
                    icon: Icons.location_on,
                    title: isEnglish
                        ? 'Automatic location'
                        : 'Localisation automatique',
                    trailing: Switch(
                      value: settings.autoLocation,
                      onChanged: settingsService.toggleAutoLocation,
                      activeColor: primary,
                    ),
                  ),
                  _AdhanSelectorTile(
                    title: isEnglish ? 'Adhan' : 'Sonnerie',
                  ),
                  _AlarmActionsTile(
                    authorizeLabel: isEnglish ? 'Authorize' : 'Autoriser',
                    testLabel:
                        isEnglish ? 'Test notification' : 'Tester la notification',
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
                  _DaySelectorTile(
                    title: isEnglish ? 'Active days' : 'Jours actifs',
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

class _AdhanSelectorTile extends StatefulWidget {
  final String title;

  const _AdhanSelectorTile({
    required this.title,
  });

  @override
  State<_AdhanSelectorTile> createState() => _AdhanSelectorTileState();
}

class _AdhanSelectorTileState extends State<_AdhanSelectorTile> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  static const _options = <String, String>{
    'adhan_1': 'Adhan 1',
    'adhan_2': 'Adhan 2',
  };

  static const _assets = <String, String>{
    'adhan_1': 'audio/adhan_1.mp3',
    'adhan_2': 'audio/adhan_2.mp3',
  };

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePreview(String ringtoneKey, double volume) async {
    try {
      if (_isPlaying) {
        await _player.stop();
        if (mounted) setState(() => _isPlaying = false);
        return;
      }

      final assetPath = _assets[ringtoneKey];
      if (assetPath == null) return;

      await _player.stop();
      await _player.setVolume(volume);
      await _player.play(AssetSource(assetPath));
      if (mounted) setState(() => _isPlaying = true);

      _player.onPlayerComplete.first.then((_) {
        if (mounted) setState(() => _isPlaying = false);
      });
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsService = context.watch<SettingsService>();
    final settings = settingsService.settings;
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final selected = _options.containsKey(settings.ringtone)
        ? settings.ringtone
        : 'adhan_1';

    // Update player volume in real-time if it's already playing
    if (_isPlaying) {
      _player.setVolume(settings.volume);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.music_note, color: primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.title, 
                  style: context.textStyles.bodyLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            flex: 0,
            child: DropdownButton<String>(
              value: selected,
              underline: const SizedBox(),
              isDense: true,
              style: context.textStyles.bodyMedium?.copyWith(
                color: onSurface,
                fontSize: 13,
              ),
              items: _options.entries
                  .map(
                    (e) => DropdownMenuItem(
                      value: e.key,
                      child: Text(
                        e.value,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  settingsService.updateRingtone(value);
                }
              },
            ),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: () => _togglePreview(selected, settings.volume),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_isPlaying ? Icons.stop : Icons.play_arrow, size: 20),
                const SizedBox(width: 2),
                Text(
                  _isPlaying
                      ? (settings.language == 'en' ? 'Stop' : 'Stop')
                      : (settings.language == 'en' ? 'Listen' : 'Écouter'),
                  style: context.textStyles.labelMedium?.copyWith(color: primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlarmActionsTile extends StatefulWidget {
  final String authorizeLabel;
  final String testLabel;

  const _AlarmActionsTile({
    required this.authorizeLabel,
    required this.testLabel,
  });

  @override
  State<_AlarmActionsTile> createState() => _AlarmActionsTileState();
}

class _AlarmActionsTileState extends State<_AlarmActionsTile> {
  bool _isTesting = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final settings = context.watch<SettingsService>().settings;
    final alarmService = context.read<AlarmService>();
    final isEnglish = settings.language == 'en';

    Future<void> authorize() async {
      final granted = await alarmService.requestPermission();
      final diag = await alarmService.getPermissionDiagnostics();
      if (!context.mounted) return;

      String message;
      if (granted == true || diag['notificationsEnabled'] == true) {
        final exactOk = diag['exactAlarmsEnabled'] == true;
        message = exactOk
            ? (isEnglish
                ? 'Notifications + exact alarms authorized.'
                : 'Notifications + alarmes exactes autorisées.')
            : (isEnglish
                ? 'Notifications authorized. Enable exact alarms in Android settings.'
                : 'Notifications autorisées. Activez aussi les alarmes exactes dans Android.');
      } else {
        message = isEnglish
            ? 'Please also enable "Exact Alarms" in settings.'
            : 'Veuillez aussi activer "Alarmes et rappels" dans les réglages.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }

    Future<void> startTest() async {
      final result = await alarmService.showTestNotification(
        ringtoneKey: settings.ringtone,
        isEnglish: isEnglish,
      );
      if (!context.mounted) return;

      if (result == 'sent_custom') {
        setState(() => _isTesting = true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEnglish
                ? 'Test started — press Stop to silence.'
                : 'Test démarré — appuyez sur Arrêter pour couper.'),
          ),
        );
      } else if (result == 'permission_denied') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEnglish
                ? 'Notification blocked by Android permission/settings.'
                : 'Notification bloquée par les permissions/réglages Android.'),
          ),
        );
      } else {
        final errorSuffix = result.startsWith('send_failed:')
            ? result.substring('send_failed:'.length)
            : '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEnglish
                ? 'Notification send failed. $errorSuffix'
                : 'Échec d\'envoi de notification. $errorSuffix'),
          ),
        );
      }
    }

    Future<void> stopTest() async {
      await alarmService.stopTestAlarm();
      if (mounted) setState(() => _isTesting = false);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.notifications, color: primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  isEnglish ? 'Notification settings' : 'Réglages notifications',
                  style: context.textStyles.bodyLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: authorize,
                      style: OutlinedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                      child: Text(widget.authorizeLabel),
                    ),
                    if (!_isTesting)
                      ElevatedButton(
                        onPressed: startTest,
                        style: ElevatedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: primary.withValues(alpha: 0.1),
                          foregroundColor: primary,
                          elevation: 0,
                        ),
                        child: Text(widget.testLabel),
                      )
                    else
                      ElevatedButton.icon(
                        onPressed: stopTest,
                        icon: const Icon(Icons.stop, size: 18),
                        label: Text(isEnglish ? 'Stop' : 'Arrêter'),
                        style: ElevatedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.red.withValues(alpha: 0.15),
                          foregroundColor: Colors.red,
                          elevation: 0,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
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

class _DaySelectorTile extends StatelessWidget {
  final String title;

  const _DaySelectorTile({required this.title});

  @override
  Widget build(BuildContext context) {
    final settingsService = context.watch<SettingsService>();
    final settings = settingsService.settings;
    final isEnglish = settings.language == 'en';
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    // Day labels: 1=Monday, 7=Sunday
    final dayLabels = isEnglish
        ? ['M', 'T', 'W', 'T', 'F', 'S', 'S']
        : ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, color: primary, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: context.textStyles.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final dayNumber = index + 1; // 1=Monday, 7=Sunday
              final isActive = settings.activeDays.contains(dayNumber);

              return GestureDetector(
                onTap: () {
                  final newDays = List<int>.from(settings.activeDays);
                  if (isActive) {
                    newDays.remove(dayNumber);
                  } else {
                    newDays.add(dayNumber);
                  }
                  newDays.sort();
                  settingsService.updateActiveDays(newDays);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive
                        ? primary
                        : onSurface.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      dayLabels[index],
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: isActive
                            ? Colors.white
                            : onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
