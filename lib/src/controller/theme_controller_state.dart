part of mdk_app_theme_base;

class ThemeControllerState {
  const ThemeControllerState({
    required this.mode,
    required this.brand,
  });

  final AdaptiveThemeMode mode;
  final ThemeBrand brand;

  bool get isDark => mode == AdaptiveThemeMode.dark;

  ThemeControllerState copyWith({
    AdaptiveThemeMode? mode,
    ThemeBrand? brand,
  }) {
    return ThemeControllerState(
      mode: mode ?? this.mode,
      brand: brand ?? this.brand,
    );
  }
}

const ThemeControllerState initialThemeControllerState = ThemeControllerState(
  mode: AdaptiveThemeMode.light,
  brand: ThemeBrand.defaultBrand,
);
