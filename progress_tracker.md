# Progress Tracker — TilawatiApp (Tilawati Hijaiyah ASR)

**Update Terakhir:** 2026-05-06  
**Status Proyek:** Fase Development selesai, siap Deploy (🔄 In Progress)

---

## Status Ringkas Proyek

| Komponen | Status | Catatan |
|----------|--------|---------|
| **Fase 1: Klasifikasi Huruf** | ✅ Selesai | Model anas: 84.28% accuracy (production ready) |
| **Fase 2: ASR (ASR-EXP-03-E3)** | ✅ Selesai | CER 0.0382, WER 0.0712, Acc 92.8% (production ready) |
| **Fase 3: Development (Flutter + FastAPI)** | ✅ ~95% selesai | Fitur inti berfungsi, belum deploy ke prod |
| **Fase 4: Production Deploy** | 🔄 Belum dimulai | **PRIORITY 1: Wajib untuk demo sidang** |

---

## Fitur yang Sudah Selesai (Sesi 2026-05-06)

### 1. Fix Overflow Halaman Latihan ✅
**Status:** SELESAI & TESTED

**File:** `Tilawati/frontend/lib/screens/lesson_screen.dart`

**Masalah:** Halaman latihan menampilkan teks Arab dengan ukuran font 36pt, menyebabkan overflow pada layar mobile ketika ada banyak kata per baris.

**Solusi:**
- Wrap `Row` yang menampilkan teks Arab dengan `FittedBox(fit: BoxFit.scaleDown)` → scale down otomatis jika terlalu lebar
- Tambah `softWrap: true` + `textAlign: TextAlign.center` pada teks transcript ASR untuk word wrapping yang lebih baik
- Tested: Teks sekarang fit dengan baik pada layar 6-7 inci (Android standard)

**Verifikasi:** Buka halaman latihan → teks Arab dan transcript tidak overflow ✅

---

### 2. Fix Halaman Progres Tidak Terupdate ✅
**Status:** SELESAI & TESTED

**Root Cause:** Setelah user selesai lesson, data evaluasi tidak disimpan ke database. Halaman progres tetap blank karena tidak ada data `Evaluation` record.

**Perubahan Backend:**
- **File:** `backend/app/routers/evaluation.py`
  - Endpoint baru: `POST /api/evaluation/submit_lesson_result`
  - Form data: `jilid`, `lesson_number`, `correct_count`, `total_count`
  - Logika: Simpan ke tabel `Evaluation` + otomatis update `Progress` record via `_update_progress()`
  - Scoring: Hitung nilai berdasarkan rumus (correct_count / total_count)

**Perubahan Frontend:**
- **File:** `frontend/lib/config/api_config.dart`
  - Tambah const: `static const String submitLessonResult = '$baseUrl/api/evaluation/submit_lesson_result';`

- **File:** `frontend/lib/services/api_service.dart`
  - Tambah method `postForm()` untuk mengirim FormData tanpa file

- **File:** `frontend/lib/screens/lesson_screen.dart`
  - Tambah method `_saveLessonResult()` yang dipanggil saat semua kata selesai direkam (`_allDone = true`)
  - Fire-and-forget call: tidak block UI, SnackBar muncul jika gagal

**Verifikasi:**
1. Buka lesson → rekam semua kata → tekan "Selesai"
2. Buka halaman "Progres" → progress bar per jilid terupdate ✅
3. Buka halaman "Riwayat" → evaluasi lesson terbaru muncul ✅

---

### 3. Halaman Profil & Semua Menu Settings Fungsional ✅
**Status:** SELESAI & TESTED

**Masalah:** Semua menu di tab profil hanya menampilkan dialog kosong dengan `onTap: () {}` (dummy implementation).

**Backend - File: `backend/app/schemas/user.py`**
- Tambah schema `UserUpdate` dengan field `name` (required)

**Backend - File: `backend/app/routers/auth.py`**
- Endpoint baru: `PATCH /api/auth/me` (update profil user)
- Validasi: nama tidak boleh kosong, max 100 karakter
- Response: User object dengan data terupdate

**Frontend - File: `frontend/lib/config/api_config.dart`**
- Tambah const: `static const String updateProfile = '$baseUrl/api/auth/me';`

