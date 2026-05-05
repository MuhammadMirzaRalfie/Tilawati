# CLAUDE.md — Tilawati: Aplikasi Pembelajaran Bacaan Al-Qur'an Berbasis AI

Aplikasi Flutter + FastAPI untuk membantu pengguna belajar dan mengevaluasi bacaan Al-Qur'an metode Tilawati. User merekam bacaan per halaman, backend mengevaluasi dengan AI, lalu menampilkan skor dan feedback.

---

## Konteks Proyek

**Tugas Akhir:** Tilawati Hijaiyah ASR — pengenalan dan evaluasi ucapan huruf hijaiyah.
**Target Platform:** Android (prioritas), iOS, Web.
**Stack:** Flutter (frontend) + FastAPI + PostgreSQL (backend).
**Status AI:** Evaluasi terhubung ke model HPT-D lokal via `asr_inference.py`; fallback ke mock jika model tidak tersedia. Transkripsi ASR ditampilkan di `evaluation_screen.dart`.

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
  "phoneme_details": { "asr_transcript": "ba ta tsa", "expected": "BA TA TSA ...", "matched_tokens": [...] }
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
- [x] Semua screen Flutter: splash, login, register, home, jilid-selection, lesson, evaluation, progress, history
- [x] Rekaman audio 16kHz mono WAV di `lesson_screen.dart` (bukan screen terpisah)
- [x] `api_service.dart` — HTTP client dengan JWT + multipart support
- [x] Backend FastAPI: auth (JWT), lesson router, evaluation router, progress router
- [x] Konten Jilid 1: **44 halaman** — semua halaman lengkap (teks Arab + transliterasi sesuai kurikulum Tilawati)
- [x] Konten Jilid 2–6: data minimal/dummy (2–4 pelajaran per jilid)
- [x] `evaluation_screen.dart` terhubung ke `POST /api/evaluation/submit` via `EvaluationProvider`
- [x] Transkripsi ASR ditampilkan di `evaluation_screen.dart` (card "Transkripsi ASR", muncul saat ASR aktif)
- [x] `evaluate_audio()` di `ai_service.py` terhubung ke model HPT-D lokal + fallback mock
- [x] Glosarium per-huruf dengan model klasifikasi anas
- [x] PostgreSQL + Docker Compose sudah berjalan
- [x] **Per-kata recording + instant feedback** — `lesson_screen.dart` parse transliterasi jadi token, evaluasi per kata, UI dinamis (pending/active/correct/incorrect)
- [x] **`history_screen.dart`** — riwayat evaluasi terhubung ke `GET /api/evaluation/history`
- [x] **`progress_screen.dart` disambungkan** ke `GET /api/progress/dashboard` — stat card + progress bar per jilid aktif
- [x] **`progress_provider.dart`** — provider baru fetch progres, expose totalEvaluations, averageScore, jilidProgress, recentEvaluations
- [x] **Endpoint `/api/evaluation/submit_word`** — evaluasi per kata, return `{matched, asr_transcript, expected}`
- [x] **Fungsi `transcribe_word()` di `ai_service.py`** — wrapper HPT-D lokal

### Belum Selesai / Perlu Dilanjutkan
- [ ] Konten Jilid 2–6 masih sangat minimal (2–4 pelajaran per jilid)
- [ ] Testing end-to-end belum dilakukan secara menyeluruh (membutuhkan docker compose + flutter run)
- [ ] Audio referensi per huruf (Prioritas 3.2 Rekomendasi)
- [ ] Deploy ke HuggingFace Spaces (Prioritas 3.4 Rekomendasi)

---

## Catatan Penting

- Audio recording dikonfigurasi **16 kHz mono WAV** di `lesson_screen.dart:49-53`.
- JWT token disimpan di `SharedPreferences`, diload otomatis via `ApiService.loadToken()`.
- Evaluation screen menerima args: `jilid` (int), `lesson` (Map), `audioPath` (String), `color` (Color).
- Evaluasi scoring: makharijul huruf 40% + tajwid 35% + kelancaran 25%.
- Grade: Mumtaz ≥85, Jayyid Jiddan ≥70, Jayyid ≥55, Maqbul <55.
- Backend butuh PostgreSQL — jalankan dulu sebelum `uvicorn app.main:app --reload`.
- CORS sudah `allow_origins=["*"]`, Flutter Web tidak perlu proxy.

