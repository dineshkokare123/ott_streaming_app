# StreamVibe - OTT Platform App

A beautiful and feature-rich OTT (Over-The-Top) streaming platform built with Flutter, featuring real-time API integration, user authentication, and a Netflix-inspired UI.

## ✨ Features

### 🎬 Content
- **Real-time API Integration** with TMDB (The Movie Database)
- **Trending Content** - Stay updated with what's trending
- **Popular Movies** - Browse popular movies
- **Top Rated Movies** - Discover critically acclaimed films
- **Popular TV Shows** - Explore trending TV series
- **Search Functionality** - Find any movie or TV show instantly

### 👤 User Features
- **Firebase Authentication** - Secure email/password authentication
- **User Profiles** - Personalized user profiles
- **Watchlist** - Save content to watch later
- **Favorites** - Mark your favorite content
- **Real-time Sync** - All data synced across devices via Firestore

### 🎨 Design
- **Dark Theme** - Beautiful dark mode UI inspired by Netflix
- **Liquid Glass Effect** - Premium glassmorphism UI components
- **Animated Splash Screen** - Stunning entry experience with floating orbs
- **Smooth Animations** - Engaging transitions and micro-interactions
- **Responsive Layout** - Optimized for all screen sizes
- **Modern UI Components** - Premium-looking cards and layouts
- **Gradient Effects** - Eye-catching gradient overlays
- **Backdrop Blur** - Frosted glass effects throughout the app

## 📋 Prerequisites

Before you begin, ensure you have the following installed:
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / Xcode for mobile development
- A code editor (VS Code or Android Studio recommended)

## 🔧 Setup Instructions

### 1. Clone the Repository

```bash
cd /Users/dineshkokare/Documents/ott_streaming_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure TMDB API

1. Go to [The Movie Database (TMDB)](https://www.themoviedb.org/)
2. Create a free account
3. Navigate to Settings → API
4. Request an API key
5. Copy your API key
6. Open `lib/constants/api_constants.dart`
7. Replace `YOUR_TMDB_API_KEY` with your actual API key:

```dart
static const String apiKey = 'your_actual_api_key_here';
```

### 4. Configure Firebase

#### iOS Setup:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use an existing one
3. Add an iOS app
4. Download `GoogleService-Info.plist`
5. Place it in `ios/Runner/`
6. Follow Firebase setup instructions

#### Android Setup:
1. In Firebase Console, add an Android app
2. Download `google-services.json`
3. Place it in `android/app/`
4. Update `android/build.gradle`:
```gradle
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```
5. Update `android/app/build.gradle`:
```gradle
apply plugin: 'com.google.gms.google-services'
```

#### Enable Firebase Services:
1. In Firebase Console, enable **Authentication**
2. Enable **Email/Password** sign-in method
3. Enable **Cloud Firestore**
4. Set up Firestore rules (development):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 5. Run the App

```bash
# For iOS
flutter run -d ios

# For Android
flutter run -d android

# For specific device
flutter devices  # List available devices
flutter run -d <device_id>
```

## 📱 App Structure

```
lib/
├── constants/
│   ├── api_constants.dart      # API endpoints and configuration
│   └── app_colors.dart          # App color palette
├── models/
│   ├── content.dart             # Content data model
│   └── user.dart                # User data model
├── providers/
│   ├── auth_provider.dart       # Authentication state management
│   └── content_provider.dart    # Content state management
├── screens/
│   ├── login_screen.dart        # Login page
│   ├── register_screen.dart     # Registration page
│   ├── home_screen.dart         # Main home with content
│   ├── search_screen.dart       # Search functionality
│   ├── profile_screen.dart      # User profile
│   └── content_detail_screen.dart # Content details
├── services/
│   ├── api_service.dart         # TMDB API integration
│   └── auth_service.dart        # Firebase auth services
├── widgets/
│   ├── content_card.dart        # Content card widget
│   └── content_row.dart         # Horizontal content row
└── main.dart                    # App entry point
```

## 🎯 Key Technologies

- **Flutter** - Cross-platform mobile framework
- **Provider** - State management
- **Firebase Auth** - User authentication
- **Cloud Firestore** - Real-time database
- **TMDB API** - Movie and TV show data
- **Cached Network Image** - Efficient image loading
- **Chewie** - Video player (ready to integrate)

## 🔐 Authentication Flow

1. User opens app → Login/Register screen
2. User signs up with email and password
3. Firebase creates authentication account
4. User data stored in Firestore
5. User automatically signed in
6. Navigate to Home screen
7. Subsequent launches check auth state

## 📊 Data Flow

1. **Content Loading**: API Service → Content Provider → UI
2. **User Actions**: UI → Auth Provider → Auth Service → Firestore
3. **Real-time Updates**: Firestore → Auth Provider → UI

## 🎨 Customization

### Change App Colors
Edit `lib/constants/app_colors.dart` to customize the color scheme.

### Add More Content Categories
Edit `lib/providers/content_provider.dart` and `lib/services/api_service.dart` to add more content categories.

### Modify Theme
Edit `lib/main.dart` to customize the app theme.

## 🚀 Future Enhancements

- [ ] Video playback functionality
- [ ] Offline download support
- [ ] Continue watching feature
- [ ] User reviews and ratings
- [ ] Social sharing
- [ ] Multiple user profiles
- [ ] Parental controls
- [ ] Recommendations engine
- [ ] Cast to TV support
- [ ] Multi-language support

## 🐛 Troubleshooting

### Firebase Not Working
- Ensure Firebase is properly initialized
- Check that configuration files are in the correct locations
- Verify Firebase services are enabled in console

### API Not Loading Content
- Verify TMDB API key is correct
- Check internet connection
- Ensure API endpoint URLs are correct

### Build Errors
```bash
flutter clean
flutter pub get
flutter run
```

## 📄 License

This project is for educational purposes. Please ensure you comply with TMDB API terms of service.

## 🙏 Acknowledgments

- [TMDB](https://www.themoviedb.org/) for providing the API
- [Firebase](https://firebase.google.com/) for backend services
- Flutter community for amazing packages

## 📞 Support

For issues or questions:
1. Check the troubleshooting section
2. Review Flutter and Firebase documentation
3. Ensure all setup steps are completed

---

**Built with ❤️ using Flutter**
