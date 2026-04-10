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
      'description': 'Pengenalan huruf hijaiyah dan harakat fathah',
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFF1B5E20),
      'lessons': [
        {
                'number': 1,
                'title': 'Hal 1 - Huruf Alif & Ba',
                'arabic': '''اَ بَ
اَ اَ   بَ بَ   اَ بَ
بَ اَ   اَ بَ   اَ بَ
اَ اَ اَ         بَ بَ بَ
بَ بَ اَ         اَ بَ اَ
اَ بَ بَ         بَ اَ بَ''',
                'transliteration': '''A BA
A BA     BA BA     A A
A BA     A BA     BA A
BA BA BA         A A A
A BA A         BA BA A
BA A BA         A BA BA''',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 1'
        },
        {
                'number': 2,
                'title': 'Hal 2 - Huruf Ta',
                'arabic': 'بَ تَ   بَ تَ   بَ تَ',
                'transliteration': 'BA TA   BA TA   BA TA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 2'
        },
        {
                'number': 3,
                'title': 'Hal 3 - Huruf Tsa',
                'arabic': 'تَ ثَ   تَ ثَ   تَ ثَ',
                'transliteration': 'TA TSA   TA TSA   TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 3'
        },
        {
                'number': 4,
                'title': 'Hal 4 - Huruf Jim & Ha',
                'arabic': 'جَ حَ   جَ حَ   جَ حَ',
                'transliteration': 'JA HA   JA HA   JA HA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 4'
        },
        {
                'number': 5,
                'title': 'Hal 5 - Huruf Kha',
                'arabic': 'خَ بَ ثَ   خَ بَ ثَ   خَ بَ ثَ',
                'transliteration': 'KHA BA TSA   KHA BA TSA   KHA BA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 5'
        },
        {
                'number': 6,
                'title': 'Hal 6 - Huruf Dal & Dzal',
                'arabic': 'دَ ذَ   دَ ذَ   دَ ذَ',
                'transliteration': 'DA DZA   DA DZA   DA DZA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 6'
        },
        {
                'number': 7,
                'title': 'Hal 7 - Huruf Ra & Za',
                'arabic': 'رَ زَ   رَ زَ   رَ زَ',
                'transliteration': 'RA ZA   RA ZA   RA ZA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 7'
        },
        {
                'number': 8,
                'title': 'Hal 8 - Huruf Sin',
                'arabic': 'سَ رَ زَ   سَ رَ زَ   سَ رَ زَ',
                'transliteration': 'SA RA ZA   SA RA ZA   SA RA ZA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 8'
        },
        {
                'number': 9,
                'title': 'Hal 9 - Huruf Syin',
                'arabic': 'شَ رَ حَ   شَ رَ حَ   شَ رَ حَ',
                'transliteration': 'SYA RA HA   SYA RA HA   SYA RA HA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 9'
        },
        {
                'number': 10,
                'title': 'Hal 10 - Huruf Shad',
                'arabic': 'صَ حَ بَ   صَ حَ بَ   صَ حَ بَ',
                'transliteration': 'SHA HA BA   SHA HA BA   SHA HA BA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 10'
        },
        {
                'number': 11,
                'title': 'Hal 11 - Huruf Dhad',
                'arabic': 'ضَ رَ بَ   ضَ رَ بَ   ضَ رَ بَ',
                'transliteration': 'DHA RA BA   DHA RA BA   DHA RA BA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 11'
        },
        {
                'number': 12,
                'title': 'Hal 12 - Huruf Tha',
                'arabic': 'طَ بَ خَ   طَ بَ خَ   طَ بَ خَ',
                'transliteration': 'THA BA KHA   THA BA KHA   THA BA KHA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 12'
        },
        {
                'number': 13,
                'title': 'Hal 13 - Huruf Zha',
                'arabic': 'ظَ صَ   ظَ صَ   ظَ صَ',
                'transliteration': 'ZHA SHA   ZHA SHA   ZHA SHA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 13'
        },
        {
                'number': 14,
                'title': "Hal 14 - Huruf 'Ain",
                'arabic': 'عَ طَ بَ   عَ طَ بَ   عَ طَ بَ',
                'transliteration': "'A THA BA   'A THA BA   'A THA BA",
                'desc': 'Latihan Tilawati Jilid 1 Halaman 14'
        },
        {
                'number': 15,
                'title': 'Hal 15 - Huruf Ghain',
                'arabic': 'غَ عَ   غَ عَ   غَ عَ',
                'transliteration': "GHA 'A   GHA 'A   GHA 'A",
                'desc': 'Latihan Tilawati Jilid 1 Halaman 15'
        },
        {
                'number': 16,
                'title': 'Hal 16 - Huruf Fa',
                'arabic': 'فَ قَ   فَ قَ   فَ قَ',
                'transliteration': 'FA QA   FA QA   FA QA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 16'
        },
        {
                'number': 17,
                'title': 'Hal 17 - Huruf Qaf',
                'arabic': 'قَ فَ   قَ فَ   قَ فَ',
                'transliteration': 'QA FA   QA FA   QA FA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 17'
        },
        {
                'number': 18,
                'title': 'Hal 18 - Huruf Kaf',
                'arabic': 'كَ   كَ   كَ',
                'transliteration': 'KA   KA   KA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 18'
        },
        {
                'number': 19,
                'title': 'Hal 19 - Huruf Lam',
                'arabic': 'لَ   لَ   لَ',
                'transliteration': 'LA   LA   LA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 19'
        },
        {
                'number': 20,
                'title': 'Hal 20 - Huruf Mim',
                'arabic': 'مَ نَ   مَ نَ   مَ نَ',
                'transliteration': 'MA NA   MA NA   MA NA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 20'
        },
        {
                'number': 21,
                'title': 'Hal 21 - Huruf Nun',
                'arabic': 'نَ   نَ   نَ',
                'transliteration': 'NA   NA   NA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 21'
        },
        {
                'number': 22,
                'title': 'Hal 22 - Huruf Wawu',
                'arabic': 'وَ هَ   وَ هَ   وَ هَ',
                'transliteration': 'WA HA   WA HA   WA HA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 22'
        },
        {
                'number': 23,
                'title': 'Hal 23 - Huruf Ha',
                'arabic': 'هَ   هَ   هَ',
                'transliteration': 'HA   HA   HA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 23'
        },
        {
                'number': 24,
                'title': 'Hal 24 - Huruf Ya',
                'arabic': 'يَ اَ   يَ اَ   يَ اَ',
                'transliteration': 'YA A   YA A   YA A',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 24'
        },
        {
                'number': 25,
                'title': 'Hal 25 - Latihan 1',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 25'
        },
        {
                'number': 26,
                'title': 'Hal 26 - Latihan 2',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 26'
        },
        {
                'number': 27,
                'title': 'Hal 27 - Latihan 3',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 27'
        },
        {
                'number': 28,
                'title': 'Hal 28 - Latihan 4',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 28'
        },
        {
                'number': 29,
                'title': 'Hal 29 - Latihan 5',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 29'
        },
        {
                'number': 30,
                'title': 'Hal 30 - Latihan 6',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 30'
        },
        {
                'number': 31,
                'title': 'Hal 31 - Latihan 7',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 31'
        },
        {
                'number': 32,
                'title': 'Hal 32 - Latihan 8',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 32'
        },
        {
                'number': 33,
                'title': 'Hal 33 - Latihan 9',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 33'
        },
        {
                'number': 34,
                'title': 'Hal 34 - Latihan 10',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 34'
        },
        {
                'number': 35,
                'title': 'Hal 35 - Latihan 11',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 35'
        },
        {
                'number': 36,
                'title': 'Hal 36 - Latihan 12',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 36'
        },
        {
                'number': 37,
                'title': 'Hal 37 - Latihan 13',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 37'
        },
        {
                'number': 38,
                'title': 'Hal 38 - Latihan 14',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 38'
        },
        {
                'number': 39,
                'title': 'Hal 39 - Latihan 15',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 39'
        },
        {
                'number': 40,
                'title': 'Hal 40 - Latihan 16',
                'arabic': 'اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ',
                'transliteration': 'A BA TA TSA   A BA TA TSA   A BA TA TSA',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 40'
        }
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
