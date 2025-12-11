part of mdk_app_theme_base;

final Provider<ThemeRegistry> themeRegistryProvider =
    Provider<ThemeRegistry>((Ref ref) {
  final ThemeRegistry registry = ThemeRegistry.instance;
  registry.ensureDefaults();
  return registry;
});

final Provider<ThemePlatformAdapter> themePlatformAdapterProvider =
    Provider<ThemePlatformAdapter>((Ref ref) {
  final ThemeRegistry registry = ref.watch(themeRegistryProvider);
  return registry.adapter;
});

/// AdaptiveTheme와 AppTheme를 활용한 테마 관리 클래스
/// Riverpod 기반 ThemeController
final Provider<ThemeController> themeControllerProvider =
    Provider<ThemeController>((Ref ref) {
  final ThemeRegistry registry = ref.watch(themeRegistryProvider);
  return registry.controller;
});

class ThemeController {
  ThemeController({ThemePlatformAdapter? adapter})
      : _adapter = adapter ?? const AdaptiveThemePlatformAdapter();

  final ThemePlatformAdapter _adapter;

  /// 저장된 ThemeMode를 로드 (host 앱의 main()에서 사용)
  Future<AdaptiveThemeMode?> loadSavedThemeMode() {
    return _adapter.loadSavedThemeMode();
  }

  /// 현재 적용 중인 ThemeMode (system도 내부 상태에 따라 light/dark로 해석)
  AdaptiveThemeMode effectiveMode(BuildContext context) {
    final AdaptiveThemeMode mode = _adapter.currentMode(context);
    if (mode == AdaptiveThemeMode.system) {
      final Brightness brightness = Theme.of(context).brightness;
      return brightness == Brightness.dark
          ? AdaptiveThemeMode.dark
          : AdaptiveThemeMode.light;
    }
    return mode;
  }

  bool isDarkMode(BuildContext context) {
    return effectiveMode(context) == AdaptiveThemeMode.dark;
  }

  /// light ↔ dark 토글 (system은 처음 토글 시 dark로 보냄)
  Future<void> toggle(BuildContext context) async {
    final AdaptiveThemeMode mode = _adapter.currentMode(context);

    switch (mode) {
      case AdaptiveThemeMode.light:
        _adapter.setDark(context);
        break;
      case AdaptiveThemeMode.dark:
        _adapter.setLight(context);
        break;
      case AdaptiveThemeMode.system:
        // 정책: system → 처음 토글 시 다크로
        _adapter.setDark(context);
        break;
    }
  }

  /// (확장용) 브랜드를 바꾸고 싶을 때 ThemeData 전체를 교체하는 메서드
  Future<void> setBrand(
    BuildContext context, {
    required ThemeBrand brand,
    bool? isWebOverride,
  }) async {
    final bool? isWeb = isWebOverride;
    final AdaptiveThemeMode mode = _adapter.currentMode(context);
    final ThemeData lightTheme = AppTheme.light(
      brand: brand,
      isWebOverride: isWeb,
    );
    final ThemeData darkTheme = AppTheme.dark(
      brand: brand,
      isWebOverride: isWeb,
    );
    _adapter.setTheme(
      context: context,
      lightTheme: lightTheme,
      darkTheme: darkTheme,
    );
    switch (mode) {
      case AdaptiveThemeMode.light:
        _adapter.setLight(context);
        break;
      case AdaptiveThemeMode.dark:
        _adapter.setDark(context);
        break;
      case AdaptiveThemeMode.system:
        _adapter.setSystem(context);
        break;
    }
  }
}
