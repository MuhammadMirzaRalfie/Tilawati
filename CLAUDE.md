# CLAUDE.md — Tilawati: Aplikasi Pembelajaran Bacaan Al-Qur'an Berbasis AI

Aplikasi Flutter + FastAPI untuk membantu pengguna belajar dan mengevaluasi bacaan Al-Qur'an metode Tilawati. User merekam bacaan per halaman, backend mengevaluasi dengan AI, lalu menampilkan skor dan feedback.

---

## Konteks Proyek

**Tugas Akhir:** Tilawati Hijaiyah ASR — pengenalan dan evaluasi ucapan huruf hijaiyah.
**Target Platform:** Android (prioritas), iOS, Web.
**Stack:** Flutter (frontend) + FastAPI + PostgreSQL (backend).
**Status AI:** Evaluasi masih **mock** (skor acak). Integrasi model AI nyata belum dilakukan.

---

## Struktur Direktori Aktual

```
D:\TA\Tilawati\
├── frontend/                    # Flutter app
│   ├── lib/
│   │   ├── main.dart            # Entry point, MultiProvider, routes
│   │   ├── config/
│   │   │   ├── theme.dart       # AppTheme, AppColors
│   │   │   └── api_config.dart  # Base URL & semua endpoint URL
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── jilid_model.dart
│   │   │   └── evaluation_model.dart
│   │   ├── services/
│   │   │   └── api_service.dart # HTTP client (get/post/postMultipart + JWT token)
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── lesson_provider.dart
│   │   │   └── evaluation_provider.dart
│   │   └── screens/
│   │       ├── splash_screen.dart
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       ├── home_screen.dart
│   │       ├── jilid_selection_screen.dart
│   │       ├── lesson_screen.dart    # ← rekam audio ada di sini (bukan screen terpisah)
│   │       ├── evaluation_screen.dart # ← MASIH MOCK, belum konek API
│   │       └── progress_screen.dart
│   └── pubspec.yaml
│
└── backend/
    ├── app/
    │   ├── main.py              # FastAPI + CORS + router registration
    │   ├── config.py            # Settings (DB URL, JWT secret, dll)
    │   ├── database.py          # SQLAlchemy async engine + get_db
    │   ├── models/
    │   │   ├── user.py
    │   │   ├── evaluation.py
    │   │   └── progress.py
    │   ├── schemas/
    │   │   ├── user.py
    │   │   ├── evaluation.py
    │   │   └── progress.py
    │   ├── routers/
    │   │   ├── auth.py          # POST /api/auth/register, /login, GET /me
    │   │   ├── lessons.py       # GET /api/lessons/jilids, /jilids/{id}, /jilids/{id}/lessons/{n}
    │   │   ├── evaluation.py    # POST /api/evaluation/submit, GET /history, /{id}
    │   │   └── progress.py      # GET /api/progress/dashboard, /jilid/{id}
    │   ├── services/
    │   │   ├── auth_service.py  # JWT + password hashing + get_current_user
    │   │   └── ai_service.py    # Konten Tilawati + evaluate_audio (MOCK)
    │   └── utils/
    │       └── audio.py
    ├── requirements.txt
    └── .env / .env.example
```

---

## API Endpoints (Backend Lokal)

### Base URL
```
http://10.0.2.2:8000   # Android emulator
http://localhost:8000   # iOS simulator / Web
http://192.168.x.x:8000 # Real device (ganti IP)
```
Konfigurasi di `frontend/lib/config/api_config.dart`.

### Auth
| Method | Path | Deskripsi |
|--------|------|-----------|
| POST | `/api/auth/register` | Daftar user baru |
| POST | `/api/auth/login` | Login, dapat JWT token |
| GET | `/api/auth/me` | Info user saat ini |

### Lessons
| Method | Path | Deskripsi |
|--------|------|-----------|
| GET | `/api/lessons/jilids` | List semua jilid |
| GET | `/api/lessons/jilids/{id}` | Detail + list halaman jilid |
| GET | `/api/lessons/jilids/{id}/lessons/{n}` | Detail halaman tertentu |

