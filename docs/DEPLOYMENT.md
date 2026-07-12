# Studybeat Deployment Guide

## Prerequisites

- Flutter 3.32+ / Dart 3.8+
- Xcode 16+ (iOS)
- Android Studio / SDK 35
- Firebase CLI (`npm i -g firebase-tools`)
- Node 20+ (Cloud Functions)
- Apple Developer + Google Play Console accounts
- RevenueCat project (subscriptions)

## 1. Run the Flutter app locally

```bash
cd studybeat_app
flutter pub get
flutter run          # device / simulator
flutter run -d chrome  # web demo
flutter test
```

Demo mode uses SharedPreferences — tap **Explore Demo** on the welcome screen.

## 2. Create Firebase project

```bash
firebase login
cd firebase
firebase projects:create studybeat-prod
firebase use studybeat-prod
firebase apps:create android com.studybeat.studybeat
firebase apps:create ios com.studybeat.studybeat
```

Add FlutterFire:

```bash
dart pub global activate flutterfire_cli
cd ../studybeat_app
flutterfire configure --project=studybeat-prod
```

Then add packages:

```bash
flutter pub add firebase_core firebase_auth cloud_firestore cloud_functions firebase_messaging firebase_analytics
```

Wire `StudyRepository` to Firestore (keep `LocalStorageService` as offline cache).

## 3. Deploy backend

```bash
cd firebase/functions
npm install
# set secret
firebase functions:secrets:set OPENAI_API_KEY
npm run build
cd ..
firebase deploy --only firestore:rules,firestore:indexes,storage,functions
```

## 4. Emulators (optional)

```bash
cd firebase
firebase emulators:start
```

Point the Flutter app at emulator hosts in debug builds.

## 5. iOS release

1. Open `studybeat_app/ios/Runner.xcworkspace` in Xcode
2. Set Team, Bundle ID `com.studybeat.studybeat`
3. Enable Push Notifications + Sign in with Apple
4. Archive → Upload to App Store Connect
5. Attach screenshots from `store-assets/`

```bash
flutter build ipa --release
```

## 6. Android release

1. Create upload keystore
2. Configure `android/key.properties`
3. Enable Play App Signing

```bash
flutter build appbundle --release
```

Upload AAB to Play Console → Internal testing → Production.

## 7. Website

```bash
cd website
# static site — deploy to Firebase Hosting or any CDN
firebase deploy --only hosting   # after adding hosting target
# or: npx serve .
```

## 8. Payments (RevenueCat)

1. Create entitlements: `studybeat_pro`
2. Products: monthly / yearly
3. Configure App Store + Play products
4. Add `purchases_flutter` SDK; gate AI music + advanced coach behind entitlement

## Environment checklist

- [ ] `GOOGLE_APPLICATION_CREDENTIALS` for CI
- [ ] `OPENAI_API_KEY` in Functions secrets
- [ ] FCM APNs key uploaded
- [ ] Privacy policy + terms URLs live on website
- [ ] Analytics + Crashlytics enabled
