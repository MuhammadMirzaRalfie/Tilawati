# Rancangan Implementasi Deploy — TilawatiApp

**Versi:** 1.0
**Tanggal Disusun:** 2026-05-17
**Status:** Draft — Siap Eksekusi
**Disusun untuk:** Demo Sidang Tugas Akhir Tilawati Hijaiyah ASR
**Lokasi referensi plan eksekusi:** `C:\Users\mirza\.claude\plans\apa-yang-harus-dilakukan-radiant-locket.md`

---

## 1. Tujuan & Konteks

### 1.1 Tujuan
Membawa aplikasi TilawatiApp dari status development (lokal) ke status production sehingga dapat dijalankan dari HP fisik tanpa ketergantungan koneksi LAN laptop pengembang. Hasil akhir: APK release yang siap di-sideload dan terhubung ke layanan ASR + backend cloud.

### 1.2 Konteks Sesi
- Fase 1 (Klasifikasi Huruf) — selesai.
- Fase 2 (ASR Word-Level) — selesai dengan model terbaik **ASR-EXP-03-E3** (bukan lagi HPT-D).
- Fase 3 (Development Flutter + FastAPI) — ~95% selesai per `progress_tracker.md` (2026-05-06).
- Fase 4 (Production Deploy) — **fokus dokumen ini.**

### 1.3 Update Model (Penting)
Model ASR yang dideploy adalah **ASR-EXP-03-E3**, hasil HPT (Hyper-Parameter Tuning) Phase-2 LR × Dropout terbaik dari 6 kombinasi (E1–E6). Detail dari `Model/Blueprint dan Rancangan/rancangan_alur_ASR_extended.docx`:

| Aspek | HPT-D (lama) | **ASR-EXP-03-E3 (baru)** |
|-------|--------------|--------------------------|
| Pendekatan | Char-level CTC awal | Word-Level CTC + Extended Dataset + Jonathan-base |
| CER | 0.1013 | **0.0382** |
| WER | 0.2025 | **0.0712** |
| Accuracy | ~65% (TSA) | **92.8%** |
| Trainable params Phase 2 | n/a | 98.7% (311M / 315M) |
| SpecAugment Phase 2 | n/a | mask_time=0.05, mask_feat=0.004 |

Artefak model E3 berada di:
`D:\TA\TilawatiApp\Model\Model Final ASR\ASR-EXP-03-E3\final model exp03e3\asr_hpt_e3\best_model\`

### 1.4 Status Evaluasi (di luar scope deploy)
Audit pipeline rekam-audio → ASR → score → simpan → progress menunjukkan **tidak ada bug runtime**. Laporan "field mismatch" dari eksplorasi awal merupakan false positive — data lesson di-hardcode di `frontend/lib/screens/jilid_selection_screen.dart`, bukan dari backend `ai_service.py`. Scoring per-komponen disamakan dengan `overall_score` di `/submit_lesson_result` dan **diterima sebagai keputusan desain MVP**. Tidak ada perubahan kode evaluasi pada sesi ini.

---

## 2. Arsitektur Production

```
┌──────────────────────────┐
│   Flutter APK (release)  │
│   sideloaded ke HP user  │
└────────────┬─────────────┘
             │ HTTPS
             ▼
┌──────────────────────────┐
│   Railway.app            │
│   ├─ FastAPI (uvicorn)   │
│   │   • auth             │
│   │   • lessons          │
│   │   • evaluation       │
│   │   • progress         │
│   │   • glossary         │
│   └─ PostgreSQL plugin   │
└────────────┬─────────────┘
             │ HTTPS (env: ASR_SERVICE_URL)
             ▼
