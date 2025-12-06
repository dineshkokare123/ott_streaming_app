import 'package:flutter/foundation.dart';

/// Achievement types
enum AchievementType {
  watchTime,
  contentCount,
  streak,
  genre,
  rating,
  social,
  special,
}

/// Achievement model
class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon; // emoji
  final int points;
  final AchievementType type;
  final int targetValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final int currentProgress;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.points,
    required this.type,
    required this.targetValue,
    this.isUnlocked = false,
    this.unlockedAt,
    this.currentProgress = 0,
  });

  double get progressPercentage =>
      (currentProgress / targetValue * 100).clamp(0, 100);

  Achievement copyWith({
    bool? isUnlocked,
    DateTime? unlockedAt,
    int? currentProgress,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      points: points,
      type: type,
      targetValue: targetValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      currentProgress: currentProgress ?? this.currentProgress,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'points': points,
    'type': type.name,
    'targetValue': targetValue,
    'isUnlocked': isUnlocked,
    'unlockedAt': unlockedAt?.toIso8601String(),
    'currentProgress': currentProgress,
  };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    icon: json['icon'],
    points: json['points'],
    type: AchievementType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => AchievementType.special,
    ),
    targetValue: json['targetValue'],
    isUnlocked: json['isUnlocked'] ?? false,
    unlockedAt: json['unlockedAt'] != null
        ? DateTime.parse(json['unlockedAt'])
        : null,
    currentProgress: json['currentProgress'] ?? 0,
  );
}

/// Badge model
class Badge {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String rarity; // common, rare, epic, legendary
  final DateTime earnedAt;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.rarity,
    required this.earnedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'icon': icon,
    'rarity': rarity,
    'earnedAt': earnedAt.toIso8601String(),
  };

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    icon: json['icon'],
    rarity: json['rarity'],
    earnedAt: DateTime.parse(json['earnedAt']),
  );
}

/// Daily challenge model
class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final int points;
  final int targetValue;
  final int currentProgress;
  final DateTime expiresAt;
  final bool isCompleted;

  DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
    required this.targetValue,
    this.currentProgress = 0,
    required this.expiresAt,
    this.isCompleted = false,
  });

  double get progressPercentage =>
      (currentProgress / targetValue * 100).clamp(0, 100);

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  DailyChallenge copyWith({int? currentProgress, bool? isCompleted}) {
    return DailyChallenge(
      id: id,
      title: title,
      description: description,
      points: points,
      targetValue: targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      expiresAt: expiresAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'points': points,
    'targetValue': targetValue,
    'currentProgress': currentProgress,
    'expiresAt': expiresAt.toIso8601String(),
    'isCompleted': isCompleted,
  };

  factory DailyChallenge.fromJson(Map<String, dynamic> json) => DailyChallenge(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    points: json['points'],
    targetValue: json['targetValue'],
    currentProgress: json['currentProgress'] ?? 0,
    expiresAt: DateTime.parse(json['expiresAt']),
    isCompleted: json['isCompleted'] ?? false,
  );
}

/// User stats for gamification
class UserStats {
  final int totalPoints;
  final int level;
  final int currentStreak;
  final int longestStreak;
  final int totalWatchTime; // in minutes
  final int moviesWatched;
  final int showsWatched;
  final int achievementsUnlocked;
  final DateTime lastActive;

  UserStats({
    this.totalPoints = 0,
    this.level = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalWatchTime = 0,
    this.moviesWatched = 0,
    this.showsWatched = 0,
    this.achievementsUnlocked = 0,
    required this.lastActive,
  });

  int get pointsToNextLevel => (level * 1000);
  int get currentLevelProgress => totalPoints % 1000;
  double get levelProgressPercentage =>
      (currentLevelProgress / pointsToNextLevel * 100).clamp(0, 100);

  String get levelTitle {
    if (level < 5) return 'Newbie';
    if (level < 10) return 'Movie Fan';
    if (level < 20) return 'Binge Watcher';
    if (level < 30) return 'Cinephile';
    if (level < 50) return 'Film Buff';
    return 'Legend';
  }

  UserStats copyWith({
    int? totalPoints,
    int? level,
    int? currentStreak,
    int? longestStreak,
    int? totalWatchTime,
    int? moviesWatched,
    int? showsWatched,
    int? achievementsUnlocked,
    DateTime? lastActive,
  }) {
    return UserStats(
      totalPoints: totalPoints ?? this.totalPoints,
      level: level ?? this.level,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalWatchTime: totalWatchTime ?? this.totalWatchTime,
      moviesWatched: moviesWatched ?? this.moviesWatched,
      showsWatched: showsWatched ?? this.showsWatched,
      achievementsUnlocked: achievementsUnlocked ?? this.achievementsUnlocked,
      lastActive: lastActive ?? this.lastActive,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalPoints': totalPoints,
    'level': level,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'totalWatchTime': totalWatchTime,
    'moviesWatched': moviesWatched,
    'showsWatched': showsWatched,
    'achievementsUnlocked': achievementsUnlocked,
    'lastActive': lastActive.toIso8601String(),
  };

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
    totalPoints: json['totalPoints'] ?? 0,
    level: json['level'] ?? 1,
    currentStreak: json['currentStreak'] ?? 0,
    longestStreak: json['longestStreak'] ?? 0,
    totalWatchTime: json['totalWatchTime'] ?? 0,
    moviesWatched: json['moviesWatched'] ?? 0,
    showsWatched: json['showsWatched'] ?? 0,
    achievementsUnlocked: json['achievementsUnlocked'] ?? 0,
    lastActive: DateTime.parse(json['lastActive']),
  );
}

