import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/auth_provider.dart';
import 'providers/content_provider.dart';
import 'providers/watchlist_provider.dart';
import 'providers/continue_watching_provider.dart';
import 'providers/recommendations_provider.dart';
import 'providers/download_provider.dart';
import 'providers/reviews_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/notification_provider.dart';
import 'services/localization_service.dart';
import 'services/cast_service.dart';
import 'services/connectivity_service.dart';
import 'providers/gamification_provider.dart';
import 'providers/analytics_provider.dart';
import 'services/theme_service.dart';
import 'services/subscription_service.dart';
import 'services/smart_notification_service.dart';
import 'services/content_extras_service.dart';
import 'services/social_watching_service.dart';
import 'services/creator_studio_service.dart';
import 'services/smart_download_service.dart';
import 'services/social_service.dart';
import 'services/appsflyer_service.dart';
import 'screens/splash_screen.dart';
import 'constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
    // Continue without .env for now, but API calls may fail
  }

  // Initialize Firebase (Note: You'll need to add Firebase configuration)
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Continue without Firebase for now
  }

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ContentProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => ContinueWatchingProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationsProvider()),
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
        ChangeNotifierProvider(create: (_) => ReviewsProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProfileProvider>(
          create: (_) => ProfileProvider(),
          update: (context, authProvider, previous) {
            final provider = previous ?? ProfileProvider();

            if (authProvider.currentUser != null &&
                !provider.hasProfiles &&
                !provider.isLoading) {
              // Trigger load in microtask to avoid build-phase side effects
              Future.microtask(() {
                provider.loadProfiles(authProvider.currentUser!);
              });
            } else if (authProvider.currentUser == null) {
              provider.clearProfiles();
            }

            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => LocalizationService()),
        ChangeNotifierProvider(create: (_) => CastService()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => GamificationProvider()),
        ChangeNotifierProxyProvider<AuthProvider, AnalyticsProvider>(
          create: (_) => AnalyticsProvider(
            baseUrl: dotenv.env['API_BASE_URL'] ?? 'https://api.example.com/v1',
            userId: '',
          ),
          update: (context, authProvider, previous) {
            final userId = authProvider.currentUser?.id ?? '';
            if (previous != null && previous.userId == userId) {
              return previous;
            }
            return AnalyticsProvider(
              baseUrl:
                  dotenv.env['API_BASE_URL'] ?? 'https://api.example.com/v1',
              userId: userId,
            );
          },
        ),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => SubscriptionService()),
        ChangeNotifierProvider(create: (_) => SmartNotificationService()),
        ChangeNotifierProvider(create: (_) => ContentExtrasService()),
        ChangeNotifierProvider(create: (_) => SocialWatchingService()),
        ChangeNotifierProvider(create: (_) => SocialService()),
        ChangeNotifierProvider(create: (_) => AppsFlyerService()),
        ChangeNotifierProvider(create: (_) => CreatorStudioService()),
        ChangeNotifierProxyProvider<DownloadProvider, SmartDownloadService>(
          create: (context) => SmartDownloadService(
            Provider.of<DownloadProvider>(context, listen: false),
          ),
          update: (context, downloadProvider, previous) =>
              SmartDownloadService(downloadProvider),
        ),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, child) {
          return MaterialApp(
            title: 'StreamVibe',
            debugShowCheckedModeBanner: false,
            theme: themeService.getTheme(),
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return SplashScreen(
                  isAuthenticated: authProvider.isAuthenticated,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
