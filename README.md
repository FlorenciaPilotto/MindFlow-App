# MindFlow 🧘

A Flutter meditation app that helps users build a daily mindfulness habit through guided audio sessions, progress tracking, and a curated meditation library.

---

## Features

- **Email / password authentication** — powered by Firebase Auth
- **Meditation library** — browse, search, and filter sessions by category
- **Audio playback** — stream meditation audio with a seek slider and play/pause/stop controls
- **Favorites** — save and manage preferred meditations; swipe to remove
- **Progress tracking** — daily streak, total minutes, and session count displayed on the home dashboard
- **Dark mode** — automatic light/dark theme support via `AppTheme`
- **Error handling** — typed exception hierarchy with user-friendly messages

---

## Project Structure

```
lib/
├── config/
│   └── app_config.dart          # Environment-based configuration
├── constants/
│   └── constants.dart           # App-wide constants (categories, durations, regex)
├── models/
│   ├── meditation.dart          # Meditation data model with JSON serialisation
│   └── user.dart                # User profile model with JSON serialisation
├── screens/
│   ├── auth_screen.dart         # Login / sign-up UI
│   ├── home_screen.dart         # Dashboard (greeting, stats, featured meditations)
│   ├── meditation_list_screen.dart  # Browse & filter meditation library
│   ├── meditation_detail_screen.dart # Audio playback interface
│   └── favorites_screen.dart    # Saved meditations management
├── services/
│   ├── auth_service.dart        # Firebase Auth wrapper
│   └── meditation_service.dart  # Firestore CRUD for meditations
├── theme/
│   └── app_theme.dart           # Light and dark ThemeData
├── utils/
│   ├── app_utils.dart           # Formatting, validation, and helper functions
│   └── error_handler.dart       # Exception types and error-to-message mapping
├── widgets/
│   └── custom_widgets.dart      # CustomButton, CustomTextField, CustomCard,
│                                #   LoadingWidget, EmptyStateWidget
└── main.dart                    # App entry point with Firebase initialisation
```

---

## Getting Started

### Prerequisites

- [Flutter](https://flutter.dev/docs/get-started/install) ≥ 3.0 (Dart ≥ 2.17)
- A [Firebase](https://firebase.google.com/) project with **Authentication** and **Cloud Firestore** enabled

### 1 · Clone the repository

```bash
git clone https://github.com/FlorenciaPilotto/MindFlow-App.git
cd MindFlow-App
```

### 2 · Connect Firebase

Follow the [FlutterFire setup guide](https://firebase.flutter.dev/docs/overview) to:

1. Register your Android / iOS / Web app in the Firebase console
2. Download and place `google-services.json` (Android) and / or `GoogleService-Info.plist` (iOS) in the correct platform directories
3. Run `flutterfire configure` to generate `lib/firebase_options.dart`

Then update `main.dart` to pass the generated options:

```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
```

### 3 · Install dependencies

```bash
flutter pub get
```

### 4 · Run the app

```bash
flutter run
```

---

## Firestore Data Structure

### `users/{uid}`

| Field | Type | Description |
|---|---|---|
| `id` | String | Firebase Auth UID |
| `email` | String | User email address |
| `name` | String | Display name |
| `profileImageUrl` | String? | Optional avatar URL |
| `createdAt` | String | ISO-8601 timestamp |
| `meditationStreak` | int | Current daily streak |
| `totalMeditationMinutes` | int | Cumulative session minutes |
| `completedMeditationIds` | List\<String\> | IDs of completed sessions |
| `favoriteCategories` | List\<String\> | Preferred categories |
| `favoriteMeditationIds` | List\<String\> | Saved meditation IDs |

### `meditations/{id}`

| Field | Type | Description |
|---|---|---|
| `id` | String | Document ID |
| `title` | String | Meditation title |
| `description` | String | Short description |
| `duration` | int | Duration in **seconds** |
| `category` | String | One of the constants in `AppConstants.meditationCategories` |
| `audioUrl` | String | Streaming URL for the audio file |
| `imageUrl` | String | Cover art URL |
| `rating` | double | Average user rating |
| `completions` | int | Total completion count |

---

## Dependencies

| Package | Purpose |
|---|---|
| `firebase_core` | Firebase SDK initialisation |
| `firebase_auth` | Email / password authentication |
| `cloud_firestore` | Real-time database |
| `audioplayers` | Audio streaming and playback |
| `provider` | State management (available for extension) |
| `riverpod` | Advanced state management (available for extension) |

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## License

This project is provided for educational purposes.
