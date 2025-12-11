part of mdk_app_theme_base;

class ThemeToggle extends ConsumerWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeControllerState state = ref.watch(themeControllerStateProvider);
    final ThemeControllerNotifier notifier =
        ref.read(themeControllerStateProvider.notifier);
    final bool isDark = state.isDark;
    final String tooltip = isDark ? '라이트 모드로 전환' : '다크 모드로 전환';
    final IconData icon = isDark ? Icons.dark_mode : Icons.light_mode;
    final Color iconColor = isDark ? Colors.yellow : Colors.orangeAccent;

    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, color: iconColor),
      onPressed: () => notifier.toggleTheme(context),
    );
  }
}