**Frontend - File: `frontend/lib/services/api_service.dart`**
- Tambah method `patch()` untuk HTTP PATCH requests

**Frontend - File: `frontend/lib/providers/auth_provider.dart`**
- Tambah method `updateProfile(String newName)` yang:
  - Call `PATCH /api/auth/me` dengan form data
  - Update local state setelah sukses
  - Throw exception jika gagal (di-catch di UI)

**Frontend - File: `frontend/lib/screens/home_screen.dart`**
- Ubah `_ProfileTab` dari `StatelessWidget` → `StatefulWidget` untuk manage state preference
- Implementasi semua menu items:

  | Menu | Tindakan | Verifikasi |
  |------|----------|-----------|
  | **Edit Profil** | Bottom sheet form edit nama + validasi + `PATCH /api/auth/me` + SnackBar feedback | Nama user terupdate di UI |
  | **Notifikasi** | Toggle switch, state di SharedPreferences | Switch ON/OFF, subtitle show "Aktif"/"Nonaktif" |
  | **Bantuan** | Dialog FAQ dengan 4 Q&A (cara rekam, arti akurasi, arti nilai skor, riwayat) | Dialog muncul saat diklik |
  | **Tentang Tilawati** | Dialog info app (nama, versi 1.0.0, deskripsi singkat) | Dialog muncul dengan info lengkap |
  | **Keluar** | Sudah berfungsi sebelumnya | Token dihapus, redirect login ✅ |

**Verifikasi:**
1. Buka halaman Profil → semua menu bisa diklik
2. Edit Profil → ubah nama → SnackBar "Profil berhasil diupdate" ✅
3. Notifikasi → toggle ON/OFF → subtitle terupdate ✅
4. Bantuan → buka FAQ dialog ✅
5. Tentang → buka info app dialog ✅

---

## Fitur Development Lengkap (Sudah Exist)

### Authentication & User Management ✅
- Registration (email + password + nama)
- Login dengan JWT token
- Token refresh otomatis
- Logout

### Lessons & Progress ✅
- List jilid (1-6, tapi konten jilid 2-6 minimal)
- List lesson per jilid
- List halaman (per kata) per lesson
- Rekam audio per kata → ASR → evaluasi skor

### Evaluation & Scoring ✅
- Scoring formula: makharijul huruf 40% + tajwid 35% + kelancaran 25%
- Grade: Mumtaz (≥90), Jayyid (≥80), dst
- Simpan evaluasi per kata + per lesson

### Progress Tracking ✅
- Progress bar per jilid (% completion)
- Calculated dari jumlah kata yang sudah direkam vs total

### Glossary & Classification ✅
- List huruf hijaiyah dengan gambar
- Klasifikasi huruf via model lokal (fallback jika tidak ada)

### UI/UX ✅
- Dark mode support
- Bottom nav: Latihan, Glosarium, Riwayat, Progres, Profil
- Responsive design (Android 6.0+)
- Offline support (partial)

---

## Known Issues & Blockers

| # | Issue | Severity | Workaround | ETA Fix |
|----|-------|----------|-----------|---------|
| 1 | Jilid 2-6 konten minimal (placeholder) | LOW | Gunakan Jilid 1 untuk demo | Fase 2 (enhancement) |
| 2 | Rekaman per kata, bukan per halaman (suboptimal UX) | MEDIUM | User bisa record multiple times | Fase 2 (UX improvement) |
| 3 | Classification model belum di-deploy Railway (fallback graceful) | LOW | Glossary berfungsi tapi tanpa klasifikasi | Acceptable untuk TA |
| 4 | Testing E2E belum menyeluruh (hanya manual) | MEDIUM | Lakukan testing pada Fase 5 | Sebelum demo sidang |
| 5 | Halaman Riwayat kosong saat pertama kali (baru ada setelah 1 evaluasi) | LOW | Normal, expected behavior | Tidak perlu fix |

---

## Deployment Readiness Checklist

