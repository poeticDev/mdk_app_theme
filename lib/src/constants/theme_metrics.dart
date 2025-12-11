part of mdk_app_theme_base;

class ThemeMetrics {
  const ThemeMetrics._();

  static const BorderRadius baseBorderRadius = BorderRadius.all(
    Radius.circular(12),
  );
  static const RoundedRectangleBorder cardShape = RoundedRectangleBorder(
    borderRadius: baseBorderRadius,
  );
  static const RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: baseBorderRadius,
  );
  static const BorderRadius fabBorderRadius = BorderRadius.all(
    Radius.circular(16),
  );
  static const RoundedRectangleBorder fabShape = RoundedRectangleBorder(
    borderRadius: fabBorderRadius,
  );
  static const double buttonHeight = 48;
  static const Size buttonMinSize = Size(64, buttonHeight);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 12,
  );
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );
  static const double inputBorderWidth = 1.4;
  static const double tabIndicatorWeight = 2;
  static const double dividerThickness = 1;
  static const double snackBarElevation = 2;
  static const EdgeInsets snackBarInset = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );
  static const EdgeInsets tooltipPadding = EdgeInsets.symmetric(
    horizontal: 10,
    vertical: 6,
  );
}
