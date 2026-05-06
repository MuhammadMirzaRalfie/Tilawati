# Rencana Implementasi Deploy — TilawatiApp

## Context

Deploy diperlukan agar demo sidang bisa dilakukan dari HP fisik tanpa ketergantungan pada koneksi LAN laptop. Target arsitektur:

```
Flutter APK (sideload)
    ↓ HTTPS
Railway.app
  ├─ FastAPI (full backend: auth, lessons, evaluation, progress)
  └─ PostgreSQL (user data, evaluations, progress)
    ↓ HTTPS (ASR_SERVICE_URL env var)
HuggingFace Spaces
  └─ ASR inference (HPT-D, Wav2Vec2ForCTC, 1.2 GB)
```

ASR tetap di HF Spaces (stateless, sudah ada scaffold di `Model/Deploy/api/`). Backend full di Railway (butuh PostgreSQL). Flutter APK di-build release dan di-sideload ke HP.

---

## Fase 1 — Verifikasi & Perbaikan File Deploy/api/ (HF Spaces) (~30 menit)

**Tujuan:** Pastikan `Model/Deploy/api/` siap push ke HuggingFace Spaces.

### 1.1 Verifikasi README.md (YAML header HF Spaces)
File: `Model/Deploy/api/README.md`

Pastikan header YAML tepat:
```yaml
---
title: Tilawati ASR Hijaiyah HPT-D
emoji: 🕌
colorFrom: green
colorTo: blue
sdk: docker
app_port: 7860
pinned: false
---
```
`app_port: 7860` harus cocok dengan `EXPOSE 7860` di Dockerfile.

### 1.2 Verifikasi Dockerfile
File: `Model/Deploy/api/Dockerfile`

Port 7860 sudah **benar** untuk HF Spaces Docker SDK — jangan diubah. Pastikan:
```dockerfile
EXPOSE 7860
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]
```

### 1.3 Buat/Verifikasi .gitattributes (Git LFS)
File: `Model/Deploy/api/.gitattributes`

Harus ada agar `model.safetensors` (1.2 GB) bisa di-push via Git LFS:
```
*.safetensors filter=lfs diff=lfs merge=lfs -text
*.bin filter=lfs diff=lfs merge=lfs -text
```

### 1.4 Verifikasi model/ directory
Path: `Model/Deploy/api/model/`

File yang harus ada:
- `model.safetensors` (1.175 GB) ← **wajib ada, via Git LFS**
- `config.json`
- `id2word.json`
- `vocab.json`
- `word2id.json`
- `preprocessor_config.json`
- `tokenizer_config.json`
- `special_tokens_map.json`
- `added_tokens.json`

**Verifikasi:** Semua file ada → lanjut ke Fase 2.

---

## Fase 2 — Deploy ASR ke HuggingFace Spaces (~1–2 jam)

**Prasyarat:** Punya akun HuggingFace, Git LFS terinstall (`git lfs install`).

### 2.1 Buat HF Space baru
1. Buka `https://huggingface.co/new-space`
2. Name: `tilawati-asr-hptd` (atau sesuai keinginan)
3. SDK: **Docker**
4. Visibility: Public (free tier hanya bisa Public)
5. Klik "Create Space" → akan ada repo kosong

### 2.2 Clone repo HF Space & setup Git LFS
```bash
git clone https://huggingface.co/spaces/{username}/tilawati-asr-hptd
cd tilawati-asr-hptd

git lfs install
git lfs track "*.safetensors"
git lfs track "*.bin"
git add .gitattributes
```

### 2.3 Copy file dari Deploy/api/ ke repo HF
```bash
# Copy semua file dari Model/Deploy/api/ ke repo HF
# (main.py, inference.py, requirements.txt, Dockerfile, README.md, model/)
```

### 2.4 Push ke HF Spaces
```bash
git add .
git commit -m "Initial deploy HPT-D ASR API"
git push
```
Upload 1.2 GB via Git LFS — bisa memakan **15–30 menit** tergantung koneksi.

### 2.5 Monitor build HF Spaces
- Buka tab "Logs" di HF Space
- Build Docker image: ~5–10 menit
- Load model + warm-up: ~2 menit
- Status berubah ke "Running" ✅

### 2.6 Test endpoint
```bash
# Health check
curl https://{username}-tilawati-asr-hptd.hf.space/health

# Transcribe test (pakai file WAV 16kHz)
curl -X POST https://{username}-tilawati-asr-hptd.hf.space/transcribe \
  -F "audio=@test_audio.wav"
```

**Verifikasi sukses:** `/health` → `{"status":"ok","model":"HPT-D"}` dan `/transcribe` → `{"transcript":"ba ta","words":["ba","ta"],...}`

**Catat URL:** `https://{username}-tilawati-asr-hptd.hf.space` → dipakai di Fase 3.

---

## Fase 3 — Deploy Backend ke Railway (~1–2 jam)

**Prasyarat:** Akun Railway (railway.app) — butuh verifikasi nomor telepon atau kartu kredit untuk dapat $5/bulan free credit.

### 3.1 Buat file railway.toml
File baru: `Tilawati/backend/railway.toml`
```toml
[build]
builder = "DOCKERFILE"
dockerfilePath = "Dockerfile"

[deploy]
startCommand = "uvicorn app.main:app --host 0.0.0.0 --port $PORT"
healthcheckPath = "/api/auth/me"
healthcheckTimeout = 30
```

