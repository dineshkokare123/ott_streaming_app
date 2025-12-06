import 'package:flutter/material.dart';

/// Supported languages in the app
enum AppLanguage {
  english('en', 'English', '🇺🇸'),
  spanish('es', 'Español', '🇪🇸'),
  french('fr', 'Français', '🇫🇷'),
  german('de', 'Deutsch', '🇩🇪'),
  italian('it', 'Italiano', '🇮🇹'),
  portuguese('pt', 'Português', '🇵🇹'),
  japanese('ja', '日本語', '🇯🇵'),
  korean('ko', '한국어', '🇰🇷'),
  chinese('zh', '中文', '🇨🇳'),
  hindi('hi', 'हिन्दी', '🇮🇳'),
  arabic('ar', 'العربية', '🇸🇦'),
  russian('ru', 'Русский', '🇷🇺');

  final String code;
  final String name;
  final String flag;

  const AppLanguage(this.code, this.name, this.flag);

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.english,
    );
  }
}

/// Localization service for multi-language support
class LocalizationService extends ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.english;

  AppLanguage get currentLanguage => _currentLanguage;
  Locale get currentLocale => _currentLanguage.locale;

  /// Change app language
  Future<void> changeLanguage(AppLanguage language) async {
    if (_currentLanguage == language) return;

    _currentLanguage = language;
    notifyListeners();

    // Save to preferences
    // await SharedPreferences.getInstance().then((prefs) {
    //   prefs.setString('language', language.code);
    // });
  }

  /// Get localized string
  String translate(String key) {
    // Try to find translation in current language
    final localizedString = _translations[_currentLanguage.code]?[key];
    if (localizedString != null) {
      return localizedString;
    }

    // Fallback to English
    return _englishTranslations[key] ?? key;
  }

  /// Translations map
  static const Map<String, Map<String, String>> _translations = {
    'en': _englishTranslations,
    'es': _spanishTranslations,
    'fr': _frenchTranslations,
    'de': _germanTranslations,
    'hi': _hindiTranslations,
    'ja': _japaneseTranslations,
    'zh': _chineseTranslations,
    'ar': _arabicTranslations,
  };
}

// English Translations (Default)
const Map<String, String> _englishTranslations = {
  // Navigation
  'nav_home': 'Home',
  'nav_search': 'Search',
  'nav_watchlist': 'My List',
  'nav_downloads': 'Downloads',
  'nav_profile': 'Profile',

  // Home Screen
  'trending_now': 'Trending Now',
  'top_rated': 'Top Rated',
  'continue_watching': 'Continue Watching',
  'recommended_for_you': 'Recommended For You',
  'new_releases': 'New Releases',
  'popular_movies': 'Popular Movies',
  'popular_tv_shows': 'Popular TV Shows',
  'because_you_watched': 'Because You Watched',
  'top_picks': 'Top Picks For You',

  // Search
  'search_placeholder': 'Search movies, TV shows...',
  'search_results': 'Search Results',
  'no_results': 'No results found',
  'search_movies': 'Movies',
  'search_tv': 'TV Shows',

  // Content Detail
  'play': 'Play',
  'trailer': 'Trailer',
  'my_list': 'My List',
  'download': 'Download',
  'downloaded': 'Downloaded',
  'downloading': 'Downloading',
  'rate_review': 'Rate & Review',
  'overview': 'Overview',
  'more_like_this': 'More Like This',
  'cast': 'Cast',
  'seasons': 'Seasons',
  'episodes': 'Episodes',

  // Profile
  'edit_profile': 'Edit Profile',
  'notifications': 'Notifications',
  'privacy_security': 'Privacy & Security',
  'watch_history': 'Watch History',
  'downloads': 'Downloads',
  'settings': 'Settings',
  'language': 'Language',
  'sign_out': 'Sign Out',
  'account': 'Account',
  'content': 'Content',

  // Downloads
  'download_quality': 'Download Quality',
  'select_quality': 'Select Quality',
  'storage_used': 'Storage Used',
  'delete_download': 'Delete Download',
  'download_complete': 'Download Complete',

  // Reviews
  'write_review': 'Write a Review',
  'your_rating': 'Your Rating',
  'your_review': 'Your Review',
  'submit_review': 'Submit Review',
  'edit_review': 'Edit Review',
  'delete_review': 'Delete Review',

  // Notifications
  'mark_all_read': 'Mark all read',
  'clear_all': 'Clear all',
  'no_notifications': 'No notifications yet',

  // Actions Messages
  'added_to_list': 'Added to My List',
  'removed_from_list': 'Removed from My List',
  'added_to_favorites': 'Added to Favorites',
  'removed_from_favorites': 'Removed from Favorites',
  'select_profile_first': 'Please select a profile first',

  // Media Types
  'movie': 'Movie',
  'episode': 'Episode',

  // Cast to TV
  'cast_to_tv': 'Cast to TV',
  'available_devices': 'Available Devices',
  'connected_to': 'Connected to',
  'disconnect': 'Disconnect',
  'scanning_devices': 'Scanning for devices...',
  'no_devices_found': 'No devices found',
  'cast_connected': 'Connected to',
  'cast_disconnected': 'Disconnected',

  // Common
  'cancel': 'Cancel',
  'ok': 'OK',
  'save': 'Save',
  'delete': 'Delete',
  'edit': 'Edit',
  'close': 'Close',
  'retry': 'Retry',
  'loading': 'Loading...',
  'error': 'Error',
  'success': 'Success',
  'confirm': 'Confirm',
  'yes': 'Yes',
  'no': 'No',

  // Time
  'min': 'min',
  'hour': 'hour',
  'hours': 'hours',
  'day': 'day',
  'days': 'days',
  'week': 'week',
  'weeks': 'weeks',
  'month': 'month',
  'months': 'months',
  'year': 'year',
  'years': 'years',
  'just_now': 'Just now',
  'ago': 'ago',
};

