import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';
import '../data/tilawati_lessons.dart';
import '../providers/auth_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/theme_provider.dart';
import '../services/notification_service.dart';
import '../widgets/islamic_pattern.dart';
import 'progress_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Data dashboard dipakai kartu "Lanjutkan Latihan" di Beranda.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProgressProvider>().fetchDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          // Tab "Jilid" tidak punya konten in-place — tap langsung push
          // ke /jilid-selection (lihat onTap BottomNavigationBar di bawah).
          SizedBox.shrink(),
          ProgressScreen(showBackButton: false),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: context.cardBg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 1) {
              // Tab Jilid: langsung ke halaman pilih jilid, jangan ubah _currentIndex
              // supaya saat user kembali (back), tab tetap di Beranda.
              Navigator.pushNamed(context, '/jilid-selection');
              return;
            }
            setState(() => _currentIndex = index);
          },
          items: [
            _navItem(Icons.home_rounded, 'Beranda'),
            _navItem(Icons.menu_book_rounded, 'Jilid'),
            _navItem(Icons.bar_chart_rounded, 'Progres'),
            _navItem(Icons.person_rounded, 'Profil'),
          ],
        ),
      ),
    );
  }

  /// Item bottom nav dengan pill highlight saat aktif.
  BottomNavigationBarItem _navItem(IconData icon, String label) {
    final accent =
        context.isDarkMode ? AppColors.primaryLight : AppColors.primary;
    return BottomNavigationBarItem(
      icon: Icon(icon),
      activeIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon),
      ),
      label: label,
    );
  }
}

// ========== HOME TAB ==========
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final name = user?.name ?? 'Pengguna';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Greeting
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Assalamu\'alaikum,',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: context.textSecondary,
                        ),
                      ),
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'U',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Banner Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, Color(0xFF2E7D32)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Ornamen geometris halus di pojok banner
                    Positioned(
                      right: -35,
                      top: -35,
                      child: IslamicStarOrnament(
                        size: 160,
                        color: Colors.white.withOpacity(0.10),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      bottom: -50,
                      child: IslamicStarOrnament(
                        size: 110,
                        color: Colors.white.withOpacity(0.07),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '📖 Tilawati',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tingkatkan Bacaan\nAl-Qur\'an Anda',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Evaluasi bacaan dengan AI untuk hasil yang lebih baik',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.85),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/jilid-selection');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      'Mulai Latihan',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Lanjutkan latihan dari posisi terakhir
            ..._buildContinueSection(context),
            const SizedBox(height: 28),

            // Quick Menu
            Text(
              'Menu Utama',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildMenuCard(
                  context,
                  icon: Icons.menu_book_rounded,
                  title: 'Latihan',
                  subtitle: 'Pilih jilid',
                  color: AppColors.primary,
                  onTap: () => Navigator.pushNamed(context, '/jilid-selection'),
                ),
                const SizedBox(width: 12),
                _buildMenuCard(
                  context,
                  icon: Icons.bar_chart_rounded,
                  title: 'Progres',
                  subtitle: 'Lihat kemajuan',
                  color: const Color(0xFF1976D2),
                  onTap: () => Navigator.pushNamed(context, '/progress'),
                ),
              ],
            ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.08),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMenuCard(
                  context,
                  icon: Icons.abc_rounded,
                  title: 'Glosarium',
                  subtitle: 'Latihan per huruf',
                  color: const Color(0xFF00695C),
                  onTap: () => Navigator.pushNamed(context, '/glossary'),
                ),
                const SizedBox(width: 12),
                _buildMenuCard(
                  context,
                  icon: Icons.spatial_audio_rounded,
                  title: 'Uji ASR',
                  subtitle: 'Inferensi bebas',
                  color: const Color(0xFF0D47A1),
                  onTap: () => Navigator.pushNamed(context, '/free-inference'),
                ),
              ],
            ).animate().fadeIn(duration: 250.ms, delay: 80.ms).slideY(begin: 0.08),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMenuCard(
                  context,
                  icon: Icons.history_rounded,
                  title: 'Riwayat',
                  subtitle: 'Hasil evaluasi',
                  color: const Color(0xFF7B1FA2),
                  onTap: () => Navigator.pushNamed(context, '/riwayat'),
                ),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()),
              ],
            ).animate().fadeIn(duration: 250.ms, delay: 160.ms).slideY(begin: 0.08),
            const SizedBox(height: 28),

            // Tips Section
            Text(
              'Tips Membaca',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              context,
              '🎯 Konsistensi',
              '''أَحَبُّ الأَعْمَالِ إِلَى اللَّهِ أَدْوَمُهَا وَإِنْ قَلَّ

"Amalan yang paling dicintai oleh Allah adalah amalan yang paling kontinu (konsisten), walaupun sedikit."
(HR. Bukhari dan Muslim).''',
            ),
            _buildTipCard(
              context,
              '🎤 Lingkungan Tenang',
              'Rekam bacaan di tempat tenang untuk hasil evaluasi AI yang lebih akurat.',
            ),
            _buildTipCard(
              context,
              '📝 Perbaiki Bertahap',
              'Fokus memperbaiki satu aspek (makhraj/tajwid) per sesi latihan.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(20),
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
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Kartu "Lanjutkan Latihan": target = pelajaran setelah evaluasi terakhir
  /// (atau pelajaran yang sama jika sudah di akhir jilid). Kosong jika belum
  /// pernah latihan.
  List<Widget> _buildContinueSection(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    if (progress.recentEvaluations.isEmpty) return [];

    final last = progress.recentEvaluations.first;
    final jilidNum = (last['jilid'] as num?)?.toInt() ?? 1;
    final lastLesson = (last['lesson_number'] as num?)?.toInt() ?? 1;

    final jilid = kJilids.firstWhere(
      (j) => j['jilid'] == jilidNum,
      orElse: () => kJilids.first,
    );
    // cast() penting: list literal di kJilids ber-elemen Map<String, Object>,
    // sehingga orElse pada firstWhere butuh tipe E yang konsisten.
    final lessons =
        (jilid['lessons'] as List).cast<Map<String, dynamic>>();
    final next = lessons.firstWhere(
      (l) => l['number'] == lastLesson + 1,
      orElse: () => lessons.firstWhere(
        (l) => l['number'] == lastLesson,
        orElse: () => lessons.first,
      ),
    );
    final color = jilid['color'] as Color;

    final completed = progress.completedLessons(jilidNum);
    final total = progress.totalLessons(jilidNum) > 0
        ? progress.totalLessons(jilidNum)
        : lessons.length;
    final percent = (completed / total).clamp(0.0, 1.0);

    return [
      const SizedBox(height: 16),
      GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/lesson',
            arguments: {'jilid': jilidNum, 'lesson': next, 'color': color},
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.25)),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(Icons.auto_stories_rounded, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LANJUTKAN LATIHAN',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Jilid $jilidNum · ${next['title']}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            lineHeight: 6,
                            percent: percent,
                            backgroundColor: color.withOpacity(0.12),
                            progressColor: color,
                            barRadius: const Radius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$completed/$total',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.arrow_forward_rounded,
                    color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1),
    ];
  }

  Widget _buildTipCard(BuildContext context, String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: context.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}


