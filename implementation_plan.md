# Tilawati: Aplikasi Pembelajaran dan Evaluasi Bacaan Al-Qur'an Berbasis AI

Aplikasi mobile untuk membantu pengguna meningkatkan kualitas bacaan Al-Qur'an dengan evaluasi berbasis AI (Contrastive Learning & Forced Alignment).

## User Review Required

> [!IMPORTANT]
> **Platform Target**: Dokumen menyebutkan Android/iOS. Apakah kita fokus Android dulu untuk MVP, atau langsung keduanya?

> [!IMPORTANT]
> **Database Setup**: Rancangan menyebutkan PostgreSQL. Apakah sudah ada server PostgreSQL yang tersedia, atau perlu setup menggunakan Docker?

> [!IMPORTANT]
> **AI Model**: Rancangan menyebutkan Contrastive Learning dan Forced Alignment. Apakah model AI sudah ada/dilatih, atau perlu dibuat placeholder untuk saat ini?

> [!WARNING]
> **UI Mockup**: File `Rancangan UI Aplikasi Tilawati.docx` berisi wireframe/mockup. Bisakah Anda share screenshot dari mockup tersebut agar desain UI sesuai dengan rancangan?

## Proposed Changes

### 1. Project Structure

```
d:\TA\Tilawati\
├── frontend/          # Flutter app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── config/
│   │   │   ├── theme.dart          # App theme & colors
│   │   │   └── routes.dart         # Route definitions
│   │   ├── models/
│   │   │   ├── user.dart           # User model
│   │   │   ├── jilid.dart          # Jilid/lesson model
│   │   │   ├── evaluation.dart     # Evaluation result model
│   │   │   └── progress.dart       # User progress model
│   │   ├── services/
│   │   │   ├── api_service.dart    # HTTP client
│   │   │   ├── auth_service.dart   # Auth logic
│   │   │   ├── audio_service.dart  # Recording & playback
│   │   │   └── evaluation_service.dart  # AI evaluation API
│   │   ├── providers/
│   │   │   ├── auth_provider.dart
│   │   │   ├── lesson_provider.dart
│   │   │   └── progress_provider.dart
│   │   └── screens/
│   │       ├── splash_screen.dart
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       ├── home_screen.dart
│   │       ├── jilid_selection_screen.dart
│   │       ├── lesson_screen.dart
│   │       ├── recording_screen.dart
│   │       ├── evaluation_screen.dart
│   │       └── progress_screen.dart
│   └── pubspec.yaml
│
├── backend/           # FastAPI server
│   ├── app/
│   │   ├── main.py              # FastAPI entry point
│   │   ├── config.py            # Configuration
│   │   ├── database.py          # DB connection
│   │   ├── models/
│   │   │   ├── user.py          # SQLAlchemy User model
│   │   │   ├── evaluation.py    # Evaluation model
│   │   │   └── progress.py      # Progress model
│   │   ├── schemas/
│   │   │   ├── user.py          # Pydantic schemas
│   │   │   ├── evaluation.py
│   │   │   └── progress.py
│   │   ├── routers/
│   │   │   ├── auth.py          # Login/Register endpoints
│   │   │   ├── lessons.py       # Jilid & lesson endpoints
│   │   │   ├── evaluation.py    # Audio evaluation endpoint
│   │   │   └── progress.py      # Progress tracking
│   │   ├── services/
│   │   │   ├── auth_service.py  # JWT & password hashing
│   │   │   └── ai_service.py   # AI evaluation logic (placeholder)
│   │   └── utils/
│   │       └── audio.py         # Audio processing utilities
│   ├── requirements.txt
│   └── .env.example
│
└── docker-compose.yml  # PostgreSQL + backend
```

---

### 2. Backend (FastAPI + PostgreSQL)

#### [NEW] backend/app/main.py
- FastAPI app initialization with CORS middleware
- Router registration for auth, lessons, evaluation, progress
- Startup event for database initialization

#### [NEW] backend/app/config.py
- Environment variable loading (DATABASE_URL, SECRET_KEY, etc.)
- App configuration dataclass

#### [NEW] backend/app/database.py
- SQLAlchemy async engine setup
- Session factory
- Base model class

#### [NEW] backend/app/models/user.py
- User SQLAlchemy model (id, email, name, hashed_password, created_at)

#### [NEW] backend/app/models/evaluation.py
- Evaluation model (id, user_id, jilid, lesson, score, feedback_json, created_at)

#### [NEW] backend/app/models/progress.py
- Progress model (id, user_id, jilid, total_lessons, completed, average_score)

