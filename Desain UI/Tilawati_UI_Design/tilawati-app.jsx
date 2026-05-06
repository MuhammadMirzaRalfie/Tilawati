// Main app — routing, theming, tweaks, design canvas

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "themeName": "classic",
  "userName": "Aisyah",
  "showAllScreens": false,
  "arabicFont": "Amiri Quran",
  "primaryColor": "#0F5132",
  "accentColor": "#D4AF37",
  "highContrast": false
}/*EDITMODE-END*/;

const SCREEN_INFO = [
  { id: 'home', label: '01 Home' },
  { id: 'jilid-list', label: '02 Pilih Jilid' },
  { id: 'jilid-detail', label: '03 Pilih Halaman' },
  { id: 'huruf', label: '04 Mengenal Huruf' },
  { id: 'latihan', label: '05 Latihan Membaca' },
  { id: 'evaluasi-list', label: '06 Pilih Level' },
  { id: 'evaluasi-do', label: '07 Mengerjakan Evaluasi' },
  { id: 'evaluasi-result', label: '08 Hasil Evaluasi' },
  { id: 'glosarium', label: '09 Glosarium' },
  { id: 'pengaturan', label: '10 Pengaturan' },
];

function buildTheme(name, primaryOverride, accentOverride, highContrast) {
  const base = TILAWATI_THEME[name] || TILAWATI_THEME.classic;
  const t = { ...base };
  if (primaryOverride) t.primary = primaryOverride;
  if (accentOverride) t.accent = accentOverride;
  if (highContrast) {
    t.muted = '#5a5a5a';
    t.ink = '#000';
  }
  return t;
}

