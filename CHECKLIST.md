# 📋 Configuration Checklist

Before running the app, complete these configuration steps:

## ✅ Essential Setup (Required)

### 1. TMDB API Key (REQUIRED)
- [ ] Created TMDB account at https://www.themoviedb.org/
- [ ] Generated API key from Settings → API
- [ ] Updated `lib/constants/api_constants.dart` with your API key
- [ ] Verified API key is working

**File**: `lib/constants/api_constants.dart`
```dart
static const String apiKey = 'your_actual_api_key_here'; // Replace this
```

## 🔥 Firebase Setup (Optional but Recommended)

### 2. Firebase Project
- [ ] Created Firebase project at https://console.firebase.google.com/
- [ ] Enabled Authentication → Email/Password sign-in
- [ ] Created Cloud Firestore database
- [ ] Set up Firestore security rules

### 3. iOS Configuration (if targeting iOS)
- [ ] Downloaded `GoogleService-Info.plist` from Firebase
- [ ] Placed file in `ios/Runner/` directory
- [ ] Updated iOS bundle ID in Firebase console

### 4. Android Configuration (if targeting Android)  
- [ ] Downloaded `google-services.json` from Firebase
- [ ] Placed file in `android/app/` directory
- [ ] Updated `android/build.gradle` with Google services classpath
- [ ] Updated `android/app/build.gradle` with Google services plugin
- [ ] Updated Android package name in Firebase console

## 📱 Platform-Specific

### For iOS:
- [ ] Run `cd ios && pod install && cd ..`
- [ ] Opened Xcode and verified project builds
- [ ] Set code signing team in Xcode

### For Android:
- [ ] Verified minSdkVersion is 21 or higher
- [ ] Checked internet permissions in AndroidManifest.xml

## 🧪 Testing Readiness

### Without Firebase:
- [ ] Can browse content
- [ ] Can search movies/shows
- [ ] Can view content details

### With Firebase:
- [ ] Can create account
- [ ] Can sign in/out
- [ ] Can add to watchlist
- [ ] Can add to favorites
- [ ] Profile shows user data

## 🚀 Final Checks

- [ ] Run `flutter doctor` - all checks should pass
- [ ] Run `flutter pub get` - no errors
- [ ] Run `flutter analyze` - no major issues
- [ ] App builds successfully: `flutter build ios` or `flutter build apk`
- [ ] App runs on device/simulator: `flutter run`

## 📝 Quick Test Commands

```bash
# Check Flutter environment
flutter doctor -v

# Get all dependencies
flutter pub get

# Analyze code for issues
flutter analyze

# Run the app
flutter run

# Run on specific device
flutter devices
flutter run -d <device_id>
```

## ⚠️ Common Issues

### Issue: "No Firebase App has been created"
**Solution**: Either complete Firebase setup or the app will run with limited features (no auth)

### Issue: "Failed to load content"
**Solution**: Check TMDB API key is correctly set in `api_constants.dart`

### Issue: Build errors on iOS
**Solution**: 
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

### Issue: Build errors on Android
**Solution**:
```bash
flutter clean
flutter pub get
flutter run
```

## 🎯 Recommended Setup Order

1. ✅ Setup TMDB API (5 minutes)
2. ✅ Test app without Firebase (verify content loads)
3. ✅ Setup Firebase iOS/Android (15 minutes)
4. ✅ Test full authentication flow
5. ✅ Enjoy your OTT platform! 🎬

---

**Status**: 
- [ ] Basic Setup Complete (TMDB API)
- [ ] Full Setup Complete (Firebase + TMDB)
- [ ] Tested on Device
- [ ] Ready for Production
