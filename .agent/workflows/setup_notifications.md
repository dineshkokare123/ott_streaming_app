---
description: How to setup and test Real-time Push Notifications (FCM)
---

# Setup Real-time Push Notifications

This workflow guides you through setting up Firebase Cloud Messaging (FCM) for real-time notifications.

## Prerequisites
- [x] `firebase_messaging` and `flutter_local_notifications` packages added.
- [x] `NotificationService` created and initialized in `main.dart`.
- [x] iOS `Info.plist` configured with background modes.

## Step 1: Firebase Console Setup (Crucial)

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Open your project settings (Gear icon > Project settings).
3. Go to the **Cloud Messaging** tab.
4. **iOS Only**:
    - Under "Apple app configuration", upload your APNs Authentication Key (.p8 file) from your Apple Developer account.
    - If you don't have one, create it at [developer.apple.com](https://developer.apple.com) under "Certificates, Identifiers & Profiles" > "Keys".

## Step 2: Platform Specific Setup

### iOS (Xcode)
You **must** enable the capability in Xcode for notifications to work on iOS.

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the `Runner` target in the project editor.
3. Click the **Signing & Capabilities** tab.
4. Click **+ Capability** (plus button).
5. Search for and add **Push Notifications**.
6. (Optional) Also add **Background Modes** if not checked, and ensure "Remote notifications" is checked.

### Android
No extra steps required. The plugin handles it.

## Step 3: Send a Test Notification

1. Run the app on your device/emulator.
   ```bash
   flutter run
   ```
2. Look at the debug console logs for:
   ```
   FCM Token: <some_long_string>
   ```
   Copy this token.

3. Go to **Firebase Console** > **Messaging**.
4. Click **Create your first campaign** (or New Campaign) > **Firebase Notification messages**.
5. Enter a **Notification Title** (e.g., "Hello StreamVibe!") and **Notification Text**.
6. Click **Send Test Message** (button on the right).
7. Paste the FCM Token you copied and click **Test**.

## Troubleshooting

- **Notification not showing in foreground?**
  - Check `NotificationService` -> `_showForegroundNotification`.
- **Background notification not working?**
  - Ensure `_firebaseMessagingBackgroundHandler` is a top-level function (it is).
  - iOS: Ensure "Push Notifications" capability is enabled in Xcode.
