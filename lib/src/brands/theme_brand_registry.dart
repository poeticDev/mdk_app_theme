part of mdk_app_theme_base;

class ThemeBrandTokens {
  const ThemeBrandTokens({
    required this.lightScheme,
    required this.darkScheme,
    required this.lightExtension,
    required this.darkExtension,
  });

  final ColorScheme lightScheme;
  final ColorScheme darkScheme;
  final AppColors lightExtension;
  final AppColors darkExtension;
}

class ThemeBrandRegistry {
  const ThemeBrandRegistry(this._tokens);

  final Map<ThemeBrand, ThemeBrandTokens> _tokens;

  ThemeBrandTokens tokensOf(ThemeBrand brand) {
    final ThemeBrandTokens? tokens = _tokens[brand];
    if (tokens == null) {
      throw ArgumentError('ThemeBrand $brand is not registered.');
    }
    return tokens;
  }

  // 기존 lightColors, darkColors 헬퍼는 더 이상 단순 AppColors 반환이 아니므로 제거하거나
  // 필요하다면 ColorScheme/Extension을 반환하도록 변경해야 하지만,
  // AppTheme에서 직접 tokensOf를 사용하는 것이 명확하므로 제거합니다.

  List<ThemeBrand> getBrandList() {
    return List<ThemeBrand>.unmodifiable(_tokens.keys);
  }
}

const ThemeBrandRegistry themeBrandRegistry = ThemeBrandRegistry(_brandTokens);

const Map<ThemeBrand, ThemeBrandTokens> _brandTokens =
    <ThemeBrand, ThemeBrandTokens>{
  ThemeBrand.defaultBrand: defaultBrandTokens,
  ThemeBrand.midnight: midnightBrandTokens,
  ThemeBrand.orangeDay: orangeDayBrandTokens,
};

extension ThemeBrandLabel on ThemeBrand {
  String get label {
    switch (this) {
      case ThemeBrand.defaultBrand:
        return 'Default';
      case ThemeBrand.midnight:
        return 'Midnight';
      case ThemeBrand.orangeDay:
        return 'Orange Day';
    }
  }
}
