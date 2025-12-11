part of mdk_app_theme_base;

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
    final String tooltip =
        isDarkMode ? '라이트 모드로 전환' : '다크 모드로 전환';
    final IconData icon = isDarkMode ? Icons.dark_mode : Icons.light_mode;
    final Color iconColor = isDarkMode ? Colors.yellow : Colors.orangeAccent;

    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, color: iconColor),
      onPressed: () => onToggle(context),
    );
  }
}
