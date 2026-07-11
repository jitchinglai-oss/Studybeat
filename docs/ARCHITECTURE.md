# Studybeat Architecture

## Overview

```
┌─────────────────────────────────────────────────────────┐
│                   Flutter App (iOS/Android/Web)         │
│  Screens → Providers (Riverpod) → Repository            │
│                         │                               │
│              LocalStorage (Phase 1 demo)                │
│                         │                               │
│              FirestoreRepository (deploy)               │
└─────────────────────────┬───────────────────────────────┘
                          │
          ┌───────────────┼───────────────┐
          ▼               ▼               ▼
   Firebase Auth    Cloud Firestore   Cloud Functions
          │                               │
          │                    ┌──────────┴──────────┐
          │                    ▼                     ▼
          │               OpenAI Coach        Music Adapt
          │
          ▼
   FCM + Analytics + RevenueCat
```

## App layers

| Layer | Path | Responsibility |
|-------|------|----------------|
| UI | `lib/screens/`, `lib/widgets/` | Notion/Spotify-inspired polished screens |
| State | `lib/providers/` | Riverpod notifiers for profile, sessions, focus mode |
| Domain | `lib/models/`, `lib/services/` | Sessions, music state, adaptive engine, coach |
| Data | `lib/data/` | Local storage now; Firestore adapter next |
| Theme | `lib/core/theme/` | 7 color themes, Outfit + DM Sans |

## MVP screens (Phase 1)

1. **Welcome** — brand-first entry
2. **Onboarding** — name, music vibe, pomodoro, color theme
3. **Dashboard** — greeting, today's sessions, mood, streak, coach, XP
4. **Create Session** — subject, duration, stress, energy, goal, theme
5. **Focus Mode** — large timer, progress, music meters, focus check-ins
6. **Statistics** — hours, themes, focus history
7. **Settings** — themes, languages, mood, achievements

## Adaptive music loop

```
Session start → MusicState.forTheme(stress)
        ↓
Every 15 min → Focus check UI
        ↓
adapt(focus, stress, progress) → BPM / richness / ambience / brightness
        ↓
Pomodoro break → forBreak() softer mix
        ↓
Resume work → restore work snapshot
```

## Roadmap alignment

| Phase | Status in repo |
|-------|----------------|
| Phase 1 — accounts, scheduler, pomodoro, themes, stats, dark/lang | **Implemented (local demo)** |
| Phase 2 — AI coach, animated backgrounds, enhanced analytics | Coach stub + Cloud Function ready |
| Phase 3 — AI music generation, real-time stems, personalization model | Engine interface ready; providers TBD |

## Design language

- Signature theme: **Ocean Blue**
- Typography: **Outfit** (display) + **DM Sans** (body)
- Atmosphere: deep teal gradients, soft panels (not card grids)
- Motion: fade/slide on greeting, sessions, focus check
