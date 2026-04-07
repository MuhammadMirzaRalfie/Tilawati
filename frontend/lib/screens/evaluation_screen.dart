import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../config/theme.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scoreAnimation;
  bool _showDetails = false;

  // Mock evaluation result (would come from API in production)
  late double _overallScore;
  late double _makhrajScore;
  late double _tajwidScore;
  late double _kelancaranScore;
  late String _grade;
  late String _message;
  late List<String> _tips;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Generate mock scores
    _overallScore = 78.5;
    _makhrajScore = 82.3;
    _tajwidScore = 74.1;
    _kelancaranScore = 79.8;
    _grade = 'Jayyid Jiddan (Baik Sekali)';
    _message = 'Bacaan Anda sudah bagus. Terus berlatih untuk kesempurnaan.';
    _tips = [
      'Makhraj huruf sudah cukup baik, terus latih konsistensi pengucapan.',
      'Tajwid sudah baik, perhatikan lagi panjang pendek bacaan.',
      'Kelancaran bacaan sudah baik, pertahankan ritme bacaan.',
    ];

    _scoreAnimation = Tween<double>(begin: 0.0, end: _overallScore / 100)
        .animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 300), () {
      _animController.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showDetails = true);
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _getScoreColor(double score) {
    if (score >= 85) return AppColors.scoreExcellent;
    if (score >= 70) return AppColors.scoreGood;
    if (score >= 55) return AppColors.scoreAverage;
    return AppColors.scorePoor;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final _ = args['lesson'] as Map<String, dynamic>;
    final color = args['color'] as Color;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
        title: Text(
          'Hasil Evaluasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Score Circle
            AnimatedBuilder(
              animation: _scoreAnimation,
              builder: (context, _) {
                final score = _scoreAnimation.value * 100;
                return CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 12.0,
                  percent: _scoreAnimation.value,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        score.toStringAsFixed(1),
                        style: GoogleFonts.poppins(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(score),
                        ),
                      ),
                      Text(
                        'dari 100',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  progressColor: _getScoreColor(score),
                  backgroundColor: Colors.grey.shade200,
                  circularStrokeCap: CircularStrokeCap.round,
                  animation: false,
                );
              },
            ),
            const SizedBox(height: 16),

            // Grade
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: _getScoreColor(_overallScore).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getScoreColor(_overallScore).withOpacity(0.3),
                ),
              ),
              child: Text(
                _grade,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _getScoreColor(_overallScore),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),

            // Detail Scores
            AnimatedOpacity(
              opacity: _showDetails ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: AnimatedSlide(
                offset: _showDetails ? Offset.zero : const Offset(0, 0.1),
                duration: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    // Score breakdown
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Detail Penilaian',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildScoreRow(
                            'Makharijul Huruf',
                            _makhrajScore,
                            Icons.record_voice_over_rounded,
                          ),
                          const SizedBox(height: 12),
                          _buildScoreRow(
                            'Tajwid',
                            _tajwidScore,
                            Icons.auto_stories_rounded,
                          ),
                          const SizedBox(height: 12),
                          _buildScoreRow(
                            'Kelancaran',
                            _kelancaranScore,
                            Icons.speed_rounded,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Feedback
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_rounded,
                                  color: AppColors.secondary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Saran Perbaikan',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ..._tips.map(
                            (tip) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      tip,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                        height: 1.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Coba Lagi'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                            },
                            icon: const Icon(Icons.home_rounded),
                            label: const Text('Beranda'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRow(String label, double score, IconData icon) {
    final scoreColor = _getScoreColor(score);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: scoreColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: scoreColor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: score / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          score.toStringAsFixed(1),
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: scoreColor,
          ),
        ),
      ],
    );
  }
}
