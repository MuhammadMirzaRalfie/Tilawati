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
TILAWATI_CONTENT = {
    1: {
        "title": "Jilid 1 - Huruf Hijaiyah",
        "description": "Pengenalan huruf hijaiyah dan harakat dasar",
        "icon": "menu_book",
        "color": "#1B5E20",
        "lessons": [
            {
                "lesson_number": 1,
                "title": "Huruf Alif - Ba - Ta",
                "arabic_text": "أَ بَ تَ أِ بِ تِ أُ بُ تُ",
                "transliteration": "A BA TA I BI TI U BU TU",
                "description": "Belajar membaca huruf Alif, Ba, dan Ta dengan harakat fathah, kasrah, dan dhammah",
            },
            {
                "lesson_number": 2,
                "title": "Huruf Tsa - Jim - Ha",
                "arabic_text": "ثَ جَ حَ ثِ جِ حِ ثُ جُ حُ",
                "transliteration": "TSA JA HA TSI JI HI TSU JU HU",
                "description": "Belajar membaca huruf Tsa, Jim, dan Ha dengan harakat dasar",
            },
            {
                "lesson_number": 3,
                "title": "Huruf Kha - Dal - Dzal",
                "arabic_text": "خَ دَ ذَ خِ دِ ذِ خُ دُ ذُ",
                "transliteration": "KHA DA DZA KHI DI DZI KHU DU DZU",
                "description": "Belajar membaca huruf Kha, Dal, dan Dzal dengan harakat dasar",
            },
            {
                "lesson_number": 4,
                "title": "Huruf Ra - Za - Sin",
                "arabic_text": "رَ زَ سَ رِ زِ سِ رُ زُ سُ",
                "transliteration": "RA ZA SA RI ZI SI RU ZU SU",
                "description": "Belajar membaca huruf Ra, Za, dan Sin dengan harakat dasar",
            },
            {
                "lesson_number": 5,
                "title": "Huruf Syin - Shad - Dhad",
                "arabic_text": "شَ صَ ضَ شِ صِ ضِ شُ صُ ضُ",
                "transliteration": "SYA SHA DHA SYI SHI DHI SYU SHU DHU",
                "description": "Belajar membaca huruf Syin, Shad, dan Dhad dengan harakat dasar",
            },
        ],
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
