# GitHub Pages Setup Guide

## 🌐 Create Your Application URL for TMDB

Follow these steps to create a live URL for your TMDB API application:

### Option 1: GitHub Pages (Recommended - Free & Easy)

#### Step 1: Push Your Code to GitHub

```bash
# If you haven't added remote yet
git remote add origin https://github.com/YOUR_USERNAME/ott-streaming-app.git

# Push your code
git push -u origin main
```

#### Step 2: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** tab
3. Scroll down to **Pages** section (left sidebar)
4. Under **Source**, select:
   - Branch: `main`
   - Folder: `/docs`
5. Click **Save**

#### Step 3: Wait for Deployment

- GitHub will deploy your site (takes 1-2 minutes)
- Your URL will be: `https://YOUR_USERNAME.github.io/ott-streaming-app`

#### Step 4: Use This URL for TMDB

✅ **Your Application URL**: `https://YOUR_USERNAME.github.io/ott-streaming-app`

---

### Option 2: Use GitHub Repository URL (Simplest)

If you don't want to set up GitHub Pages:

✅ **Your Application URL**: `https://github.com/YOUR_USERNAME/ott-streaming-app`

This is perfectly acceptable for TMDB API applications!

---

### Option 3: Custom Domain (Advanced)

If you have a custom domain:

1. Register a domain (e.g., streamvibe.app)
2. Configure DNS settings
3. Add CNAME file to docs folder
4. Update GitHub Pages settings

---

## 📝 TMDB API Application Form

### Where to Apply

🔗 **TMDB API Registration**: https://www.themoviedb.org/settings/api

### What You'll Need

1. **TMDB Account**
   - Create account at: https://www.themoviedb.org/signup
   - Verify your email

2. **Application Information**
   - Use the details from `TMDB_APPLICATION_INFO.md`

### Form Fields

**Application Name:**
```
StreamVibe - Premium OTT Platform
```

**Application URL:**
```
https://YOUR_USERNAME.github.io/ott-streaming-app
OR
https://github.com/YOUR_USERNAME/ott-streaming-app
```

**Application Summary:**
```
StreamVibe is a premium over-the-top (OTT) streaming platform built with Flutter 
that provides users with a Netflix-like experience for discovering and watching 
movies and TV shows. The app integrates with The Movie Database (TMDB) API to 
provide real-time content information, including trending movies, popular shows, 
top-rated content, and comprehensive search functionality.
```

**How will you use the API:**
```
Our application uses the TMDB API to:

1. Display trending movies and TV shows
2. Show popular and top-rated content
3. Provide comprehensive search functionality
4. Fetch detailed movie/show information including cast, crew, and ratings
5. Access trailer videos and promotional content
6. Display high-quality posters and backdrop images
7. Implement personalized recommendations based on TMDB data

We implement proper caching to minimize API calls and display TMDB attribution 
throughout the app. The application is built with Flutter for iOS and Android 
platforms and uses Firebase for user authentication and data storage.
```

**Type of Use:**
- Select: **Website** or **Other** (Mobile App)
- Select: **Non-Commercial** (for now)

---

## ✅ After Getting Your API Key

### Step 1: Update Your App

1. Open `lib/constants/api_constants.dart`
2. Replace the placeholder:
   ```dart
   static const String apiKey = 'YOUR_ACTUAL_API_KEY_HERE';
   ```

### Step 2: Test the API

```bash
flutter run
```

Verify that:
- ✅ Trending content loads
- ✅ Search works
- ✅ Content details display
- ✅ Images load correctly

### Step 3: Secure Your API Key

**Important**: Don't commit your real API key to GitHub!

Create `.gitignore` entry:
```
# API Keys
lib/constants/api_constants.dart
```

Or use environment variables:
```dart
static const String apiKey = String.fromEnvironment('TMDB_API_KEY');
```

---

## 🎯 Quick Start Commands

### Push to GitHub (First Time)

```bash
# Create repository on GitHub first, then:
git remote add origin https://github.com/YOUR_USERNAME/ott-streaming-app.git
git branch -M main
git push -u origin main
```

### Enable GitHub Pages

1. Go to: `https://github.com/YOUR_USERNAME/ott-streaming-app/settings/pages`
2. Source: `main` branch, `/docs` folder
3. Save

### Your Live URL

After 1-2 minutes:
```
https://YOUR_USERNAME.github.io/ott-streaming-app
```

---

## 📋 Checklist

Before submitting TMDB application:

- [ ] Code pushed to GitHub
- [ ] Repository is public
- [ ] README.md is complete
- [ ] GitHub Pages enabled (optional)
- [ ] Landing page accessible
- [ ] TMDB account created
- [ ] Application form filled out
- [ ] Terms of service accepted

After getting API key:

- [ ] API key added to app
- [ ] App tested with real data
- [ ] API key secured (not in git)
- [ ] Attribution added to app
- [ ] Rate limiting implemented

---

## 🆘 Troubleshooting

### GitHub Pages Not Working

1. Check repository settings
2. Ensure `/docs` folder exists
3. Wait 5-10 minutes for deployment
4. Check GitHub Actions tab for errors

### TMDB Application Rejected

Common reasons:
- Incomplete application form
- Invalid URL
- Unclear use case
- Commercial use without proper licensing

**Solution**: Reapply with more detailed information

### API Key Not Working

1. Check if key is correct
2. Verify API endpoint URLs
3. Check rate limits
4. Ensure proper authentication header

---

## 📞 Support

**TMDB Support**: https://www.themoviedb.org/talk
**GitHub Pages Docs**: https://docs.github.com/pages

---

## 🎉 You're Ready!

1. **Push your code to GitHub**
2. **Enable GitHub Pages** (optional)
3. **Apply for TMDB API key**
4. **Start building!**

Your application URL will be:
```
https://YOUR_USERNAME.github.io/ott-streaming-app
```

Or simply use:
```
https://github.com/YOUR_USERNAME/ott-streaming-app
```

Both are valid for TMDB API applications! 🚀
