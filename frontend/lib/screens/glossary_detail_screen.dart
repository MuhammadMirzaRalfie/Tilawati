import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../config/theme.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';
import '../widgets/example_audio_button.dart';
import '../widgets/hold_hint_banner.dart';

class GlossaryDetailScreen extends StatefulWidget {
  const GlossaryDetailScreen({super.key});

  @override
  State<GlossaryDetailScreen> createState() => _GlossaryDetailScreenState();
}

class _GlossaryDetailScreenState extends State<GlossaryDetailScreen>
    with SingleTickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isSubmitting = false;
  String? _recordingPath;
  int _recordingSeconds = 0;
  Timer? _timer;
  Map<String, dynamic>? _result;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) return;
    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/glossary_${DateTime.now().millisecondsSinceEpoch}.wav';
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: path,
    );
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
      _recordingPath = path;
      _result = null;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _recordingSeconds++);
    });
  }

  Future<void> _stopAndSubmit(String label) async {
    _timer?.cancel();
    await _recorder.stop();
    setState(() {
      _isRecording = false;
      _isSubmitting = true;
    });

    try {
      final response = await ApiService.postMultipart(
        ApiConfig.glossaryClassify,
        fields: {'expected_label': label},
        filePath: _recordingPath!,
        fileField: 'audio',
        timeout: const Duration(seconds: 70),
      );
      setState(() {
        _result = response;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengevaluasi: $e')),
        );
      }
    }
  }

  void _reset() {
    setState(() {
      _result = null;
      _recordingPath = null;
      _recordingSeconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final letter = args['letter'] as Map<String, dynamic>;
    final color = args['color'] as Color;
    final label = letter['label'] as String;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Latihan Huruf',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Huruf card
            Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.08), color.withOpacity(0.03)],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Text(
                    letter['arabic'] as String,
                    style: GoogleFonts.amiri(
                      fontSize: 80,
                      color: color,
                      height: 1.2,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: color,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.place_rounded, size: 14, color: color.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          letter['makhraj'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: context.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Contoh bacaan ahli (audio). Graceful bila file belum di-bundle.
            Center(
              child: ExampleAudioButton(
                assetPath: 'assets/audio/glossary/${label.toLowerCase()}.wav',
                color: color,
                label: 'Dengar contoh',
              ),
            ),
            const SizedBox(height: 24),

            // Result card
            if (_result != null) ...[
              _ResultCard(result: _result!, color: color),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Coba Lagi'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.grid_view_rounded),
                      label: const Text('Huruf Lain'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const HoldHintBanner(),
              // Recording section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _isRecording
                          ? 'Sedang Merekam...'
                          : _isSubmitting
                              ? 'Mengevaluasi...'
                              : 'Ucapkan huruf di atas',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _isRecording
                          ? 'Ucapkan sekali dengan jelas'
                          : _isSubmitting
                              ? 'Mohon tunggu, hingga 1 menit jika pertama kali'
                              : 'Tahan tombol mikrofon & ucapkan',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    if (_isSubmitting)
                      const CircularProgressIndicator()
                    else
                      Listener(
                        onPointerDown: (_) {
                          if (!_isRecording) _startRecording();
                        },
                        onPointerUp: (_) {
                          if (_isRecording) _stopAndSubmit(label);
                        },
                        onPointerCancel: (_) {
                          if (_isRecording) _stopAndSubmit(label);
                        },
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final scale = _isRecording
                                ? 1.0 + _pulseController.value * 0.08
                                : 1.0;
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: _isRecording
                                        ? [AppColors.error, const Color(0xFFFF5252)]
                                        : [color, color.withOpacity(0.8)],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: (_isRecording ? AppColors.error : color)
                                          .withOpacity(0.35),
                                      blurRadius: 20,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.mic_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    if (_isRecording) ...[
                      const SizedBox(height: 14),
                      Text(
                        '${_recordingSeconds}s',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Lepas tombol setelah selesai',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: context.textLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final Map<String, dynamic> result;
  final Color color;

  const _ResultCard({required this.result, required this.color});

  @override
  Widget build(BuildContext context) {
    final isCorrect = result['is_correct'] as bool;
    final confidencePct = (result['confidence_pct'] as num).toDouble();
    final feedback = result['feedback'] as Map<String, dynamic>;
    final top3 = result['top3'] as List;

    final statusColor = isCorrect
        ? (confidencePct >= 80 ? AppColors.scoreExcellent : AppColors.scoreGood)
        : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: statusColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status icon + message
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? '✅ Benar!' : '❌ Kurang Tepat',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      '${confidencePct.toStringAsFixed(1)}% keyakinan model',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Feedback message
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.06),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              feedback['message'] as String,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: context.textPrimary,
                height: 1.5,
              ),
            ),
          ),

          if (feedback['tip'] != null) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline_rounded,
                    size: 14, color: AppColors.secondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    feedback['tip'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: context.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),
          Text(
            'Top 3 Prediksi',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...top3.map((item) {
            final pct = ((item['confidence'] as num) * 100);
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: Text(
                      item['label'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: color,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (item['confidence'] as num).toDouble(),
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 8,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${pct.toStringAsFixed(1)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
