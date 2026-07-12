import 'dart:math';

import '../models/enums.dart';
import '../models/music_state.dart';
import '../models/study_session.dart';

/// Adaptive music engine that evolves the soundscape throughout a session.
///
/// Phase 1 uses a rule-based engine. Phase 3 will swap this for
/// Stable Audio / Suno / ambient synthesis APIs while keeping the same interface.
class AdaptiveMusicEngine {
  MusicState initialize(StudySession session) {
    return MusicState.forTheme(
      session.musicTheme,
      stress: session.stressLevel,
    );
  }

  /// Called every focus check-in (~15 min) to adapt the soundscape.
  MusicState adapt({
    required MusicState current,
    required FocusLevel focus,
    required StressLevel stress,
    required int elapsedMinutes,
    required int totalMinutes,
  }) {
    var bpm = current.bpm;
    var richness = current.richness;
    var ambient = current.ambientIntensity;
    var brightness = current.brightness;
    String note;

    switch (focus) {
      case FocusLevel.excellent:
        richness = (richness + 0.12).clamp(0.2, 1.0);
        note = 'Focus excellent — enriching instrumentation';
      case FocusLevel.good:
        richness = (richness + 0.05).clamp(0.2, 1.0);
        note = 'Focus good — gently enriching layers';
      case FocusLevel.okay:
        note = 'Focus steady — holding current mix';
      case FocusLevel.distracted:
        richness = (richness - 0.15).clamp(0.15, 1.0);
        ambient = (ambient + 0.1).clamp(0.2, 1.0);
        note = 'Distracted — simplifying to fewer layers';
      case FocusLevel.overwhelmed:
        richness = (richness - 0.25).clamp(0.1, 1.0);
        bpm = (bpm - 6).clamp(40, 100);
        ambient = (ambient + 0.2).clamp(0.3, 1.0);
        note = 'Overwhelmed — slowing tempo, boosting ambience';
    }

    if (stress == StressLevel.high || stress == StressLevel.overwhelmed) {
      bpm = (bpm - 4).clamp(40, 100);
      ambient = (ambient + 0.08).clamp(0.2, 1.0);
    }

    // Gradually brighten after the midpoint of the session.
    final progress = totalMinutes == 0 ? 0.0 : elapsedMinutes / totalMinutes;
    if (progress > 0.5) {
      brightness = (0.3 + (progress - 0.5) * 0.8).clamp(0.3, 0.9);
      if (progress > 0.5 && note.contains('holding')) {
        note = 'Past midpoint — gradually brightening tone';
      }
    }

    return current.copyWith(
      bpm: bpm,
      richness: richness,
      ambientIntensity: ambient,
      brightness: brightness,
      transitionNote: note,
    );
  }

  /// Smooth transition when entering a Pomodoro break.
  MusicState forBreak(MusicState current) {
    return current.copyWith(
      bpm: (current.bpm - 10).clamp(40, 80),
      richness: (current.richness * 0.6).clamp(0.1, 1.0),
      ambientIntensity: (current.ambientIntensity + 0.15).clamp(0.2, 1.0),
      transitionNote: 'Break mode — softer, ambient-forward mix',
    );
  }

  MusicState forWorkResume(MusicState workingState) {
    return workingState.copyWith(
      transitionNote: 'Resuming study mix',
    );
  }

  /// Suggest a theme based on subject heuristics (demo AI).
  MusicTheme suggestTheme(String subject, StudyGoal goal) {
    final s = subject.toLowerCase();
    if (s.contains('bio') || s.contains('marine') || s.contains('chem')) {
      return MusicTheme.aquarium;
    }
    if (s.contains('astro') || s.contains('physics') || s.contains('space')) {
      return MusicTheme.planetarium;
    }
    if (s.contains('history') || s.contains('law') || s.contains('lit')) {
      return MusicTheme.library;
    }
    if (s.contains('cs') || s.contains('code') || s.contains('math')) {
      return MusicTheme.electronic;
    }
    if (s.contains('music') || s.contains('art')) {
      return MusicTheme.classical;
    }
    if (goal == StudyGoal.memorization) return MusicTheme.forest;
    return MusicTheme.aquarium;
  }
}

class AiCoachService {
  final _rng = Random();

  List<CoachInsight> generateInsights({
    required List<StudySession> completedSessions,
    required StressLevel currentMood,
  }) {
    if (completedSessions.isEmpty) {
      return CoachInsight.demoInsights();
    }

    final insights = <CoachInsight>[];
    final evening = completedSessions.where((s) {
      final h = s.scheduledStart.hour;
      return h >= 17 && h <= 22;
    }).length;

    if (evening >= 1) {
      final subject = completedSessions.first.subject;
      insights.add(CoachInsight(
        id: 'prod-${_rng.nextInt(9999)}',
        message:
            'You seem more productive during evening $subject sessions.',
        category: 'productivity',
        createdAt: DateTime.now(),
      ));
    }

    final longSessions =
        completedSessions.where((s) => s.durationMinutes >= 40).toList();
    if (longSessions.isNotEmpty) {
      insights.add(CoachInsight(
        id: 'focus-${_rng.nextInt(9999)}',
        message:
            'Your focus drops after 40 minutes. Try a 10-minute break.',
        category: 'focus',
        createdAt: DateTime.now(),
      ));
    }

    final ambient = completedSessions
        .where((s) =>
            s.musicTheme == MusicTheme.aquarium ||
            s.musicTheme == MusicTheme.forest ||
            s.musicTheme == MusicTheme.planetarium)
        .toList();
    if (ambient.isNotEmpty) {
      insights.add(CoachInsight(
        id: 'music-${_rng.nextInt(9999)}',
        message:
            'You remember ${ambient.first.subject.toLowerCase()} better with slower ambient music.',
        category: 'music',
        createdAt: DateTime.now(),
      ));
    }

    if (currentMood == StressLevel.high ||
        currentMood == StressLevel.overwhelmed) {
      insights.add(CoachInsight(
        id: 'stress-${_rng.nextInt(9999)}',
        message:
            'Stress is elevated. A Forest or Aquarium theme at ~50 BPM can help settle in.',
        category: 'break',
        createdAt: DateTime.now(),
      ));
    }

    return insights.isEmpty ? CoachInsight.demoInsights() : insights;
  }
}