### Pre-Deploy Verifikasi (Fase 1)
- [ ] `Model/Deploy/api/README.md` — YAML header benar (`app_port: 7860`)
- [ ] `Model/Deploy/api/Dockerfile` — Port 7860 benar, startup command OK
- [ ] `Model/Deploy/api/.gitattributes` — LFS tracking `*.safetensors` & `*.bin`
- [ ] `Model/Deploy/api/model/` — Semua file ada (model.safetensors 1.175 GB, config, vocab, dll)

### HuggingFace Spaces Deploy (Fase 2)
- [ ] Buat Space baru (Docker SDK, Public)
- [ ] Clone & setup Git LFS
- [ ] Copy file dari `Model/Deploy/api/`
- [ ] Push ke HF (via Git LFS)
- [ ] Monitor build (~15 menit)
- [ ] Test `/health` endpoint
- [ ] Test `/transcribe` endpoint
- [ ] **Catat URL:** `https://{username}-tilawati-asr-hptd.hf.space`

### Railway Backend Deploy (Fase 3)
- [ ] Buat file `backend/railway.toml`
- [ ] Buat project Railway
- [ ] Add PostgreSQL database
- [ ] Set env vars:
  - `ASR_SERVICE_URL=https://{username}-tilawati-asr-hptd.hf.space`
  - `JWT_SECRET={random 32+ char}`
  - `ASR_MODEL_DIR=` (kosong, tidak pakai lokal)
  - `CLASSIFICATION_MODEL_DIR=` (kosong, tidak pakai lokal)
- [ ] Fix `config.py`: `postgresql://` → `postgresql+asyncpg://`
- [ ] Deploy & run `alembic upgrade head`
- [ ] Test `/api/auth/register` endpoint
- [ ] **Catat URL:** `https://{app-name}.railway.app`

### Flutter Build & Sideload (Fase 4)
- [ ] Update `api_config.dart` baseUrl ke Railway URL
- [ ] Build release APK: `flutter build apk --release`
- [ ] Sideload ke HP via ADB: `adb install app-release.apk`

### E2E Testing di HP Fisik (Fase 5)
- [ ] Register user baru → token diterima
- [ ] Login → redirect home
- [ ] Pilih Jilid 1 → list halaman muncul
- [ ] Rekam audio → transcript ASR muncul
- [ ] Lihat skor evaluasi
- [ ] Cek halaman Progres → terupdate
- [ ] Cek halaman Riwayat → muncul
- [ ] Cek halaman Profil → edit nama berfungsi
- [ ] Offline graceful → error message jelas
- [ ] **Total test:** 8 test cases

---

## Next Steps (Prioritas)

### Priority 1: DEPLOY (Wajib untuk demo sidang) — Estimasi 4-7 jam
1. **Fase 1 (30 menit):** Verifikasi file `Model/Deploy/api/` (README, Dockerfile, .gitattributes, model files)
2. **Fase 2 (1-2 jam):** Deploy ASR ke HuggingFace Spaces (upload 1.2 GB via Git LFS)
3. **Fase 3 (1-2 jam):** Deploy backend ke Railway.app + PostgreSQL + Alembic migrate
4. **Fase 4 (30 menit):** Build release APK + update baseUrl → sideload ke HP
5. **Fase 5 (1-2 jam):** E2E testing di HP fisik (8 test cases dari checklist)

**Blocker:** Akun Railway (butuh CC/nomor telepon untuk free credit $5/bulan). Akun HuggingFace (gratis, hanya butuh email).

**Risiko:**
- Upload 1.2 GB model timeout → gunakan koneksi stabil
- HF Spaces sleep after 48h inactivity → ping sebelum demo
- Railway free credit ($5/month) habis → estimasi $1-2 untuk demo

### Priority 2: Enhancement (Setelah deploy sukses)
- Tambah contoh bacaan di halaman Glosarium + Latihan (audio bacaan ahli)
- Improve UI/UX (layout, spacing, font sizing, dark mode refinement)
- Jilid 2-6: fill konten dengan lessons & audio

### Priority 3: Optimization & Testing
- Unit test + integration test
- Performance optimization (bundle size, boot time)
- Analytics & monitoring (crash reporting, usage tracking)
- Gamifikasi (leaderboard, achievements, streaks)

---

## Estimasi Timeline ke Demo Sidang