/// Gamification provider
class GamificationProvider extends ChangeNotifier {
  UserStats _stats = UserStats(lastActive: DateTime.now());
  List<Achievement> _achievements = [];
  final List<Badge> _badges = [];
  List<DailyChallenge> _dailyChallenges = [];

  UserStats get stats => _stats;
  List<Achievement> get achievements => _achievements;
  List<Badge> get badges => _badges;
  List<DailyChallenge> get dailyChallenges => _dailyChallenges;

  List<Achievement> get unlockedAchievements =>
      _achievements.where((a) => a.isUnlocked).toList();

  List<Achievement> get lockedAchievements =>
      _achievements.where((a) => !a.isUnlocked).toList();

  GamificationProvider() {
    _initializeAchievements();
    _generateDailyChallenges();
  }

  /// Initialize all achievements
  void _initializeAchievements() {
    _achievements = [
      // Watch time achievements
      Achievement(
        id: 'first_watch',
        title: 'First Watch',
        description: 'Watch your first movie or show',
        icon: '🎬',
        points: 10,
        type: AchievementType.watchTime,
        targetValue: 1,
      ),
      Achievement(
        id: 'binge_watcher',
        title: 'Binge Watcher',
        description: 'Watch 10 hours of content',
        icon: '📺',
        points: 50,
        type: AchievementType.watchTime,
        targetValue: 600, // minutes
      ),
      Achievement(
        id: 'marathon_master',
        title: 'Marathon Master',
        description: 'Watch 50 hours of content',
        icon: '🏃',
        points: 200,
        type: AchievementType.watchTime,
        targetValue: 3000,
      ),

      // Content count achievements
      Achievement(
        id: 'movie_buff',
        title: 'Movie Buff',
        description: 'Watch 50 movies',
        icon: '🎥',
        points: 100,
        type: AchievementType.contentCount,
        targetValue: 50,
      ),
      Achievement(
        id: 'series_addict',
        title: 'Series Addict',
        description: 'Watch 20 TV shows',
        icon: '📺',
        points: 100,
        type: AchievementType.contentCount,
        targetValue: 20,
      ),

      // Streak achievements
      Achievement(
        id: 'week_streak',
        title: 'Week Warrior',
        description: 'Watch content 7 days in a row',
        icon: '🔥',
        points: 75,
        type: AchievementType.streak,
        targetValue: 7,
      ),
      Achievement(
        id: 'month_streak',
        title: 'Monthly Master',
        description: 'Watch content 30 days in a row',
        icon: '💪',
        points: 300,
        type: AchievementType.streak,
        targetValue: 30,
      ),

      // Genre achievements
      Achievement(
        id: 'action_hero',
        title: 'Action Hero',
        description: 'Watch 20 action movies',
        icon: '💥',
        points: 50,
        type: AchievementType.genre,
        targetValue: 20,
      ),
      Achievement(
        id: 'comedy_king',
        title: 'Comedy King',
        description: 'Watch 20 comedy shows',
        icon: '😂',
        points: 50,
        type: AchievementType.genre,
        targetValue: 20,
      ),

      // Rating achievements
      Achievement(
        id: 'critic',
        title: 'Critic',
        description: 'Rate 50 movies or shows',
        icon: '⭐',
        points: 75,
        type: AchievementType.rating,
        targetValue: 50,
      ),

      // Social achievements
      Achievement(
        id: 'social_butterfly',
        title: 'Social Butterfly',
        description: 'Share 10 movies with friends',
        icon: '🦋',
        points: 50,
        type: AchievementType.social,
        targetValue: 10,
      ),
    ];
  }

  /// Generate daily challenges
  void _generateDailyChallenges() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final endOfDay = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

