import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../models/evaluation_model.dart';
import '../providers/evaluation_provider.dart';
import '../widgets/confetti_celebration.dart';

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
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 0.0, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _submitEvaluation());
  }

  Future<void> _submitEvaluation() async {
    if (_submitted) return;
    _submitted = true;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final jilid = args['jilid'] as int;
    final lesson = args['lesson'] as Map<String, dynamic>;
    final audioPath = args['audioPath'] as String?;
    final lessonNumber =
        (lesson['number'] ?? lesson['lesson_number'] ?? 1) as int;

    if (audioPath == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File audio tidak ditemukan.')),
        );
      }
      return;
    }

    final provider = context.read<EvaluationProvider>();
    final success = await provider.submitEvaluation(
      jilid: jilid,
      lessonNumber: lessonNumber,
      audioPath: audioPath,
    );

    if (!mounted) return;

    if (success && provider.currentEvaluation != null) {
      final score = provider.currentEvaluation!.overallScore;
      _scoreAnimation = Tween<double>(begin: 0.0, end: score / 100).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
      );
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) _animController.forward();
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) setState(() => _showDetails = true);
    }
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
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final color = args['color'] as Color;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () =>
              Navigator.popUntil(context, (route) => route.isFirst),
        ),
        title: Text(
          'Hasil Evaluasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<EvaluationProvider>(
        builder: (context, provider, _) {
          if (provider.isSubmitting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Mengevaluasi bacaan...'),
                ],
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(
                      'Evaluasi gagal',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.error!,
                      style: GoogleFonts.poppins(color: context.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          final eval = provider.currentEvaluation;
          if (eval == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              _buildResult(eval, color),
              // Perayaan sekali jalan saat skor Mumtaz.
              if (_showDetails && eval.overallScore >= 85)
                const Positioned.fill(child: ConfettiCelebration()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResult(EvaluationModel eval, Color color) {
    return SingleChildScrollView(
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
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
                progressColor: _getScoreColor(eval.overallScore),
                backgroundColor: Colors.grey.shade200,
                circularStrokeCap: CircularStrokeCap.round,
                animation: false,
              );
            },
          ),
          const SizedBox(height: 16),

          // Grade
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color:
                  _getScoreColor(eval.overallScore).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getScoreColor(eval.overallScore).withOpacity(0.3),
              ),
            ),
            child: Text(
              eval.grade,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getScoreColor(eval.overallScore),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            eval.gradeMessage,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: context.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Detail Scores
          AnimatedOpacity(
            opacity: _showDetails ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: AnimatedSlide(
              offset:
                  _showDetails ? Offset.zero : const Offset(0, 0.1),
              duration: const Duration(milliseconds: 500),
              child: Column(
                children: [
                  // ASR Transcript Card
                  if (eval.asrTranscript != null) ...[
                    _buildAsrCard(eval),
                    const SizedBox(height: 16),
                  ],

                  // Score breakdown
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.cardBg,
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
                            color: context.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildScoreRow(
                          'Makharijul Huruf',
                          eval.makharijulHurufScore,
                          Icons.record_voice_over_rounded,
                        ),
                        const SizedBox(height: 12),
                        _buildScoreRow(
                          'Tajwid',
                          eval.tajwidScore,
                          Icons.auto_stories_rounded,
                        ),
                        const SizedBox(height: 12),
                        _buildScoreRow(
                          'Kelancaran',
                          eval.kelancaranScore,
                          Icons.speed_rounded,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Feedback
                  if (eval.tips.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: context.cardBg,
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
                                  color: context.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          ...eval.tips.map(
                            (tip) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
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
                                        color: context.textSecondary,
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
                          onPressed: () => Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          ),
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
    );
  }

  Widget _buildAsrCard(EvaluationModel eval) {
    final transcript = eval.asrTranscript!.toLowerCase();
    final expected = eval.asrExpected;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
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
              const Icon(Icons.hearing_rounded,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Transkripsi ASR',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTranscriptRow('Model mendengar', '"$transcript"',
              AppColors.info),
          if (expected != null) ...[
            const SizedBox(height: 8),
            _buildTranscriptRow('Yang diharapkan', '"${expected.toUpperCase()}"',
                context.textSecondary),
          ],
        ],
      ),
    );
  }

  Widget _buildTranscriptRow(String label, String value, Color valueColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 118,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: context.textSecondary,
            ),
          ),
        ),
        Text(': ', style: TextStyle(color: context.textLight)),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ),
      ],
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
                  color: context.textPrimary,
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