| Milestone | Target | Status |
|-----------|--------|--------|
| Develop selesai | 2026-05-06 | ✅ DONE |
| Deploy selesai | 2026-05-08 (2 hari) | 🔄 Next |
| E2E testing done | 2026-05-09 | 🔄 Next |
| Demo sidang siap | 2026-05-10 | 📅 Planned |

**Asumsi:** 4-7 jam deploy dapat diselesaikan dalam 2 hari kerja (Rabu-Kamis).

---

## Technical Specifications (Reference)

### Model ASR (ASR-EXP-03-E3)
- Architecture: Wav2Vec2ForCTC (Jonathan-base + Extended Dataset + Word-Level CTC + HPT Phase-2 LR × Dropout)
- Vocab: Word-level Extended (Jilid 1 + Jilid 2-ish vocab)
- Input: 16 kHz mono WAV
- Output: Transcript + confidence scores
- Performance: CER 0.0382, WER 0.0712, Accuracy 92.8%

### Model Klasifikasi (anas)
- Architecture: CNN (feature extractor frozen, linear head)
- Classes: 28 huruf hijaiyah
- Performance: 84.28% accuracy
- Note: Tidak akan di-deploy Railway untuk TA, hanya lokal

### Backend API
- Framework: FastAPI + SQLAlchemy async
- Database: PostgreSQL (Railway)
- Auth: JWT (RS256)
- Main routers: auth, lessons, evaluation, progress, glossary

### Frontend App
- Framework: Flutter 3.x
- Min SDK: Android 6.0 (API 21)
- Packages: provider, dio, shared_preferences, flutter_sound, image_picker

---

## Session Log (2026-05-06)

**Apa yang dikerjakan:**
- Fix overflow halaman latihan (FittedBox + text wrapping)
- Fix progress tidak terupdate (tambah endpoint submit_lesson_result + fire-and-forget call)
- Implementasi semua menu profil & settings (edit nama, notifikasi toggle, FAQ, info app)
- Verifikasi DEPLOYMENT_PLAN.md sudah lengkap & actionable

**Apa yang TIDAK dikerjakan (dan mengapa):**
- Deploy (belum, tunggu konfirmasi apakah siap mulai Fase 1)
- Jilid 2-6 konten (not required untuk MVP, dapat ditambah setelah deploy)
- Unit test (nice-to-have, E2E manual sudah cukup untuk TA)

**Blocker/Risiko discovered:**
- Railway deploy membutuhkan verifikasi CC/nomor telepon (not critical, just setup overhead)
- Model 1.2 GB upload bisa slow di koneksi internet lemah

**Prioritas sesi berikutnya:**
1. **Fase 1 (hari ini):** Verifikasi deploy files (30 menit)
2. **Fase 2 (hari ini/besok):** Push ASR ke HF Spaces (1-2 jam)
3. **Fase 3 (besok):** Deploy backend ke Railway (1-2 jam)
4. **Fase 4 (besok):** Build APK + sideload (30 menit)
5. **Fase 5 (besok):** E2E testing HP (1-2 jam)

**File yang dimodifikasi sesi ini:**
- `Tilawati/frontend/lib/screens/lesson_screen.dart` (overflow fix + save result)
- `Tilawati/frontend/lib/screens/home_screen.dart` (profil menu implementation)
- `Tilawati/frontend/lib/services/api_service.dart` (postForm, patch methods)
- `Tilawati/frontend/lib/config/api_config.dart` (new endpoints)
- `Tilawati/frontend/lib/providers/auth_provider.dart` (updateProfile method)
- `Tilawati/backend/app/routers/evaluation.py` (submit_lesson_result endpoint)
- `Tilawati/backend/app/schemas/user.py` (UserUpdate schema)

---

## Kontak & Resources

**Email:** x4veront@gmail.com  
**Deployment Plan:** `Tilawati/DEPLOYMENT_PLAN.md` (detail lengkap setiap fase)  
**CLAUDE.md:** `Tilawati/CLAUDE.md` (project guidelines & aturan AI)  
**GitHub repo:** [TilawatiApp](https://github.com/your-github/TilawatiApp)

---

**End of Progress Tracker**
