# Theme Implementation Documentation

This document explains how theming is implemented in the Mobile Playground project. The theme system is built on Flutter's Material Design 3 (Material You) and uses Riverpod for state management.

## Overview

The theme implementation is organized into several files, each with a specific responsibility:

```
lib/theme/
├── app_theme.dart          # Main theme configuration and builder
├── color_schemes.dart      # Color palettes for all theme variants
├── text_theme.dart         # Typography configuration
├── theme_controller.dart   # State management for theme switching
├── util.dart              # Utility functions for text theme creation
└── docs/
    └── theme_implementation.md
```

## File Descriptions

### 1. `app_theme.dart`

**Purpose:** Central theme configuration and theme data builder for the application.

**Key Components:**

- **`MaterialTheme` class**: Core theme builder that creates `ThemeData` objects
  - Takes a `TextTheme` as input for typography
  - Provides static methods to access different color schemes (light, dark, and contrast variants)
  - Contains a `theme()` method that builds complete `ThemeData` with all component customizations
  - Supports Material 3 (useMaterial3: true)

- **`ExtendedColor` class**: Structure for defining custom colors beyond Material Design's standard palette
  - Supports light, dark, and contrast variants
  - Can be extended for brand-specific colors

- **`ColorFamily` class**: Groups related colors together
  - color: Primary color
  - onColor: Contrasting color for text on the primary color
  - colorContainer: Lighter variant for containers
  - onColorContainer: Text color for container backgrounds

- **`AppTheme` class**: Static factory methods for creating theme variants
  - `lightTheme()`: Standard light theme
  - `darkTheme()`: Standard dark theme
  - `lightMediumContrastTheme()`: Enhanced contrast for light mode
  - `lightHighContrastTheme()`: Maximum contrast for accessibility (light)
  - `darkMediumContrastTheme()`: Enhanced contrast for dark mode
  - `darkHighContrastTheme()`: Maximum contrast for accessibility (dark)

**Location in code:** `lib/theme/app_theme.dart`

**Usage Example:**
```dart
MaterialApp(
  theme: AppTheme.lightTheme(context),
  darkTheme: AppTheme.darkTheme(context),
  themeMode: themeMode,
);
```

---

### 2. `color_schemes.dart`

**Purpose:** Defines all color palettes used throughout the application.

**Key Components:**

- **Color Schemes**: Six complete Material 3 color schemes
  - `lightColorScheme`: Standard light mode colors
  - `lightMediumContrastScheme`: Improved readability for light mode
  - `lightHighContrastScheme`: Accessibility-focused high contrast (light)
  - `darkColorScheme`: Standard dark mode colors
  - `darkMediumContrastScheme`: Improved readability for dark mode
  - `darkHighContrastScheme`: Accessibility-focused high contrast (dark)

