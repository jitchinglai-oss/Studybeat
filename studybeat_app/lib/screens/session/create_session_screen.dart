import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../models/enums.dart';
import '../../models/study_session.dart';
import '../../providers/app_providers.dart';
import '../../widgets/common_widgets.dart';

class CreateSessionScreen extends ConsumerStatefulWidget {
  const CreateSessionScreen({super.key});

  @override
  ConsumerState<CreateSessionScreen> createState() =>
      _CreateSessionScreenState();
}

class _CreateSessionScreenState extends ConsumerState<CreateSessionScreen> {
  final _subjectController = TextEditingController(text: 'Biochemistry');
  int _duration = 90;
  Difficulty _difficulty = Difficulty.medium;
  StressLevel _stress = StressLevel.high;
  EnergyLevel _energy = EnergyLevel.medium;
  StudyGoal _goal = StudyGoal.memorization;
  MusicTheme _theme = MusicTheme.aquarium;
  PomodoroPreset _pomodoro = PomodoroPreset.deep45_10;
  final DateTime _start = DateTime.now().add(const Duration(minutes: 5));

  final _emojiOptions = ['📚', '🧪', '🧬', '∑', '📜', '💻', '🌍', '🎨'];
  String _emoji = '🧬';

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _save({bool startNow = false}) async {
    final engine = ref.read(musicEngineProvider);
    final subject = _subjectController.text.trim();
    if (subject.isEmpty) return;

    final suggested = engine.suggestTheme(subject, _goal);
    final theme = _theme;

    final session = StudySession(
      subject: subject,
      subjectEmoji: _emoji,
      durationMinutes: _duration,
      scheduledStart: startNow ? DateTime.now() : _start,
      difficulty: _difficulty,
      stressLevel: _stress,
      energyLevel: _energy,
      goal: _goal,
      musicTheme: theme,
      pomodoroPreset: _pomodoro,
      status: SessionStatus.scheduled,
      notes: theme == suggested
          ? null
          : 'AI suggested ${suggested.label}; you chose ${theme.label}',
    );

    await ref.read(sessionsProvider.notifier).upsert(session);

    if (!mounted) return;
    if (startNow) {
      ref.read(activeSessionProvider.notifier).start(session);
      context.pushReplacement('/focus/${session.id}');
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        title: const Text('Add Study Session'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            TextField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                hintText: 'e.g. Biochemistry',
              ),
              onChanged: (_) {
                final suggested = ref
                    .read(musicEngineProvider)
                    .suggestTheme(_subjectController.text, _goal);
                setState(() => _theme = suggested);
              },
            ),
            const SizedBox(height: 16),
            Text('Emoji', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _emojiOptions.map((e) {
                return ChoiceChip(
                  label: Text(e),
                  selected: _emoji == e,
                  onSelected: (_) => setState(() => _emoji = e),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('Duration · $_duration minutes',
                style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _duration.toDouble(),
              min: 15,
              max: 180,
              divisions: 33,
              label: '$_duration min',
              onChanged: (v) => setState(() => _duration = v.round()),
            ),
            const SizedBox(height: 8),
            Text('Difficulty', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: Difficulty.values.map((d) {
                return ChoiceChip(
                  label: Text(d.name),
                  selected: _difficulty == d,
                  onSelected: (_) => setState(() => _difficulty = d),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Stress Level', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: StressLevel.values.map((s) {
                return ChoiceChip(
                  label: Text('${s.emoji} ${s.label}'),
                  selected: _stress == s,
                  onSelected: (_) => setState(() => _stress = s),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Energy Level', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: EnergyLevel.values.map((e) {
                return ChoiceChip(
                  label: Text(e.name),
                  selected: _energy == e,
                  onSelected: (_) => setState(() => _energy = e),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Goal', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: StudyGoal.values.map((g) {
                return ChoiceChip(
                  label: Text(g.name),
                  selected: _goal == g,
                  onSelected: (_) {
                    setState(() {
                      _goal = g;
                      _theme = ref
                          .read(musicEngineProvider)
                          .suggestTheme(_subjectController.text, g);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text('Music Theme', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...MusicTheme.values.map((t) {
              final selected = _theme == t;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SoftPanel(
                  onTap: () => setState(() => _theme = t),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Text(t.emoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.label,
                                style: Theme.of(context).textTheme.titleMedium),
                            Text('${t.description} · ${t.defaultBpm} BPM',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                      if (selected)
                        Icon(Icons.check_circle, color: context.sbColors.accent),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
            Text('Pomodoro', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: PomodoroPreset.values
                  .where((p) => p != PomodoroPreset.custom)
                  .map((p) {
                return ChoiceChip(
                  label: Text(p.label),
                  selected: _pomodoro == p,
                  onSelected: (_) => setState(() => _pomodoro = p),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              label: 'Start Now',
              icon: Icons.play_arrow_rounded,
              onPressed: () => _save(startNow: true),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => _save(startNow: false),
              child: const Text('Save to Schedule'),
            ),
          ],
        ),
      ),
    );
  }
}
