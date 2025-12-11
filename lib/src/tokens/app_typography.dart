part of mdk_app_theme_base;

enum AppTypographyRole { bold, semiBold, medium, regular }

abstract class AppFontFamily {
  const AppFontFamily();

  TextStyle apply(
    TextStyle? base,
    AppTypographyRole role, {
    double scale = 1.0,
  });
}

class VariableFontFamily extends AppFontFamily {
  const VariableFontFamily({
    required this.family,
    required this.package,
    required this.roleVariations,
  });

  final String family;
  final String package;
  final Map<AppTypographyRole, List<FontVariation>> roleVariations;

  @override
  TextStyle apply(
    TextStyle? base,
    _TypographyRole role, {
    double scale = 1.0,
  }) {
    final TextStyle resolved = base ?? const TextStyle();
    final double? fontSize =
        resolved.fontSize == null ? null : resolved.fontSize! * scale;
    final List<FontVariation> variations =
        roleVariations[role] ?? const <FontVariation>[];
    return resolved.copyWith(
      fontFamily: family,
      package: package,
      fontVariations: variations,
      fontWeight: null,
      fontSize: fontSize,
    );
  }
}

class StaticFontFamily extends AppFontFamily {
  const StaticFontFamily({
    required this.family,
    required this.roleWeights,
    this.package,
  });

  final String family;
  final Map<AppTypographyRole, FontWeight> roleWeights;
  final String? package;

  @override
  TextStyle apply(
    TextStyle? base,
    _TypographyRole role, {
    double scale = 1.0,
  }) {
    final TextStyle resolved = base ?? const TextStyle();
    final double? fontSize =
        resolved.fontSize == null ? null : resolved.fontSize! * scale;
    final FontWeight weight = roleWeights[role] ?? FontWeight.w400;
    return resolved.copyWith(
      fontFamily: family,
      package: package,
      fontWeight: weight,
      fontVariations: null,
      fontSize: fontSize,
    );
  }
}

const VariableFontFamily defaultVariableFontFamily = VariableFontFamily(
  family: 'Pretendard Variable',
  package: 'mdk_app_theme',
  roleVariations: <AppTypographyRole, List<FontVariation>>{
    AppTypographyRole.bold: <FontVariation>[FontVariation('wght', 700)],
    AppTypographyRole.semiBold: <FontVariation>[FontVariation('wght', 600)],
    AppTypographyRole.medium: <FontVariation>[FontVariation('wght', 500)],
    AppTypographyRole.regular: <FontVariation>[FontVariation('wght', 400)],
  },
);

const StaticFontFamily paperlogyFontFamily = StaticFontFamily(
  family: 'Paperlogy',
  roleWeights: <AppTypographyRole, FontWeight>{
    AppTypographyRole.bold: FontWeight.w700,
    AppTypographyRole.semiBold: FontWeight.w600,
    AppTypographyRole.medium: FontWeight.w500,
    AppTypographyRole.regular: FontWeight.w400,
  },
);

/// 플랫폼별 TextTheme 설정을 담당
class AppTypography {
  static const String defaultFontFamily = 'Pretendard Variable';
  static const String defaultFontPackage = 'mdk_app_theme';

  final TextTheme textTheme;

  const AppTypography._(this.textTheme);

  /// 웹 환경: 헤드라인 가독성을 위한 소폭 스케일 업
  factory AppTypography.web({
    AppFontFamily fontFamily = defaultVariableFontFamily,
  }) {
    final TextTheme base = ThemeData.light().textTheme;
    return AppTypography._(
      _buildTextTheme(
        base,
        fontFamily: fontFamily,
        headlineScale: 1.04,
      ),
    );
  }

  /// 모바일/데스크톱 앱용 (asset 폰트 기반)
  factory AppTypography.mobile({
    AppFontFamily fontFamily = defaultVariableFontFamily,
  }) {
    final TextTheme base = ThemeData.light().textTheme;
    return AppTypography._(
      _buildTextTheme(
        base,
        fontFamily: fontFamily,
      ),
    );
  }

  static TextTheme _buildTextTheme(
    TextTheme base, {
    required AppFontFamily fontFamily,
    double headlineScale = 1.0,
  }) {
    TextStyle apply(
      TextStyle? style,
      AppTypographyRole role, {
      double scale = 1.0,
    }) {
      return fontFamily.apply(style, role, scale: scale);
    }

    return base.copyWith(
      displayLarge: apply(
        base.displayLarge,
        AppTypographyRole.bold,
        scale: headlineScale,
      ),
      displayMedium: apply(
        base.displayMedium,
        AppTypographyRole.bold,
        scale: headlineScale,
      ),
      displaySmall: apply(base.displaySmall, AppTypographyRole.bold),
      headlineLarge: apply(
        base.headlineLarge,
        AppTypographyRole.bold,
        scale: headlineScale,
      ),
      headlineMedium: apply(base.headlineMedium, AppTypographyRole.semiBold),
      headlineSmall: apply(base.headlineSmall, AppTypographyRole.semiBold),
      titleLarge: apply(base.titleLarge, AppTypographyRole.bold),
      titleMedium: apply(base.titleMedium, AppTypographyRole.semiBold),
      titleSmall: apply(base.titleSmall, AppTypographyRole.medium),
      bodyLarge: apply(base.bodyLarge, AppTypographyRole.medium),
      bodyMedium: apply(base.bodyMedium, AppTypographyRole.medium),
      bodySmall: apply(base.bodySmall, AppTypographyRole.regular),
      labelLarge: apply(base.labelLarge, AppTypographyRole.medium),
      labelMedium: apply(base.labelMedium, AppTypographyRole.regular),
      labelSmall: apply(base.labelSmall, AppTypographyRole.regular),
    );
  }
}
