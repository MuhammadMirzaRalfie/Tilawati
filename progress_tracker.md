# Progress Tracker — TilawatiApp (Tilawati Hijaiyah ASR)

**Update Terakhir:** 2026-06-08  
**Status Proyek:** Production LIVE ✅ — HF Spaces + Railway + APK semua running

---

## Status Ringkas Proyek

| Komponen | Status | Catatan |
|----------|--------|---------|
| **Model ASR (ASR-EXP-03-E3)** | ✅ Deploy HF Spaces | CER 0.0382, WER 0.0712, Acc 92.8% |
| **Model Klasifikasi (anas)** | ✅ Lokal saja | 84.28% accuracy, tidak di-deploy (glossary fallback graceful) |
| **Backend (FastAPI + PostgreSQL)** | ✅ Railway | `https://tilawati-production.up.railway.app` |
| **Frontend (Flutter)** | ✅ APK installed | Android 16, Xiaomi 24090RA29G |

**URL Production:**
- 🤗 ASR: `https://XyroOne-tilawati-asr-exp03e3.hf.space`
- 🚂 Backend: `https://tilawati-production.up.railway.app`
- 📱 APK: `frontend/build/app/outputs/flutter-apk/app-release.apk` (85.9 MB)

---

## Catatan Penting (Operasional)

### Build APK — Wajib pakai `--dart-define`
```
flutter build apk --release --dart-define=API_BASE_URL=https://tilawati-production.up.railway.app
```
Tanpa `--dart-define`, APK akan pakai default `localhost:8000` → connection refused di HP.

### `flutter run` ke Railway
```
flutter run --dart-define=API_BASE_URL=https://tilawati-production.up.railway.app
```

### Railway Free Tier
- $5 **one-time** credit (bukan bulanan) — setelah habis perlu Hobby plan $5/bulan
- Alternatif gratis permanen: Render.com (ada cold start seperti HF)

### HF Spaces Free Tier
- Tidak ada batas waktu, tapi **cold start 30–60 detik** setelah idle
- Timeout sudah disesuaikan (lihat bagian Timeout di bawah)

---

## Konfigurasi Timeout (2026-05-19)

| Lokasi | Nilai | Keterangan |
|--------|-------|------------|
| `ai_service.py` — HF Spaces ASR | **55s** | Cover cold start HF free tier |
| `classification_inference.py` — HF Spaces | **55s** | Cover cold start HF free tier |
| `api_service.dart` — `wordEvalTimeout` | **70s** | Flutter cover backend 55s + network |
| `free_inference_screen.dart` | **70s** | Sama |
| `glossary_detail_screen.dart` | **70s** | Sama |

Worst-case: HF cold start 55s + network ~5s = ~60s → Flutter 70s cukup menutup semua skenario.

---

## Fitur Selesai

### Core Features ✅
- Authentication (register, login, JWT, logout)
- Lessons: list jilid/lesson/halaman, rekam per kata, ASR → skor evaluasi
- Progress tracking: progress bar per jilid, riwayat evaluasi
- Profil: edit nama, notifikasi toggle, FAQ, info app
- Glossary: list huruf hijaiyah + klasifikasi (lokal)

### UI/UX ✅
- Dark mode, bottom nav (5 tab), responsive Android 6.0+
- Fix overflow teks Arab (FittedBox)
- Tombol Ulangi/Lanjut di lesson
- Progress tab pakai ProgressProvider (fix navbar bug)

---

## Known Issues

| # | Issue | Severity | Status |
|----|-------|----------|--------|
| 1 | Jilid 2-6 konten minimal (placeholder) | LOW | Acceptable untuk TA |
| 2 | Classification model tidak di-deploy (glossary tanpa klasifikasi) | LOW | Fallback graceful ✅ |
| 3 | Testing E2E hanya manual | MEDIUM | 8 test cases semua PASS |
| 4 | Halaman Riwayat kosong sebelum ada evaluasi | LOW | Expected behavior |

---

## Backlog (Tidak Critical untuk Demo)

- [✅ ] Deploy classification model ke remote (untuk glossary classify)
- [ ] Konten Jilid 2-6 lessons
- [ ] Offline graceful error message
- [ ] Unit test + integration test
- [ ] Gamifikasi (leaderboard, achievements, streaks)

---

## Technical Specifications (Reference)

### Model ASR (ASR-EXP-03-E3)
- Architecture: Wav2Vec2ForCTC (Jonathan-base + Extended Dataset + Word-Level CTC + HPT Phase-2)
- Input: 16 kHz mono WAV
- Output: Transcript + confidence scores
- Performance: CER 0.0382, WER 0.0712, Accuracy 92.8%

