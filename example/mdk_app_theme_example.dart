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
          title: 'MDK Theme Showroom',
          theme: lightTheme,
          darkTheme: darkTheme,
          home: const ThemeShowroomPage(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class ThemeShowroomPage extends StatefulWidget {
  const ThemeShowroomPage({super.key});

  @override
  State<ThemeShowroomPage> createState() => _ThemeShowroomPageState();
}

class _ThemeShowroomPageState extends State<ThemeShowroomPage> {
  final ThemeController _controller = ThemeController();
  ThemeControllerState _state = const ThemeControllerState(
    mode: AdaptiveThemeMode.system,
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
      setState(() => _state = _state.copyWith(mode: saved));
    }
    await _refreshMode(context);
  }

  Future<void> _refreshMode(BuildContext context) async {
    final AdaptiveThemeMode mode = _controller.effectiveMode(context);
    if (!mounted) return;
    setState(() => _state = _state.copyWith(mode: mode));
  }

  Future<void> _toggle(BuildContext context) async {
    await _controller.toggle(context);
    await _refreshMode(context);
  }

  Future<void> _changeBrand(BuildContext context, ThemeBrand brand) async {
    await _controller.setBrand(context, brand: brand);
    if (!mounted) return;
    setState(() => _state = _state.copyWith(brand: brand));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${_state.brand.label} Showroom'),
        actions: <Widget>[
          _BrandDropdown(
            currentBrand: _state.brand,
            onChanged: (brand) => _changeBrand(context, brand),
            brands: _controller.getBrandList(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(_state.isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => _toggle(context),
            tooltip: 'Toggle Theme',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: 'Color Palette'),
            _ColorPaletteGrid(colorScheme: theme.colorScheme),
            const SizedBox(height: 32),
            _SectionHeader(title: 'Typography'),
            _TypographyPreview(textTheme: theme.textTheme),
            const SizedBox(height: 32),
            _SectionHeader(title: 'Components'),
            _ComponentGallery(),
          ],
        ),
      ),
    );
  }
}

class _BrandDropdown extends StatelessWidget {
  const _BrandDropdown({
    required this.currentBrand,
    required this.onChanged,
    required this.brands,
  });

  final ThemeBrand currentBrand;
  final ValueChanged<ThemeBrand> onChanged;
  final List<ThemeBrand> brands;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<ThemeBrand>(
          value: currentBrand,
          onChanged: (val) => val != null ? onChanged(val) : null,
          items: brands.map((brand) {
            return DropdownMenuItem(
              value: brand,
              child: Text(brand.label),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

class _ColorPaletteGrid extends StatelessWidget {
  const _ColorPaletteGrid({required this.colorScheme});
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _ColorCard('Primary', colorScheme.primary, colorScheme.onPrimary),
        _ColorCard('Secondary', colorScheme.secondary, colorScheme.onSecondary),
        _ColorCard('Tertiary', colorScheme.tertiary, colorScheme.onTertiary),
        _ColorCard('Surface', colorScheme.surface, colorScheme.onSurface),
        _ColorCard('Error', colorScheme.error, colorScheme.onError),
      ],
    );
  }
}

class _ColorCard extends StatelessWidget {
  const _ColorCard(this.label, this.color, this.onColor);
  final String label;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(color: onColor, fontWeight: FontWeight.bold)),
          Text(
            '#${color.toARGB32().toRadixString(16).toUpperCase().substring(2)}',
            style:
                TextStyle(color: onColor.withValues(alpha: 0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _TypographyPreview extends StatelessWidget {
  const _TypographyPreview({required this.textTheme});
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Display Large 57pt', style: textTheme.displayLarge),
            Text('Headline Medium 28pt', style: textTheme.headlineMedium),
            Text('Title Medium 16pt (Medium weight)',
                style: textTheme.titleMedium),
            Text('Body Large 16pt (Regular weight) - Pretendard Variable',
                style: textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}

class _ComponentGallery extends StatelessWidget {
  const _ComponentGallery();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Buttons',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
                const SizedBox(width: 8),
                FilledButton(onPressed: () {}, child: const Text('Filled')),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Inputs', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const SizedBox(
              width: 200,
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Label',
                  hintText: 'Input text',
                ),
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chips', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: const [
                Chip(label: Text('Chip 1')),
                SizedBox(width: 8),
                FilterChip(
                    selected: true, onSelected: null, label: Text('Selected')),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
