"""
AI Service - Placeholder for Contrastive Learning & Forced Alignment

This module will eventually integrate:
1. Forced Alignment: Phoneme-level alignment of recorded audio with reference text
2. Contrastive Learning: Quality comparison between user's reading and reference readings

For now, it generates mock evaluation scores for development purposes.
"""

import random
import uuid
import re
from typing import Any


# Data konten Tilawati Jilid 1
TILAWATI_CONTENT = {
    1: {
        "title": "Jilid 1 - Huruf Hijaiyah",
        "description": "Pengenalan huruf hijaiyah dan harakat fathah",
        "icon": "menu_book",
        "color": "#1B5E20",
        "lessons": [
            {
                        "lesson_number": 1,
                        "title": "Hal 1 - Huruf Alif & Ba",
                        "arabic_text": "اَ بَ\nاَ اَ   بَ بَ   اَ بَ\nبَ اَ   اَ بَ   اَ بَ\nاَ اَ اَ         بَ بَ بَ\nبَ بَ اَ         اَ بَ اَ\nاَ بَ بَ         بَ اَ بَ",
                        "transliteration": "A BA\nA BA     BA BA     A A\nA BA     A BA     BA A\nBA BA BA     A A A\nA BA A     BA BA A\nBA A BA     A BA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 1"
            },
            {
                        "lesson_number": 2,
                        "title": "Hal 2 - Huruf Ta",
                        "arabic_text": "بَ تَ\nبَ تَ   تَ بَ   اَ تَ\nتَ تَ   تَ بَ   تَ اَ\nتَ بَ تَ         بَ تَ تَ\nتَ اَ بَ         بَ اَ تَ\nاَ تَ بَ         اَ بَ تَ\nتَ تَ بَ         بَ بَ تَ",
                        "transliteration": "BA TA\nA TA     TA BA     BA TA\nTA A     TA BA     TA TA\nBA TA TA     TA BA TA\nBA A TA     TA A BA\nA BA TA     A TA BA\nBA BA TA     TA TA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 2"
            },
            {
                        "lesson_number": 3,
                        "title": "Hal 3 - Huruf Tsa",
                        "arabic_text": "تَ ثَ\nثَ ثَ   ثَ ثَ   ثَ بَ\nثَ تَ   ثَ اَ   ثَ بَ\nتَ ثَ   اَ ثَ   بَ ثَ\nثَ ثَ بَ         بَ تَ ثَ\nثَ بَ تَ         تَ ثَ تَ\nتَ اَ ثَ         بَ اَ ثَ\nثَ اَ بَ   تَ ثَ اَ   بَ تَ ثَ",
                        "transliteration": "TA TSA\nTSA BA     TSA TSA     TSA TSA\nTSA BA     TSA A     TSA TA\nBA TSA     A TSA     TA TSA\nBA TA TSA     TSA TSA BA\nTA TSA TA     TSA BA TA\nBA A TSA     TA A TSA\nBA TA TSA     TA TSA A     TSA A BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 3"
            },
            {
                        "lesson_number": 4,
                        "title": "Hal 4 - Huruf Jim & Ha",
                        "arabic_text": "جَ حَ\nجَ جَ   حَ حَ   جَ حَ\nثَ جَ   بَ جَ   تَ حَ\nحَ تَ   جَ حَ   ثَ حَ\nحَ جَ بَ         اَ حَ حَ\nبَ حَ تَ         حَ تَ ثَ\nجَ بَ حَ         حَ ثَ جَ",
                        "transliteration": "JA HHA\nJA HHA     HHA HHA     JA JA\nTA HHA     BA JA     TSA JA\nTSA HHA     JA HHA     HHA TA\nA HHA HHA     HHA JA BA\nHHA TA TSA     BA HHA TA\nHHA TSA JA     JA BA HHA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 4"
            },
            {
                        "lesson_number": 5,
                        "title": "Hal 5 - Huruf Kha",
                        "arabic_text": "خَ بَ ثَ\nخَ خَ   خَ بَ   بَ خَ\nجَ خَ   حَ خَ   خَ خَ\nبَ تَ خَ         ثَ خَ تَ\nبَ حَ ثَ         حَ خَ ثَ\nخَ خَ جَ         خَ جَ حَ\nخَ بَ جَ         بَ خَ ثَ",
                        "transliteration": "KHO BA TSA\nBA KHO     KHO BA     KHO KHO\nKHO KHO     HHA KHO     JA KHO\nTSA KHO TA     BA TA KHO\nHHA KHO TSA     BA HHA TSA\nKHO JA HHA     KHO KHO JA\nBA KHO TSA     KHO BA JA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 5"
            },
            {
                        "lesson_number": 6,
                        "title": "Hal 6 - Latihan",
                        "arabic_text": "خَ جَ بَ   تَ جَ ثَ   اَ تَ جَ\nثَ جَ حَ   بَ خَ ثَ   ثَ حَ جَ\nجَ جَ تَ   ثَ خَ ثَ   حَ جَ بَ\nبَ جَ ثَ   جَ خَ تَ   اَ جَ خَ\nبَ خَ جَ   خَ ثَ حَ   جَ اَ بَ\nبَ خَ جَ   جَ ثَ تَ   تَ اَ خَ\nخَ جَ بَ   اَ حَ بَ   بَ حَ ثَ",
                        "transliteration": "A TA JA     TA JA TSA     KHO JA BA\nTSA HHA JA     BA KHO TSA     TSA JA HHA\nHHA JA BA     TSA KHO TSA     JA JA TA\nA JA KHO     JA KHO TA     BA JA TSA\nJA A BA     KHO TSA HHA     BA KHO JA\nTA A KHO     JA TSA TA     BA KHO JA\nBA HHA TSA     A HHA BA     KHO JA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 6"
            },
            {
                        "lesson_number": 7,
                        "title": "Hal 7 - Huruf Dal",
                        "arabic_text": "حَ خَ دَ\nدَ دَ   حَ دَ   خَ دَ\nدَ حَ   دَ خَ   دَ جَ\nثَ دَ   خَ دَ   تَ دَ\nدَ دَ خَ         دَ دَ جَ\nحَ دَ خَ         خَ دَ حَ\nثَ دَ خَ         تَ دَ حَ",
                        "transliteration": "HHA KHO DA\nKHO DA     HHA DA     DA DA\nDA JA     DA KHO     DA HHA\nTA DA     KHO DA     TSA DA\nDA DA JA     DA DA KHO\nKHO DA HHA     HHA DA KHO\nTA DA HHA     TSA DA KHO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 7"
            },
            {
                        "lesson_number": 8,
                        "title": "Hal 8 - Huruf Dzal",
                        "arabic_text": "خَ دَ ذَ\nذَ ذَ   ذَ دَ   ذَ خَ\nحَ ذَ   خَ ذَ   جَ ذَ\nذَ ثَ   بَ ذَ   ذَ تَ\nذَ دَ حَ         دَ ذَ حَ\nحَ بَ ذَ         خَ ذَ ثَ\nتَ خَ ذَ         ثَ جَ ذَ",
                        "transliteration": "KHO DA DZA\nDZA KHO     DZA DA     DZA DZA\nJA DZA     KHO DZA     HHA DZA\nDZA TA     BA DZA     DZA TSA\nDA DZA HHA     DZA DA HHA\nKHO DZA TSA     HHA BA DZA\nTSA JA DZA     TA KHO DZA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 8"
            },
            {
                        "lesson_number": 9,
                        "title": "Hal 9 - Huruf Ra & Za",
                        "arabic_text": "رَ زَ\nرَ زَ   ذَ رَ   زَ رَ\nحَ زَ   دَ زَ   خَ زَ\nرَ رَ   جَ رَ   ذَ زَ\nذَ رَ زَ         زَ رَ دَ\nذَ حَ زَ         زَ خَ رَ\nخَ زَ رَ         حَ ذَ رَ",
                        "transliteration": "RO ZAY\nZAY RO     DZA RO     RO ZAY\nKHO ZAY     DA ZAY     HHA ZAY\nDZA ZAY     JA RO     RO RO\nZAY RO DA     DZA RO ZAY\nZAY KHO RO     DZA HHA ZAY\nHHA DZA RO     KHO ZAY RO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 9"
            },
            {
                        "lesson_number": 10,
                        "title": "Hal 10 - Huruf Sin",
                        "arabic_text": "زَ سَ\nسَ سَ   سَ رَ   سَ زَ\nدَ سَ   ذَ سَ   زَ سَ\nسَ جَ   سَ حَ   سَ خَ\nسَ رَ دَ         سَ جَ دَ\nخَ سَ رَ         حَ سَ دَ\nدَ رَ سَ         تَ خَ سَ",
                        "transliteration": "ZAY SA\nSA ZAY     SA RO     SA SA\nZAY SA     DZA SA     DA SA\nSA KHO     SA HHA     SA JA\nSA JA DA     SA RO DA\nHHA SA DA     KHO SA RO\nTA KHO SA     DA RO SA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 10"
            },
            {
                        "lesson_number": 11,
                        "title": "Hal 11 - Huruf Syin",
                        "arabic_text": "شَ رَ حَ\nشَ شَ   شَ رَ   شَ حَ\nدَ سَ   ذَ شَ   حَ شَ\nشَ خَ   سَ زَ   شَ ذَ\nشَ جَ سَ         شَ سَ خَ\nخَ سَ رَ         شَ خَ رَ\nشَ جَ رَ         شَ رَ حَ",
                        "transliteration": "SYA RO HHA\nSYA HHA     SYA RO     SYA SYA\nHHA SYA     DZA SYA     DA SA\nSYA DZA     SA ZAY     SYA KHO\nSYA SA KHO     SYA JA SA\nSYA KHO RO     KHO SA RO\nSYA RO HHA     SYA JA RO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 11"
            },
            {
                        "lesson_number": 12,
                        "title": "Hal 12 - Latihan",
                        "arabic_text": "ذَ دَ خَ   سَ رَ دَ   سَ جَ دَ\nحَ ذَ بَ   خَ سَ رَ   حَ سَ دَ\nتَ خَ ذَ   دَ رَ سَ   ثَ خَ سَ\nدَ ذَ حَ   رَ زَ دَ   سَ شَ جَ\nخَ دَ ثَ   حَ ذَ رَ   ذَ حَ شَ\nثَ جَ دَ   زَ حَ رَ   خَ سَ دَ\nسَ رَ دَ   دَ رَ سَ   خَ سَ رَ\nشَ جَ رَ   رَ شَ دَ   شَ رَ حَ",
                        "transliteration": "SA JA DA     SA RO DA     DZA DA KHO\nHHA SA DA     KHO SA RO     HHA DZA BA\nTSA KHO SA     DA RO SA     TA KHO DZA\nSA SYA JA     RO ZAY DA     DA DZA HHA\nDZA HHA SYA     HHA DZA RO     KHO DA TSA\nKHO SA DA     ZAY HHA RO     TSA JA DA\nKHO SA RO     DA RO SA     SA RO DA\nSYA RO HHA     RO SYA DA     SYA JA RO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 12"
            },
            {
                        "lesson_number": 13,
                        "title": "Hal 13 - Huruf Shad",
                        "arabic_text": "صَ حَ بَ\nصَ صَ   صَ حَ   صَ خَ\nرَ صَ   سَ صَ   ذَ صَ\nصَ بَ   صَ خَ   صَ رَ\nصَ دَ بَ         صَ بَ رَ\nجَ تَ صَ         حَ صَ بَ\nحَ صَ دَ         حَ صَ ذَ",
                        "transliteration": "SHO HHA BA\nSHO KHO     SHO HHA     SHO SHO\nDZA SHO     SA SHO     RO SHO\nSHO RO     SHO KHO     SHO BA\nSHO BA RO     SHO DA BA\nHHA SHO BA     JA TA SHO\nHHA SHO DZA     HHA SHO DA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 13"
            },
            {
                        "lesson_number": 14,
                        "title": "Hal 14 - Huruf Dhad",
                        "arabic_text": "ضَ رَ بَ\nضَ ضَ   ضَ رَ   ضَ بَ\nرَ ضَ   ذَ ضَ   صَ ضَ\nضَ خَ   زَ ضَ   ضَ حَ\nضَ رَ بَ         ضَ بَ رَ\nحَ ضَ رَ         شَ رَ ضَ\nتَ بَ ضَ         صَ صَ ضَ",
                        "transliteration": "DHO RO BA\nDHO BA     DHO RO     DHO DHO\nSHO DHO     DZA DHO     RO DHO\nDHO HHA     ZAY DHO     DHO KHO\nDHO BA RO     DHO RO BA\nSYA RO DHO     HHA DHO RO\nSHO SHO DHO     TA BA DHO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 14"
            },
            {
                        "lesson_number": 15,
                        "title": "Hal 15 - Huruf Tha",
                        "arabic_text": "طَ بَ خَ\nطَ طَ   طَ ضَ   طَ صَ\nسَ طَ   صَ طَ   شَ طَ\nطَ رَ   ذَ طَ   طَ دَ\nطَ بَ خَ         حَ طَ بَ\nصَ تَ طَ         طَ زَ ضَ\nشَ طَ دَ         حَ طَ سَ",
                        "transliteration": "THO BA KHO\nTHO SHO     THO DHO     THO THO\nSYA THO     SHO THO     SA THO\nTHO DA     DZA THO     THO RO\nHHA THO BA     THO BA KHO\nTHO ZAY DHO     SHO TA THO\nHHA THO SA     SYA THO DA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 15"
            },
            {
                        "lesson_number": 16,
                        "title": "Hal 16 - Huruf Zha",
                        "arabic_text": "ظَ صَ\nظَ ظَ   ظَ صَ   طَ ظَ\nشَ ظَ   زَ ظَ   صَ طَ\nظَ طَ   ظَ سَ   ظَ دَ\nظَ بَ طَ         سَ ظَ خَ\nصَ حَ ظَ         صَ ظَ بَ\nلَ ظَ بَ         حَ بَ ظَ",
                        "transliteration": "ZHO SHO\nTHO ZHO     ZHO SHO     ZHO ZHO\nSHO THO     ZAY ZHO     SYA ZHO\nZHO DA     ZHO SA     ZHO THO\nSA ZHO KHO     ZHO BA THO\nSHO ZHO BA     SHO HHA ZHO\nHHA BA ZHO     LA ZHO BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 16"
            },
            {
                        "lesson_number": 17,
                        "title": "Hal 17 - Huruf 'Ain",
                        "arabic_text": "عَ طَ بَ\nعَ ظَ   عَ طَ   عَ صَ\nشَ عَ   ضَ عَ   عَ ظَ\nعَ زَ   ذَ عَ   عَ دَ\nذَ عَ ظَ         عَ طَ شَ\nسَ صَ عَ         ظَ عَ ضَ\nحَ عَ صَ         عَ ظَ بَ",
                        "transliteration": "AIN THO BA\nAIN SHO     AIN THO     AIN ZHO\nAIN ZHO     DHO AIN     SYA AIN\nAIN DA     DZA AIN     AIN ZAY\nAIN THO SYA     DZA AIN ZHO\nZHO AIN DHO     SA SHO AIN\nAIN ZHO BA     HHA AIN SHO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 17"
            },
            {
                        "lesson_number": 18,
                        "title": "Hal 18 - Latihan",
                        "arabic_text": "صَ بَ رَ   شَ طَ طَ   رَ طَ بَ\nطَ رَ دَ   ظَ بَ طَ   عَ طَ سَ\nحَ صَ دَ   اَ ظَ بَ   طَ رَ دَ\nحَ ضَ رَ   بَ طَ رَ   شَ رَ عَ\nخَ طَ بَ   عَ جَ بَ   بَ شَ رَ\nبَ رَ دَ   زَ رَ عَ   اَ ثَ رَ\nتَ بَ عَ   سَ جَ دَ   شَ رَ بَ\nعَ ضَ بَ   ضَ رَ بَ   عَ رَ ضَ",
                        "transliteration": "RO THO BA     SYA THO THO     SHO BA RO\nAIN THO SA     ZHO BA THO     THO RO DA\nTHO RO DA     A ZHO BA     HHA SHO DA\nSYA RO AIN     BA THO RO     HHA DHO RO\nBA SYA RO     AIN JA BA     KHO THO BA\nA TSA RO     ZAY RO AIN     BA RO DA\nSYA RO BA     SA JA DA     TA BA AIN\nAIN RO DHO     DHO RO BA     AIN DHO BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 18"
            },
            {
                        "lesson_number": 19,
                        "title": "Hal 19 - Huruf Ghain",
                        "arabic_text": "عَ غَ\nغَ غَ   غَ عَ   غَ عَ\nطَ غَ   غَ ظَ   صَ عَ\nغَ ضَ   شَ غَ   خَ غَ\nغَ بَ رَ         شَ غَ رَ\nبَ غَ سَ         غَ سَ طَ\nغَ ضَ بَ         غَ رَ بَ",
                        "transliteration": "AIN GHO\nGHO AIN     GHO AIN     GHO GHO\nSHO AIN     GHO ZHO     THO GHO\nKHO GHO     SYA GHO     GHO DHO\nSYA GHO RO     GHO BA RO\nGHO SA THO     BA GHO SA\nGHO RO BA     GHO DHO BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 19"
            },
            {
                        "lesson_number": 20,
                        "title": "Hal 20 - Huruf Fa",
                        "arabic_text": "غَ فَ\nفَ فَ   فَ غَ   فَ عَ\nغَ فَ   ظَ فَ   صَ فَ\nفَ ضَ   فَ شَ   فَ ذَ\nفَ زَ دَ         صَ فَ حَ\nعَ ضَ فَ         عَ رَ فَ\nفَ شَ جَ         ظَ عَ فَ",
                        "transliteration": "GHO FA\nFA AIN     FA GHO     FA FA\nSHO FA     ZHO FA     GHO FA\nFA DZA     FA SYA     FA DHO\nSHO FA HHA     FA ZAY DA\nAIN RO FA     AIN DHO FA\nZHO AIN FA     FA SYA JA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 20"
            },
            {
                        "lesson_number": 21,
                        "title": "Hal 21 - Huruf Qaf",
                        "arabic_text": "فَ قَ\nفَ قَ   قَ فَ   قَ عَ\nفَ قَ   عَ قَ   طَ قَ\nقَ ضَ   فَ ظَ   طَ قَ\nقَ فَ ظَ         عَ قَ بَ\nغَ دَ قَ         زَ عَ فَ\nفَ قَ رَ         غَ رَ قَ",
                        "transliteration": "FA QO\nQO AIN     QO FA     FA QO\nTHO QO     AIN QO     FA QO\nTHO QO     FA ZHO     QO DHO\nAIN QO BA     QO FA ZHO\nZAY AIN FA     GHO DA QO\nGHO RO QO     FA QO RO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 21"
            },
            {
                        "lesson_number": 22,
                        "title": "Hal 22 - Latihan",
                        "arabic_text": "عَ رَ ضَ   غَ دَ قَ   فَ قَ رَ\nعَ رَ فَ   رَ فَ قَ   فَ قَ دَ\nزَ رَ عَ   رَ زَ قَ   قَ تَ دَ\nرَ فَ ثَ   سَ رَ قَ   قَ رَ بَ\nشَ فَ عَ   غَ رَ بَ   عَ دَ بَ\nاَ ثَ رَ   شَ حَ دَ   حَ طَ ظَ\nظَ فَ رَ   جَ رَ دَ   حَ فَ ظَ\nخَ رَ جَ   عَ زَ زَ   غَ سَ قَ",
                        "transliteration": "FA QO RO     GHO DA QO     AIN RO DHO\nFA QO DA     RO FA QO     AIN RO FA\nQO TA DA     RO ZAY QO     ZAY RO AIN\nQO RO BA     SA RO QO     RO FA TSA\nAIN DA BA     GHO RO BA     SYA FA AIN\nHHA THO ZHO     SYA HHA DA     A TSA RO\nHHA FA ZHO     JA RO DA     ZHO FA RO\nGHO SA QO     AIN ZAY ZAY     KHO RO JA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 22"
            },
            {
                        "lesson_number": 23,
                        "title": "Hal 23 - Huruf Kaf",
                        "arabic_text": "كَ فَ رَ\nكَ كَ   فَ كَ   كَ قَ\nفَ كَ   قَ كَ   غَ كَ\nكَ غَ   كَ ضَ   كَ صَ\nكَ فَ رَ         قَ سَ كَ\nعَ كَ فَ         بَ رَ كَ\nكَ بَ دَ         سَ رَ كَ",
                        "transliteration": "KA FA RO\nKA QO     FA KA     KA KA\nGHO KA     QO KA     FA KA\nKA SHO     KA DHO     KA GHO\nQO SA KA     KA FA RO\nBA RO KA     AIN KA FA\nSA RO KA     KA BA DA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 23"
            },
            {
                        "lesson_number": 24,
                        "title": "Hal 24 - Huruf Lam",
                        "arabic_text": "لَ كَ\nلَ شَ   لَ فَ   قَ لَ\nكَ لَ   لَ خَ   ضَ لَ\nعَ لَ   فَ لَ   لَ ضَ\nعَ دَ لَ         لَ قَ بَ\nجَ عَ لَ         فَ لَ حَ\nغَ زَ لَ         خَ لَ قَ",
                        "transliteration": "LA KA\nQO LA     LA FA     LA SYA\nDHO LA     LA KHO     KA LA\nLA DHO     FA LA     AIN LA\nLA QO BA     AIN DA LA\nFA LA HHA     JA AIN LA\nKHO LA QO     GHO ZAY LA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 24"
            },
            {
                        "lesson_number": 25,
                        "title": "Hal 25 - Huruf Mim",
                        "arabic_text": "مَ = مَ\nكَ كَ   فَ كَ   كَ قَ\nلَ سَ   لَ فَ   قَ لَ\nرَ مَ   مَ ضَ   لَ مَ\nقَ مَ رَ   رَ غَ مَ   فَ لَ مَ\nكَ رَ مَ   مَ زَ قَ   عَ ظَ مَ\nمَ رَ حَ   رَ جَ مَ   طَ مَ سَ",
                        "transliteration": "MA = MA\nKA QO     FA KA     KA KA\nQO LA     LA FA     LA SA\nLA MA     MA DHO     RO MA\nFA LA MA     RO GHO MA     QO MA RO\nAIN ZHO MA     MA ZAY QO     KA RO MA\nTHO MA SA     RO JA MA     MA RO HHA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 25"
            },
            {
                        "lesson_number": 26,
                        "title": "Hal 26 - Huruf Nun",
                        "arabic_text": "نَ لَ\nنَ لَ   بَ نَ   خَ نَ\nكَ نَ   فَ نَ   نَ جَ\nدَ نَ   نَ دَ   نَ صَ\nفَ نَ دَ   نَ صَ رَ   قَ رَ نَ\nضَ مَ نَ   نَ ظَ مَ   جَ نَ بَ\nحَ ضَ نَ   نَ خَ لَ   حَ سَ نَ",
                        "transliteration": "NA LA\nKHO NA     BA NA     NA LA\nNA JA     FA NA     KA NA\nNA SHO     NA DA     DA NA\nQO RO NA     NA SHO RO     FA NA DA\nJA NA BA     NA ZHO MA     DHO MA NA\nHHA SA NA     NA KHO LA     HHA DHO NA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 26"
            },
            {
                        "lesson_number": 27,
                        "title": "Hal 27 - Huruf Wawu",
                        "arabic_text": "وَ قَ فَ\nوَ قَ   وَ فَ   قَ وَ\nرَ وَ   نَ وَ   وَ مَ\nوَ لَ   صَ وَ   طَ وَ\nوَ قَ رَ         صَ وَ بَ\nسَ قَ وَ         وَ رَ دَ\nوَ جَ لَ         زَ وَ لَ",
                        "transliteration": "WA QO FA\nQO WA     WA FA     WA QO\nWA MA     NA WA     RO WA\nTHO WA     SHO WA     WA LA\nSHO WA BA     WA QO RO\nWA RO DA     SA QO WA\nZAY WA LA     WA JA LA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 27"
            },
            {
                        "lesson_number": 28,
                        "title": "Hal 28 - Huruf Ha",
                        "arabic_text": "هَ   وَ\nهَ دَ   هَ رَ   وَ هَ\nجَ هَ   شَ هَ   هَ رَ\nهَ وَ   نَ هَ   هَ مَ\nهَ دَ بَ         وَ هَ نَ\nجَ هَ دَ         شَ هَ دَ\nدَ هَ قَ         وَ هَ بَ",
                        "transliteration": "WA     HA\nWA HA     HA RO     HA DA\nHA RO     SYA HA     JA HA\nHA MA     NA HA     HA WA\nWA HA NA     HA DA BA\nSYA HA DA     JA HA DA\nWA HA BA     DA HA QO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 28"
            },
            {
                        "lesson_number": 29,
                        "title": "Hal 29 - Latihan",
                        "arabic_text": "هَ لَ كَ   كَ لَ مَ   فَ هَ دَ\nحَ صَ لَ   هَ دَ مَ   نَ ظَ رَ\nكَ رَ مَ   فَ عَ لَ   غَ سَ مَ\nشَ هَ دَ   جَ عَ لَ   مَ هَ نَ\nجَ بَ لَ   ثَ قَ بَ   وَ طَ رَ\nهَ زَ مَ   نَ زَ لَ   قَ وَ مَ\nحَ زَ نَ   وَ عَ دَ   كَ رَ هَ",
                        "transliteration": "FA HA DA     KA LA MA     HA LA KA\nNA ZHO RO     HA DA MA     HHA SHO LA\nGHO SA MA     FA AIN LA     KA RO MA\nMA HA NA     JA AIN LA     SYA HA DA\nWA THO RO     TSA QO BA     JA BA LA\nQO WA MA     NA ZAY LA     HA ZAY MA\nKA RO HA     WA AIN DA     HHA ZAY NA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 29"
            },
            {
                        "lesson_number": 30,
                        "title": "Hal 30 - Huruf Hamzah",
                        "arabic_text": "ءَ هَ\nنَ ءَ   ءَ هَ   هَ ءَ\nجَ ءَ   رَ ءَ   سَ ءَ\nلَ ءَ   فَ ءَ   مَ ءَ\nءَ جَ لَ         اَ مَ نَ\nمَ لَ ءَ         اَ خَ ذَ\nسَ ءَ لَ         نَ دَ هَ",
                        "transliteration": "A HA\nHA A     A HA     NA A\nSA A     RO A     JA A\nMA A     FA A     LA A\nA MA NA     A JA LA\nA KHO DZA     MA LA A\nNA DA HA     SA A LA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 30"
            },
            {
                        "lesson_number": 31,
                        "title": "Hal 31 - Huruf Ya",
                        "arabic_text": "يَ ءَ مَ\nيَ ءَ   يَ مَ   مَ يَ\nيَ رَ   وَ يَ   هَ يَ\nقَ يَ   صَ يَ   فَ يَ\nيَ سَ رَ         قَ يَ مَ\nيَ زَ دَ         خَ يَ لَ\nيَ شَ ءَ         عَ يَ مَ",
                        "transliteration": "YA A MA\nMA YA     YA MA     YA A\nHA YA     WA YA     YA RO\nFA YA     SHO YA     QO YA\nQO YA MA     YA SA RO\nKHO YA LA     YA ZAY DA\nAIN YA MA     YA SYA A",
                        "description": "Latihan Tilawati Jilid 1 Halaman 31"
            },
            {
                        "lesson_number": 32,
                        "title": "Hal 32 - Latihan 1",
                        "arabic_text": "فَ رَ غَ   فَ قَ رَ   صَ دَ قَ\nسَ لَ كَ   كَ لَ مَ   شَ جَ رَ\nنَ وَ لَ   هَ وَ نَ   فَ عَ لَ\nاَ مَ نَ   اَ طَ عَ   جَ دَ لَ\nسَ عَ دَ   شَ قَ يَ   عَ ذَ بَ",
                        "transliteration": "SHO DA QO     FA QO RO     FA RO GHO\nSYA JA RO     KA LA MA     SA LA KA\nFA AIN LA     HA WA NA     NA WA LA\nJA DA LA     A THO AIN     A MA NA\nAIN DZA BA     SYA QO YA     SA AIN DA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 32"
            },
            {
                        "lesson_number": 33,
                        "title": "Hal 33 - Latihan 9",
                        "arabic_text": "بَ تَ ثَ = بَتَثَ\nبَبَتَ   تَبَثَ   ثَبَتَ\nاَثَبَ   بَدَرَ   ثَبَرَ\nوَثَقَ   تَرَكَ   بَرَزَ\nبَثَطَ   تَزَمَ   رَثَتَ\nتَرَكَ   تَثَرَ   رَتَبَ\nبَتَمَ   طَبَرَ   رَتَبَ\nوَثَبَ   بَرَرَ   دَبَرَ",
                        "transliteration": "BA TA TSA = BA TA TSA\nTSA BA TA     TA BA TSA     BA BA TA\nTSA BA RO     BA DA RO     A TSA BA\nBA RO ZAY     TA RO KA     WA TSA QO\nRO TSA TA     TA ZAY MA     BA TSA THO\nRO TA BA     TA TSA RO     TA RO KA\nRO TA BA     THO BA RO     BA TA MA\nDA BA RO     BA RO RO     WA TSA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 33"
            },
            {
                        "lesson_number": 34,
                        "title": "Hal 34 - Latihan 10",
                        "arabic_text": "جَ حَ خَ = جَحَخَ\nخَزَنَ   جَرَحَ   حَجَمَ\nحَجَرَ   اَخَذَ   خَرَجَ\nحَجَبَ   بَحَثَ   خَطَبَ\nتَحَجَ   حَجَجَ   اَجَجَ\nتَجَخَ   وَجَدَ   زَحَنَ\nثَجَجَ   حَرَزَ   حَجَبَ",
                        "transliteration": "JA HHA KHO = JA HHA KHO\nHHA JA MA     JA RO HHA     KHO ZAY NA\nKHO RO JA     A KHO DZA     HHA JA RO\nKHO THO BA     BA HHA TSA     HHA JA BA\nA JA JA     HHA JA JA     TA HHA JA\nZAY HHA NA     WA JA DA     TA JA KHO\nHHA JA BA     HHA RO ZAY     TSA JA JA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 34"
            },
            {
                        "lesson_number": 35,
                        "title": "Hal 35 - Latihan 11",
                        "arabic_text": "سَ شَ = سَشَ\nسَرَحَ   شَجَرَ   سَرَجَ\nحَسَبَ   بَشَرَ   رَسَبَ\nخَرَسَ   حَسَدَ   خَشَرَ\nاَشَرَ   سَوَلَ   سَحَبَ\nسَرَدَ   رَشَدَ   دَرَسَ\nسَحَرَ   رَسَحَ   شَطَبَ",
                        "transliteration": "SA SYA = SA SYA\nSA RO JA     SYA JA RO     SA RO HHA\nRO SA BA     BA SYA RO     HHA SA BA\nKHO SYA RO     HHA SA DA     KHO RO SA\nSA HHA BA     SA WA LA     A SYA RO\nDA RO SA     RO SYA DA     SA RO DA\nSYA THO BA     RO SA HHA     SA HHA RO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 35"
            },
            {
                        "lesson_number": 36,
                        "title": "Hal 36 - Latihan 12",
                        "arabic_text": "صَ ضَ = صَضَ\nصَرَحَ   حَصَرَ   خَرَبَ\nصَحَبَ   صَبَرَ   ضَحَنَ\nحَضَنَ   حَصَدَ   ضَبَطَ\nصَوَبَ   وَضَحَ   جَحَصَ\nنَصَبَ   صَحَبَ   اَضَبَ\nخَبَضَ   رَضَبَ   طَحَضَ",
                        "transliteration": "SHO DHO = SHO DHO\nKHO RO BA     HHA SHO RO     SHO RO HHA\nDHO HHA NA     SHO BA RO     SHO HHA BA\nDHO BA THO     HHA SHO DA     HHA DHO NA\nJA HHA SHO     WA DHO HHA     SHO WA BA\nA DHO BA     SHO HHA BA     NA SHO BA\nTHO HHA DHO     RO DHO BA     KHO BA DHO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 36"
            },
            {
                        "lesson_number": 37,
                        "title": "Hal 37 - Latihan 13",
                        "arabic_text": "عَ عَ عَ = عَعَعَ\nغَ غَ غَ = غَغَغَ\nعَجَبَ   شَعَرَ   عَزَمَ\nغَبَرَ   غَرَقَ   بَسَغَ\nصَعَدَ   عَجَزَ   وَدَعَ\nبَغَدَ   تَسَغَ   سَعَدَ\nعَرَفَ   رَفَعَ   رَجَعَ\nغَدَقَ   بَغَو   تَبَغَ",
                        "transliteration": "AIN AIN AIN = AIN AIN AIN\nGHO GHO GHO = GHO GHO GHO\nAIN ZAY MA     SYA AIN RO     AIN JA BA\nBA SA GHO     GHO RO QO     GHO BA RO\nWA DA AIN     AIN JA ZAY     SHO AIN DA\nSA AIN DA     TA SA GHO     BA GHO DA\nRO JA AIN     RO FA AIN     AIN RO FA\nTA BA GHO     BA GHO WA     GHO DA QO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 37"
            },
            {
                        "lesson_number": 38,
                        "title": "Hal 38 - Latihan 14",
                        "arabic_text": "فَ فَ فَ = فَفَفَ\nقَ قَ قَ = قَقَقَ\nفَرَحَ   فَرَجَ   قَدَرَ\nفَرَقَ   سَفَرَ   قَرَمَ\nقَفَرَ   قَصَرَ   صَفَرَ\nفَسَقَ   قَدَرَ   رَفَعَ\nحَرَقَ   قَفَصَ   فَقَضَ\nشَفَقَ   تَقَعَ   رَفَقَ",
                        "transliteration": "FA FA FA = FA FA FA\nQO QO QO = QO QO QO\nQO DA RO     FA RO JA     FA RO HHA\nQO RO MA     SA FA RO     FA RO QO\nSHO FA RO     QO SHO RO     QO FA RO\nRO FA AIN     QO DA RO     FA SA QO\nFA QO DHO     QO FA SHO     HHA RO QO\nRO FA QO     TA QO AIN     SYA FA QO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 38"
            },
            {
                        "lesson_number": 39,
                        "title": "Hal 39 - Latihan 15",
                        "arabic_text": "لَ لَ لَ = لَلَلَ\nحَلَمَ   سَلَمَ   لَمَسَ\nجَعَلَ   خَبَلَ   لَشَدَ\nعَلَقَ   خَلَقَ   عَظَمَ\nغَلَبَ   بَلَعَ   غَرَمَ\nسَمَعَ   بَلَغَ   عَجَلَ\nطَلَبَ   ثَلَثَ   حَلَمَ\nحَرَمَ   مَلَحَ   دَخَلَ",
                        "transliteration": "LA LA LA = LA LA LA\nLA MA SA     SA LA MA     HHA LA MA\nLA SYA DA     KHO BA LA     JA AIN LA\nAIN ZHO MA     KHO LA QO     AIN LA QO\nGHO RO MA     BA LA AIN     GHO LA BA\nAIN JA LA     BA LA GHO     SA MA AIN\nHHA LA MA     TSA LA TSA     THO LA BA\nDA KHO LA     MA LA HHA     HHA RO MA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 39"
            },
            {
                        "lesson_number": 40,
                        "title": "Hal 40 - Latihan 16",
                        "arabic_text": "كَ = كَ = كَ = كَمَلَ حَكَمَ\nكَرَمَ   شَكَرَ   تَرَكَ\nمَلَكَ   كَلَمَ   ذَكَرَ\nكَسَرَ   كَسَبَ   فَلَكَ\nكَذَبَ   كَسَدَ   كَبَرَ\nكَرَمَ   رَكَبَ   بَرَكَ\nكَتَبَ   سَلَكَ   هَلَكَ\nكَبَرَ   كَمَلَ   بَكَرَ",
                        "transliteration": "KA = KA = KA = KA MA LA HHA KA MA\nTA RO KA     SYA KA RO     KA RO MA\nDZA KA RO     KA LA MA     MA LA KA\nFA LA KA     KA SA BA     KA SA RO\nKA BA RO     KA SA DA     KA DZA BA\nBA RO KA     RO KA BA     KA RO MA\nHA LA KA     SA LA KA     KA TA BA\nBA KA RO     KA MA LA     KA BA RO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 40"
            },
            {
                        "lesson_number": 41,
                        "title": "Hal 41 - Latihan 17",
                        "arabic_text": "نَ = نَ = نَزَلَ\nنَصَرَ   صَنَعَ   حَضَنَ\nفَنَدَ   نَفَقَ   حَسَنَ\nنَبَذَ   بَدَنَ   غَنَمَ\nنَعَمَ   قَنَتَ   جَنَبَ\nنَفَرَ   مَنَتَ   فَتَنَ\nسَنَدَ   فَنَنَ   نَفَسَ\nنَذَرَ   مَنَعَ   نَظَرَ",
                        "transliteration": "NA = NA = NA ZAY LA\nHHA DHO NA     SHO NA AIN     NA SHO RO\nHHA SA NA     NA FA QO     FA NA DA\nGHO NA MA     BA DA NA     NA BA DZA\nJA NA BA     QO NA TA     NA AIN MA\nFA TA NA     MA NA TA     NA FA RO\nNA FA SA     FA NA NA     SA NA DA\nNA ZHO RO     MA NA AIN     NA DZA RO",
                        "description": "Latihan Tilawati Jilid 1 Halaman 41"
            },
            {
                        "lesson_number": 42,
                        "title": "Hal 42 - Latihan 18",
                        "arabic_text": "هَ = هَ = هَ = هَ = فَهَدَ\nهَلَكَ   شَهَدَ   كَرَهَ\nجَهَدَ   هَرَبَ   نَهَرَ\nهَذَلَ   لَهَبَ   فَقَهَ\nسَفَهَ   هَدَيَ   بَهَجَ\nمَهَيَ   شَهَقَ   نَزَهَ\nوَهَمَ   ظَهَرَ   بَنَهَ\nشَهَبَ   جَهَلَ   فَهَدَ",
                        "transliteration": "HA = HA = HA = HA = FA HA DA\nKA RO HA     SYA HA DA     HA LA KA\nNA HA RO     HA RO BA     JA HA DA\nFA QO HA     LA HA BA     HA DZA LA\nBA HA JA     HA DA YA     SA FA HA\nNA ZAY HA     SYA HA QO     MA HA YA\nBA NA HA     ZHO HA RO     WA HA MA\nFA HA DA     JA HA LA     SYA HA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 42"
            },
            {
                        "lesson_number": 43,
                        "title": "Hal 43 - Latihan 19",
                        "arabic_text": "ءَ = أَ = ـئَـ   سَأَلَ\nيَ = يـَ   يَئَمَ\nأَدَمَ   يَسَرَ   فَئَدَ\nسَئَمَ   أَجَلَ   عَصَيَ\nخَيَرَ   بَيَنَ   أَلَمَ\nدَيَرَ   أَدَبَ   بَئَسَ\nيَلَدَ   سَيَرَ   خَطَيَ\nسَئَرَ   لَخَذَ   دَأَبَ\nأَخَذَ   يَتَمَ   بَيَعَ",
                        "transliteration": "SA A LA     A = A =  A \nYA A MA     YA = YA \nFA A DA     YA SA RO     A DA MA\nAIN SHO YA     A JA LA     SA A MA\nA LA MA     BA YA NA     KHO YA RO\nBA A SA     A DA BA     DA YA RO\nKHO THO YA     SA YA RO     YA LA DA\nDA A BA     LA KHO DZA     SA A RO\nBA YA AIN     YA TA MA     A KHO DZA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 43"
            },
            {
                        "lesson_number": 44,
                        "title": "Hal 44 - Latihan 20",
                        "arabic_text": "عَلَمَ وَحَكَمَ   رَءَفَ وَرَحَمَ\nغَفَرَ وَشَكَرَ   شَهَدَ وَمَجَدَ\nسَمَعَ وَبَصَرَ   عَذَبَ وَحَدَقَ\nصَعَدَ وَزَلَقَ   ظَهَرَ وَطَبَقَ\nعَمَلَ وَصَلَحَ   فَخَرَ وَذَنَبَ\nبَشَرَ وَنَذَرَ   ضَلَلَ وَمَيَنَ\nعَزَزَ وَحَلَمَ   شَهَبَ وَثَقَبَ\nكَتَبَ وَمَبَنَ   عَذَبَ وَمَهَنَ",
                        "transliteration": "RO A FA WA RO HHA MA     AIN LA MA WA HHA KA MA\nSYA HA DA WA MA JA DA     GHO FA RO WA SYA KA RO\nAIN DZA BA WA HHA DA QO     SA MA AIN WA BA SHO RO\nZHO HA RO WA THO BA QO     SHO AIN DA WA ZAY LA QO\nFA KHO RO WA DZA NA BA     AIN MA LA WA SHO LA HHA\nDHO LA LA WA MA YA NA     BA SYA RO WA NA DZA RO\nSYA HA BA WA TSA QO BA     AIN ZAY ZAY WA HHA LA MA\nAIN DZA BA WA MA HA NA     KA TA BA WA MA BA NA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 44"
            }
]
    },
    2: {
        "title": "Jilid 2 - Huruf Sambung",
        "description": "Membaca huruf sambung dan kata sederhana",
        "icon": "auto_stories",
        "color": "#0D47A1",
        "lessons": [
            {
                "lesson_number": 1,
                "title": "Huruf Sambung Awal",
                "arabic_text": "بَتَ نَصَرَ كَتَبَ",
                "transliteration": "BA TA NA SHO RO KA TA BA",
                "description": "Membaca huruf hijaiyah yang disambung di awal kata",
            },
            {
                "lesson_number": 2,
                "title": "Huruf Sambung Tengah",
                "arabic_text": "سَمِعَ عَلِمَ فَهِمَ",
                "transliteration": "SA MA ِ AIN AIN LA ِ MA FA HA ِ MA",
                "description": "Membaca huruf hijaiyah yang disambung di tengah kata",
            },
            {
                "lesson_number": 3,
                "title": "Huruf Sambung Akhir",
                "arabic_text": "ذَهَبَ حَسُنَ كَرُمَ",
                "transliteration": "DZA HA BA HHA SA ُ NA KA RO ُ MA",
                "description": "Membaca huruf hijaiyah yang disambung di akhir kata",
            },
            {
                "lesson_number": 4,
                "title": "Kata dengan Tanwin",
                "arabic_text": "كِتَابًا عِلْمًا نُوْرًا",
                "transliteration": "KA ِ TA A BA ً A AIN ِ LA ْ MA ً A NA ُ WA ْ RO ً A",
                "description": "Membaca kata dengan tanwin fathah, kasrah, dan dhammah",
            },
        ],
    },
    3: {
        "title": "Jilid 3 - Mad & Sukun",
        "description": "Hukum mad (panjang) dan sukun",
        "icon": "school",
        "color": "#4A148C",
        "lessons": [
            {
                "lesson_number": 1,
                "title": "Mad Asli (Mad Thabi'i)",
                "arabic_text": "قَالَ - كِيْلَ - يَقُوْلُ",
                "transliteration": "QO A LA - KA ِ YA ْ LA - YA QO ُ WA ْ LA ُ",
                "description": "Belajar membaca mad asli dengan panjang 2 harakat",
            },
            {
                "lesson_number": 2,
                "title": "Sukun dan Qalqalah",
                "arabic_text": "اَلْحَمْدُ - يَبْدَأُ",
                "transliteration": "A LA ْ HHA MA ْ DA ُ - YA BA ْ DA A ُ",
                "description": "Belajar membaca huruf sukun dan huruf qalqalah",
            },
            {
                "lesson_number": 3,
                "title": "Tasydid",
                "arabic_text": "إِنَّ - أَنَّ - رَبَّكَ",
                "transliteration": "إ ِ NA ّ - A NA ّ - RO BA ّ KA",
                "description": "Belajar membaca huruf bertasydid dengan benar",
            },
        ],
    },
    4: {
        "title": "Jilid 4 - Hukum Nun & Mim",
        "description": "Idzhar, Idgham, Ikhfa, dan Iqlab",
        "icon": "mosque",
        "color": "#BF360C",
        "lessons": [
            {
                "lesson_number": 1,
                "title": "Nun Sukun - Idzhar",
                "arabic_text": "مَنْ أَعْطَى - مِنْ عِلْمٍ",
                "transliteration": "MA NA ْ A AIN ْ THO ى - MA ِ NA ْ AIN ِ LA ْ MA ٍ",
                "description": "Nun sukun bertemu huruf halqi: dibaca jelas",
            },
            {
                "lesson_number": 2,
                "title": "Nun Sukun - Idgham",
                "arabic_text": "مَنْ يَعْمَلْ - مِنْ وَلِيٍّ",
                "transliteration": "MA NA ْ YA AIN ْ MA LA ْ - MA ِ NA ْ WA LA ِ YA ٍ ّ",
                "description": "Nun sukun bertemu huruf idgham: dilebur",
            },
            {
                "lesson_number": 3,
                "title": "Nun Sukun - Ikhfa",
                "arabic_text": "مِنْ قَبْلِ - أَنْتُمْ",
                "transliteration": "MA ِ NA ْ QO BA ْ LA ِ - A NA ْ TA ُ MA ْ",
                "description": "Nun sukun bertemu huruf ikhfa: dibaca samar",
            },
        ],
    },
    5: {
        "title": "Jilid 5 - Waqaf & Ibtida",
        "description": "Tanda berhenti dan cara memulai bacaan",
        "icon": "bookmark",
        "color": "#006064",
        "lessons": [
            {
                "lesson_number": 1,
                "title": "Waqaf Lazim",
                "arabic_text": "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ ۝",
                "transliteration": "BA ِ SA ْ MA ِ A LA LA ّ HA ِ A LA RO ّ HHA ْ MA NA ِ A LA RO ّ HHA ِ YA MA ِ ۝",
                "description": "Belajar berhenti pada tanda waqaf lazim",
            },
            {
                "lesson_number": 2,
                "title": "Waqaf Ja'iz",
                "arabic_text": "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
                "transliteration": "A LA ْ HHA MA ْ DA ُ LA ِ LA ّ HA ِ RO BA ِ ّ A LA ْ AIN A LA MA ِ YA NA",
                "description": "Belajar berhenti pada tanda waqaf ja'iz",
            },
        ],
    },
    6: {
        "title": "Jilid 6 - Gharib & Musykilat",
        "description": "Bacaan-bacaan asing dan sulit dalam Al-Qur'an",
        "icon": "star",
        "color": "#FF6F00",
        "lessons": [
            {
                "lesson_number": 1,
                "title": "Saktah",
                "arabic_text": "عِوَجَا ۜ قَيِّمًا",
                "transliteration": "AIN ِ WA JA A ۜ QO YA ِ ّ MA ً A",
                "description": "Belajar membaca saktah: berhenti sejenak tanpa bernapas",
            },
            {
                "lesson_number": 2,
                "title": "Isymam & Imalah",
                "arabic_text": "لَا تَأْمَ۪نَّا",
                "transliteration": "LA A TA A ْ MA ۪ NA ّ A",
                "description": "Belajar bacaan isymam dan imalah",
            },
        ],
    },
}


