import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../shared/widgets/crms.dart';
import 'audit_repository.dart';

final _ts = DateFormat('dd-MM-yyyy HH:mm');

/// Read-only view of the audit trail (most recent first).
class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key, this.embedded = false});

  /// When true, omits the Scaffold app bar (the shell provides the top bar).
  final bool embedded;

  IconData _icon(String action) => switch (action) {
        'create' => PhosphorIconsRegular.plusCircle,
        'update' => PhosphorIconsRegular.pencilSimple,
        'delete' => PhosphorIconsRegular.trash,
        _ => PhosphorIconsRegular.clockCounterClockwise,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(auditLogProvider);
    return Scaffold(
      appBar: embedded ? null : AppBar(title: Text('audit.title'.tr())),
      body: entries.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text('list.loadError'.tr())),
        data: (rows) {
          if (rows.isEmpty) {
            return CrmsEmptyState(
              icon: PhosphorIconsRegular.clockCounterClockwise,
              title: 'audit.empty'.tr(),
            );
          }
          return ListView.builder(
            itemCount: rows.length,
            itemBuilder: (context, i) {
              final e = rows[i];
              return ListTile(
                leading: Icon(_icon(e.action)),
                title: Text(
                  '${'audit.action.${e.action}'.tr()}'
                  '${e.changesJson != null ? ' — ${e.changesJson}' : ''}',
                ),
                subtitle: Text(_ts.format(e.timestamp)),
              );
            },
          );
        },
      ),
    );
  }
}