### 3.2 Buat project Railway
1. Buka `https://railway.app/new`
2. Pilih "Deploy from GitHub repo" → connect repo GitHub
   - Atau gunakan Railway CLI: `railway login && railway init`
3. Set root directory ke `Tilawati/backend/`

### 3.3 Tambah PostgreSQL
Di dashboard Railway project:
1. Klik "+ New" → "Database" → "Add PostgreSQL"
2. Railway otomatis meng-inject `DATABASE_URL` ke environment

### 3.4 Set environment variables di Railway
Tambah vars berikut di Railway dashboard (Settings → Variables):

```
ASR_SERVICE_URL=https://{username}-tilawati-asr-hptd.hf.space
JWT_SECRET={random string panjang, minimal 32 karakter}
ASR_MODEL_DIR=
CLASSIFICATION_MODEL_DIR=
```

`DATABASE_URL` akan di-inject otomatis oleh Railway PostgreSQL plugin.

**Catatan penting:** Railway inject `DATABASE_URL` dalam format `postgresql://`, tapi backend butuh `postgresql+asyncpg://` untuk async. Perlu modifikasi di `backend/app/config.py`:
```python
# Setelah DATABASE_URL dibaca dari env:
if DATABASE_URL.startswith("postgresql://"):
    DATABASE_URL = DATABASE_URL.replace("postgresql://", "postgresql+asyncpg://", 1)
```

### 3.5 Deploy & jalankan migrasi database
Setelah Railway deploy selesai, jalankan via Railway CLI atau One-Off command di dashboard:
```bash
alembic upgrade head
```

### 3.6 Test endpoint Railway
```bash
curl https://{app-name}.railway.app/api/auth/register \
  -X POST -H "Content-Type: application/json" \
  -d '{"name":"Test","email":"test@test.com","password":"test123"}'
```

**Catat Railway URL:** `https://{app-name}.railway.app` → dipakai di Fase 4.

---

## Fase 4 — Update Flutter & Build APK (~30 menit)

### 4.1 Update api_config.dart
File: `frontend/lib/config/api_config.dart`

```dart
static const String baseUrl = 'https://{app-name}.railway.app';
```

### 4.2 Build release APK
```bash
cd frontend
flutter build apk --release
```
APK output: `build/app/outputs/flutter-apk/app-release.apk`

### 4.3 Install ke HP via sideload
```bash
# Via ADB (HP terhubung USB + USB debugging aktif)
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## Fase 5 — End-to-End Testing (~1–2 jam)

| # | Test | Verifikasi |
|---|------|-----------|
| 1 | Register user baru | Token JWT diterima, user tersimpan di DB |
| 2 | Login | Token valid, redirect ke home |
| 3 | Pilih Jilid 1 | List halaman muncul |
| 4 | Rekam audio di lesson | Upload berhasil, transcript ASR muncul |
| 5 | Lihat evaluasi | Skor Mumtaz/Jayyid/dst tampil |
| 6 | Lihat history | Riwayat evaluasi muncul |
| 7 | Lihat progress | Progress bar per jilid akurat |
| 8 | Test glosarium | Klasifikasi huruf berfungsi (atau graceful fallback) |
| 9 | Test offline (matikan WiFi) | App tidak crash, pesan error yang jelas |

---

## File yang Dimodifikasi

| File | Perubahan |
|------|-----------|
| `Model/Deploy/api/README.md` | Verifikasi YAML header `app_port: 7860` |
| `Model/Deploy/api/.gitattributes` | Buat jika belum ada (Git LFS tracking) |
| `Tilawati/backend/railway.toml` | **Buat baru** — Railway config |
| `Tilawati/backend/app/config.py` | Fix `postgresql://` → `postgresql+asyncpg://` |
| `Tilawati/frontend/lib/config/api_config.dart` | Update `baseUrl` ke Railway URL |

---

## Estimasi Waktu

| Fase | Estimasi |
|------|---------|
| Fase 1 — Verifikasi file | 30 menit |
| Fase 2 — HF Spaces deploy | 1–2 jam (upload 1.2 GB) |
| Fase 3 — Railway deploy | 1–2 jam |
| Fase 4 — Flutter build | 30 menit |
| Fase 5 — E2E testing | 1–2 jam |
| **Total** | **4–7 jam** |

---

## Risiko & Mitigasi

| Risiko | Mitigasi |
|--------|---------|
| Upload 1.2 GB model ke HF Spaces gagal/timeout | Pakai koneksi stabil, Git LFS sudah di-setup |
| HF Spaces sleep setelah inaktif 48h | Kirim request ping sebelum demo sidang |
| Railway free credit habis ($5/bulan) | Cukup untuk demo, estimasi ~$1–2 pemakaian ringan |
| Alembic migration gagal di Railway | Pastikan format `DATABASE_URL` benar sebelum migrate |
| Glosarium (classification model) tidak jalan | Model 1.2 GB tidak di-deploy Railway, graceful fallback — OK untuk TA |

---

## Sukses Kriteria

- [ ] `GET /health` HF Spaces → `{"status":"ok","model":"HPT-D"}`
- [ ] `POST /transcribe` HF Spaces → transcript valid untuk audio hijaiyah
- [ ] `POST /api/auth/register` Railway → user terbuat di DB
- [ ] `POST /api/evaluation/submit_word` Railway → ASR dari HF Spaces dipakai (bukan mock)
- [ ] Flutter APK ter-install di HP, login berfungsi, rekam → dapat skor