┌──────────────────────────┐
│   HuggingFace Spaces     │
│   (Docker SDK)           │
│   └─ ASR-EXP-03-E3       │
│      Wav2Vec2ForCTC      │
│      • GET  /health      │
│      • POST /transcribe  │
└──────────────────────────┘
```

### 2.1 Justifikasi Platform
- **HuggingFace Spaces (ASR):** gratis untuk model public, mendukung Docker SDK dengan Git LFS untuk file 1.2 GB. Cocok untuk inference stateless.
- **Railway (Backend + DB):** gratis $5/bulan credit (cukup untuk demo), PostgreSQL plugin built-in, deploy via Dockerfile mudah, public HTTPS otomatis.
- **APK sideload:** menghindari kompleksitas Play Store review untuk demo TA. Distribusi via ADB ke HP penguji.

---

## 3. Komponen yang Di-deploy

### 3.1 Model ASR-EXP-03-E3
- **Source artefak:** `D:\TA\TilawatiApp\Model\Model Final ASR\ASR-EXP-03-E3\final model exp03e3\asr_hpt_e3\best_model\`
- **Total ukuran:** ≈1.2 GB
- **Files (10):**
  - `model.safetensors` (≈1.17 GB) — bobot model, di-LFS
  - `config.json` — arsitektur Wav2Vec2ForCTC
  - `vocab.json` — vocab word-level Extended Dataset
  - `id2word.json`, `word2id.json` — mapping bidirectional
  - `preprocessor_config.json` — feature extractor (16 kHz)
  - `tokenizer_config.json`, `special_tokens_map.json`, `added_tokens.json` — tokenizer
  - `training_args.bin` — referensi konfigurasi training (di-LFS)
- **Wrapper API:** `Model/Deploy/api/`
  - `Dockerfile` — base PyTorch CPU, `EXPOSE 7860`, `CMD uvicorn main:app --host 0.0.0.0 --port 7860`
  - `main.py` — FastAPI dengan endpoint:
    - `GET /health` → `{"status":"ok","model":"ASR-EXP-03-E3","device":"cpu"}`
    - `POST /transcribe` (multipart `audio`, max 10 MB) → `{"transcript": "...", "confidence": ...}`
  - `inference.py` — load model & `transcribe_bytes()`
  - `requirements.txt` — torch, transformers, librosa, fastapi, uvicorn
  - `.gitattributes` — Git LFS untuk `*.safetensors` & `*.bin`
  - `README.md` — YAML header HF Spaces (title, sdk, app_port: 7860)

### 3.2 Backend FastAPI
- **Source:** `D:\TA\TilawatiApp\Tilawati\backend\`
- **Routers terdaftar di `app/main.py`:** auth, lessons, evaluation, progress, glossary
- **Persistence:**
  - PostgreSQL via SQLAlchemy async (asyncpg driver)
  - Schema auto-create: `Base.metadata.create_all` di lifespan hook (`app/database.py:23`)
  - Tidak perlu Alembic untuk MVP — startup hook cukup
- **ASR call:**
  - HTTP client → `ASR_SERVICE_URL` (env var)
  - Fallback ke mock jika `ASR_SERVICE_URL` kosong/error
- **Auth:** JWT dengan `SECRET_KEY` env var
- **Dockerfile:** existing di `backend/Dockerfile`

### 3.3 Frontend Flutter
- **Source:** `D:\TA\TilawatiApp\Tilawati\frontend\`
- **Build target:** Android (release APK)
- **Strategi baseUrl:** `String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8000')`
  - Dev: pakai default (atau `--dart-define=API_BASE_URL=http://10.0.2.2:8000` untuk emulator)
  - Prod: `flutter build apk --release --dart-define=API_BASE_URL=https://<app>.railway.app`
- **Packages utama:** provider, dio, shared_preferences, flutter_sound, image_picker

---

## 4. Konfigurasi & Env Vars

### 4.1 HuggingFace Spaces (ASR)
**README YAML header:**
```yaml
---
title: ASR Hijaiyah EXP-03-E3
emoji: 🕌
colorFrom: green
colorTo: blue
sdk: docker
app_port: 7860
pinned: false
---
```

**Git LFS tracking (.gitattributes):**
```
*.safetensors filter=lfs diff=lfs merge=lfs -text
*.bin filter=lfs diff=lfs merge=lfs -text
```

**Tidak ada secret yang perlu di-set.** Semua public.

### 4.2 Railway Backend
**railway.toml:**
```toml
[build]
builder = "DOCKERFILE"
dockerfilePath = "Dockerfile"

[deploy]
startCommand = "uvicorn app.main:app --host 0.0.0.0 --port $PORT"
healthcheckPath = "/health"
healthcheckTimeout = 100
restartPolicyType = "ON_FAILURE"
restartPolicyMaxRetries = 3
```

**Env vars yang harus di-set di Railway dashboard:**

