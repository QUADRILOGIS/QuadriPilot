import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  /// —————————————————————————————————————————————————————————
  /// LIGHT SCHEMES
  /// —————————————————————————————————————————————————————————
  ///
  /// Base light scheme
  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      // Primary — Green
      primary: Color(0xFF3DB547), // #3db547
      surfaceTint: Color(0xFF3DB547),
      onPrimary: Color(0xFFFFFFFF), // White text on green
      // Container variants for primary
      primaryContainer: Color(0xFFC4F0DF), // Lighter green container
      onPrimaryContainer: Color(0xFF141414),

      // Secondary — Green
      secondary: Color(0xFF3DB547), // #3db547
      onSecondary: Color(0xFF141414), // Black text on green
      secondaryContainer: Color(0xFF90EACE), // Lighter container
      onSecondaryContainer: Color(0xFF141414),

      // Tertiary — Dark Green accent
      tertiary: Color(0xFF203737), // #203737
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF96B1B0), // Lightened container
      onTertiaryContainer: Color(0xFF141414),

      // Error — standard Material red tones (customize as needed)
      error: Color(0xFFB3261E),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFF9DEDC),
      onErrorContainer: Color(0xFF141414),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF141414),

      // Additional “onSurface” variants, outlines, shadows
      onSurfaceVariant: Color(0xFF757575),
      outline: Color(0xFFA1A1A1),
      outlineVariant: Color(0xFFCACACA),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),

      // Inverse colors (used in FAB, etc.)
      inverseSurface: Color(0xFF141414),
      inversePrimary: Color(0xFFC4F0DF),

      // “Fixed” colors (M3 advanced roles)
      primaryFixed: Color(0xFFC4F0DF),
      onPrimaryFixed: Color(0xFF141414),
      primaryFixedDim: Color(0xFFA7EBD9),
      onPrimaryFixedVariant: Color(0xFF141414),
      secondaryFixed: Color(0xFFC4F0DF),
      onSecondaryFixed: Color(0xFF141414),
      secondaryFixedDim: Color(0xFFA7EBD9),
      onSecondaryFixedVariant: Color(0xFF141414),
      tertiaryFixed: Color(0xFF96B1B0),
      onTertiaryFixed: Color(0xFF141414),
      tertiaryFixedDim: Color(0xFF8FA4A4),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),

      // Surface container variants
      surfaceDim: Color(0xFFF5F5F5),
      surfaceBright: Color(0xFFFFFFFF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF5F5F5),
      surfaceContainer: Color(0xFFF0F0F0),
      surfaceContainerHigh: Color(0xFFF1F1F1),
      surfaceContainerHighest: Color(0xFFECECEC),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  /// Medium-contrast light scheme (can be the same or tweaked slightly)
  static ColorScheme lightMediumContrastScheme() => lightScheme();

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  /// High-contrast light scheme (can be the same or further tweaked)
  static ColorScheme lightHighContrastScheme() => lightScheme();

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  /// —————————————————————————————————————————————————————————
  /// DARK SCHEMES
  /// —————————————————————————————————————————————————————————
  ///
  /// Base dark scheme
  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      // Primary — Orange
      primary: Color(0xFF3DB547),
      surfaceTint: Color(0xFF3DB547),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFF2D7462), // Darker/lighter tone for container
      onPrimaryContainer: Color(0xFFFFFFFF),

      // Secondary — Green
      secondary: Color(0xFF3DB547),
      onSecondary: Color(0xFFFFFFFF), // White text on green in dark mode
      secondaryContainer: Color(0xFF2D7462),
      onSecondaryContainer: Color(0xFFFFFFFF),

      // Tertiary — Dark Green accent
      tertiary: Color(0xFF203737),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFF486668),
      onTertiaryContainer: Color(0xFFFFFFFF),

      // Error
      error: Color(0xFFCF6679),
      onError: Color(0xFF000000),
      errorContainer: Color(0xFF8D2B39),
      onErrorContainer: Color(0xFFFFFFFF),
      surface: Color(0xFF141414),
      onSurface: Color(0xFFFFFFFF),

      // Additional variants
      onSurfaceVariant: Color(0xFF757575),
      outline: Color(0xFFA1A1A1),
      outlineVariant: Color(0xFFCACACA),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),

      inverseSurface: Color(0xFFFFFFFF),
      inversePrimary: Color(0xFF3DB547),

      // “Fixed” roles
      primaryFixed: Color(0xFF2D7462),
      onPrimaryFixed: Color(0xFFFFFFFF),
      primaryFixedDim: Color(0xFF3DB547),
      onPrimaryFixedVariant: Color(0xFFFFFFFF),
      secondaryFixed: Color(0xFF2D7462),
      onSecondaryFixed: Color(0xFFFFFFFF),
      secondaryFixedDim: Color(0xFF3DB547),
      onSecondaryFixedVariant: Color(0xFFFFFFFF),
      tertiaryFixed: Color(0xFF486668),
      onTertiaryFixed: Color(0xFFFFFFFF),
      tertiaryFixedDim: Color(0xFF203737),
      onTertiaryFixedVariant: Color(0xFFFFFFFF),

      surfaceDim: Color(0xFF1E1E1E),
      surfaceBright: Color(0xFF1E1E1E),
      surfaceContainerLowest: Color(0xFF121212),
      surfaceContainerLow: Color(0xFF141414),
      surfaceContainer: Color(0xFF1E1E1E),
      surfaceContainerHigh: Color(0xFF2A2A2A),
      surfaceContainerHighest: Color(0xFF3C3C3C),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  /// Medium-contrast dark scheme
  static ColorScheme darkMediumContrastScheme() => darkScheme();

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  /// High-contrast dark scheme
  static ColorScheme darkHighContrastScheme() => darkScheme();

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  /// —————————————————————————————————————————————————————————
  /// COMMON THEME SETUP
  /// —————————————————————————————————————————————————————————
  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

/// Extended color definition remains unchanged unless you want
/// to provide brand-specific expansions.
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
