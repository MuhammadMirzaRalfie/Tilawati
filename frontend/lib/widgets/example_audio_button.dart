import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

/// Tombol "Dengar contoh bacaan ahli".
///
/// Sumber audio bisa berupa:
/// - [assetPath]: file yang di-bundle di app, mis. `assets/audio/glossary/ba.mp3`
/// - [url]: audio yang di-stream dari server
///
/// Tepat satu di antara keduanya harus diisi. Bila file belum tersedia
/// (mis. asset belum di-bundle), tombol gagal dengan anggun (graceful):
/// menampilkan SnackBar "Contoh bacaan belum tersedia" dan kembali ke idle.
class ExampleAudioButton extends StatefulWidget {
  final String? assetPath;
  final String? url;
  final Color? color;
  final String label;

  const ExampleAudioButton({
    super.key,
    this.assetPath,
    this.url,
    this.color,
    this.label = 'Dengar contoh bacaan',
  }) : assert(assetPath != null || url != null,
            'assetPath atau url harus diisi salah satu');

  @override
  State<ExampleAudioButton> createState() => _ExampleAudioButtonState();
}

enum _AudioState { idle, loading, playing }

class _ExampleAudioButtonState extends State<ExampleAudioButton> {
  final AudioPlayer _player = AudioPlayer();
  _AudioState _state = _AudioState.idle;

  @override
  void initState() {
    super.initState();
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _state = _AudioState.idle);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_state == _AudioState.playing || _state == _AudioState.loading) {
      await _player.stop();
      if (mounted) setState(() => _state = _AudioState.idle);
      return;
    }

    setState(() => _state = _AudioState.loading);
    try {
      // assetPath dari audioplayers tidak menyertakan prefix "assets/".
      final Source source = widget.assetPath != null
          ? AssetSource(widget.assetPath!.replaceFirst('assets/', ''))
          : UrlSource(widget.url!);
      await _player.play(source);
      if (mounted) setState(() => _state = _AudioState.playing);
    } catch (_) {
      if (!mounted) return;
      setState(() => _state = _AudioState.idle);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contoh bacaan belum tersedia'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? AppColors.primary;
    final isPlaying = _state == _AudioState.playing;
    final isLoading = _state == _AudioState.loading;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggle,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: color),
                )
              else
                Icon(
                  isPlaying ? Icons.stop_rounded : Icons.volume_up_rounded,
                  size: 20,
                  color: color,
                ),
              const SizedBox(width: 8),
              Text(
                isPlaying ? 'Hentikan' : widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
