// Data for Tilawati app
const HIJAIYAH = [
  { ar: 'ا', name: 'Alif' }, { ar: 'ب', name: 'Ba' }, { ar: 'ت', name: 'Ta' },
  { ar: 'ث', name: 'Tsa' }, { ar: 'ج', name: 'Jim' }, { ar: 'ح', name: 'Ha' },
  { ar: 'خ', name: 'Kho' }, { ar: 'د', name: 'Dal' }, { ar: 'ذ', name: 'Dzal' },
  { ar: 'ر', name: 'Ro' }, { ar: 'ز', name: 'Za' }, { ar: 'س', name: 'Sin' },
  { ar: 'ش', name: 'Syin' }, { ar: 'ص', name: 'Shod' }, { ar: 'ض', name: 'Dhod' },
  { ar: 'ط', name: 'Tho' }, { ar: 'ظ', name: 'Zho' }, { ar: 'ع', name: 'Ain' },
  { ar: 'غ', name: 'Ghoin' }, { ar: 'ف', name: 'Fa' }, { ar: 'ق', name: 'Qof' },
  { ar: 'ك', name: 'Kaf' }, { ar: 'ل', name: 'Lam' }, { ar: 'م', name: 'Mim' },
  { ar: 'ن', name: 'Nun' }, { ar: 'و', name: 'Wawu' }, { ar: 'ه', name: 'Ha\'' },
  { ar: 'ء', name: 'Hamzah' }, { ar: 'ي', name: 'Ya' },
];

const JILID = [
  { id: 1, title: 'Jilid 1', subtitle: 'Mengenal Huruf Hijaiyah', pages: 44, progress: 0.85, color: '#1B7F5A', desc: 'Pengenalan huruf berharakat fathah' },
  { id: 2, title: 'Jilid 2', subtitle: 'Huruf Bersambung & Mad', pages: 44, progress: 0.62, color: '#0F5132', desc: 'Huruf bersambung dan bacaan panjang' },
  { id: 3, title: 'Jilid 3', subtitle: 'Kasrah, Dhammah & Tanwin', pages: 44, progress: 0.30, color: '#D4AF37', desc: 'Mengenal harakat lainnya' },
  { id: 4, title: 'Jilid 4', subtitle: 'Bacaan Sukun & Tasydid', pages: 44, progress: 0.05, color: '#B8860B', desc: 'Huruf mati dan bertasydid' },
  { id: 5, title: 'Jilid 5', subtitle: 'Tajwid Dasar', pages: 44, progress: 0, color: '#264653', desc: 'Hukum bacaan tajwid' },
  { id: 6, title: 'Jilid 6', subtitle: 'Bacaan Gharib', pages: 44, progress: 0, color: '#5C2C0E', desc: 'Bacaan-bacaan musykilat' },
];

// Sample practice page content (rows of huruf with harakat)
const PRACTICE_ROWS = [
  ['اَ', 'بَ'],
  ['اَ', 'بَ', 'بَ', 'اَ', 'بَ', 'اَ'],
  ['اَ', 'بَ', 'اَ', 'بَ', 'اَ'],
  ['ااا', 'بَ', 'بَ', 'بَ'],
  ['اَبَ', 'اَبَ'],
  ['اَبَ', 'بَاَبَ'],
];

// Letters for "kenal huruf" sequence
const HURUF_LESSONS = [
  { ar: 'اَ', latin: 'A', desc: 'Dibaca "A" dengan mulut terbuka' },
  { ar: 'بَ', latin: 'BA', desc: 'Dibaca "BA" dengan bibir tertutup ringan' },
  { ar: 'تَ', latin: 'TA', desc: 'Dibaca "TA" dengan ujung lidah ke gigi atas' },
  { ar: 'ثَ', latin: 'TSA', desc: 'Dibaca "TSA" dengan ujung lidah keluar sedikit' },
  { ar: 'جَ', latin: 'JA', desc: 'Dibaca "JA" dengan tengah lidah' },
  { ar: 'حَ', latin: 'HA', desc: 'Dibaca "HA" dari tenggorokan tengah' },
];

const EVALUASI_LEVELS = [
  { id: 1, title: 'Level 1', subtitle: 'Huruf Tunggal', stars: 3, locked: false, color: '#1B7F5A' },
  { id: 2, title: 'Level 2', subtitle: 'Huruf Berharakat', stars: 3, locked: false, color: '#1B7F5A' },
  { id: 3, title: 'Level 3', subtitle: 'Huruf Bersambung', stars: 2, locked: false, color: '#D4AF37' },
  { id: 4, title: 'Level 4', subtitle: 'Bacaan Mad', stars: 1, locked: false, color: '#D4AF37' },
  { id: 5, title: 'Level 5', subtitle: 'Tanwin', stars: 0, locked: false, color: '#B8860B' },
  { id: 6, title: 'Level 6', subtitle: 'Sukun', stars: 0, locked: true, color: '#888' },
  { id: 7, title: 'Level 7', subtitle: 'Tasydid', stars: 0, locked: true, color: '#888' },
  { id: 8, title: 'Level 8', subtitle: 'Tajwid', stars: 0, locked: true, color: '#888' },
];

Object.assign(window, { HIJAIYAH, JILID, PRACTICE_ROWS, HURUF_LESSONS, EVALUASI_LEVELS });