- **Primary Brand Colors**: Custom color constants
  - `primaryColor`: Purple (#66558F)
  - `secondaryColor`: Gray-purple (#625B70)
  - `tertiaryColor`: Rose (#7E525F)
  - `successColor`: Green (#198754)
  - `warningColor`: Amber (#FFC107)
  - `infoColor`: Cyan (#0DCAF0)

- **Surface Container Colors**: Different elevation levels
  - Light theme: From white (#FFFFFF) to light gray (#E6E0E9)
  - Dark theme: From near-black (#0F0D13) to dark gray (#36343A)

Each color scheme includes comprehensive color definitions:
- Primary, secondary, and tertiary color families
- Surface colors with various elevations
- Error states
- Outline colors
- Fixed colors for consistent appearance
- Inverse colors for contrast

**Location in code:** `lib/theme/color_schemes.dart:4-319`

---

### 3. `text_theme.dart`

**Purpose:** Manages typography throughout the application using Google Fonts.

**Key Components:**

- **Font Families**:
  - `bodyFontFamily`: 'Inter' - Used for body text and labels
  - `displayFontFamily`: 'Fredoka' - Used for headlines and titles

- **`createTextTheme()` method**: Dynamic text theme creation
  - Fetches fonts from Google Fonts at runtime
  - Applies 'Fredoka' for display/headline/title styles
  - Applies 'Inter' for body text and labels
  - Inherits base text theme from current context

- **`fallbackTextTheme`**: Static fallback text theme
  - Predefined Material 3 typography scale
  - All text styles from `displayLarge` to `bodySmall`
  - Includes proper font sizes, weights, letter spacing, and line heights
  - Used as backup if Google Fonts fail to load

**Text Style Hierarchy:**
- Display: 57px, 45px, 36px (Fredoka)
- Headline: 32px, 28px, 24px (Fredoka)
- Title: 22px, 16px, 14px (Fredoka)
- Body: 16px, 14px, 12px (Inter)
- Label: 14px, 12px, 11px (Inter)

**Location in code:** `lib/theme/text_theme.dart:4-132`

---

### 4. `theme_controller.dart`

**Purpose:** Manages theme state and provides theme switching functionality using Riverpod.

**Key Components:**

- **`ThemeController` class**: State notifier for theme management
  - Extends `StateNotifier<ThemeMode>`
  - Initial state: `ThemeMode.system` (follows system preference)
  - Loads saved theme preference on initialization

- **Methods**:
  - `_loadTheme()`: Loads theme preference (currently hardcoded to 'dark')
  - `setThemeMode(ThemeMode)`: Updates the current theme mode
  - `toggleTheme()`: Cycles between light and dark themes
  - `_stringToThemeMode()`: Converts string to ThemeMode enum

- **`themeControllerProvider`**: Riverpod provider
  - Type: `StateNotifierProvider<ThemeController, ThemeMode>`
  - Makes theme state accessible throughout the widget tree
  - Enables reactive UI updates when theme changes

**Location in code:** `lib/theme/theme_controller.dart:4-49`

**Usage Example:**
```dart
// Read current theme mode
final themeMode = ref.watch(themeControllerProvider);

// Toggle theme
ref.read(themeControllerProvider.notifier).toggleTheme();

// Set specific theme
ref.read(themeControllerProvider.notifier).setThemeMode(ThemeMode.dark);
```

---

### 5. `util.dart`

**Purpose:** Utility function for creating custom text themes with Google Fonts.

**Key Components:**

- **`createTextTheme()` function**: Generic text theme builder
  - Parameters:
    - `context`: Build context for accessing base theme
    - `bodyFontString`: Font name for body text (e.g., 'Inter')
    - `displayFontString`: Font name for display text (e.g., 'Fredoka')
  - Returns a `TextTheme` with fonts applied appropriately
  - Separates body text styles from display styles
  - Uses Google Fonts package for font retrieval

This utility is a lower-level function that `AppTextTheme.createTextTheme()` uses internally.

**Location in code:** `lib/theme/util.dart:4-19`

---

## How It All Works Together

1. **Initialization:**
   - `ThemeController` initializes with system theme preference
   - Loads saved theme preference (currently defaults to dark)

2. **Theme Creation:**
   - `AppTheme.lightTheme()` or `AppTheme.darkTheme()` is called
   - Creates text theme using Google Fonts (Inter + Fredoka)
   - Builds `MaterialTheme` with the text theme
   - Applies appropriate color scheme from `AppColorSchemes`

3. **Material App Integration:**
   ```dart
   MaterialApp(
     theme: AppTheme.lightTheme(context),
     darkTheme: AppTheme.darkTheme(context),
     themeMode: ref.watch(themeControllerProvider),
   );
   ```

4. **Theme Switching:**
   - User triggers theme toggle
   - `ThemeController.toggleTheme()` updates state
   - Riverpod notifies all listeners
   - Material app rebuilds with new theme

5. **Component Usage:**
   - Widgets automatically use theme colors via `Theme.of(context)`
   - Text styles are applied through `TextStyle` inheritance
   - Colors adapt based on current brightness (light/dark)

## Key Features

- **Material 3 Support**: Full Material You design system implementation
- **Accessibility**: Multiple contrast levels for improved readability
- **Google Fonts**: Custom typography with Inter and Fredoka
- **State Management**: Riverpod for reactive theme switching
- **Color Variants**: 6 complete color schemes (3 light + 3 dark)
- **Type Safety**: Strongly typed with Flutter's theme system
- **Extensibility**: Easy to add custom colors via `ExtendedColor`

## Future Enhancements

The codebase contains commented-out theme configurations for:
- App bar styling
- Button themes (elevated, filled, outlined, text)
- Input decoration
- Cards
- Floating action buttons
- Navigation bars and rails
- Snack bars
- Dialogs
- Bottom sheets

These can be uncommented and customized as needed.

## References

- [Material 3 Design System](https://m3.material.io/)
- [Flutter Theming Guide](https://docs.flutter.dev/cookbook/design/themes)
- [Google Fonts Package](https://pub.dev/packages/google_fonts)
- [Riverpod Documentation](https://riverpod.dev/)
