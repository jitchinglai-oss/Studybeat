# Studybeat API Design

## Client → Backend

Callable Cloud Functions (Firebase Auth ID token required).

### `adaptSoundscape`

**Request**
```json
{
  "theme": "aquarium",
  "focusLevel": "good",
  "stressLevel": "high",
  "elapsedMinutes": 30,
  "totalMinutes": 90,
  "currentBpm": 55,
  "currentRichness": 0.45
}
```

**Response**
```json
{
  "bpm": 51,
  "richness": 0.5,
  "ambientIntensity": 0.7,
  "brightness": 0.3,
  "hasVocals": false,
  "transitionNote": "Focus good — gently enriching layers",
  "coachLine": "Steady pace — you're in a strong focus window."
}
```

### `generateCoachInsights`

**Request:** `{}` (uses auth uid)

**Response**
```json
{
  "insights": [
    { "message": "You seem more productive during evening biology sessions.", "category": "productivity" },
    { "message": "Your focus drops after 40 minutes. Try a 10-minute break.", "category": "focus" }
  ]
}
```

## Firestore triggers

| Trigger | Action |
|---------|--------|
| `users/{uid}/sessions/{id}` written with `status=completed` | Aggregate into `users/{uid}/stats/{weekId}` |

## Future music APIs (Phase 3)

Abstract behind `AdaptiveMusicEngine`:

| Provider | Role |
|----------|------|
| Rule engine (shipped) | Instant adaptation of BPM / richness / ambience |
| Stable Audio | Generate ambient stems from theme prompts |
| Suno API | Optional melodic beds (instrumental only) |
| Local ambient mixer | Crossfade pre-authored stems in `assets/audio/` |

Prompt template example:
```
Instrumental study ambient, {theme}, {bpm} BPM, no vocals,
richness {richness}, ambient intensity {ambient}, brightness {brightness}
```

## Auth

- Firebase Auth: Email/password + Sign in with Apple + Google.
- Anonymous auth optional for try-before-account.
- RevenueCat entitlements keyed to Firebase `uid`.
