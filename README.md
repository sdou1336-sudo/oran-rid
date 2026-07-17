# Oran Ride (وهران رايد)

A modern, inDrive-style fair-fare ride-hailing application for Oran, Algeria. Developed with Flutter & Firebase.

## Features
- **inDrive Bidding Engine**: Dynamic fare offering by riders with active counter-offers from nearby Captains.
- **Bi-lingual Interface**: Localization with RTL/LTR layouts for Arabic and French.
- **Live Maps Integration**: Driver location tracking using Google Maps API.
- **Firebase Backend**: Real-time Firestore synchronizations, Secure OTP Authentication, and cloud triggers.

## Getting Started

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (>= 3.0.0)
- [Dart SDK](https://dart.dev/get-started) (>= 3.0.0 < 4.0.0)
- Firebase Account & Project

### 2. Configure Firebase
- Create a Firebase project in the Firebase Console.
- Add an Android App with bundle ID `com.oranride.app`.
- Add an iOS App with bundle ID `com.oranride.app`.
- Download `google-services.json` and place it in `android/app/`.
- Download `GoogleService-Info.plist` and place it in `ios/Runner/`.
- Enable **Firestore Database** and **Phone Authentication** in your Firebase project.

### 3. Google Maps API Config
- Create credentials for the Google Maps SDK on [Google Cloud Console](https://console.cloud.google.com/).
- Add the credentials to your platform-specific configuration files (e.g. `AndroidManifest.xml`).

### 4. Running the Application
```bash
# Get dependencies
flutter pub get

# Run on a connected device
flutter run
```
