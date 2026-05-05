# Rekomendasi Pengembangan Selanjutnya — TilawatiApp

**Tanggal:** 2026-04-30  
**Terakhir diperbarui:** 2026-04-30  
**Status Saat Ini:** Backend lokal + Flutter siap, evaluasi dengan HPT-D, glosarium dengan model klasifikasi anas, konten Jilid 1 lengkap 44 halaman, transkripsi ASR tampil di evaluation screen.

---

## Status Implementasi Saat Ini

| Fitur | Status |
|-------|--------|
| Auth (register/login/JWT) | ✅ Selesai |
| Latihan Jilid 1–6 | ✅ Selesai |
| Rekam & evaluasi (mock score) | ✅ Selesai |
| Evaluasi dengan HPT-D lokal | ✅ Selesai (aktif saat docker compose up) |
| Glosarium per-huruf (model anas) | ✅ Selesai |
| Dashboard progres dasar | ✅ Selesai |
| PostgreSQL + Docker | ✅ Selesai |
| Deploy ke HuggingFace Spaces | ⏳ Belum |

---

## Prioritas 1 — Wajib untuk Demo TA

### ✅ 1.1 Perbaiki Konten Jilid (Halaman 12–44) — SELESAI (2026-04-30)
**Problem:** Konten lesson 12–40 di Jilid 1 (`ai_service.py`) masih placeholder (`"اَ بَ تَ ثَ"`). Halaman 1–11 sudah benar.

