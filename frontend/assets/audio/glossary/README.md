# Audio Contoh Bacaan Ahli — Glosarium Huruf

Folder ini menampung file audio **contoh pengucapan ahli** untuk tiap huruf
hijaiyah, yang diputar lewat tombol "Dengar contoh" di layar
`glossary_detail_screen.dart` (via widget `ExampleAudioButton`).

## Konvensi penamaan

- Format: **`<label-huruf-lowercase>.mp3`**
- `label` mengikuti kunci pada `HIJAIYAH_META`
  (`backend/app/services/classification_inference.py`).
- Contoh: huruf **BA** → `ba.mp3`, **TSA** → `tsa.mp3`, **AIN** → `ain.mp3`.

Resolusi path di kode: `assets/audio/glossary/${label.toLowerCase()}.mp3`.

## Daftar 28 file yang diharapkan

```
a.mp3    ba.mp3   ta.mp3   tsa.mp3  ja.mp3   hha.mp3  kho.mp3
da.mp3   dza.mp3  ro.mp3   zay.mp3  sa.mp3   sya.mp3  sho.mp3
dho.mp3  tho.mp3  zho.mp3  ain.mp3  gho.mp3  fa.mp3   qo.mp3
ka.mp3   la.mp3   ma.mp3   na.mp3   ha.mp3   wa.mp3   ya.mp3
```

## Catatan

- File audio **belum tersedia**. Selama file belum ditaruh, tombol "Dengar
  contoh" tetap muncul namun saat ditekan menampilkan pesan
  "Contoh bacaan belum tersedia" (graceful, tidak crash).
- Disarankan: WAV/MP3 mono, durasi pendek (1–2 detik), rekaman qari/ahli.
- Setelah menambahkan file, jalankan `flutter pub get` lalu rebuild agar
  asset ter-bundle.
