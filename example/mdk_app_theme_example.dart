import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:mdk_app_theme/theme_utilities.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AdaptiveThemeMode initialMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;
  runApp(ThemeDemoApp(initialMode: initialMode));
}

class ThemeDemoApp extends StatelessWidget {
  const ThemeDemoApp({required this.initialMode, super.key});

  final AdaptiveThemeMode initialMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.light(isWebOverride: true),
      dark: AppTheme.dark(isWebOverride: true),
      initial: initialMode,
      builder: (ThemeData lightTheme, ThemeData darkTheme) {
        return MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const ThemeDemoHomePage(),
        );
      },
    );
  }
}

class ThemeDemoHomePage extends StatefulWidget {
  const ThemeDemoHomePage({super.key});

  @override
  State<ThemeDemoHomePage> createState() => _ThemeDemoHomePageState();
}

class _ThemeDemoHomePageState extends State<ThemeDemoHomePage> {
  final ThemeController _controller = ThemeController();
  ThemeControllerState _state = const ThemeControllerState(
    mode: AdaptiveThemeMode.light,
    brand: ThemeBrand.defaultBrand,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize(context);
    });
  }

  Future<void> _initialize(BuildContext context) async {
    final AdaptiveThemeMode? saved = await _controller.loadSavedThemeMode();
    if (!mounted) return;
    if (saved != null) {
      setState(() {
        _state = _state.copyWith(mode: saved);
      });
    }
    await _refreshMode(context);
  }

  Future<void> _refreshMode(BuildContext context) async {
    final AdaptiveThemeMode mode = _controller.effectiveMode(context);
    if (!mounted) return;
    setState(() {
      _state = _state.copyWith(mode: mode);
    });
  }

  Future<void> _toggle(BuildContext context) async {
    await _controller.toggle(context);
    await _refreshMode(context);
  }

  Future<void> _changeBrand(BuildContext context, ThemeBrand brand) async {
    await _controller.setBrand(context, brand: brand);
    if (!mounted) return;
    setState(() {
      _state = _state.copyWith(brand: brand);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<ThemeBrand> brands = _controller.getBrandList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('MDK Theme Demo (Pure)'),
        actions: <Widget>[
          ThemeToggle(isDarkMode: _state.isDark, onToggle: _toggle),
        ],
      ),
      body: _ThemeDemoBody(
        state: _state,
        brands: brands,
        onBrandChanged: (ThemeBrand brand) => _changeBrand(context, brand),
      ),
    );
  }
}

class _ThemeDemoBody extends StatelessWidget {
  const _ThemeDemoBody({
    required this.state,
    required this.brands,
    required this.onBrandChanged,
  });

  final ThemeControllerState state;
  final List<ThemeBrand> brands;
  final ValueChanged<ThemeBrand> onBrandChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _ThemeInfoPanel(state: state),
          const SizedBox(height: 24),
          _BrandSelector(
            state: state,
            brands: brands,
            onBrandChanged: onBrandChanged,
          ),
        ],
      ),
    );
  }
}

class _ThemeInfoPanel extends StatelessWidget {
  const _ThemeInfoPanel({required this.state});

  final ThemeControllerState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _ThemeInfoContent(
            textTheme: textTheme,
            primaryColor: theme.colorScheme.primary,
            brandLabel: state.brand.label,
          ),
        ),
      ),
    );
  }
}

class _ThemeInfoContent extends StatelessWidget {
  const _ThemeInfoContent({
    required this.textTheme,
    required this.primaryColor,
    required this.brandLabel,
  });

  final TextTheme textTheme;
  final Color primaryColor;
  final String brandLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Brand: $brandLabel', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        Text('Primary color', style: textTheme.titleLarge),
        const SizedBox(height: 8),
        _ColorSwatch(color: primaryColor),
        const SizedBox(height: 24),
        Text('Typography preview', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        Text(
          'Pretendard Variable 기반 TextTheme 입니다.',
          style: textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _BrandSelector extends StatelessWidget {
  const _BrandSelector({
    required this.state,
    required this.brands,
    required this.onBrandChanged,
  });

  final ThemeControllerState state;
  final List<ThemeBrand> brands;
  final ValueChanged<ThemeBrand> onBrandChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('브랜드 선택', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(width: 12),
        DropdownButton<ThemeBrand>(
          value: state.brand,
          onChanged: (ThemeBrand? next) {
            if (next == null || next == state.brand) {
              return;
            }
            onBrandChanged(next);
          },
          items: brands
              .map(
                (ThemeBrand brand) => DropdownMenuItem<ThemeBrand>(
                  value: brand,
                  child: Text(brand.label),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({
    super.key,
    required this.isDarkMode,
    required this.onToggle,
  });

  final bool isDarkMode;
  final Future<void> Function(BuildContext context) onToggle;

  @override
  Widget build(BuildContext context) {
    final String tooltip = isDarkMode ? '라이트 모드로 전환' : '다크 모드로 전환';
    final IconData icon = isDarkMode ? Icons.dark_mode : Icons.light_mode;
    final Color iconColor = isDarkMode ? Colors.yellow : Colors.orangeAccent;

    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, color: iconColor),
      onPressed: () => onToggle(context),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
