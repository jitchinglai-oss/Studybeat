import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../models/enums.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final colors = context.sbColors;

    return GradientScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Text('Settings', style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 24),
            SoftPanel(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: colors.primary.withValues(alpha: 0.3),
                    child: Text(
                      profile.displayName.isNotEmpty
                          ? profile.displayName[0].toUpperCase()
                          : 'S',
                      style: TextStyle(
                        fontSize: 24,
                        color: colors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile.displayName,
                            style: Theme.of(context).textTheme.titleLarge),
                        Text(
                          'Level ${profile.level} · ${profile.focusStreak}-day streak',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Themes', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ...AppColorTheme.values.map((t) {
              final c = StudybeatColors.forTheme(t);
              final selected = profile.colorTheme == t;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SoftPanel(
                  onTap: () =>
                      ref.read(userProfileProvider.notifier).setTheme(t),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [c.primary, c.accent],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(t.label,
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      if (selected)
                        Icon(Icons.check_circle, color: colors.accent),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            Text('Languages', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            SoftPanel(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.supportedLanguages.map((code) {
                  final selected = profile.language == code;
                  final labels = {
                    'en': 'English',
                    'es': 'Spanish',
                    'fr': 'French',
                    'de': 'German',
                    'zh': 'Chinese',
                    'ja': 'Japanese',
                    'ko': 'Korean',
                    'pt': 'Portuguese',
                    'ar': 'Arabic',
                  };
                  return ChoiceChip(
                    label: Text(labels[code] ?? code),
                    selected: selected,
                    onSelected: (_) {
                      ref.read(userProfileProvider.notifier).update(
                            profile.copyWith(language: code),
                          );
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Current Mood', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            SoftPanel(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: StressLevel.values.map((s) {
                  return ChoiceChip(
                    label: Text('${s.emoji} ${s.label}'),
                    selected: profile.currentMood == s,
                    onSelected: (_) =>
                        ref.read(userProfileProvider.notifier).setMood(s),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Music Preference',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            SoftPanel(
              child: Column(
                children: MusicTheme.values.map((t) {
                  final selected = profile.preferredMusicTheme == t;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(t.emoji, style: const TextStyle(fontSize: 22)),
                    title: Text(t.label),
                    trailing: selected
                        ? Icon(Icons.check_circle, color: colors.accent)
                        : null,
                    onTap: () {
                      ref.read(userProfileProvider.notifier).update(
                            profile.copyWith(preferredMusicTheme: t),
                          );
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Visual Backgrounds',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            SoftPanel(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: VisualBackground.values.map((v) {
                  return ChoiceChip(
                    label: Text(v.name),
                    selected: profile.preferredVisual == v,
                    onSelected: (_) {
                      ref.read(userProfileProvider.notifier).update(
                            profile.copyWith(preferredVisual: v),
                          );
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Achievements', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            SoftPanel(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _Badge(label: 'First Session', unlocked: profile.achievements.contains('first_session')),
                  _Badge(label: 'Week Streak', unlocked: profile.achievements.contains('week_streak')),
                  _Badge(label: 'Night Owl', unlocked: profile.achievements.contains('night_owl')),
                  _Badge(label: 'Marathon', unlocked: false),
                  _Badge(label: 'Zen Master', unlocked: false),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Studybeat Phase 1 · Local demo mode\nFirebase Auth & sync ready for Phase 1 deploy.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.unlocked});

  final String label;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final colors = context.sbColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: unlocked
            ? colors.accent.withValues(alpha: 0.15)
            : colors.surfaceElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: unlocked ? colors.accent.withValues(alpha: 0.4) : colors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            unlocked ? Icons.emoji_events_rounded : Icons.lock_outline,
            size: 16,
            color: unlocked ? colors.accent : colors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: unlocked ? colors.textPrimary : colors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
