# TMDB API Application Information

## 📋 Application Details for TMDB Registration

### Basic Information

**Application Name:** StreamVibe - Premium OTT Platform

**Application Type:** Mobile Application (iOS & Android)

**Application URL:** 
- **GitHub Repository**: `https://github.com/YOUR_USERNAME/ott-streaming-app`
- **Alternative**: `https://streamvibe.app` (placeholder - use your actual domain if you have one)

**Application Summary:**
StreamVibe is a premium over-the-top (OTT) streaming platform built with Flutter that provides users with a Netflix-like experience for discovering and watching movies and TV shows. The app integrates with The Movie Database (TMDB) API to provide real-time content information, including trending movies, popular shows, top-rated content, and comprehensive search functionality.

### Detailed Description

**Purpose:**
StreamVibe is designed to be a comprehensive entertainment platform that helps users discover, track, and enjoy movies and TV shows. The application serves as a showcase of modern mobile development practices while providing a premium user experience.

**Key Features Using TMDB API:**
1. **Content Discovery**
   - Browse trending movies and TV shows
   - Explore popular content across different categories
   - Discover top-rated movies and series
   - Real-time content updates from TMDB

2. **Search Functionality**
   - Instant search across movies and TV shows
   - Autocomplete suggestions
   - Filter by media type

3. **Content Details**
   - Comprehensive movie/show information
   - Cast and crew details
   - Ratings and reviews
   - Release dates and runtime
   - Genres and keywords
   - High-quality posters and backdrops

4. **Video Integration**
   - Trailer playback using TMDB video keys
   - YouTube integration for official trailers
   - Full movie playback (simulated)

5. **Personalization**
   - User watchlists
   - Favorites management
   - Continue watching functionality
   - Personalized recommendations based on TMDB data

**Technology Stack:**
- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Backend**: Firebase (Authentication & Firestore)
- **API Integration**: TMDB API v3
- **Video Playback**: YouTube Player Flutter, Chewie, Video Player
- **UI/UX**: Custom liquid glass design, advanced animations

**Target Audience:**
- Movie and TV show enthusiasts
- Users looking for a premium streaming discovery platform
- Mobile users on iOS and Android devices

**Monetization:**
- Currently non-commercial (educational/portfolio project)
- Potential future premium features

### API Usage Details

**TMDB Endpoints Used:**
1. `/trending/all/week` - Trending content
2. `/movie/popular` - Popular movies
3. `/movie/top_rated` - Top rated movies
4. `/tv/popular` - Popular TV shows
5. `/search/multi` - Multi-search functionality
6. `/movie/{id}` - Movie details
7. `/tv/{id}` - TV show details
8. `/movie/{id}/videos` - Movie trailers
9. `/tv/{id}/videos` - TV show trailers
10. `/configuration` - API configuration

**Image Assets:**
- Poster images (w342, w500)
- Backdrop images (w780, original)
- Profile images for cast

**Expected API Call Volume:**
- Development: ~1,000 requests/day
- Production: ~10,000-50,000 requests/day (estimated)

**Caching Strategy:**
- Content cached locally for 24 hours
- Images cached using Flutter's cached_network_image
- Firestore used for user-specific data

### Contact Information

**Developer Name:** Dinesh Kokare

**Email:** your.email@example.com (replace with your actual email)

**GitHub:** https://github.com/dineshkokare

**Project Repository:** https://github.com/dineshkokare/ott-streaming-app

### Compliance & Attribution

**TMDB Attribution:**
- TMDB logo displayed in app footer
- "Powered by TMDB" attribution on all content pages
- Link to TMDB website in About section
- Proper attribution in app description

**Terms of Service:**
- Full compliance with TMDB API Terms of Use
- No commercial use of TMDB data without proper licensing
- Proper attribution and branding
- No unauthorized scraping or data collection

**Privacy:**
- User data stored securely in Firebase
- No sharing of user data with third parties
- TMDB API key stored securely (not in version control)
- Compliance with GDPR and privacy regulations

### Screenshots & Media

**App Screenshots:**
(To be added after deployment)
- Splash screen with liquid glass effect
- Home screen with content rows
- Search functionality
- Content detail page
- Video player
- User profile

**Demo Video:**
(To be created)
- App walkthrough
- Feature demonstration
- TMDB integration showcase

### Deployment Information

**Current Status:** Development

**Planned Release:**
- iOS App Store: Q1 2025
- Google Play Store: Q1 2025

**Beta Testing:**
- TestFlight (iOS): Available
- Google Play Beta: Available

**Version:** 1.0.0

### Additional Information

**Open Source:**
- Repository: Public on GitHub
- License: MIT License
- Contributions: Welcome

**Documentation:**
- README.md with setup instructions
- QUICKSTART.md for rapid onboarding
- API integration documentation
- Feature documentation

**Support:**
- GitHub Issues for bug reports
- Email support for users
- Community Discord (planned)

---

## 📝 How to Use This Information

### For TMDB API Application:

1. **Go to**: https://www.themoviedb.org/settings/api

2. **Click**: "Request an API Key"

3. **Select**: "Developer" (for non-commercial use) or "Commercial" (if monetizing)

4. **Fill in the form with**:
   - **Application Name**: StreamVibe - Premium OTT Platform
   - **Application URL**: Your GitHub repository URL or website
   - **Application Summary**: (Copy from above)
   - **How will you use the API**: (Copy "Key Features Using TMDB API" section)

5. **Accept**: Terms of Use

6. **Submit**: Application

### Temporary URL Options (Before Deployment):

**Option 1: GitHub Repository (Recommended)**
```
https://github.com/YOUR_USERNAME/ott-streaming-app
```

**Option 2: GitHub Pages (If you create documentation site)**
```
https://YOUR_USERNAME.github.io/ott-streaming-app
```

**Option 3: Placeholder Domain**
```
https://streamvibe.app (register this domain if available)
```

**Option 4: Development URL**
```
http://localhost:8080 (for development only)
```

### After Getting API Key:

1. Copy your API key
2. Open `lib/constants/api_constants.dart`
3. Replace `YOUR_TMDB_API_KEY` with your actual key
4. **Never commit the API key to GitHub**
5. Use environment variables in production

---

## ⚠️ Important Notes

1. **API Key Security**:
   - Never commit API keys to version control
   - Use environment variables
   - Add `api_constants.dart` to `.gitignore` if it contains real keys

2. **Attribution Requirements**:
   - Display TMDB logo in your app
   - Add "Powered by TMDB" text
   - Link to TMDB website

3. **Rate Limits**:
   - TMDB allows 40 requests per 10 seconds
   - Implement proper caching
   - Handle rate limit errors gracefully

4. **Commercial Use**:
   - If monetizing, apply for commercial API key
   - Different terms and pricing apply

---

**Ready to submit your TMDB API application!** 🚀

Use the information above to fill out the TMDB API request form.
