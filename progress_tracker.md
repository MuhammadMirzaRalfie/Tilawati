# Progress Tracker — TilawatiApp (Tilawati Hijaiyah ASR)

**Update Terakhir:** 2026-06-24  
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
- **Penilaian Top-3** (2026-06-24) — toggle di Profil; huruf benar bila masuk 3 besar confidence (memaafkan kesalahan serumpun makhraj). Default tetap konvensional.
- Progress tracking: progress bar per jilid, riwayat evaluasi
- Profil: edit nama, notifikasi toggle, **toggle Penilaian Top-3**, FAQ, info app
- Glossary: list huruf hijaiyah + klasifikasi (lokal)

### UI/UX ✅
- **Dark mode** (2026-06-11) — toggle di Profil, persist via SharedPreferences. (Catatan: klaim "dark mode" di tracker sebelumnya tidak akurat — baru benar-benar diimplementasi sekarang.)
- Bottom nav (4 tab), responsive Android 6.0+
- Fix overflow teks Arab (FittedBox)
- Tombol Ulangi/Lanjut di lesson
- Progress tab pakai ProgressProvider (fix navbar bug)
- **Offline/error UX** (2026-06-11) — ErrorStateWidget reusable + pesan ramah ("Tidak ada koneksi internet"), cache dashboard & glossary di SharedPreferences dengan banner offline
- **Achievements** (2026-06-11) — 7 badge client-side di tab Progres (derive dari data dashboard, tanpa backend)
- **Notifikasi lokal** (2026-06-11) — pengingat latihan harian 18:00 via flutter_local_notifications; toggle Notifikasi di Profil kini benar-benar berfungsi

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
- [✅] Offline graceful error message (2026-06-11)
- [ ] Unit test + integration test
- [~] Gamifikasi — achievements ✅ + streak display ✅ (2026-06-11); leaderboard belum

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

### Sesi 2026-06-24 — Fitur "Penilaian Top-3" (Tilawati v2) + deploy online

**Latar:** user minta penilaian latihan lebih mudah benar — huruf dianggap benar bila masuk **3 besar confidence** ASR (mis. ucap "ha" terdeteksi "hha" tapi "ha" ada di top-3 → tetap benar).

**Analisis offline dulu (sebelum sentuh app):**
- Harness perbandingan `Model/evaluasi/eval_e3_top3_compare.py` pada TEST-SPLIT resmi (SEED=42, 393 grup).
- Hasil: group-exact **81.4% → 95.2%** (top-3 mentah), letter-acc **92.8% → 97.8%**. Tapi dari 60 huruf yang "diselamatkan", **40 (67%) adalah pasangan serumpun makhraj** (tsa↔sa, dza↔zay, dho↔zho, hha↔ha, …) — trade-off pedagogis dicatat. Output di `Model/evaluasi/exp03_e3_top3_compare/`.

**Implementasi (mode pilihan, default konvensional → v1 aman):**
- Backend `asr_inference.py`: `transcribe_file(with_topk=True)` + `_decode_ctc_topk()` — top-k per posisi huruf di frame puncak (reuse 1 forward pass, tanpa biaya inferensi tambahan).
- Backend `ai_service.py`: `transcribe_word_topk()` (lokal → fallback HF Space yang kini mengembalikan `words_topk`).
- Backend `evaluation.py`: param `match_mode` (`conventional|top3`) di `/submit_word` + `_tokens_match_topk()` (panjang huruf tetap wajib sama; toleransi HA↔HHA & normalisasi label dipakai ulang).
- Layanan ASR `Model/Deploy/api/inference.py`: `/transcribe` kini mengembalikan `words_topk` (kompatibel mundur).
- Frontend: toggle **"Penilaian Top-3"** di Profil (`SharedPreferences` key `match_top3`); `lesson_screen.dart` kirim `match_mode`.
- **Fix tampilan:** saat dinilai **benar**, hasil evaluasi menampilkan huruf yang benar (expected), bukan transkrip top-1 yang berbeda ("Sistem mendengar: TA", bukan "tho"). Saat salah tetap jujur menampilkan yang terdengar.

