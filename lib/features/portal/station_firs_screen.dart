import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../access/access_service.dart';
import 'portal_providers.dart';
import 'portal_shell.dart';

/// All FIRs of the user's admin-assigned police station, pulled from the
/// central server — every user's entries for that station, not just this
/// device's. Read-only: the server scopes a station-role user to exactly
/// their assigned station, so search can never leak another station's data.
class StationFirsScreen extends ConsumerWidget {
  const StationFirsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final station = ref.watch(accessControllerProvider).scope.station;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.policeNavy,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('nav.stationFirs'.tr(),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            if (station != null && station.isNotEmpty)
              Text(station,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.policeKhakiLight)),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => ref.invalidate(portalSearchResultsProvider),
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(PhosphorIconsRegular.arrowsClockwise, size: 18),
            label: Text('common.syncData'.tr(),
                style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: const PortalSearchView(),
    );
  }
}