### Model Klasifikasi (anas)
- Architecture: CNN (feature extractor frozen, linear head)
- Classes: 28 huruf hijaiyah
- Performance: 84.28% accuracy

### Backend
- FastAPI + SQLAlchemy async + PostgreSQL (Railway)
- Auth: JWT
- Routers: auth, lessons, evaluation, progress, glossary

### Frontend
- Flutter 3.x, Min SDK Android 6.0 (API 21)
- Packages: provider, http, shared_preferences, flutter_sound

---

**Kontak:** x4veront@gmail.com  
**GitHub:** branch `implementation_ASR`

---

## Riwayat Sesi

### Sesi 2026-06-08 — Fitur Tap-to-Jump pada Latihan Modul + Fix Build

**Yang dikerjakan:**
- Implementasi **tap-to-jump** di layar latihan (`frontend/lib/screens/lesson_screen.dart`): user bisa mengetuk kata mana saja untuk dijadikan kata aktif yang direkam & diinferensi (tidak lagi kaku berurutan).
- Perilaku (sesuai konfirmasi user):
  - Tombol **Lanjut** → lompat ke kata **belum dinilai (pending)** berikutnya.
  - **Ringkasan skor** muncul otomatis saat semua kata sudah dinilai.
  - Kata yang sudah dinilai **boleh diketuk ulang**; hasil baru menimpa lama.
- Skor di-refactor jadi **getter turunan dari `_tokenStatus`** (anti dobel-hitung saat rekam ulang / loncat). Counter `_correctCount` manual dihapus, ditambah `_evaluatedCount` & `_allEvaluated`.
- Counter progres di AppBar pakai `_evaluatedCount/total` (lebih bermakna saat loncat-loncat).
- **Fix build blocker (pre-existing):** string multi-baris single-quote di `home_screen.dart:311` (tips "Konsistensi") diubah ke triple-quote `'''...'''` — sebelumnya membuat `flutter build apk` gagal total.

**Output:**
- APK release rebuild (85.9 MB) dengan `--dart-define=API_BASE_URL=...railway.app` dan **terinstall** ke HP Xiaomi 24090RA29G (Android 16).
- `flutter analyze` bersih untuk file yang diubah.

**Catatan operasional:**
- Install via USB di Xiaomi sempat gagal `INSTALL_FAILED_USER_RESTRICTED` (popup di HP ter-close) → berhasil setelah retry + setujui popup.

---

### Sesi 2026-05-20 — Analisis & Rancangan Revisi Laporan TA

**Yang dikerjakan:**
- Analisis gap laporan TA (`Model/Draft_TA/Laporan-TA_Muhammad Mirza.docx`) vs kondisi aktual proyek
- Laporan masih versi **proposal**, bukan laporan final — cover, abstrak, dan semua bab perlu diupdate
- Dibuat rancangan revisi Bab 3 detail per subbab

**Output yang dihasilkan:**
- `Model/Draft_TA/Rancangan_Revisi_Bab3.md`
- `Model/Draft_TA/Rancangan_Revisi_Bab3.docx` ← panduan kerja utama untuk sesi berikutnya

**Koreksi penting yang ditemukan:**
- Dataset extended bukan dari augmentasi — gabungan **rekaman anak Tilawati (TPQ Depok) + dataset publik Kaggle**
- Semua angka di laporan harus mengacu extended dataset: model klasifikasi **Jonathan (93.07%)**, ASR final **EXP-03-E3 (CER 0.0382, WER 0.0712, Acc 92.8%)**
- Perlu tambah evaluasi real-world dari `Model/evaluasi/analisa_hasil_evaluasi_exp03.docx` — 10 pembaca, halaman 44 Tilawati, CER mean 14.46%, faktor dominan: kecepatan baca

**Next step (lanjutkan di sesi berikutnya):**
1. Implementasi revisi ke `Laporan-TA_Muhammad Mirza.docx`, urutan prioritas:
   - 3.1.2 Dataset (tambah komposisi sumber, angka split, dataset ASR)
   - 3.1.4 Modeling (pecah 2 jalur, tabel 12 eksperimen, konfigurasi EXP-03-E3)
   - 3.1.6 Deploy Model (revisi total — arsitektur HF Spaces + Railway)
   - Subbab lain sesuai `Rancangan_Revisi_Bab3.docx`
2. Setelah Bab 3 selesai: tulis Bab 4 (Hasil & Pembahasan) dan Bab 5 (Kesimpulan)
