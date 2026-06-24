import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';
import '../widgets/example_audio_button.dart';
import '../widgets/hold_hint_banner.dart';

enum _WordStatus { pending, active, correct, incorrect }

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with TickerProviderStateMixin {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _recordingPath;
  int _recordingSeconds = 0;
  Timer? _timer;
  late AnimationController _pulseController;

  bool _initialized = false;
  late Map<String, dynamic> _lesson;
  late int _jilid;
  late Color _color;

  List<String> _tokens = [];
  List<_WordStatus> _tokenStatus = [];
  List<List<String>> _arabicLines = [];
  int _currentTokenIndex = 0;
  bool _isEvaluatingWord = false;
  bool _allDone = false;
  String _lastTranscript = "";
  String _lastExpected = "";
  bool _lastMatched = true;

  // Teks yang ditampilkan sebagai hasil: bila benar, tampilkan huruf yang
  // diharapkan (yang benar) — bukan transkrip top-1 yang bisa berbeda saat
  // mode Top-3 atau toleransi HA↔HHA. Bila salah, tampilkan apa yang terdengar.
  String get _heardDisplay =>
      (_lastMatched && _lastExpected.isNotEmpty) ? _lastExpected : _lastTranscript;
  bool _showResultActions = false;

  // Mode penilaian dari halaman Profil: 'conventional' (top-1) atau 'top3'.
  String _matchMode = 'conventional';

  // Skor diturunkan langsung dari status tiap kata supaya rekam-ulang atau
  // loncat antar kata tidak menyebabkan salah hitung.
  int get _correctCount =>
      _tokenStatus.where((s) => s == _WordStatus.correct).length;
  int get _evaluatedCount => _tokenStatus
      .where((s) => s == _WordStatus.correct || s == _WordStatus.incorrect)
      .length;
  bool get _allEvaluated =>
      _tokens.isNotEmpty && !_tokenStatus.contains(_WordStatus.pending);

  // Contoh bacaan ahli (opsional). Aktif bila backend menyertakan `audio_url`
  // pada data lesson; jika tidak ada, tombol contoh tidak ditampilkan.
  String? get _lessonAudioUrl {
    final v = _lesson['audio_url'];
    return (v is String && v.isNotEmpty) ? v : null;
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _loadMatchMode();
  }

  Future<void> _loadMatchMode() async {
    final prefs = await SharedPreferences.getInstance();
    final top3 = prefs.getBool('match_top3') ?? false;
    if (mounted) {
      setState(() => _matchMode = top3 ? 'top3' : 'conventional');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _jilid = args['jilid'] as int;
      _lesson = args['lesson'] as Map<String, dynamic>;
      _color = args['color'] as Color;
      _initTokens(_lesson['transliteration'] as String, _lesson['arabic'] as String);
      _initialized = true;
    }
  }

  List<List<String>> _parseIntoLines(String text) {
    final result = <List<String>>[];
    for (final line in text.replaceAll('=', '  ').split(RegExp(r'\r?\n'))) {
      if (line.trim().isEmpty) continue;
      final lineGroups = line
          .split(RegExp(r'  +'))
          .map((g) => g.trim())
          .where((g) => g.isNotEmpty)
          .toList();
      if (lineGroups.isNotEmpty) result.add(lineGroups);
    }
    return result;
  }

  void _initTokens(String transliteration, String arabic) {
    final transLines = _parseIntoLines(transliteration.toUpperCase());
    final groups = <String>[];
    for (final line in transLines) {
      // Reverse each line of transliteration so it matches the RTL
      // order of the Arabic text in the UI
      for (final g in line.reversed) {
        if (RegExp(r"^[A-Z' ]+$").hasMatch(g)) groups.add(g);
      }
    }

    _arabicLines = _parseIntoLines(arabic);
    _tokens = groups;
    _tokenStatus = List.filled(groups.length, _WordStatus.pending);
    if (groups.isNotEmpty) _tokenStatus[0] = _WordStatus.active;
    _allDone = groups.isEmpty;
  }

  void _resetLesson() {
    if (_isRecording) {
      _recorder.stop();
      _timer?.cancel();
    }
    setState(() {
      _isRecording = false;
      _recordingPath = null;
      _recordingSeconds = 0;
      _currentTokenIndex = 0;
      _lastTranscript = "";
      _lastExpected = "";
      _lastMatched = true;
      _isEvaluatingWord = false;
      _showResultActions = false;
      _allDone = false;
      _tokenStatus = List.filled(_tokens.length, _WordStatus.pending);
      if (_tokens.isNotEmpty) _tokenStatus[0] = _WordStatus.active;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (_allDone || _isEvaluatingWord) return;
    if (await _recorder.hasPermission()) {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/tilawati_word_${DateTime.now().millisecondsSinceEpoch}.wav';
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
        _showResultActions = false;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() => _recordingSeconds++);
      });
    }
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      if (path != null) _recordingPath = path;
    });
    await _evaluateCurrentWord();
  }

  Future<void> _evaluateCurrentWord() async {
    if (_recordingPath == null || _currentTokenIndex >= _tokens.length) return;
    final expectedWord = _tokens[_currentTokenIndex];
    setState(() => _isEvaluatingWord = true);

    bool matched = false;
    String transcript = "";
    try {
      final response = await ApiService.postMultipart(
        ApiConfig.submitWord,
        fields: {'expected_word': expectedWord, 'match_mode': _matchMode},
        filePath: _recordingPath!,
        fileField: 'audio',
        timeout: ApiService.wordEvalTimeout,
      );
      matched = response['matched'] as bool? ?? false;
      transcript = response['asr_transcript'] as String? ?? "";
    } catch (_) {
      // Network error / timeout → count as incorrect and continue
      transcript = "Error/Timeout";
    }

    setState(() {
      _tokenStatus[_currentTokenIndex] = matched ? _WordStatus.correct : _WordStatus.incorrect;
      _lastTranscript = transcript;
      _lastExpected = expectedWord;
      _lastMatched = matched;
      _isEvaluatingWord = false;
      _recordingPath = null;
      _recordingSeconds = 0;
      if (_allEvaluated) {
        // Semua kata sudah dinilai → langsung tampilkan ringkasan skor.
        _showResultActions = false;
        _allDone = true;
        _saveLessonResult();
      } else {
        _showResultActions = true;
      }
    });
  }

  void _selectWord(int idx) {
    if (_isRecording || _isEvaluatingWord || _allDone) return;
    if (idx < 0 || idx >= _tokens.length) return;
    if (idx == _currentTokenIndex && !_showResultActions) return;
    setState(() {
      // Kembalikan kata aktif lama ke pending jika belum sempat dinilai.
      if (_tokenStatus[_currentTokenIndex] == _WordStatus.active) {
        _tokenStatus[_currentTokenIndex] = _WordStatus.pending;
      }
      _currentTokenIndex = idx;
      _tokenStatus[idx] = _WordStatus.active;
      _showResultActions = false;
      _lastTranscript = "";
      _lastExpected = "";
      _lastMatched = true;
      _recordingPath = null;
      _recordingSeconds = 0;
    });
  }

  void _advanceToNextWord() {
    // Cari kata pending berikutnya, mulai dari setelah kata sekarang lalu
    // melingkar ke awal jika perlu.
    int? nextPending;
    for (int step = 1; step <= _tokens.length; step++) {
      final idx = (_currentTokenIndex + step) % _tokens.length;
      if (_tokenStatus[idx] == _WordStatus.pending) {
        nextPending = idx;
        break;
      }
    }
    setState(() {
      _showResultActions = false;
      _lastTranscript = "";
      _lastExpected = "";
      _lastMatched = true;
      if (nextPending == null) {
        // Tidak ada kata pending tersisa → selesai.
        _allDone = true;
        _saveLessonResult();
      } else {
        _currentTokenIndex = nextPending;
        _tokenStatus[nextPending] = _WordStatus.active;
      }
    });
  }

  void _retryCurrentWord() {
    if (_currentTokenIndex >= _tokens.length) return;
    setState(() {
      _showResultActions = false;
      _lastTranscript = "";
      _lastExpected = "";
      _lastMatched = true;
      _tokenStatus[_currentTokenIndex] = _WordStatus.active;
    });
  }

  Future<void> _saveLessonResult() async {
    try {
      await ApiService.postForm(
        ApiConfig.submitLessonResult,
        fields: {
          'jilid': '$_jilid',
          'lesson_number': '${_lesson['number'] as int}',
          'correct_count': '$_correctCount',
          'total_count': '${_tokens.length}',
        },
      );
    } catch (_) {
      // Silent fail — progress update is non-critical for lesson UX
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }



  Widget _buildArabicDisplay() {
    int groupIndex = 0;
    return Column(
      children: _arabicLines.map((lineGroups) {
        final rowChildren = <Widget>[];
        for (int i = 0; i < lineGroups.length; i++) {
          if (i > 0) rowChildren.add(const SizedBox(width: 16));
          final idx = groupIndex++;
          final status = idx < _tokenStatus.length ? _tokenStatus[idx] : _WordStatus.pending;
          Color textColor;
          switch (status) {
            case _WordStatus.active:
              textColor = Colors.green.shade700;
              break;
            case _WordStatus.correct:
              textColor = Colors.green.shade500;
              break;
            case _WordStatus.incorrect:
              textColor = Colors.red.shade600;
              break;
            case _WordStatus.pending:
              textColor = context.textPrimary;
              break;
          }
          final textWidget = Text(
            lineGroups[i],
            style: GoogleFonts.amiri(
              fontSize: 36,
              height: 2,
              color: textColor,
              decoration: TextDecoration.none,
            ),
          );
          final displayWidget = status == _WordStatus.active
              ? Container(
                  padding: const EdgeInsets.only(bottom: 2),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.green.shade700,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: textWidget,
                )
              : textWidget;
          // Tiap kata bisa diketuk untuk dijadikan kata aktif (tap-to-jump),
          // kecuali saat sedang merekam / mengevaluasi.
          final tappable = !_isRecording && !_isEvaluatingWord && !_allDone;
          rowChildren.add(
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: tappable ? () => _selectWord(idx) : null,
              child: displayWidget,
            ),
          );
        }
        return FittedBox(
          fit: BoxFit.scaleDown,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: rowChildren,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScoreSummary() {
    final total = _tokens.length;
    final score = total == 0 ? 0.0 : (_correctCount / total * 100);
    final grade = score >= 85
        ? 'Mumtaz'
        : score >= 70
            ? 'Jayyid Jiddan'
            : score >= 55
                ? 'Jayyid'
                : 'Maqbul';
    final gradeColor = score >= 85
        ? Colors.green
        : score >= 70
            ? Colors.blue
            : score >= 55
                ? Colors.orange
                : Colors.red;

    return Container(
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
            'Latihan Selesai!',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$_correctCount',
                style: GoogleFonts.poppins(
                  fontSize: 52,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                ' / $total',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
          Text(
            'kata benar',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: gradeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              '$grade — ${score.toStringAsFixed(0)}%',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: gradeColor,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetLesson,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text('Ulangi', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_rounded),
                  label: Text('Selesai', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultActions() {
    final matchColor = _lastMatched ? Colors.green : Colors.red;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: matchColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _lastMatched ? 'Bacaan benar' : 'Bacaan belum tepat',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: matchColor.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sistem mendengar: $_heardDisplay',
                softWrap: true,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: matchColor.shade700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _retryCurrentWord,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Ulangi'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error.withOpacity(0.5)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _advanceToNextWord,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Lanjut'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: context.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingSection() {
    return Container(
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
          if (!_isRecording && !_isEvaluatingWord) const HoldHintBanner(),
          if (_lessonAudioUrl != null &&
              !_isRecording &&
              !_isEvaluatingWord &&
              !_showResultActions) ...[
            ExampleAudioButton(
              url: _lessonAudioUrl,
              color: _color,
              label: 'Dengar contoh',
            ),
            const SizedBox(height: 16),
          ],
          Text(
            _isEvaluatingWord
                ? 'Mengevaluasi...'
                : _isRecording
                    ? 'Sedang merekam... lepas untuk berhenti'
                    : 'Tahan tombol & ucapkan kata yang disorot hijau',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: context.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          if (_isEvaluatingWord)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: CircularProgressIndicator(),
            )
          else if (_showResultActions)
            _buildResultActions()
          else
            Column(
              children: [
                Listener(
                  onPointerDown: (_) {
                    if (!_isRecording) _startRecording();
                  },
                  onPointerUp: (_) {
                    if (_isRecording) _stopRecording();
                  },
                  onPointerCancel: (_) {
                    if (_isRecording) _stopRecording();
                  },
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final scale =
                          _isRecording ? 1.0 + (_pulseController.value * 0.08) : 1.0;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isRecording
                                  ? [AppColors.error, const Color(0xFFFF5252)]
                                  : [_color, _color.withOpacity(0.8)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_isRecording ? AppColors.error : _color)
                                    .withOpacity(0.3),
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
                if (_lastTranscript.isNotEmpty && !_isRecording && _currentTokenIndex > 0) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _lastMatched ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Sistem mendengar: $_heardDisplay',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _lastMatched ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          if (_isRecording) ...[
            const SizedBox(height: 14),
            Text(
              _formatDuration(_recordingSeconds),
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w300,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'REC',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Jilid $_jilid',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        actions: [
          if (_tokens.isNotEmpty && !_allDone)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Center(
                child: Text(
                  '$_evaluatedCount/${_tokens.length}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: context.textSecondary,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _resetLesson,
            tooltip: 'Ulangi dari awal',
          ),
        ],
        // Progress bar tipis: berapa kata sudah dinilai
        bottom: _tokens.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(3),
                child: LinearProgressIndicator(
                  value: _evaluatedCount / _tokens.length,
                  minHeight: 3,
                  backgroundColor: _color.withOpacity(0.12),
                  valueColor: AlwaysStoppedAnimation<Color>(_color),
                ),
              ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _lesson['title'] as String,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _lesson['desc'] as String,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: context.textSecondary,
              ),
            ),
            const SizedBox(height: 12),

            // Legenda warna kata
            Wrap(
              spacing: 14,
              runSpacing: 4,
              children: [
                _legendItem(Colors.green.shade700, 'Giliran Anda'),
                _legendItem(Colors.green.shade500, 'Benar'),
                _legendItem(Colors.red.shade600, 'Perlu diulang'),
                _legendItem(context.textPrimary, 'Belum'),
              ],
            ),
            const SizedBox(height: 16),

            // Arabic Text Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _color.withOpacity(0.05),
                    _color.withOpacity(0.02),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _color.withOpacity(0.15)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Teks Arab',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: _color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildArabicDisplay(),
                ],
              ),
            ),
            const SizedBox(height: 32),

            if (_allDone) _buildScoreSummary() else _buildRecordingSection(),

            const SizedBox(height: 24),

            if (!_allDone)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.info.withOpacity(0.2)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline_rounded,
                        color: AppColors.info, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tips: Tekan mikrofon, ucapkan kata Arab yang disorot hijau dengan jelas, lalu tekan stop. Sistem mengevaluasi otomatis dan lanjut ke kata berikutnya.',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.info,
                          height: 1.5,
                        ),
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
}
