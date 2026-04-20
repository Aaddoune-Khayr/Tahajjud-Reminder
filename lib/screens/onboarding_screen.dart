import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:khayr__tahajjud_reminder/services/alarm_service.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';
import 'package:khayr__tahajjud_reminder/theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final settingsService = context.read<SettingsService>();
    final alarmService = context.read<AlarmService>();

    // Demander manuellement les permissions de notification et alarme exacte
    await alarmService.requestPermission();

    await settingsService.completeOnboarding();
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>().settings;
    final isEnglish = settings.language == 'en';
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _finish,
                  child: Text(isEnglish ? 'Skip' : 'Passer'),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: [
                    _OnboardingPage(
                      icon: Icons.nights_stay,
                      title: isEnglish ? 'Welcome to Khayr' : 'Bienvenue dans Khayr',
                      description: isEnglish
                          ? 'A calm Tahajjud companion that reminds you of the last third of the night.'
                          : 'Un compagnon apaisant pour Tahajjud, qui vous rappelle le dernier tiers de la nuit.',
                    ),
                    _OnboardingPage(
                      icon: Icons.calculate,
                      title: isEnglish
                          ? 'MWL, ISNA or Egypt?'
                          : 'MWL, ISNA ou Égypte ?',
                      description: isEnglish
                          ? '• MWL – Standard Europe\n• ISNA – North America\n• Egypt – Arab countries (earlier Fajr)\n\nVery important for Tahajjud: the last third depends directly on the exact Fajr time. Changing the method will automatically adjust the alarm and countdown.'
                          : '• MWL – Standard Europe\n• ISNA – Amérique du Nord\n• Égypte – Pays arabes (Fajr plus tôt)\n\nTrès important pour Tahajjud : le dernier tiers dépend directement de l\'heure exacte du Fajr. Changer de méthode ajuste automatiquement l\'alarme et le compte à rebours.',
                    ),
                    _OnboardingPage(
                      icon: Icons.menu_book,
                      title: isEnglish
                          ? 'Du\'aa and soft reminders'
                          : 'Du\'aa et rappels doux',
                      description: isEnglish
                          ? 'Browse authentic night Du\'aa in a clean, collapsible list and let the Adhan wake you gently for Tahajjud.'
                          : 'Parcourez des Du\'aa authentiques de la nuit dans une liste pliable et laissez l\'Adhan vous réveiller en douceur pour Tahajjud.',
                    ),
                    _OnboardingPage(
                      icon: Icons.notifications_active,
                      title: isEnglish
                          ? 'Permissions Needed'
                          : 'Autorisations Requises',
                      description: isEnglish
                          ? 'To wake you up exactly on time, Khayr needs permission to send notifications and set exact alarms.\n\nPlease allow them on the next pop-ups.'
                          : 'Pour vous réveiller à l\'heure exacte pour Tahajjud, Khayr a besoin des autorisations de notifications et d\'alarmes exactes.\n\nMerci de les accepter dans les fenêtres suivantes.',
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 6,
                    width: isActive ? 20 : 8,
                    decoration: BoxDecoration(
                      color: isActive
                          ? primary
                          : onSurface.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == 3) {
                      _finish();
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    _currentPage == 3
                        ? (isEnglish ? 'Let\'s start' : 'Commencer')
                        : (isEnglish ? 'Next' : 'Suivant'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(icon, size: 48, color: primary),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: context.textStyles.titleLarge?.copyWith(
            color: secondary,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: context.textStyles.bodyMedium?.copyWith(
            color: onSurface.withValues(alpha: 0.8),
            height: 1.6,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
