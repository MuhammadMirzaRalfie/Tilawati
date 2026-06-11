import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';

class Achievement {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  /// Progres menuju badge (mis. "2/10") — tampil saat masih terkunci.
  final String? progress;

  const Achievement({
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
    this.progress,
  });
}

/// Derivasi badge dari data dashboard yang sudah ada — tanpa backend.
List<Achievement> deriveAchievements({
  required int totalEvaluations,
  required double bestScore,
  required int streakDays,
  required int jilid1Completed,
  required int jilid1Total,
}) {
  return [
    Achievement(
      title: 'Latihan Pertama',
      description: 'Selesaikan 1 evaluasi bacaan',
      icon: Icons.flag_rounded,
      unlocked: totalEvaluations >= 1,
    ),
    Achievement(
      title: '10 Latihan',
      description: 'Selesaikan 10 evaluasi bacaan',
      icon: Icons.fitness_center_rounded,
      unlocked: totalEvaluations >= 10,
      progress: '$totalEvaluations/10',
    ),
    Achievement(
      title: '50 Latihan',
      description: 'Selesaikan 50 evaluasi bacaan',
      icon: Icons.military_tech_rounded,
      unlocked: totalEvaluations >= 50,
      progress: '$totalEvaluations/50',
    ),
    Achievement(
      title: 'Rajin',
      description: 'Berlatih 3 hari berturut-turut',
      icon: Icons.local_fire_department_rounded,
      unlocked: streakDays >= 3,
      progress: '$streakDays/3 hari',
    ),
    Achievement(
      title: 'Konsisten',
      description: 'Berlatih 7 hari berturut-turut',
      icon: Icons.calendar_month_rounded,
      unlocked: streakDays >= 7,
      progress: '$streakDays/7 hari',
    ),
    Achievement(
      title: 'Mumtaz',
      description: 'Raih skor 85 atau lebih',
      icon: Icons.emoji_events_rounded,
      unlocked: bestScore >= 85,
      progress: 'Terbaik ${bestScore.toStringAsFixed(0)}',
    ),
    Achievement(
      title: 'Jilid 1 Tamat',
      description: 'Selesaikan semua pelajaran Jilid 1',
      icon: Icons.menu_book_rounded,
      unlocked: jilid1Total > 0 && jilid1Completed >= jilid1Total,
      progress: '$jilid1Completed/${jilid1Total > 0 ? jilid1Total : 44}',
    ),
  ];
}

class AchievementGrid extends StatelessWidget {
  final List<Achievement> achievements;

  const AchievementGrid({super.key, required this.achievements});

  void _showDetail(BuildContext context, Achievement a) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              a.unlocked ? a.icon : Icons.lock_rounded,
              color: a.unlocked ? AppColors.secondary : ctx.textLight,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                a.title,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        content: Text(
          a.unlocked ? a.description : '${a.description} (terkunci)',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Tutup', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final a = achievements[index];
        final iconColor = a.unlocked ? AppColors.secondary : context.textLight;
        return GestureDetector(
          onTap: () => _showDetail(context, a),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Opacity(
              opacity: a.unlocked ? 1.0 : 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      a.unlocked ? a.icon : Icons.lock_rounded,
                      color: iconColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: context.textPrimary,
                    ),
                  ),
                  if (!a.unlocked && a.progress != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      a.progress!,
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
