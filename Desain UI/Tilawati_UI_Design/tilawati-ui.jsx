// UI primitives — buttons, icons, decorative elements

// Theme tokens (overridable via Tweaks)
const TILAWATI_THEME = {
  classic: {
    bg: '#FAF6EA',
    bg2: '#F2EAD3',
    surface: '#FFFFFF',
    ink: '#1A1A1A',
    primary: '#0F5132',     // hijau zaitun
    primaryLight: '#1B7F5A',
    primaryDark: '#08381F',
    accent: '#D4AF37',      // gold
    accentLight: '#E9C46A',
    cream: '#F5EFE0',
    danger: '#C44536',
    muted: '#8A8472',
  },
  playful: {
    bg: '#FFF8EC',
    bg2: '#FFE9C2',
    surface: '#FFFFFF',
    ink: '#2D1810',
    primary: '#FF8C42',
    primaryLight: '#FFB36B',
    primaryDark: '#E0631A',
    accent: '#7B5CD6',
    accentLight: '#A88AE8',
    cream: '#FFF2DC',
    danger: '#E63946',
    muted: '#9A8472',
  },
  serene: {
    bg: '#F4F1EC',
    bg2: '#E8E2D7',
    surface: '#FFFFFF',
    ink: '#1A1A1A',
    primary: '#264653',
    primaryLight: '#3F6273',
    primaryDark: '#15303A',
    accent: '#E07856',
    accentLight: '#F4A582',
    cream: '#F0EBE0',
    danger: '#C44536',
    muted: '#8A8472',
  },
};

// ──────────────────────────────────────────────
// Icons (inline svg, sized + colored via props)
// ──────────────────────────────────────────────
const Icon = ({ name, size = 24, color = 'currentColor', stroke = 2 }) => {
  const props = { width: size, height: size, viewBox: '0 0 24 24', fill: 'none', stroke: color, strokeWidth: stroke, strokeLinecap: 'round', strokeLinejoin: 'round' };
  switch (name) {
    case 'book': return <svg {...props}><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></svg>;
    case 'star': return <svg {...props} fill={color}><polygon points="12,2 15,9 22,9 17,14 19,21 12,17 5,21 7,14 2,9 9,9"/></svg>;
    case 'star-outline': return <svg {...props}><polygon points="12,2 15,9 22,9 17,14 19,21 12,17 5,21 7,14 2,9 9,9"/></svg>;
    case 'play': return <svg {...props} fill={color} stroke="none"><polygon points="6,4 20,12 6,20"/></svg>;
    case 'pause': return <svg {...props} fill={color} stroke="none"><rect x="6" y="4" width="4" height="16" rx="1"/><rect x="14" y="4" width="4" height="16" rx="1"/></svg>;
    case 'mic': return <svg {...props}><rect x="9" y="2" width="6" height="13" rx="3"/><path d="M5 11a7 7 0 0 0 14 0M12 18v3"/></svg>;
    case 'home': return <svg {...props}><path d="M3 12L12 4l9 8M5 10v10h5v-6h4v6h5V10"/></svg>;
    case 'settings': return <svg {...props}><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></svg>;
    case 'glossary': return <svg {...props}><path d="M2 6h7a4 4 0 0 1 4 4v11M22 6h-7a4 4 0 0 0-4 4v11"/><path d="M2 6v15h7a4 4 0 0 1 4 0 4 4 0 0 1 4 0h7V6"/></svg>;
    case 'practice': return <svg {...props}><path d="M14 2l-2 5h6l-3 7"/><circle cx="11" cy="17" r="4"/><path d="M11 13v-3"/></svg>;
    case 'evaluation': return <svg {...props}><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>;
    case 'fire': return <svg {...props} fill={color} stroke="none"><path d="M12 2c1 3 3 4 3 7a3 3 0 1 1-6 0c0-1 .5-2 1-3-2 2-4 4-4 8a6 6 0 0 0 12 0c0-5-3-9-6-12z"/></svg>;
    case 'check': return <svg {...props}><polyline points="4,12 10,18 20,6"/></svg>;
    case 'lock': return <svg {...props}><rect x="4" y="11" width="16" height="11" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/></svg>;
    case 'arrow-left': return <svg {...props}><path d="M19 12H5M12 19l-7-7 7-7"/></svg>;
    case 'arrow-right': return <svg {...props}><path d="M5 12h14M12 5l7 7-7 7"/></svg>;
    case 'crown': return <svg {...props} fill={color} stroke="none"><path d="M3 6l4 4 5-7 5 7 4-4-2 13H5z"/></svg>;
    case 'sparkle': return <svg {...props} fill={color} stroke="none"><path d="M12 2l1.5 6.5L20 10l-6.5 1.5L12 18l-1.5-6.5L4 10l6.5-1.5z"/></svg>;
    case 'volume': return <svg {...props}><polygon points="11,5 6,9 2,9 2,15 6,15 11,19" fill={color} stroke="none"/><path d="M15 9a4 4 0 0 1 0 6M18 6a8 8 0 0 1 0 12"/></svg>;
    case 'replay': return <svg {...props}><path d="M3 12a9 9 0 1 0 3-6.7L3 8M3 3v5h5"/></svg>;
    case 'close': return <svg {...props}><path d="M6 6l12 12M18 6L6 18"/></svg>;
    case 'gem': return <svg {...props} fill={color} stroke="none"><path d="M6 3h12l4 6-10 12L2 9z" opacity="0.95"/><path d="M6 3l-4 6h20L18 3M11 9l1 12 1-12" stroke="rgba(255,255,255,0.4)" strokeWidth="0.8" fill="none"/></svg>;
    case 'pen': return <svg {...props}><path d="M12 19l7-7 3 3-7 7-3-3zM18 13l-1.5-7.5L2 2l3.5 14.5L13 18l5-5zM2 2l7.586 7.586M11 11a2 2 0 1 0 0-4 2 2 0 0 0 0 4z"/></svg>;
    case 'trophy': return <svg {...props} fill={color} stroke="none"><path d="M7 4h10v6a5 5 0 0 1-10 0V4zM5 4H2v3a4 4 0 0 0 4 4M19 4h3v3a4 4 0 0 1-4 4M9 17h6v3H9z"/></svg>;
    default: return null;
  }
};

