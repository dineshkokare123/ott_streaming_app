import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/content.dart';

/// Service to handle social sharing functionality
class SocialShareService {
  /// Share content to social media or other apps
  static Future<void> shareContent({
    required Content content,
    String? customMessage,
  }) async {
    final message = customMessage ?? _generateShareMessage(content);

    try {
      await Share.share(
        message,
        subject: 'Check out ${content.title} on StreamVibe!',
      );
    } catch (e) {
      debugPrint('Error sharing content: $e');
    }
  }

  /// Share with specific text and optional URL
  static Future<void> shareText({required String text, String? subject}) async {
    try {
      await Share.share(text, subject: subject);
    } catch (e) {
      debugPrint('Error sharing text: $e');
    }
  }

  /// Share to specific social media platform
  static Future<void> shareToSocialMedia({
    required Content content,
    required SocialPlatform platform,
  }) async {
    final message = _generateShareMessage(content);
    final encodedMessage = Uri.encodeComponent(message);

    String? url;

    switch (platform) {
      case SocialPlatform.twitter:
        url = 'https://twitter.com/intent/tweet?text=$encodedMessage';
        break;
      case SocialPlatform.whatsapp:
        url = 'https://wa.me/?text=$encodedMessage';
        break;
      case SocialPlatform.telegram:
        url = 'https://t.me/share/url?url=$encodedMessage';
        break;
      case SocialPlatform.instagram:
        // Instagram doesn't support direct sharing via URL
        await shareContent(content: content);
        return;
    }

    await _launchUrl(url);
  }

  /// Share watchlist
  static Future<void> shareWatchlist({
    required List<Content> watchlist,
    required String userName,
  }) async {
    final message = _generateWatchlistMessage(watchlist, userName);

    try {
      await Share.share(
        message,
        subject: '$userName\'s Watchlist on StreamVibe',
      );
    } catch (e) {
      debugPrint('Error sharing watchlist: $e');
    }
  }

  /// Share review
  static Future<void> shareReview({
    required Content content,
    required double rating,
    required String reviewText,
    required String userName,
  }) async {
    final message = _generateReviewMessage(
      content,
      rating,
      reviewText,
      userName,
    );

    try {
      await Share.share(
        message,
        subject: '$userName\'s review of ${content.title}',
      );
    } catch (e) {
      debugPrint('Error sharing review: $e');
    }
  }

  /// Invite friends to app
  static Future<void> inviteFriends() async {
    const message = '''
🎬 Join me on StreamVibe!

Discover and watch thousands of movies and TV shows. Download now and start streaming!

#StreamVibe #Movies #TVShows
    ''';

    try {
      await Share.share(message, subject: 'Join me on StreamVibe!');
    } catch (e) {
      debugPrint('Error inviting friends: $e');
    }
  }

  /// Copy link to clipboard
  static Future<void> copyLink(String link) async {
    try {
      await Share.share(link);
    } catch (e) {
      debugPrint('Error copying link: $e');
    }
  }

  // Private helper methods

  static String _generateShareMessage(Content content) {
    final type = content.isMovie ? 'movie' : 'TV show';
    return '''
🎬 Check out this $type: ${content.title}

${content.overview}

⭐ Rating: ${content.voteAverage}/10

Watch it on StreamVibe!
    ''';
  }

  static String _generateWatchlistMessage(
    List<Content> watchlist,
    String userName,
  ) {
    final buffer = StringBuffer();
    buffer.writeln('📺 $userName\'s Watchlist on StreamVibe\n');

    for (var i = 0; i < watchlist.length && i < 10; i++) {
      final content = watchlist[i];
      buffer.writeln('${i + 1}. ${content.title} ⭐ ${content.voteAverage}/10');
    }

    if (watchlist.length > 10) {
      buffer.writeln('\n...and ${watchlist.length - 10} more!');
    }

    buffer.writeln('\nJoin StreamVibe to create your own watchlist!');
    return buffer.toString();
  }

  static String _generateReviewMessage(
    Content content,
    double rating,
    String reviewText,
    String userName,
  ) {
    return '''
⭐ $userName's Review of ${content.title}

Rating: $rating/5 stars

"$reviewText"

Watch ${content.title} on StreamVibe!
    ''';
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}

/// Supported social media platforms
enum SocialPlatform { twitter, whatsapp, telegram, instagram }

/// Extension to get platform names and icons
extension SocialPlatformExtension on SocialPlatform {
  String get name {
    switch (this) {
      case SocialPlatform.twitter:
        return 'Twitter';
      case SocialPlatform.whatsapp:
        return 'WhatsApp';
      case SocialPlatform.telegram:
        return 'Telegram';
      case SocialPlatform.instagram:
        return 'Instagram';
    }
  }

  IconData get icon {
    switch (this) {
      case SocialPlatform.twitter:
        return Icons.flutter_dash; // Use appropriate icon
      case SocialPlatform.whatsapp:
        return Icons.chat;
      case SocialPlatform.telegram:
        return Icons.send;
      case SocialPlatform.instagram:
        return Icons.camera_alt;
    }
  }

  Color get color {
    switch (this) {
      case SocialPlatform.twitter:
        return const Color(0xFF1DA1F2);
      case SocialPlatform.whatsapp:
        return const Color(0xFF25D366);
      case SocialPlatform.telegram:
        return const Color(0xFF0088CC);
      case SocialPlatform.instagram:
        return const Color(0xFFE4405F);
    }
  }
}
