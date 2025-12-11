part of mdk_app_theme_base;

abstract class ThemePlatformAdapter {
  const ThemePlatformAdapter();

  Future<AdaptiveThemeMode?> loadSavedThemeMode();
  AdaptiveThemeMode currentMode(BuildContext context);
  void setTheme({
    required BuildContext context,
    required ThemeData lightTheme,
    required ThemeData darkTheme,
  });
  void setLight(BuildContext context);
  void setDark(BuildContext context);
  void setSystem(BuildContext context);
}

class AdaptiveThemePlatformAdapter extends ThemePlatformAdapter {
  const AdaptiveThemePlatformAdapter();

  @override
  Future<AdaptiveThemeMode?> loadSavedThemeMode() {
    return AdaptiveTheme.getThemeMode();
  }

  @override
  AdaptiveThemeMode currentMode(BuildContext context) {
    return _manager(context).mode;
  }

  @override
  void setTheme({
    required BuildContext context,
    required ThemeData lightTheme,
    required ThemeData darkTheme,
  }) {
    _manager(context).setTheme(light: lightTheme, dark: darkTheme);
  }

  @override
  void setLight(BuildContext context) {
    _manager(context).setLight();
  }

  @override
  void setDark(BuildContext context) {
    _manager(context).setDark();
  }

  @override
  void setSystem(BuildContext context) {
    _manager(context).setSystem();
  }

  AdaptiveThemeManager<ThemeData> _manager(BuildContext context) {
    return AdaptiveTheme.of(context);
  }
}