// ──────────────────────────────────────────────
// Decorative arabesque corner (ornamental SVG)
// ──────────────────────────────────────────────
const ArabesqueCorner = ({ size = 80, color = '#0F5132', opacity = 0.15, style = {} }) => (
  <svg width={size} height={size} viewBox="0 0 100 100" style={{ opacity, ...style }}>
    <g fill="none" stroke={color} strokeWidth="1.2">
      <circle cx="50" cy="50" r="30"/>
      <circle cx="50" cy="50" r="22"/>
      <path d="M50 20 L55 50 L50 80 L45 50 Z M20 50 L50 45 L80 50 L50 55 Z"/>
      <path d="M30 30 L70 70 M70 30 L30 70" strokeOpacity="0.5"/>
      <circle cx="50" cy="50" r="6" fill={color} fillOpacity="0.3"/>
    </g>
  </svg>
);

// 8-point star (islamic geometric)
const IslamicStar = ({ size = 40, color = '#D4AF37', style = {}, filled = true }) => (
  <svg width={size} height={size} viewBox="0 0 100 100" style={style}>
    <g fill={filled ? color : 'none'} stroke={color} strokeWidth="2">
      <path d="M50 5 L61 28 L86 22 L80 47 L97 67 L72 72 L66 96 L50 78 L34 96 L28 72 L3 67 L20 47 L14 22 L39 28 Z" />
    </g>
  </svg>
);

// Squiggly arabesque divider
const Divider = ({ color = '#D4AF37', width = 200 }) => (
  <svg width={width} height="14" viewBox="0 0 200 14" style={{ display: 'block' }}>
    <path d="M0 7 Q 25 0, 50 7 T 100 7 T 150 7 T 200 7" fill="none" stroke={color} strokeWidth="1.2" strokeLinecap="round"/>
    <circle cx="100" cy="7" r="2.5" fill={color}/>
    <circle cx="20" cy="7" r="1.5" fill={color} opacity="0.5"/>
    <circle cx="180" cy="7" r="1.5" fill={color} opacity="0.5"/>
  </svg>
);

// ──────────────────────────────────────────────
// Buttons
// ──────────────────────────────────────────────
const PrimaryButton = ({ children, onClick, theme, full, style = {} }) => (
  <button
    onClick={onClick}
    style={{
      background: theme.primary,
      color: '#fff',
      border: 'none',
      borderRadius: 18,
      padding: '14px 24px',
      fontSize: 17,
      fontWeight: 700,
      fontFamily: 'inherit',
      cursor: 'pointer',
      boxShadow: `0 4px 0 ${theme.primaryDark}, 0 6px 16px rgba(15,81,50,0.25)`,
      transition: 'all 0.1s',
      width: full ? '100%' : 'auto',
      letterSpacing: 0.2,
      ...style,
    }}
    onMouseDown={e => { e.currentTarget.style.transform = 'translateY(2px)'; e.currentTarget.style.boxShadow = `0 2px 0 ${theme.primaryDark}, 0 3px 8px rgba(15,81,50,0.2)`; }}
    onMouseUp={e => { e.currentTarget.style.transform = ''; e.currentTarget.style.boxShadow = `0 4px 0 ${theme.primaryDark}, 0 6px 16px rgba(15,81,50,0.25)`; }}
    onMouseLeave={e => { e.currentTarget.style.transform = ''; e.currentTarget.style.boxShadow = `0 4px 0 ${theme.primaryDark}, 0 6px 16px rgba(15,81,50,0.25)`; }}
  >{children}</button>
);

