# Cara Menjalankan TilawatiApp

**Stack:** Flutter (frontend Android) + FastAPI + PostgreSQL (backend)

---

## Prasyarat

| Tools | Versi Minimum | Cek Instalasi |
|-------|--------------|---------------|
| Python | 3.11+ | `python --version` |
| Docker Desktop | Terbaru | `docker --version` |
| Flutter SDK | 3.7+ | `flutter --version` |
| Android Studio / VS Code | — | — |
| Android Emulator / Device | API 21+ | — |

---

## Bagian 1 — Backend (FastAPI + PostgreSQL)

### Opsi A — Pakai Docker (Direkomendasikan)

Docker menjalankan PostgreSQL + backend sekaligus tanpa instalasi manual.

```bash
# Masuk ke direktori Tilawati
cd D:\TA\TilawatiApp\Tilawati

# Jalankan PostgreSQL + backend
docker compose up
```

Backend aktif di: `http://localhost:8000`

Untuk menjalankan di background:
```bash
docker compose up -d
```

Untuk menghentikan:
```bash
docker compose down
```

---

### Opsi B — Jalankan Lokal Tanpa Docker

> Gunakan opsi ini jika Docker tidak tersedia. PostgreSQL harus sudah terinstall dan berjalan.

**1. Buat virtual environment dan install dependencies:**

```bash
cd D:\TA\TilawatiApp\Tilawati\backend

python -m venv venv
venv\Scripts\activate        # Windows
# atau: source venv/bin/activate  (Linux/Mac)

pip install -r requirements.txt
```

**2. Siapkan database PostgreSQL:**

Pastikan PostgreSQL sudah berjalan, lalu buat database:

```sql
CREATE USER tilawati WITH PASSWORD 'tilawati123';
CREATE DATABASE tilawati_db OWNER tilawati;
```

**3. Konfigurasi environment:**

File `.env` sudah ada di `backend/`. Pastikan isinya sesuai:

```env
DATABASE_URL=postgresql+asyncpg://tilawati:tilawati123@localhost:5432/tilawati_db
SECRET_KEY=tilawati-dev-secret-key-2024
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
UPLOAD_DIR=./uploads
ASR_SERVICE_URL=          # kosongkan dulu, isi setelah deploy HF Spaces
```

**4. Jalankan backend:**

```bash
# Pastikan masih di direktori backend/ dan venv aktif
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Backend aktif di: `http://localhost:8000`

---

### Verifikasi Backend

Buka browser atau gunakan curl:

```bash
# Cek status
curl http://localhost:8000/health

# Lihat dokumentasi API interaktif
# Buka di browser: http://localhost:8000/docs
```

Respons yang diharapkan:
```json
{"status": "healthy"}
```

---

## Bagian 2 — Flutter App (Android)

### 1. Install dependencies Flutter

```bash
cd D:\TA\TilawatiApp\Tilawati\frontend

flutter pub get
```

### 2. Cek koneksi ke backend

Buka file `lib/config/api_config.dart` dan sesuaikan `baseUrl`:

```dart
// Android Emulator → gunakan ini (10.0.2.2 adalah alias localhost dari emulator)
static const String baseUrl = 'http://10.0.2.2:8000';

// Device fisik → ganti dengan IP komputer di jaringan yang sama
// static const String baseUrl = 'http://192.168.1.xxx:8000';

// iOS Simulator
// static const String baseUrl = 'http://localhost:8000';
```

> **Cara cari IP komputer (Windows):** buka Command Prompt → ketik `ipconfig` → lihat IPv4 Address.

### 3. Jalankan di Emulator atau Device

**Pastikan Android Emulator sudah berjalan** (atau device fisik terhubung via USB dengan USB Debugging aktif).

```bash
# Cek device yang tersedia
flutter devices

# Jalankan app (pilih device jika ada lebih dari satu)
flutter run
```

Atau jalankan langsung ke emulator/device spesifik:

```bash
flutter run -d emulator-5554
```

### 4. Build APK (opsional, untuk install ke device)

```bash
flutter build apk --release
```

File APK ada di: `build/app/outputs/flutter-apk/app-release.apk`

---

## Bagian 3 — Evaluasi AI (Model Lokal)

Evaluasi menggunakan **model HPT-D** (ASR) dan **model anas** (klasifikasi per huruf) yang dimuat langsung di backend saat startup — tidak perlu internet.

