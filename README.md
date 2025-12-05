# 🎬 StreamVibe - Premium OTT Platform

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**A beautiful and feature-rich OTT (Over-The-Top) streaming platform built with Flutter**

Featuring real-time API integration, advanced animations, liquid glass UI, and a Netflix-inspired design

  [Features](#-features) 
• [Screenshots](#-screenshots)


https://github.com/user-attachments/assets/8936463c-b7ab-47a3-9519-c86cf99447a9


• [Installation](#-setup-instructions) 
• [Documentation](#-documentation)

</div>

---

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

## 📸 Screenshots

<div align="center">

### Splash Screen & Authentication
*Coming soon - Add your app screenshots here*

### Home & Content Browsing
*Coming soon - Add your app screenshots here*

### Content Details & Video Player
*Coming soon - Add your app screenshots here*

</div>

> **Note**: To add screenshots, create a `screenshots` folder in your repository and update the paths above.

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

### 3. Configure API Keys (IMPORTANT! 🔒)

**Your API keys are now secured using environment variables!**

1. **Copy the environment template:**
   ```bash
   cp .env.example .env
   ```

2. **Get your TMDB API Key:**
   - Go to [The Movie Database (TMDB)](https://www.themoviedb.org/)
   - Create a free account
   - Navigate to Settings → API
   - Request an API key (instant approval)

3. **Get your RapidAPI Key:**
   - Go to [RapidAPI OTT Details](https://rapidapi.com/gox-ai-gox-ai-default/api/ott-details)
   - Sign up or log in
   - Subscribe to the API (free tier available)

4. **Update your `.env` file** with your actual API keys:
   ```env
   TMDB_API_KEY=your_actual_tmdb_api_key_here
   RAPID_API_KEY=your_actual_rapidapi_key_here
   RAPID_API_HOST=ott-details.p.rapidapi.com
   ```

> ⚠️ **IMPORTANT**: Never commit the `.env` file to version control! It's already in `.gitignore`.
> 
> 📖 For detailed security information, see [API_KEY_SECURITY.md](API_KEY_SECURITY.md)

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

## 📚 Documentation

This project includes comprehensive documentation:

- **[API_KEY_SECURITY.md](API_KEY_SECURITY.md)** - 🔒 **IMPORTANT**: API key security guide
- **[QUICKSTART.md](QUICKSTART.md)** - Quick setup guide for faster onboarding
- **[CHECKLIST.md](CHECKLIST.md)** - Configuration checklist
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Detailed project overview
- **[LIQUID_GLASS_IMPLEMENTATION.md](LIQUID_GLASS_IMPLEMENTATION.md)** - Glass effect guide
- **[ADVANCED_FEATURES.md](ADVANCED_FEATURES.md)** - Advanced features breakdown
- **[GITHUB_PUSH_GUIDE.md](GITHUB_PUSH_GUIDE.md)** - GitHub deployment guide

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 🗺️ Roadmap

- [x] Firebase authentication
- [x] TMDB API integration
- [x] Video playback
- [x] Liquid glass UI
- [x] Advanced animations
- [ ] Offline mode
- [ ] Download functionality
- [ ] Continue watching
- [ ] User reviews
- [ ] Social features
- [ ] Multi-profile support
- [ ] Parental controls
- [ ] Cast to TV

## 📊 Project Stats

- **Language**: Dart
- **Framework**: Flutter
- **State Management**: Provider
- **Backend**: Firebase
- **API**: TMDB
- **Lines of Code**: 5000+
- **Widgets**: 50+
- **Screens**: 8
- **Features**: 20+

## 🌟 Show Your Support

Give a ⭐️ if this project helped you!

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Dinesh Kokare**

- GitHub: [@dineshkokare](https://github.com/dineshkokare)

## 🙏 Acknowledgments

- [TMDB](https://www.themoviedb.org/) for providing the API
- [Firebase](https://firebase.google.com/) for backend services
- Flutter community for amazing packages
- Netflix for design inspiration

---

<div align="center">

**Built with ❤️ using Flutter**

Made with passion for creating beautiful mobile experiences