// Spanish Translations
const Map<String, String> _spanishTranslations = {
  'nav_home': 'Inicio',
  'nav_search': 'Buscar',
  'nav_watchlist': 'Mi Lista',
  'nav_downloads': 'Descargas',
  'nav_profile': 'Perfil',
  'trending_now': 'Tendencias',
  'top_rated': 'Mejor Valoradas',
  'continue_watching': 'Continuar Viendo',
  'recommended_for_you': 'Recomendado Para Ti',
  'play': 'Reproducir',
  'trailer': 'Tráiler',
  'my_list': 'Mi Lista',
  'download': 'Descargar',
  'downloaded': 'Descargado',
  'downloading': 'Descargando',
  'overview': 'Sinopsis',
  'more_like_this': 'Más Como Esto',
  'sign_out': 'Cerrar Sesión',
  'language': 'Idioma',
  'cancel': 'Cancelar',
  'ok': 'OK',
  'save': 'Guardar',
  'delete': 'Eliminar',
  'loading': 'Cargando...',
  'cast_to_tv': 'Transmitir a TV',
  'available_devices': 'Dispositivos Disponibles',
  'disconnect': 'Desconectar',
};

// French Translations
const Map<String, String> _frenchTranslations = {
  'nav_home': 'Accueil',
  'nav_search': 'Rechercher',
  'nav_watchlist': 'Ma Liste',
  'nav_downloads': 'Téléchargements',
  'nav_profile': 'Profil',
  'trending_now': 'Tendances',
  'top_rated': 'Mieux Notés',
  'continue_watching': 'Continuer à Regarder',
  'recommended_for_you': 'Recommandé Pour Vous',
  'play': 'Lire',
  'trailer': 'Bande-annonce',
  'my_list': 'Ma Liste',
  'download': 'Télécharger',
  'downloaded': 'Téléchargé',
  'downloading': 'Téléchargement',
  'overview': 'Synopsis',
  'more_like_this': 'Plus Comme Ça',
  'sign_out': 'Se Déconnecter',
  'language': 'Langue',
  'cancel': 'Annuler',
  'ok': 'OK',
  'save': 'Enregistrer',
  'delete': 'Supprimer',
  'loading': 'Chargement...',
  'cast_to_tv': 'Diffuser sur TV',
  'available_devices': 'Appareils Disponibles',
  'disconnect': 'Déconnecter',
};

// German Translations
const Map<String, String> _germanTranslations = {
  'nav_home': 'Startseite',
  'nav_search': 'Suchen',
  'nav_watchlist': 'Meine Liste',
  'nav_downloads': 'Downloads',
  'nav_profile': 'Profil',
  'trending_now': 'Trending',
  'top_rated': 'Top Bewertet',
  'continue_watching': 'Weiterschauen',
  'recommended_for_you': 'Empfohlen Für Sie',
  'play': 'Abspielen',
  'trailer': 'Trailer',
  'my_list': 'Meine Liste',
  'download': 'Herunterladen',
  'downloaded': 'Heruntergeladen',
  'downloading': 'Wird heruntergeladen',
  'overview': 'Übersicht',
  'more_like_this': 'Mehr Wie Dies',
  'sign_out': 'Abmelden',
  'language': 'Sprache',
  'cancel': 'Abbrechen',
  'ok': 'OK',
  'save': 'Speichern',
  'delete': 'Löschen',
  'loading': 'Wird geladen...',
  'cast_to_tv': 'Auf TV übertragen',
  'available_devices': 'Verfügbare Geräte',
  'disconnect': 'Trennen',
};

