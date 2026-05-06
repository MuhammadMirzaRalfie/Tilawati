# Implementation Plan — Fix Overflow Halaman Latihan

**Tanggal:** 2026-05-06  
**File target:** `frontend/lib/screens/lesson_screen.dart`  
**Estimasi:** ~15 menit

---

## 1. Root Cause

### Overflow Utama (High Priority)
**Lokasi:** `_buildArabicDisplay()` — baris 261–267

```dart
return Directionality(
  textDirection: TextDirection.rtl,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: rowChildren,  // ← Text 36px, banyak kata = overflow horizontal
  ),
);
```

Setiap baris Arab di-render dalam `Row` tanpa batas lebar. Dengan `fontSize: 36` dan beberapa kata per baris (misal: pelajaran dengan 3–4 kata), Row dapat melebihi lebar layar. `SingleChildScrollView` di body **hanya menangani vertikal**, bukan horizontal overflow pada Row ini.

### Overflow Minor (Low Priority)
**Lokasi:** `_buildRecordingSection()` — baris 475–490

```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Text('Sistem mendengar: $_lastTranscript', ...),
)
```

Container transcript tidak memiliki `softWrap` atau batas lebar eksplisit. Jika transcript ASR panjang, teks bisa overflow. Karena sudah dalam Column ter-constrain ini risikonya kecil, tapi perlu diantisipasi.

---

## 2. Solusi

### Fix 1 — Wrap Row Arabic dengan `FittedBox`
**Pendekatan:** `FittedBox(fit: BoxFit.scaleDown)` di sekeliling setiap Row Arab.

**Alasan memilih FittedBox dibanding opsi lain:**
| Opsi | Alasan Ditolak |
|------|---------------|
| `Wrap` | Mengacak urutan kata — buruk untuk RTL Arab |
| Horizontal `SingleChildScrollView` | UX buruk untuk aplikasi belajar |
| `OverflowBox` | Menyembunyikan overflow, tidak memperbaikinya |
| `FittedBox(scaleDown)` | ✅ Scale down hanya jika perlu, layout RTL terjaga, semua kata terlihat |

**Perubahan (surgical — 4 baris):**

```dart
// BEFORE (baris 261–267)
return Directionality(
  textDirection: TextDirection.rtl,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: rowChildren,
  ),
);

// AFTER
return FittedBox(
  fit: BoxFit.scaleDown,
  child: Directionality(
    textDirection: TextDirection.rtl,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowChildren,
    ),
  ),
);
```

### Fix 2 — Tambah `softWrap` pada Text Transcript
**Perubahan (surgical — 1 baris):**

```dart
// BEFORE (baris 481–487)
child: Text(
  'Sistem mendengar: $_lastTranscript',
  style: GoogleFonts.poppins(fontSize: 13, ...),
),

// AFTER — tambah softWrap dan textAlign
child: Text(
  'Sistem mendengar: $_lastTranscript',
  softWrap: true,
  textAlign: TextAlign.center,
  style: GoogleFonts.poppins(fontSize: 13, ...),
),
```

---

## 3. Langkah Implementasi

1. **Edit `_buildArabicDisplay()`** — baris 261–267  
   → Wrap Row dengan `FittedBox(fit: BoxFit.scaleDown)`  
   → Verify: tidak ada overflow indicator merah/kuning

2. **Edit transcript Text** — baris 481  
   → Tambah `softWrap: true` dan `textAlign: TextAlign.center`  
   → Verify: text transcript panjang tetap dalam container

---

## 4. Success Criteria

- [ ] Buka lesson dengan banyak kata per baris → **tidak ada RenderFlex overflow** (tidak ada strip merah/kuning di tepi layar)
- [ ] Semua kata Arab terlihat di layar tanpa perlu scroll horizontal
- [ ] Lesson dengan sedikit kata (misal 1–2 per baris) → tampilan tidak berubah (FittedBox tidak scaling jika tidak perlu)
- [ ] Teks transcript panjang wrap ke baris berikutnya, tidak overflow
- [ ] `flutter analyze` tidak ada error baru

---

## 5. File yang Dimodifikasi

| File | Perubahan |
|------|-----------|
| `frontend/lib/screens/lesson_screen.dart` | 2 lokasi: FittedBox di Row Arab (baris ~261), softWrap pada Text transcript (baris ~481) |
