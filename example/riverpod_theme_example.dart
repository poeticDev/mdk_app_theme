import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mdk_app_theme/theme_utilities.dart';

final Provider<ThemeController> themeControllerProvider =
    Provider<ThemeController>((Ref ref) {
      return ThemeController();
    });

class ThemeStateNotifier extends Notifier<ThemeControllerState> {
  late final ThemeController _controller;

  @override
  ThemeControllerState build() {
    _controller = ref.watch(themeControllerProvider);
    return const ThemeControllerState(
      mode: AdaptiveThemeMode.light,
      brand: ThemeBrand.defaultBrand,
    );
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
}

final NotifierProvider<ThemeStateNotifier, ThemeControllerState>
themeStateProvider = NotifierProvider<ThemeStateNotifier, ThemeControllerState>(
  ThemeStateNotifier.new,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AdaptiveThemeMode initialMode =
      await AdaptiveTheme.getThemeMode() ?? AdaptiveThemeMode.light;
  runApp(ProviderScope(child: ThemeDemoApp(initialMode: initialMode)));
}

class ThemeDemoApp extends ConsumerWidget {
  const ThemeDemoApp({required this.initialMode, super.key});

  final AdaptiveThemeMode initialMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

class ThemeDemoHomePage extends ConsumerStatefulWidget {
  const ThemeDemoHomePage({super.key});

  @override
  ConsumerState<ThemeDemoHomePage> createState() => _ThemeDemoHomePageState();
}

class _ThemeDemoHomePageState extends ConsumerState<ThemeDemoHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(themeStateProvider.notifier).refresh(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeControllerState state = ref.watch(themeStateProvider);
    final ThemeStateNotifier notifier = ref.read(themeStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MDK Theme Demo (Riverpod)'),
        actions: <Widget>[
          ThemeToggle(isDarkMode: state.isDark, onToggle: notifier.toggleTheme),
        ],
      ),
      body: const _ThemeDemoBody(),
    );
  }
}

class _ThemeDemoBody extends ConsumerWidget {
  const _ThemeDemoBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          _ThemeInfoPanel(),
          SizedBox(height: 24),
          _BrandSelector(),
        ],
      ),
    );
  }
}

class _ThemeInfoPanel extends ConsumerWidget {
  const _ThemeInfoPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;
    final ThemeControllerState state = ref.watch(themeStateProvider);
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

class _BrandSelector extends ConsumerWidget {
  const _BrandSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeControllerState state = ref.watch(themeStateProvider);
    final ThemeStateNotifier notifier = ref.read(themeStateProvider.notifier);
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
            notifier.changeBrand(context, brand: next, isWebOverride: true);
          },
          items: ThemeBrand.values
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