const GhostButton = ({ children, onClick, theme, style = {} }) => (
  <button
    onClick={onClick}
    style={{
      background: 'transparent',
      color: theme.primary,
      border: `2px solid ${theme.primary}33`,
      borderRadius: 18,
      padding: '12px 20px',
      fontSize: 15,
      fontWeight: 600,
      fontFamily: 'inherit',
      cursor: 'pointer',
      ...style,
    }}
  >{children}</button>
);

// Round icon button
const RoundButton = ({ icon, onClick, color = '#0F5132', size = 56, glow, style = {} }) => (
  <button
    onClick={onClick}
    style={{
      width: size, height: size,
      borderRadius: '50%',
      background: color,
      border: 'none',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      cursor: 'pointer',
      color: '#fff',
      boxShadow: glow ? `0 8px 24px ${color}66, 0 4px 0 rgba(0,0,0,0.15)` : `0 4px 0 rgba(0,0,0,0.15), 0 6px 16px rgba(0,0,0,0.1)`,
      position: 'relative',
      ...style,
    }}
  >
    <Icon name={icon} size={size * 0.4} color="#fff" stroke={2.5}/>
  </button>
);

// Top app bar inside iOS frame
const TopBar = ({ title, onBack, theme, right }) => (
  <div style={{
    display: 'flex', alignItems: 'center', justifyContent: 'space-between',
    padding: '64px 16px 12px',
    minHeight: 56,
  }}>
    <button onClick={onBack} style={{
      width: 40, height: 40, borderRadius: 12,
      background: '#fff',
      border: 'none', cursor: 'pointer',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      boxShadow: '0 2px 0 rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.05)',
    }}>
      <Icon name="arrow-left" size={20} color={theme.ink}/>
    </button>
    <div style={{ fontSize: 17, fontWeight: 700, color: theme.ink, letterSpacing: 0.2 }}>{title}</div>
    <div style={{ width: 40, height: 40 }}>{right}</div>
  </div>
);

// Streak/XP pill
const StatPill = ({ icon, value, color, bg }) => (
  <div style={{
    display: 'inline-flex', alignItems: 'center', gap: 6,
    background: bg, color,
    padding: '6px 12px 6px 8px', borderRadius: 999,
    fontSize: 14, fontWeight: 800,
    boxShadow: `0 2px 0 ${color}33`,
  }}>
    <Icon name={icon} size={16} color={color}/>
    {value}
  </div>
);

// Progress bar (Duolingo-style)
const ProgressBar = ({ value, color = '#1B7F5A', bg = '#EAE2CE', height = 12 }) => (
  <div style={{
    height, borderRadius: height, background: bg,
    overflow: 'hidden', position: 'relative',
    boxShadow: 'inset 0 1px 2px rgba(0,0,0,0.08)',
  }}>
    <div style={{
      width: `${Math.max(0, Math.min(1, value)) * 100}%`,
      height: '100%', background: color,
      borderRadius: height,
      position: 'relative',
      boxShadow: `inset 0 -3px 0 rgba(0,0,0,0.1), inset 0 3px 0 rgba(255,255,255,0.25)`,
      transition: 'width 0.4s cubic-bezier(.2,.7,.3,1)',
    }}>
    </div>
  </div>
);

// Confetti
const Confetti = ({ count = 24 }) => (
  <div style={{ position: 'absolute', inset: 0, pointerEvents: 'none', overflow: 'hidden' }}>
    {Array.from({ length: count }).map((_, i) => {
      const colors = ['#D4AF37', '#1B7F5A', '#E9C46A', '#FF8C42', '#7B5CD6'];
      const c = colors[i % colors.length];
      const left = (i * 13 + 7) % 100;
      const delay = (i % 8) * 0.08;
      const dur = 2 + (i % 5) * 0.3;
      return (
        <div key={i} style={{
          position: 'absolute', top: 0, left: `${left}%`,
          width: 8, height: 12, background: c,
          borderRadius: 2,
          animation: `confetti-fall ${dur}s ${delay}s ease-in forwards`,
        }}/>
      );
    })}
  </div>
);

Object.assign(window, {
  TILAWATI_THEME, Icon, ArabesqueCorner, IslamicStar, Divider,
  PrimaryButton, GhostButton, RoundButton, TopBar, StatPill, ProgressBar, Confetti,
});
