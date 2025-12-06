import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gamification_provider.dart';
import '../constants/app_colors.dart';

import 'dart:math';
import 'package:confetti/confetti.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    // Celebrate upon entering the screen!
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Achievements',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.celebration, color: AppColors.primary),
            onPressed: () {
              _confettiController.play();
            },
            tooltip: 'Celebrate!',
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<GamificationProvider>(
            builder: (context, gamification, _) {
              // stats is available via gamification object passed to sub-widgets

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // User Stats Header
                  _buildStatsHeader(gamification),
                  const SizedBox(height: 24),

                  // Daily Challenges section
                  const Text(
                    'Daily Challenges',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...gamification.dailyChallenges.map(
                    (challenge) => _DailyChallengeCard(challenge: challenge),
                  ),

                  const SizedBox(height: 24),

                  // Achievements Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'All Achievements',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${gamification.unlockedAchievements.length}/${gamification.achievements.length}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Unlocked
                  if (gamification.unlockedAchievements.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Unlocked',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...gamification.unlockedAchievements.map(
                      (a) => _AchievementCard(achievement: a, isUnlocked: true),
                    ),
                  ],

                  // Locked
                  if (gamification.lockedAchievements.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Locked',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...gamification.lockedAchievements.map(
                      (a) =>
                          _AchievementCard(achievement: a, isUnlocked: false),
                    ),
                  ],
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.topCenter,
            child: RepaintBoundary(
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: pi / 2,
                maxBlastForce: 5,
                minBlastForce: 2,
                emissionFrequency: 0.05,
                numberOfParticles: 50,
                gravity: 0.1,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsHeader(GamificationProvider gamification) {
    final stats = gamification.stats;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Level and Points
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${stats.level}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    stats.levelTitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${stats.totalPoints}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Total Points',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next Level',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    '${stats.currentLevelProgress} / ${stats.pointsToNextLevel} XP',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: stats.levelProgressPercentage / 100,
                  backgroundColor: Colors.black26,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                  minHeight: 8,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: '🔥',
                value: '${stats.currentStreak}',
                label: 'Streak',
              ),
              _StatItem(
                icon: '🏆',
                value: '${stats.achievementsUnlocked}',
                label: 'Unlocked',
              ),
              _StatItem(
                icon: '⏱️',
                value: '${(stats.totalWatchTime / 60).toStringAsFixed(1)}h',
                label: 'Hours',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Text(icon, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}

class _DailyChallengeCard extends StatelessWidget {
  final DailyChallenge challenge;

  const _DailyChallengeCard({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: challenge.isCompleted
            ? Border.all(color: Colors.green.withValues(alpha: 0.5), width: 1)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: challenge.isCompleted
                      ? Colors.green.withValues(alpha: 0.2)
                      : AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  challenge.isCompleted ? Icons.check : Icons.star,
                  color: challenge.isCompleted
                      ? Colors.green
                      : AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      challenge.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+${challenge.points} pts',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: challenge.progressPercentage / 100,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation(
                challenge.isCompleted ? Colors.green : AppColors.primary,
              ),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${challenge.currentProgress}/${challenge.targetValue}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;

  const _AchievementCard({required this.achievement, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.6,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: isUnlocked
              ? Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 1)
              : null,
          boxShadow: isUnlocked
              ? [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? Colors.amber.withValues(alpha: 0.2)
                    : Colors.grey.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Text(
                isUnlocked ? achievement.icon : '🔒',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.title,
                    style: TextStyle(
                      color: isUnlocked
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    achievement.description,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  if (!isUnlocked &&
                      achievement.type != AchievementType.special) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: achievement.progressPercentage / 100,
                        backgroundColor: AppColors.background,
                        valueColor: const AlwaysStoppedAnimation(
                          AppColors.primary,
                        ),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${achievement.currentProgress}/${achievement.targetValue}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${achievement.points}',
                  style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Text(
                  'pts',
                  style: TextStyle(color: Colors.amber, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
