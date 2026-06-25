import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';
import '../../core/theme/shadows.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

enum CrmsToastType { success, info, warning, danger }

/// Top-right toast notification: white card with a colored left border, icon +
/// title (+ optional description). Slides in from the right, auto-dismisses
/// after 4s. Call [CrmsToast.show].
abstract final class CrmsToast {
  static void show(
    BuildContext context, {
    required String title,
    String? description,
    CrmsToastType type = CrmsToastType.success,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastView(
        title: title,
        description: description,
        type: type,
        onDismissed: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _ToastView extends StatefulWidget {
  const _ToastView({
    required this.title,
    required this.description,
    required this.type,
    required this.onDismissed,
  });

  final String title;
  final String? description;
  final CrmsToastType type;
  final VoidCallback onDismissed;

  @override
  State<_ToastView> createState() => _ToastViewState();
}

class _ToastViewState extends State<_ToastView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  )..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () async {
      if (!mounted) return;
      await _c.reverse();
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  (Color, IconData) get _style => switch (widget.type) {
        CrmsToastType.success =>
          (AppColors.successGreen, PhosphorIconsRegular.checkCircle),
        CrmsToastType.info => (AppColors.infoBlue, PhosphorIconsRegular.info),
        CrmsToastType.warning =>
          (AppColors.warningAmber, PhosphorIconsRegular.warning),
        CrmsToastType.danger =>
          (AppColors.dangerRed, PhosphorIconsRegular.xCircle),
      };

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _style;
    final description = widget.description;
    final curved = CurvedAnimation(parent: _c, curve: Curves.easeOut);

    return Positioned(
      top: 56 + AppSpacing.s4,
      right: AppSpacing.s4,
      child: SafeArea(
        child: FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween(begin: const Offset(0.15, 0), end: Offset.zero)
                .animate(curved),
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 320,
                padding: const EdgeInsets.all(AppSpacing.s4),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: AppRadii.brMd,
                  border: Border(left: BorderSide(color: color, width: 4)),
                  boxShadow: AppShadows.popover,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 20, color: color),
                    const SizedBox(width: AppSpacing.s3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title,
                              style: AppType.body.copyWith(
                                  color: AppColors.ink900,
                                  fontWeight: FontWeight.w600)),
                          if (description != null) ...[
                            const SizedBox(height: 2),
                            Text(description,
                                style: AppType.bodySm
                                    .copyWith(color: AppColors.ink500)),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
