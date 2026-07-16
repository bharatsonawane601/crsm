import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';
import '../../core/theme/typography.dart';

/// A filled status pill: tinted background + solid colored text, 24px tall.
class CrmsBadge extends StatelessWidget {
  const CrmsBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  /// Maps a crime `status` code to its semantic color and localized label.
  factory CrmsBadge.status(String statusCode) {
    final color = switch (statusCode) {
      'detected' => AppColors.successGreen,
      'undetected' => AppColors.warningAmber,
      // Legacy values still shown on old records.
      'solved' => AppColors.successGreen,
      'chargesheeted' => AppColors.policeKhaki,
      'pending' => AppColors.warningAmber,
      'wanted' => AppColors.dangerRed,
      'investigating' => AppColors.infoBlue,
      _ => AppColors.infoBlue, // open / default
    };
    return CrmsBadge(label: 'crime.status.$statusCode'.tr(), color: color);
  }

  /// Maps a case-stage code (investigation / chargesheet / both / court /
  /// disposed) to its color and localized label.
  factory CrmsBadge.stage(String? stageCode) {
    final code = (stageCode == null || stageCode.isEmpty)
        ? 'investigation'
        : stageCode;
    final color = switch (code) {
      'investigation' => AppColors.infoBlue,
      'chargesheet' => AppColors.policeKhaki,
      'both' => AppColors.warningAmber,
      'court' => AppColors.dangerRed,
      'disposed' => AppColors.successGreen,
      _ => AppColors.infoBlue,
    };
    return CrmsBadge(label: 'crime.stage.$code'.tr(), color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.tint(color, color == AppColors.policeKhaki ? 0.2 : 0.12),
        borderRadius: AppRadii.brSm,
      ),
      child: Text(
        label,
        style: AppType.caption.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Renders one or more case-stage pills from a comma-separated stage string
/// (e.g. "investigation,chargesheet"). A FIR can sit at several stages at once.
class StageBadges extends StatelessWidget {
  const StageBadges(this.value, {super.key});

  /// Comma-separated stage codes, or a single legacy value like 'both'.
  final String? value;

  static List<String> _parse(String? v) {
    final parts = (v ?? '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    final out = <String>[];
    for (final p in parts) {
      if (p == 'both') {
        out..add('investigation')..add('chargesheet');
      } else {
        out.add(p);
      }
    }
    return out.isEmpty ? ['investigation'] : out;
  }

  @override
  Widget build(BuildContext context) {
    final codes = _parse(value);
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [for (final c in codes) CrmsBadge.stage(c)],
    );
  }
}

/// Chargesheet window in days for a court type ('sessions' = 90, 'jmfc' = 60).
int? chargesheetWindowDays(String? courtType) => switch (courtType) {
      'sessions' => 90,
      'jmfc' => 60,
      _ => null,
    };

/// Days remaining (negative = overdue) until the chargesheet deadline, computed
/// from the registration date and court window against today. Returns null when
/// no court is selected or the case isn't registered.
int? chargesheetDaysRemaining({
  required String? courtType,
  required DateTime? dateRegistered,
}) {
  final window = chargesheetWindowDays(courtType);
  if (window == null || dateRegistered == null) return null;
  final deadline = dateRegistered.add(Duration(days: window));
  final now = DateTime.now();
  return deadline.difference(DateTime(now.year, now.month, now.day)).inDays;
}

/// A compact chargesheet-deadline pill for lists: green (>15 days), amber
/// (≤15 days) or red (overdue). Returns null — and renders nothing — when the
/// case is detected, has no court selected, or isn't registered yet.
class ChargesheetBadge extends StatelessWidget {
  const ChargesheetBadge._(this.remaining);

  final int remaining;

  static Widget? maybe({
    required String status,
    required String? courtType,
    required DateTime? dateRegistered,
  }) {
    // Once detected/charge-sheeted, the deadline no longer applies.
    final s = status.toLowerCase();
    if (s == 'detected' || s == 'solved' || s == 'chargesheeted') return null;
    final remaining =
        chargesheetDaysRemaining(courtType: courtType, dateRegistered: dateRegistered);
    if (remaining == null) return null;
    return ChargesheetBadge._(remaining);
  }

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;
    if (remaining < 0) {
      color = AppColors.dangerRed;
      label = 'chargesheet.overdue'.tr(namedArgs: {'n': '${-remaining}'});
    } else {
      color = remaining <= 15 ? AppColors.warningAmber : AppColors.successGreen;
      label = 'chargesheet.daysLeft'.tr(namedArgs: {'n': '$remaining'});
    }
    return CrmsBadge(label: label, color: color);
  }
}
