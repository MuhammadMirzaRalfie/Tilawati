import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../data/tilawati_lessons.dart';
import '../providers/evaluation_provider.dart';

class JilidSelectionScreen extends StatefulWidget {
  const JilidSelectionScreen({super.key});

  @override
  State<JilidSelectionScreen> createState() => _JilidSelectionScreenState();
}

class _JilidSelectionScreenState extends State<JilidSelectionScreen> {
  int? _selectedJilid;

  final List<Map<String, dynamic>> _jilids = kJilids;

  @override
  void initState() {
    super.initState();
    // Riwayat dipakai untuk menandai pelajaran yang sudah selesai + skornya.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EvaluationProvider>().fetchHistory(limit: 100);
    });
  }

  /// Skor terbaik per pelajaran pada jilid terpilih: {lessonNumber: bestScore}.
  Map<int, double> _bestScores(List<dynamic> history) {
    final map = <int, double>{};
    for (final e in history) {
      if (e.jilid != _selectedJilid) continue;
      final prev = map[e.lessonNumber];
      if (prev == null || e.overallScore > prev) {
        map[e.lessonNumber] = e.overallScore;
      }
    }
    return map;
  }

  Color _scoreColor(double score) {
    if (score >= 85) return AppColors.scoreExcellent;
    if (score >= 70) return AppColors.scoreGood;
    if (score >= 55) return AppColors.scoreAverage;
    return AppColors.scorePoor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pilih Jilid',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: _selectedJilid == null ? _buildJilidList() : _buildLessonList(),
    );
  }

  Widget _buildJilidList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: _jilids.length,
        itemBuilder: (context, index) {
          final jilid = _jilids[index];
          return _buildJilidCard(jilid)
              .animate()
              .fadeIn(duration: 250.ms, delay: (50 * index).ms)
              .slideY(begin: 0.08, curve: Curves.easeOut);
        },
      ),
    );
  }

  Widget _buildJilidCard(Map<String, dynamic> jilid) {
    final color = jilid['color'] as Color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedJilid = jilid['jilid'] as int;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                jilid['icon'] as IconData,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Jilid ${jilid['jilid']}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                (jilid['description'] as String),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: context.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(jilid['lessons'] as List).length} pelajaran',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonList() {
    final jilid = _jilids.firstWhere((j) => j['jilid'] == _selectedJilid);
    final color = jilid['color'] as Color;
    final lessons = jilid['lessons'] as List;
    final scores = _bestScores(context.watch<EvaluationProvider>().history);

    return Column(
      children: [
        // Back to jilids
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _selectedJilid = null),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 14,
                        color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Semua Jilid',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Jilid header
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Icon(jilid['icon'] as IconData, color: Colors.white, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jilid['title'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${scores.length}/${lessons.length} pelajaran selesai',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Lesson list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index] as Map<String, dynamic>;
              final score = scores[lesson['number'] as int];
              return _buildLessonCard(lesson, color, index, score)
                  .animate()
                  .fadeIn(duration: 250.ms, delay: (40 * (index % 12)).ms)
                  .slideY(begin: 0.08, curve: Curves.easeOut);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonCard(
      Map<String, dynamic> lesson, Color color, int index, double? score) {
    final done = score != null;
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          '/lesson',
          arguments: {
            'jilid': _selectedJilid,
            'lesson': lesson,
            'color': color,
          },
        );
        // Refresh status setelah kembali dari latihan.
        if (mounted) {
          context.read<EvaluationProvider>().fetchHistory(limit: 100);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: done
              ? Border.all(color: AppColors.success.withOpacity(0.35))
              : null,
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
                color: done
                    ? AppColors.success.withOpacity(0.12)
                    : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: done
                    ? const Icon(Icons.check_rounded,
                        color: AppColors.success, size: 24)
                    : Text(
                        '${index + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson['title'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  done
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _scoreColor(score).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Skor ${score.toStringAsFixed(1)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _scoreColor(score),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Belum dikerjakan',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: context.textLight,
                          ),
                        ),
                ],
              ),
            ),
            Icon(
              done
                  ? Icons.replay_circle_filled_rounded
                  : Icons.play_circle_filled_rounded,
              color: done ? AppColors.success : color,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }
}
