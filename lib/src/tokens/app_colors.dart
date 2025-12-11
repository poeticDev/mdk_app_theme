part of mdk_app_theme_base;

/// 사용가능한 테마 브랜드
enum ThemeBrand { defaultBrand, midnight }

/// 앱 전체에서 사용할 semantic color들을 정의
class AppColors {
  final Color primary;
  final Color primaryVariant;
  final Color surface;
  final Color surfaceElevated;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color warning;
  final Color error;

  const AppColors({
    required this.primary,
    required this.primaryVariant,
    required this.surface,
    required this.surfaceElevated,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.warning,
    required this.error,
  });

  /// 브랜드 + 라이트/다크 조합으로 분기
  factory AppColors.light(ThemeBrand brand) {
    return themeBrandRegistry.lightColors(brand);
  }

  factory AppColors.dark(ThemeBrand brand) {
    return themeBrandRegistry.darkColors(brand);
  }
}
