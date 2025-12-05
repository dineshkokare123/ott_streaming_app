# 🔒 API Key Security Guide

## Overview

This project now uses **environment variables** to securely manage API keys. Your sensitive API keys are **no longer hardcoded** in the source code and will **not be committed** to version control.

## 🚨 Important Security Notes

- **NEVER** commit the `.env` file to Git
- **NEVER** share your `.env` file publicly
- **ALWAYS** use `.env.example` as a template for other developers
- The `.env` file is already added to `.gitignore` for your protection

## 🛠️ Setup Instructions

### For First-Time Setup

1. **Copy the example environment file:**
   ```bash
   cp .env.example .env
   ```

2. **Get your TMDB API Key:**
   - Go to [https://www.themoviedb.org/](https://www.themoviedb.org/)
   - Sign up for a free account
   - Navigate to Settings → API
   - Request an API key (instant approval)
   - Copy your API key

3. **Get your RapidAPI Key:**
   - Go to [https://rapidapi.com/gox-ai-gox-ai-default/api/ott-details](https://rapidapi.com/gox-ai-gox-ai-default/api/ott-details)
   - Sign up or log in
   - Subscribe to the API (free tier available)
   - Copy your API key

4. **Update your `.env` file:**
   ```env
   TMDB_API_KEY=your_actual_tmdb_api_key_here
   RAPID_API_KEY=your_actual_rapidapi_key_here
   RAPID_API_HOST=ott-details.p.rapidapi.com
   ```

5. **Install dependencies:**
   ```bash
   flutter pub get
   ```

6. **Run the app:**
   ```bash
   flutter run
   ```

## 📁 File Structure

```
ott_streaming_app/
├── .env                    # Your actual API keys (NEVER commit this!)
├── .env.example           # Template file (safe to commit)
├── .gitignore             # Contains .env to prevent commits
└── lib/
    ├── main.dart          # Loads .env at startup
    └── constants/
        └── api_constants.dart  # Reads from environment variables
```

## 🔍 How It Works

### 1. Environment Variables Loading

The app loads environment variables at startup in `main.dart`:

```dart
await dotenv.load(fileName: ".env");
```

### 2. Accessing API Keys

API keys are accessed through getters in `api_constants.dart`:

```dart
static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
static String get rapidApiKey => dotenv.env['RAPID_API_KEY'] ?? '';
```

### 3. Git Protection

The `.gitignore` file includes `.env` to prevent accidental commits:

```
# Environment variables (contains sensitive API keys)
.env
```

## ✅ Verification Checklist

Before running the app, verify:

- [ ] `.env` file exists in the project root
- [ ] `.env` contains your actual API keys
- [ ] `.env` is listed in `.gitignore`
- [ ] `flutter pub get` has been run
- [ ] No API keys are hardcoded in `api_constants.dart`

## 🚀 For Team Members

If you're cloning this repository:

1. **DO NOT** expect a `.env` file - it's not in the repository
2. **Copy** `.env.example` to `.env`
3. **Add your own** API keys to the `.env` file
4. **Run** `flutter pub get`

## 🔧 Troubleshooting

### Error: "API key is empty"

**Solution:** Make sure your `.env` file exists and contains valid API keys.

### Error: "Unable to load asset: .env"

**Solution:** 
1. Verify `.env` file exists in the project root
2. Check that `pubspec.yaml` includes `.env` in assets:
   ```yaml
   flutter:
     assets:
       - .env
   ```
3. Run `flutter pub get` and restart the app

### API calls failing

**Solution:**
1. Verify your API keys are correct in `.env`
2. Check that you've subscribed to the RapidAPI service
3. Ensure your TMDB API key is activated

## 📚 Additional Resources

- [TMDB API Documentation](https://developers.themoviedb.org/3)
- [RapidAPI OTT Details](https://rapidapi.com/gox-ai-gox-ai-default/api/ott-details)
- [flutter_dotenv Package](https://pub.dev/packages/flutter_dotenv)

## 🛡️ Best Practices

1. **Rotate your API keys regularly** for enhanced security
2. **Use different API keys** for development and production
3. **Monitor your API usage** to detect unauthorized access
4. **Never log or print** API keys in your code
5. **Review commits** before pushing to ensure no secrets are included

## ⚠️ What Changed?

### Before (Insecure ❌)
```dart
static const String apiKey = '5119b1bb88f8b1133a139578c96a70f4';
```

### After (Secure ✅)
```dart
static String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
```

Your API keys are now:
- ✅ Stored in `.env` (not committed to Git)
- ✅ Loaded at runtime
- ✅ Protected from exposure
- ✅ Easy to rotate and manage

---

**Remember:** Security is everyone's responsibility! 🔐
