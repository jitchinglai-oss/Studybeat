# Studybeat Product Vision & Roadmap

## Vision

Studybeat is a personal AI-powered study companion that creates the perfect study environment. It adapts soundscapes from subject, time remaining, stress, focus, time of day, preferred music style, and user feedback.

## Phase 1 (Foundation) — shipped in this repo

- [x] Flutter app shell (iOS / Android / Web)
- [x] User onboarding + local profile
- [x] Study session scheduler
- [x] Pomodoro presets with music transitions
- [x] Music theme catalog (8 worlds)
- [x] Adaptive rule-based music engine
- [x] Focus Mode + 15-minute focus checks
- [x] Basic statistics + gamification (streak, XP, badges)
- [x] Themes + multi-language preference UI
- [x] Firebase schema, rules, Cloud Functions stubs
- [x] Launch website + brand / store docs

## Phase 2

- [ ] Firebase Auth + cloud sync
- [ ] Live OpenAI coach in-app
- [ ] Animated visual backgrounds (aquarium, galaxy, forest…)
- [ ] Enhanced analytics (stress/focus graphs)
- [ ] Push notifications for scheduled sessions

## Phase 3

- [ ] AI-generated ambient stems (Stable Audio / Suno / local mixer)
- [ ] Real-time stem crossfades
- [ ] Personalized learning model (ideal length, best themes)
- [ ] Optional wearable integration
- [ ] RevenueCat subscriptions

## Example session flow

```
Biochemistry · 90 min · Stress High · Energy Medium · Goal Memorization
        ↓
Aquarium theme · Soft piano · Ocean ambience · 55 BPM · No vocals
        ↓
Focus checks every 15 min adapt richness / tempo / ambience
        ↓
Gradually brighter after 45 minutes
```