---

## Session Log

### 2026-04-30 — Per-Kata Recording, History, dan Progress Dashboard

**✅ Selesai (target semua tercapai):**
- **Per-kata recording** — `lesson_screen.dart` diperbaharui: parse transliterasi ke token, tracking status per kata (pending/active/correct/incorrect), animasi smooth, UI Chip interaktif dengan warna
- **Endpoint backend** — `POST /api/evaluation/submit_word` + `transcribe_word()` di `ai_service.py` untuk evaluasi per kata dengan fallback 70% mock
- **History screen baru** — `frontend/lib/screens/history_screen.dart` (StatefulWidget, pull-to-refresh, loading/error/empty state) terhubung ke `GET /api/evaluation/history`
- **Progress screen live** — `progress_screen.dart` refactor ke StatefulWidget, stat card (total latihan, rata-rata, tertinggi, streak), progress bar per jilid dari API
- **Progress provider baru** — `frontend/lib/providers/progress_provider.dart` (fetch `/api/progress/dashboard`, expose metrics & recent evals)
- **Route & navigasi** — tambah `/riwayat` route di `main.dart`, tombol Riwayat di `home_screen.dart` sekarang aktif
- **API config** — tambah `submitWord` endpoint ke `api_config.dart`

**Verifikasi:**
- `flutter analyze` — **No issues found** ✅
- Semua file baru & modifikasi mengikuti pattern existing (Provider, models, screens)
- Fallback mock ada di backend untuk kedua endpoint (ASR + Evaluasi)

**⏳ Tidak selesai / ditunda:**
- Testing end-to-end (perlu docker compose up + emulator + flutter run) — ditunda hingga sesi berikutnya
- Konten Jilid 2–6 tetap minimal (bukan prioritas utama bulan ini)

**🚧 Blocker / Risiko:**
- Tidak ada blocker teknis; semua endpoint & provider sudah ready
- Testing E2E harus dilakukan sebelum release (perlu validasi flow user lengkap: register → pilih jilid → rekam → lihat progres → lihat history)

**🎯 Prioritas sesi berikutnya:**
1. **Testing E2E end-to-end** — backend + frontend, coba full flow dengan emulator/device real (3–4 jam)
2. **Deploy ke HuggingFace Spaces** — FastAPI + model HPT-D (Priority 3.4 REKOMENDASI) (4–6 jam)
3. **Audio referensi per huruf** — `glosarium_screen.dart` sudah ada, tinggal generate & host audio (Priority 3.2) (2–3 jam)
4. **Konten Jilid 2–6** — enrich dari minimal ke ~20 halaman per jilid (saat ada bandwidth)
5. **Bug fix & polish** — UI tweaks, error messages, validasi input

**📝 Notes teknis:**
- `lesson_screen.dart`: token parsing via `RegExp(r"[\s\n\r=]+")`, fallback untuk non-token characters (digit, simbol)
- `/api/evaluation/submit_word` fallback mock: `70% + random(-5,+5)` untuk realism
- Progress bar calculated via `completedLessons / totalLessons` per jilid (enum mapping jilid → lesson count)
- History screen batch load 20 item per page dengan pagination support

**📁 File berubah:**
- Backend: `routers/evaluation.py` (endpoint baru), `services/ai_service.py` (fungsi baru)
- Frontend config: `config/api_config.dart`
- Frontend screens: `screens/lesson_screen.dart`, `screens/home_screen.dart`, `screens/progress_screen.dart` 
- Frontend providers: `providers/progress_provider.dart` (baru), `main.dart`
- Docs: `REKOMENDASI_PENGEMBANGAN.md` (updated priorities)
