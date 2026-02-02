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
    final ThemeBrandTokens tokens = themeBrandRegistry.tokensOf(brand);
    final ColorScheme scheme = tokens.lightScheme;
    final AppColors extension = tokens.lightExtension; // Custom colors

    final AppTypography typography =
        isWeb ? AppTypography.web() : AppTypography.mobile();

    final TextTheme textTheme = typography.textTheme.apply(
      bodyColor: scheme.onSurface, // Was colors.textPrimary
      displayColor: scheme.onSurface, // Was colors.textPrimary
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface, // Was colors.surface
      extensions: [extension],
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor:
            extension.surfaceElevated, // Was colors.surfaceElevated
        foregroundColor: scheme.onSurface, // Was colors.textPrimary
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: extension.surfaceElevated,
        elevation: 2,
        shape: ThemeMetrics.cardShape,
      ),
      dialogTheme: DialogThemeData(backgroundColor: extension.surfaceElevated),
      elevatedButtonTheme: _elevatedButtonTheme(extension, scheme),
      textButtonTheme: _textButtonTheme(extension, scheme),
      outlinedButtonTheme: _outlinedButtonTheme(extension, scheme),
      inputDecorationTheme: _inputDecorationTheme(extension, scheme, textTheme),
      tabBarTheme: _tabBarTheme(extension, scheme, textTheme),
      chipTheme: _chipTheme(extension, scheme, textTheme),
      floatingActionButtonTheme: _fabTheme(scheme),
      dividerTheme: _dividerTheme(extension, scheme),
      snackBarTheme: _snackBarTheme(extension, scheme, textTheme),
      tooltipTheme: _tooltipTheme(extension, scheme, textTheme),
      navigationRailTheme: _navigationRailTheme(extension, scheme, textTheme),
      navigationBarTheme: _navigationBarTheme(extension, scheme, textTheme),
    );
  }

  /// 다크 테마
  static ThemeData dark({
    ThemeBrand brand = ThemeBrand.defaultBrand,
    bool? isWebOverride,
  }) {
    final bool isWeb = isWebOverride ?? kIsWeb;
    final ThemeBrandTokens tokens = themeBrandRegistry.tokensOf(brand);
    final ColorScheme scheme = tokens.darkScheme;
    final AppColors extension = tokens.darkExtension;

    final AppTypography typography =
        isWeb ? AppTypography.web() : AppTypography.mobile();

    final TextTheme textTheme = typography.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      extensions: [extension],
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: extension.surfaceElevated,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: extension.surfaceElevated,
        elevation: 2,
        shape: ThemeMetrics.cardShape,
      ),
      dialogTheme: DialogThemeData(backgroundColor: extension.surfaceElevated),
      elevatedButtonTheme: _elevatedButtonTheme(extension, scheme),
      textButtonTheme: _textButtonTheme(extension, scheme),
      outlinedButtonTheme: _outlinedButtonTheme(extension, scheme),
      inputDecorationTheme: _inputDecorationTheme(extension, scheme, textTheme),
      tabBarTheme: _tabBarTheme(extension, scheme, textTheme),
      chipTheme: _chipTheme(extension, scheme, textTheme),
      floatingActionButtonTheme: _fabTheme(scheme),
      dividerTheme: _dividerTheme(extension, scheme),
      snackBarTheme: _snackBarTheme(extension, scheme, textTheme),
      tooltipTheme: _tooltipTheme(extension, scheme, textTheme),
      navigationRailTheme: _navigationRailTheme(extension, scheme, textTheme),
      navigationBarTheme: _navigationBarTheme(extension, scheme, textTheme),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(
    AppColors colors,
    ColorScheme scheme,
  ) {
    final Color disabledBg = scheme.primary.withValues(alpha: 0.35);
    final Color disabledFg =
        scheme.surface.withValues(alpha: 0.7); // Was colors.surface
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
          scheme.surface.withValues(alpha: 0), // Was colors.surface
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(
    AppColors colors,
    ColorScheme scheme,
  ) {
    final Color disabledFg = scheme.onSurfaceVariant
        .withValues(alpha: 0.5); // Was colors.textSecondary
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
          scheme.surface.withValues(alpha: 0), // Was colors.surface
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
      color: scheme.onSurfaceVariant
          .withValues(alpha: 0.35), // Was colors.textSecondary
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
        .copyWith(
            color: scheme.onSurfaceVariant
                .withValues(alpha: 0.6)); // Was colors.textSecondary
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceElevated,
      hintStyle: hintStyle,
      contentPadding: ThemeMetrics.inputPadding,
      enabledBorder: _inputBorder(scheme.onSurfaceVariant
          .withValues(alpha: 0.35)), // Was colors.textSecondary
      focusedBorder: _inputBorder(scheme.primary),
      errorBorder: _inputBorder(scheme.error), // Was colors.error
      focusedErrorBorder: _inputBorder(scheme.error), // Was colors.error
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
      unselectedLabelColor: scheme.onSurfaceVariant, // Was colors.textSecondary
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
        .copyWith(color: scheme.onSurface); // Was colors.textPrimary
    return ChipThemeData(
      backgroundColor: colors.surfaceElevated,
      selectedColor: scheme.primary.withValues(alpha: 0.15),
      disabledColor:
          scheme.surface.withValues(alpha: 0.4), // Was colors.surface
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

  static DividerThemeData _dividerTheme(
    AppColors colors,
    ColorScheme scheme,
  ) {
    // Added scheme arg
    return DividerThemeData(
      color: scheme.onSurfaceVariant
          .withValues(alpha: 0.2), // Was colors.textSecondary
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
        .copyWith(color: scheme.onSurface); // Was colors.textPrimary
    return SnackBarThemeData(
      backgroundColor: colors.surfaceElevated,
      behavior: SnackBarBehavior.floating,
      elevation: ThemeMetrics.snackBarElevation,
      shape: ThemeMetrics.cardShape,
      contentTextStyle: contentStyle,
      actionTextColor: scheme.primary,
      showCloseIcon: true,
      closeIconColor: scheme.onSurfaceVariant, // Was colors.textSecondary
      insetPadding: ThemeMetrics.snackBarInset,
    );
  }

  static TooltipThemeData _tooltipTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    // Added scheme arg
    final TextStyle style = (textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: scheme.onSurface, // Was colors.textPrimary
    );
    return TooltipThemeData(
      padding: ThemeMetrics.tooltipPadding,
      textStyle: style,
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: ThemeMetrics.baseBorderRadius,
        border: Border.all(
            color: scheme.onSurfaceVariant
                .withValues(alpha: 0.2)), // Was colors.textSecondary
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
        .copyWith(color: scheme.onSurface); // Was colors.textPrimary
    return NavigationRailThemeData(
      backgroundColor: scheme.surface, // Was colors.surface
      indicatorColor: scheme.primary.withValues(alpha: 0.15),
      selectedIconTheme: IconThemeData(color: scheme.primary),
      unselectedIconTheme: IconThemeData(
          color: scheme.onSurfaceVariant), // Was colors.textSecondary
      selectedLabelTextStyle: label.copyWith(color: scheme.primary),
      unselectedLabelTextStyle: label.copyWith(
          color: scheme.onSurfaceVariant), // Was colors.textSecondary
    );
  }

  static NavigationBarThemeData _navigationBarTheme(
    AppColors colors,
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    final TextStyle label = (textTheme.labelMedium ?? const TextStyle())
        .copyWith(color: scheme.onSurface); // Was colors.textPrimary
    return NavigationBarThemeData(
      backgroundColor: scheme.surface, // Was colors.surface
      elevation: 0,
      indicatorColor: scheme.primary.withValues(alpha: 0.15),
      surfaceTintColor: scheme.surface, // Was colors.surface
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
        (states) => states.contains(WidgetState.selected)
            ? label.copyWith(color: scheme.primary)
            : label.copyWith(
                color: scheme.onSurfaceVariant), // Was colors.textSecondary
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.onSurfaceVariant, // Was colors.textSecondary
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
