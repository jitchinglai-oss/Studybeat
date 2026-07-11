import 'enums.dart';

/// Describes the adaptive soundscape parameters for the current moment.
class MusicState {
  const MusicState({
    required this.theme,
    required this.bpm,
    required this.richness,
    required this.ambientIntensity,
    required this.brightness,
    this.hasVocals = false,
    this.instruments = const [],
    this.ambientLayers = const [],
    this.transitionNote,
  });

  final MusicTheme theme;
  final int bpm;
  final double richness; // 0.0–1.0
  final double ambientIntensity; // 0.0–1.0
  final double brightness; // 0.0–1.0 (darker → brighter over session)
  final bool hasVocals;
  final List<String> instruments;
  final List<String> ambientLayers;
  final String? transitionNote;

  MusicState copyWith({
    MusicTheme? theme,
    int? bpm,
    double? richness,
    double? ambientIntensity,
    double? brightness,
    bool? hasVocals,
    List<String>? instruments,
    List<String>? ambientLayers,
    String? transitionNote,
  }) {
    return MusicState(
      theme: theme ?? this.theme,
      bpm: bpm ?? this.bpm,
      richness: richness ?? this.richness,
      ambientIntensity: ambientIntensity ?? this.ambientIntensity,
      brightness: brightness ?? this.brightness,
      hasVocals: hasVocals ?? this.hasVocals,
      instruments: instruments ?? this.instruments,
      ambientLayers: ambientLayers ?? this.ambientLayers,
      transitionNote: transitionNote ?? this.transitionNote,
    );
  }

  factory MusicState.forTheme(MusicTheme theme, {StressLevel? stress}) {
    final baseBpm = theme.defaultBpm;
    final stressAdjust = switch (stress) {
      StressLevel.high => -8,
      StressLevel.overwhelmed => -12,
      StressLevel.low => 2,
      _ => 0,
    };

    return MusicState(
      theme: theme,
      bpm: (baseBpm + stressAdjust).clamp(40, 100),
      richness: 0.45,
      ambientIntensity: stress == StressLevel.high ||
              stress == StressLevel.overwhelmed
          ? 0.7
          : 0.5,
      brightness: 0.3,
      hasVocals: false,
      instruments: _instrumentsFor(theme),
      ambientLayers: _ambientFor(theme),
      transitionNote: 'Session ambience initialized',
    );
  }

  static List<String> _instrumentsFor(MusicTheme theme) {
    switch (theme) {
      case MusicTheme.aquarium:
        return ['Soft piano', 'Gentle pads'];
      case MusicTheme.planetarium:
        return ['Warm synth pads', 'Slow piano'];
      case MusicTheme.library:
        return ['Soft piano', 'Muted strings'];
      case MusicTheme.forest:
        return ['Acoustic guitar', 'Soft flute'];
      case MusicTheme.electronic:
        return ['Lo-fi beats', 'Synth leads'];
      case MusicTheme.classical:
        return ['Solo piano', 'Cello', 'Strings'];
      case MusicTheme.coffeeShop:
        return ['Jazz piano', 'Upright bass'];
      case MusicTheme.fantasy:
        return ['Harp', 'Soft choir pads', 'Woodwinds'];
    }
  }

  static List<String> _ambientFor(MusicTheme theme) {
    switch (theme) {
      case MusicTheme.aquarium:
        return ['Ocean waves', 'Whale songs', 'Bubbles'];
      case MusicTheme.planetarium:
        return ['Space ambience', 'Distant stars'];
      case MusicTheme.library:
        return ['Fireplace', 'Paper rustle', 'Clock tick'];
      case MusicTheme.forest:
        return ['Rain', 'Birds', 'River', 'Wind'];
      case MusicTheme.electronic:
        return ['Vinyl crackle', 'Soft noise floor'];
      case MusicTheme.classical:
        return ['Hall reverb'];
      case MusicTheme.coffeeShop:
        return ['Cafe chatter', 'Espresso machine'];
      case MusicTheme.fantasy:
        return ['Forest wind', 'Temple echoes'];
    }
  }
}

class CoachInsight {
  const CoachInsight({
    required this.id,
    required this.message,
    required this.category,
    this.createdAt,
  });

  final String id;
  final String message;
  final String category; // productivity, focus, music, break
  final DateTime? createdAt;

  static List<CoachInsight> demoInsights() => [
        CoachInsight(
          id: '1',
          message:
              'You seem more productive during evening biology sessions.',
          category: 'productivity',
          createdAt: DateTime.now(),
        ),
        CoachInsight(
          id: '2',
          message:
              'Your focus drops after 40 minutes. Try a 10-minute break.',
          category: 'focus',
          createdAt: DateTime.now(),
        ),
        CoachInsight(
          id: '3',
          message:
              'You remember chemistry better with slower ambient music.',
          category: 'music',
          createdAt: DateTime.now(),
        ),
      ];
}
