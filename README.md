# Studybeat

Your personal AI-powered study companion that creates the perfect study environment.

Studybeat adapts ambient soundscapes from your subject, stress, focus, time remaining, and preferred music style — so the mix evolves through every session.

## Repository layout

```
studybeat_app/     Flutter app (iOS, Android, Web) — Phase 1 MVP
firebase/          Firestore rules, indexes, Cloud Functions
website/           Launch / waitlist marketing site
docs/              Architecture, API, schema, deployment, brand, store
store-assets/      App Store & Play listing asset checklist
```

## Quick start (Flutter)

```bash
cd studybeat_app
flutter pub get
flutter run
flutter test
```

On the welcome screen, tap **Explore Demo** to load Jonah’s sample schedule (Biology + Chemistry) with the adaptive music engine and AI coach insights.

## What’s in the MVP

- Dashboard with greeting, today’s sessions, mood, focus streak, XP
- Create session (subject, duration, stress, energy, goal, theme, pomodoro)
- Focus Mode with large timer, progress, break countdown
- Adaptive music engine (BPM / richness / ambience / brightness)
- Focus check-ins every 15 minutes
- Statistics (hours, themes, focus history)
- Settings (7 color themes, 9 languages, achievements)
- Local persistence via SharedPreferences (Firebase-ready repository)

## Backend

See `docs/DATABASE_SCHEMA.md`, `docs/API_DESIGN.md`, and `firebase/`.

Callable functions:

- `adaptSoundscape` — rule-based adaptation + optional OpenAI coach line
- `generateCoachInsights` — weekly-style insights from session history

## Website

Open `website/index.html` or serve the folder:

```bash
npx serve website
```

## Documentation

| Doc | Purpose |
|-----|---------|
| [Architecture](docs/ARCHITECTURE.md) | System design & layers |
| [Database schema](docs/DATABASE_SCHEMA.md) | Firestore model |
| [API design](docs/API_DESIGN.md) | Cloud Functions contracts |
| [Deployment](docs/DEPLOYMENT.md) | Firebase, iOS, Android, hosting |
| [Brand](docs/BRAND.md) | Identity & voice |
| [Store assets](docs/STORE_ASSETS.md) | App Store / Play checklist |

## Roadmap

1. **Phase 1** — Accounts, scheduler, pomodoro, themes, stats *(this PR)*
2. **Phase 2** — Live AI coach, animated backgrounds, enhanced analytics
3. **Phase 3** — AI-generated ambient stems, real-time sound adaptation, personalization model

## License

Private — all rights reserved.
