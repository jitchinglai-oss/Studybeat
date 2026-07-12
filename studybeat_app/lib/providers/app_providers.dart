import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/local_storage_service.dart';
import '../data/repositories/study_repository.dart';
import '../models/enums.dart';
import '../models/music_state.dart';
import '../models/study_session.dart';
import '../models/user_profile.dart';
import '../services/adaptive_music_engine.dart';

final localStorageProvider = Provider((ref) => LocalStorageService());

final studyRepositoryProvider = Provider(
  (ref) => StudyRepository(ref.watch(localStorageProvider)),
);

final musicEngineProvider = Provider((ref) => AdaptiveMusicEngine());

final aiCoachProvider = Provider((ref) => AiCoachService());

final appBootstrapProvider = FutureProvider<void>((ref) async {
  final repo = ref.read(studyRepositoryProvider);
  final profile = await repo.getOrCreateProfile();
  if (!profile.onboardingComplete) {
    // Leave empty for onboarding; demo seed happens from onboarding/auth.
  } else {
    final sessions = await repo.getSessions();
    if (sessions.isEmpty) {
      await repo.seedDemo();
    }
  }
  await ref.read(userProfileProvider.notifier).reload();
  await ref.read(sessionsProvider.notifier).reload();
});

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() => UserProfile.demo();

  Future<void> reload() async {
    final repo = ref.read(studyRepositoryProvider);
    state = await repo.getOrCreateProfile(name: 'Jonah');
  }

  Future<void> update(UserProfile profile) async {
    await ref.read(studyRepositoryProvider).updateProfile(profile);
    state = profile;
  }

  Future<void> setTheme(AppColorTheme theme) async {
    await update(state.copyWith(colorTheme: theme));
  }

  Future<void> setMood(StressLevel mood) async {
    await update(state.copyWith(currentMood: mood));
  }

  Future<void> addXp(int xp) async {
    var total = state.totalXp + xp;
    var level = state.level;
    while (total >= level * 500) {
      total -= level * 500;
      level += 1;
    }
    await update(state.copyWith(totalXp: total, level: level));
  }
}

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfile>(UserProfileNotifier.new);

class SessionsNotifier extends Notifier<List<StudySession>> {
  @override
  List<StudySession> build() => [];

  Future<void> reload() async {
    state = await ref.read(studyRepositoryProvider).getSessions();
  }

  Future<void> upsert(StudySession session) async {
    await ref.read(studyRepositoryProvider).upsertSession(session);
    await reload();
  }

  Future<void> remove(String id) async {
    await ref.read(studyRepositoryProvider).deleteSession(id);
    await reload();
  }

  List<StudySession> get today {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return state
        .where((s) =>
            !s.scheduledStart.isBefore(start) &&
            s.scheduledStart.isBefore(end) &&
            s.status != SessionStatus.cancelled)
        .toList()
      ..sort((a, b) => a.scheduledStart.compareTo(b.scheduledStart));
  }

  List<StudySession> get completed => state
      .where((s) => s.status == SessionStatus.completed)
      .toList();
}

final sessionsProvider =
    NotifierProvider<SessionsNotifier, List<StudySession>>(SessionsNotifier.new);

final coachInsightsProvider = Provider<List<CoachInsight>>((ref) {
  final profile = ref.watch(userProfileProvider);
  final sessions = ref.watch(sessionsProvider);
  final coach = ref.watch(aiCoachProvider);
  return coach.generateInsights(
    completedSessions: sessions
        .where((s) => s.status == SessionStatus.completed)
        .toList(),
    currentMood: profile.currentMood,
  );
});

/// Active focus-mode session controller.
class ActiveSessionState {
  const ActiveSessionState({
    this.session,
    this.music,
    this.elapsed = Duration.zero,
    this.isRunning = false,
    this.isBreak = false,
    this.pomodoroElapsed = Duration.zero,
    this.showFocusCheck = false,
    this.workMusicSnapshot,
  });

  final StudySession? session;
  final MusicState? music;
  final Duration elapsed;
  final bool isRunning;
  final bool isBreak;
  final Duration pomodoroElapsed;
  final bool showFocusCheck;
  final MusicState? workMusicSnapshot;

  int get remainingSeconds {
    if (session == null) return 0;
    final total = Duration(minutes: session!.durationMinutes);
    return (total - elapsed).inSeconds.clamp(0, total.inSeconds);
  }

  double get progress {
    if (session == null || session!.durationMinutes == 0) return 0;
    return (elapsed.inSeconds / (session!.durationMinutes * 60))
        .clamp(0.0, 1.0);
  }

  int get secondsUntilBreak {
    if (session == null) return 0;
    final work = Duration(minutes: session!.pomodoroPreset.workMinutes);
    return (work - pomodoroElapsed).inSeconds.clamp(0, work.inSeconds);
  }