// Hindi Translations
const Map<String, String> _hindiTranslations = {
  'nav_home': 'होम',
  'nav_search': 'खोजें',
  'nav_watchlist': 'मेरी सूची',
  'nav_downloads': 'डाउनलोड',
  'nav_profile': 'प्रोफ़ाइल',
  'trending_now': 'ट्रेंडिंग',
  'top_rated': 'शीर्ष रेटेड',
  'continue_watching': 'देखना जारी रखें',
  'recommended_for_you': 'आपके लिए अनुशंसित',
  'play': 'चलाएं',
  'trailer': 'ट्रेलर',
  'my_list': 'मेरी सूची',
  'download': 'डाउनलोड करें',
  'downloaded': 'डाउनलोड किया गया',
  'downloading': 'डाउनलोड हो रहा है',
  'overview': 'अवलोकन',
  'more_like_this': 'इस जैसे और',
  'sign_out': 'साइन आउट',
  'language': 'भाषा',
  'cancel': 'रद्द करें',
  'ok': 'ठीक है',
  'save': 'सहेजें',
  'delete': 'हटाएं',
  'loading': 'लोड हो रहा है...',
  'cast_to_tv': 'टीवी पर कास्ट करें',
  'available_devices': 'उपलब्ध डिवाइस',
  'disconnect': 'डिस्कनेक्ट करें',
};

// Japanese Translations
const Map<String, String> _japaneseTranslations = {
  'nav_home': 'ホーム',
  'nav_search': '検索',
  'nav_watchlist': 'マイリスト',
  'nav_downloads': 'ダウンロード',
  'nav_profile': 'プロフィール',
  'trending_now': 'トレンド',
  'top_rated': '高評価',
  'continue_watching': '視聴を続ける',
  'recommended_for_you': 'おすすめ',
  'play': '再生',
  'trailer': '予告編',
  'my_list': 'マイリスト',
  'download': 'ダウンロード',
  'downloaded': 'ダウンロード済み',
  'downloading': 'ダウンロード中',
  'overview': '概要',
  'more_like_this': '類似作品',
  'sign_out': 'サインアウト',
  'language': '言語',
  'cancel': 'キャンセル',
  'ok': 'OK',
  'save': '保存',
  'delete': '削除',
  'loading': '読み込み中...',
  'cast_to_tv': 'テレビにキャスト',
  'available_devices': '利用可能なデバイス',
  'disconnect': '切断',
};

// Chinese Translations
const Map<String, String> _chineseTranslations = {
  'nav_home': '首页',
  'nav_search': '搜索',
  'nav_watchlist': '我的列表',
  'nav_downloads': '下载',
  'nav_profile': '个人资料',
  'trending_now': '热门',
  'top_rated': '高评分',
  'continue_watching': '继续观看',
  'recommended_for_you': '为您推荐',
  'play': '播放',
  'trailer': '预告片',
  'my_list': '我的列表',
  'download': '下载',
  'downloaded': '已下载',
  'downloading': '下载中',
  'overview': '概述',
  'more_like_this': '更多类似内容',
  'sign_out': '退出',
  'language': '语言',
  'cancel': '取消',
  'ok': '确定',
  'save': '保存',
  'delete': '删除',
  'loading': '加载中...',
  'cast_to_tv': '投屏到电视',
  'available_devices': '可用设备',
  'disconnect': '断开连接',
};

// Arabic Translations
const Map<String, String> _arabicTranslations = {
  'nav_home': 'الرئيسية',
  'nav_search': 'بحث',
  'nav_watchlist': 'قائمتي',
  'nav_downloads': 'التنزيلات',
  'nav_profile': 'الملف الشخصي',
  'trending_now': 'الأكثر رواجاً',
  'top_rated': 'الأعلى تقييماً',
  'continue_watching': 'متابعة المشاهدة',
  'recommended_for_you': 'موصى به لك',
  'play': 'تشغيل',
  'trailer': 'إعلان',
  'my_list': 'قائمتي',
  'download': 'تنزيل',
  'downloaded': 'تم التنزيل',
  'downloading': 'جاري التنزيل',
  'overview': 'نظرة عامة',
  'more_like_this': 'المزيد مثل هذا',
  'sign_out': 'تسجيل الخروج',
  'language': 'اللغة',
  'cancel': 'إلغاء',
  'ok': 'موافق',
  'save': 'حفظ',
  'delete': 'حذف',
  'loading': 'جاري التحميل...',
  'cast_to_tv': 'البث على التلفزيون',
  'available_devices': 'الأجهزة المتاحة',
  'disconnect': 'قطع الاتصال',
};

/// Extension to easily access translations
extension LocalizationExtension on String {
  String tr(LocalizationService localization) {
    return localization.translate(this);
  }
}
