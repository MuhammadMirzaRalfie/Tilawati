"""
AI Service - Placeholder for Contrastive Learning & Forced Alignment

This module will eventually integrate:
1. Forced Alignment: Phoneme-level alignment of recorded audio with reference text
2. Contrastive Learning: Quality comparison between user's reading and reference readings

For now, it generates mock evaluation scores for development purposes.
"""

import random
import uuid
from typing import Any


# Data konten Tilawati (dummy)
    1: {
        "title": "Jilid 1 - Huruf Hijaiyah",
        "description": "Pengenalan huruf hijaiyah dan harakat fathah",
        "icon": "menu_book",
        "color": "#1B5E20",
        "lessons": [
            {
                        "lesson_number": 1,
                        "title": "Hal 1 - Huruf Alif & Ba",
                        "arabic_text": "اَ بَ   اَ بَ   اَ بَ",
                        "transliteration": "A BA   A BA   A BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 1"
            },
            {
                        "lesson_number": 2,
                        "title": "Hal 2 - Huruf Ta",
                        "arabic_text": "بَ تَ   بَ تَ   بَ تَ",
                        "transliteration": "BA TA   BA TA   BA TA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 2"
            },
            {
                        "lesson_number": 3,
                        "title": "Hal 3 - Huruf Tsa",
                        "arabic_text": "تَ ثَ   تَ ثَ   تَ ثَ",
                        "transliteration": "TA TSA   TA TSA   TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 3"
            },
            {
                        "lesson_number": 4,
                        "title": "Hal 4 - Huruf Jim & Ha",
                        "arabic_text": "جَ حَ   جَ حَ   جَ حَ",
                        "transliteration": "JA HA   JA HA   JA HA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 4"
            },
            {
                        "lesson_number": 5,
                        "title": "Hal 5 - Huruf Kha",
                        "arabic_text": "خَ بَ ثَ   خَ بَ ثَ   خَ بَ ثَ",
                        "transliteration": "KHA BA TSA   KHA BA TSA   KHA BA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 5"
            },
            {
                        "lesson_number": 6,
                        "title": "Hal 6 - Huruf Dal & Dzal",
                        "arabic_text": "دَ ذَ   دَ ذَ   دَ ذَ",
                        "transliteration": "DA DZA   DA DZA   DA DZA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 6"
            },
            {
                        "lesson_number": 7,
                        "title": "Hal 7 - Huruf Ra & Za",
                        "arabic_text": "رَ زَ   رَ زَ   رَ زَ",
                        "transliteration": "RA ZA   RA ZA   RA ZA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 7"
            },
            {
                        "lesson_number": 8,
                        "title": "Hal 8 - Huruf Sin",
                        "arabic_text": "سَ رَ زَ   سَ رَ زَ   سَ رَ زَ",
                        "transliteration": "SA RA ZA   SA RA ZA   SA RA ZA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 8"
            },
            {
                        "lesson_number": 9,
                        "title": "Hal 9 - Huruf Syin",
                        "arabic_text": "شَ رَ حَ   شَ رَ حَ   شَ رَ حَ",
                        "transliteration": "SYA RA HA   SYA RA HA   SYA RA HA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 9"
            },
            {
                        "lesson_number": 10,
                        "title": "Hal 10 - Huruf Shad",
                        "arabic_text": "صَ حَ بَ   صَ حَ بَ   صَ حَ بَ",
                        "transliteration": "SHA HA BA   SHA HA BA   SHA HA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 10"
            },
            {
                        "lesson_number": 11,
                        "title": "Hal 11 - Huruf Dhad",
                        "arabic_text": "ضَ رَ بَ   ضَ رَ بَ   ضَ رَ بَ",
                        "transliteration": "DHA RA BA   DHA RA BA   DHA RA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 11"
            },
            {
                        "lesson_number": 12,
                        "title": "Hal 12 - Huruf Tha",
                        "arabic_text": "طَ بَ خَ   طَ بَ خَ   طَ بَ خَ",
                        "transliteration": "THA BA KHA   THA BA KHA   THA BA KHA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 12"
            },
            {
                        "lesson_number": 13,
                        "title": "Hal 13 - Huruf Zha",
                        "arabic_text": "ظَ صَ   ظَ صَ   ظَ صَ",
                        "transliteration": "ZHA SHA   ZHA SHA   ZHA SHA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 13"
            },
            {
                        "lesson_number": 14,
                        "title": "Hal 14 - Huruf 'Ain",
                        "arabic_text": "عَ طَ بَ   عَ طَ بَ   عَ طَ بَ",
                        "transliteration": "'A THA BA   'A THA BA   'A THA BA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 14"
            },
            {
                        "lesson_number": 15,
                        "title": "Hal 15 - Huruf Ghain",
                        "arabic_text": "غَ عَ   غَ عَ   غَ عَ",
                        "transliteration": "GHA 'A   GHA 'A   GHA 'A",
                        "description": "Latihan Tilawati Jilid 1 Halaman 15"
            },
            {
                        "lesson_number": 16,
                        "title": "Hal 16 - Huruf Fa",
                        "arabic_text": "فَ قَ   فَ قَ   فَ قَ",
                        "transliteration": "FA QA   FA QA   FA QA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 16"
            },
            {
                        "lesson_number": 17,
                        "title": "Hal 17 - Huruf Qaf",
                        "arabic_text": "قَ فَ   قَ فَ   قَ فَ",
                        "transliteration": "QA FA   QA FA   QA FA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 17"
            },
            {
                        "lesson_number": 18,
                        "title": "Hal 18 - Huruf Kaf",
                        "arabic_text": "كَ   كَ   كَ",
                        "transliteration": "KA   KA   KA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 18"
            },
            {
                        "lesson_number": 19,
                        "title": "Hal 19 - Huruf Lam",
                        "arabic_text": "لَ   لَ   لَ",
                        "transliteration": "LA   LA   LA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 19"
            },
            {
                        "lesson_number": 20,
                        "title": "Hal 20 - Huruf Mim",
                        "arabic_text": "مَ نَ   مَ نَ   مَ نَ",
                        "transliteration": "MA NA   MA NA   MA NA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 20"
            },
            {
                        "lesson_number": 21,
                        "title": "Hal 21 - Huruf Nun",
                        "arabic_text": "نَ   نَ   نَ",
                        "transliteration": "NA   NA   NA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 21"
            },
            {
                        "lesson_number": 22,
                        "title": "Hal 22 - Huruf Wawu",
                        "arabic_text": "وَ هَ   وَ هَ   وَ هَ",
                        "transliteration": "WA HA   WA HA   WA HA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 22"
            },
            {
                        "lesson_number": 23,
                        "title": "Hal 23 - Huruf Ha",
                        "arabic_text": "هَ   هَ   هَ",
                        "transliteration": "HA   HA   HA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 23"
            },
            {
                        "lesson_number": 24,
                        "title": "Hal 24 - Huruf Ya",
                        "arabic_text": "يَ اَ   يَ اَ   يَ اَ",
                        "transliteration": "YA A   YA A   YA A",
                        "description": "Latihan Tilawati Jilid 1 Halaman 24"
            },
            {
                        "lesson_number": 25,
                        "title": "Hal 25 - Latihan 1",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 25"
            },
            {
                        "lesson_number": 26,
                        "title": "Hal 26 - Latihan 2",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 26"
            },
            {
                        "lesson_number": 27,
                        "title": "Hal 27 - Latihan 3",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 27"
            },
            {
                        "lesson_number": 28,
                        "title": "Hal 28 - Latihan 4",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 28"
            },
            {
                        "lesson_number": 29,
                        "title": "Hal 29 - Latihan 5",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 29"
            },
            {
                        "lesson_number": 30,
                        "title": "Hal 30 - Latihan 6",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 30"
            },
            {
                        "lesson_number": 31,
                        "title": "Hal 31 - Latihan 7",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 31"
            },
            {
                        "lesson_number": 32,
                        "title": "Hal 32 - Latihan 8",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 32"
            },
            {
                        "lesson_number": 33,
                        "title": "Hal 33 - Latihan 9",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 33"
            },
            {
                        "lesson_number": 34,
                        "title": "Hal 34 - Latihan 10",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 34"
            },
            {
                        "lesson_number": 35,
                        "title": "Hal 35 - Latihan 11",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 35"
            },
            {
                        "lesson_number": 36,
                        "title": "Hal 36 - Latihan 12",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 36"
            },
            {
                        "lesson_number": 37,
                        "title": "Hal 37 - Latihan 13",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 37"
            },
            {
                        "lesson_number": 38,
                        "title": "Hal 38 - Latihan 14",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 38"
            },
            {
                        "lesson_number": 39,
                        "title": "Hal 39 - Latihan 15",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 39"
            },
            {
                        "lesson_number": 40,
                        "title": "Hal 40 - Latihan 16",
                        "arabic_text": "اَ بَ تَ ثَ   اَ بَ تَ ثَ   اَ بَ تَ ثَ",
                        "transliteration": "A BA TA TSA   A BA TA TSA   A BA TA TSA",
                        "description": "Latihan Tilawati Jilid 1 Halaman 40"
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
                "arabic_text": "اَلْحَمْدُ - يَبْدَأُ - تَقْرَأُ",
                "transliteration": "ALHAMDU - YABDA-U - TAQRA-U",
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
                "arabic_text": "مَنْ أَعْطَى - مِنْ عِلْمٍ - عَنْ حَقٍّ",
                "transliteration": "MAN A'THA - MIN 'ILMIN - 'AN HAQQIN",
                "description": "Nun sukun bertemu huruf halqi: dibaca jelas",
            },
            {
                "lesson_number": 2,
                "title": "Nun Sukun - Idgham",
                "arabic_text": "مَنْ يَعْمَلْ - مِنْ وَلِيٍّ - مِنْ رَبِّكَ",
                "transliteration": "MAY YA'MAL - MIW WALIYYIN - MIR RABBIKA",
                "description": "Nun sukun bertemu huruf idgham: dilebur",
            },
            {
                "lesson_number": 3,
                "title": "Nun Sukun - Ikhfa",
                "arabic_text": "مِنْ قَبْلِ - أَنْتُمْ - مُنْذِرٌ",
                "transliteration": "MIN QABLI - ANTUM - MUNDZIRUN",
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
                "arabic_text": "لَا تَأْمَ۪نَّا - بِسْمِ ٱللَّهِ مَجْر۪ىٰهَا",
                "transliteration": "LAA TA'MANNAA - BISMILLAAHI MAJRAAHAA",
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


async def evaluate_audio(audio_path: str, jilid: int, lesson_number: int) -> dict:
    """
    Evaluate audio recording against reference.

    TODO: Replace with actual AI model integration:
    1. Forced Alignment for phoneme-level analysis
    2. Contrastive Learning for quality comparison

    Currently returns mock scores for development.
    """
    lesson = get_lesson(jilid, lesson_number)
    if lesson is None:
        return {"error": "Lesson not found"}

    # Generate realistic mock scores
    base_score = random.uniform(60, 95)

    makharijul_huruf = min(100, max(0, base_score + random.uniform(-10, 10)))
    tajwid = min(100, max(0, base_score + random.uniform(-15, 15)))
    kelancaran = min(100, max(0, base_score + random.uniform(-8, 8)))
    overall = (makharijul_huruf * 0.4 + tajwid * 0.35 + kelancaran * 0.25)

    # Generate phoneme feedback
    phoneme_feedback = _generate_phoneme_feedback(lesson["arabic_text"])

    # Generate text feedback
    feedback = _generate_feedback(overall, makharijul_huruf, tajwid, kelancaran)

    return {
        "overall_score": round(overall, 1),
        "makharijul_huruf_score": round(makharijul_huruf, 1),
        "tajwid_score": round(tajwid, 1),
        "kelancaran_score": round(kelancaran, 1),
        "feedback_json": feedback,
        "phoneme_details": phoneme_feedback,
    }


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
