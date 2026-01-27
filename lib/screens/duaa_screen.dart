import 'package:flutter/material.dart';
import 'package:khayr__tahajjud_reminder/components/duaa_card.dart';
import 'package:khayr__tahajjud_reminder/services/duaa_service.dart';
import 'package:khayr__tahajjud_reminder/services/settings_service.dart';
import 'package:khayr__tahajjud_reminder/theme.dart';
import 'package:provider/provider.dart';

class DuaaScreen extends StatelessWidget {
  const DuaaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final duaas = DuaaService.getAllDuaas();
    final settings = context.watch<SettingsService>().settings;
    final isEnglish = settings.language == 'en';
    final primary = Theme.of(context).colorScheme.primary;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
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
                          child: Icon(Icons.menu_book, color: primary, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isEnglish ? 'Du\'aa' : 'Du\'aa',
                                style: context.textStyles.headlineMedium?.bold,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isEnglish
                                    ? 'Authentic invocations for the night'
                                    : 'Invocations authentiques',
                                style: context.textStyles.bodyMedium?.copyWith(
                                  color: onSurface.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => DuaaCard(duaa: duaas[index]),
                  childCount: duaas.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
