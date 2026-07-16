import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide text size, chosen by the user in Settings. Applied via a
/// [TextScaler] in the root MaterialApp builder so every screen scales together.
enum AppTextScale { mini, medium, large, extraLarge }

extension AppTextScaleX on AppTextScale {
  /// Multiplier applied to all text.
  double get factor => switch (this) {
        AppTextScale.mini => 0.85,
        AppTextScale.medium => 1.0,
        AppTextScale.large => 1.18,
        AppTextScale.extraLarge => 1.35,
      };

  /// Translation key for the option label.
  String get labelKey => 'settings.textScale.$name';
}

/// Persisted text-scale preference (shared_preferences). Defaults to medium and
/// loads the saved value asynchronously on first build.
class TextScaleController extends Notifier<AppTextScale> {
  static const _key = 'app_text_scale';

  @override
  AppTextScale build() {
    _load();
    return AppTextScale.medium;
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    for (final v in AppTextScale.values) {
      if (v.name == name) {
        state = v;
        return;
      }
    }
  }

  Future<void> set(AppTextScale scale) async {
    state = scale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, scale.name);
  }
}

final textScaleProvider =
    NotifierProvider<TextScaleController, AppTextScale>(TextScaleController.new);
