import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../config/theme.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';

class FreeInferenceScreen extends StatefulWidget {
  const FreeInferenceScreen({super.key});

  @override
  State<FreeInferenceScreen> createState() => _FreeInferenceScreenState();
}

class _FreeInferenceScreenState extends State<FreeInferenceScreen>
    with TickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  bool _isProcessing = false;
  String? _recordingPath;
  int _recordingSeconds = 0;
  Timer? _timer;

  // Hasil inferensi
  List<String> _words = [];
  String _transcript = '';
  String _source = '';
  bool _hasResult = false;

  // History rekaman
  final List<_InferenceResult> _history = [];

  late AnimationController _pulseController;
  late AnimationController _waveController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    )..repeat(reverse: true);

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _waveController.dispose();
    _fadeController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_isProcessing) return;
    if (await _recorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/tilawati_free_${DateTime.now().millisecondsSinceEpoch}.wav';
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
        _hasResult = false;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _recordingSeconds++);
      });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin mikrofon diperlukan'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _stopAndTranscribe() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      if (path != null) _recordingPath = path;
      _isProcessing = true;
    });

    await _transcribe();
  }

  Future<void> _transcribe() async {
    if (_recordingPath == null) {
      setState(() => _isProcessing = false);
      return;
    }

    try {
      final response = await ApiService.postMultipart(
        ApiConfig.transcribeFree,
        fields: {},
        filePath: _recordingPath!,
        fileField: 'audio',
        timeout: const Duration(seconds: 20),
      );

      final words = (response['words'] as List?)
              ?.map((w) => w.toString())
              .toList() ??
          [];
      final transcript = response['transcript'] as String? ?? '';
      final source = response['source'] as String? ?? '';

      final result = _InferenceResult(
        words: words,
        transcript: transcript,
        source: source,
        duration: _recordingSeconds,
        timestamp: DateTime.now(),
      );

      setState(() {
        _words = words;
        _transcript = transcript;
        _source = source;
        _hasResult = true;
        _isProcessing = false;
        _history.insert(0, result);
        if (_history.length > 10) _history.removeLast();
      });
      _fadeController.forward(from: 0);
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _formatDuration(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Inferensi Bebas',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.history_rounded),
              tooltip: 'Riwayat',
              onPressed: _showHistory,
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildInfoCard(),
              const SizedBox(height: 24),
              _buildRecorderCard(),
              const SizedBox(height: 24),
              if (_isProcessing) _buildProcessingCard(),
              if (_hasResult && !_isProcessing) _buildResultCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D47A1).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.spatial_audio_off_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mode Bebas',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ucapkan huruf atau kata hijaiyah apa saja, model ASR akan mentranskripsi secara langsung.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecorderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Status teks
          Text(
            _isRecording
                ? 'Sedang merekam...'
                : _isProcessing
                    ? 'Memproses...'
                    : 'Tekan mikrofon untuk mulai',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: _isRecording ? AppColors.error : AppColors.textSecondary,
              fontWeight: _isRecording ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),

          // Timer
          Text(
            _formatDuration(_recordingSeconds),
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.w200,
              color: _isRecording ? AppColors.error : AppColors.textLight,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 28),

          // Gelombang suara animasi saat rekam
          if (_isRecording) _buildWaveform(),
          if (_isRecording) const SizedBox(height: 24),

          // Tombol mikrofon
          if (!_isProcessing)
            GestureDetector(
              onTap: _isRecording ? _stopAndTranscribe : _startRecording,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = _isRecording
                      ? 1.0 + (_pulseController.value * 0.08)
                      : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: _isRecording
                              ? [AppColors.error, const Color(0xFFFF5252)]
                              : [
                                  const Color(0xFF0D47A1),
                                  const Color(0xFF1976D2)
                                ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (_isRecording
                                    ? AppColors.error
                                    : const Color(0xFF0D47A1))
                                .withOpacity(0.35),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isRecording
                            ? Icons.stop_rounded
                            : Icons.mic_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            )
          else
            const SizedBox(
              width: 88,
              height: 88,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF1976D2),
                  strokeWidth: 3,
                ),
              ),
            ),

          const SizedBox(height: 16),
          Text(
            _isRecording ? 'Tap untuk berhenti & transkripsi' : 'Tap & bicara',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(11, (i) {
            final phase = (_waveController.value * 2 * 3.14159) +
                (i * 0.5);
            final heightFactor = 0.3 + 0.7 * ((1 + _sin(phase)) / 2);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 4,
              height: 8 + (32 * heightFactor),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.7 + heightFactor * 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }

  double _sin(double x) => (x - x * x * x / 6 + x * x * x * x * x / 120) %
      (2 * 3.14159) < 3.14159
      ? (x % (2 * 3.14159) < 3.14159 ? 1.0 : -1.0) *
          (1 - (((x % 3.14159) / 3.14159) - 0.5).abs() * 2).clamp(0.0, 1.0)
      : -((x % (2 * 3.14159) - 3.14159) / 3.14159 - 0.5).abs() * 2 + 1;

  Widget _buildProcessingCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1976D2).withOpacity(0.15)),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Color(0xFF1976D2),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Model sedang memproses audio...',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D47A1),
                  ),
                ),
                Text(
                  'Wav2Vec2 HPT-D sedang mentranskripsi',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    final bool modelAvailable = _source == 'asr_model';
    final bool isEmpty = _words.isEmpty;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: modelAvailable
                        ? const Color(0xFF1B5E20).withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        modelAvailable
                            ? Icons.check_circle_outline_rounded
                            : Icons.warning_amber_rounded,
                        size: 13,
                        color: modelAvailable
                            ? const Color(0xFF1B5E20)
                            : Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        modelAvailable ? 'ASR HPT-D' : 'Model Tidak Tersedia',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: modelAvailable
                              ? const Color(0xFF1B5E20)
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  '${_words.length} token',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Hasil transkripsi utama
            if (!isEmpty) ...[
              Text(
                'Hasil Transkripsi',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),

              // Token chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _words
                    .map(
                      (w) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  const Color(0xFF0D47A1).withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          w,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Full transcript string
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teks Lengkap',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _transcript,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: const Color(0xFF0D47A1),
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Tidak ada token terdeteksi
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.hearing_disabled_rounded,
                      size: 48,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      modelAvailable
                          ? 'Tidak ada token terdeteksi.\nCoba ucapkan lebih jelas.'
                          : 'Model ASR tidak tersedia.\nDeploy model terlebih dahulu.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Rekam ulang button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _hasResult = false;
                    _words = [];
                    _transcript = '';
                    _recordingSeconds = 0;
                  });
                },
                icon: const Icon(Icons.refresh_rounded),
                label: Text(
                  'Rekam Ulang',
                  style:
                      GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        maxChildSize: 0.85,
        minChildSize: 0.35,
        expand: false,
        builder: (ctx, scrollController) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Riwayat Inferensi',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: _history.length,
                  separatorBuilder: (_, __) => const Divider(height: 16),
                  itemBuilder: (ctx, i) {
                    final item = _history[i];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0D47A1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0D47A1),
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
                                item.transcript.isEmpty
                                    ? '(kosong)'
                                    : item.transcript,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: item.transcript.isEmpty
                                      ? AppColors.textLight
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${item.words.length} token · ${item.duration}s · ${_timeAgo(item.timestamp)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s lalu';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    return '${diff.inHours}j lalu';
  }
}

class _InferenceResult {
  final List<String> words;
  final String transcript;
  final String source;
  final int duration;
  final DateTime timestamp;

  _InferenceResult({
    required this.words,
    required this.transcript,
    required this.source,
    required this.duration,
    required this.timestamp,
  });
}
