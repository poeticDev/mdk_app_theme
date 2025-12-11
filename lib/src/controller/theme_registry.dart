part of mdk_app_theme_base;

typedef ThemeControllerBuilder = ThemeController Function(
  ThemePlatformAdapter adapter,
);

class ThemeRegistry {
  ThemeRegistry._(this._container);

  factory ThemeRegistry.custom(GetIt container) {
    return ThemeRegistry._(container);
  }

  final GetIt _container;

  static final ThemeRegistry instance = ThemeRegistry._(GetIt.instance);

  ThemePlatformAdapter get adapter {
    ensureDefaults();
    return _container<ThemePlatformAdapter>();
  }

  ThemeController get controller {
    ensureDefaults();
    return _container<ThemeController>();
  }

  void ensureDefaults() {
    if (!_container.isRegistered<ThemePlatformAdapter>()) {
      registerAdapter(const AdaptiveThemePlatformAdapter());
    }
    if (!_container.isRegistered<ThemeController>()) {
      registerController(_buildDefaultController);
    }
  }

  void registerAdapter(ThemePlatformAdapter adapter) {
    _replaceSingleton<ThemePlatformAdapter>(adapter);
  }

  void registerController(ThemeControllerBuilder builder) {
    _unregister<ThemeController>();
    _container.registerLazySingleton<ThemeController>(() {
      final ThemePlatformAdapter adapter = this.adapter;
      return builder(adapter);
    });
  }

  void reset() {
    _unregister<ThemePlatformAdapter>();
    _unregister<ThemeController>();
  }

  static ThemeController _buildDefaultController(
    ThemePlatformAdapter adapter,
  ) {
    return ThemeController(adapter: adapter);
  }

  void _replaceSingleton<T extends Object>(T instance) {
    _unregister<T>();
    _container.registerSingleton<T>(instance);
  }

  void _unregister<T extends Object>() {
    if (_container.isRegistered<T>()) {
      _container.unregister<T>();
    }
  }
}