**Deploy (semua online):**
- HF Space ASR `XyroOne/tilawati-asr-exp03e3` di-redeploy via `_upload_to_hf.py --mode=space` → `words_topk` live (verified).
- Backend Railway redeploy via push `implementation_ASR` → `match_mode` live di schema (verified).
- APK release rebuild (91.4 MB, `--dart-define=...railway.app`) + terinstall di Xiaomi 24090RA29G (sempat `INSTALL_FAILED_USER_RESTRICTED`, sukses setelah retry).

**Catatan operasional:**
- Top-3 online **bergantung pada HF Space mengembalikan `words_topk`** (Railway tak punya model lokal). Token HF disimpan di `backend/.env` (`HF_TOKEN_ASR`/`HF_TOKEN_CLASSIFIER`, ter-ignore git).
- `client wordEvalTimeout 70s` cukup untuk cold-start HF 55s.

**Lanjutan — klarifikasi skor & pembersihan dead code:**
- **Temuan:** alur latihan aktual (`lesson_screen` → `/submit_word` → `/submit_lesson_result`) **tidak** menghasilkan skor tajwid/makhraj. Ringkasan hanya menampilkan jumlah kata benar + persentase + grade. Field `makharijul/tajwid/kelancaran` di DB diisi **placeholder identik** (= overall) oleh `submit_lesson_result`.
- Formula "skor" `wmr*90`/`wmr*85` ada di `evaluate_audio` (`/submit`) yang **hanya** dipakai `EvaluationScreen` — dan tak ada navigasi ke sana → **dead code**.
- **Dihapus:** `EvaluationScreen` (+ route `/evaluation` & import di main.dart), `EvaluationProvider.submitEvaluation` + field terkait (`fetchHistory` tetap dipakai Riwayat/Jilid), const `submitEvaluation` di api_config; backend endpoint `/submit` (`submit_evaluation`), `evaluate_audio`, `_generate_feedback`, `_generate_phoneme_feedback`, `_tokenize_transliteration`, `_word_match_rate`, + import yatim (`random`/`uuid`/`re`/`Any`). `flutter analyze` bersih, backend `py_compile` OK. APK tak perlu rebuild (tanpa perubahan perilaku).



**Yang dikerjakan (semua frontend, tanpa perubahan backend):**
1. **Offline/Error UX** — `_guard()` di `api_service.dart` mengubah `SocketException`/`TimeoutException` jadi pesan ramah; util `saveCache`/`loadCache` (SharedPreferences); `ErrorStateWidget` + `OfflineBanner` reusable (`widgets/error_state.dart`); fallback cache di dashboard progres & glossary; error state di Progres/Glosarium/Riwayat (sebelumnya silent fail → angka 0).
2. **Dark Mode** — `AppTheme.darkTheme` + `ThemeProvider` baru, extension `ThemeColors on BuildContext` (`cardBg`/`textPrimary`/`textSecondary`/`textLight`), sweep warna hardcoded di 11 screen + 2 widget, toggle "Mode Gelap" di Profil, persist `dark_mode` pref, status bar menyesuaikan per theme.
3. **Achievements** — `widgets/achievement_grid.dart`: 7 badge (Latihan Pertama/10/50, Rajin, Konsisten, Mumtaz, Jilid 1 Tamat) derive client-side dari data dashboard; section "Pencapaian" di tab Progres; tap badge → dialog deskripsi.
4. **Notifikasi Lokal** — `flutter_local_notifications` ^18 + `timezone`; desugaring di `build.gradle.kts`; permission `POST_NOTIFICATIONS` + boot receiver di manifest; `services/notification_service.dart` (reminder harian 18:00, inexact alarm → tanpa SCHEDULE_EXACT_ALARM); toggle Notifikasi di Profil kini schedule/cancel sungguhan + handle penolakan izin Android 13+.

