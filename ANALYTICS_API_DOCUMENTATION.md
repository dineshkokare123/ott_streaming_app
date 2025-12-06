# 📊 Analytics API Documentation

## Overview

This document describes the API endpoints needed for the Advanced Analytics feature with Year in Review (Spotify Wrapped style).

---

## Base URL

```
https://your-api-domain.com/api/v1
```

---

## Authentication

All requests require authentication via Bearer token:

```http
Authorization: Bearer {user_token}
```

---

## API Endpoints

### 1. **Record Watch Session**

Record a new watch session for analytics tracking.

**Endpoint**: `POST /analytics/sessions`

**Request Body**:
```json
{
  "userId": "user123",
  "id": "session_abc123",
  "contentId": 12345,
  "contentTitle": "Inception",
  "contentType": "movie",
  "genre": "Action",
  "watchTimeMinutes": 120,
  "startTime": "2024-12-05T15:30:00Z",
  "endTime": "2024-12-05T17:30:00Z",
  "completed": true
}
```

**Response**: `201 Created`
```json
{
  "success": true,
  "sessionId": "session_abc123",
  "message": "Watch session recorded successfully"
}
```

---

### 2. **Get Watch Sessions**

Retrieve user's watch history.

**Endpoint**: `GET /analytics/sessions?userId={userId}&limit={limit}`

**Query Parameters**:
- `userId` (required): User ID
- `limit` (optional): Number of sessions to return (default: 50)

**Response**: `200 OK`
```json
{
  "sessions": [
    {
      "id": "session_abc123",
      "contentId": 12345,
      "contentTitle": "Inception",
      "contentType": "movie",
      "genre": "Action",
      "watchTimeMinutes": 120,
      "startTime": "2024-12-05T15:30:00Z",
      "endTime": "2024-12-05T17:30:00Z",
      "completed": true
    }
  ],
  "total": 150
}
```

---

### 3. **Get Daily Stats**

Get watch statistics grouped by day.

**Endpoint**: `GET /analytics/daily?userId={userId}&days={days}`

**Query Parameters**:
- `userId` (required): User ID
- `days` (optional): Number of days to fetch (default: 30)

**Response**: `200 OK`
```json
{
  "dailyStats": [
    {
      "date": "2024-12-05T00:00:00Z",
      "watchTimeMinutes": 180,
      "sessionsCount": 3,
      "genresWatched": ["Action", "Comedy", "Drama"]
    },
    {
      "date": "2024-12-04T00:00:00Z",
      "watchTimeMinutes": 120,
      "sessionsCount": 2,
      "genresWatched": ["Thriller", "Sci-Fi"]
    }
  ]
}
```

---

### 4. **Get Genre Statistics**

Get user's genre preferences and watch time by genre.

**Endpoint**: `GET /analytics/genres?userId={userId}`

**Response**: `200 OK`
```json
{
  "genreStats": [
    {
      "genre": "Action",
      "watchTimeMinutes": 1200,
      "contentCount": 15,
      "percentage": 35.5
    },
    {
      "genre": "Comedy",
      "watchTimeMinutes": 800,
      "contentCount": 12,
      "percentage": 23.7
    },
    {
      "genre": "Drama",
      "watchTimeMinutes": 600,
      "contentCount": 8,
      "percentage": 17.8
    }
  ]
}
```

---

### 5. **Get Viewing Patterns**

Get user's viewing patterns by time of day.

**Endpoint**: `GET /analytics/patterns?userId={userId}`

**Response**: `200 OK`
```json
{
  "patterns": [
    {
      "timeSlot": "evening",
      "watchTimeMinutes": 1500,
      "sessionsCount": 25
    },
    {
      "timeSlot": "night",
      "watchTimeMinutes": 1200,
      "sessionsCount": 20
    },
    {
      "timeSlot": "afternoon",
      "watchTimeMinutes": 800,
      "sessionsCount": 15
    },
    {
      "timeSlot": "morning",
      "watchTimeMinutes": 300,
      "sessionsCount": 5
    }
  ]
}
```

**Time Slots**:
- `morning`: 6AM - 12PM
- `afternoon`: 12PM - 6PM
- `evening`: 6PM - 10PM
- `night`: 10PM - 6AM

---

