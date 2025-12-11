part of mdk_app_theme_base;

class ThemeControllerState {
  const ThemeControllerState({
    required this.mode,
    required this.brand,
  });

  final AdaptiveThemeMode mode;
  final ThemeBrand brand;

  bool get isDark => mode == AdaptiveThemeMode.dark;

  ThemeControllerState copyWith({
    AdaptiveThemeMode? mode,
    ThemeBrand? brand,
  }) {
    return ThemeControllerState(
      mode: mode ?? this.mode,
      brand: brand ?? this.brand,
    );
  }
}

const ThemeControllerState initialThemeControllerState = ThemeControllerState(
  mode: AdaptiveThemeMode.light,
  brand: ThemeBrand.defaultBrand,
);

class ThemeControllerNotifier extends Notifier<ThemeControllerState> {
  late final ThemeController _controller;

  @override
  ThemeControllerState build() {
    _controller = ref.watch(themeControllerProvider);
    return initialThemeControllerState;
  }

  Future<void> refresh(BuildContext context) async {
    final AdaptiveThemeMode mode = _controller.effectiveMode(context);
    state = state.copyWith(mode: mode);
  }

  Future<void> toggleTheme(BuildContext context) async {
    await _controller.toggle(context);
    await refresh(context);
  }

  Future<void> changeBrand(
    BuildContext context, {
    required ThemeBrand brand,
    bool? isWebOverride,
  }) async {
    await _controller.setBrand(
      context,
      brand: brand,
      isWebOverride: isWebOverride,
    );
    state = state.copyWith(brand: brand);
  }

  Future<void> loadSavedThemeMode() async {
    final AdaptiveThemeMode? saved = await _controller.loadSavedThemeMode();
    if (saved != null) {
      state = state.copyWith(mode: saved);
    }
  }
}

final NotifierProvider<ThemeControllerNotifier, ThemeControllerState>
    themeControllerStateProvider =
    NotifierProvider<ThemeControllerNotifier, ThemeControllerState>(
  ThemeControllerNotifier.new,
);