def get_all_jilids() -> list[dict]:
    """Get list of all jilid with basic info."""
    jilids = []
    for jilid_num, data in TILAWATI_CONTENT.items():
        jilids.append({
            "jilid": jilid_num,
            "title": data["title"],
            "description": data["description"],
            "total_lessons": len(data["lessons"]),
            "icon": data["icon"],
            "color": data["color"],
        })
    return jilids


def get_jilid_lessons(jilid: int) -> dict | None:
    """Get all lessons in a jilid."""
    if jilid not in TILAWATI_CONTENT:
        return None
    data = TILAWATI_CONTENT[jilid]
    return {
        "jilid": jilid,
        "title": data["title"],
        "description": data["description"],
        "total_lessons": len(data["lessons"]),
        "icon": data["icon"],
        "color": data["color"],
        "lessons": data["lessons"],
    }


def get_lesson(jilid: int, lesson_number: int) -> dict | None:
    """Get a specific lesson."""
    if jilid not in TILAWATI_CONTENT:
        return None
    lessons = TILAWATI_CONTENT[jilid]["lessons"]
    for lesson in lessons:
        if lesson["lesson_number"] == lesson_number:
            return lesson
    return None


def _tokenize_transliteration(text: str) -> list[str]:
    """Extract hijaiyah word tokens from a transliteration string (uppercase words only)."""
    return [w for w in re.split(r"[\s\n\r]+", text.upper()) if re.match(r"^[A-Z']+$", w)]


