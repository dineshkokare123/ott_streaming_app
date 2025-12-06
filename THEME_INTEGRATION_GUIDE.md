# Theme Integration Guide

## Overview
This guide explains how to make theme changes (from the "New Features" screen) reflect throughout the entire app.

## What We've Already Done

### 1. **Main App Configuration** (`lib/main.dart`)
- ✅ MaterialApp now listens to both `ThemeService` and `LocalizationService`
- ✅ Uses `Consumer2<ThemeService, LocalizationService>` to rebuild when either changes
- ✅ Sets `theme: themeService.getTheme()` to apply the selected theme
- ✅ Sets `locale: localizationService.currentLocale` for language changes

### 2. **Updated Widgets to Use Theme**
We've updated the following to use `Theme.of(context)` instead of hardcoded `AppColors`:

#### **ContentRow Widget** (`lib/widgets/content_row.dart`)
- ✅ Title text now uses `Theme.of(context).textTheme.titleLarge`
- ✅ Removed unused `AppColors` import

#### **HomeScreen** (`lib/screens/home_screen.dart`)
- ✅ Scaffold background uses `Theme.of(context).scaffoldBackgroundColor`
- ✅ AppBar background uses `Theme.of(context).scaffoldBackgroundColor`
- ✅ Text colors use theme text styles

#### **ProfileScreen** (`lib/screens/profile_screen.dart`)
- ✅ Scaffold and AppBar backgrounds use theme colors
- ✅ Gradient uses `Theme.of(context).primaryColor`
- ✅ All text widgets use theme text colors
- ✅ Fixed `_buildMenuItem` to accept `BuildContext` for theme access

## How to Apply This Pattern to Other Screens

### Step 1: Replace Hardcoded Colors

**Before:**
```dart
Container(
  color: AppColors.background,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textPrimary),
  ),
)
```

**After:**
```dart
Container(
  color: Theme.of(context).scaffoldBackgroundColor,
  child: Text(
    'Hello',
    style: TextStyle(
      color: Theme.of(context).textTheme.bodyLarge?.color,
    ),
  ),
)
```

### Step 2: Use Theme Properties

| Old (AppColors) | New (Theme) |
|----------------|-------------|
| `AppColors.background` | `Theme.of(context).scaffoldBackgroundColor` |
| `AppColors.backgroundLight` | `Theme.of(context).colorScheme.surface` |
| `AppColors.textPrimary` | `Theme.of(context).textTheme.bodyLarge?.color` |
| `AppColors.textSecondary` | `Theme.of(context).textTheme.bodyMedium?.color` |
| `AppColors.primary` | `Theme.of(context).primaryColor` |
| `AppColors.error` | `Theme.of(context).colorScheme.error` |

### Step 3: Remove `const` When Using Theme

**Wrong:**
```dart
const Text(
  'Hello',
  style: TextStyle(
    color: Theme.of(context).textTheme.bodyLarge?.color, // ERROR!
  ),
)
```

**Correct:**
```dart
Text(
  'Hello',
  style: TextStyle(
    color: Theme.of(context).textTheme.bodyLarge?.color, // ✓
  ),
)
```

### Step 4: Update Custom Widgets

If you have custom widgets that need theme access:

```dart
class MyCustomWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    // Access theme here
    final theme = Theme.of(context);
    
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Text(
        'Themed Text',
        style: theme.textTheme.bodyLarge,
      ),
    );
  }
}
```

## Screens That Still Need Updates

The following screens likely still use hardcoded `AppColors` and should be updated:

1. **SearchScreen** - Update to use theme colors
2. **ContentDetailScreen** - Partially updated, needs full review
3. **WatchlistScreen** - Needs theme integration
4. **LoginScreen** - Uses AppColors extensively
5. **SignUpScreen** - Uses AppColors extensively
6. **DownloadsScreen** - Needs theme integration
7. **All other screens in `/lib/screens/`**

## Testing Theme Changes

1. Run the app
2. Navigate to Profile → New Features 🚀
3. Under "🎨 Appearance", select different themes:
   - Netflix Red (Dark)
   - Light Mode
   - Ocean Blue
   - Midnight Purple
4. Navigate through different screens to verify colors update

## Common Patterns

### Buttons
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).primaryColor,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
  ),
  child: Text('Button'),
)
```

### Cards
```dart
Card(
  color: Theme.of(context).colorScheme.surface,
  child: ListTile(
    title: Text(
      'Title',
      style: Theme.of(context).textTheme.titleMedium,
    ),
  ),
)
```

### AppBar
```dart
AppBar(
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
  title: Text('Title'),
)
```

## Benefits

✅ **Dynamic Theming**: Users can switch themes and see changes immediately
✅ **Consistency**: All screens follow the same color scheme
✅ **Maintainability**: Change themes in one place (`ThemeService`)
✅ **Accessibility**: Support for light/dark modes and high contrast themes
✅ **User Preference**: Users can choose their preferred visual style

## Next Steps

1. **Systematically update remaining screens** - Go through each screen file and replace `AppColors` with `Theme.of(context)`
2. **Test thoroughly** - Verify all themes work correctly on all screens
3. **Add more themes** - Consider adding more theme options in `ThemeService`
4. **Persist user choice** - Save selected theme to SharedPreferences so it persists across app restarts
