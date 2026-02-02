import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdk_app_theme/mdk_app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ThemeBrandTokens', () {
    test('default brand light/dark schemes match spec', () {
      final ThemeBrandTokens tokens =
          themeBrandRegistry.tokensOf(ThemeBrand.defaultBrand);
      final ColorScheme light = tokens.lightScheme;
      final ColorScheme dark = tokens.darkScheme;

      expect(light.primary, equals(const Color(0xFF626AE8)));
      expect(light.secondary, equals(const Color(0xFF626AE8)));
      expect(dark.surface, equals(const Color(0xFF1B2028)));
    });

    test('midnight brand exposes dedicated palette', () {
      final ThemeBrandTokens tokens =
          themeBrandRegistry.tokensOf(ThemeBrand.midnight);
      final ColorScheme light = tokens.lightScheme;
      final ColorScheme dark = tokens.darkScheme;

      expect(light.primary, equals(const Color(0xFF005695)));
      expect(dark.surface, equals(const Color(0xFF0F121A)));
    });

    test('orange day brand matches spec', () {
      final ThemeBrandTokens tokens =
          themeBrandRegistry.tokensOf(ThemeBrand.orangeDay);
      final ColorScheme light = tokens.lightScheme;
      final ColorScheme dark = tokens.darkScheme;

      expect(light.primary, equals(const Color(0xFFAC3400)));
      expect(light.secondary, equals(const Color(0xFF006A60)));
      expect(dark.primary, equals(const Color(0xFFFFB596)));
    });
  });

  group('AppTypography', () {
    test('web typography uses Pretendard Variable family from package', () {
      final AppTypography typography = AppTypography.web();
      final TextStyle? body = typography.textTheme.bodyMedium;
      const String expectedFontFamilyReference =
          'packages/${AppTypography.defaultFontPackage}/${AppTypography.defaultFontFamily}';

      expect(body?.fontFamily, equals(expectedFontFamilyReference));
    });

    test('mobile typography can opt into Paperlogy static font', () {
      final AppTypography typography = AppTypography.mobile(
        fontFamily: paperlogyFontFamily,
      );
      final TextStyle? body = typography.textTheme.bodyMedium;
      expect(body?.fontFamily, equals('Paperlogy'));
      expect(body?.fontWeight, equals(FontWeight.w500));
    });
  });

  group('AppTheme', () {
    test('light theme composes expected colors', () {
      final ThemeData theme = AppTheme.light(isWebOverride: true);
      expect(theme.colorScheme.primary, equals(const Color(0xFF626AE8)));
      const String expectedFontFamilyReference =
          'packages/${AppTypography.defaultFontPackage}/${AppTypography.defaultFontFamily}';
      expect(
        theme.textTheme.bodyMedium?.fontFamily,
        equals(expectedFontFamilyReference),
      );
    });
  });

  group('ThemeRegistry', () {
    test('ensureDefaults registers lazy singletons', () {
      final ThemeRegistry registry = ThemeRegistry.ephemeral();
      registry.ensureDefaults();

      final ThemePlatformAdapter firstAdapter = registry.adapter;
      final ThemePlatformAdapter secondAdapter = registry.adapter;
      expect(identical(firstAdapter, secondAdapter), isTrue);

      final ThemeController firstController = registry.controller;
      final ThemeController secondController = registry.controller;
      expect(identical(firstController, secondController), isTrue);
    });

    test('custom adapter/controller override works', () {
      final ThemeRegistry registry = ThemeRegistry.ephemeral();
      final _StubAdapter adapter = _StubAdapter();
      registry.registerAdapter(adapter);
      int builderCallCount = 0;
      registry.registerController((ThemePlatformAdapter input) {
        builderCallCount += 1;
        expect(input, same(adapter));
        return ThemeController(adapter: input);
      });

      final ThemeController controller = registry.controller;
      expect(controller, isA<ThemeController>());
      expect(builderCallCount, equals(1));
      expect(registry.adapter, same(adapter));
    });
  });

  group('ThemeController', () {
    test('toggle switches adapter mode', () async {
      final _StubAdapter adapter = _StubAdapter();
      final ThemeController controller = ThemeController(adapter: adapter);
      final BuildContext context = _FakeBuildContext();

      await controller.toggle(context);
      expect(adapter.mode, equals(AdaptiveThemeMode.dark));

      await controller.toggle(context);
      expect(adapter.mode, equals(AdaptiveThemeMode.light));
    });

    test('getAppColors uses current mode and initial brand by default', () {
      final _StubAdapter adapter = _StubAdapter();
      final ThemeController controller = ThemeController(
        adapter: adapter,
        initialBrand: ThemeBrand.midnight,
      );
      final BuildContext context = _FakeBuildContext();

      final AppColors actualExtension = controller.getAppColors(context);
      // AppColors only has semantic colors now
      // Midnight light success: 0xFF006C4C
      expect(actualExtension.success, equals(const Color(0xFF006C4C)));
    });

    test('getAppColors honors explicit mode and brand', () {
      final _StubAdapter adapter = _StubAdapter();
      final ThemeController controller = ThemeController(adapter: adapter);
      final BuildContext context = _FakeBuildContext();

      final AppColors actualExtension = controller.getAppColors(
        context,
        mode: AdaptiveThemeMode.dark,
        brand: ThemeBrand.orangeDay,
      );

      // OrangeDay dark success: 0xFF91D56D
      expect(actualExtension.success, equals(const Color(0xFF91D56D)));
    });

    test('getBrandList exposes registered brands', () {
      final _StubAdapter adapter = _StubAdapter();
      final ThemeController controller = ThemeController(adapter: adapter);

      final List<ThemeBrand> actualBrands = controller.getBrandList();

      expect(actualBrands, contains(ThemeBrand.defaultBrand));
      expect(actualBrands, contains(ThemeBrand.midnight));
      expect(actualBrands, contains(ThemeBrand.orangeDay));
    });
  });
}

class _StubAdapter extends ThemePlatformAdapter {
  AdaptiveThemeMode _mode = AdaptiveThemeMode.light;
  AdaptiveThemeMode get mode => _mode;

  @override
  Future<AdaptiveThemeMode?> loadSavedThemeMode() {
    return Future<AdaptiveThemeMode?>.value(_mode);
  }

  @override
  AdaptiveThemeMode currentMode(BuildContext context) {
    return _mode;
  }

  @override
  void setTheme({
    required BuildContext context,
    required ThemeData lightTheme,
    required ThemeData darkTheme,
  }) {}

  @override
  void setLight(BuildContext context) {
    _mode = AdaptiveThemeMode.light;
  }

  @override
  void setDark(BuildContext context) {
    _mode = AdaptiveThemeMode.dark;
  }

  @override
  void setSystem(BuildContext context) {
    _mode = AdaptiveThemeMode.system;
  }
}

class _FakeBuildContext extends Fake implements BuildContext {}