Model dimuat otomatis oleh Docker via volume mount. Tidak ada konfigurasi tambahan yang dibutuhkan.

> **Catatan:** Model pertama kali dimuat saat `docker compose up` — proses ini memakan waktu ~30–60 detik. Tunggu hingga log menampilkan `✅ Tilawati API is ready!` sebelum membuka Flutter app.

---

## Bagian 4 — Deploy ke HuggingFace Spaces (Opsional)

Hanya diperlukan jika ingin akses online (demo tanpa laptop). Untuk development lokal, bagian ini bisa dilewati.

### Deploy ASR ke HuggingFace Spaces

Semua file sudah siap di `Model/Deploy/api/`.

**Langkah:**

```bash
# 1. Login ke huggingface.co, buat Space baru
#    Settings: SDK = Docker, Visibility = Public
#    Nama contoh: asr-hijaiyah-hptd

# 2. Clone repo Space yang baru dibuat
git clone https://huggingface.co/spaces/{username}/asr-hijaiyah-hptd
cd asr-hijaiyah-hptd

# 3. Setup Git LFS (wajib untuk model ~1.2 GB)
git lfs install
git lfs track "*.safetensors"
git add .gitattributes

# 4. Salin semua file dari Model/Deploy/api/ ke folder ini
# (main.py, inference.py, Dockerfile, requirements.txt, README.md, folder model/)

# 5. Push ke HuggingFace
git add .
git commit -m "deploy asr hijaiyah hptd"
git push
```

Build pertama kali memakan waktu 5–10 menit. Setelah selesai, cek:
```
GET https://{username}-asr-hijaiyah-hptd.hf.space/health
```

**Aktifkan di backend:**

Edit `Tilawati/backend/.env`:
```env
ASR_SERVICE_URL=https://{username}-asr-hijaiyah-hptd.hf.space
```

Lalu restart backend:
```bash
# Dengan Docker:
docker compose restart backend

# Tanpa Docker:
# Stop uvicorn (Ctrl+C) lalu jalankan ulang
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

---

## Struktur Direktori Tilawati

```
Tilawati/
├── backend/              ← FastAPI server
│   ├── app/
│   │   ├── main.py       ← entry point FastAPI
│   │   ├── config.py     ← konfigurasi env vars
│   │   ├── models/       ← SQLAlchemy models (User, Evaluation, Progress)
│   │   ├── routers/      ← endpoint API (auth, lessons, evaluation, progress)
│   │   └── services/
│   │       └── ai_service.py  ← logika evaluasi + konten Tilawati
│   ├── requirements.txt
│   ├── Dockerfile
│   └── .env              ← konfigurasi lokal (jangan di-commit ke git publik)
│
├── frontend/             ← Flutter app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── config/
│   │   │   └── api_config.dart  ← URL backend (ubah sesuai environment)
│   │   ├── screens/      ← halaman UI
│   │   ├── providers/    ← state management
│   │   ├── services/     ← HTTP client
│   │   └── models/       ← data models
│   └── pubspec.yaml
│
├── docker-compose.yml    ← PostgreSQL + backend (Docker)
└── CARA_MENJALANKAN.md   ← dokumen ini
```

---

## Ringkasan Perintah Cepat

```bash
# --- Backend (Docker) ---
cd D:\TA\TilawatiApp\Tilawati
docker compose up               # jalankan
docker compose down             # hentikan
docker compose logs backend     # lihat log

# --- Backend (lokal) ---
cd backend && venv\Scripts\activate
uvicorn app.main:app --reload --port 8000

# --- Flutter ---
cd frontend
flutter pub get
flutter run                     # emulator/device
flutter build apk --release     # build APK
```

---

## Troubleshooting

| Masalah | Solusi |
|---------|--------|
| `Connection refused` di Flutter | Pastikan backend jalan & `baseUrl` di `api_config.dart` sudah benar |
| `RECORD_AUDIO permission denied` | Saat pertama buka app, izinkan akses mikrofon di popup |
| Docker port 5432 sudah dipakai | Stop PostgreSQL lokal yang sedang berjalan, atau ubah port di `docker-compose.yml` |
| `flutter pub get` gagal | Jalankan `flutter doctor` untuk cek instalasi |
| Backend crash saat startup | Cek log: `docker compose logs backend` — biasanya DB belum siap |
| Evaluasi hanya mengembalikan skor acak | `ASR_SERVICE_URL` belum diisi di `.env`, deploy HF Spaces dulu |
