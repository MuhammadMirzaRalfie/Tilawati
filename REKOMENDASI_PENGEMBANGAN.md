# Rekomendasi Pengembangan Selanjutnya — TilawatiApp

**Tanggal:** 2026-04-30  
**Status Saat Ini:** Backend lokal + Flutter siap, evaluasi dengan HPT-D, glosarium dengan model klasifikasi anas.

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

### 1.1 Perbaiki Konten Jilid (Halaman 12–40)
**Problem:** Konten lesson 12–40 di Jilid 1 (`ai_service.py`) masih placeholder (`"اَ بَ تَ ثَ"`). Halaman 1–11 sudah benar.

**Solusi:** Isi teks Arab dan transliterasi yang sesuai buku Tilawati Jilid 1. Ini data, bukan kode — cukup update dict `TILAWATI_CONTENT`.

**Impact:** Langsung meningkatkan kualitas demo dan akurasi evaluasi ASR.

---

### 1.2 Alur Evaluasi Lebih Akurat — Scoring per Baris
**Problem:** Model HPT-D dilatih untuk 2–4 huruf sekaligus, tapi konten lesson bisa punya banyak baris. Jika user merekam seluruh halaman, evaluasi jadi tidak akurat.

**Solusi:** Bagi rekaman per baris atau per kelompok huruf (misal 2–4 huruf per rekaman), sesuai cara model dilatih.

Opsi implementasi:
- Flutter menampilkan **satu baris** teks per rekaman (bukan satu halaman penuh)
- User rekam baris per baris, skor per baris diakumulasi

---

### 1.3 Tampilan Konfirmasi ASR di Evaluation Screen
**Problem:** User tidak tahu apakah model ASR berhasil mendengar atau tidak.

**Solusi:** Tampilkan transkripsi HPT-D di `evaluation_screen.dart`:
```
Model mendengar: "ba ta tsa"
Yang diharapkan: "BA TA TSA"
```

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

### 2.3 Riwayat Evaluasi di Flutter
**Problem:** Menu "Riwayat" di HomeScreen masih kosong (onTap: `() {}`).

**Solusi:** Buat `history_screen.dart` yang memanggil `GET /api/evaluation/history` dan menampilkan daftar hasil evaluasi dengan tanggal, jilid, lesson, dan skor.

---

### 2.4 Progress Screen yang Lebih Informatif
`progress_screen.dart` perlu disambungkan ke `GET /api/progress/dashboard`. Tambahkan:
- Grafik progres skor per minggu (gunakan `fl_chart` yang sudah ada di pubspec)
- Streak latihan harian
- Badge pencapaian per jilid

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
  1. Lengkapi konten Jilid 1 hal 12–40
  2. Tampilkan transkripsi ASR di evaluation screen
  3. Pertimbangkan rekaman per baris (bukan per halaman)

[Minggu ini]
  4. Sambungkan menu Riwayat
  5. Lengkapi Progress screen dengan chart
  6. Tambahkan audio referensi huruf

[Setelah TA / Pengembangan Lanjut]
  7. Mode kuis glosarium
  8. Offline mode
  9. Notifikasi harian
  10. Deploy HuggingFace Spaces
  11. Alembic migrations
```
