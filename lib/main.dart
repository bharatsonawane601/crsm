import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/i18n/locale_config.dart';
import 'features/settings/backup_service.dart';
import 'features/sync/sync_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // Apply a staged DB restore (if any) before the database is opened.
  await BackupService.applyPendingRestore();
  // Pull a newer Google Drive copy (if any) before the database is opened.
  await pullOnLaunch();

  runApp(
    EasyLocalization(
      supportedLocales: LocaleConfig.supported,
      path: LocaleConfig.path,
      fallbackLocale: LocaleConfig.fallback,
      startLocale: LocaleConfig.fallback,
      child: const ProviderScope(child: CrmsApp()),
    ),
  );
}
