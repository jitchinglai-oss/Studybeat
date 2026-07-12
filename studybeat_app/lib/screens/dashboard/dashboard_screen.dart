import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_theme.dart';
import '../../models/enums.dart';
import '../../models/study_session.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final sessions = ref.watch(sessionsProvider.notifier).today;
    final insights = ref.watch(coachInsightsProvider);
    final colors = context.sbColors;
    final timeFmt = DateFormat('h:mm a');

    return GradientScaffold(
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              sliver: SliverToBoxAdapter(
                child: GreetingHeader(
                  name: profile.displayName,
                  subtitle: 'Ready to build your study soundscape?',
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: StatTile(
                        label: 'Current Mood',
                        value: profile.currentMood.label,
                        emoji: profile.currentMood.emoji,
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StatTile(
                        label: 'Focus Streak',
                        value: '${profile.focusStreak} Days',
                        icon: Icons.local_fire_department_rounded,
                      ).animate().fadeIn(delay: 180.ms).slideY(begin: 0.1),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: SectionHeader(
                  title: "Today's Sessions",
                  action: TextButton.icon(
                    onPressed: () => context.push('/session/create'),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                  ),
                ),
              ),
            ),
            if (sessions.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: SoftPanel(
                    child: Text(
                      'No sessions yet. Add one to start your soundscape.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                sliver: SliverList.separated(
                  itemCount: sessions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final s = sessions[index];
                    return _SessionRow(
                      session: s,
                      timeLabel:
                          '${timeFmt.format(s.scheduledStart)} – ${timeFmt.format(s.scheduledEnd)}',
                      onStart: () {
                        ref.read(activeSessionProvider.notifier).start(s);
                        context.push('/focus/${s.id}');
                      },
                    )
                        .animate()
                        .fadeIn(delay: (80 * index).ms)
                        .slideX(begin: 0.04);
                  },
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: PrimaryButton(
                  label: sessions.isNotEmpty ? 'Start Session' : 'Add Study Session',
                  icon: sessions.isNotEmpty
                      ? Icons.play_arrow_rounded
                      : Icons.add_rounded,
                  onPressed: () {
                    if (sessions.isNotEmpty) {
                      final s = sessions.first;
                      ref.read(activeSessionProvider.notifier).start(s);
                      context.push('/focus/${s.id}');
                    } else {
                      context.push('/session/create');
                    }
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              sliver: SliverToBoxAdapter(
                child: SectionHeader(title: 'AI Coach'),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: SliverList.separated(
                itemCount: insights.take(3).length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final insight = insights[index];
                  return SoftPanel(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.auto_awesome, color: colors.accent, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            insight.message,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: (100 * index).ms);
                },
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              sliver: SliverToBoxAdapter(
                child: SoftPanel(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Level ${profile.level}',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 4),
                            Text('${profile.totalXp} XP · ${profile.xpToNextLevel - (profile.totalXp % profile.xpToNextLevel)} to next',
                                style: Theme.of(context).textTheme.bodyMedium),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: profile.levelProgress,
                                minHeight: 8,
                                backgroundColor: colors.border,
                                color: colors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('⚡', style: TextStyle(fontSize: 32)),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.session,
    required this.timeLabel,
    required this.onStart,
  });

  final StudySession session;
  final String timeLabel;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final colors = context.sbColors;
    return SoftPanel(
      onTap: onStart,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(session.subjectEmoji,
                style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(session.subject,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(timeLabel, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  '${session.musicTheme.emoji} ${session.musicTheme.label} · ${session.durationMinutes} min',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colors.accent,
                        fontSize: 12,
                      ),
                ),
              ],
            ),
          ),
          Icon(Icons.play_circle_fill_rounded,
              color: colors.accent, size: 36),
        ],
      ),
    );
  }
}
