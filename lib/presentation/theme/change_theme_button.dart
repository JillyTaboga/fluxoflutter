import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluxoflutter/presentation/theme/theme_controller.dart';

class ChangeThemeButton extends ConsumerWidget {
  const ChangeThemeButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(currentThemeProvider) == ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Switch(
            onChanged: (value) {
              ref.read(currentThemeProvider.notifier).changeTheme();
            },
            value: isDark,
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: isDark
                ? Icon(
                    Icons.dark_mode,
                    key: ValueKey(isDark),
                  )
                : Icon(
                    Icons.light_mode,
                    key: ValueKey(isDark),
                  ),
          ),
        ],
      ),
    );
  }
}
