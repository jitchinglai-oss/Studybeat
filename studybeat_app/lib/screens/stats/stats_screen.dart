import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/enums.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/simple_bar_chart.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  String _range = 'Weekly';

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(sessionsProvider);
    final completed =
        sessions.where((s) => s.status == SessionStatus.completed).toList();

    final totalMinutes =
        completed.fold<int>(0, (sum, s) => sum + s.durationMinutes);
    final totalHours = (totalMinutes / 60).toStringAsFixed(1);
    final longest = completed.isEmpty
        ? 0
        : completed
            .map((s) => s.durationMinutes)
            .reduce((a, b) => a > b ? a : b);

    final themeCounts = <MusicTheme, int>{};
    for (final s in completed) {
      themeCounts[s.musicTheme] = (themeCounts[s.musicTheme] ?? 0) + 1;
    }
    final favoriteTheme = themeCounts.isEmpty
        ? null
        : themeCounts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;

    final dayHours = List<double>.filled(7, 0);
    for (final s in completed) {
      final day = (s.completedAt ?? s.scheduledStart).weekday % 7;
      dayHours[day] += s.durationMinutes / 60.0;
    }
    final mostProductiveIdx =
        dayHours.indexOf(dayHours.reduce((a, b) => a > b ? a : b));
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return GradientScaffold(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            Text('Statistics', style: Theme.of(context).textTheme.displayMedium)
                .animate()
                .fadeIn(),
            const SizedBox(height: 16),
            Row(
              children: ['Daily', 'Weekly', 'Monthly'].map((r) {
                final selected = _range == r;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(r),
                    selected: selected,
                    onSelected: (_) => setState(() => _range = r),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: 'Study Hours',
                    value: '${totalHours}h',
                    icon: Icons.schedule_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    label: 'Sessions',
                    value: '${completed.length}',
                    icon: Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    label: 'Longest',
                    value: '${longest}m',
                    icon: Icons.timelapse_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    label: 'Top Day',
                    value: dayNames[mostProductiveIdx],
                    icon: Icons.calendar_today_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SoftPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Study Hours',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                  SimpleBarChart(
                    values: dayHours,
                    labels: dayNames,
                    highlightIndex: mostProductiveIdx,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 16),
            SoftPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Favorite Theme',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  if (favoriteTheme == null)
                    Text('Complete a session to unlock insights.',
                        style: Theme.of(context).textTheme.bodyMedium)
                  else
                    Row(
                      children: [
                        Text(favoriteTheme.emoji,
                            style: const TextStyle(fontSize: 36)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(favoriteTheme.label,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Text(favoriteTheme.description,
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SoftPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Focus & Stress',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  Text(
                    'Focus checks and stress trends appear here as you complete adaptive sessions.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  ...completed.take(3).expand((s) => s.focusChecks).take(5).map(
                    (c) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        children: [
                          Text(c.level.emoji),
                          const SizedBox(width: 8),
                          Text(
                            '${c.level.label} at ${c.elapsedMinutes} min',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
