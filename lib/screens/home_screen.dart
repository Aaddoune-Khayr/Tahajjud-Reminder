import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:khayr__tahajjud_reminder/services/prayer_time_service.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';
import 'package:khayr__tahajjud_reminder/theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prayerService = context.watch<PrayerTimeService>();
    final settings = context.watch<SettingsService>().settings;
    final isEnglish = settings.language == 'en';
    final timeFormat = DateFormat('HH:mm');
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final surfaceVariant = Theme.of(context).colorScheme.surfaceContainerHighest;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.nights_stay,
            size: 80,
            color: primary.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 16),
          Text(
            'Khayr',
            style: context.textStyles.displaySmall?.copyWith(
              color: primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isEnglish ? 'Tahajjud Reminder' : 'Rappel pour Tahajjud',
            style: context.textStyles.titleLarge?.copyWith(
              color: onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 40),
          Card(
            child: Padding(
              padding: AppSpacing.paddingLg,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.wb_twilight, color: secondary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEnglish ? 'Fajr time' : 'Heure du Fajr',
                            style: context.textStyles.bodyMedium?.copyWith(
                              color: onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeFormat.format(prayerService.fajrTime),
                            style: context.textStyles.headlineSmall?.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(color: onSurface.withValues(alpha: 0.1)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.dark_mode, color: primary, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEnglish
                                ? 'Last third of the night'
                                : 'Dernier tiers de la nuit',
                            style: context.textStyles.bodyMedium?.copyWith(
                              color: onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            timeFormat.format(prayerService.lastThirdTime),
                            style: context.textStyles.headlineSmall?.bold,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primary.withValues(alpha: 0.1),
                  secondary.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  isEnglish ? 'Countdown' : 'Compte à rebours',
                  style: context.textStyles.titleMedium?.copyWith(
                    color: onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  prayerService.formatCountdown(),
                  style: context.textStyles.displayMedium?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: AppSpacing.paddingLg,
            decoration: BoxDecoration(
              color: surfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Icon(Icons.auto_stories, color: primary, size: 32),
                const SizedBox(height: 16),
                Text(
                  isEnglish
                      ? 'Hadith (Sahih Bukhari & Muslim)'
                      : 'Hadith (Sahih Bukhari & Muslim)',
                  style: context.textStyles.titleSmall?.copyWith(
                    color: secondary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  isEnglish
                      ? 'Our Lord descends to the lowest heaven every night during the last third and says:'
                      : '« Notre Seigneur descend au ciel le plus bas, chaque nuit, durant le dernier tiers, et Il dit :',
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: onSurface,
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  isEnglish
                      ? '“Our Lord descends to the lowest heaven every night during the last third and says:\nWho calls upon Me so that I may answer him?\nWho asks Me so that I may give him?\nWho seeks My forgiveness so that I may forgive him?”'
                      : '"Qui M\'invoque afin que Je lui réponde ?\nQui Me demande afin que Je lui donne ?\nQui sollicite Mon pardon afin que Je lui pardonne ?"',
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: primary,
                    height: 1.8,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '»',
                  style: context.textStyles.bodyMedium?.copyWith(
                    color: onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