| Variable | Nilai | Catatan |
|----------|-------|---------|
| `DATABASE_URL` | `postgresql+asyncpg://...` | Auto-set oleh PG plugin, **override scheme** dari `postgresql://` ke `postgresql+asyncpg://` |
| `SECRET_KEY` | Random 32+ char hex | Generate: `openssl rand -hex 32` |
| `ASR_SERVICE_URL` | `https://<user>-tilawati-asr-exp03e3.hf.space` | URL Space dari Fase 2 |
| `ASR_MODEL_DIR` | (kosong) | Force remote ASR, jangan load lokal di Railway |
| `CLASSIFICATION_MODEL_DIR` | (kosong) | Klasifikasi tidak dideploy, fallback graceful |

### 4.3 Frontend Build
**Build command production:**
```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://<app>.railway.app
```

**Output APK:** `build/app/outputs/flutter-apk/app-release.apk`

---

## 5. Urutan Implementasi

### Fase 0 — Dokumen Rancangan (~30 menit)
File ini sendiri. Menjadi single source of truth eksekusi.

### Fase 1 — Sync & Fix Artefak Deploy (~30 menit)
1. Verifikasi & sync model E3 ke `Model/Deploy/api/model/` (compare timestamp/size vs `best_model/`)
2. Update label `HPT-D` → `ASR-EXP-03-E3` di `Model/Deploy/api/main.py` (title + health response)
3. Update `Model/Deploy/api/README.md`: tambah `app_port: 7860`, title, metrics
4. Create `Tilawati/backend/railway.toml`
5. Refactor `Tilawati/frontend/lib/config/api_config.dart` ke `String.fromEnvironment`
6. Update referensi `HPT-D` di dokumentasi: `Tilawati/CLAUDE.md`, `Tilawati/DEPLOYMENT_PLAN.md`, `Tilawati/progress_tracker.md`, `Model/CLAUDE.md`, dan string literal di backend (jika ada)

### Fase 2 — Deploy ASR ke HF Spaces (~1–2 jam)
1. Buat akun HF (`x4veront@gmail.com`)
2. Create Space `tilawati-asr-exp03e3` (Docker SDK, Public)
3. Clone repo Space lokal, setup Git LFS
4. Copy isi `Model/Deploy/api/` → repo Space, commit, push (1.2 GB)
5. Monitor build (~15 menit)
6. Test `/health` & `/transcribe`
7. Catat URL `https://<user>-tilawati-asr-exp03e3.hf.space`

### Fase 3 — Deploy Backend ke Railway (~1–2 jam)
1. Akun Railway (verifikasi telepon)
2. New Project → Deploy `Tilawati/backend/` via GitHub atau CLI
3. Add PostgreSQL plugin
4. Override `DATABASE_URL` scheme ke `postgresql+asyncpg://`
5. Set env vars `SECRET_KEY`, `ASR_SERVICE_URL`, `ASR_MODEL_DIR=""`, `CLASSIFICATION_MODEL_DIR=""`
6. Deploy, monitor build log
7. Test `/health` & `POST /api/auth/register`
8. Catat URL `https://<app>.railway.app`

### Fase 4 — Build APK Release + Sideload (~30 menit)
```powershell
cd D:\TA\TilawatiApp\Tilawati\frontend
flutter clean
flutter pub get
flutter build apk --release --dart-define=API_BASE_URL=https://<app>.railway.app
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Fase 5 — E2E Testing di HP Fisik (~1–2 jam)
8 test cases, lihat Bagian 7.

---

## 6. Risiko & Mitigasi

| # | Risiko | Severity | Mitigasi |
|---|--------|----------|----------|
| 1 | Vocab/tokenizer E3 incompatible dengan wrapper `inference.py` (jika wrapper masih asumsikan vocab HPT-D) | HIGH | Test lokal: `python Model/Deploy/api/main.py` + curl `/transcribe` dengan sample WAV sebelum push HF |
| 2 | Upload 1.2 GB ke HF timeout | MEDIUM | Koneksi kabel/stabil, Git LFS chunked resume |
| 3 | HF Spaces sleep setelah 48 jam idle | MEDIUM | Ping `/health` 15 menit sebelum demo; warmup ≈30 detik |
| 4 | Railway free credit ($5/bulan) habis | LOW | Monitor dashboard, estimasi <$2 untuk demo + testing |
| 5 | `DATABASE_URL` Railway pakai scheme sync `postgresql://` | MEDIUM | Override manual env var |
| 6 | Audio Flutter (AAC/AMR) tidak compatible dengan backend ASR | LOW | Backend `librosa.load(sr=16000, mono=True)` auto-resample; sudah teruji di dev |
| 7 | ASR cold start lambat (>30 detik) saat pertama call | LOW | Acceptable; jelaskan "model loading" ke audience saat demo |
| 8 | HP test offline saat demo | MEDIUM | Test seluler dulu sebelum demo; siapkan offline error message |

