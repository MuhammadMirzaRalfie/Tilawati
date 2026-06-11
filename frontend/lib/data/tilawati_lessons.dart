import 'package:flutter/material.dart';

/// Data statis jilid & pelajaran Tilawati (sinkron dengan backend ai_service.py).
/// Diekstrak dari jilid_selection_screen agar bisa dipakai lintas layar
/// (mis. kartu "Lanjutkan Latihan" di Beranda).
final List<Map<String, dynamic>> kJilids = [
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
BA BA BA     A A A
A BA A     BA BA A
BA A BA     A BA BA''',
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
BA TA TA     TA BA TA
BA A TA     TA A BA
A BA TA     A TA BA
BA BA TA     TA TA BA''',
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
BA TA TSA     TSA TSA BA
TA TSA TA     TSA BA TA
BA A TSA     TA A TSA
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
          'transliteration': '''JA HHA
JA HHA     HHA HHA     JA JA
TA HHA     BA JA     TSA JA
TSA HHA     JA HHA     HHA TA
A HHA HHA     HHA JA BA
HHA TA TSA     BA HHA TA
HHA TSA JA     JA BA HHA''',
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
          'transliteration': '''KHO BA TSA
BA KHO     KHO BA     KHO KHO
KHO KHO     HHA KHO     JA KHO
TSA KHO TA     BA TA KHO
HHA KHO TSA     BA HHA TSA
KHO JA HHA     KHO KHO JA
BA KHO TSA     KHO BA JA''',
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
          'transliteration': '''A TA JA     TA JA TSA     KHO JA BA
TSA HHA JA     BA KHO TSA     TSA JA HHA
HHA JA BA     TSA KHO TSA     JA JA TA
A JA KHO     JA KHO TA     BA JA TSA
JA A BA     KHO TSA HHA     BA KHO JA
TA A KHO     JA TSA TA     BA KHO JA
BA HHA TSA     A HHA BA     KHO JA BA''',
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
          'transliteration': '''HHA KHO DA
KHO DA     HHA DA     DA DA
DA JA     DA KHO     DA HHA
TA DA     KHO DA     TSA DA
DA DA JA     DA DA KHO
KHO DA HHA     HHA DA KHO
TA DA HHA     TSA DA KHO''',
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
          'transliteration': '''KHO DA DZA
DZA KHO     DZA DA     DZA DZA
JA DZA     KHO DZA     HHA DZA
DZA TA     BA DZA     DZA TSA
DA DZA HHA     DZA DA HHA
KHO DZA TSA     HHA BA DZA
TSA JA DZA     TA KHO DZA''',
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
          'transliteration': '''RO ZAY
ZAY RO     DZA RO     RO ZAY
KHO ZAY     DA ZAY     HHA ZAY
DZA ZAY     JA RO     RO RO
ZAY RO DA     DZA RO ZAY
ZAY KHO RO     DZA HHA ZAY
HHA DZA RO     KHO ZAY RO''',
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
          'transliteration': '''ZAY SA
SA ZAY     SA RO     SA SA
ZAY SA     DZA SA     DA SA
SA KHO     SA HHA     SA JA
SA JA DA     SA RO DA
HHA SA DA     KHO SA RO
TA KHO SA     DA RO SA''',
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
          'transliteration': '''SYA RO HHA
SYA HHA     SYA RO     SYA SYA
HHA SYA     DZA SYA     DA SA
SYA DZA     SA ZAY     SYA KHO
SYA SA KHO     SYA JA SA
SYA KHO RO     KHO SA RO
SYA RO HHA     SYA JA RO''',
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
          'transliteration': '''SA JA DA     SA RO DA     DZA DA KHO
HHA SA DA     KHO SA RO     HHA DZA BA
TSA KHO SA     DA RO SA     TA KHO DZA
SA SYA JA     RO ZAY DA     DA DZA HHA
DZA HHA SYA     HHA DZA RO     KHO DA TSA
KHO SA DA     ZAY HHA RO     TSA JA DA
KHO SA RO     DA RO SA     SA RO DA
SYA RO HHA     RO SYA DA     SYA JA RO''',
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
          'transliteration': '''SHO HHA BA
SHO KHO     SHO HHA     SHO SHO
DZA SHO     SA SHO     RO SHO
SHO RO     SHO KHO     SHO BA
SHO BA RO     SHO DA BA
HHA SHO BA     JA TA SHO
HHA SHO DZA     HHA SHO DA''',
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
          'transliteration': '''DHO RO BA
DHO BA     DHO RO     DHO DHO
SHO DHO     DZA DHO     RO DHO
DHO HHA     ZAY DHO     DHO KHO
DHO BA RO     DHO RO BA
SYA RO DHO     HHA DHO RO
SHO SHO DHO     TA BA DHO''',
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
          'transliteration': '''THO BA KHO
THO SHO     THO DHO     THO THO
SYA THO     SHO THO     SA THO
THO DA     DZA THO     THO RO
HHA THO BA     THO BA KHO
THO ZAY DHO     SHO TA THO
HHA THO SA     SYA THO DA''',
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
          'transliteration': '''ZHO SHO
THO ZHO     ZHO SHO     ZHO ZHO
SHO THO     ZAY ZHO     SYA ZHO
ZHO DA     ZHO SA     ZHO THO
SA ZHO KHO     ZHO BA THO
SHO ZHO BA     SHO HHA ZHO
HHA BA ZHO     LA ZHO BA''',
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
          'transliteration': """AIN THO BA
AIN SHO     AIN THO     AIN ZHO
AIN ZHO     DHO AIN     SYA AIN
AIN DA     DZA AIN     AIN ZAY
AIN THO SYA     DZA AIN ZHO
ZHO AIN DHO     SA SHO AIN
AIN ZHO BA     HHA AIN SHO""",
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
          'transliteration': '''RO THO BA     SYA THO THO     SHO BA RO
AIN THO SA     ZHO BA THO     THO RO DA
THO RO DA     A ZHO BA     HHA SHO DA
SYA RO AIN     BA THO RO     HHA DHO RO
BA SYA RO     AIN JA BA     KHO THO BA
A TSA RO     ZAY RO AIN     BA RO DA
SYA RO BA     SA JA DA     TA BA AIN
AIN RO DHO     DHO RO BA     AIN DHO BA''',
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
          'transliteration': """AIN GHO
GHO AIN     GHO AIN     GHO GHO
SHO AIN     GHO ZHO     THO GHO
KHO GHO     SYA GHO     GHO DHO
SYA GHO RO     GHO BA RO
GHO SA THO     BA GHO SA
GHO RO BA     GHO DHO BA""",
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
          'transliteration': """GHO FA
FA AIN     FA GHO     FA FA
SHO FA     ZHO FA     GHO FA
FA DZA     FA SYA     FA DHO
SHO FA HHA     FA ZAY DA
AIN RO FA     AIN DHO FA
ZHO AIN FA     FA SYA JA""",
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
          'transliteration': '''FA QO
QO AIN     QO FA     FA QO
THO QO     AIN QO     FA QO
THO QO     FA ZHO     QO DHO
AIN QO BA     QO FA ZHO
ZAY AIN FA     GHO DA QO
GHO RO QO     FA QO RO''',
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
          'transliteration': """FA QO RO     GHO DA QO     AIN RO DHO
FA QO DA     RO FA QO     AIN RO FA
QO TA DA     RO ZAY QO     ZAY RO AIN
QO RO BA     SA RO QO     RO FA TSA
AIN DA BA     GHO RO BA     SYA FA AIN
HHA THO ZHO     SYA HHA DA     A TSA RO
HHA FA ZHO     JA RO DA     ZHO FA RO
GHO SA QO     AIN ZAY ZAY     KHO RO JA""",
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
          'transliteration': '''KA FA RO
KA QO     FA KA     KA KA
GHO KA     QO KA     FA KA
KA SHO     KA DHO     KA GHO
QO SA KA     KA FA RO
BA RO KA     AIN KA FA
SA RO KA     KA BA DA''',
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
QO LA     LA FA     LA SYA
DHO LA     LA KHO     KA LA
LA DHO     FA LA     AIN LA
LA QO BA     AIN DA LA
FA LA HHA     JA AIN LA
KHO LA QO     GHO ZAY LA''',
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
KA QO     FA KA     KA KA
QO LA     LA FA     LA SA
LA MA     MA DHO     RO MA
FA LA MA     RO GHO MA     QO MA RO
AIN ZHO MA     MA ZAY QO     KA RO MA
THO MA SA     RO JA MA     MA RO HHA''',
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
          'transliteration': '''NA LA
KHO NA     BA NA     NA LA
NA JA     FA NA     KA NA
NA SHO     NA DA     DA NA
QO RO NA     NA SHO RO     FA NA DA
JA NA BA     NA ZHO MA     DHO MA NA
HHA SA NA     NA KHO LA     HHA DHO NA''',
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
          'transliteration': '''WA QO FA
QO WA     WA FA     WA QO
WA MA     NA WA     RO WA
THO WA     SHO WA     WA LA
SHO WA BA     WA QO RO
WA RO DA     SA QO WA
ZAY WA LA     WA JA LA''',
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
          'transliteration': '''WA     HA
WA HA     HA RO     HA DA
HA RO     SYA HA     JA HA
HA MA     NA HA     HA WA
WA HA NA     HA DA BA
SYA HA DA     JA HA DA
WA HA BA     DA HA QO''',
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
          'transliteration': '''FA HA DA     KA LA MA     HA LA KA
NA ZHO RO     HA DA MA     HHA SHO LA
GHO SA MA     FA AIN LA     KA RO MA
MA HA NA     JA AIN LA     SYA HA DA
WA THO RO     TSA QO BA     JA BA LA
QO WA MA     NA ZAY LA     HA ZAY MA
KA RO HA     WA AIN DA     HHA ZAY NA''',
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
HA A     A HA     NA A
SA A     RO A     JA A
MA A     FA A     LA A
A MA NA     A JA LA
A KHO DZA     MA LA A
NA DA HA     SA A LA''',
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
MA YA     YA MA     YA A
HA YA     WA YA     YA RO
FA YA     SHO YA     QO YA
QO YA MA     YA SA RO
KHO YA LA     YA ZAY DA
AIN YA MA     YA SYA A''',
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
          'transliteration': '''SHO DA QO     FA QO RO     FA RO GHO
SYA JA RO     KA LA MA     SA LA KA
FA AIN LA     HA WA NA     NA WA LA
JA DA LA     A THO AIN     A MA NA
AIN DZA BA     SYA QO YA     SA AIN DA''',
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
TSA BA TA     TA BA TSA     BA BA TA
TSA BA RO     BA DA RO     A TSA BA
BA RO ZAY     TA RO KA     WA TSA QO
RO TSA TA     TA ZAY MA     BA TSA THO
RO TA BA     TA TSA RO     TA RO KA
RO TA BA     THO BA RO     BA TA MA
DA BA RO     BA RO RO     WA TSA BA''',
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
          'transliteration': '''JA HHA KHO = JA HHA KHO
HHA JA MA     JA RO HHA     KHO ZAY NA
KHO RO JA     A KHO DZA     HHA JA RO
KHO THO BA     BA HHA TSA     HHA JA BA
A JA JA     HHA JA JA     TA HHA JA
ZAY HHA NA     WA JA DA     TA JA KHO
HHA JA BA     HHA RO ZAY     TSA JA JA''',
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
SA RO JA     SYA JA RO     SA RO HHA
RO SA BA     BA SYA RO     HHA SA BA
KHO SYA RO     HHA SA DA     KHO RO SA
SA HHA BA     SA WA LA     A SYA RO
DA RO SA     RO SYA DA     SA RO DA
SYA THO BA     RO SA HHA     SA HHA RO''',
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
          'transliteration': '''SHO DHO = SHO DHO
KHO RO BA     HHA SHO RO     SHO RO HHA
DHO HHA NA     SHO BA RO     SHO HHA BA
DHO BA THO     HHA SHO DA     HHA DHO NA
JA HHA SHO     WA DHO HHA     SHO WA BA
A DHO BA     SHO HHA BA     NA SHO BA
THO HHA DHO     RO DHO BA     KHO BA DHO''',
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
          'transliteration': """AIN AIN AIN = AIN AIN AIN
GHO GHO GHO = GHO GHO GHO
AIN ZAY MA     SYA AIN RO     AIN JA BA
BA SA GHO     GHO RO QO     GHO BA RO
WA DA AIN     AIN JA ZAY     SHO AIN DA
SA AIN DA     TA SA GHO     BA GHO DA
RO JA AIN     RO FA AIN     AIN RO FA
TA BA GHO     BA GHO WA     GHO DA QO""",
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
QO QO QO = QO QO QO
QO DA RO     FA RO JA     FA RO HHA
QO RO MA     SA FA RO     FA RO QO
SHO FA RO     QO SHO RO     QO FA RO
RO FA AIN     QO DA RO     FA SA QO
FA QO DHO     QO FA SHO     HHA RO QO
RO FA QO     TA QO AIN     SYA FA QO""",
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
LA MA SA     SA LA MA     HHA LA MA
LA SYA DA     KHO BA LA     JA AIN LA
AIN ZHO MA     KHO LA QO     AIN LA QO
GHO RO MA     BA LA AIN     GHO LA BA
AIN JA LA     BA LA GHO     SA MA AIN
HHA LA MA     TSA LA TSA     THO LA BA
DA KHO LA     MA LA HHA     HHA RO MA''',
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
          'transliteration': '''KA = KA = KA = KA MA LA HHA KA MA
TA RO KA     SYA KA RO     KA RO MA
DZA KA RO     KA LA MA     MA LA KA
FA LA KA     KA SA BA     KA SA RO
KA BA RO     KA SA DA     KA DZA BA
BA RO KA     RO KA BA     KA RO MA
HA LA KA     SA LA KA     KA TA BA
BA KA RO     KA MA LA     KA BA RO''',
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
          'transliteration': '''NA = NA = NA ZAY LA
HHA DHO NA     SHO NA AIN     NA SHO RO
HHA SA NA     NA FA QO     FA NA DA
GHO NA MA     BA DA NA     NA BA DZA
JA NA BA     QO NA TA     NA AIN MA
FA TA NA     MA NA TA     NA FA RO
NA FA SA     FA NA NA     SA NA DA
NA ZHO RO     MA NA AIN     NA DZA RO''',
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
KA RO HA     SYA HA DA     HA LA KA
NA HA RO     HA RO BA     JA HA DA
FA QO HA     LA HA BA     HA DZA LA
BA HA JA     HA DA YA     SA FA HA
NA ZAY HA     SYA HA QO     MA HA YA
BA NA HA     ZHO HA RO     WA HA MA
FA HA DA     JA HA LA     SYA HA BA''',
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
          'transliteration': '''SA A LA     A = A =  A 
YA A MA     YA = YA 
FA A DA     YA SA RO     A DA MA
AIN SHO YA     A JA LA     SA A MA
A LA MA     BA YA NA     KHO YA RO
BA A SA     A DA BA     DA YA RO
KHO THO YA     SA YA RO     YA LA DA
DA A BA     LA KHO DZA     SA A RO
BA YA AIN     YA TA MA     A KHO DZA''',
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
          'transliteration': '''RO A FA WA RO HHA MA     AIN LA MA WA HHA KA MA
SYA HA DA WA MA JA DA     GHO FA RO WA SYA KA RO
AIN DZA BA WA HHA DA QO     SA MA AIN WA BA SHO RO
ZHO HA RO WA THO BA QO     SHO AIN DA WA ZAY LA QO
FA KHO RO WA DZA NA BA     AIN MA LA WA SHO LA HHA
DHO LA LA WA MA YA NA     BA SYA RO WA NA DZA RO
SYA HA BA WA TSA QO BA     AIN ZAY ZAY WA HHA LA MA
AIN DZA BA WA MA HA NA     KA TA BA WA MA BA NA''',
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
