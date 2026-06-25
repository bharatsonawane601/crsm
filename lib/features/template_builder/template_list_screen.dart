import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';
import '../../core/theme/typography.dart';
import '../../data/db/database.dart';
import '../../shared/widgets/crms.dart';
import '../analyzer/stats_screen.dart';
import '../reports/report_service.dart' show kBundledTemplates;
import '../reports/template_repository.dart';
import 'template_draft.dart';
import 'template_editor_screen.dart';

/// Lists report templates: bundled system templates (read-only, duplicatable)
/// and user-created ones (edit / duplicate / delete). Admin-facing.
class TemplateListScreen extends ConsumerWidget {
  const TemplateListScreen({super.key});

  Future<void> _openEditor(BuildContext context, TemplateDraft draft) async {
    await Navigator.of(context).push(
      MaterialPageRoute<Object?>(
        builder: (_) => TemplateEditorScreen(draft: draft),
      ),
    );
  }

  Future<void> _duplicateBundled(
      BuildContext context, String assetPath, String name) async {
    final json = await rootBundle.loadString(assetPath);
    final draft = TemplateDraft.fromJsonString(json)
      ..name = '$name (copy)';
    if (context.mounted) await _openEditor(context, draft);
  }

  Future<void> _delete(
      BuildContext context, WidgetRef ref, ReportTemplateRow row) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('templates.deleteTitle'.tr()),
        content: Text(row.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(templateRepositoryProvider).delete(row.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbTemplates = ref.watch(dbTemplatesProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'fab_template',
        onPressed: () => _openEditor(context, TemplateDraft.starter()),
        icon: const Icon(PhosphorIconsRegular.plus),
        label: Text('templates.newTitle'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
        children: [
          _SectionHeader(title: 'templates.system'.tr()),
          // Locked built-in statistics report — read-only, opens the
          // monthly/yearly solved-vs-unsolved matrix. Cannot be edited/deleted.
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: Text('stats.title'.tr()),
              subtitle: Text('templates.lockedReport'.tr()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<Object?>(builder: (_) => const StatsScreen()),
              ),
            ),
          ),
          for (final b in kBundledTemplates)
            Card(
              child: ListTile(
                leading: const Icon(Icons.lock_outline),
                title: Text(b.displayName),
                subtitle: Text('templates.systemHint'.tr()),
                trailing: IconButton(
                  tooltip: 'templates.duplicate'.tr(),
                  icon: const Icon(Icons.copy),
                  onPressed: () =>
                      _duplicateBundled(context, b.assetPath, b.displayName),
                ),
              ),
            ),
          _SectionHeader(title: 'templates.custom'.tr()),
          dbTemplates.when(
            loading: () => const SizedBox(
              height: 220,
              child: CrmsListSkeleton(rows: 3),
            ),
            error: (_, _) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('list.loadError'.tr()),
            ),
            data: (rows) {
              if (rows.isEmpty) {
                return SizedBox(
                  height: 200,
                  child: CrmsEmptyState(
                    icon: PhosphorIconsRegular.fileDashed,
                    title: 'templates.emptyTitle'.tr(),
                    message: 'templates.empty'.tr(),
                  ),
                );
              }
              return Column(
                children: [
                  for (final row in rows)
                    Card(
                      child: ListTile(
                        leading: const Icon(
                            PhosphorIconsRegular.fileText,
                            color: AppColors.policeNavy),
                        title: Text(row.name),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: _FormatPill(format: row.outputFormat),
                        ),
                        onTap: () => _openEditor(
                          context,
                          TemplateDraft.fromJsonString(row.templateJson,
                              id: row.id),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (action) async {
                            switch (action) {
                              case 'edit':
                                await _openEditor(
                                  context,
                                  TemplateDraft.fromJsonString(row.templateJson,
                                      id: row.id),
                                );
                              case 'duplicate':
                                await _openEditor(
                                  context,
                                  TemplateDraft.fromJsonString(row.templateJson)
                                    ..name = '${row.name} (copy)',
                                );
                              case 'delete':
                                if (context.mounted) {
                                  await _delete(context, ref, row);
                                }
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem(
                                value: 'edit',
                                child: Text('common.edit'.tr())),
                            PopupMenuItem(
                                value: 'duplicate',
                                child: Text('templates.duplicate'.tr())),
                            PopupMenuItem(
                                value: 'delete',
                                child: Text('common.delete'.tr())),
                          ],
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Small pill showing a template's output format (DOCX / PDF / XLSX).
class _FormatPill extends StatelessWidget {
  const _FormatPill({required this.format});
  final String format;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.tint(AppColors.policeKhaki, 0.2),
        borderRadius: AppRadii.brSm,
      ),
      child: Text(
        format.toUpperCase(),
        style: AppType.caption.copyWith(
          color: AppColors.policeNavyDark,
          fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 4),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary)),
    );
  }
}
