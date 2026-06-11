import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';

/// Banner petunjuk gesture rekam (tahan untuk merekam) yang tampil **sekali**.
///
/// Setelah perubahan tombol rekam dari tap → hold, banner ini membantu user
/// memahami cara baru. Status "sudah dilihat" disimpan di [SharedPreferences]
/// dengan key [_prefsKey] sehingga banner tidak muncul lagi setelah ditutup.
class HoldHintBanner extends StatefulWidget {
  const HoldHintBanner({super.key});

  static const String _prefsKey = 'hint_hold_record_seen';

  @override
  State<HoldHintBanner> createState() => _HoldHintBannerState();
}

class _HoldHintBannerState extends State<HoldHintBanner> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _checkSeen();
  }

  Future<void> _checkSeen() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool(HoldHintBanner._prefsKey) ?? false;
    if (mounted) setState(() => _visible = !seen);
  }

  Future<void> _dismiss() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(HoldHintBanner._prefsKey, true);
    if (mounted) setState(() => _visible = false);
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.touch_app_rounded, color: AppColors.info, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Tahan tombol lalu ucapkan, lepas untuk berhenti.',
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                color: context.textPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: _dismiss,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Mengerti',
              style: GoogleFonts.poppins(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
