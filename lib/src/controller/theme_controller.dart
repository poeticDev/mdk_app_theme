part of mdk_app_theme_base;

/// AdaptiveTheme와 AppTheme를 활용한 테마 관리 클래스
class ThemeController {
  ThemeController({
    ThemePlatformAdapter? adapter,
    ThemeBrand initialBrand = ThemeBrand.defaultBrand,
  })  : _adapter = adapter ?? const AdaptiveThemePlatformAdapter(),
        _currentBrand = initialBrand;

  /// 플랫폼별 테마 적용/조회 어댑터
  final ThemePlatformAdapter _adapter;

  /// 현재 사용 중인 브랜드 (setBrand 호출 시 갱신)
  ThemeBrand _currentBrand;

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

  /// 현재 모드 기준 다크 여부
  bool isDarkMode(BuildContext context) {
    return effectiveMode(context) == AdaptiveThemeMode.dark;
  }

  /// 모드/브랜드 기준 AppColors 조회 (미지정 시 현재 값 사용)
  AppColors getAppColors(
    BuildContext context, {
    AdaptiveThemeMode? mode,
    ThemeBrand? brand,
  }) {
    final AdaptiveThemeMode resolvedMode = _resolveMode(context, mode);
    final ThemeBrand resolvedBrand = brand ?? _currentBrand;
    final ThemeBrandTokens tokens = themeBrandRegistry.tokensOf(resolvedBrand);
    if (resolvedMode == AdaptiveThemeMode.dark) {
      return tokens.darkExtension;
    }
    return tokens.lightExtension;
  }

  /// 등록된 브랜드 목록 조회
  List<ThemeBrand> getBrandList() => themeBrandRegistry.getBrandList();

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
    _currentBrand = brand;
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

  /// 모드가 null/system일 경우 현재 환경에 맞게 해석
  AdaptiveThemeMode _resolveMode(
    BuildContext context,
    AdaptiveThemeMode? mode,
  ) {
    if (mode == null) {
      return effectiveMode(context);
    }
    if (mode == AdaptiveThemeMode.system) {
      final Brightness brightness = Theme.of(context).brightness;
      return brightness == Brightness.dark
          ? AdaptiveThemeMode.dark
          : AdaptiveThemeMode.light;
    }
    return mode;
  }
}
