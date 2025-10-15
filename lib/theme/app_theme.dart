import 'package:flutter/material.dart';
import 'package:mobile_playground/theme/color_schemes.dart';
import 'package:mobile_playground/theme/text_theme.dart';

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return AppColorSchemes.lightColorScheme;
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return AppColorSchemes.lightMediumContrastScheme;
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return AppColorSchemes.lightHighContrastScheme;
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return AppColorSchemes.darkColorScheme;
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return AppColorSchemes.darkMediumContrastScheme;
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return AppColorSchemes.darkHighContrastScheme;
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        // appBarTheme: _appBarTheme,
        // elevatedButtonTheme: _elevatedButtonTheme,
        // filledButtonTheme: _filledButtonTheme,
        // outlinedButtonTheme: _outlinedButtonTheme,
        // textButtonTheme: _textButtonTheme,
        // inputDecorationTheme: _inputDecorationTheme,
        // cardTheme: _cardTheme,
        // floatingActionButtonTheme: _floatingActionButtonTheme,
        // navigationBarTheme: _navigationBarTheme,
        // navigationRailTheme: _navigationRailTheme,
        // snackBarTheme: _snackBarTheme,
        // dialogTheme: _dialogTheme,
        // bottomSheetTheme: _bottomSheetTheme,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

class AppTheme {
  static ThemeData lightTheme(BuildContext context) {
    final textTheme = AppTextTheme.createTextTheme(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.light();
  }

  static ThemeData darkTheme(BuildContext context) {
    final textTheme = AppTextTheme.createTextTheme(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.dark();
  }

  static ThemeData lightMediumContrastTheme(BuildContext context) {
    final textTheme = AppTextTheme.createTextTheme(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.lightMediumContrast();
  }

  static ThemeData lightHighContrastTheme(BuildContext context) {
    final textTheme = AppTextTheme.createTextTheme(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.lightHighContrast();
  }

  static ThemeData darkMediumContrastTheme(BuildContext context) {
    final textTheme = AppTextTheme.createTextTheme(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.darkMediumContrast();
  }

  static ThemeData darkHighContrastTheme(BuildContext context) {
    final textTheme = AppTextTheme.createTextTheme(context);
    final materialTheme = MaterialTheme(textTheme);
    return materialTheme.darkHighContrast();
  }

//   static AppBarTheme get _appBarTheme {
//     return const AppBarTheme(
//       centerTitle: false,
//       elevation: 0,
//       scrolledUnderElevation: 1,
//     );
//   }

//   static ElevatedButtonThemeData get _elevatedButtonTheme {
//     return ElevatedButtonThemeData(
//       style: ElevatedButton.styleFrom(
//         minimumSize: const Size(64, 48),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }

//   static FilledButtonThemeData get _filledButtonTheme {
//     return FilledButtonThemeData(
//       style: FilledButton.styleFrom(
//         minimumSize: const Size(64, 48),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }

//   static OutlinedButtonThemeData get _outlinedButtonTheme {
//     return OutlinedButtonThemeData(
//       style: OutlinedButton.styleFrom(
//         minimumSize: const Size(64, 48),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }

//   static TextButtonThemeData get _textButtonTheme {
//     return TextButtonThemeData(
//       style: TextButton.styleFrom(
//         minimumSize: const Size(64, 48),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }

//   static InputDecorationTheme get _inputDecorationTheme {
//     return InputDecorationTheme(
//       filled: true,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide.none,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: BorderSide.none,
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(width: 2),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(16),
//         borderSide: const BorderSide(width: 2),
//       ),
//       contentPadding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//     );
//   }

//   static CardThemeData get _cardTheme {
//     return CardThemeData(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//     );
//   }

//   static FloatingActionButtonThemeData get _floatingActionButtonTheme {
//     return FloatingActionButtonThemeData(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//     );
//   }

//   static NavigationBarThemeData get _navigationBarTheme {
//     return NavigationBarThemeData(
//       height: 80,
//       labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
//       indicatorShape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//     );
//   }

//   static NavigationRailThemeData get _navigationRailTheme {
//     return NavigationRailThemeData(
//       indicatorShape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//     );
//   }

//   static SnackBarThemeData get _snackBarTheme {
//     return SnackBarThemeData(
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//   }

//   static DialogThemeData get _dialogTheme {
//     return DialogThemeData(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//     );
//   }

//   static BottomSheetThemeData get _bottomSheetTheme {
//     return const BottomSheetThemeData(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(20),
//         ),
//       ),
//     );
//   }
}
