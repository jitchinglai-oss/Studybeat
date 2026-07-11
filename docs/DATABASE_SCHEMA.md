# Studybeat Firestore Schema

## Collections

```
users/{userId}
  displayName: string
  email: string
  language: string                  # en | es | fr | de | zh | ja | ko | pt | ar
  colorTheme: string                # oceanBlue | forestGreen | ...
  preferredMusicTheme: string
  preferredVisual: string
  preferredPomodoro: string
  focusStreak: number
  totalXp: number
  level: number
  currentMood: string               # low | medium | high | overwhelmed
  onboardingComplete: boolean
  achievements: string[]
  createdAt: timestamp
  updatedAt: timestamp

users/{userId}/sessions/{sessionId}
  subject: string
  subjectEmoji: string
  durationMinutes: number
  scheduledStart: timestamp
  examDate: timestamp?
  difficulty: string
  stressLevel: string
  energyLevel: string
  goal: string
  musicTheme: string
  pomodoroPreset: string
  status: string                    # scheduled | active | paused | breakTime | completed | cancelled
  notes: string?
  completedAt: timestamp?
  focusChecks: FocusCheckIn[]
  xpEarned: number
  musicSnapshot: {                  # last adaptive state
    bpm: number
    richness: number
    ambientIntensity: number
    brightness: number
  }?

users/{userId}/focusChecks/{checkId}
  sessionId: string
  timestamp: timestamp
  level: string
  elapsedMinutes: number

users/{userId}/insights/{insightId}
  message: string
  category: string                  # productivity | focus | music | break
  createdAt: timestamp
  order: number

users/{userId}/stats/{weekId}       # e.g. 2026-W28
  studyMinutes: number
  sessionsCompleted: number
  themeCounts: map<string, number>
  xpEarned: number
  updatedAt: string

musicThemes/{themeId}               # catalog (read-only to clients)
  label: string
  description: string
  defaultBpm: number
  instruments: string[]
  ambientLayers: string[]
  previewUrl: string?

leaderboards/{boardId}/entries/{userId}  # optional Phase 2+
  displayName: string
  xp: number
  streak: number
```

## Security model

- All user subcollections are owner-only.
- `insights` and `stats` are written by Cloud Functions.
- Theme catalog is authenticated-read, admin-write.

## Sync strategy (Flutter)

1. **Phase 1:** `LocalStorageService` (SharedPreferences) for offline demo.
2. **Phase 1 deploy:** Swap `StudyRepository` to Firestore with local cache.
3. Keep the same models (`StudySession`, `UserProfile`, `MusicState`) across both backends.
