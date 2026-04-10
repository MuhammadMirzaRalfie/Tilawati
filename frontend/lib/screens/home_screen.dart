import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _HomeTab(),
          _JilidTab(),
          _ProgressTab(),
          _ProfileTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              label: 'Jilid',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Progres',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
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
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
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
              padding: const EdgeInsets.all(24),
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
            const SizedBox(height: 28),

            // Quick Menu
            Text(
              'Menu Utama',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
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
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildMenuCard(
                  context,
                  icon: Icons.history_rounded,
                  title: 'Riwayat',
                  subtitle: 'Hasil evaluasi',
                  color: const Color(0xFF7B1FA2),
                  onTap: () {},
                ),
                const SizedBox(width: 12),
                _buildMenuCard(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'Panduan',
                  subtitle: 'Cara pakai',
                  color: const Color(0xFFF57C00),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Tips Section
            Text(
              'Tips Membaca',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildTipCard(
              '🎯 Konsistensi',
              'Latihan 15-30 menit setiap hari lebih efektif dari latihan panjang sesekali.',
            ),
            _buildTipCard(
              '🎤 Lingkungan Tenang',
              'Rekam bacaan di tempat tenang untuk hasil evaluasi AI yang lebih akurat.',
            ),
            _buildTipCard(
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
            color: Colors.white,
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
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String content) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ========== JILID TAB ==========
class _JilidTab extends StatelessWidget {
  const _JilidTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Pilih Jilid',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pilih jilid Tilawati untuk mulai berlatih',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) {
                  final jilid = index + 1;
                  final titles = [
                    'Huruf Hijaiyah',
                    'Huruf Sambung',
                    'Mad & Sukun',
                    'Hukum Nun & Mim',
                    'Waqaf & Ibtida',
                    'Gharib & Musykilat',
                  ];
                  final descriptions = [
                    'Pengenalan huruf hijaiyah dan harakat fathah',
                    'Membaca huruf sambung dan kata sederhana',
                    'Hukum mad (panjang) dan sukun',
                    'Idzhar, Idgham, Ikhfa, dan Iqlab',
                    'Tanda berhenti dan cara memulai bacaan',
                    'Bacaan-bacaan asing dan sulit',
                  ];
                  return _buildJilidCard(
                    context,
                    jilid: jilid,
                    title: titles[index],
                    description: descriptions[index],
                    color: AppColors.jilidColors[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJilidCard(
    BuildContext context, {
    required int jilid,
    required String title,
    required String description,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/jilid-selection', arguments: jilid);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  '$jilid',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jilid $jilid - $title',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

// ========== PROGRESS TAB ==========
class _ProgressTab extends StatelessWidget {
  const _ProgressTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Progres Saya',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Stats row
            Row(
              children: [
                _buildStatCard('0', 'Total\nLatihan', AppColors.primary),
                const SizedBox(width: 10),
                _buildStatCard('0', 'Rata-rata\nSkor', const Color(0xFF1976D2)),
                const SizedBox(width: 10),
                _buildStatCard('0', 'Hari\nBerturut', const Color(0xFFF57C00)),
              ],
            ),
            const SizedBox(height: 24),

            // Empty state
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
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
                children: [
                  Icon(
                    Icons.bar_chart_rounded,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data progres',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mulai latihan untuk melihat\nperkembangan bacaan Anda',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.textLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/jilid-selection');
                    },
                    child: const Text('Mulai Latihan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: color.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ========== PROFILE TAB ==========
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

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
                  user?.name.isNotEmpty == true
                      ? user!.name[0].toUpperCase()
                      : 'U',
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
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              user?.email ?? '',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Menu items
            _buildProfileMenuItem(
              icon: Icons.person_outlined,
              title: 'Edit Profil',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.notifications_outlined,
              title: 'Notifikasi',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.help_outline_rounded,
              title: 'Bantuan',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.info_outline_rounded,
              title: 'Tentang Tilawati',
              onTap: () {},
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
                          Provider.of<AuthProvider>(context, listen: false)
                              .logout();
                          Navigator.pop(ctx);
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: const Text(
                          'Keluar',
                          style: TextStyle(color: AppColors.error),
                        ),
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

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
        leading: Icon(icon, color: color ?? AppColors.textPrimary),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: color ?? AppColors.textPrimary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: color ?? AppColors.textLight,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
