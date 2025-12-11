part of mdk_app_theme_base;

typedef ThemeControllerBuilder = ThemeController Function(
  ThemePlatformAdapter adapter,
);

class ThemeRegistry {
  ThemeRegistry._();

  factory ThemeRegistry.ephemeral() {
    return ThemeRegistry._();
  }

  static final ThemeRegistry instance = ThemeRegistry._();

  ThemePlatformAdapter? _adapter;
  ThemeControllerBuilder? _controllerBuilder;
  ThemeController? _controller;

  ThemePlatformAdapter get adapter {
    ensureDefaults();
    return _adapter!;
  }

  ThemeController get controller {
    ensureDefaults();
    _controller ??= _controllerBuilder!(adapter);
    return _controller!;
  }

  void ensureDefaults() {
    _adapter ??= const AdaptiveThemePlatformAdapter();
    _controllerBuilder ??= _buildDefaultController;
  }

  void registerAdapter(ThemePlatformAdapter adapter) {
    _adapter = adapter;
    _controller = null;
  }

  void registerController(ThemeControllerBuilder builder) {
    _controllerBuilder = builder;
    _controller = null;
  }

  void reset() {
    _adapter = null;
    _controllerBuilder = null;
    _controller = null;
  }

  static ThemeController _buildDefaultController(
    ThemePlatformAdapter adapter,
  ) {
    return ThemeController(adapter: adapter);
  }
}