    _dailyChallenges = [
      DailyChallenge(
        id: 'daily_watch',
        title: 'Daily Viewer',
        description: 'Watch 1 movie or episode today',
        points: 20,
        targetValue: 1,
        expiresAt: endOfDay,
      ),
      DailyChallenge(
        id: 'daily_rate',
        title: 'Daily Critic',
        description: 'Rate 3 movies or shows today',
        points: 15,
        targetValue: 3,
        expiresAt: endOfDay,
      ),
      DailyChallenge(
        id: 'daily_discover',
        title: 'Daily Explorer',
        description: 'Add 5 items to your watchlist',
        points: 10,
        targetValue: 5,
        expiresAt: endOfDay,
      ),
    ];
  }

  /// Award points to user
  void awardPoints(int points, {String? reason}) {
    final newPoints = _stats.totalPoints + points;
    final newLevel = (newPoints / 1000).floor() + 1;

    _stats = _stats.copyWith(totalPoints: newPoints, level: newLevel);

    notifyListeners();

    // Check for level up
    if (newLevel > _stats.level) {
      _onLevelUp(newLevel);
    }
  }

  /// Record watch activity
  void recordWatch({
    required bool isMovie,
    required int watchTimeMinutes,
    String? genre,
  }) {
    _stats = _stats.copyWith(
      totalWatchTime: _stats.totalWatchTime + watchTimeMinutes,
      moviesWatched: isMovie ? _stats.moviesWatched + 1 : _stats.moviesWatched,
      showsWatched: !isMovie ? _stats.showsWatched + 1 : _stats.showsWatched,
      lastActive: DateTime.now(),
    );

    // Update streak
    _updateStreak();

    // Award points
    awardPoints(watchTimeMinutes ~/ 10); // 1 point per 10 minutes

    // Check achievements
    _checkAchievements();

    // Update daily challenges
    _updateDailyChallenges('watch', 1);

    notifyListeners();
  }

  /// Update streak
  void _updateStreak() {
    final now = DateTime.now();
    final lastActive = _stats.lastActive;
    final daysDiff = now.difference(lastActive).inDays;

    if (daysDiff == 1) {
      // Consecutive day
      final newStreak = _stats.currentStreak + 1;
      _stats = _stats.copyWith(
        currentStreak: newStreak,
        longestStreak: newStreak > _stats.longestStreak
            ? newStreak
            : _stats.longestStreak,
      );
    } else if (daysDiff > 1) {
      // Streak broken
      _stats = _stats.copyWith(currentStreak: 1);
    }
  }

  /// Check and unlock achievements
  void _checkAchievements() {
    for (var i = 0; i < _achievements.length; i++) {
      final achievement = _achievements[i];
      if (achievement.isUnlocked) continue;

      int progress = 0;

      switch (achievement.type) {
        case AchievementType.watchTime:
          progress = _stats.totalWatchTime;
          break;
        case AchievementType.contentCount:
          progress = _stats.moviesWatched + _stats.showsWatched;
          break;
        case AchievementType.streak:
          progress = _stats.currentStreak;
          break;
        default:
          continue;
      }

      _achievements[i] = achievement.copyWith(currentProgress: progress);

      if (progress >= achievement.targetValue) {
        _unlockAchievement(i);
      }
    }
  }

  /// Unlock achievement
  void _unlockAchievement(int index) {
    final achievement = _achievements[index];
    _achievements[index] = achievement.copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );

    _stats = _stats.copyWith(
      achievementsUnlocked: _stats.achievementsUnlocked + 1,
    );

    awardPoints(
      achievement.points,
      reason: 'Achievement: ${achievement.title}',
    );

    // Award badge
    _awardBadge(achievement);
  }

  /// Award badge
  void _awardBadge(Achievement achievement) {
    final badge = Badge(
      id: 'badge_${achievement.id}',
      name: achievement.title,
      description: achievement.description,
      icon: achievement.icon,
      rarity: _getBadgeRarity(achievement.points),
      earnedAt: DateTime.now(),
    );

    _badges.add(badge);
  }

  /// Get badge rarity based on points
  String _getBadgeRarity(int points) {
    if (points >= 200) return 'legendary';
    if (points >= 100) return 'epic';
    if (points >= 50) return 'rare';
    return 'common';
  }

  /// Update daily challenges
  void _updateDailyChallenges(String type, int progress) {
    for (var i = 0; i < _dailyChallenges.length; i++) {
      final challenge = _dailyChallenges[i];
      if (challenge.isCompleted || challenge.isExpired) continue;

      if ((type == 'watch' && challenge.id == 'daily_watch') ||
          (type == 'rate' && challenge.id == 'daily_rate') ||
          (type == 'watchlist' && challenge.id == 'daily_discover')) {
        final newProgress = challenge.currentProgress + progress;
        _dailyChallenges[i] = challenge.copyWith(currentProgress: newProgress);

        if (newProgress >= challenge.targetValue) {
          _completeDailyChallenge(i);
        }
      }
    }
  }

  /// Complete daily challenge
  void _completeDailyChallenge(int index) {
    final challenge = _dailyChallenges[index];
    _dailyChallenges[index] = challenge.copyWith(isCompleted: true);
    awardPoints(challenge.points, reason: 'Challenge: ${challenge.title}');
  }

  /// Level up callback
  void _onLevelUp(int newLevel) {
    debugPrint('🎉 Level Up! Now level $newLevel');
    // Show level up animation/notification
  }

  /// Get leaderboard position (mock - in production, fetch from backend)
  Future<int> getLeaderboardPosition() async {
    // In production, fetch from backend
    return 42; // Mock position
  }
}
