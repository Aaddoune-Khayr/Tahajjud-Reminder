import 'package:flutter/material.dart';
import 'package:khayr__tahajjud_reminder/models/duaa_model.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';
import 'package:khayr__tahajjud_reminder/theme.dart';
import 'package:provider/provider.dart';

class DuaaCard extends StatefulWidget {
  final DuaaModel duaa;

  const DuaaCard({super.key, required this.duaa});

  @override
  State<DuaaCard> createState() => _DuaaCardState();
}

class _DuaaCardState extends State<DuaaCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _expansionController;
  late Animation<double> _heightAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _expansionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _heightAnimation = CurvedAnimation(
      parent: _expansionController,
      curve: Curves.easeInOutCubic,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expansionController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    _expansionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>().settings;
    final isEnglish = settings.language == 'en';
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final surfaceVariant = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Card(
      margin: AppSpacing.verticalSm,
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                  if (_expanded) {
                    _expansionController.forward();
                  } else {
                    _expansionController.reverse();
                  }
                });
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.book_outlined, color: primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEnglish ? widget.duaa.titleEn : widget.duaa.titleFr,
                          style: context.textStyles.titleMedium?.semiBold,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.duaa.source,
                          style: context.textStyles.bodySmall?.copyWith(
                            color: secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    turns: _expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    child: Icon(
                      _expanded ? Icons.remove : Icons.add,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              sizeFactor: _heightAnimation,
              axisAlignment: -1.0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      padding: AppSpacing.paddingMd,
                      decoration: BoxDecoration(
                        color: surfaceVariant.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        widget.duaa.arabic,
                        style: context.textStyles.bodyLarge?.copyWith(
                          fontSize: 18,
                          height: 2.0,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isEnglish ? widget.duaa.translationEn : widget.duaa.translationFr,
                      style: context.textStyles.bodyMedium?.copyWith(
                        color: onSurface.withValues(alpha: 0.8),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