function App() {
  const [tweaks, setTweak] = useTweaks(TWEAK_DEFAULTS);
  const theme = buildTheme(tweaks.themeName, tweaks.primaryColor, tweaks.accentColor, tweaks.highContrast);
  const [route, setRoute] = React.useState({ name: 'home', params: {} });
  const [user, setUser] = React.useState({ name: tweaks.userName, streak: 5, xp: 1240, gems: 18 });
  const [history, setHistory] = React.useState([]);

  React.useEffect(() => { setUser(u => ({ ...u, name: tweaks.userName })); }, [tweaks.userName]);

  const navigate = (name, params = {}) => {
    setHistory(h => [...h, route]);
    setRoute({ name, params });
  };

  const renderScreen = (routeOverride) => {
    const r = routeOverride || route;
    const props = { theme, navigate, user, setUser, ...(r.params || {}) };
    switch (r.name) {
      case 'home': return <HomeScreen {...props}/>;
      case 'jilid-list': return <JilidListScreen {...props}/>;
      case 'jilid-detail': return <JilidDetailScreen {...props} jilidId={r.params?.jilid || 1}/>;
      case 'huruf': return <HurufScreen {...props} jilidId={r.params?.jilid || 1} page={r.params?.page || 1}/>;
      case 'latihan': return <LatihanScreen {...props} jilidId={r.params?.jilid || 1} page={r.params?.page || 1}/>;
      case 'evaluasi-list': return <EvaluasiListScreen {...props}/>;
      case 'evaluasi-do': return <EvaluasiDoScreen {...props} levelId={r.params?.level || 1}/>;
      case 'evaluasi-result': return <EvaluasiResultScreen {...props}/>;
      case 'glosarium': return <GlosariumScreen {...props}/>;
      case 'pengaturan': return <PengaturanScreen {...props}/>;
      default: return <HomeScreen {...props}/>;
    }
  };

  // Multi-screen canvas mode: shows all screens in a grid
  if (tweaks.showAllScreens) {
    return (
      <div style={{ width: '100%', maxWidth: 1700, margin: '0 auto' }}>
        <div style={{ textAlign: 'center', marginBottom: 24 }}>
          <div style={{ fontSize: 13, fontWeight: 700, letterSpacing: 2, color: theme.primary, textTransform: 'uppercase' }}>Tilawati</div>
          <div style={{ fontSize: 32, fontWeight: 800, color: theme.ink, marginTop: 4, letterSpacing: -0.5 }}>UI Walkthrough — Semua Layar</div>
          <div style={{ fontSize: 14, color: theme.muted, marginTop: 4 }}>Aplikasi belajar mengaji untuk anak · Metode Tilawati</div>
        </div>
        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(280px, 320px))',
          gap: 32, justifyContent: 'center',
        }}>
          {SCREEN_INFO.map(s => {
            // Customize params for screens that need them
            const params = s.id === 'jilid-detail' ? { jilid: 1 }
              : s.id === 'huruf' ? { jilid: 1, page: 1 }
              : s.id === 'latihan' ? { jilid: 1, page: 1 }
              : s.id === 'evaluasi-do' ? { level: 2 } : {};
            return (
              <div key={s.id} data-screen-label={s.label} style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 10 }}>
                <div style={{ fontSize: 12, fontWeight: 700, color: theme.muted, letterSpacing: 1.5, textTransform: 'uppercase' }}>{s.label}</div>
                <div style={{ transform: 'scale(0.78)', transformOrigin: 'top center', marginBottom: -180 }}>
                  <IOSDevice width={402} height={874}>
                    <ScreenWithoutFrame route={{ name: s.id, params }} theme={theme} user={user} setUser={setUser} navigate={() => {}} />
                  </IOSDevice>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    );
  }

  // Single-device mode
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 28, flexWrap: 'wrap', justifyContent: 'center' }}>
      <div data-screen-label={SCREEN_INFO.find(s => s.id === route.name)?.label || route.name}>
        <IOSDevice width={402} height={874}>
          {renderScreen()}
        </IOSDevice>
      </div>

      {/* Side mini-nav (lets user jump to any screen for prototyping) */}
      <div style={{
        background: 'rgba(255,255,255,0.7)', backdropFilter: 'blur(12px)',
        border: '1px solid rgba(0,0,0,0.06)',
        borderRadius: 22, padding: 14,
        width: 240,
        boxShadow: '0 8px 30px rgba(0,0,0,0.08)',
      }}>
        <div style={{ fontSize: 11, fontWeight: 800, color: theme.primary, letterSpacing: 1.5, textTransform: 'uppercase' }}>Layar</div>
        <div style={{ fontSize: 17, fontWeight: 800, color: theme.ink, marginTop: 2, marginBottom: 10 }}>Navigasi Cepat</div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 4 }}>
          {SCREEN_INFO.map(s => {
            const active = route.name === s.id;
            return (
              <button key={s.id} onClick={() => navigate(s.id, s.id === 'jilid-detail' ? { jilid: 1 } : s.id === 'huruf' ? { jilid: 1, page: 1 } : s.id === 'latihan' ? { jilid: 1, page: 1 } : s.id === 'evaluasi-do' ? { level: 2 } : {})}
                style={{
                  textAlign: 'left', padding: '8px 10px', borderRadius: 10,
                  border: 'none', cursor: 'pointer', fontFamily: 'inherit',
                  background: active ? theme.primary : 'transparent',
                  color: active ? '#fff' : theme.ink,
                  fontSize: 13, fontWeight: active ? 700 : 500,
                  transition: 'all 0.15s',
                }}>{s.label}</button>
            );
          })}
        </div>
      </div>

      {/* Tweaks panel */}
      <TweaksPanel title="Tweaks">
        <TweakSection title="Tema">
          <TweakRadio label="Skema warna"
            options={[
              { label: 'Klasik', value: 'classic' },
              { label: 'Playful', value: 'playful' },
              { label: 'Tenang', value: 'serene' },
            ]}
            value={tweaks.themeName}
            onChange={v => { setTweak('themeName', v); setTweak('primaryColor', TILAWATI_THEME[v].primary); setTweak('accentColor', TILAWATI_THEME[v].accent); }}
          />
          <TweakColor label="Warna utama" value={tweaks.primaryColor} onChange={v => setTweak('primaryColor', v)}/>
          <TweakColor label="Warna aksen" value={tweaks.accentColor} onChange={v => setTweak('accentColor', v)}/>
          <TweakToggle label="Kontras tinggi" value={tweaks.highContrast} onChange={v => setTweak('highContrast', v)}/>
        </TweakSection>
        <TweakSection title="Tipografi">
          <TweakSelect label="Font Arab" value={tweaks.arabicFont}
            options={['Amiri Quran', 'Amiri', 'Reem Kufi']}
            onChange={v => {
              setTweak('arabicFont', v);
              document.documentElement.style.setProperty('--arabic-font', v);
              document.querySelectorAll('.arabic').forEach(el => el.style.fontFamily = `${v}, serif`);
            }}/>
        </TweakSection>
        <TweakSection title="Profil">
          <TweakText label="Nama santri" value={tweaks.userName} onChange={v => setTweak('userName', v)}/>
        </TweakSection>
        <TweakSection title="Tampilan">
          <TweakToggle label="Lihat semua layar" value={tweaks.showAllScreens} onChange={v => setTweak('showAllScreens', v)}/>
        </TweakSection>
      </TweaksPanel>
    </div>
  );
}

// Stateless screen renderer for the canvas mode (so each device shows its own screen)
function ScreenWithoutFrame({ route, theme, user, setUser, navigate }) {
  const props = { theme, navigate, user, setUser, ...(route.params || {}) };
  switch (route.name) {
    case 'home': return <HomeScreen {...props}/>;
    case 'jilid-list': return <JilidListScreen {...props}/>;
    case 'jilid-detail': return <JilidDetailScreen {...props} jilidId={route.params?.jilid || 1}/>;
    case 'huruf': return <HurufScreen {...props} jilidId={route.params?.jilid || 1} page={route.params?.page || 1}/>;
    case 'latihan': return <LatihanScreen {...props} jilidId={route.params?.jilid || 1} page={route.params?.page || 1}/>;
    case 'evaluasi-list': return <EvaluasiListScreen {...props}/>;
    case 'evaluasi-do': return <EvaluasiDoScreen {...props} levelId={route.params?.level || 1}/>;
    case 'evaluasi-result': return <EvaluasiResultScreen {...props}/>;
    case 'glosarium': return <GlosariumScreen {...props}/>;
    case 'pengaturan': return <PengaturanScreen {...props}/>;
    default: return <HomeScreen {...props}/>;
  }
}

const root = ReactDOM.createRoot(document.getElementById('stage'));
root.render(<App/>);
