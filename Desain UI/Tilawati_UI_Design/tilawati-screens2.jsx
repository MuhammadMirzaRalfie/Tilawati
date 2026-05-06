// More screens — Latihan, Evaluasi, Glosarium, Pengaturan

// ─────────────────────────────────────────────────────
// LATIHAN MEMBACA — karaoke highlight + mic recording
// ─────────────────────────────────────────────────────
const LatihanScreen = ({ theme, navigate, jilidId, page }) => {
  const [activeRow, setActiveRow] = React.useState(null);
  const [activeCol, setActiveCol] = React.useState(null);
  const [recording, setRecording] = React.useState(false);
  const [playingAll, setPlayingAll] = React.useState(false);
  const playRef = React.useRef(null);

  // Karaoke playback - sequentially highlight each huruf
  const playAll = () => {
    if (playingAll) {
      clearTimeout(playRef.current);
      setPlayingAll(false);
      setActiveRow(null);
      setActiveCol(null);
      return;
    }
    setPlayingAll(true);
    let r = 0, c = 0;
    const tick = () => {
      if (r >= PRACTICE_ROWS.length) {
        setPlayingAll(false);
        setActiveRow(null);
        setActiveCol(null);
        return;
      }
      setActiveRow(r);
      setActiveCol(c);
      c++;
      if (c >= PRACTICE_ROWS[r].length) { r++; c = 0; }
      playRef.current = setTimeout(tick, 550);
    };
    tick();
  };
  React.useEffect(() => () => clearTimeout(playRef.current), []);

  return (
    <div style={{ background: theme.bg, minHeight: '100%', display: 'flex', flexDirection: 'column' }}>
      <TopBar title={`Latihan · Hal. ${page || 1}`} onBack={() => navigate('huruf', { jilid: jilidId, page })} theme={theme}
        right={<div onClick={() => navigate('glosarium')} style={{ width: 40, height: 40, borderRadius: 12, background: '#fff', display:'flex', alignItems:'center', justifyContent:'center', cursor:'pointer', boxShadow: '0 2px 0 rgba(0,0,0,0.06)' }}>
          <Icon name="book" size={18} color={theme.ink}/>
        </div>}/>

      {/* Title row — first one is the example */}
      <div style={{ padding: '0 24px 12px', textAlign: 'center', position: 'relative' }}>
        <div className="arabic" style={{ fontSize: 60, color: theme.primary, lineHeight: 1.4 }}>
          {PRACTICE_ROWS[0].map((h, i) => (
            <span key={i} style={{ margin: '0 12px' }}>{h}</span>
          ))}
        </div>
        <div style={{ display: 'flex', justifyContent: 'center', marginTop: 4 }}>
          <Divider color={theme.accent} width={120}/>
        </div>
      </div>

      {/* Practice rows */}
      <div style={{ flex: 1, padding: '0 16px', overflow: 'auto' }}>
        {PRACTICE_ROWS.slice(1).map((row, ri) => {
          const realRi = ri + 1;
          return (
            <div key={ri} style={{
              display: 'flex', flexDirection: 'row-reverse',
              justifyContent: 'space-around', alignItems: 'center',
              padding: '14px 8px',
              borderBottom: ri < PRACTICE_ROWS.length - 2 ? `1px solid ${theme.bg2}` : 'none',
              background: activeRow === realRi ? `${theme.accent}15` : 'transparent',
              borderRadius: 12,
              transition: 'background 0.2s',
            }}>
              {row.map((h, ci) => {
                const isActive = activeRow === realRi && activeCol === ci;
                return (
                  <span key={ci} className="arabic"
                    onClick={() => { setActiveRow(realRi); setActiveCol(ci); setTimeout(()=>{setActiveRow(null);setActiveCol(null)},500); }}
                    style={{
                      fontSize: 38,
                      color: isActive ? theme.primary : theme.ink,
                      fontWeight: isActive ? 700 : 400,
                      cursor: 'pointer',
                      transform: isActive ? 'scale(1.2)' : 'scale(1)',
                      transition: 'all 0.2s cubic-bezier(.2,1.4,.3,1)',
                      textShadow: isActive ? `0 4px 12px ${theme.primary}55` : 'none',
                      display: 'inline-block',
                    }}>{h}</span>
                );
              })}
            </div>
          );
        })}
      </div>

      {/* Bottom control bar */}
      <div style={{
        padding: '12px 16px 24px',
        background: '#fff',
        borderTopLeftRadius: 28, borderTopRightRadius: 28,
        boxShadow: '0 -6px 20px rgba(0,0,0,0.05)',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: 8,
      }}>
        <button onClick={() => navigate('huruf', { jilid: jilidId, page: Math.max(1, (page||1) - 1) })} style={btnSec(theme)}>
          <Icon name="arrow-left" size={20} color={theme.ink}/>
        </button>

        <button onClick={playAll} style={{ ...btnSec(theme), background: playingAll ? theme.accent : '#fff', color: playingAll ? '#fff' : theme.ink }}>
          <Icon name={playingAll ? 'pause' : 'play'} size={20} color={playingAll ? '#fff' : theme.ink}/>
        </button>

        {/* Big mic button */}
        <button onClick={() => setRecording(!recording)} style={{
          flex: 1, height: 64, borderRadius: 22,
          background: recording ? theme.danger : theme.primary,
          color: '#fff', border: 'none', cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 12,
          fontFamily: 'inherit', fontSize: 15, fontWeight: 800,
          boxShadow: recording ? `0 4px 0 #8B2A20, 0 0 0 4px ${theme.danger}33` : `0 4px 0 ${theme.primaryDark}, 0 6px 16px ${theme.primary}55`,
          position: 'relative', overflow: 'hidden',
        }}>
          {recording ? (
            <>
              <Waveform color="#fff"/>
              <span>Mendengarkan...</span>
            </>
          ) : (
            <>
              <Icon name="mic" size={22} color="#fff"/>
              <span>Tekan untuk Membaca</span>
            </>
          )}
        </button>

        <button onClick={() => { setRecording(false); navigate('evaluasi-result'); }} style={btnSec(theme)}>
          <Icon name="arrow-right" size={20} color={theme.ink}/>
        </button>
      </div>
    </div>
  );
};

