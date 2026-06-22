# Audio Contoh Bacaan Ahli — Glosarium Huruf

Folder ini menampung file audio **contoh pengucapan ahli** untuk tiap huruf
hijaiyah, yang diputar lewat tombol "Dengar contoh" di layar
`glossary_detail_screen.dart` (via widget `ExampleAudioButton`).

## Konvensi penamaan

- Format: **`<label-huruf-lowercase>.wav`**
- `label` mengikuti kunci pada `HIJAIYAH_META`
  (`backend/app/services/classification_inference.py`).
- Contoh: huruf **BA** → `ba.wav`, **TSA** → `tsa.wav`, **AIN** → `ain.wav`.

Resolusi path di kode: `assets/audio/glossary/${label.toLowerCase()}.wav`.

## Daftar 28 file (sudah tersedia)

```
a.wav    ba.wav   ta.wav   tsa.wav  ja.wav   hha.wav  kho.wav
da.wav   dza.wav  ro.wav   zay.wav  sa.wav   sya.wav  sho.wav
dho.wav  tho.wav  zho.wav  ain.wav  gho.wav  fa.wav   qo.wav
ka.wav   la.wav   ma.wav   na.wav   ha.wav   wa.wav   ya.wav
```

## Catatan

- File audio diisi dari rekaman **bacaan ahli** (folder `Bacaan ahli/`),
  huruf hijaiyah harakat fathah, mono.
- Jika suatu file belum ada, tombol "Dengar contoh" tetap muncul namun saat
  ditekan menampilkan pesan "Contoh bacaan belum tersedia" (graceful, tidak crash).
- Setelah menambah/mengubah file, jalankan `flutter pub get` lalu rebuild agar
  asset ter-bundle.
