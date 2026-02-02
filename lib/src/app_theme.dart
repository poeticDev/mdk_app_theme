part of mdk_app_theme_base;

/// AppColors + AppTypography를 활용해 ThemeData 생성
class AppTheme {
  const AppTheme._();

  /// 라이트 테마
  static ThemeData light({
    ThemeBrand brand = ThemeBrand.defaultBrand,
    bool? isWebOverride,
  }) {
    final bool isWeb = isWebOverride ?? kIsWeb;
    final AppColors colors = AppColors.light(brand);
    final AppTypography typography =
        isWeb ? AppTypography.web() : AppTypography.mobile();
    final ColorScheme scheme = _buildColorScheme(colors, isDark: false);
    final TextTheme textTheme = typography.textTheme.apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true, // 필요 없으면 false로 전환
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfaceElevated,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceElevated,
        elevation: 2,
        shape: ThemeMetrics.cardShape,
      ),
      dialogTheme: DialogThemeData(backgroundColor: colors.surfaceElevated),
      elevatedButtonTheme: _elevatedButtonTheme(colors, scheme),
      textButtonTheme: _textButtonTheme(colors, scheme),
      outlinedButtonTheme: _outlinedButtonTheme(colors, scheme),
      inputDecorationTheme: _inputDecorationTheme(colors, scheme, textTheme),
      tabBarTheme: _tabBarTheme(colors, scheme, textTheme),
      chipTheme: _chipTheme(colors, scheme, textTheme),
      floatingActionButtonTheme: _fabTheme(scheme),
      dividerTheme: _dividerTheme(colors),
      snackBarTheme: _snackBarTheme(colors, scheme, textTheme),
      tooltipTheme: _tooltipTheme(colors, textTheme),
      navigationRailTheme: _navigationRailTheme(colors, scheme, textTheme),
      navigationBarTheme: _navigationBarTheme(colors, scheme, textTheme),
    );
  }

  /// 다크 테마
  static ThemeData dark({
    ThemeBrand brand = ThemeBrand.defaultBrand,
    bool? isWebOverride,
  }) {
    final bool isWeb = isWebOverride ?? kIsWeb;
    final AppColors colors = AppColors.dark(brand);
    final AppTypography typography =
        isWeb ? AppTypography.web() : AppTypography.mobile();
    final ColorScheme scheme = _buildColorScheme(colors, isDark: true);
    final TextTheme textTheme = typography.textTheme.apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surfaceElevated,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: colors.surfaceElevated,
        elevation: 2,
        shape: ThemeMetrics.cardShape,
      ),
      dialogTheme: DialogThemeData(backgroundColor: colors.surfaceElevated),
      elevatedButtonTheme: _elevatedButtonTheme(colors, scheme),
      textButtonTheme: _textButtonTheme(colors, scheme),
      outlinedButtonTheme: _outlinedButtonTheme(colors, scheme),
      inputDecorationTheme: _inputDecorationTheme(colors, scheme, textTheme),
      tabBarTheme: _tabBarTheme(colors, scheme, textTheme),
      chipTheme: _chipTheme(colors, scheme, textTheme),
      floatingActionButtonTheme: _fabTheme(scheme),
      dividerTheme: _dividerTheme(colors),
      snackBarTheme: _snackBarTheme(colors, scheme, textTheme),
      tooltipTheme: _tooltipTheme(colors, textTheme),
      navigationRailTheme: _navigationRailTheme(colors, scheme, textTheme),
      navigationBarTheme: _navigationBarTheme(colors, scheme, textTheme),
    );
  }

  /// AppColors → ColorScheme 변환 레이어
  static ColorScheme _buildColorScheme(AppColors c, {required bool isDark}) {
    final Brightness brightness = isDark ? Brightness.dark : Brightness.light;

    // primaryVariant가 없을 경우 지능형 fallback (darken/lighten)
    final Color secondary = c.primaryVariant ??
        _shiftLightness(c.primary, amount: isDark ? 0.15 : -0.15);

    // tertiary가 없을 경우 secondary 사용
    final Color tertiary = c.tertiary ?? secondary;

    return ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.surface,
      secondary: secondary,
      onSecondary: c.surface,
      tertiary: tertiary,
      onTertiary: c.surface,
      surface: c.surfaceElevated,
      onSurface: c.textPrimary,
      error: c.error,
      onError: c.surface,
    );
  }

  /// 색상의 밝기를 조절하는 헬퍼 함수
  static Color _shiftLightness(Color color, {required double amount}) {
    final HSLColor hsl = HSLColor.fromColor(color);
    final double newLightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness).toColor();
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(
    AppColors colors,
    ColorScheme scheme,
  ) {
    final Color disabledBg = scheme.primary.withValues(alpha: 0.35);
    final Color disabledFg = colors.surface.withValues(alpha: 0.7);
    return ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll<Size>(
          ThemeMetrics.buttonMinSize,
        ),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          ThemeMetrics.buttonPadding,
        ),
        shape: const WidgetStatePropertyAll<OutlinedBorder>(
          ThemeMetrics.buttonShape,
        ),
        elevation: const WidgetStatePropertyAll<double>(0),
        foregroundColor: _colorState(scheme.onPrimary, disabledFg),
        backgroundColor: _colorState(scheme.primary, disabledBg),
        overlayColor: _colorState(
          scheme.onPrimary.withValues(alpha: 0.08),
          colors.surface.withValues(alpha: 0),
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(
    AppColors colors,
    ColorScheme scheme,
  ) {
    final Color disabledFg = colors.textSecondary.withValues(alpha: 0.5);
    return TextButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll<Size>(
          ThemeMetrics.buttonMinSize,
        ),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          ThemeMetrics.buttonPadding,
        ),
        shape: const WidgetStatePropertyAll<OutlinedBorder>(
          ThemeMetrics.buttonShape,
        ),
        foregroundColor: _colorState(scheme.primary, disabledFg),
        overlayColor: _colorState(
          scheme.primary.withValues(alpha: 0.1),
          colors.surface.withValues(alpha: 0),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(
    AppColors colors,
    ColorScheme scheme,
  ) {
    final BorderSide enabled = BorderSide(color: scheme.primary, width: 1.4);
    final BorderSide disabled = BorderSide(
      color: colors.textSecondary.withValues(alpha: 0.35),
      width: 1,
    );
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: const WidgetStatePropertyAll<Size>(
          ThemeMetrics.buttonMinSize,
        ),
        padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
          ThemeMetrics.buttonPadding,
        ),
        shape: const WidgetStatePropertyAll<OutlinedBorder>(
          ThemeMetrics.buttonShape,
        ),
        side: _borderState(enabled, disabled),
        foregroundColor: _colorState(scheme.primary, disabled.color),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle hintStyle = (textTheme.bodyMedium ?? const TextStyle())
        .copyWith(color: colors.textSecondary.withValues(alpha: 0.6));
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceElevated,
      hintStyle: hintStyle,
      contentPadding: ThemeMetrics.inputPadding,
      enabledBorder: _inputBorder(colors.textSecondary.withValues(alpha: 0.35)),
      focusedBorder: _inputBorder(scheme.primary),
      errorBorder: _inputBorder(colors.error),
      focusedErrorBorder: _inputBorder(colors.error),
    );
  }

  static TabBarThemeData _tabBarTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle label = (textTheme.titleSmall ?? const TextStyle())
        .copyWith(fontWeight: FontWeight.w600);
    return TabBarThemeData(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(
          color: scheme.primary,
          width: ThemeMetrics.tabIndicatorWeight,
        ),
      ),
      labelColor: scheme.primary,
      unselectedLabelColor: colors.textSecondary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: label,
      unselectedLabelStyle: label.copyWith(fontWeight: FontWeight.w400),
    );
  }

  static ChipThemeData _chipTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle label = (textTheme.bodyMedium ?? const TextStyle())
        .copyWith(color: colors.textPrimary);
    return ChipThemeData(
      backgroundColor: colors.surfaceElevated,
      selectedColor: scheme.primary.withValues(alpha: 0.15),
      disabledColor: colors.surface.withValues(alpha: 0.4),
      secondarySelectedColor: scheme.primary,
      labelStyle: label,
      secondaryLabelStyle: label.copyWith(color: scheme.onPrimary),
      padding: ThemeMetrics.chipPadding,
      shape: const StadiumBorder(),
    );
  }

  static FloatingActionButtonThemeData _fabTheme(ColorScheme scheme) {
    return FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: ThemeMetrics.fabShape,
    );
  }

  static DividerThemeData _dividerTheme(AppColors colors) {
    return DividerThemeData(
      color: colors.textSecondary.withValues(alpha: 0.2),
      thickness: ThemeMetrics.dividerThickness,
      space: ThemeMetrics.dividerThickness,
    );
  }

  static SnackBarThemeData _snackBarTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle contentStyle = (textTheme.bodyMedium ?? const TextStyle())
        .copyWith(color: colors.textPrimary);
    return SnackBarThemeData(
      backgroundColor: colors.surfaceElevated,
      behavior: SnackBarBehavior.floating,
      elevation: ThemeMetrics.snackBarElevation,
      shape: ThemeMetrics.cardShape,
      contentTextStyle: contentStyle,
      actionTextColor: scheme.primary,
      showCloseIcon: true,
      closeIconColor: colors.textSecondary,
      insetPadding: ThemeMetrics.snackBarInset,
    );
  }

  static TooltipThemeData _tooltipTheme(AppColors colors, TextTheme textTheme) {
    final TextStyle style = (textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: colors.textPrimary,
    );
    return TooltipThemeData(
      padding: ThemeMetrics.tooltipPadding,
      textStyle: style,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: ThemeMetrics.baseBorderRadius,
        border: Border.all(color: colors.textSecondary.withValues(alpha: 0.2)),
      ),
      waitDuration: const Duration(milliseconds: 200),
      preferBelow: true,
    );
  }

  static NavigationRailThemeData _navigationRailTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle label = (textTheme.labelLarge ?? const TextStyle())
        .copyWith(color: colors.textPrimary);
    return NavigationRailThemeData(
      backgroundColor: colors.surface,
      indicatorColor: scheme.primary.withValues(alpha: 0.15),
      selectedIconTheme: IconThemeData(color: scheme.primary),
      unselectedIconTheme: IconThemeData(color: colors.textSecondary),
      selectedLabelTextStyle: label.copyWith(color: scheme.primary),
      unselectedLabelTextStyle: label.copyWith(color: colors.textSecondary),
    );
  }

  static NavigationBarThemeData _navigationBarTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle label = (textTheme.labelMedium ?? const TextStyle())
        .copyWith(color: colors.textPrimary);
    return NavigationBarThemeData(
      backgroundColor: colors.surface,
      elevation: 0,
      indicatorColor: scheme.primary.withValues(alpha: 0.15),
      surfaceTintColor: colors.surface,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
        (states) => states.contains(WidgetState.selected)
            ? label.copyWith(color: scheme.primary)
            : label.copyWith(color: colors.textSecondary),
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? scheme.primary
              : colors.textSecondary,
        ),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: ThemeMetrics.baseBorderRadius,
      borderSide: BorderSide(
        color: color,
        width: ThemeMetrics.inputBorderWidth,
      ),
    );
  }

  static WidgetStateProperty<Color?> _colorState(
    Color enabled,
    Color disabled,
  ) {
    return WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled) ? disabled : enabled,
    );
  }

  static WidgetStateProperty<BorderSide?> _borderState(
    BorderSide enabled,
    BorderSide disabled,
  ) {
    return WidgetStateProperty.resolveWith(
      (states) => states.contains(WidgetState.disabled) ? disabled : enabled,
    );
  }
}
