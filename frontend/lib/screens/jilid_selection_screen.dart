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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 1',
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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 2',
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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 3',
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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 4',
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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 5',
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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 6',
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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 7',
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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 8',
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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 9',
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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 10',
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
          'desc': 'Latihan Tilawati Jilid 1 Halaman 11',
        },
        {
          'number': 12,
          'title': 'Hal 12 - Latihan',
          'arabic': '''ذَ دَ خَ   سَ رَ دَ   سَ جَ دَ
حَ ذَ بَ   خَ سَ رَ   حَ سَ دَ
تَ خَ ذَ   دَ رَ سَ   ثَ خَ سَ
دَ ذَ حَ   رَ زَ دَ   سَ شَ جَ
خَ دَ ثَ   حَ ذَ رَ   ذَ حَ شَ
ثَ جَ دَ   زَ حَ رَ   خَ سَ دَ
سَ رَ دَ   دَ رَ سَ   خَ سَ رَ
شَ جَ رَ   رَ شَ دَ   شَ رَ حَ''',
          'transliteration': '''DZA DA KHA     SA RA DA     SA JA DA
HA DZA BA     KHA SA RA     HA SA DA
TA KHA DZA     DA RA SA     TSA KHA SA
DA DZA HA     RA ZA DA     SA SYA JA
KHA DA TSA     HA DZA RA     DZA HA SYA
TSA JA DA     ZA HA RA     KHA SA DA
SA RA DA     DA RA SA     KHA SA RA
SYA JA RA     RA SYA DA     SYA RA HA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 12',
        },
        {
          'number': 13,
          'title': 'Hal 13 - Huruf Shad',
          'arabic': '''صَ حَ بَ
صَ صَ   صَ حَ   صَ خَ
رَ صَ   سَ صَ   ذَ صَ
صَ بَ   صَ خَ   صَ رَ
صَ دَ بَ         صَ بَ رَ
جَ تَ صَ         حَ صَ بَ
حَ صَ دَ         حَ صَ ذَ''',
          'transliteration': '''SHA HA BA
SHA KHA     SHA HA     SHA SHA
DZA SHA     SA SHA     RA SHA
SHA RA     SHA KHA     SHA BA
SHA BA RA         SHA DA BA
HA SHA BA         JA TA SHA
HA SHA DZA         HA SHA DA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 13',
        },
        {
          'number': 14,
          'title': 'Hal 14 - Huruf Dhad',
          'arabic': '''ضَ رَ بَ
ضَ ضَ   ضَ رَ   ضَ بَ
رَ ضَ   ذَ ضَ   صَ ضَ
ضَ خَ   زَ ضَ   ضَ حَ
ضَ رَ بَ         ضَ بَ رَ
حَ ضَ رَ         شَ رَ ضَ
تَ بَ ضَ         صَ صَ ضَ''',
          'transliteration': '''DHA RA BA
DHA BA     DHA RA     DHA DHA
SHA DHA     DZA DHA     RA DHA
DHA HA     ZA DHA     DHA KHA
DHA BA RA         DHA RA BA
SYA RA DHA         HA DHA RA
SHA SHA DHA         TA BA DHA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 14',
        },
        {
          'number': 15,
          'title': 'Hal 15 - Huruf Tha',
          'arabic': '''طَ بَ خَ
طَ طَ   طَ ضَ   طَ صَ
سَ طَ   صَ طَ   شَ طَ
طَ رَ   ذَ طَ   طَ دَ
طَ بَ خَ         حَ طَ بَ
صَ تَ طَ         طَ زَ ضَ
شَ طَ دَ         حَ طَ سَ''',
          'transliteration': '''THA BA KHA
THA SHA     THA DHA     THA THA
SYA THA     SHA THA     SA THA
THA DA     DZA THA     THA RA
HA THA BA         THA BA KHA
THA ZA DHA         SHA TA THA
HA THA SA         SYA THA DA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 15',
        },
        {
          'number': 16,
          'title': 'Hal 16 - Huruf Zha',
          'arabic': '''ظَ صَ
ظَ ظَ   ظَ صَ   طَ ظَ
شَ ظَ   زَ ظَ   صَ طَ
ظَ طَ   ظَ سَ   ظَ دَ
ظَ بَ طَ         سَ ظَ خَ
صَ حَ ظَ         صَ ظَ بَ
لَ ظَ بَ         حَ بَ ظَ''',
          'transliteration': '''ZHA SHA
THA ZHA     ZHA SHA     ZHA ZHA
SHA THA     ZA ZHA     SYA ZHA
ZHA DA     ZHA SA     ZHA THA
SA ZHA KHA         ZHA BA THA
SHA ZHA BA         SHA HA ZHA
HA BA ZHA         LA ZHA BA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 16',
        },
        {
          'number': 17,
          'title': "Hal 17 - Huruf 'Ain",
          'arabic': '''عَ طَ بَ
عَ ظَ   عَ طَ   عَ صَ
شَ عَ   ضَ عَ   عَ ظَ
عَ زَ   ذَ عَ   عَ دَ
ذَ عَ ظَ         عَ طَ شَ
سَ صَ عَ         ظَ عَ ضَ
حَ عَ صَ         عَ ظَ بَ''',
          'transliteration': """'A THA BA
'A ZHA     'A THA     'A SHA
SYA 'A     DHA 'A     'A ZHA
'A ZA     DZA 'A     'A DA
DZA 'A ZHA         'A THA SYA
SA SHA 'A         ZHA 'A DHA
HA 'A SHA         'A ZHA BA""",
          'desc': 'Latihan Tilawati Jilid 1 Halaman 17',
        },
        {
          'number': 18,
          'title': 'Hal 18 - Latihan',
          'arabic': '''صَ بَ رَ   شَ طَ طَ   رَ طَ بَ
طَ رَ دَ   ظَ بَ طَ   عَ طَ سَ
حَ صَ دَ   اَ ظَ بَ   طَ رَ دَ
حَ ضَ رَ   بَ طَ رَ   شَ رَ عَ
خَ طَ بَ   عَ جَ بَ   بَ شَ رَ
بَ رَ دَ   زَ رَ عَ   اَ ثَ رَ
تَ بَ عَ   سَ جَ دَ   شَ رَ بَ
عَ ضَ بَ   ضَ رَ بَ   عَ رَ ضَ''',
          'transliteration': '''SHA BA RA     SYA THA THA     RA THA BA
THA RA DA     ZHA BA THA     'A THA SA
HA SHA DA     A ZHA BA     THA RA DA
HA DHA RA     BA THA RA     SYA RA 'A
KHA THA BA     'A JA BA     BA SYA RA
BA RA DA     ZA RA 'A     A TSA RA
TA BA 'A     SA JA DA     SYA RA BA
'A DHA BA     DHA RA BA     'A RA DHA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 18',
        },
        {
          'number': 19,
          'title': 'Hal 19 - Huruf Ghain',
          'arabic': '''عَ غَ
غَ غَ   غَ عَ   غَ عَ
طَ غَ   غَ ظَ   صَ عَ
غَ ضَ   شَ غَ   خَ غَ
غَ بَ رَ         شَ غَ رَ
بَ غَ سَ         غَ سَ طَ
غَ ضَ بَ         غَ رَ بَ''',
          'transliteration': """'A GHA
GHA GHA     GHA 'A     GHA 'A
THA GHA     GHA ZHA     SHA 'A
GHA DHA     SYA GHA     KHA GHA
GHA BA RA         SYA GHA RA
BA GHA SA         GHA SA THA
GHA DHA BA         GHA RA BA""",
          'desc': 'Latihan Tilawati Jilid 1 Halaman 19',
        },
        {
          'number': 20,
          'title': 'Hal 20 - Huruf Fa',
          'arabic': '''غَ فَ
فَ فَ   فَ غَ   فَ عَ
غَ فَ   ظَ فَ   صَ فَ
فَ ضَ   فَ شَ   فَ ذَ
فَ زَ دَ         صَ فَ حَ
عَ ضَ فَ         عَ رَ فَ
فَ شَ جَ         ظَ عَ فَ''',
          'transliteration': """GHA FA
FA FA     FA GHA     FA 'A
GHA FA     ZHA FA     SHA FA
FA DHA     FA SYA     FA DZA
FA ZA DA         SHA FA HA
'A DHA FA         'A RA FA
FA SYA JA         ZHA 'A FA""",
          'desc': 'Latihan Tilawati Jilid 1 Halaman 20',
        },
        {
          'number': 21,
          'title': 'Hal 21 - Huruf Qaf',
          'arabic': '''فَ قَ 
فَ قَ   قَ فَ   قَ عَ
فَ قَ   عَ قَ   طَ قَ
قَ ضَ   فَ ظَ   طَ قَ
قَ فَ ظَ         عَ قَ بَ
غَ دَ قَ         زَ عَ فَ
فَ قَ رَ         غَ رَ قَ''',
          'transliteration': '''FA   QA
FA QA   QA QA   FA QA   'A QA
FA QA   'A QA   THA QA   QA THA
QA DHA   FA ZHA   'A QA   BA QA
FA QA RA   DA QA A   FA RA 'A   QA RA A''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 21',
        },
        {
          'number': 22,
          'title': 'Hal 22 - Latihan',
          'arabic': '''عَ رَ ضَ   غَ دَ قَ   فَ قَ رَ
عَ رَ فَ   رَ فَ قَ   فَ قَ دَ
زَ رَ عَ   رَ زَ قَ   قَ تَ دَ
رَ فَ ثَ   سَ رَ قَ   قَ رَ بَ
شَ فَ عَ   غَ رَ بَ   عَ دَ بَ
اَ ثَ رَ   شَ حَ دَ   حَ طَ ظَ
ظَ فَ رَ   جَ رَ دَ   حَ فَ ظَ
خَ رَ جَ   عَ زَ زَ   غَ سَ قَ''',
          'transliteration': """'A RA DHA   GHA DA QA   FA QA RA
'A RA FA   RA FA QA   FA QA DA
ZA RA 'A   RA ZA QA   QA TA DA
RA FA TSA   SA RA QA   QA RA BA
SYA FA 'A   GHA RA BA   'A DA BA
A TSA RA   SYA HA DA   HA THA ZHA
ZHA FA RA   JA RA DA   HA FA ZHA
KHA RA JA   'A ZA ZA   GHA SA QA""",
          'desc': 'Latihan Tilawati Jilid 1 Halaman 22',
        },
        {
          'number': 23,
          'title': 'Hal 23 - Huruf Kaf',
          'arabic': '''كَ فَ رَ
كَ كَ   فَ كَ   كَ قَ
فَ كَ   قَ كَ   غَ كَ
كَ غَ   كَ ضَ   كَ صَ
كَ فَ رَ         قَ سَ كَ
عَ كَ فَ         بَ رَ كَ
كَ بَ دَ         سَ رَ كَ''',
          'transliteration': '''KA FA RA
KA KA   FA KA   KA QA
FA KA   QA KA   GHA KA
KA GHA   KA DHA   KA SHA
KA FA RA         QA SA KA
'A KA FA         BA RA KA
KA BA DA         SA RA KA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 23',
        },
        {
          'number': 24,
          'title': 'Hal 24 - Huruf Lam',
          'arabic': '''لَ كَ
لَ شَ   لَ فَ   قَ لَ
كَ لَ   لَ خَ   ضَ لَ
عَ لَ   فَ لَ   لَ ضَ
عَ دَ لَ         لَ قَ بَ
جَ عَ لَ         فَ لَ حَ
غَ زَ لَ         خَ لَ قَ''',
          'transliteration': '''LA KA
LA SYA   LA FA   QA LA
KA LA   LA KHA   DHA LA
'A LA   FA LA   LA DHA
'A DA LA         LA QA BA
JA 'A LA         FA LA HA
GHA ZA LA         KHA LA QA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 24',
        },
        {
          'number': 25,
          'title': 'Hal 25 - Huruf Mim',
          'arabic': '''مَ = مَ
كَ كَ   فَ كَ   كَ قَ
لَ سَ   لَ فَ   قَ لَ
رَ مَ   مَ ضَ   لَ مَ
قَ مَ رَ   رَ غَ مَ   فَ لَ مَ
كَ رَ مَ   مَ زَ قَ   عَ ظَ مَ
مَ رَ حَ   رَ جَ مَ   طَ مَ سَ''',
          'transliteration': '''MA = MA
KA KA   FA KA   KA QA
LA SA   LA FA   QA LA
RA MA   MA DHA   LA MA
QA MA RA   RA GHA MA   FA LA MA
KA RA MA   MA ZA QA   'A ZHA MA
MA RA HA   RA JA MA   THA MA SA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 25',
        },
        {
          'number': 26,
          'title': 'Hal 26 - Huruf Nun',
          'arabic': '''نَ لَ
نَ لَ   بَ نَ   خَ نَ
كَ نَ   فَ نَ   نَ جَ
دَ نَ   نَ دَ   نَ صَ
فَ نَ دَ   نَ صَ رَ   قَ رَ نَ
ضَ مَ نَ   نَ ظَ مَ   جَ نَ بَ
حَ ضَ نَ   نَ خَ لَ   حَ سَ نَ''',
          'transliteration': '''NA = NA
NA LA   BA NA   KHA NA
KA NA   FA NA   NA JA
DA NA   NA DA   NA SHA
FA NA DA   NA SHA RA   QA RA NA
DHA MA NA   NA ZHA MA   JA NA BA
HA DHA NA   NA KHA LA   HA SA NA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 26',
        },
        {
          'number': 27,
          'title': 'Hal 27 - Huruf Wawu',
          'arabic': '''وَ قَ فَ
وَ قَ   وَ فَ   قَ وَ
رَ وَ   نَ وَ   وَ مَ
وَ لَ   صَ وَ   طَ وَ
وَ قَ رَ         صَ وَ بَ
سَ قَ وَ         وَ رَ دَ
وَ جَ لَ         زَ وَ لَ''',
          'transliteration': '''WA QA FA
WA QA   WA FA   QA WA
RA WA   NA WA   WA MA
WA LA   SHA WA   THA WA
WA QA RA         SHA WA BA
SA QA WA         WA RA DA
WA JA LA         ZA WA LA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 27',
        },
        {
          'number': 28,
          'title': 'Hal 28 - Huruf Ha',
          'arabic': '''هَ   وَ
هَ دَ   هَ رَ   وَ هَ
جَ هَ   شَ هَ   هَ رَ
هَ وَ   نَ هَ   هَ مَ
هَ دَ بَ         وَ هَ نَ
جَ هَ دَ         شَ هَ دَ
دَ هَ قَ         وَ هَ بَ''',
          'transliteration': '''HA   WA
HA DA   HA RA   WA HA
JA HA   SYA HA   HA RA
HA WA   NA HA   HA MA
HA DA BA         WA HA NA
JA HA DA         SYA HA DA
DA HA QA         WA HA BA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 28',
        },
        {
          'number': 29,
          'title': 'Hal 29 - Latihan',
          'arabic': '''هَ لَ كَ   كَ لَ مَ   فَ هَ دَ
حَ صَ لَ   هَ دَ مَ   نَ ظَ رَ
كَ رَ مَ   فَ عَ لَ   غَ سَ مَ
شَ هَ دَ   جَ عَ لَ   مَ هَ نَ
جَ بَ لَ   ثَ قَ بَ   وَ طَ رَ
هَ زَ مَ   نَ زَ لَ   قَ وَ مَ
حَ زَ نَ   وَ عَ دَ   كَ رَ هَ''',
          'transliteration': '''HA LA KA   KA LA MA   FA HA DA
HA SHA LA   HA DA MA   NA ZHA RA
KA RA MA   FA 'A LA   GHA SA MA
SYA HA DA   JA 'A LA   MA HA NA
JA BA LA   TSA QA BA   WA THA RA
HA ZA MA   NA ZA LA   QA WA MA
HA ZA NA   WA 'A DA   KA RA HA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 29',
        },
        {
          'number': 30,
          'title': 'Hal 30 - Huruf Hamzah',
          'arabic': '''ءَ هَ
نَ ءَ   ءَ هَ   هَ ءَ
جَ ءَ   رَ ءَ   سَ ءَ
لَ ءَ   فَ ءَ   مَ ءَ
ءَ جَ لَ         اَ مَ نَ
مَ لَ ءَ         اَ خَ ذَ
سَ ءَ لَ         نَ دَ هَ''',
          'transliteration': '''A HA
NA A     A HA     HA A
JA A     RA A     SA A
LA A     FA A     MA A
LA JA A         A MA NA
MA LA A         A KHA DZA
SA A LA         NA DA HA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 30',
        },
        {
          'number': 31,
          'title': 'Hal 31 - Huruf Ya',
          'arabic': '''يَ ءَ مَ
يَ ءَ   يَ مَ   مَ يَ
يَ رَ   وَ يَ   هَ يَ
قَ يَ   صَ يَ   فَ يَ
يَ سَ رَ         قَ يَ مَ
يَ زَ دَ         خَ يَ لَ
يَ شَ ءَ         عَ يَ مَ''',
          'transliteration': '''YA A MA
YA A     YA MA     MA YA
YA RA     WA YA     HA YA
QA YA     SHA YA     FA YA
YA SA RA         QA YA MA
YA ZA DA         KHA YA LA
YA SYA A         \'A YA MA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 31',
        },
        {
          'number': 32,
          'title': 'Hal 32 - Latihan 1',
          'arabic': '''فَ رَ غَ   فَ قَ رَ   صَ دَ قَ
سَ لَ كَ   كَ لَ مَ   شَ جَ رَ
نَ وَ لَ   هَ وَ نَ   فَ عَ لَ
اَ مَ نَ   اَ طَ عَ   جَ دَ لَ
سَ عَ دَ   شَ قَ يَ   عَ ذَ بَ''',
          'transliteration': '''FA RA GHA     FA QA RA     SHA DA QA
SA LA KA     KA LA MA     SYA JA RA
NA WA LA     HA WA NA     FA \'A LA
A MA NA     A THA \'A     JA DA LA
SA \'A DA     SYA QA YA     \'A DZA BA
A BA TA TSA JA HA KHA DA DZA RA
ZA SA SYA SHA DHA THA ZHA \'A GHA FA
QA KA LA MA NA WA HA LA A YA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 32',
        },
        {
          'number': 33,
          'title': 'Hal 33 - Latihan 9',
          'arabic': '''بَ تَ ثَ = بَتَثَ
بَبَتَ   تَبَثَ   ثَبَتَ
اَثَبَ   بَدَرَ   ثَبَرَ
وَثَقَ   تَرَكَ   بَرَزَ
بَثَطَ   تَزَمَ   رَثَتَ
تَرَكَ   تَثَرَ   رَتَبَ
بَتَمَ   طَبَرَ   رَتَبَ
وَثَبَ   بَرَرَ   دَبَرَ''',
          'transliteration': '''BA TA TSA = BA TA TSA
BA BA TA   TA BA TSA   TSA BA TA
A TSA BA   BA DA RA   TSA BA RA
WA TSA QA   TA RA KA   BA RA ZA
BA TSA THA   TA ZA MA   RA TSA TA
TA RA KA   TA TSA RA   RA TA BA
BA TA MA   THA BA RA   RA TA BA
WA TSA BA   BA RA RA   DA BA RA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 33',
        },
        {
          'number': 34,
          'title': 'Hal 34 - Latihan 10',
          'arabic': '''جَ حَ خَ = جَحَخَ
خَزَنَ   جَرَحَ   حَجَمَ
حَجَرَ   اَخَذَ   خَرَجَ
حَجَبَ   بَحَثَ   خَطَبَ
تَحَجَ   حَجَجَ   اَجَجَ
تَجَخَ   وَجَدَ   زَحَنَ
ثَجَجَ   حَرَزَ   حَجَبَ''',
          'transliteration': '''JA HA KHA = JA HA KHA
KHA ZA NA   JA RA HA   HA JA MA
HA JA RA   A KHA DZA   KHA RA JA
HA JA BA   BA HA TSA   KHA THA BA
TA HA JA   HA JA JA   A JA JA
TA JA KHA   WA JA DA   ZA HA NA
TSA JA JA   HA RA ZA   HA JA BA
104   102   103   101   100   90''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 34',
        },
        {
          'number': 35,
          'title': 'Hal 35 - Latihan 11',
          'arabic': '''سَ شَ = سَشَ
سَرَحَ   شَجَرَ   سَرَجَ
حَسَبَ   بَشَرَ   رَسَبَ
خَرَسَ   حَسَدَ   خَشَرَ
اَشَرَ   سَوَلَ   سَحَبَ
سَرَدَ   رَشَدَ   دَرَسَ
سَحَرَ   رَسَحَ   شَطَبَ''',
          'transliteration': '''SA SYA = SA SYA
SA RA HA   SYA JA RA   SA RA JA
HA SA BA   BA SYA RA   RA SA BA
KHA RA SA   HA SA DA   KHA SYA RA
A SYA RA   SA WA LA   SA HA BA
SA RA DA   RA SYA DA   DA RA SA
SA HA RA   RA SA HA   SYA THA BA
600   500   400   300   200   100''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 35',
        },
        {
          'number': 36,
          'title': 'Hal 36 - Latihan 12',
          'arabic': '''صَ ضَ = صَضَ
صَرَحَ   حَصَرَ   خَرَبَ
صَحَبَ   صَبَرَ   ضَحَنَ
حَضَنَ   حَصَدَ   ضَبَطَ
صَوَبَ   وَضَحَ   جَحَصَ
نَصَبَ   صَحَبَ   اَضَبَ
خَبَضَ   رَضَبَ   طَحَضَ''',
          'transliteration': '''SHA DHA = SHA DHA
SHA RA HA   HA SHA RA   KHA RA BA
SHA HA BA   SHA BA RA   DHA HA NA
HA DHA NA   HA SHA DA   DHA BA THA
SHA WA BA   WA DHA HA   JA HA SHA
NA SHA BA   SHA HA BA   A DHA BA
KHA BA DHA   RA DHA BA   THA HA DHA
1000   700   800   900''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 36',
        },
        {
          'number': 37,
          'title': 'Hal 37 - Latihan 13',
          'arabic': '''عَ عَ عَ = عَعَعَ
غَ غَ غَ = غَغَغَ
عَجَبَ   شَعَرَ   عَزَمَ
غَبَرَ   غَرَقَ   بَسَغَ
صَعَدَ   عَجَزَ   وَدَعَ
بَغَدَ   تَسَغَ   سَعَدَ
عَرَفَ   رَفَعَ   رَجَعَ
غَدَقَ   بَغَو   تَبَغَ''',
          'transliteration': """'A 'A 'A = 'A 'A 'A
GHA GHA GHA = GHA GHA GHA
'A JA BA   SYA 'A RA   'A ZA MA
GHA BA RA   GHA RA QA   BA SA GHA
SHA 'A DA   'A JA ZA   WA DA 'A
BA GHA DA   TA SA GHA   SA 'A DA
'A RA FA   RA FA 'A   RA JA 'A
GHA DA QA   BA GHA WA   TA BA GHA""",
          'desc': 'Latihan Tilawati Jilid 1 Halaman 37',
        },
        {
          'number': 38,
          'title': 'Hal 38 - Latihan 14',
          'arabic': '''فَ فَ فَ = فَفَفَ
قَ قَ قَ = قَقَقَ
فَرَحَ   فَرَجَ   قَدَرَ
فَرَقَ   سَفَرَ   قَرَمَ
قَفَرَ   قَصَرَ   صَفَرَ
فَسَقَ   قَدَرَ   رَفَعَ
حَرَقَ   قَفَصَ   فَقَضَ
شَفَقَ   تَقَعَ   رَفَقَ''',
          'transliteration': """FA FA FA = FA FA FA
QA QA QA = QA QA QA
FA RA HA   FA RA JA   QA DA RA
FA RA QA   SA FA RA   QA RA MA
QA FA RA   QA SHA RA   SHA FA RA
FA SA QA   QA DA RA   RA FA 'A
HA RA QA   QA FA SHA   FA QA DHA
SYA FA QA   TA QA 'A   RA FA QA""",
          'desc': 'Latihan Tilawati Jilid 1 Halaman 38',
        },
        {
          'number': 39,
          'title': 'Hal 39 - Latihan 15',
          'arabic': '''لَ لَ لَ = لَلَلَ
حَلَمَ   سَلَمَ   لَمَسَ
جَعَلَ   خَبَلَ   لَشَدَ
عَلَقَ   خَلَقَ   عَظَمَ
غَلَبَ   بَلَعَ   غَرَمَ
سَمَعَ   بَلَغَ   عَجَلَ
طَلَبَ   ثَلَثَ   حَلَمَ
حَرَمَ   مَلَحَ   دَخَلَ''',
          'transliteration': '''LA LA LA = LA LA LA
HA LA MA   SA LA MA   LA MA SA
JA 'A LA   KHA BA LA   LA SYA DA
'A LA QA   KHA LA QA   'A ZHA MA
GHA LA BA   BA LA 'A   GHA RA MA
SA MA 'A   BA LA GHA   'A JA LA
THA LA BA   TSA LA TSA   HA LA MA
HA RA MA   MA LA HA   DA KHA LA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 39',
        },
        {
          'number': 40,
          'title': 'Hal 40 - Latihan 16',
          'arabic': '''كَ = كَ = كَ = كَمَلَ حَكَمَ
كَرَمَ   شَكَرَ   تَرَكَ
مَلَكَ   كَلَمَ   ذَكَرَ
كَسَرَ   كَسَبَ   فَلَكَ
كَذَبَ   كَسَدَ   كَبَرَ
كَرَمَ   رَكَبَ   بَرَكَ
كَتَبَ   سَلَكَ   هَلَكَ
كَبَرَ   كَمَلَ   بَكَرَ''',
          'transliteration': '''KA = KA = KA = KA MA LA HA KA MA
KA RA MA   SYA KA RA   TA RA KA
MA LA KA   KA LA MA   DZA KA RA
KA SA RA   KA SA BA   FA LA KA
KA DZA BA   KA SA DA   KA BA RA
KA RA MA   RA KA BA   BA RA KA
KA TA BA   SA LA KA   HA LA KA
KA BA RA   KA MA LA   BA KA RA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 40',
        },
        {
          'number': 41,
          'title': 'Hal 41 - Latihan 17',
          'arabic': '''نَ = نَ = نَزَلَ
نَصَرَ   صَنَعَ   حَضَنَ
فَنَدَ   نَفَقَ   حَسَنَ
نَبَذَ   بَدَنَ   غَنَمَ
نَعَمَ   قَنَتَ   جَنَبَ
نَفَرَ   مَنَتَ   فَتَنَ
سَنَدَ   فَنَنَ   نَفَسَ
نَذَرَ   مَنَعَ   نَظَرَ''',
          'transliteration': '''NA = NA = NA ZA LA
NA SHA RA   SHA NA 'A   HA DHA NA
FA NA DA   NA FA QA   HA SA NA
NA BA DZA   BA DA NA   GHA NA MA
NA 'A MA   QA NA TA   JA NA BA
NA FA RA   MA NA TA   FA TA NA
SA NA DA   FA NA NA   NA FA SA
NA DZA RA   MA NA 'A   NA ZHA RA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 41',
        },
        {
          'number': 42,
          'title': 'Hal 42 - Latihan 18',
          'arabic': '''هَ = هَ = هَ = هَ = فَهَدَ
هَلَكَ   شَهَدَ   كَرَهَ
جَهَدَ   هَرَبَ   نَهَرَ
هَذَلَ   لَهَبَ   فَقَهَ
سَفَهَ   هَدَيَ   بَهَجَ
مَهَيَ   شَهَقَ   نَزَهَ
وَهَمَ   ظَهَرَ   بَنَهَ
شَهَبَ   جَهَلَ   فَهَدَ''',
          'transliteration': '''HA = HA = HA = HA = FA HA DA
HA LA KA   SYA HA DA   KA RA HA
JA HA DA   HA RA BA   NA HA RA
HA DZA LA   LA HA BA   FA QA HA
SA FA HA   HA DA YA   BA HA JA
MA HA YA   SYA HA QA   NA ZA HA
WA HA MA   ZHA HA RA   BA NA HA
SYA HA BA   JA HA LA   FA HA DA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 42',
        },
        {
          'number': 43,
          'title': 'Hal 43 - Latihan 19',
          'arabic': '''ءَ = أَ = ـئَـ   سَأَلَ
يَ = يـَ   يَئَمَ
أَدَمَ   يَسَرَ   فَئَدَ
سَئَمَ   أَجَلَ   عَصَيَ
خَيَرَ   بَيَنَ   أَلَمَ
دَيَرَ   أَدَبَ   بَئَسَ
يَلَدَ   سَيَرَ   خَطَيَ
سَئَرَ   لَخَذَ   دَأَبَ
أَخَذَ   يَتَمَ   بَيَعَ''',
          'transliteration': '''A = A = A   SA A LA
YA = YA   YA YA MA
A DA MA   YA SA RA   FA A DA
SA A MA   A JA LA   'A SHA YA
KHA YA RA   BA YA NA   A LA MA
DA YA RA   A DA BA   BA A SA
YA LA DA   SA YA RA   KHA THA YA
SA A RA   YA KHA DZA   DA A BA
A KHA DZA   YA TA MA   BA YA 'A''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 43',
        },
        {
          'number': 44,
          'title': 'Hal 44 - Latihan 20',
          'arabic': '''عَلَمَ وَحَكَمَ   رَءَفَ وَرَحَمَ
غَفَرَ وَشَكَرَ   شَهَدَ وَمَجَدَ
سَمَعَ وَبَصَرَ   عَذَبَ وَحَدَقَ
صَعَدَ وَزَلَقَ   ظَهَرَ وَطَبَقَ
عَمَلَ وَصَلَحَ   فَخَرَ وَذَنَبَ
بَشَرَ وَنَذَرَ   ضَلَلَ وَمَيَنَ
عَزَزَ وَحَلَمَ   شَهَبَ وَثَقَبَ
كَتَبَ وَمَبَنَ   عَذَبَ وَمَهَنَ''',
          'transliteration': ''''A LA MA WA HA KA MA   RA A FA WA RA HA MA
GHA FA RA WA SYA KA RA   SYA HA DA WA MA JA DA
SA MA 'A WA BA SHA RA   'A DZA BA WA HA DA QA
SHA 'A DA WA ZA LA QA   ZHA HA RA WA THA BA QA
'A MA LA WA SHA LA HA   FA KHA RA WA DZA NA BA
BA SYA RA WA NA DZA RA   DHA LA LA WA MA YA NA
'A ZA ZA WA HA LA MA   SYA HA BA WA TSA QA BA
KA TA BA WA BA YA NA   'A DZA BA WA MA HA NA''',
          'desc': 'Latihan Tilawati Jilid 1 Halaman 44',
        },
      ],
    },
    {
      'jilid': 2,
      'title': 'Jilid 2 - Huruf Sambung',
      'description': 'Membaca huruf sambung dan kata sederhana',
      'icon': Icons.auto_stories_rounded,
      'color': const Color(0xFF0D47A1),
      'lessons': [
        {
          'number': 1,
          'title': 'Huruf Sambung Awal',
          'arabic': 'بَتَ نَصَرَ كَتَبَ',
          'transliteration': 'BATA NASHARA KATABA',
          'desc': 'Membaca huruf sambung di awal kata',
        },
        {
          'number': 2,
          'title': 'Huruf Sambung Tengah',
          'arabic': 'سَمِعَ عَلِمَ فَهِمَ',
          'transliteration': "SAMI'A 'ALIMA FAHIMA",
          'desc': 'Membaca huruf sambung di tengah kata',
        },
        {
          'number': 3,
          'title': 'Huruf Sambung Akhir',
          'arabic': 'ذَهَبَ حَسُنَ كَرُمَ',
          'transliteration': 'DZAHABA HASUNA KARUMA',
          'desc': 'Membaca huruf sambung di akhir kata',
        },
        {
          'number': 4,
          'title': 'Kata dengan Tanwin',
          'arabic': 'كِتَابًا عِلْمًا نُوْرًا',
          'transliteration': "KITAABAN 'ILMAN NUURAN",
          'desc': 'Membaca kata dengan tanwin',
        },
      ],
    },
    {
      'jilid': 3,
      'title': 'Jilid 3 - Mad & Sukun',
      'description': 'Hukum mad (panjang) dan sukun',
      'icon': Icons.school_rounded,
      'color': const Color(0xFF4A148C),
      'lessons': [
        {
          'number': 1,
          'title': "Mad Asli (Mad Thabi'i)",
          'arabic': 'قَالَ - كِيْلَ - يَقُوْلُ',
          'transliteration': 'QAALA - KIILA - YAQUULU',
          'desc': 'Membaca mad asli dengan panjang 2 harakat',
        },
        {
          'number': 2,
          'title': 'Sukun dan Qalqalah',
          'arabic': 'اَلْحَمْدُ - يَبْدَأُ',
          'transliteration': 'ALHAMDU - YABDA-U',
          'desc': 'Huruf sukun dan qalqalah',
        },
        {
          'number': 3,
          'title': 'Tasydid',
          'arabic': 'إِنَّ - أَنَّ - رَبَّكَ',
          'transliteration': 'INNA - ANNA - RABBAKA',
          'desc': 'Membaca huruf bertasydid',
        },
      ],
    },
    {
      'jilid': 4,
      'title': 'Jilid 4 - Hukum Nun & Mim',
      'description': 'Idzhar, Idgham, Ikhfa, dan Iqlab',
      'icon': Icons.mosque_rounded,
      'color': const Color(0xFFBF360C),
      'lessons': [
        {
          'number': 1,
          'title': 'Nun Sukun - Idzhar',
          'arabic': "مَنْ أَعْطَى - مِنْ عِلْمٍ",
          'transliteration': "MAN A'THA - MIN 'ILMIN",
          'desc': 'Nun sukun bertemu huruf halqi',
        },
        {
          'number': 2,
          'title': 'Nun Sukun - Idgham',
          'arabic': 'مَنْ يَعْمَلْ - مِنْ وَلِيٍّ',
          'transliteration': "MAY YA'MAL - MIW WALIYYIN",
          'desc': 'Nun sukun bertemu huruf idgham',
        },
        {
          'number': 3,
          'title': 'Nun Sukun - Ikhfa',
          'arabic': 'مِنْ قَبْلِ - أَنْتُمْ',
          'transliteration': 'MIN QABLI - ANTUM',
          'desc': 'Nun sukun bertemu huruf ikhfa',
        },
      ],
    },
    {
      'jilid': 5,
      'title': 'Jilid 5 - Waqaf & Ibtida',
      'description': 'Tanda berhenti dan cara memulai bacaan',
      'icon': Icons.bookmark_rounded,
      'color': const Color(0xFF006064),
      'lessons': [
        {
          'number': 1,
          'title': 'Waqaf Lazim',
          'arabic': 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ ۝',
          'transliteration': 'BISMILLAHIRRAHMANIRRAHIIM',
          'desc': 'Berhenti pada tanda waqaf lazim',
        },
        {
          'number': 2,
          'title': 'Waqaf Ja\'iz',
          'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
          'transliteration': "ALHAMDULILLAHI RABBIL 'AALAMIIN",
          'desc': 'Berhenti pada tanda waqaf ja\'iz',
        },
      ],
    },
    {
      'jilid': 6,
      'title': 'Jilid 6 - Gharib & Musykilat',
      'description': 'Bacaan-bacaan asing dan sulit dalam Al-Qur\'an',
      'icon': Icons.star_rounded,
      'color': const Color(0xFFFF6F00),
      'lessons': [
        {
          'number': 1,
          'title': 'Saktah',
          'arabic': 'عِوَجَا ۜ قَيِّمًا',
          'transliteration': 'IWAJA (saktah) QAYYIMAN',
          'desc': 'Berhenti sejenak tanpa bernapas',
        },
        {
          'number': 2,
          'title': 'Isymam & Imalah',
          'arabic': 'لَا تَأْمَ۪نَّا',
          'transliteration': "LAA TA'MANNAA",
          'desc': 'Bacaan isymam dan imalah',
        },
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 14,
                        color: color,
                      ),
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
            gradient: LinearGradient(colors: [color, color.withOpacity(0.8)]),
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
