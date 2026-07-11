import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/enums.dart';
import '../../models/study_session.dart';
import '../../models/user_profile.dart';

class LocalStorageService {
  static const _profileKey = 'studybeat_profile';
  static const _sessionsKey = 'studybeat_sessions';
  static const _onboardingKey = 'studybeat_onboarding';

  Future<UserProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null) return null;
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<List<StudySession>> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_sessionsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => StudySession.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveSessions(List<StudySession> sessions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await prefs.setString(_sessionsKey, encoded);
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }

  Future<void> setOnboardingComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, value);
  }

  Future<void> seedDemoData() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final profile = UserProfile.demo();
    final sessions = [
      StudySession(
        subject: 'Biology',
        subjectEmoji: '📚',
        durationMinutes: 90,
        scheduledStart: today.add(const Duration(hours: 19)),
        difficulty: Difficulty.medium,
        stressLevel: StressLevel.medium,
        energyLevel: EnergyLevel.medium,
        goal: StudyGoal.memorization,
        musicTheme: MusicTheme.aquarium,
        pomodoroPreset: PomodoroPreset.deep45_10,
        status: SessionStatus.scheduled,
      ),
      StudySession(
        subject: 'Chemistry',
        subjectEmoji: '🧪',
        durationMinutes: 60,
        scheduledStart: today.add(const Duration(hours: 21)),
        difficulty: Difficulty.hard,
        stressLevel: StressLevel.high,
        energyLevel: EnergyLevel.medium,
        goal: StudyGoal.understanding,
        musicTheme: MusicTheme.planetarium,
        pomodoroPreset: PomodoroPreset.classic25_5,
        status: SessionStatus.scheduled,
      ),
      StudySession(
        subject: 'Biochemistry',
        subjectEmoji: '🧬',
        durationMinutes: 90,
        scheduledStart: today.subtract(const Duration(days: 1, hours: -18)),
        difficulty: Difficulty.hard,
        stressLevel: StressLevel.high,
        energyLevel: EnergyLevel.medium,
        goal: StudyGoal.memorization,
        musicTheme: MusicTheme.aquarium,
        status: SessionStatus.completed,
        completedAt: today.subtract(const Duration(days: 1, hours: -19, minutes: -30)),
        xpEarned: 180,
        focusChecks: [
          FocusCheckIn(
            timestamp: today.subtract(const Duration(days: 1, hours: -18, minutes: -15)),
            level: FocusLevel.good,
            elapsedMinutes: 15,
          ),
          FocusCheckIn(
            timestamp: today.subtract(const Duration(days: 1, hours: -18, minutes: -30)),
            level: FocusLevel.excellent,
            elapsedMinutes: 30,
          ),
          FocusCheckIn(
            timestamp: today.subtract(const Duration(days: 1, hours: -18, minutes: -45)),
            level: FocusLevel.okay,
            elapsedMinutes: 45,
          ),
        ],
      ),
      StudySession(
        subject: 'History',
        subjectEmoji: '📜',
        durationMinutes: 45,
        scheduledStart: today.subtract(const Duration(days: 2, hours: -16)),
        musicTheme: MusicTheme.library,
        status: SessionStatus.completed,
        completedAt: today.subtract(const Duration(days: 2, hours: -16, minutes: -45)),
        xpEarned: 90,
      ),
      StudySession(
        subject: 'Mathematics',
        subjectEmoji: '∑',
        durationMinutes: 60,
        scheduledStart: today.subtract(const Duration(days: 3, hours: -14)),
        musicTheme: MusicTheme.electronic,
        status: SessionStatus.completed,
        completedAt: today.subtract(const Duration(days: 3, hours: -15)),
        xpEarned: 120,
      ),
    ];

    await saveProfile(profile);
    await saveSessions(sessions);
    await setOnboardingComplete(true);
  }
}
