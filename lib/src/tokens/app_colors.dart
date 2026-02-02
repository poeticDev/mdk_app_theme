part of mdk_app_theme_base;

/// 사용가능한 테마 브랜드
enum ThemeBrand { defaultBrand, midnight, orangeDay }

/// 앱 전체에서 사용할 semantic color들을 정의
/// 표준 Material ColorScheme에 없는 커스텀 색상만 관리합니다.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color success;
  final Color warning;
  final Color surfaceElevated;

  // textPrimary, textSecondary는 ColorScheme의 onSurface, onSurfaceVariant 등으로 대체 권장
  // 하지만 마이그레이션 편의 및 명시적 의미를 위해 extensions에 남겨둘 수도 있으나,
  // 이번 리팩토링에서는 ColorScheme 사용을 강제하기 위해 표준 필드는 제거합니다.

  const AppColors({
    required this.success,
    required this.warning,
    required this.surfaceElevated,
  });

  @override
  AppColors copyWith({
    Color? success,
    Color? warning,
    Color? surfaceElevated,
  }) {
    return AppColors(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
    );
  }

  // 기존 static factory light/dark 메서드는 ThemeBrandRegistry 구조 변경에 따라 제거하거나
  // ThemeBrandTokens에서 직접 관리하도록 변경합니다.
}
