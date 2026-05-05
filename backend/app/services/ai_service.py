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


# Data konten Tilawati (dummy)
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
                        "transliteration": "A BA\nA BA     BA BA     A A\nA BA     A BA     BA A\nBA BA BA         A A A\nA BA A         BA BA A\nBA A BA         A BA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 1"
            },
            {
                        "lesson_number": 2,
                        "title": "Hal 2 - Huruf Ta",
                        "arabic_text": "بَ تَ\nبَ تَ   تَ بَ   اَ تَ\nتَ تَ   تَ بَ   تَ اَ\nتَ بَ تَ         بَ تَ تَ\nتَ اَ بَ         بَ اَ تَ\nاَ تَ بَ         اَ بَ تَ\nتَ تَ بَ         بَ بَ تَ",
                        "transliteration": "BA TA\nA TA     TA BA     BA TA\nTA A     TA BA     TA TA\nBA TA TA         TA BA TA\nBA A TA         TA A BA\nA BA TA         A TA BA\nBA BA TA         TA TA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 2"
            },
            {
                        "lesson_number": 3,
                        "title": "Hal 3 - Huruf Tsa",
                        "arabic_text": "تَ ثَ\nثَ ثَ   ثَ ثَ   ثَ بَ\nثَ تَ   ثَ اَ   ثَ بَ\nتَ ثَ   اَ ثَ   بَ ثَ\nثَ ثَ بَ         بَ تَ ثَ\nثَ بَ تَ         تَ ثَ تَ\nتَ اَ ثَ         بَ اَ ثَ\nثَ اَ بَ   تَ ثَ اَ   بَ تَ ثَ",
                        "transliteration": "TA TSA\nTSA BA     TSA TSA     TSA TSA\nTSA BA     TSA A     TSA TA\nBA TSA     A TSA     TA TSA\nBA TA TSA         TSA TSA BA\nTA TSA TA         TSA BA TA\nBA A TSA         TA A TSA\nBA TA TSA     TA TSA A     TSA A BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 3"
            },
            {
                        "lesson_number": 4,
                        "title": "Hal 4 - Huruf Jim & Ha",
                        "arabic_text": "جَ حَ\nجَ جَ   حَ حَ   جَ حَ\nثَ جَ   بَ جَ   تَ حَ\nحَ تَ   جَ حَ   ثَ حَ\nحَ جَ بَ         اَ حَ حَ\nبَ حَ تَ         حَ تَ ثَ\nجَ بَ حَ         حَ ثَ جَ",
                        "transliteration": "JA HA\nJA HA     HA HA     JA JA\nTA HA     BA JA     TSA JA\nTSA HA     JA HA     HA TA\nA HA HA         HA JA BA\nHA TA TSA         BA HA TA\nHA TSA JA         JA BA HA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 4"
            },
            {
                        "lesson_number": 5,
                        "title": "Hal 5 - Huruf Kha",
                        "arabic_text": "خَ بَ ثَ\nخَ خَ   خَ بَ   بَ خَ\nجَ خَ   حَ خَ   خَ خَ\nبَ تَ خَ         ثَ خَ تَ\nبَ حَ ثَ         حَ خَ ثَ\nخَ خَ جَ         خَ جَ حَ\nخَ بَ جَ         بَ خَ ثَ",
                        "transliteration": "KHA BA TSA\nBA KHA     KHA BA     KHA KHA\nKHA KHA     HA KHA     JA KHA\nTSA KHA TA         BA TA KHA\nHA KHA TSA         BA HA TSA\nKHA JA HA         KHA KHA JA\nBA KHA TSA         KHA BA JA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 5"
            },
            {
                        "lesson_number": 6,
                        "title": "Hal 6 - Latihan",
                        "arabic_text": "خَ جَ بَ   تَ جَ ثَ   اَ تَ جَ\nثَ جَ حَ   بَ خَ ثَ   ثَ حَ جَ\nجَ جَ تَ   ثَ خَ ثَ   حَ جَ بَ\nبَ جَ ثَ   جَ خَ تَ   اَ جَ خَ\nبَ خَ جَ   خَ ثَ حَ   جَ اَ بَ\nبَ خَ جَ   جَ ثَ تَ   تَ اَ خَ\nخَ جَ بَ   اَ حَ بَ   بَ حَ ثَ",
                        "transliteration": "A TA JA     TA JA TSA     KHA JA BA\nTSA HA JA     BA KHA TSA     TSA JA HA\nHA JA BA     TSA KHA TSA     JA JA TA\nA JA KHA     JA KHA TA     BA JA TSA\nJA A BA     KHA TSA HA     BA KHA JA\nTA A KHA     JA TSA TA     BA KHA JA\nBA HA TSA     A HA BA     KHA JA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 6"
            },
            {
                        "lesson_number": 7,
                        "title": "Hal 7 - Huruf Dal",
                        "arabic_text": "حَ خَ دَ\nدَ دَ   حَ دَ   خَ دَ\nدَ حَ   دَ خَ   دَ جَ\nثَ دَ   خَ دَ   تَ دَ\nدَ دَ خَ         دَ دَ جَ\nحَ دَ خَ         خَ دَ حَ\nثَ دَ خَ         تَ دَ حَ",
                        "transliteration": "HA KHA DA\nKHA DA     HA DA     DA DA\nDA JA     DA KHA     DA HA\nTA DA     KHA DA     TSA DA\nDA DA JA         DA DA KHA\nHA DA KHA         KHA DA HA\nTA DA HA         TSA DA KHA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 7"
            },
            {
                        "lesson_number": 8,
                        "title": "Hal 8 - Huruf Dzal",
                        "arabic_text": "خَ دَ ذَ\nذَ ذَ   ذَ دَ   ذَ خَ\nحَ ذَ   خَ ذَ   جَ ذَ\nذَ ثَ   بَ ذَ   ذَ تَ\nذَ دَ حَ         دَ ذَ حَ\nحَ بَ ذَ         خَ ذَ ثَ\nتَ خَ ذَ         ثَ جَ ذَ",
                        "transliteration": "KHA DA DZA\nDZA KHA     DZA DA     DZA DZA\nJA DZA     KHA DZA     HA DZA\nDZA TA     BA DZA     DZA TSA\nDA DZA HA         DZA DA HA\nKHA DZA TSA         HA BA DZA\nTSA JA DZA         TA KHA DZA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 8"
            },
            {
                        "lesson_number": 9,
                        "title": "Hal 9 - Huruf Ra & Za",
                        "arabic_text": "رَ زَ\nرَ زَ   ذَ رَ   زَ رَ\nحَ زَ   دَ زَ   خَ زَ\nرَ رَ   جَ رَ   ذَ زَ\nذَ رَ زَ         زَ رَ دَ\nذَ حَ زَ         زَ خَ رَ\nخَ زَ رَ         حَ ذَ رَ",
                        "transliteration": "RA ZA\nZA RA     DZA RA     RA ZA\nKHA ZA     DA ZA     HA ZA\nDZA ZA     JA RA     RA RA\nZA RA DA         DZA RA ZA\nZA KHA RA         DZA HA ZA\nHA DZA RA         KHA ZA RA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 9"
            },
            {
                        "lesson_number": 10,
                        "title": "Hal 10 - Huruf Sin",
                        "arabic_text": "زَ سَ\nسَ سَ   سَ رَ   سَ زَ\nدَ سَ   ذَ سَ   زَ سَ\nسَ جَ   سَ حَ   سَ خَ\nسَ رَ دَ         سَ جَ دَ\nخَ سَ رَ         حَ سَ دَ\nدَ رَ سَ         تَ خَ سَ",
                        "transliteration": "ZA SA\nSA ZA     SA RA     SA SA\nZA SA     DZA SA     DA SA\nSA KHA     SA HA     SA JA\nSA JA DA         SA RA DA\nHA SA DA         KHA SA RA\nTA KHA SA         DA RA SA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 10"
            },
            {
                        "lesson_number": 11,
                        "title": "Hal 11 - Huruf Syin",
                        "arabic_text": "شَ رَ حَ\nشَ شَ   شَ رَ   شَ حَ\nدَ سَ   ذَ شَ   حَ شَ\nشَ خَ   سَ زَ   شَ ذَ\nشَ جَ سَ         شَ سَ خَ\nخَ سَ رَ         شَ خَ رَ\nشَ جَ رَ         شَ رَ حَ",
                        "transliteration": "SYA RA HA\nSYA HA     SYA RA     SYA SYA\nHA SYA     DZA SYA     DA SA\nSYA DZA     SA ZA     SYA KHA\nSYA SA KHA         SYA JA SA\nSYA KHA RA         KHA SA RA\nSYA RA HA         SYA JA RA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 11"
            },
            {
                        "lesson_number": 12,
                        "title": "Hal 12 - Latihan",
                        "arabic_text": "ذَ دَ خَ   سَ رَ دَ   سَ جَ دَ\nحَ ذَ بَ   خَ سَ رَ   حَ سَ دَ\nتَ خَ ذَ   دَ رَ سَ   ثَ خَ سَ\nدَ ذَ حَ   رَ زَ دَ   سَ شَ جَ\nخَ دَ ثَ   حَ ذَ رَ   ذَ حَ شَ\nثَ جَ دَ   زَ حَ رَ   خَ سَ دَ\nسَ رَ دَ   دَ رَ سَ   خَ سَ رَ\nشَ جَ رَ   رَ شَ دَ   شَ رَ حَ",
                        "transliteration": "DZA DA KHA   SA RA DA   SA JA DA\nHA DZA BA   KHA SA RA   HA SA DA\nTA KHA DZA   DA RA SA   TSA KHA SA\nDA DZA HA   RA ZA DA   SA SYA JA\nKHA DA TSA   HA DZA RA   DZA HA SYA\nTSA JA DA   ZA HA RA   KHA SA DA\nSA RA DA   DA RA SA   KHA SA RA\nSYA JA RA   RA SYA DA   SYA RA HA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 12"
            },
            {
                        "lesson_number": 13,
                        "title": "Hal 13 - Huruf Shad",
                        "arabic_text": "صَ حَ بَ\nصَ صَ   صَ حَ   صَ خَ\nرَ صَ   سَ صَ   ذَ صَ\nصَ بَ   صَ خَ   صَ رَ\nصَ دَ بَ         صَ بَ رَ\nجَ تَ صَ         حَ صَ بَ\nحَ صَ دَ         حَ صَ ذَ",
                        "transliteration": "SHA HA BA\nSHA KHA   SHA HA   SHA SHA\nDZA SHA   SA SHA   RA SHA\nSHA RA   SHA KHA   SHA BA\nSHA BA RA   SHA DA BA\nHA SHA BA   JA TA SHA\nHA SHA DZA   HA SHA DA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 13"
            },
            {
                        "lesson_number": 14,
                        "title": "Hal 14 - Huruf Dhad",
                        "arabic_text": "ضَ رَ بَ\nضَ ضَ   ضَ رَ   ضَ بَ\nرَ ضَ   ذَ ضَ   صَ ضَ\nضَ خَ   زَ ضَ   ضَ حَ\nضَ رَ بَ         ضَ بَ رَ\nحَ ضَ رَ         شَ رَ ضَ\nتَ بَ ضَ         صَ صَ ضَ",
                        "transliteration": "DHA RA BA\nDHA BA   DHA RA   DHA DHA\nSHA DHA   DZA DHA   RA DHA\nDHA HA   ZA DHA   DHA KHA\nDHA BA RA   DHA RA BA\nSYA RA DHA   HA DHA RA\nSHA SHA DHA   TA BA DHA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 14"
            },
            {
                        "lesson_number": 15,
                        "title": "Hal 15 - Huruf Tha",
                        "arabic_text": "طَ بَ خَ\nطَ طَ   طَ ضَ   طَ صَ\nسَ طَ   صَ طَ   شَ طَ\nطَ رَ   ذَ طَ   طَ دَ\nطَ بَ خَ         حَ طَ بَ\nصَ تَ طَ         طَ زَ ضَ\nشَ طَ دَ         حَ طَ سَ",
                        "transliteration": "THA BA KHA\nTHA SHA   THA DHA   THA THA\nSYA THA   SHA THA   SA THA\nTHA DA   DZA THA   THA RA\nHA THA BA   THA BA KHA\nTHA ZA DHA   SHA TA THA\nHA THA SA   SYA THA DA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 15"
            },
            {
                        "lesson_number": 16,
                        "title": "Hal 16 - Huruf Zha",
                        "arabic_text": "ظَ صَ\nظَ ظَ   ظَ صَ   طَ ظَ\nشَ ظَ   زَ ظَ   صَ طَ\nظَ طَ   ظَ سَ   ظَ دَ\nظَ بَ طَ         سَ ظَ خَ\nصَ حَ ظَ         صَ ظَ بَ\nلَ ظَ بَ         حَ بَ ظَ",
                        "transliteration": "ZHA SHA\nTHA ZHA   ZHA SHA   ZHA ZHA\nSHA THA   ZA ZHA   SYA ZHA\nZHA DA   ZHA SA   ZHA THA\nSA ZHA KHA   ZHA BA THA\nSHA ZHA BA   SHA HA ZHA\nHA BA ZHA   LA ZHA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 16"
            },
            {
                        "lesson_number": 17,
                        "title": "Hal 17 - Huruf 'Ain",
                        "arabic_text": "عَ طَ بَ\nعَ ظَ   عَ طَ   عَ صَ\nشَ عَ   ضَ عَ   عَ ظَ\nعَ زَ   ذَ عَ   عَ دَ\nذَ عَ ظَ         عَ طَ شَ\nسَ صَ عَ         ظَ عَ ضَ\nحَ عَ صَ         عَ ظَ بَ",
                        "transliteration": "'A THA BA\n'A ZHA   'A THA   'A SHA\nSYA 'A   DHA 'A   'A ZHA\n'A ZA   DZA 'A   'A DA\nDZA 'A ZHA   'A THA SYA\nSA SHA 'A   ZHA 'A DHA\nHA 'A SHA   'A ZHA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 17"
            },
            {
                        "lesson_number": 18,
                        "title": "Hal 18 - Latihan",
                        "arabic_text": "صَ بَ رَ   شَ طَ طَ   رَ طَ بَ\nطَ رَ دَ   ظَ بَ طَ   عَ طَ سَ\nحَ صَ دَ   اَ ظَ بَ   طَ رَ دَ\nحَ ضَ رَ   بَ طَ رَ   شَ رَ عَ\nخَ طَ بَ   عَ جَ بَ   بَ شَ رَ\nبَ رَ دَ   زَ رَ عَ   اَ ثَ رَ\nتَ بَ عَ   سَ جَ دَ   شَ رَ بَ\nعَ ضَ بَ   ضَ رَ بَ   عَ رَ ضَ",
                        "transliteration": "SHA BA RA   SYA THA THA   RA THA BA\nTHA RA DA   ZHA BA THA   'A THA SA\nHA SHA DA   A ZHA BA   THA RA DA\nHA DHA RA   BA THA RA   SYA RA 'A\nKHA THA BA   'A JA BA   BA SYA RA\nBA RA DA   ZA RA 'A   A TSA RA\nTA BA 'A   SA JA DA   SYA RA BA\n'A DHA BA   DHA RA BA   'A RA DHA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 18"
            },
            {
                        "lesson_number": 19,
                        "title": "Hal 19 - Huruf Ghain",
                        "arabic_text": "عَ غَ\nغَ غَ   غَ عَ   غَ عَ\nطَ غَ   غَ ظَ   صَ عَ\nغَ ضَ   شَ غَ   خَ غَ\nغَ بَ رَ         شَ غَ رَ\nبَ غَ سَ         غَ سَ طَ\nغَ ضَ بَ         غَ رَ بَ",
                        "transliteration": "'A GHA\nGHA GHA   GHA 'A   GHA 'A\nTHA GHA   GHA ZHA   SHA 'A\nGHA DHA   SYA GHA   KHA GHA\nGHA BA RA   SYA GHA RA\nBA GHA SA   GHA SA THA\nGHA DHA BA   GHA RA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 19"
            },
            {
                        "lesson_number": 20,
                        "title": "Hal 20 - Huruf Fa",
                        "arabic_text": "غَ فَ\nفَ فَ   فَ غَ   فَ عَ\nغَ فَ   ظَ فَ   صَ فَ\nفَ ضَ   فَ شَ   فَ ذَ\nفَ زَ دَ         صَ فَ حَ\nعَ ضَ فَ         عَ رَ فَ\nفَ شَ جَ         ظَ عَ فَ",
                        "transliteration": "GHA FA\nFA FA   FA GHA   FA 'A\nGHA FA   ZHA FA   SHA FA\nFA DHA   FA SYA   FA DZA\nFA ZA DA   SHA FA HA\n'A DHA FA   'A RA FA\nFA SYA JA   ZHA 'A FA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 20"
            },
            {
                        "lesson_number": 21,
                        "title": "Hal 21 - Huruf Qaf",
                        "arabic_text": "فَ قَ\nفَ قَ   قَ فَ   قَ عَ\nفَ قَ   عَ قَ   طَ قَ\nقَ ضَ   فَ ظَ   طَ قَ\nقَ فَ ظَ         عَ قَ بَ\nغَ دَ قَ         زَ عَ فَ\nفَ قَ رَ         غَ رَ قَ",
                        "transliteration": "FA   QA\nFA QA   QA QA   FA QA   'A QA\nFA QA   'A QA   THA QA   QA THA\nQA DHA   FA ZHA   'A QA   BA QA\nFA QA RA   DA QA A   FA RA 'A   QA RA A",
                        "description": "Latihan Tilawati Jilid 1 Halaman 21"
            },
            {
                        "lesson_number": 22,
                        "title": "Hal 22 - Latihan",
                        "arabic_text": "عَ رَ ضَ   غَ دَ قَ   فَ قَ رَ\nعَ رَ فَ   رَ فَ قَ   فَ قَ دَ\nزَ رَ عَ   رَ زَ قَ   قَ تَ دَ\nرَ فَ ثَ   سَ رَ قَ   قَ رَ بَ\nشَ فَ عَ   غَ رَ بَ   عَ دَ بَ\nاَ ثَ رَ   شَ حَ دَ   حَ طَ ظَ\nظَ فَ رَ   جَ رَ دَ   حَ فَ ظَ\nخَ رَ جَ   عَ زَ زَ   غَ سَ قَ",
                        "transliteration": "'A RA DHA   GHA DA QA   FA QA RA\n'A RA FA   RA FA QA   FA QA DA\nZA RA 'A   RA ZA QA   QA TA DA\nRA FA TSA   SA RA QA   QA RA BA\nSYA FA 'A   GHA RA BA   'A DA BA\nA TSA RA   SYA HA DA   HA THA ZHA\nZHA FA RA   JA RA DA   HA FA ZHA\nKHA RA JA   'A ZA ZA   GHA SA QA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 22"
            },
            {
                        "lesson_number": 23,
                        "title": "Hal 23 - Huruf Kaf",
                        "arabic_text": "كَ فَ رَ\nكَ كَ   فَ كَ   كَ قَ\nفَ كَ   قَ كَ   غَ كَ\nكَ غَ   كَ ضَ   كَ صَ\nكَ فَ رَ         قَ سَ كَ\nعَ كَ فَ         بَ رَ كَ\nكَ بَ دَ         سَ رَ كَ",
                        "transliteration": "KA FA RA\nKA KA   FA KA   KA QA\nFA KA   QA KA   GHA KA\nKA GHA   KA DHA   KA SHA\nKA FA RA   QA SA KA\n'A KA FA   BA RA KA\nKA BA DA   SA RA KA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 23"
            },
            {
                        "lesson_number": 24,
                        "title": "Hal 24 - Huruf Lam",
                        "arabic_text": "لَ كَ\nلَ شَ   لَ فَ   قَ لَ\nكَ لَ   لَ خَ   ضَ لَ\nعَ لَ   فَ لَ   لَ ضَ\nعَ دَ لَ         لَ قَ بَ\nجَ عَ لَ         فَ لَ حَ\nغَ زَ لَ         خَ لَ قَ",
                        "transliteration": "LA KA\nLA SYA   LA FA   QA LA\nKA LA   LA KHA   DHA LA\n'A LA   FA LA   LA DHA\n'A DA LA   LA QA BA\nJA 'A LA   FA LA HA\nGHA ZA LA   KHA LA QA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 24"
            },
            {
                        "lesson_number": 25,
                        "title": "Hal 25 - Huruf Mim",
                        "arabic_text": "مَ = مَ\nكَ كَ   فَ كَ   كَ قَ\nلَ سَ   لَ فَ   قَ لَ\nرَ مَ   مَ ضَ   لَ مَ\nقَ مَ رَ   رَ غَ مَ   فَ لَ مَ\nكَ رَ مَ   مَ زَ قَ   عَ ظَ مَ\nمَ رَ حَ   رَ جَ مَ   طَ مَ سَ",
                        "transliteration": "MA = MA\nKA KA   FA KA   KA QA\nLA SA   LA FA   QA LA\nRA MA   MA DHA   LA MA\nQA MA RA   RA GHA MA   FA LA MA\nKA RA MA   MA ZA QA   'A ZHA MA\nMA RA HA   RA JA MA   THA MA SA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 25"
            },
            {
                        "lesson_number": 26,
                        "title": "Hal 26 - Huruf Nun",
                        "arabic_text": "نَ لَ\nنَ لَ   بَ نَ   خَ نَ\nكَ نَ   فَ نَ   نَ جَ\nدَ نَ   نَ دَ   نَ صَ\nفَ نَ دَ   نَ صَ رَ   قَ رَ نَ\nضَ مَ نَ   نَ ظَ مَ   جَ نَ بَ\nحَ ضَ نَ   نَ خَ لَ   حَ سَ نَ",
                        "transliteration": "NA = NA\nNA LA   BA NA   KHA NA\nKA NA   FA NA   NA JA\nDA NA   NA DA   NA SHA\nFA NA DA   NA SHA RA   QA RA NA\nDHA MA NA   NA ZHA MA   JA NA BA\nHA DHA NA   NA KHA LA   HA SA NA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 26"
            },
            {
                        "lesson_number": 27,
                        "title": "Hal 27 - Huruf Wawu",
                        "arabic_text": "وَ قَ فَ\nوَ قَ   وَ فَ   قَ وَ\nرَ وَ   نَ وَ   وَ مَ\nوَ لَ   صَ وَ   طَ وَ\nوَ قَ رَ         صَ وَ بَ\nسَ قَ وَ         وَ رَ دَ\nوَ جَ لَ         زَ وَ لَ",
                        "transliteration": "WA QA FA\nWA QA   WA FA   QA WA\nRA WA   NA WA   WA MA\nWA LA   SHA WA   THA WA\nWA QA RA   SHA WA BA\nSA QA WA   WA RA DA\nWA JA LA   ZA WA LA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 27"
            },
            {
                        "lesson_number": 28,
                        "title": "Hal 28 - Huruf Ha",
                        "arabic_text": "هَ   وَ\nهَ دَ   هَ رَ   وَ هَ\nجَ هَ   شَ هَ   هَ رَ\nهَ وَ   نَ هَ   هَ مَ\nهَ دَ بَ         وَ هَ نَ\nجَ هَ دَ         شَ هَ دَ\nدَ هَ قَ         وَ هَ بَ",
                        "transliteration": "HA WA\nHA DA   HA RA   WA HA\nJA HA   SYA HA   HA RA\nHA WA   NA HA   HA MA\nHA DA BA   WA HA NA\nJA HA DA   SYA HA DA\nDA HA QA   WA HA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 28"
            },
            {
                        "lesson_number": 29,
                        "title": "Hal 29 - Latihan",
                        "arabic_text": "هَ لَ كَ   كَ لَ مَ   فَ هَ دَ\nحَ صَ لَ   هَ دَ مَ   نَ ظَ رَ\nكَ رَ مَ   فَ عَ لَ   غَ سَ مَ\nشَ هَ دَ   جَ عَ لَ   مَ هَ نَ\nجَ بَ لَ   ثَ قَ بَ   وَ طَ رَ\nهَ زَ مَ   نَ زَ لَ   قَ وَ مَ\nحَ زَ نَ   وَ عَ دَ   كَ رَ هَ",
                        "transliteration": "HA LA KA   KA LA MA   FA HA DA\nHA SHA LA   HA DA MA   NA ZHA RA\nKA RA MA   FA 'A LA   GHA SA MA\nSYA HA DA   JA 'A LA   MA HA NA\nJA BA LA   TSA QA BA   WA THA RA\nHA ZA MA   NA ZA LA   QA WA MA\nHA ZA NA   WA 'A DA   KA RA HA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 29"
            },
            {
                        "lesson_number": 30,
                        "title": "Hal 30 - Huruf Hamzah",
                        "arabic_text": "ءَ هَ\nنَ ءَ   ءَ هَ   هَ ءَ\nجَ ءَ   رَ ءَ   سَ ءَ\nلَ ءَ   فَ ءَ   مَ ءَ\nءَ جَ لَ         اَ مَ نَ\nمَ لَ ءَ         اَ خَ ذَ\nسَ ءَ لَ         نَ دَ هَ",
                        "transliteration": "A HA\nNA A   A HA   HA A\nJA A   RA A   SA A\nLA A   FA A   MA A\nLA JA A   A MA NA\nMA LA A   A KHA DZA\nSA A LA   NA DA HA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 30"
            },
            {
                        "lesson_number": 31,
                        "title": "Hal 31 - Huruf Ya",
                        "arabic_text": "يَ ءَ مَ\nيَ ءَ   يَ مَ   مَ يَ\nيَ رَ   وَ يَ   هَ يَ\nقَ يَ   صَ يَ   فَ يَ\nيَ سَ رَ         قَ يَ مَ\nيَ زَ دَ         خَ يَ لَ\nيَ شَ ءَ         عَ يَ مَ",
                        "transliteration": "YA A MA\nYA A   YA MA   MA YA\nYA RA   WA YA   HA YA\nQA YA   SHA YA   FA YA\nYA SA RA   QA YA MA\nYA ZA DA   KHA YA LA\nYA SYA A   'A YA MA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 31"
            },
            {
                        "lesson_number": 32,
                        "title": "Hal 32 - Latihan 1",
                        "arabic_text": "فَ رَ غَ   فَ قَ رَ   صَ دَ قَ\nسَ لَ كَ   كَ لَ مَ   شَ جَ رَ\nنَ وَ لَ   هَ وَ نَ   فَ عَ لَ\nاَ مَ نَ   اَ طَ عَ   جَ دَ لَ\nسَ عَ دَ   شَ قَ يَ   عَ ذَ بَ",
                        "transliteration": "FA RA GHA   FA QA RA   SHA DA QA\nSA LA KA   KA LA MA   SYA JA RA\nNA WA LA   HA WA NA   FA 'A LA\nA MA NA   A THA 'A   JA DA LA\nSA 'A DA   SYA QA YA   'A DZA BA\nA BA TA TSA JA HA KHA DA DZA RA\nZA SA SYA SHA DHA THA ZHA 'A GHA FA\nQA KA LA MA NA WA HA LA A YA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 32"
            },
            {
                        "lesson_number": 33,
                        "title": "Hal 33 - Latihan 9",
                        "arabic_text": "بَ تَ ثَ = بَتَثَ\nبَبَتَ   تَبَثَ   ثَبَتَ\nاَثَبَ   بَدَرَ   ثَبَرَ\nوَثَقَ   تَرَكَ   بَرَزَ\nبَثَطَ   تَزَمَ   رَثَتَ\nتَرَكَ   تَثَرَ   رَتَبَ\nبَتَمَ   طَبَرَ   رَتَبَ\nوَثَبَ   بَرَرَ   دَبَرَ",
                        "transliteration": "BA TA TSA = BA TA TSA\nBA BA TA   TA BA TSA   TSA BA TA\nA TSA BA   BA DA RA   TSA BA RA\nWA TSA QA   TA RA KA   BA RA ZA\nBA TSA THA   TA ZA MA   RA TSA TA\nTA RA KA   TA TSA RA   RA TA BA\nBA TA MA   THA BA RA   RA TA BA\nWA TSA BA   BA RA RA   DA BA RA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 33"
            },
            {
                        "lesson_number": 34,
                        "title": "Hal 34 - Latihan 10",
                        "arabic_text": "جَ حَ خَ = جَحَخَ\nخَزَنَ   جَرَحَ   حَجَمَ\nحَجَرَ   اَخَذَ   خَرَجَ\nحَجَبَ   بَحَثَ   خَطَبَ\nتَحَجَ   حَجَجَ   اَجَجَ\nتَجَخَ   وَجَدَ   زَحَنَ\nثَجَجَ   حَرَزَ   حَجَبَ",
                        "transliteration": "JA HA KHA = JA HA KHA\nKHA ZA NA   JA RA HA   HA JA MA\nHA JA RA   A KHA DZA   KHA RA JA\nHA JA BA   BA HA TSA   KHA THA BA\nTA HA JA   HA JA JA   A JA JA\nTA JA KHA   WA JA DA   ZA HA NA\nTSA JA JA   HA RA ZA   HA JA BA\n104   102   103   101   100   90",
                        "description": "Latihan Tilawati Jilid 1 Halaman 34"
            },
            {
                        "lesson_number": 35,
                        "title": "Hal 35 - Latihan 11",
                        "arabic_text": "سَ شَ = سَشَ\nسَرَحَ   شَجَرَ   سَرَجَ\nحَسَبَ   بَشَرَ   رَسَبَ\nخَرَسَ   حَسَدَ   خَشَرَ\nاَشَرَ   سَوَلَ   سَحَبَ\nسَرَدَ   رَشَدَ   دَرَسَ\nسَحَرَ   رَسَحَ   شَطَبَ",
                        "transliteration": "SA SYA = SA SYA\nSA RA HA   SYA JA RA   SA RA JA\nHA SA BA   BA SYA RA   RA SA BA\nKHA RA SA   HA SA DA   KHA SYA RA\nA SYA RA   SA WA LA   SA HA BA\nSA RA DA   RA SYA DA   DA RA SA\nSA HA RA   RA SA HA   SYA THA BA\n600   500   400   300   200   100",
                        "description": "Latihan Tilawati Jilid 1 Halaman 35"
            },
            {
                        "lesson_number": 36,
                        "title": "Hal 36 - Latihan 12",
                        "arabic_text": "صَ ضَ = صَضَ\nصَرَحَ   حَصَرَ   خَرَبَ\nصَحَبَ   صَبَرَ   ضَحَنَ\nحَضَنَ   حَصَدَ   ضَبَطَ\nصَوَبَ   وَضَحَ   جَحَصَ\nنَصَبَ   صَحَبَ   اَضَبَ\nخَبَضَ   رَضَبَ   طَحَضَ",
                        "transliteration": "SHA DHA = SHA DHA\nSHA RA HA   HA SHA RA   KHA RA BA\nSHA HA BA   SHA BA RA   DHA HA NA\nHA DHA NA   HA SHA DA   DHA BA THA\nSHA WA BA   WA DHA HA   JA HA SHA\nNA SHA BA   SHA HA BA   A DHA BA\nKHA BA DHA   RA DHA BA   THA HA DHA\n1000   700   800   900",
                        "description": "Latihan Tilawati Jilid 1 Halaman 36"
            },
            {
                        "lesson_number": 37,
                        "title": "Hal 37 - Latihan 13",
                        "arabic_text": "عَ عَ عَ = عَعَعَ\nغَ غَ غَ = غَغَغَ\nعَجَبَ   شَعَرَ   عَزَمَ\nغَبَرَ   غَرَقَ   بَسَغَ\nصَعَدَ   عَجَزَ   وَدَعَ\nبَغَدَ   تَسَغَ   سَعَدَ\nعَرَفَ   رَفَعَ   رَجَعَ\nغَدَقَ   بَغَو   تَبَغَ",
                        "transliteration": "'A 'A 'A = 'A 'A 'A\nGHA GHA GHA = GHA GHA GHA\n'A JA BA   SYA 'A RA   'A ZA MA\nGHA BA RA   GHA RA QA   BA SA GHA\nSHA 'A DA   'A JA ZA   WA DA 'A\nBA GHA DA   TA SA GHA   SA 'A DA\n'A RA FA   RA FA 'A   RA JA 'A\nGHA DA QA   BA GHA WA   TA BA GHA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 37"
            },
            {
                        "lesson_number": 38,
                        "title": "Hal 38 - Latihan 14",
                        "arabic_text": "فَ فَ فَ = فَفَفَ\nقَ قَ قَ = قَقَقَ\nفَرَحَ   فَرَجَ   قَدَرَ\nفَرَقَ   سَفَرَ   قَرَمَ\nقَفَرَ   قَصَرَ   صَفَرَ\nفَسَقَ   قَدَرَ   رَفَعَ\nحَرَقَ   قَفَصَ   فَقَضَ\nشَفَقَ   تَقَعَ   رَفَقَ",
                        "transliteration": "FA FA FA = FA FA FA\nQA QA QA = QA QA QA\nFA RA HA   FA RA JA   QA DA RA\nFA RA QA   SA FA RA   QA RA MA\nQA FA RA   QA SHA RA   SHA FA RA\nFA SA QA   QA DA RA   RA FA 'A\nHA RA QA   QA FA SHA   FA QA DHA\nSYA FA QA   TA QA 'A   RA FA QA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 38"
            },
            {
                        "lesson_number": 39,
                        "title": "Hal 39 - Latihan 15",
                        "arabic_text": "لَ لَ لَ = لَلَلَ\nحَلَمَ   سَلَمَ   لَمَسَ\nجَعَلَ   خَبَلَ   لَشَدَ\nعَلَقَ   خَلَقَ   عَظَمَ\nغَلَبَ   بَلَعَ   غَرَمَ\nسَمَعَ   بَلَغَ   عَجَلَ\nطَلَبَ   ثَلَثَ   حَلَمَ\nحَرَمَ   مَلَحَ   دَخَلَ",
                        "transliteration": "LA LA LA = LA LA LA\nHA LA MA   SA LA MA   LA MA SA\nJA 'A LA   KHA BA LA   LA SYA DA\n'A LA QA   KHA LA QA   'A ZHA MA\nGHA LA BA   BA LA 'A   GHA RA MA\nSA MA 'A   BA LA GHA   'A JA LA\nTHA LA BA   TSA LA TSA   HA LA MA\nHA RA MA   MA LA HA   DA KHA LA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 39"
            },
            {
                        "lesson_number": 40,
                        "title": "Hal 40 - Latihan 16",
                        "arabic_text": "كَ = كَ = كَ = كَمَلَ حَكَمَ\nكَرَمَ   شَكَرَ   تَرَكَ\nمَلَكَ   كَلَمَ   ذَكَرَ\nكَسَرَ   كَسَبَ   فَلَكَ\nكَذَبَ   كَسَدَ   كَبَرَ\nكَرَمَ   رَكَبَ   بَرَكَ\nكَتَبَ   سَلَكَ   هَلَكَ\nكَبَرَ   كَمَلَ   بَكَرَ",
                        "transliteration": "KA = KA = KA = KA MA LA HA KA MA\nKA RA MA   SYA KA RA   TA RA KA\nMA LA KA   KA LA MA   DZA KA RA\nKA SA RA   KA SA BA   FA LA KA\nKA DZA BA   KA SA DA   KA BA RA\nKA RA MA   RA KA BA   BA RA KA\nKA TA BA   SA LA KA   HA LA KA\nKA BA RA   KA MA LA   BA KA RA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 40"
            },
            {
                        "lesson_number": 41,
                        "title": "Hal 41 - Latihan 17",
                        "arabic_text": "نَ = نَ = نَزَلَ\nنَصَرَ   صَنَعَ   حَضَنَ\nفَنَدَ   نَفَقَ   حَسَنَ\nنَبَذَ   بَدَنَ   غَنَمَ\nنَعَمَ   قَنَتَ   جَنَبَ\nنَفَرَ   مَنَتَ   فَتَنَ\nسَنَدَ   فَنَنَ   نَفَسَ\nنَذَرَ   مَنَعَ   نَظَرَ",
                        "transliteration": "NA = NA = NA ZA LA\nNA SHA RA   SHA NA 'A   HA DHA NA\nFA NA DA   NA FA QA   HA SA NA\nNA BA DZA   BA DA NA   GHA NA MA\nNA 'A MA   QA NA TA   JA NA BA\nNA FA RA   MA NA TA   FA TA NA\nSA NA DA   FA NA NA   NA FA SA\nNA DZA RA   MA NA 'A   NA ZHA RA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 41"
            },
            {
                        "lesson_number": 42,
                        "title": "Hal 42 - Latihan 18",
                        "arabic_text": "هَ = هَ = هَ = هَ = فَهَدَ\nهَلَكَ   شَهَدَ   كَرَهَ\nجَهَدَ   هَرَبَ   نَهَرَ\nهَذَلَ   لَهَبَ   فَقَهَ\nسَفَهَ   هَدَيَ   بَهَجَ\nمَهَيَ   شَهَقَ   نَزَهَ\nوَهَمَ   ظَهَرَ   بَنَهَ\nشَهَبَ   جَهَلَ   فَهَدَ",
                        "transliteration": "HA = HA = HA = HA = FA HA DA\nHA LA KA   SYA HA DA   KA RA HA\nJA HA DA   HA RA BA   NA HA RA\nHA DZA LA   LA HA BA   FA QA HA\nSA FA HA   HA DA YA   BA HA JA\nMA HA YA   SYA HA QA   NA ZA HA\nWA HA MA   ZHA HA RA   BA NA HA\nSYA HA BA   JA HA LA   FA HA DA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 42"
            },
            {
                        "lesson_number": 43,
                        "title": "Hal 43 - Latihan 19",
                        "arabic_text": "ءَ = أَ = ـئَـ   سَأَلَ\nيَ = يـَ   يَئَمَ\nأَدَمَ   يَسَرَ   فَئَدَ\nسَئَمَ   أَجَلَ   عَصَيَ\nخَيَرَ   بَيَنَ   أَلَمَ\nدَيَرَ   أَدَبَ   بَئَسَ\nيَلَدَ   سَيَرَ   خَطَيَ\nسَئَرَ   لَخَذَ   دَأَبَ\nأَخَذَ   يَتَمَ   بَيَعَ",
                        "transliteration": "A = A = A   SA A LA\nYA = YA   YA YA MA\nA DA MA   YA SA RA   FA A DA\nSA A MA   A JA LA   'A SHA YA\nKHA YA RA   BA YA NA   A LA MA\nDA YA RA   A DA BA   BA A SA\nYA LA DA   SA YA RA   KHA THA YA\nSA A RA   YA KHA DZA   DA A BA\nA KHA DZA   YA TA MA   BA YA 'A",
                        "description": "Latihan Tilawati Jilid 1 Halaman 43"
            },
            {
                        "lesson_number": 44,
                        "title": "Hal 44 - Latihan 20",
                        "arabic_text": "عَلَمَ وَحَكَمَ   رَءَفَ وَرَحَمَ\nغَفَرَ وَشَكَرَ   شَهَدَ وَمَجَدَ\nسَمَعَ وَبَصَرَ   عَذَبَ وَحَدَقَ\nصَعَدَ وَزَلَقَ   ظَهَرَ وَطَبَقَ\nعَمَلَ وَصَلَحَ   فَخَرَ وَذَنَبَ\nبَشَرَ وَنَذَرَ   ضَلَلَ وَمَيَنَ\nعَزَزَ وَحَلَمَ   شَهَبَ وَثَقَبَ\nكَتَبَ وَمَبَنَ   عَذَبَ وَمَهَنَ",
                        "transliteration": "'A LA MA WA HA KA MA   RA A FA WA RA HA MA\nGHA FA RA WA SYA KA RA   SYA HA DA WA MA JA DA\nSA MA 'A WA BA SHA RA   'A DZA BA WA HA DA QA\nSHA 'A DA WA ZA LA QA   ZHA HA RA WA THA BA QA\n'A MA LA WA SHA LA HA   FA KHA RA WA DZA NA BA\nBA SYA RA WA NA DZA RA   DHA LA LA WA MA YA NA\n'A ZA ZA WA HA LA MA   SYA HA BA WA TSA QA BA\nKA TA BA WA BA YA NA   'A DZA BA WA MA HA NA",
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
                "transliteration": "BATA NASHARA KATABA",
                "description": "Membaca huruf hijaiyah yang disambung di awal kata",
            },
            {
                "lesson_number": 2,
                "title": "Huruf Sambung Tengah",
                "arabic_text": "سَمِعَ عَلِمَ فَهِمَ",
                "transliteration": "SAMI'A 'ALIMA FAHIMA",
                "description": "Membaca huruf hijaiyah yang disambung di tengah kata",
            },
            {
                "lesson_number": 3,
                "title": "Huruf Sambung Akhir",
                "arabic_text": "ذَهَبَ حَسُنَ كَرُمَ",
                "transliteration": "DZAHABA HASUNA KARUMA",
                "description": "Membaca huruf hijaiyah yang disambung di akhir kata",
            },
            {
                "lesson_number": 4,
                "title": "Kata dengan Tanwin",
                "arabic_text": "كِتَابًا عِلْمًا نُوْرًا",
                "transliteration": "KITAABAN 'ILMAN NUURAN",
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
                "transliteration": "QAALA - KIILA - YAQUULU",
                "description": "Belajar membaca mad asli dengan panjang 2 harakat",
            },
            {
                "lesson_number": 2,
                "title": "Sukun dan Qalqalah",
                "arabic_text": "اَلْحَمْدُ - يَبْدَأُ",
                "transliteration": "ALHAMDU - YABDA-U",
                "description": "Belajar membaca huruf sukun dan huruf qalqalah",
            },
            {
                "lesson_number": 3,
                "title": "Tasydid",
                "arabic_text": "إِنَّ - أَنَّ - رَبَّكَ",
                "transliteration": "INNA - ANNA - RABBAKA",
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
                "transliteration": "MAN A'THA - MIN 'ILMIN",
                "description": "Nun sukun bertemu huruf halqi: dibaca jelas",
            },
            {
                "lesson_number": 2,
                "title": "Nun Sukun - Idgham",
                "arabic_text": "مَنْ يَعْمَلْ - مِنْ وَلِيٍّ",
                "transliteration": "MAY YA'MAL - MIW WALIYYIN",
                "description": "Nun sukun bertemu huruf idgham: dilebur",
            },
            {
                "lesson_number": 3,
                "title": "Nun Sukun - Ikhfa",
                "arabic_text": "مِنْ قَبْلِ - أَنْتُمْ",
                "transliteration": "MIN QABLI - ANTUM",
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
                "transliteration": "BISMILLAHIRRAHMANIRRAHIIM",
                "description": "Belajar berhenti pada tanda waqaf lazim",
            },
            {
                "lesson_number": 2,
                "title": "Waqaf Ja'iz",
                "arabic_text": "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
                "transliteration": "ALHAMDULILLAHI RABBIL 'AALAMIIN",
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
                "transliteration": "IWAJA (saktah) QAYYIMAN",
                "description": "Belajar membaca saktah: berhenti sejenak tanpa bernapas",
            },
            {
                "lesson_number": 2,
                "title": "Isymam & Imalah",
                "arabic_text": "لَا تَأْمَ۪نَّا",
                "transliteration": "LAA TA'MANNAA",
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
    Transkripsi audio menggunakan model ASR lokal (HPT-D).
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
    Evaluate audio recording using HPT-D ASR model.
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
