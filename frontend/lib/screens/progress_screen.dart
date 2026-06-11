import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/progress_provider.dart';
import '../widgets/achievement_grid.dart';
import '../widgets/error_state.dart';
import '../widgets/skeleton_loading.dart';

class ProgressScreen extends StatefulWidget {
  final bool showBackButton;
  const ProgressScreen({super.key, this.showBackButton = true});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressProvider>().fetchDashboard();
    });
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final day = dt.day.toString().padLeft(2, '0');
      final month = dt.month.toString().padLeft(2, '0');
      final year = dt.year;
      return '$day/$month/$year';
    } catch (_) {
      return isoDate;
    }
  }

  Color _gradeColor(double score) {
    if (score >= 85) return Colors.green;
    if (score >= 70) return Colors.blue;
    if (score >= 55) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.showBackButton,
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          'Progres Saya',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => context.read<ProgressProvider>().fetchDashboard(),
            tooltip: 'Perbarui',
          ),
        ],
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const ProgressSkeleton();
          }
          if (provider.error != null) {
            return ErrorStateWidget(
              message: provider.error!,
              onRetry: () => provider.fetchDashboard(),
            );
          }
          return RefreshIndicator(
            onRefresh: () => provider.fetchDashboard(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (provider.isOffline) const OfflineBanner(),
                  // Stats Cards
                  Row(
                    children: [
                      _buildStatCard(
                        '${provider.totalEvaluations}',
                        'Total Latihan',
                        Icons.fitness_center_rounded,
                        AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      _buildStatCard(
                        provider.averageScore.toStringAsFixed(1),
                        'Rata-rata Skor',
                        Icons.star_rounded,
                        const Color(0xFFF57C00),
                      ),
                    ],
                  ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.08),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildStatCard(
                        provider.bestScore.toStringAsFixed(0),
                        'Skor Tertinggi',
                        Icons.emoji_events_rounded,
                        const Color(0xFF7B1FA2),
                      ),
                      const SizedBox(width: 10),
                      _buildStatCard(
                        '${provider.streakDays}',
                        'Hari Streak',
                        Icons.local_fire_department_rounded,
                        const Color(0xFFD32F2F),
                      ),
                    ],
                  ).animate().fadeIn(duration: 250.ms, delay: 80.ms).slideY(begin: 0.08),
                  // Score trend chart (tampil jika ada >= 2 evaluasi)
                  ..._buildScoreTrendSection(provider),
                  const SizedBox(height: 28),

                  // Achievements
                  Text(
                    'Pencapaian',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AchievementGrid(
                    achievements: deriveAchievements(
                      totalEvaluations: provider.totalEvaluations,
                      bestScore: provider.bestScore,
                      streakDays: provider.streakDays,
                      jilid1Completed: provider.completedLessons(1),
                      jilid1Total: provider.totalLessons(1),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Jilid Progress
                  Text(
                    'Progres per Jilid',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ...List.generate(6, (index) {
                    final jilid = index + 1;
                    final titles = [
                      'Huruf Hijaiyah',
                      'Huruf Sambung',
                      'Mad & Sukun',
                      'Hukum Nun & Mim',
                      'Waqaf & Ibtida',
                      'Gharib & Musykilat',
                    ];
                    final completed = provider.completedLessons(jilid);
                    final total = provider.totalLessons(jilid);
                    final fallbackTotal = [44, 4, 3, 3, 2, 2][index];
                    return _buildJilidProgress(
                      jilid: jilid,
                      title: titles[index],
                      completed: completed,
                      total: total > 0 ? total : fallbackTotal,
                      color: AppColors.jilidColors[index],
                    );
                  }),
                  const SizedBox(height: 28),

                  // Recent Activity
                  Text(
                    'Aktivitas Terbaru',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (provider.recentEvaluations.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: context.cardBg,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.history_rounded,
                              size: 48, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          Text(
                            'Belum ada aktivitas',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: context.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mulai berlatih untuk melihat riwayat',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: context.textLight,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ...provider.recentEvaluations.map((e) {
                      final score = (e['overall_score'] as num?)?.toDouble() ?? 0;
                      final jilid = (e['jilid'] as num?)?.toInt() ?? 1;
                      final title = e['lesson_title'] as String? ?? '';
                      final date = e['created_at'] as String? ?? '';
                      final gradeColor = _gradeColor(score);
                      return GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/riwayat'),
                        child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: context.cardBg,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.jilidColors[
                                        (jilid - 1).clamp(0, 5)]
                                    .withOpacity(0.12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'J$jilid',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.jilidColors[
                                        (jilid - 1).clamp(0, 5)],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: context.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    _formatDate(date),
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      color: context.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              score.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: gradeColor,
                              ),
                            ),
                          ],
                        ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Section "Tren Skor" — grafik garis skor evaluasi terbaru.
  /// Kosong jika data kurang dari 2 titik.
  List<Widget> _buildScoreTrendSection(ProgressProvider provider) {
    final evals = provider.recentEvaluations;
    if (evals.length < 2) return [];

    // API mengembalikan evaluasi terbaru lebih dulu → balik agar kronologis.
    final scores = evals.reversed
        .map((e) =>
            ((e['overall_score'] as num?)?.toDouble() ?? 0).clamp(0.0, 100.0))
        .toList();
    final spots = [
      for (var i = 0; i < scores.length; i++)
        FlSpot(i.toDouble(), scores[i]),
    ];

    return [
      const SizedBox(height: 28),
      Text(
        'Tren Skor',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: context.textPrimary,
        ),
      ),
      const SizedBox(height: 14),
      Container(
        padding: const EdgeInsets.fromLTRB(8, 20, 20, 12),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SizedBox(
          height: 180,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 100,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 25,
                getDrawingHorizontalLine: (_) => FlLine(
                  color: Theme.of(context).dividerColor.withOpacity(0.15),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 25,
                    reservedSize: 34,
                    getTitlesWidget: (value, _) => Text(
                      value.toInt().toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: context.textLight,
                      ),
                    ),
                  ),
                ),
                bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) => touchedSpots
                      .map((s) => LineTooltipItem(
                            s.y.toStringAsFixed(1),
                            GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ))
                      .toList(),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  preventCurveOverShooting: true,
                  color: AppColors.primaryLight,
                  barWidth: 3,
                  dotData: const FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryLight.withOpacity(0.25),
                        AppColors.primaryLight.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _buildStatCard(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJilidProgress({
    required int jilid,
    required String title,
    required int completed,
    required int total,
    required Color color,
  }) {
    final percent = total > 0 ? (completed / total).clamp(0.0, 1.0) : 0.0;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    '$jilid',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Jilid $jilid - $title',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.textPrimary,
                  ),
                ),
              ),
              Text(
                '$completed/$total',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8.0,
            percent: percent,
            backgroundColor: Colors.grey.shade200,
            progressColor: color,
            barRadius: const Radius.circular(4),
            animation: true,
            animationDuration: 800,
          ),
        ],
      ),
    );
  }
}
