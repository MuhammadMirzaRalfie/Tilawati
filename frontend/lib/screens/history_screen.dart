import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/evaluation_provider.dart';
import '../models/evaluation_model.dart';
import '../widgets/error_state.dart';
import '../widgets/skeleton_loading.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EvaluationProvider>().fetchHistory();
    });
  }

  String _formatDate(DateTime dt) {
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day/$month/$year • $hour:$minute';
  }

  Color _gradeColor(String grade) {
    switch (grade) {
      case 'Mumtaz':       return Colors.green;
      case 'Jayyid Jiddan': return Colors.blue;
      case 'Jayyid':       return Colors.orange;
      default:             return Colors.red;
    }
  }

  Color _jilidColor(int jilid) {
    const colors = [
      Color(0xFF1B5E20),
      Color(0xFF0D47A1),
      Color(0xFF4A148C),
      Color(0xFF880E4F),
      Color(0xFFE65100),
      Color(0xFF004D40),
    ];
    return colors[(jilid - 1).clamp(0, colors.length - 1)];
  }

  Widget _buildHistoryItem(EvaluationModel item) {
    final gradeColor = _gradeColor(item.grade);
    final jilidColor = _jilidColor(item.jilid);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Jilid badge
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: jilidColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'J${item.jilid}',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: jilidColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Lesson info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.lessonTitle,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(item.createdAt),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: context.textLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Score + grade
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.overallScore.toStringAsFixed(1),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: gradeColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: gradeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  item.grade,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: gradeColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
          'Riwayat Evaluasi',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Consumer<EvaluationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const HistoryListSkeleton();
          }

          if (provider.error != null && provider.history.isEmpty) {
            return ErrorStateWidget(
              message: provider.error!,
              onRetry: () => provider.fetchHistory(),
            );
          }

          if (provider.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history_rounded, size: 64,
                      color: context.textLight.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat evaluasi',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: context.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai latihan untuk melihat hasilnya di sini',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: context.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchHistory(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: provider.history.length,
              itemBuilder: (context, index) =>
                  _buildHistoryItem(provider.history[index]),
            ),
          );
        },
      ),
    );
  }
}
