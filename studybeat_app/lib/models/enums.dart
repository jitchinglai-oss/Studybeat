enum StressLevel { low, medium, high, overwhelmed }

enum EnergyLevel { low, medium, high }

enum FocusLevel { excellent, good, okay, distracted, overwhelmed }

enum Difficulty { easy, medium, hard, examPrep }

enum StudyGoal { memorization, understanding, practice, review, examPrep }

enum MusicTheme {
  aquarium,
  planetarium,
  library,
  forest,
  electronic,
  classical,
  coffeeShop,
  fantasy,
}

enum AppColorTheme {
  oceanBlue,
  forestGreen,
  lavender,
  darkMode,
  solarOrange,
  midnightPurple,
  minimalWhite,
}

enum PomodoroPreset { classic25_5, deep45_10, long50_10, marathon90_20, custom }

enum SessionStatus { scheduled, active, paused, breakTime, completed, cancelled }

enum VisualBackground {
  aquarium,
  planetarium,
  galaxy,
  forest,
  rain,
  snow,
  northernLights,
  mountains,
  none,
}

extension StressLevelX on StressLevel {
  String get label {
    switch (this) {
      case StressLevel.low:
        return 'Calm';
      case StressLevel.medium:
        return 'Slightly Stressed';
      case StressLevel.high:
        return 'Stressed';
      case StressLevel.overwhelmed:
        return 'Overwhelmed';
    }
  }

  String get emoji {
    switch (this) {
      case StressLevel.low:
        return '😌';
      case StressLevel.medium:
        return '🙂';
      case StressLevel.high:
        return '😰';
      case StressLevel.overwhelmed:
        return '😫';
    }
  }
}

extension FocusLevelX on FocusLevel {
  String get label {
    switch (this) {
      case FocusLevel.excellent:
        return 'Excellent';
      case FocusLevel.good:
        return 'Good';
      case FocusLevel.okay:
        return 'Okay';
      case FocusLevel.distracted:
        return 'Distracted';
      case FocusLevel.overwhelmed:
        return 'Overwhelmed';
    }
  }

  String get emoji {
    switch (this) {
      case FocusLevel.excellent:
        return '😀';
      case FocusLevel.good:
        return '🙂';
      case FocusLevel.okay:
        return '😕';
      case FocusLevel.distracted:
        return '😣';
      case FocusLevel.overwhelmed:
        return '😫';
    }
  }
}

extension MusicThemeX on MusicTheme {
  String get label {
    switch (this) {
      case MusicTheme.aquarium:
        return 'Aquarium';
      case MusicTheme.planetarium:
        return 'Planetarium';
      case MusicTheme.library:
        return 'Library';
      case MusicTheme.forest:
        return 'Forest';
      case MusicTheme.electronic:
        return 'Electronic';
      case MusicTheme.classical:
        return 'Classical';
      case MusicTheme.coffeeShop:
        return 'Coffee Shop';
      case MusicTheme.fantasy:
        return 'Fantasy';
    }
  }

  String get emoji {
    switch (this) {
      case MusicTheme.aquarium:
        return '🐠';
      case MusicTheme.planetarium:
        return '🌌';
      case MusicTheme.library:
        return '📚';
      case MusicTheme.forest:
        return '🌲';
      case MusicTheme.electronic:
        return '🎧';
      case MusicTheme.classical:
        return '🎻';
      case MusicTheme.coffeeShop:
        return '☕';
      case MusicTheme.fantasy:
        return '✨';
    }
  }

  String get description {
    switch (this) {
      case MusicTheme.aquarium:
        return 'Soft piano, ocean ambience, whale songs';
      case MusicTheme.planetarium:
        return 'Warm synth pads, space ambience, slow piano';
      case MusicTheme.library:
        return 'Fireplace crackle, paper rustle, wood ambience';
      case MusicTheme.forest:
        return 'Rain, birds, wind, and distant river';
      case MusicTheme.electronic:
        return 'Lo-fi, synthwave, ambient techno';
      case MusicTheme.classical:
        return 'Solo piano, strings, soft orchestra';
      case MusicTheme.coffeeShop:
        return 'Cafe ambience, jazz piano, quiet chatter';
      case MusicTheme.fantasy:
        return 'Elven forests, ancient temples, magic';
    }
  }

  int get defaultBpm {
    switch (this) {
      case MusicTheme.aquarium:
        return 55;
      case MusicTheme.planetarium:
        return 50;
      case MusicTheme.library:
        return 60;
      case MusicTheme.forest:
        return 52;
      case MusicTheme.electronic:
        return 78;
      case MusicTheme.classical:
        return 58;
      case MusicTheme.coffeeShop:
        return 70;
      case MusicTheme.fantasy:
        return 54;
    }
  }
}

extension PomodoroPresetX on PomodoroPreset {
  String get label {
    switch (this) {
      case PomodoroPreset.classic25_5:
        return '25 / 5';
      case PomodoroPreset.deep45_10:
        return '45 / 10';
      case PomodoroPreset.long50_10:
        return '50 / 10';
      case PomodoroPreset.marathon90_20:
        return '90 / 20';
      case PomodoroPreset.custom:
        return 'Custom';
    }
  }

  int get workMinutes {
    switch (this) {
      case PomodoroPreset.classic25_5:
        return 25;
      case PomodoroPreset.deep45_10:
        return 45;
      case PomodoroPreset.long50_10:
        return 50;
      case PomodoroPreset.marathon90_20:
        return 90;
      case PomodoroPreset.custom:
        return 25;
    }
  }

  int get breakMinutes {
    switch (this) {
      case PomodoroPreset.classic25_5:
        return 5;
      case PomodoroPreset.deep45_10:
        return 10;
      case PomodoroPreset.long50_10:
        return 10;
      case PomodoroPreset.marathon90_20:
        return 20;
      case PomodoroPreset.custom:
        return 5;
    }
  }
}

extension AppColorThemeX on AppColorTheme {
  String get label {
    switch (this) {
      case AppColorTheme.oceanBlue:
        return 'Ocean Blue';
      case AppColorTheme.forestGreen:
        return 'Forest Green';
      case AppColorTheme.lavender:
        return 'Lavender';
      case AppColorTheme.darkMode:
        return 'Dark Mode';
      case AppColorTheme.solarOrange:
        return 'Solar Orange';
      case AppColorTheme.midnightPurple:
        return 'Midnight Purple';
      case AppColorTheme.minimalWhite:
        return 'Minimal White';
    }
  }
}
