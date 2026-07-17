# AGENTS.md

## Cursor Cloud specific instructions

Studybeat is a monorepo with one product (a Flutter study-companion app) plus an optional Firebase backend and a static marketing site. See `README.md` for the component layout and standard commands.

### Services

- `studybeat_app/` — **the product** (Flutter, iOS/Android/Web). Phase 1 MVP is fully self-contained: it persists locally via `SharedPreferences` and has no Firebase wiring yet, so it runs and can be tested end-to-end with no backend, no env vars, and no database.
- `firebase/` — optional TypeScript Cloud Functions + Firestore/Storage rules (Phase 2+, not called by the app yet).
- `website/` — optional static landing page (`npx serve website`).

### Toolchain (already installed in the snapshot; refreshed by the update script)

- Flutter SDK lives at `$HOME/flutter` and is added to `PATH` via `~/.bashrc`. In non-login shells (e.g. the update script) call it explicitly as `"$HOME/flutter/bin/flutter"`.
- Web is enabled (`flutter config --enable-web`). Chrome is available at `/usr/local/bin/google-chrome`.
- Node 22 is available for the Firebase functions (`firebase/functions`). The Firebase CLI is **not** installed; the emulator suite is optional and not needed to test the app.

### Running / testing the Flutter app (`studybeat_app/`)

- Lint: `flutter analyze`
- Test: `flutter test`
- Run (web, for headless VM testing): `flutter run -d web-server --web-port=8090 --web-hostname=0.0.0.0`, then open `http://localhost:8090` in Chrome. The `web-server` device has no auto-launched browser, which is what you want here (`flutter run -d chrome` tries to launch its own Chrome instance).
- Flutter web takes ~20s to bootstrap the debug service on first load before the welcome screen appears — wait before assuming a blank page is broken.
- Hello-world smoke flow: on the welcome screen tap **Explore Demo** → dashboard (greeting + sessions) → tap a session (e.g. Biology) → Focus Mode with live countdown timer and adaptive soundscape controls.

### Firebase functions (`firebase/functions/`, optional)

- Build: `npm run build` (tsc → `lib/`). `OPENAI_API_KEY` is optional; functions degrade gracefully without it.