def _word_match_rate(predicted: list[str], expected: list[str]) -> float:
    """Compute token-level match rate (order-insensitive, caps-normalized)."""
    if not expected:
        return 0.0
    pred_lower = [w.lower() for w in predicted]
    exp_lower = [w.lower() for w in expected]
    matched = sum(1 for w in exp_lower if w in pred_lower)
    return matched / len(exp_lower)


async def _call_asr_service(audio_path: str) -> list[str] | None:
    """
    Transkripsi audio menggunakan model ASR lokal (ASR-EXP-03-E3).
    Fallback ke HF Spaces jika ASR_MODEL_DIR tidak tersedia dan ASR_SERVICE_URL diisi.
    Timeout lokal: 8 detik. Timeout HF Spaces: 10 detik.
    """
    import asyncio

    # Coba lokal dulu — timeout 8 detik supaya tidak memblokir terlalu lama
    try:
        from app.services.asr_inference import transcribe_file
        loop = asyncio.get_event_loop()
        result = await asyncio.wait_for(
            loop.run_in_executor(None, transcribe_file, audio_path),
            timeout=8.0,
        )
        words = result.get("words", [])
        return [w.upper() for w in words]
    except asyncio.TimeoutError:
        print("[ai_service] Local ASR timeout (>8s), fallback ke mock.", flush=True)
        return None
    except RuntimeError:
        pass  # model belum dimuat, coba HF Spaces
    except Exception as e:
        print(f"[ai_service] Local ASR error: {e}", flush=True)

    # Fallback ke HF Spaces jika URL tersedia (timeout diperkecil ke 10s)
    from app.config import settings
    if not settings.ASR_SERVICE_URL:
        return None

    try:
        import httpx
        url = settings.ASR_SERVICE_URL.rstrip("/") + "/transcribe"
        async with httpx.AsyncClient(timeout=10.0) as client:
            with open(audio_path, "rb") as f:
                response = await client.post(url, files={"audio": f})
        response.raise_for_status()
        data = response.json()
        words = data.get("words", [])
        return [w.upper() for w in words]
    except Exception as e:
        print(f"[ai_service] HF Spaces ASR error: {e}", flush=True)
        return None


