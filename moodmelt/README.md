# MoodMelt

Az érzelmi wellness companion Melt karakterrel és health tracking integrációval.

## Features

- **Mood Tracking**: Napi hangulatfelmérés streak counterrel
- **Practice Library**: Breathing, grounding, reframe gyakorlatok
- **Health Integration**: Apple Health / Google Fit integráció szívverés monitorozáshoz
- **Smart Notifications**: Gentle nudge-ok amikor a rendszer stressz jeleket észlel
- **Insights**: Heti összefoglalók és hangulat patterns

## Tech Stack

- **Flutter** 3.0+
- **Riverpod** - State management
- **Hive** - Local storage
- **GoRouter** - Navigation
- **Health** package - Apple Health / Google Fit integration
- **Flutter Local Notifications** - Smart notifications

## Getting Started

### Prerequisites

```bash
flutter --version  # Flutter 3.0 or higher
```

### Installation

1. Clone the repository
```bash
git clone <repo-url>
cd moodmelt
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate Hive adapters
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── core/               # Constants, theme, router
├── data/               # Models, repositories, local storage
├── domain/             # Services, providers (business logic)
└── presentation/       # Screens, widgets (UI)
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Permissions

### iOS
- HealthKit access for heart rate monitoring
- Notifications for wellness reminders

### Android
- Activity Recognition for step counting
- Health Connect for heart rate data
- Post Notifications permission

## License

MIT License
