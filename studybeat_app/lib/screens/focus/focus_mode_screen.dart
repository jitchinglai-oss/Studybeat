import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../core/theme/app_theme.dart';
import '../../models/enums.dart';
import '../../models/music_state.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';

class FocusModeScreen extends ConsumerStatefulWidget {
  const FocusModeScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<FocusModeScreen> createState() => _FocusModeScreenState();
}

class _FocusModeScreenState extends ConsumerState<FocusModeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      ref.read(activeSessionProvider.notifier).tick();
      final active = ref.read(activeSessionProvider);
      if (active.session == null && mounted) {
        context.go('/dashboard');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final active = ref.watch(activeSessionProvider);
    final session = active.session;
    final music = active.music;
    final colors = context.sbColors;

    if (session == null) {
      return GradientScaffold(
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return GradientScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref.read(activeSessionProvider.notifier).abandon();
                          context.go('/dashboard');
                        },
                        icon: const Icon(Icons.close),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colors.surfaceElevated,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: colors.border),
                        ),
                        child: Text(
                          active.isBreak ? 'Break' : 'Focus Mode',
                          style: TextStyle(
                            color: colors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    session.subject,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: colors.textSecondary,
                        ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 20),
                  Text(
                    _format(active.remainingSeconds),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 72,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -2,
                        ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 28),
                  LinearPercentIndicator(
                    lineHeight: 10,
                    percent: active.progress,
                    backgroundColor: colors.border,
                    progressColor: colors.accent,
                    barRadius: const Radius.circular(6),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    active.isBreak
                        ? 'Break · ${_format(active.secondsUntilBreak)} left'
                        : 'Next break · ${_format(active.secondsUntilBreak)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  if (music != null) _MusicPanel(music: music),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _CircleAction(
                        icon: active.isRunning
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        onTap: () => ref
                            .read(activeSessionProvider.notifier)
                            .togglePause(),
                      ),
                      const SizedBox(width: 20),
                      _CircleAction(
                        icon: Icons.check_rounded,
                        filled: true,
                        onTap: () async {
                          await ref
                              .read(activeSessionProvider.notifier)
                              .complete();
                          if (context.mounted) context.go('/dashboard');
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
            if (active.showFocusCheck) const _FocusCheckOverlay(),
          ],
        ),
      ),
    );
  }
}

class _MusicPanel extends StatelessWidget {
  const _MusicPanel({required this.music});

  final MusicState music;

  @override
  Widget build(BuildContext context) {
    final colors = context.sbColors;
    return SoftPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(music.theme.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                '${music.theme.label} · ${music.bpm} BPM',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              Icon(Icons.graphic_eq_rounded, color: colors.accent, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            music.instruments.join(' · '),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            music.ambientLayers.join(' · '),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (music.transitionNote != null) ...[
            const SizedBox(height: 8),
            Text(
              music.transitionNote!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors.accent,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              _meter(context, 'Rich', music.richness),
              const SizedBox(width: 8),
              _meter(context, 'Ambient', music.ambientIntensity),
              const SizedBox(width: 8),
              _meter(context, 'Bright', music.brightness),
            ],
          ),
        ],
      ),
    );
  }

  Widget _meter(BuildContext context, String label, double value) {
    final colors = context.sbColors;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 11)),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: colors.border,
              color: colors.primarySoft,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colors = context.sbColors;
    return Material(
      color: filled ? colors.accent : colors.surfaceElevated,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 64,
          height: 64,
          child: Icon(
            icon,
            size: 32,
            color: filled ? colors.background : colors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _FocusCheckOverlay extends ConsumerWidget {
  const _FocusCheckOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.sbColors;
    return Positioned.fill(
      child: Container(
        color: colors.background.withValues(alpha: 0.92),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'How focused are you?',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn().slideY(begin: 0.1),
                const SizedBox(height: 8),
                Text(
                  'Your soundscape will adapt.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 28),
                ...FocusLevel.values.map((level) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SoftPanel(
                      onTap: () => ref
                          .read(activeSessionProvider.notifier)
                          .submitFocusCheck(level),
                      child: Row(
                        children: [
                          Text(level.emoji,
                              style: const TextStyle(fontSize: 28)),
                          const SizedBox(width: 14),
                          Text(level.label,
                              style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                    ).animate().fadeIn(delay: (60 * level.index).ms),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
