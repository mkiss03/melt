# MoodMelt - Setup Instructions

## Prerequisites

- Flutter SDK 3.0+ installed
- Android Studio / Xcode for platform development
- Git

## Initial Setup

### 1. Install Dependencies

```bash
cd moodmelt
flutter pub get
```

### 2. Generate Hive Adapters

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate the following files:
- `lib/data/models/mood_entry.g.dart`
- `lib/data/models/practice_session.g.dart`
- `lib/data/models/user_preferences.g.dart`

### 3. Run the App

**For Android:**
```bash
flutter run
```

**For iOS (Mac only):**
```bash
flutter run -d ios
```

## Platform-Specific Setup

### Android

The project is configured for Android v2 embedding with:
- `compileSdk 34`
- `minSdkVersion 21`
- `targetSdkVersion 34`
- Gradle 8.3
- Kotlin 1.9.10

**Required Permissions:**
- Activity Recognition (for step counting)
- Post Notifications (for wellness reminders)
- Health permissions (if Google Fit integration)

### iOS

**Required Permissions (Info.plist):**
- NSHealthShareUsageDescription
- NSHealthUpdateUsageDescription
- Background fetch modes

**Minimum iOS Version:** 12.0

## Assets

### Sounds (Optional for MVP)
Place in `assets/sounds/`:
- `breath_in.mp3`
- `breath_out.mp3`

You can download free meditation sounds from:
- [Freesound.org](https://freesound.org)
- [Zapsplat](https://www.zapsplat.com)

### Animations (Optional)
Create a Melt character animation at [rive.app](https://rive.app) and export as:
- `assets/animations/melt_character.riv`

## Building for Production

### Android APK
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS (Mac only)
```bash
flutter build ios --release
```

Then open in Xcode for signing and distribution.

## Troubleshooting

### "Build failed due to use of deleted Android v1 embedding"
✅ **Fixed!** The project now uses Android v2 embedding.

### Hive adapters not found
Run: `flutter pub run build_runner build --delete-conflicting-outputs`

### Health permissions not working
- **Android:** Enable Health Connect in device settings
- **iOS:** Enable HealthKit in Xcode capabilities

## Next Steps

1. ✅ Run `flutter pub get`
2. ✅ Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. ✅ Run `flutter run`
4. 🎨 Add sound assets (optional)
5. 🎨 Add Melt character animation (optional)
6. 📊 Test on physical device with health data
7. 🚀 Build for production

## Support

If you encounter any issues, check:
- Flutter version: `flutter --version`
- Doctor: `flutter doctor -v`
- Clean build: `flutter clean && flutter pub get`