**Output:**
- `flutter analyze` bersih; APK release rebuild (87.8 MB) dengan `--dart-define=API_BASE_URL=...railway.app`.
- File baru: `lib/providers/theme_provider.dart`, `lib/widgets/error_state.dart`, `lib/widgets/achievement_grid.dart`, `lib/services/notification_service.dart`.

**Belum diverifikasi di device (perlu smoke test manual):**
- Visual dark mode tiap screen, notifikasi 18:00 muncul, banner offline saat airplane mode, badge sesuai data.

**Lanjutan sesi yang sama — 4 polesan UI/UX:**
1. **Font Arab Amiri** — ganti `fontFamily: 'Arial'` → `GoogleFonts.amiri` di lesson, glosarium, dan detail glosarium (font naskh yang layak untuk teks Al-Qur'an).
2. **Shimmer skeleton loading** — `widgets/skeleton_loading.dart` (ProgressSkeleton, GlossaryGridSkeleton, HistoryListSkeleton) menggantikan spinner polos; theme-aware dark/light. Package `shimmer` yang sudah terpasang akhirnya dipakai.
3. **Grafik tren skor** — section "Tren Skor" di tab Progres (LineChart `fl_chart` dari recent evaluations, tampil jika ≥2 data, tooltip skor). Package `fl_chart` yang sudah terpasang akhirnya dipakai.
4. **Confetti Mumtaz** — `widgets/confetti_celebration.dart` (CustomPainter ~3 detik, tanpa aset eksternal) muncul di halaman evaluasi saat skor ≥85.
- Keputusan user: **tanpa haptic feedback** (getaran tidak disukai).
- APK rebuild (88.4 MB) + terinstall & diluncurkan di Xiaomi 24090RA29G.
- Catatan: `lottie` & `flutter_animate` di pubspec masih belum terpakai — kandidat dihapus untuk mengecilkan APK.

**Lanjutan sesi yang sama — 10 pembaruan UI/UX (hasil analisa screenshot):**
1. **Status di daftar pelajaran** — data jilid statis diekstrak ke `lib/data/tilawati_lessons.dart` (`kJilids`); kartu lesson kini menampilkan ✓ + chip "Skor X" (warna sesuai grade) / "Belum dikerjakan", ikon play→replay, border hijau untuk yang selesai; header jilid menampilkan "X/N pelajaran selesai". Status dari history evaluasi (`fetchHistory(limit: 100)` — provider sekarang menerima param limit), refresh otomatis setelah kembali dari latihan.
2. **Kartu "Lanjutkan Latihan" di Beranda** — target = pelajaran setelah evaluasi terakhir, dengan progress bar jilid; navigasi langsung ke `/lesson`. Dashboard di-fetch saat HomeScreen init.
3. **Progres di badge terkunci** — Achievement punya field `progress` ("2/10", "1/3 hari", "Terbaik 85"); tampil emas kecil di badge terkunci; opacity terkunci dinaikkan 0.45→0.6.
4. **Ornamen geometris Islami** — `widgets/islamic_pattern.dart` (CustomPainter bintang 8 sudut konsentris, tanpa aset); dipasang di banner Beranda (putih transparan) + latar login (hijau/emas transparan).
5. **Legenda warna + progress bar di latihan** — chip legenda (Giliran Anda/Benar/Perlu diulang/Belum) di atas kartu Arab; LinearProgressIndicator tipis di bawah AppBar (evaluated/total).
6. **Animasi stagger (flutter_animate akhirnya dipakai)** — fade-in+slide pada grid jilid, list lesson, menu Beranda, stat cards Progres, kartu Lanjutkan.
7. **Aktivitas Terbaru tappable** → membuka /riwayat.
8. **Ikon Mode Gelap** statis bulan. 9. **Pill indicator** di bottom nav aktif. 10. Emoji ✨ di register dihapus.
- `flutter analyze` bersih; APK rebuild 88.6 MB. **Install ke HP tertunda — device tidak terdeteksi ADB saat itu** (`adb install -r frontend/build/app/outputs/flutter-apk/app-release.apk` saat HP tersambung).

---

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
