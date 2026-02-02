part of mdk_app_theme_base;

const ThemeBrandTokens orangeDayBrandTokens = ThemeBrandTokens(
  lightScheme: ColorScheme.light(
    primary: Color(0xFFAC3400), // Terracotta / Deep Orange
    primaryContainer: Color(0xFF862200),
    secondary: Color(0xFF006A60), // Teal/Forest Green
    surface: Color(0xFFFFF8F1), // Warm Paper/Cream
    onSurface: Color(0xFF231A14), // textPrimary
    onSurfaceVariant: Color(0xFF53433C), // textSecondary
    error: Color(0xFFBA1A1A),
  ),
  darkScheme: ColorScheme.dark(
    primary: Color(0xFFFFB596), // Soft Orange (Tone 80)
    primaryContainer: Color(0xFFAC3400),
    secondary: Color(0xFF53DBC9), // Soft Teal
    surface: Color(0xFF19120C), // Warm Dark Grey
    onSurface: Color(0xFFEDE0DB), // textPrimary
    onSurfaceVariant: Color(0xFFD0C4BF), // textSecondary
    error: Color(0xFFFFB4AB),
  ),
  lightExtension: AppColors(
    success: Color(0xFF2E6C00),
    warning: Color(0xFF904D00),
    surfaceElevated: Color(0xFFFFFFFF),
  ),
  darkExtension: AppColors(
    success: Color(0xFF91D56D),
    warning: Color(0xFFFFB776),
    surfaceElevated: Color(0xFF261D16),
  ),
);
