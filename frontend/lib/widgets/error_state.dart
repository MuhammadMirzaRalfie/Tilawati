import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

/// Tampilan error reusable: ikon + pesan ramah + tombol "Coba Lagi".
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final IconData? icon;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.icon,
  });

  bool get _isNetworkMessage =>
      message.contains('koneksi') || message.contains('jaringan');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ??
                  (_isNetworkMessage
                      ? Icons.wifi_off_rounded
                      : Icons.error_outline_rounded),
              size: 56,
              color: context.textLight,
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: context.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text('Coba Lagi', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );
  }
}

/// Banner kecil penanda data berasal dari cache (mode offline).
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded,
              size: 18, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Menampilkan data tersimpan — Anda sedang offline',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.warning,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
