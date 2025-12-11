part of mdk_app_theme_base;

class ThemeBrandTokens {
  const ThemeBrandTokens({
    required this.lightColors,
    required this.darkColors,
  });

  final AppColors lightColors;
  final AppColors darkColors;
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

  AppColors lightColors(ThemeBrand brand) {
    return tokensOf(brand).lightColors;
  }

  AppColors darkColors(ThemeBrand brand) {
    return tokensOf(brand).darkColors;
  }
}

const ThemeBrandRegistry themeBrandRegistry = ThemeBrandRegistry(_brandTokens);

const Map<ThemeBrand, ThemeBrandTokens> _brandTokens =
    <ThemeBrand, ThemeBrandTokens>{
  ThemeBrand.defaultBrand: defaultBrandTokens,
  ThemeBrand.midnight: midnightBrandTokens,
};

extension ThemeBrandLabel on ThemeBrand {
  String get label {
    switch (this) {
      case ThemeBrand.defaultBrand:
        return 'Default';
      case ThemeBrand.midnight:
        return 'Midnight';
    }
  }
}
