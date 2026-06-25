import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/crms_theme.dart';

/// Sun/moon icon button that toggles light/dark. Tinted for the navy top bar.
class DarkModeToggle extends ConsumerWidget {
  const DarkModeToggle({super.key, this.onNavy = true});

  /// When placed on the navy top bar, render in white.
  final bool onNavy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == ThemeMode.dark;
    return IconButton(
      tooltip: (isDark ? 'common.lightMode' : 'common.darkMode').tr(),
      color: onNavy ? Colors.white : null,
      icon: Icon(
        isDark ? PhosphorIconsRegular.sun : PhosphorIconsRegular.moon,
        size: 20,
      ),
      onPressed: () => ref.read(themeModeProvider.notifier).toggle(),
    );
  }
}
