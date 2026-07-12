import 'package:uuid/uuid.dart';

import 'enums.dart';

class StudySession {
  StudySession({
    String? id,
    required this.subject,
    required this.durationMinutes,
    required this.scheduledStart,
    this.examDate,
    this.difficulty = Difficulty.medium,
    this.stressLevel = StressLevel.medium,
    this.energyLevel = EnergyLevel.medium,
    this.goal = StudyGoal.understanding,
    this.musicTheme = MusicTheme.aquarium,
    this.pomodoroPreset = PomodoroPreset.classic25_5,
    this.status = SessionStatus.scheduled,
    this.subjectEmoji = '📚',
    this.notes,
    this.completedAt,
    this.focusChecks = const [],
    this.xpEarned = 0,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String subject;
  final String subjectEmoji;
  final int durationMinutes;
  final DateTime scheduledStart;
  final DateTime? examDate;
  final Difficulty difficulty;
  final StressLevel stressLevel;
  final EnergyLevel energyLevel;
  final StudyGoal goal;
  final MusicTheme musicTheme;
  final PomodoroPreset pomodoroPreset;
  final SessionStatus status;
  final String? notes;
  final DateTime? completedAt;
  final List<FocusCheckIn> focusChecks;
  final int xpEarned;

  DateTime get scheduledEnd =>
      scheduledStart.add(Duration(minutes: durationMinutes));

  StudySession copyWith({
    String? subject,
    String? subjectEmoji,
    int? durationMinutes,
    DateTime? scheduledStart,
    DateTime? examDate,
    Difficulty? difficulty,
    StressLevel? stressLevel,
    EnergyLevel? energyLevel,
    StudyGoal? goal,
    MusicTheme? musicTheme,
    PomodoroPreset? pomodoroPreset,
    SessionStatus? status,
    String? notes,
    DateTime? completedAt,
    List<FocusCheckIn>? focusChecks,
    int? xpEarned,
  }) {
    return StudySession(
      id: id,
      subject: subject ?? this.subject,
      subjectEmoji: subjectEmoji ?? this.subjectEmoji,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      examDate: examDate ?? this.examDate,
      difficulty: difficulty ?? this.difficulty,
      stressLevel: stressLevel ?? this.stressLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      goal: goal ?? this.goal,
      musicTheme: musicTheme ?? this.musicTheme,
      pomodoroPreset: pomodoroPreset ?? this.pomodoroPreset,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      completedAt: completedAt ?? this.completedAt,
      focusChecks: focusChecks ?? this.focusChecks,
      xpEarned: xpEarned ?? this.xpEarned,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'subjectEmoji': subjectEmoji,
        'durationMinutes': durationMinutes,
        'scheduledStart': scheduledStart.toIso8601String(),
        'examDate': examDate?.toIso8601String(),
        'difficulty': difficulty.name,
        'stressLevel': stressLevel.name,
        'energyLevel': energyLevel.name,
        'goal': goal.name,
        'musicTheme': musicTheme.name,
        'pomodoroPreset': pomodoroPreset.name,
        'status': status.name,
        'notes': notes,
        'completedAt': completedAt?.toIso8601String(),
        'focusChecks': focusChecks.map((e) => e.toJson()).toList(),
        'xpEarned': xpEarned,
      };

  factory StudySession.fromJson(Map<String, dynamic> json) {
    return StudySession(
      id: json['id'] as String,
      subject: json['subject'] as String,
      subjectEmoji: json['subjectEmoji'] as String? ?? '📚',
      durationMinutes: json['durationMinutes'] as int,
      scheduledStart: DateTime.parse(json['scheduledStart'] as String),
      examDate: json['examDate'] != null
          ? DateTime.parse(json['examDate'] as String)
          : null,
      difficulty: Difficulty.values.byName(json['difficulty'] as String),
      stressLevel: StressLevel.values.byName(json['stressLevel'] as String),
      energyLevel: EnergyLevel.values.byName(json['energyLevel'] as String),
      goal: StudyGoal.values.byName(json['goal'] as String),
      musicTheme: MusicTheme.values.byName(json['musicTheme'] as String),
      pomodoroPreset:
          PomodoroPreset.values.byName(json['pomodoroPreset'] as String),
      status: SessionStatus.values.byName(json['status'] as String),
      notes: json['notes'] as String?,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      focusChecks: (json['focusChecks'] as List<dynamic>? ?? [])
          .map((e) => FocusCheckIn.fromJson(e as Map<String, dynamic>))
          .toList(),
      xpEarned: json['xpEarned'] as int? ?? 0,
    );
  }
}

class FocusCheckIn {
  const FocusCheckIn({
    required this.timestamp,
    required this.level,
    required this.elapsedMinutes,
  });

  final DateTime timestamp;
  final FocusLevel level;
  final int elapsedMinutes;

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'level': level.name,
        'elapsedMinutes': elapsedMinutes,
      };

  factory FocusCheckIn.fromJson(Map<String, dynamic> json) {
    return FocusCheckIn(
      timestamp: DateTime.parse(json['timestamp'] as String),
      level: FocusLevel.values.byName(json['level'] as String),
      elapsedMinutes: json['elapsedMinutes'] as int,
    );
  }
}
