import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';
import '../providers/gamification_provider.dart';
import '../constants/app_colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Your Stats',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Insights'),
            Tab(text: 'Year in Review'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_OverviewTab(), _InsightsTab(), _YearInReviewTab()],
      ),
    );
  }
}

/// Overview Tab
class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return Consumer2<AnalyticsProvider, GamificationProvider>(
      builder: (context, analytics, gamification, _) {
        if (analytics.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: analytics.refresh,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Stats Cards
              _buildStatsGrid(analytics, gamification),
              const SizedBox(height: 24),

              // Watch Time Chart
              _buildWatchTimeChart(analytics),
              const SizedBox(height: 24),

              // Genre Distribution
              _buildGenreDistribution(analytics),
              const SizedBox(height: 24),

              // Viewing Patterns
              _buildViewingPatterns(analytics),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(
    AnalyticsProvider analytics,
    GamificationProvider gamification,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          icon: '⏱️',
          value: '${analytics.totalWatchTimeHours}h',
          label: 'Total Watch Time',
          color: AppColors.primary,
        ),
        _StatCard(
          icon: '🎬',
          value: '${analytics.totalMoviesWatched}',
          label: 'Movies Watched',
          color: Colors.orange,
        ),
        _StatCard(
          icon: '📺',
          value: '${analytics.totalShowsWatched}',
          label: 'Shows Watched',
          color: Colors.purple,
        ),
        _StatCard(
          icon: '🔥',
          value: '${gamification.stats.currentStreak}',
          label: 'Day Streak',
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildWatchTimeChart(AnalyticsProvider analytics) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Watch Time (Last 7 Days)',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getWatchTimeSpots(analytics),
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getWatchTimeSpots(AnalyticsProvider analytics) {
    final spots = <FlSpot>[];
    final now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = DateTime(date.year, date.month, date.day);
      final stats = analytics.dailyStats[dateKey];
      final minutes = stats?.watchTimeMinutes ?? 0;
      spots.add(FlSpot((6 - i).toDouble(), minutes.toDouble()));
    }

    return spots;
  }

  Widget _buildGenreDistribution(AnalyticsProvider analytics) {
    if (analytics.genreStats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Favorite Genres',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: analytics.genreStats.take(5).map((genre) {
                  return PieChartSectionData(
                    value: genre.watchTimeMinutes.toDouble(),
                    title: '${genre.percentage.toStringAsFixed(0)}%',
                    color: _getGenreColor(genre.genre),
                    radius: 100,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...analytics.genreStats.take(5).map((genre) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getGenreColor(genre.genre),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      genre.genre,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                  Text(
                    '${genre.watchTimeMinutes ~/ 60}h',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildViewingPatterns(AnalyticsProvider analytics) {
    if (analytics.viewingPatterns.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Viewing Patterns',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...analytics.viewingPatterns.map((pattern) {
            final maxTime = analytics.viewingPatterns
                .map((p) => p.watchTimeMinutes)
                .reduce((a, b) => a > b ? a : b);
            final percentage = pattern.watchTimeMinutes / maxTime;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getTimeSlotLabel(pattern.timeSlot),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${pattern.watchTimeMinutes ~/ 60}h',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: percentage,
                    backgroundColor: AppColors.background,
                    valueColor: AlwaysStoppedAnimation(
                      _getTimeSlotColor(pattern.timeSlot),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getGenreColor(String genre) {
    final colors = {
      'Action': Colors.red,
      'Comedy': Colors.orange,
      'Drama': Colors.purple,
      'Thriller': Colors.blue,
      'Horror': Colors.deepPurple,
      'Romance': Colors.pink,
      'Sci-Fi': Colors.cyan,
      'Fantasy': Colors.indigo,
    };
    return colors[genre] ?? Colors.grey;
  }

  String _getTimeSlotLabel(String slot) {
    final labels = {
      'morning': '🌅 Morning (6AM - 12PM)',
      'afternoon': '☀️ Afternoon (12PM - 6PM)',
      'evening': '🌆 Evening (6PM - 10PM)',
      'night': '🌙 Night (10PM - 6AM)',
    };
    return labels[slot] ?? slot;
  }

  Color _getTimeSlotColor(String slot) {
    final colors = {
      'morning': Colors.orange,
      'afternoon': Colors.yellow,
      'evening': Colors.deepOrange,
      'night': Colors.indigo,
    };
    return colors[slot] ?? Colors.grey;
  }
}

/// Insights Tab
class _InsightsTab extends StatelessWidget {
  const _InsightsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsProvider>(
      builder: (context, analytics, _) {
        if (analytics.insights.isEmpty) {
          return const Center(
            child: Text(
              'No insights available yet.\nKeep watching to get personalized insights!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: analytics.insights.length,
          itemBuilder: (context, index) {
            final insight = analytics.insights[index];
            return _InsightCard(insight: insight);
          },
        );
      },
    );
  }
}

/// Year in Review Tab
class _YearInReviewTab extends StatelessWidget {
  const _YearInReviewTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsProvider>(
      builder: (context, analytics, _) {
        final yearInReview = analytics.yearInReview;

        if (yearInReview == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Your Year in Review',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    analytics.fetchYearInReview(DateTime.now().year);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Generate My 2024 Wrapped',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Spotify Wrapped style UI
        return PageView(
          children: [
            _WrappedPage1(yearInReview: yearInReview),
            _WrappedPage2(yearInReview: yearInReview),
            _WrappedPage3(yearInReview: yearInReview),
            _WrappedPage4(yearInReview: yearInReview),
          ],
        );
      },
    );
  }
}

/// Stat Card Widget
class _StatCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Insight Card Widget
class _InsightCard extends StatelessWidget {
  final PersonalizedInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(insight.icon, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Wrapped Page 1 - Total Watch Time
class _WrappedPage1 extends StatelessWidget {
  final YearInReview yearInReview;

  const _WrappedPage1({required this.yearInReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.accent],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your 2024',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '${yearInReview.totalWatchTimeHours}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'hours watched',
              style: TextStyle(color: Colors.white70, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

/// More wrapped pages would go here...
class _WrappedPage2 extends StatelessWidget {
  final YearInReview yearInReview;
  const _WrappedPage2({required this.yearInReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.purple,
      child: Center(
        child: Text(
          'Top Genre: ${yearInReview.topGenre}',
          style: const TextStyle(color: Colors.white, fontSize: 32),
        ),
      ),
    );
  }
}

class _WrappedPage3 extends StatelessWidget {
  final YearInReview yearInReview;
  const _WrappedPage3({required this.yearInReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      child: Center(
        child: Text(
          '${yearInReview.moviesWatched} Movies\n${yearInReview.showsWatched} Shows',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 32),
        ),
      ),
    );
  }
}

class _WrappedPage4 extends StatelessWidget {
  final YearInReview yearInReview;
  const _WrappedPage4({required this.yearInReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Text(
          'Longest Streak:\n${yearInReview.longestStreak} days 🔥',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 32),
        ),
      ),
    );
  }
}