---

## 7. Kriteria Verifikasi

### 7.1 Smoke Test Pra-Demo (dari HP fisik, koneksi seluler bukan WiFi laptop)

| # | Skenario | Expected Result |
|---|----------|-----------------|
| 1 | Register user baru | Token diterima, user object kembali |
| 2 | Login dengan kredensial yang valid | Redirect ke home, token persistent |
| 3 | Pilih Jilid 1 dari home | List halaman muncul (hardcoded data, tidak butuh API) |
| 4 | Tap kata "اَ" di Hal 1 → rekam suara "A" → tunggu | Transcript ASR muncul dari HF Spaces, status match/mismatch tampil <10 detik (kecuali cold start 30 detik pertama) |
| 5 | Selesaikan semua kata di lesson, tekan "Selesai" | Lesson result tersimpan, skor tampil |
| 6 | Tab Progres | Progress bar Jilid 1 terupdate sesuai % completion |
| 7 | Tab Riwayat | Entri evaluasi terbaru muncul dengan timestamp & skor |
| 8 | Tab Profil → Edit nama → save | SnackBar success, nama terupdate di UI dan persist setelah re-login |

### 7.2 Endpoint Health Check

| Endpoint | Expected Response |
|----------|-------------------|
| `GET https://<user>-tilawati-asr-exp03e3.hf.space/health` | `{"status":"ok","model":"ASR-EXP-03-E3","device":"cpu"}` |
| `GET https://<app>.railway.app/health` | 200 OK |
| `POST https://<app>.railway.app/api/auth/register` | 201 + token |

---

## 8. Estimasi Waktu & Milestone

| Fase | Estimasi | Target Tanggal |
|------|----------|----------------|
| Fase 0 — Dokumen rancangan | 30 menit | 2026-05-17 (hari ini) |
| Fase 1 — Sync & fix artefak | 30 menit | 2026-05-17 |
| Fase 2 — Deploy HF | 1–2 jam | 2026-05-17 atau 2026-05-18 |
| Fase 3 — Deploy Railway | 1–2 jam | 2026-05-18 |
| Fase 4 — Build APK + sideload | 30 menit | 2026-05-18 |
| Fase 5 — E2E testing | 1–2 jam | 2026-05-18 atau 2026-05-19 |
| **Total** | **4–7 jam** | **Demo siap: 2026-05-19 / 2026-05-20** |

---

## 9. Out of Scope (Sesi Ini)

Daftar item yang **TIDAK dikerjakan** pada sesi deploy ini (catat untuk sesi berikutnya jika diperlukan):

1. Refactor scoring `/submit_lesson_result` per-komponen (user setuju biarkan overall_score sama untuk semua)
2. Refactor lesson data dual-source (frontend hardcoded vs backend `ai_service.py`)
3. Konten Jilid 2–6 (Jilid 1 cukup untuk demo)
4. Deploy classification model ke remote (fallback graceful sudah ada)
5. EXP-04 Focal CTC (model lanjutan, belum siap deploy)
6. Unit/integration test
7. Migrasi ke Alembic (startup hook `create_all` cukup untuk MVP)

---

## 10. Lampiran

### 10.1 Referensi Dokumen Terkait
- `Tilawati/DEPLOYMENT_PLAN.md` — plan deploy versi lama (referensi HPT-D, perlu update label)
- `Tilawati/progress_tracker.md` — log progres development
- `Tilawati/CLAUDE.md` — aturan AI & konteks proyek
- `Model/Blueprint dan Rancangan/rancangan_alur_ASR_extended.docx` — rancangan eksperimen ASR (sumber metrics E3)
- `C:\Users\mirza\.claude\plans\apa-yang-harus-dilakukan-radiant-locket.md` — plan eksekusi sesi (detail teknis langkah)

### 10.2 Kontak
- **Pengembang:** x4veront@gmail.com
- **Target demo:** Sidang Tugas Akhir Tilawati Hijaiyah ASR

---

**Akhir dokumen.**
