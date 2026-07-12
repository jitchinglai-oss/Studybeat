import '../../models/enums.dart';
import '../../models/study_session.dart';
import '../../models/user_profile.dart';
import '../local/local_storage_service.dart';

/// Repository abstraction — swap LocalStorageService for Firestore later.
class StudyRepository {
  StudyRepository(this._local);

  final LocalStorageService _local;

  Future<UserProfile> getOrCreateProfile({String? name}) async {
    final existing = await _local.loadProfile();
    if (existing != null) return existing;
    final profile = UserProfile(
      id: 'local-user',
      displayName: name ?? 'Student',
      onboardingComplete: false,
    );
    await _local.saveProfile(profile);
    return profile;
  }

  Future<void> updateProfile(UserProfile profile) =>
      _local.saveProfile(profile);

  Future<List<StudySession>> getSessions() => _local.loadSessions();

  Future<void> upsertSession(StudySession session) async {
    final sessions = await _local.loadSessions();
    final idx = sessions.indexWhere((s) => s.id == session.id);
    if (idx >= 0) {
      sessions[idx] = session;
    } else {
      sessions.add(session);
    }
    sessions.sort((a, b) => a.scheduledStart.compareTo(b.scheduledStart));
    await _local.saveSessions(sessions);
  }

  Future<void> deleteSession(String id) async {
    final sessions = await _local.loadSessions();
    sessions.removeWhere((s) => s.id == id);
    await _local.saveSessions(sessions);
  }

  Future<List<StudySession>> todaysSessions() async {
    final sessions = await getSessions();
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return sessions
        .where((s) =>
            !s.scheduledStart.isBefore(start) && s.scheduledStart.isBefore(end))
        .toList();
  }

  Future<List<StudySession>> completedSessions({int days = 30}) async {
    final sessions = await getSessions();
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return sessions
        .where((s) =>
            s.status == SessionStatus.completed &&
            (s.completedAt ?? s.scheduledStart).isAfter(cutoff))
        .toList();
  }

  Future<void> seedDemo() => _local.seedDemoData();

  Future<bool> isOnboardingComplete() => _local.isOnboardingComplete();

  Future<void> completeOnboarding() => _local.setOnboardingComplete(true);
}
