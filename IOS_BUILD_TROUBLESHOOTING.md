# iOS Build Troubleshooting Guide

## ✅ Issue Fixed: Unsupported option '-G' for target 'x86_64-apple-ios10.0-simulator'

This error occurs when the iOS deployment target is too old or architecture settings are incorrect.

### What We Fixed:

1. **Updated Podfile** (`ios/Podfile`):
   - Set minimum iOS version to 13.0
   - Added deployment target configuration
   - Excluded arm64 for simulator builds

2. **Cleaned and Reinstalled**:
   - Removed old Pods
   - Reinstalled with correct settings
   - Cleaned Flutter build cache

### Changes Made to Podfile:

```ruby
# Set iOS platform version
platform :ios, '13.0'

# In post_install block, added:
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
```

## 🚀 How to Run the App Now

### Option 1: Using Flutter Command
```bash
flutter run
```

### Option 2: Using Xcode
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your simulator or device
3. Click Run (▶️)

### Option 3: Specific Device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

## 🔧 Common iOS Build Issues & Solutions

### Issue 1: "No such module 'Firebase'"
**Solution:**
```bash
cd ios
pod install
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue 2: "CocoaPods not installed"
**Solution:**
```bash
sudo gem install cocoapods
pod setup
```

### Issue 3: "Xcode version too old"
**Solution:**
- Update Xcode from App Store
- Run: `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`

### Issue 4: "Signing requires a development team"
**Solution:**
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner in project navigator
3. Go to "Signing & Capabilities"
4. Select your team or use "Automatically manage signing"

### Issue 5: "Build failed with exit code 65"
**Solution:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

### Issue 6: "The iOS deployment target is set to 8.0"
**Solution:**
- Already fixed in our Podfile
- Ensure `platform :ios, '13.0'` is uncommented

### Issue 7: "Multiple commands produce"
**Solution:**
```bash
cd ios
rm -rf build
cd ..
flutter clean
flutter run
```

## 📱 Simulator Issues

### Simulator Not Showing Up
```bash
# Open Simulator
open -a Simulator

# Or install specific simulator
xcodebuild -downloadPlatform iOS
```

### Simulator Running Slow
- Close other apps
- Restart simulator
- Reduce graphics quality in Simulator settings

## 🔍 Debug Build Issues

### Enable Verbose Logging
```bash
flutter run -v
```

### Check iOS Build Settings
```bash
cd ios
xcodebuild -showBuildSettings -workspace Runner.xcworkspace -scheme Runner
```

### Verify Pod Installation
```bash
cd ios
pod --version
pod repo update
pod install --verbose
```

## 🛠️ Complete Clean Build

If all else fails, do a complete clean:

```bash
# 1. Clean Flutter
flutter clean

# 2. Remove iOS build artifacts
cd ios
rm -rf Pods Podfile.lock build
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# 3. Reinstall pods
pod deintegrate
pod install

# 4. Back to project root
cd ..

# 5. Get dependencies
flutter pub get

# 6. Run
flutter run
```

## 📋 Pre-flight Checklist

Before running on iOS, ensure:
- ✅ Xcode is installed and updated
- ✅ Command Line Tools are installed
- ✅ CocoaPods is installed
- ✅ iOS Simulator is available
- ✅ Podfile has correct deployment target
- ✅ Firebase configuration files are in place
- ✅ TMDB API key is configured

## 🎯 Deployment Target Requirements

Our app requires:
- **Minimum iOS Version**: 13.0
- **Xcode Version**: 14.0 or higher
- **CocoaPods**: 1.11.0 or higher
- **Flutter**: Latest stable

## 📞 Still Having Issues?

1. Check Flutter doctor:
   ```bash
   flutter doctor -v
   ```

2. Check iOS setup:
   ```bash
   flutter doctor --verbose
   ```

3. Verify Xcode installation:
   ```bash
   xcode-select -p
   xcodebuild -version
   ```

4. Check CocoaPods:
   ```bash
   pod --version
   which pod
   ```

## 🔗 Useful Resources

- [Flutter iOS Setup](https://docs.flutter.dev/get-started/install/macos#ios-setup)
- [CocoaPods Guide](https://guides.cocoapods.org/)
- [Xcode Documentation](https://developer.apple.com/xcode/)
- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)

---

**Your app should now build successfully!** 🎉

Run `flutter run` to launch the app on your iOS simulator or device.