// ========== PROFILE TAB ==========
class _ProfileTab extends StatefulWidget {
  const _ProfileTab();

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  bool _notificationsEnabled = true;
  bool _matchTop3 = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationPref();
    _loadMatchModePref();
  }

  Future<void> _loadMatchModePref() async {
    final prefs = await SharedPreferences.getInstance();
    final top3 = prefs.getBool('match_top3') ?? false;
    if (mounted) setState(() => _matchTop3 = top3);
  }

  Future<void> _saveMatchModePref(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('match_top3', value);
    if (mounted) setState(() => _matchTop3 = value);
  }

  Future<void> _loadNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notifications_enabled') ?? true;
    if (mounted) {
      setState(() => _notificationsEnabled = enabled);
    }
    // Sinkronkan state: pref default true tapi jadwal belum tentu terpasang
    // (mis. setelah reinstall). zonedSchedule dengan id sama bersifat replace.
    if (enabled) {
      final granted = await NotificationService.requestPermission();
      if (granted) await NotificationService.scheduleDailyReminder();
    }
  }

  Future<void> _saveNotificationPref(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    if (value) {
      final granted = await NotificationService.requestPermission();
      if (!granted) {
        if (mounted) {
          setState(() => _notificationsEnabled = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Izin notifikasi ditolak. Aktifkan di pengaturan perangkat.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        await prefs.setBool('notifications_enabled', false);
        return;
      }
      await NotificationService.scheduleDailyReminder();
    } else {
      await NotificationService.cancelReminder();
    }

    await prefs.setBool('notifications_enabled', value);
  }

  void _showEditProfile() {
    final authProvider = context.read<AuthProvider>();
    final nameController = TextEditingController(text: authProvider.user?.name ?? '');
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const SizedBox(height: 20),
                Text(
                  'Edit Profil',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      final newName = nameController.text.trim();
                      Navigator.pop(ctx);
                      final ok = await authProvider.updateProfile(newName);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(ok ? 'Profil berhasil diperbarui' : 'Gagal memperbarui profil'),
                            backgroundColor: ok ? AppColors.primary : AppColors.error,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Simpan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Notifikasi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: Text('Pengingat latihan harian',
                    style: GoogleFonts.poppins(fontSize: 14)),
                subtitle: Text('Ingatkan saya berlatih setiap hari pukul 18:00',
                    style: GoogleFonts.poppins(fontSize: 12, color: context.textSecondary)),
                value: _notificationsEnabled,
                activeColor: AppColors.primary,
                onChanged: (val) async {
                  setState(() => _notificationsEnabled = val);
                  setDialogState(() {});
                  await _saveNotificationPref(val);
                  // Refresh dialog: izin bisa ditolak → switch kembali off.
                  setDialogState(() {});
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Tutup', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );
  }

  void _showBantuan() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Bantuan', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFaqItem('Bagaimana cara merekam bacaan?',
                  'Buka menu Jilid, pilih pelajaran, lalu tekan tombol mikrofon. Ucapkan kata Arab yang disorot hijau dengan jelas, kemudian tekan stop.'),
              _buildFaqItem('Kenapa evaluasi tidak akurat?',
                  'Pastikan merekam di tempat tenang, ucapkan dengan jelas dan tidak terlalu cepat. Jarak mikrofon yang ideal adalah 15-20 cm dari mulut.'),
              _buildFaqItem('Apa arti nilai Mumtaz, Jayyid, dll?',
                  'Mumtaz (≥85%): Istimewa\nJayyid Jiddan (≥70%): Sangat Baik\nJayyid (≥55%): Baik\nMaqbul (<55%): Cukup'),
              _buildFaqItem('Bagaimana melihat riwayat latihan?',
                  'Buka menu Riwayat dari halaman utama atau tab Progres untuk melihat statistik lengkap.'),
            ],
          ),
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

  void _showTentangTilawati() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Tentang Tilawati', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                // Logo butuh latar terang agar terlihat di dark mode.
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/icon/logo_aplikasi.png'),
              ),
            ),
            const SizedBox(height: 16),
            Text('Tilawati',
                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: context.textPrimary)),
            Text('v1.0.0',
                style: GoogleFonts.poppins(fontSize: 13, color: context.textSecondary)),
            const SizedBox(height: 16),
            Text(
              'Aplikasi pembelajaran bacaan Al-Qur\'an berbasis AI menggunakan metode Tilawati. Membantu pengguna belajar dan mengevaluasi bacaan huruf hijaiyah dengan teknologi pengenalan suara.',
              style: GoogleFonts.poppins(fontSize: 13, color: context.textSecondary, height: 1.6),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text('Tilawati — 2025',
                style: GoogleFonts.poppins(fontSize: 12, color: context.textLight)),
          ],
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

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary)),
          const SizedBox(height: 4),
          Text(answer,
              style: GoogleFonts.poppins(fontSize: 12, color: context.textSecondary, height: 1.5)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'Pengguna',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            Text(
              user?.email ?? '',
              style: GoogleFonts.poppins(fontSize: 14, color: context.textSecondary),
            ),
            const SizedBox(height: 32),

            // Menu items
            _buildProfileMenuItem(
              icon: Icons.person_outlined,
              title: 'Edit Profil',
              onTap: _showEditProfile,
            ),
            _buildDarkModeItem(),
            _buildMatchModeItem(),
            _buildProfileMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifikasi',
              subtitle: _notificationsEnabled ? 'Aktif' : 'Nonaktif',
              onTap: _showNotificationSettings,
            ),
            _buildProfileMenuItem(
              icon: Icons.help_outline_rounded,
              title: 'Bantuan',
              onTap: _showBantuan,
            ),
            _buildProfileMenuItem(
              icon: Icons.info_outline_rounded,
              title: 'Tentang Tilawati',
              onTap: _showTentangTilawati,
            ),
            const SizedBox(height: 16),
            _buildProfileMenuItem(
              icon: Icons.logout_rounded,
              title: 'Keluar',
              color: AppColors.error,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Keluar'),
                    content: const Text('Apakah Anda yakin ingin keluar?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthProvider>().logout();
                          Navigator.pop(ctx);
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text('Keluar', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkModeItem() {
    final themeProvider = context.watch<ThemeProvider>();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
      child: SwitchListTile(
        secondary: Icon(
          Icons.dark_mode_outlined,
          color: context.textPrimary,
        ),
        title: Text(
          'Mode Gelap',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: context.textPrimary,
          ),
        ),
        value: themeProvider.isDark,
        activeColor: AppColors.primaryLight,
        onChanged: (v) => themeProvider.toggle(v),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildMatchModeItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
      child: SwitchListTile(
        secondary: Icon(
          Icons.rule_rounded,
          color: context.textPrimary,
        ),
        title: Text(
          'Penilaian Top-3',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: context.textPrimary,
          ),
        ),
        subtitle: Text(
          _matchTop3
              ? 'Huruf benar bila masuk 3 besar tebakan (lebih mudah)'
              : 'Konvensional — pengucapan harus tepat',
          style: GoogleFonts.poppins(fontSize: 12, color: context.textSecondary),
        ),
        value: _matchTop3,
        activeColor: AppColors.primaryLight,
        onChanged: (v) => _saveMatchModePref(v),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
      child: ListTile(
        leading: Icon(icon, color: color ?? context.textPrimary),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: color ?? context.textPrimary,
          ),
        ),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: GoogleFonts.poppins(fontSize: 12, color: context.textSecondary))
            : null,
        trailing: Icon(Icons.chevron_right_rounded, color: color ?? context.textLight),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
