import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../models/enums.dart';
import '../../models/user_profile.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nameController = TextEditingController(text: 'Jonah');
  int _step = 0;
  MusicTheme _theme = MusicTheme.aquarium;
  PomodoroPreset _pomodoro = PomodoroPreset.classic25_5;
  AppColorTheme _colorTheme = AppColorTheme.oceanBlue;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final repo = ref.read(studyRepositoryProvider);
    await repo.seedDemo();
    final profile = UserProfile(
      id: 'local-user',
      displayName: _nameController.text.trim().isEmpty
          ? 'Student'
          : _nameController.text.trim(),
      preferredMusicTheme: _theme,
      preferredPomodoro: _pomodoro,
      colorTheme: _colorTheme,
      focusStreak: 12,
      totalXp: 2450,
      level: 5,
      currentMood: StressLevel.medium,
      onboardingComplete: true,
      achievements: const ['first_session', 'week_streak', 'night_owl'],
    );
    await repo.updateProfile(profile);
    await repo.completeOnboarding();
    await ref.read(userProfileProvider.notifier).reload();
    await ref.read(sessionsProvider.notifier).reload();
    if (mounted) context.go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.sbColors;

    return GradientScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LinearProgressIndicator(
                value: (_step + 1) / 4,
                backgroundColor: colors.border,
                color: colors.accent,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 28),
              Expanded(child: _buildStep()),
              PrimaryButton(
                label: _step == 3 ? 'Enter Studybeat' : 'Continue',
                onPressed: () {
                  if (_step < 3) {
                    setState(() => _step++);
                  } else {
                    _finish();
                  }
                },
              ),
              if (_step > 0) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => _step--),
                  child: const Text('Back'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('What should we call you?',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Your name appears on the dashboard greeting.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              textCapitalization: TextCapitalization.words,
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pick a music vibe',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('You can change this per session.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: MusicTheme.values.map((t) {
                  final selected = _theme == t;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SoftPanel(
                      onTap: () => setState(() => _theme = t),
                      child: Row(
                        children: [
                          Text(t.emoji, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.label,
                                    style:
                                        Theme.of(context).textTheme.titleMedium),
                                Text(t.description,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          if (selected)
                            Icon(Icons.check_circle,
                                color: context.sbColors.accent),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pomodoro rhythm',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Music transitions automatically on breaks.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: PomodoroPreset.values
                  .where((p) => p != PomodoroPreset.custom)
                  .map((p) {
                final selected = _pomodoro == p;
                return ChoiceChip(
                  label: Text(p.label),
                  selected: selected,
                  onSelected: (_) => setState(() => _pomodoro = p),
                );
              }).toList(),
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose your look',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('Ocean Blue is the Studybeat signature.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: AppColorTheme.values.map((t) {
                  final c = StudybeatColors.forTheme(t);
                  final selected = _colorTheme == t;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: SoftPanel(
                      onTap: () => setState(() => _colorTheme = t),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [c.primary, c.accent],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(t.label,
                                style:
                                    Theme.of(context).textTheme.titleMedium),
                          ),
                          if (selected)
                            Icon(Icons.check_circle,
                                color: context.sbColors.accent),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
    }
  }
}
