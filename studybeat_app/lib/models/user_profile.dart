import 'enums.dart';

class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    this.email,
    this.language = 'en',
    this.colorTheme = AppColorTheme.oceanBlue,
    this.preferredMusicTheme = MusicTheme.aquarium,
    this.preferredVisual = VisualBackground.aquarium,
    this.focusStreak = 0,
    this.totalXp = 0,
    this.level = 1,
    this.currentMood = StressLevel.medium,
    this.onboardingComplete = false,
    this.preferredPomodoro = PomodoroPreset.classic25_5,
    this.achievements = const [],
  });

  final String id;
  final String displayName;
  final String? email;
  final String language;
  final AppColorTheme colorTheme;
  final MusicTheme preferredMusicTheme;
  final VisualBackground preferredVisual;
  final int focusStreak;
  final int totalXp;
  final int level;
  final StressLevel currentMood;
  final bool onboardingComplete;
  final PomodoroPreset preferredPomodoro;
  final List<String> achievements;

  int get xpToNextLevel => level * 500;
  double get levelProgress => (totalXp % xpToNextLevel) / xpToNextLevel;

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? language,
    AppColorTheme? colorTheme,
    MusicTheme? preferredMusicTheme,
    VisualBackground? preferredVisual,
    int? focusStreak,
    int? totalXp,
    int? level,
    StressLevel? currentMood,
    bool? onboardingComplete,
    PomodoroPreset? preferredPomodoro,
    List<String>? achievements,
  }) {
    return UserProfile(
      id: id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      language: language ?? this.language,
      colorTheme: colorTheme ?? this.colorTheme,
      preferredMusicTheme: preferredMusicTheme ?? this.preferredMusicTheme,
      preferredVisual: preferredVisual ?? this.preferredVisual,
      focusStreak: focusStreak ?? this.focusStreak,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      currentMood: currentMood ?? this.currentMood,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      preferredPomodoro: preferredPomodoro ?? this.preferredPomodoro,
      achievements: achievements ?? this.achievements,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'displayName': displayName,
        'email': email,
        'language': language,
        'colorTheme': colorTheme.name,
        'preferredMusicTheme': preferredMusicTheme.name,
        'preferredVisual': preferredVisual.name,
        'focusStreak': focusStreak,
        'totalXp': totalXp,
        'level': level,
        'currentMood': currentMood.name,
        'onboardingComplete': onboardingComplete,
        'preferredPomodoro': preferredPomodoro.name,
        'achievements': achievements,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String?,
      language: json['language'] as String? ?? 'en',
      colorTheme: AppColorTheme.values.byName(
        json['colorTheme'] as String? ?? 'oceanBlue',
      ),
      preferredMusicTheme: MusicTheme.values.byName(
        json['preferredMusicTheme'] as String? ?? 'aquarium',
      ),
      preferredVisual: VisualBackground.values.byName(
        json['preferredVisual'] as String? ?? 'aquarium',
      ),
      focusStreak: json['focusStreak'] as int? ?? 0,
      totalXp: json['totalXp'] as int? ?? 0,
      level: json['level'] as int? ?? 1,
      currentMood: StressLevel.values.byName(
        json['currentMood'] as String? ?? 'medium',
      ),
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      preferredPomodoro: PomodoroPreset.values.byName(
        json['preferredPomodoro'] as String? ?? 'classic25_5',
      ),
      achievements: (json['achievements'] as List<dynamic>? ?? [])
          .map((e) => e as String)
          .toList(),
    );
  }

  static UserProfile demo() => const UserProfile(
        id: 'demo-user',
        displayName: 'Jonah',
        email: 'jonah@studybeat.app',
        focusStreak: 12,
        totalXp: 2450,
        level: 5,
        currentMood: StressLevel.medium,
        onboardingComplete: true,
        achievements: ['first_session', 'week_streak', 'night_owl'],
      );
}
