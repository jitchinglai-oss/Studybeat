import 'package:flutter_test/flutter_test.dart';
import 'package:studybeat/models/enums.dart';
import 'package:studybeat/models/study_session.dart';
import 'package:studybeat/services/adaptive_music_engine.dart';

void main() {
  group('AdaptiveMusicEngine', () {
    final engine = AdaptiveMusicEngine();

    test('initializes aquarium theme at reduced BPM when stressed', () {
      final session = StudySession(
        subject: 'Biology',
        durationMinutes: 90,
        scheduledStart: DateTime.now(),
        musicTheme: MusicTheme.aquarium,
        stressLevel: StressLevel.high,
      );
      final state = engine.initialize(session);
      expect(state.theme, MusicTheme.aquarium);
      expect(state.bpm, lessThan(MusicTheme.aquarium.defaultBpm));
      expect(state.hasVocals, isFalse);
      expect(state.ambientLayers, contains('Ocean waves'));
    });

    test('enriches music when focus is excellent', () {
      final session = StudySession(
        subject: 'Chemistry',
        durationMinutes: 60,
        scheduledStart: DateTime.now(),
        musicTheme: MusicTheme.planetarium,
      );
      final initial = engine.initialize(session);
      final adapted = engine.adapt(
        current: initial,
        focus: FocusLevel.excellent,
        stress: StressLevel.low,
        elapsedMinutes: 15,
        totalMinutes: 60,
      );
      expect(adapted.richness, greaterThan(initial.richness));
    });

    test('simplifies and slows when overwhelmed', () {
      final session = StudySession(
        subject: 'Math',
        durationMinutes: 60,
        scheduledStart: DateTime.now(),
        musicTheme: MusicTheme.electronic,
        stressLevel: StressLevel.overwhelmed,
      );
      final initial = engine.initialize(session);
      final adapted = engine.adapt(
        current: initial,
        focus: FocusLevel.overwhelmed,
        stress: StressLevel.overwhelmed,
        elapsedMinutes: 30,
        totalMinutes: 60,
      );
      expect(adapted.richness, lessThan(initial.richness));
      expect(adapted.bpm, lessThanOrEqualTo(initial.bpm));
      expect(adapted.ambientIntensity, greaterThanOrEqualTo(initial.ambientIntensity));
    });

    test('suggests aquarium for biology', () {
      expect(
        engine.suggestTheme('Biology', StudyGoal.memorization),
        MusicTheme.aquarium,
      );
    });

    test('brightens after midpoint', () {
      final session = StudySession(
        subject: 'History',
        durationMinutes: 90,
        scheduledStart: DateTime.now(),
        musicTheme: MusicTheme.library,
      );
      final initial = engine.initialize(session);
      final adapted = engine.adapt(
        current: initial,
        focus: FocusLevel.good,
        stress: StressLevel.medium,
        elapsedMinutes: 50,
        totalMinutes: 90,
      );
      expect(adapted.brightness, greaterThan(initial.brightness));
    });
  });

  group('StudySession', () {
    test('serializes round-trip', () {
      final session = StudySession(
        subject: 'Biochemistry',
        durationMinutes: 90,
        scheduledStart: DateTime(2026, 7, 11, 19),
        stressLevel: StressLevel.high,
        energyLevel: EnergyLevel.medium,
        goal: StudyGoal.memorization,
        musicTheme: MusicTheme.aquarium,
      );
      final json = session.toJson();
      final restored = StudySession.fromJson(json);
      expect(restored.subject, 'Biochemistry');
      expect(restored.durationMinutes, 90);
      expect(restored.stressLevel, StressLevel.high);
      expect(restored.musicTheme, MusicTheme.aquarium);
    });
  });
}
