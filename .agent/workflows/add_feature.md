---
description: How to add a new feature to the app
---

# Adding a New Feature

1. **Plan the Feature**
   - Identify necessary UI changes
   - Identify necessary data/API changes
   - Identify new dependencies

2. **Update Dependencies**
   - Add packages to `pubspec.yaml`
   - Run `flutter pub get`

3. **Implement Data Layer**
   - Update Models if needed
   - Update Services (API/Auth)
   - Update Providers

4. **Implement UI**
   - Create new screens/widgets
   - Update existing screens
   - Connect UI to Providers

5. **Verify**
   - Run `flutter analyze`
   - Run the app and test manually
