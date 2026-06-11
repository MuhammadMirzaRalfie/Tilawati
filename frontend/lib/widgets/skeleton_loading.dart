import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../config/theme.dart';

/// Skeleton loading berkilau (shimmer) — pengganti spinner di layar list/grid.
class _ShimmerWrap extends StatelessWidget {
  final Widget child;
  const _ShimmerWrap({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Shimmer.fromColors(
      baseColor: isDark ? AppColors.darkSurfaceVariant : Colors.grey.shade300,
      highlightColor:
          isDark ? const Color(0xFF3A3A3A) : Colors.grey.shade100,
      child: child,
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height; // null = ikuti constraint parent (mis. tile grid)
  final double radius;
  const _SkeletonBox({this.width, this.height, this.radius = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Skeleton untuk layar Progres: stat cards + bar progres.
class ProgressSkeleton extends StatelessWidget {
  const ProgressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShimmerWrap(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Expanded(child: _SkeletonBox(height: 76, radius: 20)),
                SizedBox(width: 10),
                Expanded(child: _SkeletonBox(height: 76, radius: 20)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Expanded(child: _SkeletonBox(height: 76, radius: 20)),
                SizedBox(width: 10),
                Expanded(child: _SkeletonBox(height: 76, radius: 20)),
              ],
            ),
            const SizedBox(height: 28),
            const _SkeletonBox(width: 160, height: 20, radius: 6),
            const SizedBox(height: 14),
            ...List.generate(
              4,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: _SkeletonBox(height: 86, radius: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton untuk grid glosarium (4 kolom).
class GlossaryGridSkeleton extends StatelessWidget {
  const GlossaryGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShimmerWrap(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: 20,
        itemBuilder: (_, __) => const _SkeletonBox(),
      ),
    );
  }
}

/// Skeleton untuk list riwayat evaluasi.
class HistoryListSkeleton extends StatelessWidget {
  const HistoryListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return _ShimmerWrap(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: _SkeletonBox(height: 96, radius: 18),
        ),
      ),
    );
  }
}