### Evaluation
| Method | Path | Deskripsi |
|--------|------|-----------|
| POST | `/api/evaluation/submit` | Upload audio WAV, dapat skor |
| GET | `/api/evaluation/history` | Riwayat evaluasi user |
| GET | `/api/evaluation/{id}` | Detail satu evaluasi |

Request submit: `multipart/form-data` — field `jilid` (int), `lesson_number` (int), `audio` (file WAV).

Response submit:
```json
{
  "overall_score": 78.5,
  "makharijul_huruf_score": 82.3,
  "tajwid_score": 74.1,
  "kelancaran_score": 79.8,
  "feedback_json": { "grade": "...", "message": "...", "tips": [...] },
  "phoneme_details": { "phonemes": [...], "correct_count": 12, ... }
}
```

### Progress
| Method | Path | Deskripsi |
|--------|------|-----------|
| GET | `/api/progress/dashboard` | Ringkasan progres semua jilid |
| GET | `/api/progress/jilid/{id}` | Progres spesifik satu jilid |

---

## Flutter Dependencies

```yaml
provider: ^6.1.2          # state management
http: ^1.2.2              # HTTP client
shared_preferences: ^2.3.2 # simpan JWT token
record: any               # rekam audio 16kHz mono WAV
audioplayers: ^6.1.0      # playback audio
fl_chart: ^0.69.0         # grafik progres
google_fonts: ^6.2.1      # tipografi
percent_indicator: ^4.2.3 # circular score indicator
lottie: ^3.1.3            # animasi
path_provider: ^2.1.4     # direktori temp
permission_handler: ^11.3.1 # izin mikrofon
```

---

## Backend Dependencies

```
fastapi, uvicorn, sqlalchemy (async), asyncpg, psycopg2-binary
python-jose, passlib[bcrypt]        # JWT + hashing
python-multipart                    # upload file
alembic                             # migrasi DB
librosa, numpy                      # audio processing (belum dipakai aktif)
```

---

## Status Progress

### Selesai
- [x] Semua screen Flutter: splash, login, register, home, jilid-selection, lesson, evaluation, progress
- [x] Rekaman audio 16kHz mono WAV di `lesson_screen.dart` (bukan screen terpisah)
- [x] `api_service.dart` — HTTP client dengan JWT + multipart support
- [x] Backend FastAPI: auth (JWT), lesson router, evaluation router, progress router
- [x] Konten Jilid 1: **40 halaman** — hal 1–11 lengkap (teks Arab + transliterasi), hal 12–40 placeholder
- [x] Konten Jilid 2–6: data minimal/dummy (2–4 pelajaran per jilid)
- [x] Evaluasi mock: skor acak realistis + feedback teks di `ai_service.py`

### Belum Selesai / Perlu Dilanjutkan
- [ ] **`evaluation_screen.dart` belum konek API** — masih pakai skor hardcoded, perlu panggil `POST /api/evaluation/submit`
- [ ] **Integrasi AI nyata** — `evaluate_audio()` di `ai_service.py` masih mock, perlu ganti dengan model ASR/Forced Alignment
- [ ] Konten Jilid 1 hal 12–40 masih placeholder (teks Arab generik)
- [ ] Konten Jilid 2–6 masih sangat minimal
- [ ] Setup database: PostgreSQL belum dijalankan, Alembic migrations belum diinisialisasi
- [ ] `docker-compose.yml` belum dibuat
- [ ] Testing end-to-end belum dilakukan

---

## Catatan Penting

- Audio recording dikonfigurasi **16 kHz mono WAV** di `lesson_screen.dart:49-53`.
- JWT token disimpan di `SharedPreferences`, diload otomatis via `ApiService.loadToken()`.
- Evaluation screen menerima args: `jilid` (int), `lesson` (Map), `audioPath` (String), `color` (Color).
- Evaluasi scoring: makharijul huruf 40% + tajwid 35% + kelancaran 25%.
- Grade: Mumtaz ≥85, Jayyid Jiddan ≥70, Jayyid ≥55, Maqbul <55.
- Backend butuh PostgreSQL — jalankan dulu sebelum `uvicorn app.main:app --reload`.
- CORS sudah `allow_origins=["*"]`, Flutter Web tidak perlu proxy.
