import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'excel_importer.dart';

/// Lets the user pick an .xlsx of old records and import them. Auto-maps
/// columns by their Marathi header text; each row becomes a new crime.
Future<void> runExcelImport(BuildContext context, WidgetRef ref) async {
  final messenger = ScaffoldMessenger.of(context);

  final picked = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
    withData: true,
  );
  final file = picked?.files.single;
  if (file == null) return;

  // On desktop, bytes may be null even with withData; fall back to the path.
  var bytes = file.bytes;
  if (bytes == null && file.path != null) {
    try {
      bytes = await File(file.path!).readAsBytes();
    } catch (_) {/* handled below */}
  }
  if (bytes == null) {
    messenger.showSnackBar(SnackBar(content: Text('import.failed'.tr())));
    return;
  }

  // Reject non-xlsx early with a clear message (the excel package only reads
  // the newer zipped .xlsx; .xls / .csv are not supported).
  final isZip = bytes.length > 1 && bytes[0] == 0x50 && bytes[1] == 0x4B;
  if (!isZip) {
    messenger.showSnackBar(SnackBar(
      content: Text('import.notXlsx'.tr()),
      duration: const Duration(seconds: 6),
    ));
    return;
  }

  if (!context.mounted) return;
  // Block with a progress dialog while importing.
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      content: Row(
        children: [
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 16),
          Expanded(child: Text('import.running'.tr())),
        ],
      ),
    ),
  );

  ImportResult? result;
  Object? error;
  try {
    result = await ref.read(excelImporterProvider).import(bytes);
  } catch (e) {
    error = e;
  }

  if (!context.mounted) return;
  Navigator.of(context).pop(); // close progress dialog

  if (error != null || result == null) {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('import.failed'.tr()),
        content: SingleChildScrollView(child: Text('$error')),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('common.ok'.tr()),
          ),
        ],
      ),
    );
    return;
  }

  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('import.doneTitle'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('import.imported'
              .tr(namedArgs: {'n': '${result!.imported}'})),
          if (result.skipped > 0)
            Text('import.skipped'.tr(namedArgs: {'n': '${result.skipped}'})),
          if (result.failed > 0)
            Text('import.failedRows'
                .tr(namedArgs: {'n': '${result.failed}'})),
          if (result.errors.isNotEmpty) ...[
            const SizedBox(height: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 160),
              child: SingleChildScrollView(
                child: Text(
                  result.errors.join('\n'),
                  style: Theme.of(ctx).textTheme.bodySmall,
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text('common.ok'.tr()),
        ),
      ],
    ),
  );
}
