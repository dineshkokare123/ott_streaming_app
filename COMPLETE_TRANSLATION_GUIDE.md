# Complete Translation Guide for StreamVibe App

## Current Status
The app has partial translations. Many strings are still hardcoded in English throughout the app.

## Languages Supported
- 🇺🇸 English (en) - Complete
- 🇪🇸 Spanish (es) - Partial
- 🇫🇷 French (fr) - Partial  
- 🇩🇪 German (de) - Partial
- 🇮🇳 Hindi (hi) - Partial
- 🇯🇵 Japanese (ja) - Minimal
- 🇨🇳 Chinese (zh) - Minimal
- 🇸🇦 Arabic (ar) - Minimal

## Translation Keys Added (English Base)

### Auth & Onboarding
```dart
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
```

### Common Actions
```dart
'search': 'Search',
'filter': 'Filter',
'sort': 'Sort',
'apply': 'Apply',
'clear': 'Clear',
'share': 'Share',
'remove': 'Remove',
```

### Messages
```dart
'something_went_wrong': 'Something went wrong',
'no_internet': 'No internet connection',
'loading_content': 'Loading content...',
'no_content_found': 'No content found',
'search_results_for': 'Search results for',
```

### Quality & Download
```dart
'quality': 'Quality',
'sd': 'SD',
'hd': 'HD',
'fhd': 'FHD',
'downloading_in_quality': 'Downloading in',
'already_downloaded': 'Already downloaded',
'download_in_progress': 'Download in progress',
```

### Video Player
```dart
'no_trailer_available': 'No trailer available',
'error_loading_video': 'Error loading video',
```

### Reviews
```dart
'reviews': 'Reviews',
'write_a_review': 'Write a Review',
'no_reviews_yet': 'No reviews yet',
```

### Watchlist
```dart
'empty_watchlist': 'Your watchlist is empty',
'add_content_to_watchlist': 'Add content to your watchlist',
```

### Search
```dart
'recent_searches': 'Recent Searches',
'trending_searches': 'Trending Searches',
'clear_search_history': 'Clear search history',
```

## How to Add Translations

### Step 1: Add to Spanish (_spanishTranslations)
```dart
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
```

### Step 2: Add to French (_frenchTranslations)
```dart
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
```

### Step 3: Add to German (_germanTranslations)
```dart
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
```

### Step 4: Add to Hindi (_hindiTranslations)
```dart
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
```

## Screens That Need Translation Updates

### 1. LoginScreen (`lib/screens/login_screen.dart`)
Replace hardcoded strings:
- "Welcome Back" → `'welcome_back'.tr(localization)`
- "Sign in to continue" → `'sign_in_to_continue'.tr(localization)`
- "Sign In" → `'sign_in'.tr(localization)`
- "Email" → `'email'.tr(localization)`
- "Password" → `'password'.tr(localization)`
- "Forgot Password?" → `'forgot_password'.tr(localization)`
- "Don't have an account?" → `'dont_have_account'.tr(localization)`
- "Sign Up" → `'sign_up'.tr(localization)`

### 2. SignUpScreen (`lib/screens/signup_screen.dart`)
Replace hardcoded strings:
- "Create Account" → `'create_account'.tr(localization)`
- "Full Name" → `'full_name'.tr(localization)`
- "Email" → `'email'.tr(localization)`
- "Password" → `'password'.tr(localization)`
- "Confirm Password" → `'confirm_password'.tr(localization)`
- "Already have an account?" → `'already_have_account'.tr(localization)`

### 3. SearchScreen (`lib/screens/search_screen.dart`)
Replace hardcoded strings:
- "Search" → `'search'.tr(localization)`
- "Recent Searches" → `'recent_searches'.tr(localization)`
- "Trending Searches" → `'trending_searches'.tr(localization)`
- "No results found" → `'no_results'.tr(localization)`

### 4. ContentDetailScreen (`lib/screens/content_detail_screen.dart`)
Replace hardcoded strings:
- "No trailer available" → `'no_trailer_available'.tr(localization)`
- "Error loading video" → `'error_loading_video'.tr(localization)`
- "Select Quality" → `'select_quality'.tr(localization)`
- "Already downloaded" → `'already_downloaded'.tr(localization)`
- "Download in progress" → `'download_in_progress'.tr(localization)`

### 5. WatchlistScreen (`lib/screens/watchlist_screen.dart`)
Replace hardcoded strings:
- "Your watchlist is empty" → `'empty_watchlist'.tr(localization)`
- "Add content to your watchlist" → `'add_content_to_watchlist'.tr(localization)`

### 6. ReviewsScreen (`lib/screens/reviews_screen.dart`)
Replace hardcoded strings:
- "Reviews" → `'reviews'.tr(localization)`
- "Write a Review" → `'write_a_review'.tr(localization)`
- "No reviews yet" → `'no_reviews_yet'.tr(localization)`

## Implementation Steps

1. **Add all translations to `localization_service.dart`** for each language
2. **Update each screen** to use `.tr(localization)` instead of hardcoded strings
3. **Add `LocalizationService` provider** to screens that don't have it yet
4. **Test each language** to ensure all strings translate correctly

## Testing Checklist

For each language (Spanish, French, German, Hindi):
- [ ] Login screen - all text translates
- [ ] Sign up screen - all text translates
- [ ] Home screen - all sections translate
- [ ] Search screen - all text translates
- [ ] Content detail - all buttons/labels translate
- [ ] Profile screen - all menu items translate
- [ ] Watchlist - all text translates
- [ ] Downloads - all text translates

## Priority Order

1. **High Priority** (User-facing, frequently used):
   - Login/SignUp screens
   - Home screen sections
   - Profile menu
   - Search screen

2. **Medium Priority**:
   - Content detail screen
   - Watchlist
   - Downloads

3. **Low Priority**:
   - Settings screens
   - Less frequently used features

## Notes

- Always use `.tr(localization)` for user-facing strings
- Never hardcode user-visible text
- Keep translation keys descriptive and consistent
- Test with actual users who speak the target language when possible
