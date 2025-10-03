# Smart Campus Companion

A comprehensive campus management mobile application for university students that integrates multiple services including class scheduling, library booking, events, lost & found, study groups, and cafeteria ordering.

## Features

- **Authentication**: Email/Password and Google Sign-In
- **Class Schedule**: Manage your class timetable
- **Library**: Book study seats in the library
- **Events**: Discover and register for campus events
- **Lost & Found**: Report and search for lost items
- **Study Groups**: Create and join study groups
- **Cafeteria**: Browse menu and place orders
- **Profile Management**: Update your personal information

## Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Firebase account
- Android Studio / Xcode (for emulators/simulators)
- Physical device (recommended for testing)

## Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/smart-campus-companion.git
   cd smart-campus-companion
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add a new Android/iOS app to your Firebase project
   - Download the configuration files:
     - Android: `google-services.json` (place in `android/app/`)
     - iOS: `GoogleService-Info.plist` (place in `ios/Runner/`)
   - Enable Authentication methods in Firebase Console:
     - Email/Password
     - Google Sign-In

4. **Run the app**
   ```bash
   # For Android
   flutter run -d <device_id>
   
   # For iOS
   cd ios
   pod install
   cd ..
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                  # App entry point
├── models/                   # Data models
├── screens/                  # UI screens
│   ├── auth/                 # Authentication screens
│   ├── home/                 # Home/dashboard screens
│   ├── schedule/             # Class schedule screens
│   ├── library/              # Library booking screens
│   ├── events/               # Events screens
│   ├── lost_found/           # Lost & found screens
│   ├── study_groups/         # Study groups screens
│   ├── cafeteria/            # Cafeteria screens
│   └── settings/             # Settings screens
├── widgets/                  # Reusable widgets
├── services/                 # Business logic and API calls
├── providers/                # State management
├── utils/                    # Helper functions and constants
└── routes/                   # App navigation routes
```

## Dependencies

- `firebase_core`: Firebase Core
- `firebase_auth`: Firebase Authentication
- `cloud_firestore`: Cloud Firestore database
- `firebase_storage`: Firebase Storage
- `provider`: State management
- `google_fonts`: Custom fonts
- `intl`: Date and number formatting
- `image_picker`: Image selection from gallery/camera
- `cached_network_image`: Image caching
- `shared_preferences`: Local storage
- `url_launcher`: Launch external URLs

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Special thanks to the Flutter and Firebase teams for their amazing tools
- Icons made by [Freepik](https://www.freepik.com) from [Flaticon](https://www.flaticon.com/)
- Inspiration from various educational apps and university portals