### 6. **Get Year in Review** 🎉

Generate Spotify Wrapped-style year in review.

**Endpoint**: `GET /analytics/year-in-review?userId={userId}&year={year}`

**Query Parameters**:
- `userId` (required): User ID
- `year` (required): Year (e.g., 2024)

**Response**: `200 OK`
```json
{
  "year": 2024,
  "totalWatchTimeMinutes": 12000,
  "totalWatchTimeHours": 200,
  "moviesWatched": 85,
  "showsWatched": 42,
  "episodesWatched": 320,
  "topGenre": "Action",
  "topGenres": [
    {
      "genre": "Action",
      "watchTimeMinutes": 3600,
      "contentCount": 30,
      "percentage": 30.0
    },
    {
      "genre": "Comedy",
      "watchTimeMinutes": 2400,
      "contentCount": 25,
      "percentage": 20.0
    }
  ],
  "favoriteMovie": "Inception",
  "favoriteShow": "Breaking Bad",
  "mostWatchedDay": "Saturday",
  "preferredTimeSlot": "evening",
  "longestStreak": 45,
  "averageRating": 8.2,
  "achievements": [
    "Watched 100+ hours",
    "45-day streak",
    "Explored 15 genres"
  ],
  "monthlyWatchTime": {
    "January": 800,
    "February": 900,
    "March": 1100,
    "April": 950,
    "May": 1050,
    "June": 980,
    "July": 1200,
    "August": 1100,
    "September": 950,
    "October": 1000,
    "November": 1050,
    "December": 920
  }
}
```

---

### 7. **Get Personalized Insights**

Get AI-generated personalized insights.

**Endpoint**: `GET /analytics/insights?userId={userId}`

**Response**: `200 OK`
```json
{
  "insights": [
    {
      "id": "insight_1",
      "type": "trend",
      "title": "You're on a roll! 🔥",
      "description": "You've watched content for 7 days straight. Keep the streak going!",
      "icon": "🔥",
      "generatedAt": "2024-12-05T10:00:00Z"
    },
    {
      "id": "insight_2",
      "type": "recommendation",
      "title": "Action fan detected! 💥",
      "description": "70% of your watch time is action movies. Check out our new action releases!",
      "icon": "💥",
      "generatedAt": "2024-12-05T10:00:00Z"
    },
    {
      "id": "insight_3",
      "type": "milestone",
      "title": "100 hours milestone! 🎉",
      "description": "You've watched 100 hours of content this year. That's dedication!",
      "icon": "🎉",
      "generatedAt": "2024-12-05T10:00:00Z"
    }
  ]
}
```

**Insight Types**:
- `trend`: Viewing trends and patterns
- `recommendation`: Content recommendations based on behavior
- `achievement`: Milestones and achievements
- `milestone`: Special milestones reached

---

## Backend Implementation Example

### Node.js/Express Example

```javascript
// Record watch session
app.post('/api/v1/analytics/sessions', async (req, res) => {
  const { userId, ...sessionData } = req.body;
  
  try {
    // Save to database
    await db.collection('watchSessions').insertOne({
      userId,
      ...sessionData,
      createdAt: new Date()
    });
    
    // Update user stats
    await updateUserStats(userId, sessionData);
    
    res.status(201).json({
      success: true,
      sessionId: sessionData.id,
      message: 'Watch session recorded successfully'
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get daily stats
app.get('/api/v1/analytics/daily', async (req, res) => {
  const { userId, days = 30 } = req.query;
  
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - days);
  
  const sessions = await db.collection('watchSessions')
    .find({
      userId,
      startTime: { $gte: startDate }
    })
    .toArray();
  
  // Group by date
  const dailyStats = groupByDate(sessions);
  
  res.json({ dailyStats });
});

// Generate year in review
app.get('/api/v1/analytics/year-in-review', async (req, res) => {
  const { userId, year } = req.query;
  
  const startDate = new Date(`${year}-01-01`);
  const endDate = new Date(`${year}-12-31`);
  
  const sessions = await db.collection('watchSessions')
    .find({
      userId,
      startTime: { $gte: startDate, $lte: endDate }
    })
    .toArray();
  
  const yearInReview = generateYearInReview(sessions, year);
  
  res.json(yearInReview);
});
```

---

## Database Schema

