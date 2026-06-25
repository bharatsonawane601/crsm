import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';
import '../../core/theme/spacing.dart';

/// A single shimmering placeholder block.
class CrmsSkeletonBox extends StatelessWidget {
  const CrmsSkeletonBox({
    super.key,
    this.width = double.infinity,
    this.height = 14,
    this.radius = AppRadii.sm,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: dark ? AppColors.darkBorder : AppColors.ink100,
      highlightColor: dark ? AppColors.darkCard : AppColors.cardSurface,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.ink100,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// A vertical list of shimmering placeholder rows (title + subtitle).
class CrmsListSkeleton extends StatelessWidget {
  const CrmsListSkeleton({super.key, this.rows = 5, this.padding});

  final int rows;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: padding ?? const EdgeInsets.all(AppSpacing.s4),
      children: [
        for (var i = 0; i < rows; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: AppRadii.brLg,
              ),
              child: const Padding(
                padding: EdgeInsets.all(AppSpacing.s4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CrmsSkeletonBox(width: 180, height: 16),
                    SizedBox(height: 10),
                    CrmsSkeletonBox(width: 100, height: 12),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Skeleton placeholder shaped like the crime records table while it loads.
class CrmsTableSkeleton extends StatelessWidget {
  const CrmsTableSkeleton({super.key, this.rows = 8});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CrmsSkeletonBox(width: 280, height: 28),
          const SizedBox(height: AppSpacing.s4),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: AppRadii.brLg,
              ),
              child: ListView.separated(
                itemCount: rows,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, color: Theme.of(context).dividerColor),
                itemBuilder: (_, _) => const Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.s4, vertical: 18),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: CrmsSkeletonBox(width: 90)),
                      SizedBox(width: 24),
                      Expanded(flex: 2, child: CrmsSkeletonBox(width: 80)),
                      SizedBox(width: 24),
                      Expanded(flex: 3, child: CrmsSkeletonBox(width: 140)),
                      SizedBox(width: 24),
                      Expanded(flex: 3, child: CrmsSkeletonBox(width: 120)),
                      SizedBox(width: 24),
                      SizedBox(width: 96, child: CrmsSkeletonBox(height: 24)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
