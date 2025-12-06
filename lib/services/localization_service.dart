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

  // Genres
  'genre_action': 'Action Movies',
  'genre_scifi': 'Sci-Fi Movies',
  'genre_comedy': 'Comedy Movies',
  'genre_horror': 'Horror Movies',

  // Content Details Labels
  'label_popularity': 'Popularity',
  'label_vote_count': 'Vote Count',
  'label_language': 'Language',

  // Profile Menu Items
  'achievements': 'Achievements',
  'your_stats': 'Your Stats',
  'new_features': 'New Features',

  // Auth & Onboarding
  'welcome_back': 'Welcome Back',
  'sign_in_to_continue': 'Sign in to continue',
  'sign_in': 'Sign In',
  'sign_up': 'Sign Up',
  'email': 'Email',
  'password': 'Password',
  'forgot_password': 'Forgot Password?',
  'dont_have_account': "Don't have an account?",
  'already_have_account': 'Already have an account?',
  'create_account': 'Create Account',
  'full_name': 'Full Name',
  'confirm_password': 'Confirm Password',
  'sign_in_with_google': 'Sign in with Google',
  'or_sign_in_with_email': 'or sign in with email',

  // Common Actions
  'search': 'Search',
  'filter': 'Filter',
  'sort': 'Sort',
  'apply': 'Apply',
  'clear': 'Clear',
  'share': 'Share',
  'remove': 'Remove',

  // Messages
  'something_went_wrong': 'Something went wrong',
  'no_internet': 'No internet connection',
  'loading_content': 'Loading content...',
  'no_content_found': 'No content found',
  'search_results_for': 'Search results for',

  // Quality & Download
  'quality': 'Quality',
  'sd': 'SD',
  'hd': 'HD',
  'fhd': 'FHD',
  'downloading_in_quality': 'Downloading in',
  'already_downloaded': 'Already downloaded',
  'download_in_progress': 'Download in progress',

  // Video Player
  'no_trailer_available': 'No trailer available',
  'error_loading_video': 'Error loading video',

  // Reviews
  'reviews': 'Reviews',
  'write_a_review': 'Write a Review',
  'no_reviews_yet': 'No reviews yet',

  // Watchlist
  'empty_watchlist': 'Your watchlist is empty',
  'add_content_to_watchlist': 'Add content to your watchlist',

  // Search
  'recent_searches': 'Recent Searches',
  'trending_searches': 'Trending Searches',
  'clear_search_history': 'Clear search history',
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
  'popular_movies': 'Películas Populares',
  'popular_tv_shows': 'Series Populares',
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
  'achievements': 'Logros',
  'your_stats': 'Tus Estadísticas',
  'new_features': 'Nuevas Funciones',
  'watch_history': 'Historial de Visualización',
  'notifications': 'Notificaciones',
  'privacy_security': 'Privacidad y Seguridad',
  'edit_profile': 'Editar Perfil',
  'account': 'Cuenta',
  'content': 'Contenido',

  // Genres
  'genre_action': 'Películas de Acción',
  'genre_scifi': 'Películas de Ciencia Ficción',
  'genre_comedy': 'Películas de Comedia',
  'genre_horror': 'Películas de Terror',

  // Auth & Onboarding
  'welcome_back': 'Bienvenido de Nuevo',
  'sign_in_to_continue': 'Inicia sesión para continuar',
  'sign_in': 'Iniciar Sesión',
  'sign_up': 'Registrarse',
  'email': 'Correo Electrónico',
  'password': 'Contraseña',
  'forgot_password': '¿Olvidaste tu contraseña?',
  'dont_have_account': '¿No tienes una cuenta?',
  'already_have_account': '¿Ya tienes una cuenta?',
  'create_account': 'Crear Cuenta',
  'full_name': 'Nombre Completo',
  'confirm_password': 'Confirmar Contraseña',
  'sign_in_with_google': 'Iniciar sesión con Google',
  'or_sign_in_with_email': 'o inicia sesión con correo',

  // Common Actions
  'search': 'Buscar',
  'filter': 'Filtrar',
  'sort': 'Ordenar',
  'apply': 'Aplicar',
  'clear': 'Limpiar',
  'share': 'Compartir',
  'remove': 'Eliminar',

  // Messages
  'something_went_wrong': 'Algo salió mal',
  'no_internet': 'Sin conexión a internet',
  'loading_content': 'Cargando contenido...',
  'no_content_found': 'No se encontró contenido',
  'search_results_for': 'Resultados de búsqueda para',

  // Quality & Download
  'quality': 'Calidad',
  'sd': 'SD',
  'hd': 'HD',
  'fhd': 'FHD',
  'downloading_in_quality': 'Descargando en',
  'already_downloaded': 'Ya descargado',
  'download_in_progress': 'Descarga en progreso',

  // Video Player
  'no_trailer_available': 'No hay tráiler disponible',
  'error_loading_video': 'Error al cargar el video',

  // Reviews
  'reviews': 'Reseñas',
  'write_a_review': 'Escribir una Reseña',
  'no_reviews_yet': 'Aún no hay reseñas',

  // Watchlist
  'empty_watchlist': 'Tu lista está vacía',
  'add_content_to_watchlist': 'Agrega contenido a tu lista',

  // Search
  'recent_searches': 'Búsquedas Recientes',
  'trending_searches': 'Búsquedas Populares',
  'clear_search_history': 'Limpiar historial de búsqueda',
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
  'popular_movies': 'Films Populaires',
  'popular_tv_shows': 'Séries Populaires',
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
  'achievements': 'Réalisations',
  'your_stats': 'Vos Statistiques',
  'new_features': 'Nouvelles Fonctionnalités',
  'watch_history': 'Historique de Visionnage',
  'notifications': 'Notifications',
  'privacy_security': 'Confidentialité et Sécurité',
  'edit_profile': 'Modifier le Profil',
  'account': 'Compte',
  'content': 'Contenu',

  // Genres
  'genre_action': 'Films d\'Action',
  'genre_scifi': 'Films de Science-Fiction',
  'genre_comedy': 'Films de Comédie',
  'genre_horror': 'Films d\'Horreur',

  // Auth & Onboarding
  'welcome_back': 'Bon Retour',
  'sign_in_to_continue': 'Connectez-vous pour continuer',
  'sign_in': 'Se Connecter',
  'sign_up': 'S\'inscrire',
  'email': 'E-mail',
  'password': 'Mot de Passe',
  'forgot_password': 'Mot de passe oublié?',
  'dont_have_account': 'Vous n\'avez pas de compte?',
  'already_have_account': 'Vous avez déjà un compte?',
  'create_account': 'Créer un Compte',
  'full_name': 'Nom Complet',
  'confirm_password': 'Confirmer le Mot de Passe',
  'sign_in_with_google': 'Se connecter avec Google',
  'or_sign_in_with_email': 'ou connectez-vous par e-mail',

  // Common Actions
  'search': 'Rechercher',
  'filter': 'Filtrer',
  'sort': 'Trier',
  'apply': 'Appliquer',
  'clear': 'Effacer',
  'share': 'Partager',
  'remove': 'Supprimer',

  // Messages
  'something_went_wrong': 'Quelque chose s\'est mal passé',
  'no_internet': 'Pas de connexion Internet',
  'loading_content': 'Chargement du contenu...',
  'no_content_found': 'Aucun contenu trouvé',
  'search_results_for': 'Résultats de recherche pour',

  // Quality & Download
  'quality': 'Qualité',
  'sd': 'SD',
  'hd': 'HD',
  'fhd': 'FHD',
  'downloading_in_quality': 'Téléchargement en',
  'already_downloaded': 'Déjà téléchargé',
  'download_in_progress': 'Téléchargement en cours',

  // Video Player
  'no_trailer_available': 'Aucune bande-annonce disponible',
  'error_loading_video': 'Erreur de chargement de la vidéo',

  // Reviews
  'reviews': 'Avis',
  'write_a_review': 'Écrire un Avis',
  'no_reviews_yet': 'Pas encore d\'avis',

  // Watchlist
  'empty_watchlist': 'Votre liste est vide',
  'add_content_to_watchlist': 'Ajoutez du contenu à votre liste',

  // Search
  'recent_searches': 'Recherches Récentes',
  'trending_searches': 'Recherches Populaires',
  'clear_search_history': 'Effacer l\'historique de recherche',
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
  'popular_movies': 'Beliebte Filme',
  'popular_tv_shows': 'Beliebte Serien',
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
  'achievements': 'Erfolge',
  'your_stats': 'Ihre Statistiken',
  'new_features': 'Neue Funktionen',
  'watch_history': 'Wiedergabeverlauf',
  'notifications': 'Benachrichtigungen',
  'privacy_security': 'Datenschutz und Sicherheit',
  'edit_profile': 'Profil Bearbeiten',
  'account': 'Konto',
  'content': 'Inhalt',

  // Genres
  'genre_action': 'Actionfilme',
  'genre_scifi': 'Science-Fiction-Filme',
  'genre_comedy': 'Komödien',
  'genre_horror': 'Horrorfilme',

  // Auth & Onboarding
  'welcome_back': 'Willkommen Zurück',
  'sign_in_to_continue': 'Melden Sie sich an, um fortzufahren',
  'sign_in': 'Anmelden',
  'sign_up': 'Registrieren',
  'email': 'E-Mail',
  'password': 'Passwort',
  'forgot_password': 'Passwort vergessen?',
  'dont_have_account': 'Haben Sie kein Konto?',
  'already_have_account': 'Haben Sie bereits ein Konto?',
  'create_account': 'Konto Erstellen',
  'full_name': 'Vollständiger Name',
  'confirm_password': 'Passwort Bestätigen',
  'sign_in_with_google': 'Mit Google anmelden',
  'or_sign_in_with_email': 'oder per E-Mail anmelden',

  // Common Actions
  'search': 'Suchen',
  'filter': 'Filtern',
  'sort': 'Sortieren',
  'apply': 'Anwenden',
  'clear': 'Löschen',
  'share': 'Teilen',
  'remove': 'Entfernen',

  // Messages
  'something_went_wrong': 'Etwas ist schief gelaufen',
  'no_internet': 'Keine Internetverbindung',
  'loading_content': 'Inhalt wird geladen...',
  'no_content_found': 'Kein Inhalt gefunden',
  'search_results_for': 'Suchergebnisse für',

  // Quality & Download
  'quality': 'Qualität',
  'sd': 'SD',
  'hd': 'HD',
  'fhd': 'FHD',
  'downloading_in_quality': 'Wird heruntergeladen in',
  'already_downloaded': 'Bereits heruntergeladen',
  'download_in_progress': 'Download läuft',

  // Video Player
  'no_trailer_available': 'Kein Trailer verfügbar',
  'error_loading_video': 'Fehler beim Laden des Videos',

  // Reviews
  'reviews': 'Bewertungen',
  'write_a_review': 'Eine Bewertung Schreiben',
  'no_reviews_yet': 'Noch keine Bewertungen',

  // Watchlist
  'empty_watchlist': 'Ihre Liste ist leer',
  'add_content_to_watchlist': 'Fügen Sie Inhalte zu Ihrer Liste hinzu',

  // Search
  'recent_searches': 'Letzte Suchen',
  'trending_searches': 'Beliebte Suchen',
  'clear_search_history': 'Suchverlauf löschen',
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
  'popular_movies': 'लोकप्रिय फ़िल्में',
  'popular_tv_shows': 'लोकप्रिय टीवी शो',
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
  'achievements': 'उपलब्धियां',
  'your_stats': 'आपके आंकड़े',
  'new_features': 'नई सुविधाएं',
  'watch_history': 'देखने का इतिहास',
  'notifications': 'सूचनाएं',
  'privacy_security': 'गोपनीयता और सुरक्षा',
  'edit_profile': 'प्रोफ़ाइल संपादित करें',
  'account': 'खाता',
  'content': 'सामग्री',

  // Genres
  'genre_action': 'एक्शन फ़िल्में',
  'genre_scifi': 'विज्ञान कथा फ़िल्में',
  'genre_comedy': 'कॉमेडी फ़िल्में',
  'genre_horror': 'डरावनी फ़िल्में',

  // Auth & Onboarding
  'welcome_back': 'वापसी पर स्वागत है',
  'sign_in_to_continue': 'जारी रखने के लिए साइन इन करें',
  'sign_in': 'साइन इन करें',
  'sign_up': 'साइन अप करें',
  'email': 'ईमेल',
  'password': 'पासवर्ड',
  'forgot_password': 'पासवर्ड भूल गए?',
  'dont_have_account': 'खाता नहीं है?',
  'already_have_account': 'पहले से खाता है?',
  'create_account': 'खाता बनाएं',
  'full_name': 'पूरा नाम',
  'confirm_password': 'पासवर्ड की पुष्टि करें',
  'sign_in_with_google': 'Google से साइन इन करें',
  'or_sign_in_with_email': 'या ईमेल से साइन इन करें',

  // Common Actions
  'search': 'खोजें',
  'filter': 'फ़िल्टर करें',
  'sort': 'क्रमबद्ध करें',
  'apply': 'लागू करें',
  'clear': 'साफ़ करें',
  'share': 'साझा करें',
  'remove': 'हटाएं',

  // Messages
  'something_went_wrong': 'कुछ गलत हो गया',
  'no_internet': 'इंटरनेट कनेक्शन नहीं है',
  'loading_content': 'सामग्री लोड हो रही है...',
  'no_content_found': 'कोई सामग्री नहीं मिली',
  'search_results_for': 'खोज परिणाम',

  // Quality & Download
  'quality': 'गुणवत्ता',
  'sd': 'SD',
  'hd': 'HD',
  'fhd': 'FHD',
  'downloading_in_quality': 'डाउनलोड हो रहा है',
  'already_downloaded': 'पहले से डाउनलोड किया गया',
  'download_in_progress': 'डाउनलोड जारी है',

  // Video Player
  'no_trailer_available': 'कोई ट्रेलर उपलब्ध नहीं',
  'error_loading_video': 'वीडियो लोड करने में त्रुटि',

  // Reviews
  'reviews': 'समीक्षाएं',
  'write_a_review': 'समीक्षा लिखें',
  'no_reviews_yet': 'अभी तक कोई समीक्षा नहीं',

  // Watchlist
  'empty_watchlist': 'आपकी सूची खाली है',
  'add_content_to_watchlist': 'अपनी सूची में सामग्री जोड़ें',

  // Search
  'recent_searches': 'हाल की खोजें',
  'trending_searches': 'लोकप्रिय खोजें',
  'clear_search_history': 'खोज इतिहास साफ़ करें',
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
