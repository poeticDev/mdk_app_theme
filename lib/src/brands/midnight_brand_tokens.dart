part of mdk_app_theme_base;

const ThemeBrandTokens midnightBrandTokens = ThemeBrandTokens(
  lightScheme: ColorScheme.light(
    primary: Color(0xFF005695), // Deep Ocean Blue
    primaryContainer: Color(0xFF003F6E),
    secondary: Color(0xFF006874), // Teal Accents
    surface: Color(0xFFF9FAFB),
    onSurface: Color(0xFF191C1E), // textPrimary
    onSurfaceVariant: Color(0xFF41484D), // textSecondary
    error: Color(0xFFBA1A1A),
  ),
  darkScheme: ColorScheme.dark(
    primary: Color(0xFFA0C9FF), // Soft Blue (Tone 80)
    primaryContainer: Color(0xFF004A77),
    secondary: Color(0xFF4FD8EB), // Cyan/Teal (Tone 80)
    surface: Color(0xFF0F121A), // Deep Navy (Tone 6)
    onSurface: Color(0xFFE2E2E6), // textPrimary
    onSurfaceVariant: Color(0xFFC2C7CE), // textSecondary
    error: Color(0xFFFFB4AB), // Soft Red
  ),
  lightExtension: AppColors(
    success: Color(0xFF006C4C),
    warning: Color(0xFF9E6200),
    surfaceElevated: Color(0xFFFFFFFF),
  ),
  darkExtension: AppColors(
    success: Color(0xFF33B780),
    warning: Color(0xFFFFB77C),
    surfaceElevated: Color(0xFF1E222D),
  ),
);