### Watch Sessions Collection

```javascript
{
  _id: ObjectId,
  userId: String,
  id: String,
  contentId: Number,
  contentTitle: String,
  contentType: String, // 'movie' or 'tv'
  genre: String,
  watchTimeMinutes: Number,
  startTime: Date,
  endTime: Date,
  completed: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

### User Stats Collection

```javascript
{
  _id: ObjectId,
  userId: String,
  totalWatchTimeMinutes: Number,
  moviesWatched: Number,
  showsWatched: Number,
  episodesWatched: Number,
  currentStreak: Number,
  longestStreak: Number,
  lastActiveDate: Date,
  genreStats: [{
    genre: String,
    watchTimeMinutes: Number,
    contentCount: Number
  }],
  viewingPatterns: [{
    timeSlot: String,
    watchTimeMinutes: Number,
    sessionsCount: Number
  }],
  updatedAt: Date
}
```

---

## Integration Steps

### 1. **Setup Backend**

```bash
# Install dependencies
npm install express mongoose

# Create API routes
mkdir routes
touch routes/analytics.js

# Setup database connection
# Configure MongoDB/PostgreSQL
```

### 2. **Configure Flutter App**

```dart
// In main.dart
ChangeNotifierProvider(
  create: (_) => AnalyticsProvider(
    baseUrl: 'https://your-api-domain.com/api/v1',
    userId: currentUser.id,
  ),
)
```

### 3. **Record Watch Sessions**

```dart
// When user watches content
final analytics = context.read<AnalyticsProvider>();
await analytics.recordWatchSession(
  WatchSession(
    id: 'session_${DateTime.now().millisecondsSinceEpoch}',
    contentId: content.id,
    contentTitle: content.title,
    contentType: content.mediaType,
    genre: content.genres?.first,
    watchTimeMinutes: watchedMinutes,
    startTime: sessionStart,
    endTime: DateTime.now(),
    completed: watchedMinutes >= totalDuration * 0.9,
  ),
);
```

### 4. **Display Analytics**

```dart
// Navigate to analytics screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AnalyticsScreen(),
  ),
);
```

---

## Testing

### cURL Examples

```bash
# Record watch session
curl -X POST https://your-api.com/api/v1/analytics/sessions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer {token}" \
  -d '{
    "userId": "user123",
    "id": "session_test",
    "contentId": 12345,
    "contentTitle": "Test Movie",
    "contentType": "movie",
    "watchTimeMinutes": 120,
    "startTime": "2024-12-05T15:00:00Z",
    "endTime": "2024-12-05T17:00:00Z",
    "completed": true
  }'

# Get year in review
curl https://your-api.com/api/v1/analytics/year-in-review?userId=user123&year=2024 \
  -H "Authorization: Bearer {token}"
```

---

## Security Considerations

1. **Authentication**: Always verify user tokens
2. **Rate Limiting**: Implement rate limiting on all endpoints
3. **Data Privacy**: Only return data for authenticated user
4. **Input Validation**: Validate all input data
5. **HTTPS Only**: Use HTTPS for all API calls

---

## Performance Optimization

1. **Caching**: Cache frequently accessed data (Redis)
2. **Indexing**: Index userId and date fields in database
3. **Pagination**: Implement pagination for large datasets
4. **Aggregation**: Use database aggregation for stats
5. **Background Jobs**: Generate year in review asynchronously

---

## Error Handling

```json
{
  "error": {
    "code": "INVALID_REQUEST",
    "message": "Missing required field: userId",
    "details": {
      "field": "userId",
      "type": "required"
    }
  }
}
```

**Error Codes**:
- `INVALID_REQUEST`: Invalid request parameters
- `UNAUTHORIZED`: Authentication failed
- `NOT_FOUND`: Resource not found
- `SERVER_ERROR`: Internal server error

---

## Next Steps

1. ✅ Set up backend API
2. ✅ Create database schema
3. ✅ Implement API endpoints
4. ✅ Test with Postman/cURL
5. ✅ Integrate with Flutter app
6. ✅ Test end-to-end
7. ✅ Deploy to production

---

**📊 Your analytics system is ready to track and visualize user behavior!**

---

**Last Updated**: December 5, 2025
**Version**: 1.0.0
**API Version**: v1
