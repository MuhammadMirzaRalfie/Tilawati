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
                'arabic': '''بَ تَ
بَ تَ   تَ بَ   اَ تَ
تَ تَ   تَ بَ   تَ اَ
تَ بَ تَ         بَ تَ تَ
تَ اَ بَ         بَ اَ تَ
اَ تَ بَ         اَ بَ تَ
تَ تَ بَ         بَ بَ تَ''',
                'transliteration': '''BA TA
A TA     TA BA     BA TA
TA A     TA BA     TA TA
BA TA TA         TA BA TA
BA A TA         TA A BA
A BA TA         A TA BA
BA BA TA         TA TA BA''',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 2'
        },
        {
                'number': 3,
                'title': 'Hal 3 - Huruf Tsa',
                'arabic': '''تَ ثَ
ثَ ثَ   ثَ ثَ   ثَ بَ
ثَ تَ   ثَ اَ   ثَ بَ
تَ ثَ   اَ ثَ   بَ ثَ
ثَ ثَ بَ         بَ تَ ثَ
ثَ بَ تَ         تَ ثَ تَ
تَ اَ ثَ         بَ اَ ثَ
ثَ اَ بَ   تَ ثَ اَ   بَ تَ ثَ''',
                'transliteration': '''TA TSA
TSA BA     TSA TSA     TSA TSA
TSA BA     TSA A     TSA TA
BA TSA     A TSA     TA TSA
BA TA TSA         TSA TSA BA
TA TSA TA         TSA BA TA
BA A TSA         TA A TSA
BA TA TSA     TA TSA A     TSA A BA''',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 3'
        },
        {
                'number': 4,
                'title': 'Hal 4 - Huruf Jim & Ha',
                'arabic': '''جَ حَ
جَ جَ   حَ حَ   جَ حَ
ثَ جَ   بَ جَ   تَ حَ
حَ تَ   جَ حَ   ثَ حَ
حَ جَ بَ         اَ حَ حَ
بَ حَ تَ         حَ تَ ثَ
جَ بَ حَ         حَ ثَ جَ''',
                'transliteration': '''JA HA
JA HA     HA HA     JA JA
TA HA     BA JA     TSA JA
TSA HA     JA HA     HA TA
A HA HA         HA JA BA
HA TA TSA         BA HA TA
HA TSA JA         JA BA HA''',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 4'
        },
        {
                'number': 5,
                'title': 'Hal 5 - Huruf Kha',
                'arabic': '''خَ بَ ثَ
خَ خَ   خَ بَ   بَ خَ
جَ خَ   حَ خَ   خَ خَ
بَ تَ خَ         ثَ خَ تَ
بَ حَ ثَ         حَ خَ ثَ
خَ خَ جَ         خَ جَ حَ
خَ بَ جَ         بَ خَ ثَ''',
                'transliteration': '''KHA BA TSA
BA KHA     KHA BA     KHA KHA
KHA KHA     HA KHA     JA KHA
TSA KHA TA         BA TA KHA
HA KHA TSA         BA HA TSA
KHA JA HA         KHA KHA JA
BA KHA TSA         KHA BA JA''',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 5'
        },
        {
                'number': 6,
                'title': 'Hal 6 - Latihan',
                'arabic': '''خَ جَ بَ   تَ جَ ثَ   اَ تَ جَ
ثَ جَ حَ   بَ خَ ثَ   ثَ حَ جَ
جَ جَ تَ   ثَ خَ ثَ   حَ جَ بَ
بَ جَ ثَ   جَ خَ تَ   اَ جَ خَ
بَ خَ جَ   خَ ثَ حَ   جَ اَ بَ
بَ خَ جَ   جَ ثَ تَ   تَ اَ خَ
خَ جَ بَ   اَ حَ بَ   بَ حَ ثَ''',
                'transliteration': '''A TA JA     TA JA TSA     KHA JA BA
TSA HA JA     BA KHA TSA     TSA JA HA
HA JA BA     TSA KHA TSA     JA JA TA
A JA KHA     JA KHA TA     BA JA TSA
JA A BA     KHA TSA HA     BA KHA JA
TA A KHA     JA TSA TA     BA KHA JA
BA HA TSA     A HA BA     KHA JA BA''',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 6'
        },
        {
                'number': 7,
                'title': 'Hal 7 - Huruf Dal',
                'arabic': '''حَ خَ دَ
دَ دَ   حَ دَ   خَ دَ
دَ حَ   دَ خَ   دَ جَ
ثَ دَ   خَ دَ   تَ دَ
دَ دَ خَ         دَ دَ جَ
حَ دَ خَ         خَ دَ حَ
ثَ دَ خَ         تَ دَ حَ''',
                'transliteration': '''HA KHA DA
KHA DA     HA DA     DA DA
DA JA     DA KHA     DA HA
TA DA     KHA DA     TSA DA
DA DA JA         DA DA KHA
HA DA KHA         KHA DA HA
TA DA HA         TSA DA KHA''',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 7'
        },
        {
                'number': 8,
                'title': 'Hal 8 - Huruf Dzal',
                'arabic': '''خَ دَ ذَ
ذَ ذَ   ذَ دَ   ذَ خَ
حَ ذَ   خَ ذَ   جَ ذَ
ذَ ثَ   بَ ذَ   ذَ تَ
ذَ دَ حَ         دَ ذَ حَ
حَ بَ ذَ         خَ ذَ ثَ
تَ خَ ذَ         ثَ جَ ذَ''',
                'transliteration': '''KHA DA DZA
DZA KHA     DZA DA     DZA DZA
JA DZA     KHA DZA     HA DZA
DZA TA     BA DZA     DZA TSA
DA DZA HA         DZA DA HA
KHA DZA TSA         HA BA DZA
TSA JA DZA         TA KHA DZA''',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 8'
        },
        {
                'number': 9,
                'title': 'Hal 9 - Huruf Ra & Za',
                'arabic': '''رَ زَ
رَ زَ   ذَ رَ   زَ رَ
حَ زَ   دَ زَ   خَ زَ
رَ رَ   جَ رَ   ذَ زَ
ذَ رَ زَ         زَ رَ دَ
ذَ حَ زَ         زَ خَ رَ
خَ زَ رَ         حَ ذَ رَ''',
                'transliteration': '''RA ZA
ZA RA     DZA RA     RA ZA
KHA ZA     DA ZA     HA ZA
DZA ZA     JA RA     RA RA
ZA RA DA         DZA RA ZA
ZA KHA RA         DZA HA ZA
HA DZA RA         KHA ZA RA''',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 9'
        },
        {
                'number': 10,
                'title': 'Hal 10 - Huruf Sin',
                'arabic': '''زَ سَ
سَ سَ   سَ رَ   سَ زَ
دَ سَ   ذَ سَ   زَ سَ
سَ جَ   سَ حَ   سَ خَ
سَ رَ دَ         سَ جَ دَ
خَ سَ رَ         حَ سَ دَ
دَ رَ سَ         تَ خَ سَ''',
                'transliteration': '''ZA SA
SA ZA     SA RA     SA SA
ZA SA     DZA SA     DA SA
SA KHA     SA HA     SA JA
SA JA DA         SA RA DA
HA SA DA         KHA SA RA
TA KHA SA         DA RA SA''',
                'desc': 'Latihan Tilawati Jilid 1 Halaman 10'
        },
        {
                'number': 11,
                'title': 'Hal 11 - Huruf Syin',
                'arabic': '''شَ رَ حَ
شَ شَ   شَ رَ   شَ حَ
دَ سَ   ذَ شَ   حَ شَ
شَ خَ   سَ زَ   شَ ذَ
شَ جَ سَ         شَ سَ خَ
خَ سَ رَ         شَ خَ رَ
شَ جَ رَ         شَ رَ حَ''',
                'transliteration': '''SYA RA HA
SYA HA     SYA RA     SYA SYA
HA SYA     DZA SYA     DA SA
SYA DZA     SA ZA     SYA KHA
SYA SA KHA         SYA JA SA
SYA KHA RA         KHA SA RA
SYA RA HA         SYA JA RA''',
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
