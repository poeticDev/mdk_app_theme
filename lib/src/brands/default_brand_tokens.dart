part of mdk_app_theme_base;

const ThemeBrandTokens defaultBrandTokens = ThemeBrandTokens(
  lightScheme: ColorScheme.light(
    primary: Color(0xFF626AE8),
    primaryContainer: Color(0xff334479), // Legacy primaryVariant
    secondary: Color(0xFF626AE8),
    surface: Color(0xFFEFEFEF),
    onSurface: Color(0xFF2C2C2C), // textPrimary
    onSurfaceVariant: Color(0xFF485157), // textSecondary
    error: Color(0xFFE26D72),
    // Defaulting onPrimary, onSecondary to white/black via .light()
  ),
  darkScheme: ColorScheme.dark(
    primary: Color(0xFF626AE8),
    primaryContainer: Color(0xff334479),
    secondary: Color(0xFF626AE8),
    surface: Color(0xFF1B2028),
    onSurface: Color(0xFFE8EAED), // textPrimary
    onSurfaceVariant: Color(0xFFB0B8C2), // textSecondary
    error: Color(0xFFE08A66),
  ),
  lightExtension: AppColors(
    success: Color(0xFF70B38C),
    warning: Color(0xFFFFC785),
    surfaceElevated: Color(0xFFFAFAFA),
  ),
  darkExtension: AppColors(
    success: Color(0xFF4FA083),
    warning: Color(0xFFFFC785),
    surfaceElevated: Color(0xFF242A34),
  ),
);
