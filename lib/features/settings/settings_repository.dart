import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-level settings (station identity + report defaults). Stored as simple
/// key/values in shared_preferences — no schema needed.
class AppSettings {
  const AppSettings({
    this.stationNameMarathi = '',
    this.stationNameEnglish = '',
    this.district = '',
    this.code = '',
    this.defaultTemplateKey,
  });

  final String stationNameMarathi;
  final String stationNameEnglish;
  final String district;
  final String code;

  /// TemplateChoice.key of the report template pre-selected in the generate
  /// sheet, or null for "first available".
  final String? defaultTemplateKey;

  /// Station map consumed by the report engine for {station.*} placeholders.
  Map<String, String> get stationMap => {
        'name_marathi': stationNameMarathi,
        'name_english': stationNameEnglish,
        'district': district,
        'code': code,
      };

  bool get hasStation =>
      stationNameMarathi.isNotEmpty ||
      stationNameEnglish.isNotEmpty ||
      district.isNotEmpty ||
      code.isNotEmpty;

  AppSettings copyWith({
    String? stationNameMarathi,
    String? stationNameEnglish,
    String? district,
    String? code,
    String? defaultTemplateKey,
  }) =>
      AppSettings(
        stationNameMarathi: stationNameMarathi ?? this.stationNameMarathi,
        stationNameEnglish: stationNameEnglish ?? this.stationNameEnglish,
        district: district ?? this.district,
        code: code ?? this.code,
        defaultTemplateKey: defaultTemplateKey ?? this.defaultTemplateKey,
      );
}

class SettingsRepository {
  static const _kNameMr = 'station_name_mr';
  static const _kNameEn = 'station_name_en';
  static const _kDistrict = 'station_district';
  static const _kCode = 'station_code';
  static const _kDefaultTemplate = 'default_template_key';

  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      stationNameMarathi: prefs.getString(_kNameMr) ?? '',
      stationNameEnglish: prefs.getString(_kNameEn) ?? '',
      district: prefs.getString(_kDistrict) ?? '',
      code: prefs.getString(_kCode) ?? '',
      defaultTemplateKey: prefs.getString(_kDefaultTemplate),
    );
  }

  Future<void> save(AppSettings s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kNameMr, s.stationNameMarathi);
    await prefs.setString(_kNameEn, s.stationNameEnglish);
    await prefs.setString(_kDistrict, s.district);
    await prefs.setString(_kCode, s.code);
    if (s.defaultTemplateKey == null) {
      await prefs.remove(_kDefaultTemplate);
    } else {
      await prefs.setString(_kDefaultTemplate, s.defaultTemplateKey!);
    }
  }
}

final settingsRepositoryProvider =
    Provider<SettingsRepository>((ref) => SettingsRepository());

/// Current settings; invalidate after saving to refresh consumers.
final settingsProvider = FutureProvider<AppSettings>(
  (ref) => ref.watch(settingsRepositoryProvider).load(),
);