const btnSec = (theme) => ({
  width: 52, height: 52, borderRadius: 16,
  background: '#fff', border: `1px solid ${theme.bg2}`, cursor: 'pointer',
  display: 'flex', alignItems: 'center', justifyContent: 'center',
  boxShadow: '0 2px 0 rgba(0,0,0,0.04)',
});

// Mic waveform animation
const Waveform = ({ color = '#fff', bars = 5 }) => (
  <div style={{ display: 'flex', alignItems: 'center', gap: 3, height: 24 }}>
    {Array.from({ length: bars }).map((_, i) => (
      <div key={i} style={{
        width: 3, height: 20, borderRadius: 2, background: color,
        transformOrigin: 'center',
        animation: `wave 0.7s ${i * 0.08}s ease-in-out infinite`,
      }}/>
    ))}
  </div>
);

// ─────────────────────────────────────────────────────
// EVALUASI — Level select grid (Duolingo-style path)
// ─────────────────────────────────────────────────────
const EvaluasiListScreen = ({ theme, navigate }) => {
  return (
    <div style={{ background: theme.bg, minHeight: '100%', paddingBottom: 80, position: 'relative' }}>
      <TopBar title="Evaluasi" onBack={() => navigate('home')} theme={theme}/>
      <div style={{ padding: '0 20px 16px' }}>
        <div style={{
          background: `linear-gradient(135deg, ${theme.accent} 0%, ${theme.accentLight} 100%)`,
          borderRadius: 22, padding: 16, color: '#fff', position: 'relative', overflow: 'hidden',
          boxShadow: `0 6px 0 #B8860B, 0 10px 24px rgba(212,175,55,0.4)`,
        }}>
          <ArabesqueCorner size={120} color="#fff" opacity={0.15} style={{ position: 'absolute', top: -20, right: -20 }}/>
          <Icon name="trophy" size={28} color="#fff"/>
          <div style={{ fontSize: 18, fontWeight: 800, marginTop: 4 }}>Uji kemampuan bacaanmu</div>
          <div style={{ fontSize: 12, opacity: 0.95, marginTop: 2 }}>Selesaikan setiap level untuk mendapat bintang</div>
        </div>
      </div>
      {/* Path */}
      <div style={{ padding: '8px 20px', position: 'relative' }}>
        {EVALUASI_LEVELS.map((lv, i) => {
          const align = i % 2 === 0 ? 'flex-start' : 'flex-end';
          return (
            <div key={lv.id} style={{ display: 'flex', justifyContent: align, padding: '6px 0', position: 'relative' }}>
              <button disabled={lv.locked} onClick={() => !lv.locked && navigate('evaluasi-do', { level: lv.id })} style={{
                width: 92, height: 92, borderRadius: '50%',
                background: lv.locked ? theme.bg2 : `linear-gradient(135deg, ${lv.color} 0%, ${lv.color}cc 100%)`,
                border: 'none', cursor: lv.locked ? 'not-allowed' : 'pointer',
                color: '#fff', fontFamily: 'inherit',
                display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
                boxShadow: lv.locked ? 'none' : `0 6px 0 ${lv.color}77, 0 10px 20px ${lv.color}33`,
                position: 'relative',
              }}>
                {lv.locked ? <Icon name="lock" size={26} color={theme.muted}/> : (
                  <>
                    <div style={{ fontSize: 22, fontWeight: 800 }}>{lv.id}</div>
                    <div style={{ display: 'flex', gap: 1, marginTop: 2 }}>
                      {[0,1,2].map(s => (
                        <Icon key={s} name="star" size={10} color={s < lv.stars ? '#FFD25F' : 'rgba(255,255,255,0.3)'}/>
                      ))}
                    </div>
                  </>
                )}
              </button>
              <div style={{
                position: 'absolute',
                [align === 'flex-start' ? 'left' : 'right']: 110,
                top: 28,
                fontSize: 13, fontWeight: 700, color: theme.ink,
                textAlign: align === 'flex-start' ? 'left' : 'right',
              }}>
                <div>{lv.title}</div>
                <div style={{ fontSize: 11, color: theme.muted, fontWeight: 500 }}>{lv.subtitle}</div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

// EVALUASI - mengerjakan
const EvaluasiDoScreen = ({ theme, navigate, levelId }) => {
  const lv = EVALUASI_LEVELS.find(x => x.id === levelId) || EVALUASI_LEVELS[0];
  const [q, setQ] = React.useState(0);
  const [recording, setRecording] = React.useState(false);
  const [selected, setSelected] = React.useState(null);
  const total = 5;
  const questions = HURUF_LESSONS.slice(0, 4);
  const correctIdx = q % 4;

  return (
    <div style={{ background: theme.bg, minHeight: '100%', display: 'flex', flexDirection: 'column' }}>
      <div style={{ padding: '64px 16px 8px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <button onClick={() => navigate('evaluasi-list')} style={{
          width: 36, height: 36, borderRadius: 12, background: '#fff', border: 'none', cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <Icon name="close" size={18} color={theme.ink}/>
        </button>
        <div style={{ flex: 1 }}>
          <ProgressBar value={(q + 1) / total} color={theme.primary} bg={theme.bg2} height={12}/>
        </div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 4, color: theme.danger, fontWeight: 800 }}>
          <Icon name="fire" size={18} color={theme.danger}/> 3
        </div>
      </div>

      <div style={{ flex: 1, padding: '20px 24px', display: 'flex', flexDirection: 'column' }}>
        <div style={{ fontSize: 12, fontWeight: 800, color: theme.muted, letterSpacing: 1, textTransform: 'uppercase' }}>Soal {q + 1} / {total}</div>
        <div style={{ fontSize: 22, fontWeight: 800, color: theme.ink, marginTop: 4 }}>Pilih bacaan yang benar</div>

        {/* Audio prompt */}
        <div onClick={() => {}} style={{
          marginTop: 20, background: '#fff', borderRadius: 22,
          padding: 24, display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 14,
          boxShadow: '0 4px 0 rgba(0,0,0,0.04)', cursor: 'pointer',
        }}>
          <RoundButton icon="volume" color={theme.primary} size={56} glow/>
          <div>
            <div style={{ fontSize: 13, color: theme.muted, fontWeight: 600 }}>Dengarkan</div>
            <div style={{ fontSize: 15, fontWeight: 800, color: theme.ink }}>Tap untuk memutar</div>
          </div>
        </div>

        {/* Options */}
        <div style={{ marginTop: 18, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          {questions.map((opt, i) => {
            const isSel = selected === i;
            const correct = selected !== null && i === correctIdx;
            const wrong = selected === i && i !== correctIdx;
            return (
              <button key={i} onClick={() => selected === null && setSelected(i)} style={{
                background: correct ? '#E0F4E5' : wrong ? '#FBE4E0' : '#fff',
                border: `2px solid ${correct ? theme.primary : wrong ? theme.danger : isSel ? theme.primary : 'transparent'}`,
                borderRadius: 18, padding: '20px 12px', cursor: 'pointer',
                fontFamily: 'inherit',
                boxShadow: '0 3px 0 rgba(0,0,0,0.04), 0 4px 10px rgba(0,0,0,0.04)',
              }}>
                <div className="arabic" style={{ fontSize: 48, lineHeight: 1, color: theme.ink }}>{opt.ar}</div>
                <div style={{ marginTop: 8, fontSize: 12, fontWeight: 700, color: theme.muted, letterSpacing: 1 }}>{opt.latin}</div>
              </button>
            );
          })}
        </div>

        <div style={{ flex: 1 }}/>

        {/* Mic / next */}
        <div style={{ display: 'flex', gap: 10, marginTop: 16 }}>
          <button onClick={() => setRecording(!recording)} style={{
            flex: 1, height: 56, borderRadius: 18,
            background: recording ? theme.danger : '#fff',
            color: recording ? '#fff' : theme.ink, border: `2px solid ${recording ? theme.danger : theme.bg2}`, cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
            fontFamily: 'inherit', fontSize: 14, fontWeight: 800,
          }}>
            {recording ? <Waveform color="#fff"/> : <Icon name="mic" size={20} color={theme.ink}/>}
            <span>{recording ? 'Rekam...' : 'Baca'}</span>
          </button>
          <button onClick={() => {
            if (q < total - 1) { setQ(q + 1); setSelected(null); }
            else navigate('evaluasi-result', { level: levelId });
          }} disabled={selected === null} style={{
            flex: 1, height: 56, borderRadius: 18,
            background: selected === null ? theme.bg2 : theme.primary,
            color: '#fff', border: 'none', cursor: selected === null ? 'not-allowed' : 'pointer',
            fontFamily: 'inherit', fontSize: 16, fontWeight: 800,
            boxShadow: selected === null ? 'none' : `0 4px 0 ${theme.primaryDark}`,
          }}>{q < total - 1 ? 'Lanjut' : 'Selesai'}</button>
        </div>
      </div>
    </div>
  );
};

// EVALUASI - hasil
const EvaluasiResultScreen = ({ theme, navigate }) => {
  const [shown, setShown] = React.useState(0);
  React.useEffect(() => {
    const timers = [
      setTimeout(() => setShown(1), 300),
      setTimeout(() => setShown(2), 700),
      setTimeout(() => setShown(3), 1100),
    ];
    return () => timers.forEach(clearTimeout);
  }, []);

  return (
    <div style={{ background: theme.bg, minHeight: '100%', position: 'relative', overflow: 'hidden' }}>
      <Confetti count={36}/>
      <div style={{ padding: '110px 24px 24px', textAlign: 'center', position: 'relative' }}>
        <div style={{ fontSize: 14, color: theme.muted, fontWeight: 700, letterSpacing: 1, textTransform: 'uppercase' }}>Selamat!</div>
        <div style={{ fontSize: 30, fontWeight: 800, color: theme.ink, marginTop: 4 }}>Masya Allah!</div>
        <div style={{ fontSize: 14, color: theme.muted, marginTop: 4 }}>Kamu menyelesaikan Level 1</div>

        {/* Stars */}
        <div style={{ display: 'flex', justifyContent: 'center', gap: 10, marginTop: 28 }}>
          {[0,1,2].map(i => (
            <div key={i} style={{
              animation: shown > i ? `star-pop 0.6s cubic-bezier(.2,1.6,.4,1) both` : 'none',
              opacity: shown > i ? 1 : 0,
            }}>
              <IslamicStar size={64} color={theme.accent}/>
            </div>
          ))}
        </div>

        {/* Stat cards */}
        <div style={{ marginTop: 32, display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
          <ResultCard theme={theme} label="Skor" value="92" icon="check" color={theme.primary} bg="#E8F2EC"/>
          <ResultCard theme={theme} label="Akurasi" value="4/5" icon="evaluation" color={theme.accent} bg="#FBF1D6"/>
          <ResultCard theme={theme} label="XP" value="+50" icon="sparkle" color="#7B5CD6" bg="#EFE9FA"/>
          <ResultCard theme={theme} label="Streak" value="3 🔥" icon="fire" color="#E07856" bg="#FCE6DC"/>
        </div>

        <div style={{ marginTop: 28, display: 'flex', gap: 10 }}>
          <GhostButton theme={theme} onClick={() => navigate('evaluasi-do')} style={{ flex: 1 }}>Ulangi</GhostButton>
          <PrimaryButton theme={theme} onClick={() => navigate('evaluasi-list')} style={{ flex: 1 }}>Lanjut</PrimaryButton>
        </div>
      </div>
    </div>
  );
};

const ResultCard = ({ label, value, icon, color, bg, theme }) => (
  <div style={{ background: '#fff', borderRadius: 18, padding: 14, textAlign: 'left', boxShadow: '0 2px 0 rgba(0,0,0,0.04)' }}>
    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
      <div style={{ width: 32, height: 32, borderRadius: 10, background: bg, display: 'flex', alignItems:'center', justifyContent:'center' }}>
        <Icon name={icon} size={16} color={color} stroke={2.4}/>
      </div>
      <div style={{ fontSize: 11, fontWeight: 700, color: theme.muted, letterSpacing: 0.5, textTransform: 'uppercase' }}>{label}</div>
    </div>
    <div style={{ fontSize: 22, fontWeight: 800, color: theme.ink, marginTop: 6 }}>{value}</div>
  </div>
);

// ─────────────────────────────────────────────────────
// GLOSARIUM Hijaiyah grid + detail modal
// ─────────────────────────────────────────────────────
const GlosariumScreen = ({ theme, navigate }) => {
  const [sel, setSel] = React.useState(null);
  return (
    <div style={{ background: theme.bg, minHeight: '100%', paddingBottom: 80 }}>
      <TopBar title="Glosarium Hijaiyah" onBack={() => navigate('home')} theme={theme}/>
      <div style={{ padding: '0 20px 14px' }}>
        <div style={{ fontSize: 13, color: theme.muted, lineHeight: 1.5 }}>29 huruf hijaiyah. Tap untuk mendengar pelafalannya.</div>
      </div>
      <div style={{ padding: '0 16px', display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8 }}>
        {HIJAIYAH.map((h, i) => (
          <button key={i} onClick={() => setSel(h)} style={{
            background: '#fff', border: 'none', borderRadius: 14,
            padding: '14px 8px 10px', cursor: 'pointer', fontFamily: 'inherit',
            boxShadow: '0 2px 0 rgba(0,0,0,0.04), 0 3px 8px rgba(0,0,0,0.04)',
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
          }}>
            <div className="arabic" style={{ fontSize: 36, lineHeight: 1, color: theme.primary }}>{h.ar}</div>
            <div style={{ fontSize: 11, fontWeight: 700, color: theme.muted }}>{h.name}</div>
          </button>
        ))}
      </div>

      {/* Detail modal */}
      {sel && (
        <div onClick={() => setSel(null)} style={{
          position: 'absolute', inset: 0, background: 'rgba(20,20,20,0.45)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          padding: 20, zIndex: 100, backdropFilter: 'blur(4px)',
          animation: 'fade-up 0.25s ease',
        }}>
          <div onClick={e => e.stopPropagation()} style={{
            background: '#fff', borderRadius: 26, padding: 24, width: '100%', maxWidth: 320,
            position: 'relative', boxShadow: '0 20px 60px rgba(0,0,0,0.3)',
            animation: 'bounce-in 0.4s cubic-bezier(.2,1.4,.4,1)',
          }}>
            <button onClick={() => setSel(null)} style={{
              position: 'absolute', top: 12, right: 12, width: 32, height: 32, borderRadius: 10,
              border: 'none', background: theme.bg, cursor: 'pointer',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
            }}>
              <Icon name="close" size={16} color={theme.ink}/>
            </button>
            <div style={{ textAlign: 'center', padding: '12px 0' }}>
              <div className="arabic" style={{ fontSize: 110, color: theme.primary, lineHeight: 1 }}>{sel.ar}</div>
              <div style={{ fontSize: 22, fontWeight: 800, color: theme.ink, marginTop: 8 }}>{sel.name}</div>
              <div style={{ fontSize: 12, color: theme.muted, marginTop: 4 }}>Huruf hijaiyah</div>
              <div style={{ display: 'flex', justifyContent: 'center', marginTop: 14 }}>
                <Divider color={theme.accent} width={120}/>
              </div>
              <div style={{ marginTop: 16, display: 'flex', gap: 8, justifyContent: 'center' }}>
                <RoundButton icon="play" color={theme.primary} size={52}/>
                <RoundButton icon="mic" color={theme.accent} size={52}/>
                <RoundButton icon="replay" color={theme.muted} size={52}/>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

// ─────────────────────────────────────────────────────
// PENGATURAN
// ─────────────────────────────────────────────────────
const PengaturanScreen = ({ theme, navigate, user, setUser }) => {
  return (
    <div style={{ background: theme.bg, minHeight: '100%', paddingBottom: 80 }}>
      <TopBar title="Pengaturan" onBack={() => navigate('home')} theme={theme}/>
      <div style={{ padding: '0 20px' }}>
        <div style={{ background: '#fff', borderRadius: 22, padding: 16, display: 'flex', gap: 14, alignItems: 'center', boxShadow: '0 2px 0 rgba(0,0,0,0.04)' }}>
          <div style={{ width: 56, height: 56, borderRadius: '50%', background: `linear-gradient(135deg, ${theme.accentLight}, ${theme.accent})`, display: 'flex', alignItems: 'center', justifyContent: 'center', color: '#fff', fontSize: 24, fontWeight: 800 }}>{user.name[0]}</div>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 17, fontWeight: 800, color: theme.ink }}>{user.name}</div>
            <div style={{ fontSize: 12, color: theme.muted }}>Santri Tilawati</div>
          </div>
          <button style={{ ...btnSec(theme), width: 40, height: 40 }}>
            <Icon name="pen" size={16} color={theme.ink}/>
          </button>
        </div>

        <SettingGroup theme={theme} title="Suara">
          <SettingRow theme={theme} label="Volume audio" right={<div style={{ fontSize: 13, color: theme.muted }}>80%</div>}/>
          <SettingRow theme={theme} label="Suara qori" right={<div style={{ fontSize: 13, color: theme.muted }}>Default</div>}/>
          <SettingRow theme={theme} label="Auto-play huruf" right={<Toggle theme={theme} on/>}/>
        </SettingGroup>
        <SettingGroup theme={theme} title="Belajar">
          <SettingRow theme={theme} label="Target harian" right={<div style={{ fontSize: 13, color: theme.muted }}>5 halaman</div>}/>
          <SettingRow theme={theme} label="Pengingat belajar" right={<Toggle theme={theme} on/>}/>
        </SettingGroup>
        <SettingGroup theme={theme} title="Tampilan">
          <SettingRow theme={theme} label="Mode gelap" right={<Toggle theme={theme}/>}/>
          <SettingRow theme={theme} label="Bahasa" right={<div style={{ fontSize: 13, color: theme.muted }}>Indonesia</div>}/>
        </SettingGroup>
      </div>
    </div>
  );
};

const SettingGroup = ({ title, children, theme }) => (
  <div style={{ marginTop: 18 }}>
    <div style={{ fontSize: 12, fontWeight: 700, color: theme.muted, letterSpacing: 1, textTransform: 'uppercase', padding: '0 4px 8px' }}>{title}</div>
    <div style={{ background: '#fff', borderRadius: 18, overflow: 'hidden', boxShadow: '0 2px 0 rgba(0,0,0,0.04)' }}>{children}</div>
  </div>
);
const SettingRow = ({ label, right, theme }) => (
  <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '14px 16px', borderBottom: `1px solid ${theme.bg}` }}>
    <div style={{ fontSize: 14, color: theme.ink, fontWeight: 600 }}>{label}</div>
    {right}
  </div>
);
const Toggle = ({ on: defaultOn = false, theme }) => {
  const [on, setOn] = React.useState(defaultOn);
  return (
    <div onClick={() => setOn(!on)} style={{
      width: 44, height: 26, borderRadius: 999,
      background: on ? theme.primary : theme.bg2, cursor: 'pointer',
      position: 'relative', transition: 'background 0.2s',
    }}>
      <div style={{
        position: 'absolute', top: 2, left: on ? 20 : 2, width: 22, height: 22, borderRadius: '50%', background: '#fff',
        boxShadow: '0 1px 3px rgba(0,0,0,0.2)', transition: 'left 0.2s',
      }}/>
    </div>
  );
};

Object.assign(window, {
  LatihanScreen, EvaluasiListScreen, EvaluasiDoScreen, EvaluasiResultScreen,
  GlosariumScreen, PengaturanScreen, Waveform,
});
