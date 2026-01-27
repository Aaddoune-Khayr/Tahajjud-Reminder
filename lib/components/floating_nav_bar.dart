import 'package:flutter/material.dart';
import 'package:khayr__tahajjud_reminder/theme.dart';
import 'package:provider/provider.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';

class FloatingNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>().settings;
    final isEnglish = settings.language == 'en';
    // No splash effects for a cleaner, modern feel
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: AppSpacing.paddingMd,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: isDark ? DarkModeColors.darkSurfaceVariant : surface,
          borderRadius: BorderRadius.circular(36),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.4)
                  : Colors.black.withValues(alpha: 0.1),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = constraints.maxWidth / 3;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  left: currentIndex * itemWidth,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: itemWidth,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavItem(
                      icon: Icons.settings_outlined,
                      label: isEnglish ? 'Settings' : 'Paramètres',
                      isActive: currentIndex == 0,
                      onTap: () => onTap(0),
                      primary: primary,
                      onSurface: onSurface,
                    ),
                    _NavItem(
                      icon: Icons.home_outlined,
                      label: isEnglish ? 'Home' : 'Accueil',
                      isActive: currentIndex == 1,
                      onTap: () => onTap(1),
                      primary: primary,
                      onSurface: onSurface,
                    ),
                    _NavItem(
                      icon: Icons.menu_book_outlined,
                      label: isEnglish ? 'Du\'aa' : 'Du\'aa',
                      isActive: currentIndex == 2,
                      onTap: () => onTap(2),
                      primary: primary,
                      onSurface: onSurface,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color primary;
  final Color onSurface;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.primary,
    required this.onSurface,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(36),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? primary : onSurface.withValues(alpha: 0.5),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.textStyles.labelSmall?.copyWith(
                color: isActive ? primary : onSurface.withValues(alpha: 0.5),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
