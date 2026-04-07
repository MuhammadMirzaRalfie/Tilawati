import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../config/theme.dart';


class JilidSelectionScreen extends StatefulWidget {
  const JilidSelectionScreen({super.key});

  @override
  State<JilidSelectionScreen> createState() => _JilidSelectionScreenState();
}

class _JilidSelectionScreenState extends State<JilidSelectionScreen> {
  int? _selectedJilid;


  // Static data matching backend ai_service.py
  final List<Map<String, dynamic>> _jilids = [
    {
      'jilid': 1,
      'title': 'Jilid 1 - Huruf Hijaiyah',
      'description': 'Pengenalan huruf hijaiyah dan harakat dasar',
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFF1B5E20),
      'lessons': [
        {'number': 1, 'title': 'Huruf Alif - Ba - Ta', 'arabic': 'أَ بَ تَ أِ بِ تِ أُ بُ تُ', 'transliteration': 'A BA TA I BI TI U BU TU', 'desc': 'Belajar membaca huruf Alif, Ba, dan Ta dengan harakat fathah, kasrah, dan dhammah'},
        {'number': 2, 'title': 'Huruf Tsa - Jim - Ha', 'arabic': 'ثَ جَ حَ ثِ جِ حِ ثُ جُ حُ', 'transliteration': 'TSA JA HA TSI JI HI TSU JU HU', 'desc': 'Belajar membaca huruf Tsa, Jim, dan Ha dengan harakat dasar'},
        {'number': 3, 'title': 'Huruf Kha - Dal - Dzal', 'arabic': 'خَ دَ ذَ خِ دِ ذِ خُ دُ ذُ', 'transliteration': 'KHA DA DZA KHI DI DZI KHU DU DZU', 'desc': 'Belajar membaca huruf Kha, Dal, dan Dzal'},
        {'number': 4, 'title': 'Huruf Ra - Za - Sin', 'arabic': 'رَ زَ سَ رِ زِ سِ رُ زُ سُ', 'transliteration': 'RA ZA SA RI ZI SI RU ZU SU', 'desc': 'Belajar membaca huruf Ra, Za, dan Sin'},
        {'number': 5, 'title': 'Huruf Syin - Shad - Dhad', 'arabic': 'شَ صَ ضَ شِ صِ ضِ شُ صُ ضُ', 'transliteration': 'SYA SHA DHA SYI SHI DHI SYU SHU DHU', 'desc': 'Belajar membaca huruf Syin, Shad, dan Dhad'},
      ],
    },
    {
      'jilid': 2,
      'title': 'Jilid 2 - Huruf Sambung',
      'description': 'Membaca huruf sambung dan kata sederhana',
      'icon': Icons.auto_stories_rounded,
      'color': const Color(0xFF0D47A1),
      'lessons': [
        {'number': 1, 'title': 'Huruf Sambung Awal', 'arabic': 'بَتَ نَصَرَ كَتَبَ', 'transliteration': 'BATA NASHARA KATABA', 'desc': 'Membaca huruf sambung di awal kata'},
        {'number': 2, 'title': 'Huruf Sambung Tengah', 'arabic': 'سَمِعَ عَلِمَ فَهِمَ', 'transliteration': "SAMI'A 'ALIMA FAHIMA", 'desc': 'Membaca huruf sambung di tengah kata'},
        {'number': 3, 'title': 'Huruf Sambung Akhir', 'arabic': 'ذَهَبَ حَسُنَ كَرُمَ', 'transliteration': 'DZAHABA HASUNA KARUMA', 'desc': 'Membaca huruf sambung di akhir kata'},
        {'number': 4, 'title': 'Kata dengan Tanwin', 'arabic': 'كِتَابًا عِلْمًا نُوْرًا', 'transliteration': "KITAABAN 'ILMAN NUURAN", 'desc': 'Membaca kata dengan tanwin'},
      ],
    },
    {
      'jilid': 3,
      'title': 'Jilid 3 - Mad & Sukun',
      'description': 'Hukum mad (panjang) dan sukun',
      'icon': Icons.school_rounded,
      'color': const Color(0xFF4A148C),
      'lessons': [
        {'number': 1, 'title': "Mad Asli (Mad Thabi'i)", 'arabic': 'قَالَ - كِيْلَ - يَقُوْلُ', 'transliteration': 'QAALA - KIILA - YAQUULU', 'desc': 'Membaca mad asli dengan panjang 2 harakat'},
        {'number': 2, 'title': 'Sukun dan Qalqalah', 'arabic': 'اَلْحَمْدُ - يَبْدَأُ', 'transliteration': 'ALHAMDU - YABDA-U', 'desc': 'Huruf sukun dan qalqalah'},
        {'number': 3, 'title': 'Tasydid', 'arabic': 'إِنَّ - أَنَّ - رَبَّكَ', 'transliteration': 'INNA - ANNA - RABBAKA', 'desc': 'Membaca huruf bertasydid'},
      ],
    },
    {
      'jilid': 4,
      'title': 'Jilid 4 - Hukum Nun & Mim',
      'description': 'Idzhar, Idgham, Ikhfa, dan Iqlab',
      'icon': Icons.mosque_rounded,
      'color': const Color(0xFFBF360C),
      'lessons': [
        {'number': 1, 'title': 'Nun Sukun - Idzhar', 'arabic': "مَنْ أَعْطَى - مِنْ عِلْمٍ", 'transliteration': "MAN A'THA - MIN 'ILMIN", 'desc': 'Nun sukun bertemu huruf halqi'},
        {'number': 2, 'title': 'Nun Sukun - Idgham', 'arabic': 'مَنْ يَعْمَلْ - مِنْ وَلِيٍّ', 'transliteration': "MAY YA'MAL - MIW WALIYYIN", 'desc': 'Nun sukun bertemu huruf idgham'},
        {'number': 3, 'title': 'Nun Sukun - Ikhfa', 'arabic': 'مِنْ قَبْلِ - أَنْتُمْ', 'transliteration': 'MIN QABLI - ANTUM', 'desc': 'Nun sukun bertemu huruf ikhfa'},
      ],
    },
    {
      'jilid': 5,
      'title': 'Jilid 5 - Waqaf & Ibtida',
      'description': 'Tanda berhenti dan cara memulai bacaan',
      'icon': Icons.bookmark_rounded,
      'color': const Color(0xFF006064),
      'lessons': [
        {'number': 1, 'title': 'Waqaf Lazim', 'arabic': 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ ۝', 'transliteration': 'BISMILLAHIRRAHMANIRRAHIIM', 'desc': 'Berhenti pada tanda waqaf lazim'},
        {'number': 2, 'title': 'Waqaf Ja\'iz', 'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', 'transliteration': "ALHAMDULILLAHI RABBIL 'AALAMIIN", 'desc': 'Berhenti pada tanda waqaf ja\'iz'},
      ],
    },
    {
      'jilid': 6,
      'title': 'Jilid 6 - Gharib & Musykilat',
      'description': 'Bacaan-bacaan asing dan sulit dalam Al-Qur\'an',
      'icon': Icons.star_rounded,
      'color': const Color(0xFFFF6F00),
      'lessons': [
        {'number': 1, 'title': 'Saktah', 'arabic': 'عِوَجَا ۜ قَيِّمًا', 'transliteration': 'IWAJA (saktah) QAYYIMAN', 'desc': 'Berhenti sejenak tanpa bernapas'},
        {'number': 2, 'title': 'Isymam & Imalah', 'arabic': 'لَا تَأْمَ۪نَّا', 'transliteration': "LAA TA'MANNAA", 'desc': 'Bacaan isymam dan imalah'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pilih Jilid',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: _selectedJilid == null ? _buildJilidList() : _buildLessonList(),
    );
  }

  Widget _buildJilidList() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: _jilids.length,
        itemBuilder: (context, index) {
          final jilid = _jilids[index];
          return _buildJilidCard(jilid);
        },
      ),
    );
  }

  Widget _buildJilidCard(Map<String, dynamic> jilid) {
    final color = jilid['color'] as Color;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedJilid = jilid['jilid'] as int;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                jilid['icon'] as IconData,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Jilid ${jilid['jilid']}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                (jilid['description'] as String),
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${(jilid['lessons'] as List).length} pelajaran',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonList() {
    final jilid = _jilids.firstWhere((j) => j['jilid'] == _selectedJilid);
    final color = jilid['color'] as Color;
    final lessons = jilid['lessons'] as List;

    return Column(
      children: [
        // Back to jilids
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _selectedJilid = null),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_back_ios_rounded, size: 14, color: color),
                      const SizedBox(width: 4),
                      Text(
                        'Semua Jilid',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Jilid header
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Icon(jilid['icon'] as IconData, color: Colors.white, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jilid['title'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${lessons.length} pelajaran tersedia',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Lesson list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length,
            itemBuilder: (context, index) {
              final lesson = lessons[index] as Map<String, dynamic>;
              return _buildLessonCard(lesson, color, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonCard(Map<String, dynamic> lesson, Color color, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/lesson',
          arguments: {
            'jilid': _selectedJilid,
            'lesson': lesson,
            'color': color,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson['title'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lesson['desc'] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.play_circle_filled_rounded, color: color, size: 32),
          ],
        ),
      ),
    );
  }
}
