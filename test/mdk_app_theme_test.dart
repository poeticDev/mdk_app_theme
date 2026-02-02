import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdk_app_theme/mdk_app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppColors', () {
    test('default brand light/dark palettes match spec', () {
      final AppColors light = AppColors.light(ThemeBrand.defaultBrand);
      final AppColors dark = AppColors.dark(ThemeBrand.defaultBrand);

      expect(light.primary, equals(const Color(0xFFFF7753)));
      expect(
        light.secondary,
        equals(const Color(0xFF554b55)),
      ); // Added secondary check
      expect(dark.surfaceElevated, equals(const Color(0xFF242A34)));
    });

    test('midnight brand exposes dedicated palette', () {
      final AppColors light = AppColors.light(ThemeBrand.midnight);
      final AppColors dark = AppColors.dark(ThemeBrand.midnight);

      // Updated Primary Expectation
      expect(light.primary, equals(const Color(0xFF005695)));
      expect(dark.surface, equals(const Color(0xFF1B2028)));
    });

    test('orange day brand matches spec', () {
      final AppColors light = AppColors.light(ThemeBrand.orangeDay);
      final AppColors dark = AppColors.dark(ThemeBrand.orangeDay);

      expect(light.primary, equals(const Color(0xFFFF7753)));
      expect(light.secondary, equals(const Color(0xFF554b55)));
      expect(dark.primary, equals(const Color(0xFFFF7753)));
    });

    test('nullable primaryVariant generates fallback in AppTheme', () {
      // Default brand light has no primaryVariant
      final ThemeData theme = AppTheme.light(brand: ThemeBrand.defaultBrand);
      final Color primary = const Color(0xFFFF7753);

      // Expected: primary shifted by -0.15 lightness
      final HSLColor hsl = HSLColor.fromColor(primary);
      final Color expectedSecondary =
          hsl.withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0)).toColor();

      expect(theme.colorScheme.primary, equals(primary));
      expect(theme.colorScheme.secondary, equals(expectedSecondary));
    });

    test('tertiary color is correctly mapped in AppTheme', () {
      // Default brand light has tertiary: Color(0xFF24879f)
      final ThemeData theme = AppTheme.light(brand: ThemeBrand.defaultBrand);
      expect(theme.colorScheme.tertiary, equals(const Color(0xFF24879f)));
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
      expect(theme.colorScheme.primary, equals(const Color(0xFFFF7753)));
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

      final AppColors actualColors = controller.getAppColors(context);

      expect(actualColors.primary, equals(const Color(0xFF005695)));
    });

    test('getAppColors honors explicit mode and brand', () {
      final _StubAdapter adapter = _StubAdapter();
      final ThemeController controller = ThemeController(adapter: adapter);
      final BuildContext context = _FakeBuildContext();

      final AppColors actualColors = controller.getAppColors(
        context,
        mode: AdaptiveThemeMode.dark,
        brand: ThemeBrand.midnight,
      );

      expect(actualColors.primary, equals(const Color(0xFF626AE8)));
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