**Implementasi:**
- Konten hal 12–44 diisi sesuai kurikulum Tilawati Jilid 1 (sumber: `jilid_selection_screen.dart`)
- Total lesson Jilid 1 di backend naik dari 40 → **44 halaman**
- Semua teks Arab + transliterasi kini akurat per halaman (SHA, DHA, THA, ZHA, 'A, GHA, FA, QA, KA, LA, MA, NA, WA, HA, Hamzah, Ya, dan latihan kombinasi)
- Transliterasi bersih dari artefak angka abjad — token ASR akurat

---

### ✅ 1.2 Evaluasi Per Kata dengan Instant Feedback — SELESAI (2026-04-30)
**Problem:** Model HPT-D dilatih untuk 2–4 huruf sekaligus, tapi sebelumnya user merekam seluruh halaman penuh — evaluasi tidak akurat.

**Solusi Diimplementasikan:**
- `lesson_screen.dart` direfactor sepenuhnya: transliterasi diparse jadi token individual (misal `["A", "BA", "TA"]`)
- Tiap token ditampilkan sebagai chip interaktif dengan status warna:
  - Abu-abu: belum direkam
  - Border biru + underline: sedang aktif
  - Hijau + centang: benar
  - Merah + silang: salah
- Alur rekaman: tap mikrofon → ucapkan satu kata → tap stop → evaluasi otomatis → pindah ke kata berikutnya
- Setelah semua kata: tampilkan ringkasan skor (X/N kata benar, grade)

**Backend Baru:**
- Endpoint `POST /api/evaluation/submit_word` di `evaluation.py`
- Menerima `expected_word` + audio WAV; memanggil HPT-D via `transcribe_word()` di `ai_service.py`
- Fallback mock 70% correct jika ASR tidak tersedia (untuk demo)
- `ApiConfig.submitWord` ditambahkan di `api_config.dart`

---

### ✅ 1.3 Tampilan Konfirmasi ASR di Evaluation Screen — SELESAI (2026-04-30)
**Problem:** User tidak tahu apakah model ASR berhasil mendengar atau tidak.

**Solusi:** Tampilkan transkripsi HPT-D di `evaluation_screen.dart`:
```
Model mendengar: "ba ta tsa"
Yang diharapkan: "BA TA TSA"
```

**Implementasi:**
- Getter `asrTranscript` & `asrExpected` ditambah ke `EvaluationModel` (baca dari `phoneme_details`)
- Card "Transkripsi ASR" ditambah di atas "Detail Penilaian" di `evaluation_screen.dart`
- Card hanya muncul saat ASR aktif (tidak muncul di mock mode)

---

## Prioritas 2 — Meningkatkan Kualitas Aplikasi

### 2.1 Scoring Lebih Bermakna
**Problem saat ini:** Scoring hanya berbasis Word Match Rate (cocok/tidak cocok).

**Rekomendasi:**
- Tambahkan penalti untuk **konfusi fonetik yang diketahui** (TSA→SA, HA↔HHA, AIN→A, DZA→ZAY) — error ini lebih "dimaklumi" dari kesalahan acak
- Berikan bonus jika urutan huruf benar meskipun ada 1 huruf salah
- Skor kelancaran bisa diukur dari `duration_ms` relatif terhadap jumlah huruf

---

### 2.2 Offline Mode Terbatas
**Kebutuhan non-fungsional dari dokumen spesifikasi.**

Implementasi:
- Cache konten lesson lokal di Flutter menggunakan `shared_preferences` atau SQLite (`sqflite`)
- Mode "latihan tanpa evaluasi" saat tidak ada koneksi backend
- Sinkronisasi skor saat kembali online

---

### ✅ 2.3 Riwayat Evaluasi di Flutter — SELESAI (2026-04-30)
**Problem:** Menu "Riwayat" di HomeScreen masih kosong (onTap: `() {}`).

**Implementasi:**
- `history_screen.dart` dibuat: tampilkan daftar evaluasi dengan jilid badge, judul lesson, skor, grade, tanggal
- `EvaluationProvider.fetchHistory()` dipanggil di `initState`, pull-to-refresh tersedia
- Route `/riwayat` ditambahkan ke `main.dart`
- Tombol Riwayat di `home_screen.dart` sekarang navigasi ke `/riwayat`

---

### ✅ 2.4 Progress Screen yang Lebih Informatif — SELESAI (2026-04-30)
`progress_screen.dart` sudah disambungkan ke `GET /api/progress/dashboard`.

**Implementasi:**
- `progress_provider.dart` dibuat: fetch `ProgressDashboard` dari backend, expose `completedLessons(jilid)` + `totalLessons(jilid)`
- `ProgressProvider` didaftarkan di `MultiProvider` di `main.dart`
- `progress_screen.dart` direfactor ke `StatefulWidget`, gunakan `Consumer<ProgressProvider>`
- Stat cards (total latihan, rata-rata, tertinggi, streak) menampilkan data nyata
- Progress bar per jilid menggunakan data dari `jilid_progress` (fallback ke total hardcode jika belum ada data)
- Aktivitas terbaru ditampilkan dari `recent_evaluations` (10 terakhir)
- Pull-to-refresh + tombol refresh di AppBar

---

## Prioritas 3 — Fitur Baru yang Direkomendasikan

### 3.1 Mode Kuis Glosarium
Setelah latihan per huruf (glosarium), tambahkan mode kuis:
- Sistem menampilkan huruf Arab, user harus mengucapkan
- Atau sistem memutar audio, user harus menebak huruf
- Skor kuis disimpan ke progress

---

### 3.2 Audio Referensi per Huruf/Halaman
Fitur "Dengar Contoh" di glosarium saat ini tidak ada audio.

**Solusi:**
- Rekam audio referensi untuk 28 huruf (bisa dibaca sendiri, kualitas mikrofon standar sudah cukup)
- Simpan sebagai static file di backend atau Flutter assets
- Flutter memutar via `audioplayers` (sudah ada di pubspec)

---

### 3.3 Notifikasi Pengingat Latihan
Tambahkan notifikasi harian "waktunya latihan tilawati" menggunakan `flutter_local_notifications`.

---

### 3.4 Deploy ke HuggingFace Spaces (Akses dari Mana Saja)
Untuk demo online atau pengujian partisipan tanpa harus install lokal.

Langkah sudah terdokumentasi di `CARA_MENJALANKAN.md` Bagian 3.

---

## Prioritas 4 — Teknis & Infrastruktur

### 4.1 Alembic Migrations
Saat ini tabel dibuat via `create_all` (tanpa versioning). Untuk pengelolaan skema jangka panjang:
```bash
cd Tilawati/backend
alembic init alembic
alembic revision --autogenerate -m "initial"
alembic upgrade head
```

### 4.2 Rate Limiting & Validasi Audio
- Tambahkan validasi durasi audio di backend (minimal 0.3 detik, maksimal 10 detik)
- Rate limit `POST /api/evaluation/submit` dan `POST /api/glossary/classify` untuk mencegah overload

### 4.3 Cleanup File Audio Upload
File audio rekaman di `uploads/` menumpuk dan tidak pernah dihapus. Tambahkan cleanup job atau hapus file setelah evaluasi selesai disimpan ke DB.

---

## Ringkasan Urutan Rekomendasi

```
[Segera / Demo TA]
  1. ✅ Lengkapi konten Jilid 1 hal 12–44  ← SELESAI
  2. ✅ Tampilkan transkripsi ASR di evaluation screen  ← SELESAI
  3. ✅ Rekaman per kata dengan instant feedback  ← SELESAI (2026-04-30)

[Minggu ini]
  4. ✅ Sambungkan menu Riwayat  ← SELESAI (2026-04-30)
  5. ✅ Lengkapi Progress screen dengan data nyata  ← SELESAI (2026-04-30)
  6. Tambahkan audio referensi huruf

[Setelah TA / Pengembangan Lanjut]
  7. Mode kuis glosarium
  8. Offline mode
  9. Notifikasi harian
  10. Deploy HuggingFace Spaces
  11. Alembic migrations
```