#### [NEW] backend/app/schemas/
- Pydantic request/response schemas for all endpoints

#### [NEW] backend/app/routers/auth.py
- `POST /api/auth/register` — User registration
- `POST /api/auth/login` — JWT token generation
- `GET /api/auth/me` — Get current user

#### [NEW] backend/app/routers/lessons.py
- `GET /api/lessons/jilids` — List available jilid
- `GET /api/lessons/{jilid_id}` — Get lessons in jilid

#### [NEW] backend/app/routers/evaluation.py
- `POST /api/evaluation/submit` — Submit audio recording for evaluation
- Returns score, phoneme-level feedback, comparison result

#### [NEW] backend/app/routers/progress.py
- `GET /api/progress` — Get user progress dashboard data
- `GET /api/progress/history` — Get evaluation history

#### [NEW] backend/app/services/ai_service.py
- Placeholder for Contrastive Learning evaluation
- Placeholder for Forced Alignment phoneme analysis
- Mock scoring untuk development

#### [NEW] backend/requirements.txt
- fastapi, uvicorn, sqlalchemy, asyncpg, python-jose, passlib, python-multipart

#### [NEW] docker-compose.yml
- PostgreSQL service
- Backend service (optional)

---

### 3. Frontend (Flutter)

#### [NEW] frontend/lib/main.dart
- MaterialApp with custom theme
- Provider setup
- Route configuration

#### [NEW] frontend/lib/config/theme.dart
- Custom Islamic-inspired color palette (emerald green, gold, cream)
- Typography with Arabic-friendly fonts
- Component themes (cards, buttons, inputs)

#### [NEW] frontend/lib/screens/splash_screen.dart
- App logo & branding animation
- Auth check & auto-navigation

#### [NEW] frontend/lib/screens/login_screen.dart
- Email & password fields
- Login button with loading state
- Link to register

#### [NEW] frontend/lib/screens/register_screen.dart
- Name, email, password fields
- Registration with validation

#### [NEW] frontend/lib/screens/home_screen.dart
- Welcome greeting
- Quick stats (total latihan, rata-rata skor)
- Menu: Mulai Latihan, Progres, Profil
- Recent evaluation results

#### [NEW] frontend/lib/screens/jilid_selection_screen.dart
- Grid/list of Tilawati jilid (1-6)
- Progress indicator per jilid
- Lock/unlock based on progress

#### [NEW] frontend/lib/screens/lesson_screen.dart
- Arabic text display with tajwid highlighting
- Audio playback (reference)
- Record button
- Navigation between lessons

#### [NEW] frontend/lib/screens/recording_screen.dart
- Waveform visualization during recording
- Timer display
- Stop/retry/submit controls

#### [NEW] frontend/lib/screens/evaluation_screen.dart
- Overall score display (circular progress)
- Phoneme-level feedback with color coding
- Comparison visualization
- Tips & suggestions

#### [NEW] frontend/lib/screens/progress_screen.dart
- Charts (line chart for score history)
- Jilid completion bars
- Streak & achievement badges

---

## Open Questions

> [!IMPORTANT]
> 1. **Konten Tilawati**: Apakah sudah ada data konten jilid Tilawati (teks Arab, transliterasi, audio referensi)? Atau kita buat data dummy dulu?

> [!IMPORTANT]
> 2. **Flutter Version**: Apakah sudah terinstall Flutter SDK di komputer? Versi berapa?

> [!IMPORTANT]
> 3. **Model AI**: Apakah model Contrastive Learning dan Forced Alignment sudah ada? Jika belum, saya akan buat placeholder/mock service yang mengembalikan skor acak untuk testing.

> [!NOTE]
> 4. **Scope MVP**: Untuk tahap pertama, saya sarankan fokus pada:
>    - ✅ Auth (login/register)
>    - ✅ Pemilihan jilid & halaman latihan
>    - ✅ Rekaman suara
>    - ✅ Evaluasi (mock/placeholder)
>    - ✅ Dashboard progres sederhana
>    
>    Fitur lanjutan (offline mode, achievement, dll) bisa ditambahkan setelahnya.

## Verification Plan

### Automated Tests
- Backend: `pytest` untuk unit test setiap endpoint
- Frontend: `flutter test` untuk widget tests
- Integration: Test E2E flow register → login → pilih jilid → rekam → evaluasi

### Manual Verification
- Run backend dengan `uvicorn app.main:app --reload`
- Run Flutter app di emulator/device
- Test full flow dari registrasi hingga melihat progres
- Verify responsive design di berbagai ukuran layar