async def evaluate_audio(audio_path: str, jilid: int, lesson_number: int) -> dict:
    """
    Evaluate audio recording using ASR-EXP-03-E3 model.
    Calls HF Spaces /transcribe, compares result against expected transliteration.
    Falls back to mock scores if ASR_SERVICE_URL is not configured.
    """
    lesson = get_lesson(jilid, lesson_number)
    if lesson is None:
        return {"error": "Lesson not found"}

    expected_tokens = _tokenize_transliteration(lesson["transliteration"])
    predicted_tokens = await _call_asr_service(audio_path)

    if predicted_tokens is not None and expected_tokens:
        wmr = _word_match_rate(predicted_tokens, expected_tokens)

        n_pred = len(predicted_tokens)
        n_exp = len(expected_tokens)
        length_penalty = 1.0 - abs(n_pred - n_exp) / max(n_exp, 1)
        length_penalty = max(0.0, min(1.0, length_penalty))

        makharijul_huruf = round(wmr * 90, 1)
        tajwid = round(wmr * 85, 1)
        kelancaran = round(length_penalty * 100, 1)
        overall = round(makharijul_huruf * 0.4 + tajwid * 0.35 + kelancaran * 0.25, 1)

        phoneme_feedback = {
            "asr_transcript": " ".join(predicted_tokens),
            "expected": " ".join(expected_tokens),
            "matched_tokens": [w for w in [t.lower() for t in expected_tokens]
                               if w in [p.lower() for p in predicted_tokens]],
        }
    else:
        # Fallback: mock scores when ASR service is unavailable
        print("[ai_service] Using mock scores (ASR service not available)", flush=True)
        base = random.uniform(60, 95)
        makharijul_huruf = round(min(100, max(0, base + random.uniform(-10, 10))), 1)
        tajwid = round(min(100, max(0, base + random.uniform(-15, 15))), 1)
        kelancaran = round(min(100, max(0, base + random.uniform(-8, 8))), 1)
        overall = round(makharijul_huruf * 0.4 + tajwid * 0.35 + kelancaran * 0.25, 1)
        phoneme_feedback = {}

    feedback = _generate_feedback(overall, makharijul_huruf, tajwid, kelancaran)

    return {
        "overall_score": overall,
        "makharijul_huruf_score": makharijul_huruf,
        "tajwid_score": tajwid,
        "kelancaran_score": kelancaran,
        "feedback_json": feedback,
        "phoneme_details": phoneme_feedback,
    }