  ActiveSessionState copyWith({
    StudySession? session,
    MusicState? music,
    Duration? elapsed,
    bool? isRunning,
    bool? isBreak,
    Duration? pomodoroElapsed,
    bool? showFocusCheck,
    MusicState? workMusicSnapshot,
    bool clearSession = false,
  }) {
    return ActiveSessionState(
      session: clearSession ? null : (session ?? this.session),
      music: music ?? this.music,
      elapsed: elapsed ?? this.elapsed,
      isRunning: isRunning ?? this.isRunning,
      isBreak: isBreak ?? this.isBreak,
      pomodoroElapsed: pomodoroElapsed ?? this.pomodoroElapsed,
      showFocusCheck: showFocusCheck ?? this.showFocusCheck,
      workMusicSnapshot: workMusicSnapshot ?? this.workMusicSnapshot,
    );
  }
}

class ActiveSessionNotifier extends Notifier<ActiveSessionState> {
  @override
  ActiveSessionState build() => const ActiveSessionState();

  void start(StudySession session) {
    final music = ref.read(musicEngineProvider).initialize(session);
    state = ActiveSessionState(
      session: session.copyWith(status: SessionStatus.active),
      music: music,
      isRunning: true,
      workMusicSnapshot: music,
    );
  }

  void tick() {
    if (!state.isRunning || state.session == null) return;
    final elapsed = state.elapsed + const Duration(seconds: 1);
    final pomo = state.pomodoroElapsed + const Duration(seconds: 1);
    final session = state.session!;

    var next = state.copyWith(elapsed: elapsed, pomodoroElapsed: pomo);

    // Focus check every 15 minutes
    if (!state.isBreak &&
        elapsed.inMinutes > 0 &&
        elapsed.inMinutes % 15 == 0 &&
        elapsed.inSeconds % 60 == 0) {
      next = next.copyWith(showFocusCheck: true, isRunning: false);
    }

    // Pomodoro break transition
    if (!state.isBreak &&
        pomo.inMinutes >= session.pomodoroPreset.workMinutes &&
        pomo.inSeconds % 60 == 0) {
      final engine = ref.read(musicEngineProvider);
      next = next.copyWith(
        isBreak: true,
        pomodoroElapsed: Duration.zero,
        music: engine.forBreak(state.music!),
        workMusicSnapshot: state.music,
      );
    }

    // End break
    if (state.isBreak &&
        pomo.inMinutes >= session.pomodoroPreset.breakMinutes &&
        pomo.inSeconds % 60 == 0) {
      final engine = ref.read(musicEngineProvider);
      next = next.copyWith(
        isBreak: false,
        pomodoroElapsed: Duration.zero,
        music: engine.forWorkResume(state.workMusicSnapshot ?? state.music!),
      );
    }

    // Session complete
    if (elapsed.inMinutes >= session.durationMinutes) {
      complete();
      return;
    }

    state = next;
  }

  void togglePause() {
    state = state.copyWith(isRunning: !state.isRunning);
  }

  void submitFocusCheck(FocusLevel level) {
    if (state.session == null || state.music == null) return;
    final engine = ref.read(musicEngineProvider);
    final check = FocusCheckIn(
      timestamp: DateTime.now(),
      level: level,
      elapsedMinutes: state.elapsed.inMinutes,
    );
    final updatedChecks = [...state.session!.focusChecks, check];
    final adapted = engine.adapt(
      current: state.music!,
      focus: level,
      stress: state.session!.stressLevel,
      elapsedMinutes: state.elapsed.inMinutes,
      totalMinutes: state.session!.durationMinutes,
    );
    state = state.copyWith(
      session: state.session!.copyWith(focusChecks: updatedChecks),
      music: adapted,
      showFocusCheck: false,
      isRunning: true,
      workMusicSnapshot: adapted,
    );
  }

  Future<void> complete() async {
    if (state.session == null) return;
    final xp = (state.elapsed.inMinutes * 2).clamp(10, 300);
    final completed = state.session!.copyWith(
      status: SessionStatus.completed,
      completedAt: DateTime.now(),
      xpEarned: xp,
    );
    await ref.read(sessionsProvider.notifier).upsert(completed);
    await ref.read(userProfileProvider.notifier).addXp(xp);
    final profile = ref.read(userProfileProvider);
    await ref.read(userProfileProvider.notifier).update(
          profile.copyWith(focusStreak: profile.focusStreak + 1),
        );
    state = const ActiveSessionState();
  }

  void abandon() {
    state = const ActiveSessionState();
  }
}

final activeSessionProvider =
    NotifierProvider<ActiveSessionNotifier, ActiveSessionState>(
  ActiveSessionNotifier.new,
);
