# Quick Setup Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Get TMDB API Key (2 minutes)
1. Visit https://www.themoviedb.org/
2. Sign up for a free account
3. Go to Settings → API
4. Request an API key (it's instant and free)
5. Copy your API key

### Step 2: Update API Key (30 seconds)
1. Open `lib/constants/api_constants.dart`
2. Find this line:
   ```dart
   static const String apiKey = 'YOUR_TMDB_API_KEY';
   ```
3. Replace `YOUR_TMDB_API_KEY` with your actual key

### Step 3: Run Without Firebase (Optional - For Quick Testing)
If you want to test the app quickly without setting up Firebase:

1. Open `lib/main.dart`
2. The app will continue even if Firebase fails to initialize
3. You can browse content but authentication won't work

**To run:**
```bash
flutter run
```

### Step 4: Setup Firebase (For Full Features)
For authentication and user features to work, you need Firebase:

#### Quick Firebase Setup:
1. Go to https://console.firebase.google.com/
2. Create a new project
3. Add iOS and/or Android app
4. Download configuration files:
   - iOS: `GoogleService-Info.plist` → place in `ios/Runner/`
   - Android: `google-services.json` → place in `android/app/`
5. Enable these in Firebase Console:
   - Authentication → Email/Password
   - Firestore Database

#### For Android, also add:
In `android/app/build.gradle`, at the bottom:
```gradle
apply plugin: 'com.google.gms.google-services'
```

In `android/build.gradle`, in dependencies:
```gradle
classpath 'com.google.gms:google-services:4.3.15'
```

### Step 5: Run the App
```bash
flutter run
```

## 📱 Testing the App

### Without Authentication:
- Browse trending content
- View popular movies and TV shows
- Search for content
- View content details

### With Firebase Setup:
- Create an account
- Sign in / Sign out
- Add to watchlist
- Add to favorites
- Profile management

## 🎯 Quick Commands

```bash
# Get dependencies
flutter pub get

# Run on iOS
flutter run -d ios

# Run on Android  
flutter run -d android

# Clean build
flutter clean && flutter pub get

# Check for issues
flutter doctor
```

## ⚡ Common Issues & Quick Fixes

### "No Firebase App has been created"
- **Quick Fix**: The app will still run, but authentication won't work
- **Full Fix**: Complete Firebase setup (Step 4 above)

### "Failed to load content"
- **Fix**: Check your TMDB API key in `lib/constants/api_constants.dart`
- Ensure you have internet connection

### Build errors
```bash
flutter clean
flutter pub get  
flutter run
```

### iOS Provisioning
```bash
cd ios
pod install
cd ..
flutter run
```

## 🎨 Test Accounts

For testing, you can create any email/password combination when Firebase is set up.

Example:
- Email: `test@example.com`
- Password: `test123` (minimum 6 characters)

---

**You're all set! Enjoy your OTT platform! 🎬🍿**
