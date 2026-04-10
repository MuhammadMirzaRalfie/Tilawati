import json

class_lessons = [
    {"title": "Huruf Alif & Ba", "arabic": "اَ بَ", "transliteration": "A BA"},
    {"title": "Huruf Ta", "arabic": "بَ تَ", "transliteration": "BA TA"},
    {"title": "Huruf Tsa", "arabic": "تَ ثَ", "transliteration": "TA TSA"},
    {"title": "Huruf Jim & Ha", "arabic": "جَ حَ", "transliteration": "JA HA"},
    {"title": "Huruf Kha", "arabic": "خَ بَ ثَ", "transliteration": "KHA BA TSA"},
    {"title": "Huruf Dal & Dzal", "arabic": "دَ ذَ", "transliteration": "DA DZA"},
    {"title": "Huruf Ra & Za", "arabic": "رَ زَ", "transliteration": "RA ZA"},
    {"title": "Huruf Sin", "arabic": "سَ رَ زَ", "transliteration": "SA RA ZA"},
    {"title": "Huruf Syin", "arabic": "شَ رَ حَ", "transliteration": "SYA RA HA"},
    {"title": "Huruf Shad", "arabic": "صَ حَ بَ", "transliteration": "SHA HA BA"},
    {"title": "Huruf Dhad", "arabic": "ضَ رَ بَ", "transliteration": "DHA RA BA"},
    {"title": "Huruf Tha", "arabic": "طَ بَ خَ", "transliteration": "THA BA KHA"},
    {"title": "Huruf Zha", "arabic": "ظَ صَ", "transliteration": "ZHA SHA"},
    {"title": "Huruf 'Ain", "arabic": "عَ طَ بَ", "transliteration": "'A THA BA"},
    {"title": "Huruf Ghain", "arabic": "غَ عَ", "transliteration": "GHA 'A"},
    {"title": "Huruf Fa", "arabic": "فَ قَ", "transliteration": "FA QA"},
    {"title": "Huruf Qaf", "arabic": "قَ فَ", "transliteration": "QA FA"},
    {"title": "Huruf Kaf", "arabic": "كَ", "transliteration": "KA"},
    {"title": "Huruf Lam", "arabic": "لَ", "transliteration": "LA"},
    {"title": "Huruf Mim", "arabic": "مَ نَ", "transliteration": "MA NA"},
    {"title": "Huruf Nun", "arabic": "نَ", "transliteration": "NA"},
    {"title": "Huruf Wawu", "arabic": "وَ هَ", "transliteration": "WA HA"},
    {"title": "Huruf Ha", "arabic": "هَ", "transliteration": "HA"},
    {"title": "Huruf Ya", "arabic": "يَ اَ", "transliteration": "YA A"}
]

lessons = []
for i in range(1, 41):
    if i - 1 < len(class_lessons):
        base = class_lessons[i - 1]
    else:
        base = {"title": f"Latihan {i - len(class_lessons)}", "arabic": f"اَ بَ تَ ثَ", "transliteration": "A BA TA TSA"}
    
    lesson = {
        "number": i,
        "title": f"Hal {i} - {base['title']}",
        "arabic": f"{base['arabic']}   {base['arabic']}   {base['arabic']}",
        "transliteration": f"{base['transliteration']}   {base['transliteration']}   {base['transliteration']}",
        "desc": f"Latihan Tilawati Jilid 1 Halaman {i}"
    }
    lessons.append(lesson)

dart_code = f"""
    {{
      'jilid': 1,
      'title': 'Jilid 1 - Huruf Hijaiyah',
      'description': 'Pengenalan huruf hijaiyah dan harakat fathah',
      'icon': Icons.menu_book_rounded,
      'color': const Color(0xFF1B5E20),
      'lessons': {json.dumps(lessons, indent=8, ensure_ascii=False).replace('"', "'")},
    }},"""
with open("d:/TA/Tilawati/frontend/temp_jilid.txt", "w", encoding="utf-8") as f:
    f.write(dart_code)

backend_json = json.dumps([{
    "lesson_number": l["number"],
    "title": l["title"],
    "arabic_text": l["arabic"],
    "transliteration": l["transliteration"],
    "description": l["desc"]
} for l in lessons], indent=12, ensure_ascii=False)

python_code = f"""
    1: {{
        "title": "Jilid 1 - Huruf Hijaiyah",
        "description": "Pengenalan huruf hijaiyah dan harakat fathah",
        "icon": "menu_book",
        "color": "#1B5E20",
        "lessons": {backend_json}
    }},
"""
with open("d:/TA/Tilawati/backend/temp_jilid_backend.txt", "w", encoding="utf-8") as f:
    f.write(python_code)
