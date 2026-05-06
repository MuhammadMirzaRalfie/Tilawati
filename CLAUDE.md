# CLAUDE.md — Tilawati: Aplikasi Pembelajaran Bacaan Al-Qur'an Berbasis AI

Aplikasi Flutter + FastAPI untuk membantu pengguna belajar dan mengevaluasi bacaan Al-Qur'an metode Tilawati. User merekam bacaan per kata, backend mengevaluasi dengan AI, lalu menampilkan skor dan feedback.

---

## Konteks Proyek

**Tugas Akhir:** Tilawati Hijaiyah ASR — pengenalan dan evaluasi ucapan huruf hijaiyah.
**Target Platform:** Android (prioritas), iOS, Web.
**Stack:** Flutter (frontend) + FastAPI + PostgreSQL (backend).
**Status AI:** Evaluasi terhubung ke model HPT-D lokal via `asr_inference.py`; fallback ke mock jika model tidak tersedia. 

---
## Direktori
-model : berisi eksperimen serta analisa model yang digunakan yaitu wav2vec2 ASR dan klasifikasi
  -ASR : eksperimen dan analisa untuk model ASR
  -clasification : eksperimen dan analisa untuk model klasifikasi
  -dataset : data yang digunakan untuk training dan evaluasi model
  -deploy : kode deploy lokal model
  -inference : kode inference lokal model
  -model final ASR: model ASR dengan performa terbaik saat ini
  -model klasifikasi(anaswav2vec2): model klasifikasi dengan performa terbaik saat ini
  -preprocessing : kode untuk melakukan preprocessing pada data
-Tilawati : berisi source code aplikasi Flutter
 -backend : berisi source code backend
 -frontend : berisi source code frontend
 -blueprint dan rancangan: dokumentasi serta rancangan aplikasi dan model
 -desain ui: desain antarmuka aplikasi
 -

## aturan AI
-baca claude.md dari plugin andrej-karpathy dan terapkan
-setiap memulai sesi pahami konteks serta progres project dari progres tracker.md jika ada
-konfirmasi dan berikan pertanyaan apabila ada yang kurang.


## apa yang harus dilakukan untuk mengetahui konteks dan progres project
- pahami konteks project dengan membaca dokumentasi di direktori blueprint dan rancangan serta deployment_plan
- kalau tidak yakin lakukan konfirmasi dengan bertanya kepada saya

## apa yang harus dilakukan jika saya meminta untuk analisa
-melakukan analisa pada dokumen yang saya maksud atau dari progres tracker.md jika ada 
-lakukan analisa secara komprehensif dan detail
-lakukan dokumentasi dalam bentuk docx dan .md jika saya minta dokumentasi
-selalu tanya dan minta konfirmasi apakah saya perlu dokumentasi

## apa yang harus dilakukan jika saya meminta planning
-pahami konteks secara mendalam dari blueprint dan rancangan atau progres tracker.md jika ada
-buat rencana perubahan untuk sesi tersebut dalam bentuk implementation plan.md untuk sesi tersebut
-selalu tanya dan minta konfirmasi apakah saya perlu dokumentasi rancangan
-jika sudah selesai planning dan menulis implementation.md lakukan konfirmasi dengan bertanya apakah saya ingin melanjutkan ke implementasi

## apa yang harus dilakukan jika saya meminta implementasi
-selalu pahami konteks dari implementation plan.md jika saya tidak memverikan tugas secacra eksplisit
-selalu tanyakan dan konfirmasi saya terkait implementasi yang ingin doterapkan
-jika sudah selesai implementasi lakukan konfirmasi kemudian update progres tracker.md jika ada, jika tidak ada maka buat baru progres tracker.md

## apa yang harus dilakukan untuk menutup sesi
-jalankan agent session_closer
-lakukan update terkait progres projek
-lakukan update terkait progres tracker.md jika ada, jika tidak ada maka buat baru progres tracker.md
-minta konfirmasi apakah ingin di push ke github atau tidak.