async def transcribe_word(audio_path: str) -> list[str] | None:
    """Public wrapper for single-word ASR transcription."""
    return await _call_asr_service(audio_path)


def _generate_phoneme_feedback(arabic_text: str) -> dict:
    """Generate mock phoneme-level feedback."""
    phonemes = []
    for i, char in enumerate(arabic_text):
        if char.strip():
            status = random.choices(
                ["correct", "warning", "error"],
                weights=[0.7, 0.2, 0.1],
                k=1
            )[0]
            phonemes.append({
                "index": i,
                "character": char,
                "status": status,
                "confidence": round(random.uniform(0.6, 1.0), 2),
            })

    return {
        "phonemes": phonemes,
        "total_phonemes": len(phonemes),
        "correct_count": sum(1 for p in phonemes if p["status"] == "correct"),
        "warning_count": sum(1 for p in phonemes if p["status"] == "warning"),
        "error_count": sum(1 for p in phonemes if p["status"] == "error"),
    }


def _generate_feedback(overall: float, makhraj: float, tajwid: float, kelancaran: float) -> dict:
    """Generate feedback text based on scores."""
    tips = []

    if makhraj < 70:
        tips.append("Perhatikan makhraj huruf, terutama pada huruf-huruf yang keluar dari tenggorokan.")
    elif makhraj < 85:
        tips.append("Makhraj huruf sudah cukup baik, terus latih konsistensi pengucapan.")

    if tajwid < 70:
        tips.append("Pelajari kembali hukum tajwid yang terkait dengan pelajaran ini.")
    elif tajwid < 85:
        tips.append("Tajwid sudah baik, perhatikan lagi panjang pendek bacaan.")

    if kelancaran < 70:
        tips.append("Tingkatkan kelancaran dengan lebih sering berlatih membaca.")
    elif kelancaran < 85:
        tips.append("Kelancaran bacaan sudah baik, pertahankan ritme bacaan.")

    if overall >= 85:
        grade = "Mumtaz (Sangat Baik)"
        message = "Masya Allah! Bacaan Anda sangat baik. Pertahankan kualitas bacaan ini."
    elif overall >= 70:
        grade = "Jayyid Jiddan (Baik Sekali)"
        message = "Bacaan Anda sudah bagus. Terus berlatih untuk kesempurnaan."
    elif overall >= 55:
        grade = "Jayyid (Baik)"
        message = "Bacaan Anda cukup baik. Ada beberapa hal yang perlu diperbaiki."
    else:
        grade = "Maqbul (Cukup)"
        message = "Terus berlatih ya! Perhatikan kembali poin-poin perbaikan di bawah."

    return {
        "grade": grade,
        "message": message,
        "tips": tips,
        "overall_percentage": round(overall, 1),
    }
