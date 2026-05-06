// Screens for Tilawati app

// ─────────────────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────────────────
const HomeScreen = ({ theme, navigate, user }) => {
  const [hover, setHover] = React.useState(null);
  const menuItems = [
    { id: 'latihan', label: 'Latihan', subtitle: 'Belajar membaca jilid', icon: 'practice', color: theme.primary, bg: '#E8F2EC' },
    { id: 'evaluasi', label: 'Evaluasi', subtitle: 'Uji kemampuan', icon: 'evaluation', color: theme.accent, bg: '#FBF1D6' },
    { id: 'glosarium', label: 'Glosarium', subtitle: 'Huruf hijaiyah', icon: 'glossary', color: '#7B5CD6', bg: '#EFE9FA' },
    { id: 'pengaturan', label: 'Pengaturan', subtitle: 'Suara & profil', icon: 'settings', color: '#264653', bg: '#E5EDF0' },
  ];
  return (
    <div style={{ padding: '64px 20px 100px', position: 'relative', minHeight: '100%', background: `linear-gradient(180deg, ${theme.bg} 0%, ${theme.bg2} 100%)` }}>
      {/* decorative arabesque corners */}
      <ArabesqueCorner size={140} color={theme.primary} opacity={0.08} style={{ position: 'absolute', top: -20, right: -30 }}/>
      <ArabesqueCorner size={110} color={theme.accent} opacity={0.1} style={{ position: 'absolute', bottom: 40, left: -30 }}/>

      {/* Greeting + stats */}
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 18 }}>
        <div>
          <div style={{ fontSize: 13, color: theme.muted, fontWeight: 600, letterSpacing: 0.4, textTransform: 'uppercase' }}>Assalamu'alaikum</div>
          <div style={{ fontSize: 22, fontWeight: 800, color: theme.ink, marginTop: 2 }}>{user.name} 👋</div>
        </div>
        <div style={{
          width: 44, height: 44, borderRadius: '50%',
          background: `linear-gradient(135deg, ${theme.accentLight}, ${theme.accent})`,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          color: '#fff', fontWeight: 800, fontSize: 18,
          boxShadow: '0 4px 12px rgba(212,175,55,0.4)',
        }}>{user.name[0]}</div>
      </div>

      {/* Streak + XP row */}
      <div style={{ display: 'flex', gap: 8, marginBottom: 18 }}>
        <StatPill icon="fire" value={`${user.streak} hari`} color="#E07856" bg="#FCE6DC"/>
        <StatPill icon="star" value={`${user.xp} XP`} color={theme.accent} bg="#FBF1D6"/>
        <StatPill icon="gem" value={user.gems} color="#5BA3D0" bg="#E1F0F8"/>
      </div>

      {/* Hero card — continue last lesson */}
      <div style={{
        background: `linear-gradient(135deg, ${theme.primary} 0%, ${theme.primaryLight} 100%)`,
        borderRadius: 24, padding: 18, color: '#fff',
        position: 'relative', overflow: 'hidden',
        boxShadow: `0 6px 0 ${theme.primaryDark}, 0 12px 30px rgba(15,81,50,0.3)`,
        marginBottom: 18,
      }}>
        <ArabesqueCorner size={160} color="#fff" opacity={0.08} style={{ position: 'absolute', top: -40, right: -40 }}/>
        <div style={{ fontSize: 12, fontWeight: 700, letterSpacing: 1, opacity: 0.85, textTransform: 'uppercase' }}>Lanjutkan</div>
        <div style={{ fontSize: 22, fontWeight: 800, marginTop: 4 }}>Jilid 1 · Halaman 12</div>
        <div style={{ fontSize: 13, opacity: 0.9, marginTop: 2 }}>Mengenal huruf berharakat fathah</div>
        <div style={{ marginTop: 14 }}>
          <ProgressBar value={0.27} color="#FFD25F" bg="rgba(255,255,255,0.2)" height={10}/>
        </div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginTop: 14 }}>
          <div style={{ fontSize: 12, opacity: 0.85 }}>12 dari 44 halaman</div>
          <button onClick={() => navigate('jilid-detail', { jilid: 1 })} style={{
            background: '#fff', color: theme.primary,
            border: 'none', padding: '10px 16px', borderRadius: 14,
            fontSize: 14, fontWeight: 800, cursor: 'pointer',
            display: 'flex', alignItems: 'center', gap: 6,
          }}>
            <Icon name="play" size={14} color={theme.primary}/> Lanjut
          </button>
        </div>
      </div>

      {/* Menu grid */}
      <div style={{ fontSize: 13, fontWeight: 700, color: theme.muted, textTransform: 'uppercase', letterSpacing: 0.6, marginBottom: 10 }}>Menu</div>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
        {menuItems.map(m => (
          <button key={m.id} onClick={() => navigate(m.id === 'latihan' ? 'jilid-list' : m.id === 'evaluasi' ? 'evaluasi-list' : m.id === 'glosarium' ? 'glosarium' : 'pengaturan')}
            onMouseEnter={() => setHover(m.id)} onMouseLeave={() => setHover(null)}
            style={{
              background: '#fff', border: 'none',
              borderRadius: 22, padding: 16,
              textAlign: 'left', cursor: 'pointer',
              boxShadow: hover === m.id ? `0 2px 0 ${m.color}33, 0 8px 24px rgba(0,0,0,0.08)` : `0 4px 0 ${m.color}22, 0 6px 16px rgba(0,0,0,0.05)`,
              transform: hover === m.id ? 'translateY(2px)' : '',
              transition: 'all 0.15s',
              fontFamily: 'inherit',
            }}>
            <div style={{
              width: 48, height: 48, borderRadius: 14,
              background: m.bg,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              marginBottom: 12,
            }}>
              <Icon name={m.icon} size={24} color={m.color} stroke={2.4}/>
            </div>
            <div style={{ fontSize: 16, fontWeight: 800, color: theme.ink }}>{m.label}</div>
            <div style={{ fontSize: 12, color: theme.muted, marginTop: 2 }}>{m.subtitle}</div>
          </button>
        ))}
      </div>

      {/* Daily goal card */}
      <div style={{
        marginTop: 18, padding: 16, background: '#fff', borderRadius: 22,
        boxShadow: '0 4px 0 rgba(0,0,0,0.04), 0 6px 16px rgba(0,0,0,0.04)',
        display: 'flex', gap: 14, alignItems: 'center',
      }}>
        <div style={{ position: 'relative', width: 64, height: 64 }}>
          <svg width="64" height="64" viewBox="0 0 64 64">
            <circle cx="32" cy="32" r="28" fill="none" stroke={theme.bg2} strokeWidth="6"/>
            <circle cx="32" cy="32" r="28" fill="none" stroke={theme.accent} strokeWidth="6"
              strokeDasharray={`${0.6 * 175.9} 175.9`} strokeDashoffset="0" strokeLinecap="round"
              transform="rotate(-90 32 32)"/>
          </svg>
          <div style={{ position: 'absolute', inset: 0, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
            <Icon name="trophy" size={26} color={theme.accent}/>
          </div>
        </div>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 14, fontWeight: 800, color: theme.ink }}>Target Hari Ini</div>
          <div style={{ fontSize: 12, color: theme.muted, marginTop: 2 }}>3 dari 5 halaman selesai</div>
          <div style={{ marginTop: 6 }}><ProgressBar value={0.6} color={theme.accent} bg={theme.bg2} height={8}/></div>
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────
// PILIH JILID (list)
// ─────────────────────────────────────────────────────
const JilidListScreen = ({ theme, navigate }) => {
  return (
    <div style={{ background: theme.bg, minHeight: '100%', paddingBottom: 80 }}>
      <TopBar title="Pilih Jilid Tilawati" onBack={() => navigate('home')} theme={theme}/>
      <div style={{ padding: '8px 20px 20px' }}>
        <div style={{ fontSize: 13, color: theme.muted, marginBottom: 14, lineHeight: 1.5 }}>
          Pilih jilid yang ingin kamu pelajari. Selesaikan jilid sebelumnya untuk membuka level berikutnya.
        </div>
        <div style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          {JILID.map((j, idx) => {
            const locked = idx > 0 && JILID[idx-1].progress < 0.8;
            return (
              <button key={j.id} disabled={locked} onClick={() => !locked && navigate('jilid-detail', { jilid: j.id })} style={{
                background: '#fff', border: 'none',
                borderRadius: 22, padding: 14,
                display: 'flex', gap: 14, alignItems: 'center',
                cursor: locked ? 'not-allowed' : 'pointer',
                boxShadow: locked ? 'none' : `0 4px 0 ${j.color}22, 0 6px 16px rgba(0,0,0,0.05)`,
                opacity: locked ? 0.5 : 1,
                fontFamily: 'inherit', textAlign: 'left',
                position: 'relative', overflow: 'hidden',
              }}>
                {/* Book cover */}
                <div style={{
                  width: 72, height: 92,
                  background: `linear-gradient(135deg, ${j.color} 0%, ${j.color}dd 100%)`,
                  borderRadius: 8,
                  position: 'relative',
                  flexShrink: 0,
                  boxShadow: `inset -3px 0 0 rgba(0,0,0,0.15), 0 3px 8px ${j.color}55`,
                  display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
                  color: '#fff', padding: 6,
                }}>
                  <div style={{ fontSize: 9, fontWeight: 700, letterSpacing: 1, opacity: 0.8 }}>TILAWATI</div>
                  <div className="arabic" style={{ fontSize: 28, lineHeight: 1, marginTop: 2 }}>﷽</div>
                  <div style={{ fontSize: 18, fontWeight: 800, marginTop: 4 }}>{j.id}</div>
                  {/* spine highlight */}
                  <div style={{ position: 'absolute', left: 4, top: 4, bottom: 4, width: 1, background: 'rgba(255,255,255,0.3)' }}/>
                </div>
                <div style={{ flex: 1, minWidth: 0 }}>
                  <div style={{ fontSize: 17, fontWeight: 800, color: theme.ink }}>{j.title}</div>
                  <div style={{ fontSize: 12, color: theme.muted, marginTop: 2 }}>{j.subtitle}</div>
                  <div style={{ marginTop: 10, display: 'flex', alignItems: 'center', gap: 8 }}>
                    <div style={{ flex: 1 }}><ProgressBar value={j.progress} color={j.color} bg={theme.bg2} height={8}/></div>
                    <span style={{ fontSize: 11, fontWeight: 700, color: theme.muted, minWidth: 32 }}>{Math.round(j.progress * 100)}%</span>
                  </div>
                </div>
                {locked && (
                  <div style={{ position: 'absolute', right: 14, top: 14 }}>
                    <Icon name="lock" size={18} color={theme.muted}/>
                  </div>
                )}
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────
// PILIH HALAMAN (page grid inside a jilid)
// ─────────────────────────────────────────────────────
const JilidDetailScreen = ({ theme, navigate, jilidId }) => {
  const j = JILID.find(x => x.id === jilidId) || JILID[0];
  const completed = Math.round(j.progress * j.pages);
  const pages = Array.from({ length: j.pages }, (_, i) => ({
    n: i + 1,
    state: i < completed ? 'done' : i === completed ? 'current' : 'locked',
  }));
  return (
    <div style={{ background: theme.bg, minHeight: '100%', paddingBottom: 80 }}>
      <TopBar title={j.title} onBack={() => navigate('jilid-list')} theme={theme}/>
      {/* Jilid hero */}
      <div style={{ padding: '0 20px 16px' }}>
        <div style={{
          background: `linear-gradient(135deg, ${j.color} 0%, ${j.color}cc 100%)`,
          borderRadius: 22, padding: 18, color: '#fff',
          position: 'relative', overflow: 'hidden',
          boxShadow: `0 6px 0 ${j.color}77, 0 10px 24px ${j.color}33`,
        }}>
          <ArabesqueCorner size={140} color="#fff" opacity={0.1} style={{ position: 'absolute', top: -30, right: -30 }}/>
          <div style={{ fontSize: 13, fontWeight: 700, opacity: 0.85, letterSpacing: 0.6 }}>JILID {j.id}</div>
          <div style={{ fontSize: 20, fontWeight: 800, marginTop: 2 }}>{j.subtitle}</div>
          <div style={{ fontSize: 12, opacity: 0.9, marginTop: 4 }}>{j.desc}</div>
          <div style={{ marginTop: 14, display: 'flex', alignItems: 'center', gap: 10 }}>
            <div style={{ flex: 1 }}><ProgressBar value={j.progress} color="#FFD25F" bg="rgba(255,255,255,0.18)" height={8}/></div>
            <div style={{ fontSize: 12, fontWeight: 700 }}>{completed}/{j.pages}</div>
          </div>
        </div>
      </div>
      {/* Page grid */}
      <div style={{ padding: '0 20px' }}>
        <div style={{ fontSize: 13, fontWeight: 700, color: theme.muted, textTransform: 'uppercase', letterSpacing: 0.6, marginBottom: 10 }}>Halaman</div>
        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8 }}>
          {pages.map(p => {
            const done = p.state === 'done';
            const cur = p.state === 'current';
            const locked = p.state === 'locked';
            return (
              <button key={p.n} disabled={locked} onClick={() => navigate('huruf', { jilid: jilidId, page: p.n })}
                style={{
                  aspectRatio: '3 / 4',
                  border: 'none',
                  borderRadius: 12,
                  cursor: locked ? 'not-allowed' : 'pointer',
                  background: done ? '#fff' : cur ? '#fff' : '#fff',
                  position: 'relative',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  boxShadow: cur
                    ? `0 0 0 3px ${j.color}, 0 4px 0 ${j.color}55, 0 6px 12px ${j.color}33`
                    : done
                      ? `0 2px 0 ${j.color}33, 0 3px 8px rgba(0,0,0,0.04)`
                      : '0 1px 2px rgba(0,0,0,0.05)',
                  opacity: locked ? 0.45 : 1,
                  fontFamily: 'inherit',
                  fontSize: 18, fontWeight: 800,
                  color: cur ? j.color : done ? theme.ink : theme.muted,
                }}>
                {p.n}
                {done && (
                  <div style={{ position: 'absolute', top: 4, right: 4, width: 16, height: 16, borderRadius: '50%', background: j.color, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                    <Icon name="check" size={10} color="#fff" stroke={3.5}/>
                  </div>
                )}
                {locked && (
                  <div style={{ position: 'absolute', top: 4, right: 4 }}>
                    <Icon name="lock" size={11} color={theme.muted}/>
                  </div>
                )}
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────
// MENGENAL HURUF (single huruf intro)
// ─────────────────────────────────────────────────────
const HurufScreen = ({ theme, navigate, jilidId, page }) => {
  const lessonIdx = ((page || 1) - 1) % HURUF_LESSONS.length;
  const [idx, setIdx] = React.useState(lessonIdx);
  const [bouncing, setBouncing] = React.useState(false);
  const [playing, setPlaying] = React.useState(false);
  const lesson = HURUF_LESSONS[idx];

  const playAudio = () => {
    setBouncing(true);
    setPlaying(true);
    setTimeout(() => setBouncing(false), 600);
    setTimeout(() => setPlaying(false), 1500);
  };

  const next = () => {
    if (idx < HURUF_LESSONS.length - 1) setIdx(idx + 1);
    else navigate('latihan', { jilid: jilidId, page });
  };
  const prev = () => {
    if (idx > 0) setIdx(idx - 1);
    else navigate('jilid-detail', { jilid: jilidId });
  };

  return (
    <div style={{ background: theme.bg, minHeight: '100%', display: 'flex', flexDirection: 'column' }}>
      <TopBar title={`Halaman ${page || 1}`} onBack={() => navigate('jilid-detail', { jilid: jilidId })} theme={theme}
        right={<div style={{ width: 40, height: 40, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
          <Icon name="volume" size={20} color={theme.ink}/>
        </div>}/>

      {/* Step pills */}
      <div style={{ padding: '0 20px 16px', display: 'flex', gap: 4 }}>
        {HURUF_LESSONS.map((_, i) => (
          <div key={i} style={{
            flex: 1, height: 6, borderRadius: 3,
            background: i <= idx ? theme.primary : theme.bg2,
            transition: 'background 0.3s',
          }}/>
        ))}
      </div>

      {/* Speech bubble */}
      <div style={{ padding: '0 24px', position: 'relative' }}>
        <div key={`b-${idx}`} style={{
          background: '#fff',
          borderRadius: 20,
          padding: '14px 18px',
          boxShadow: '0 4px 0 rgba(0,0,0,0.04), 0 6px 16px rgba(0,0,0,0.06)',
          fontSize: 14, color: theme.ink, lineHeight: 1.5,
          position: 'relative',
          animation: 'fade-up 0.4s ease',
        }}>
          <div style={{ fontSize: 11, fontWeight: 800, color: theme.primary, letterSpacing: 0.6, textTransform: 'uppercase', marginBottom: 4 }}>Cara Membaca</div>
          {lesson.desc}
          {/* bubble tail */}
          <div style={{ position: 'absolute', bottom: -8, left: 32, width: 18, height: 18, background: '#fff', transform: 'rotate(45deg)', boxShadow: '4px 4px 8px rgba(0,0,0,0.04)' }}/>
        </div>
      </div>

      {/* Big huruf in center */}
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', padding: 24, position: 'relative' }}>
        <ArabesqueCorner size={260} color={theme.primary} opacity={0.06} style={{ position: 'absolute' }}/>
        <div onClick={playAudio} className="arabic" key={`h-${idx}-${bouncing}`} style={{
          fontSize: 200, lineHeight: 1, color: theme.primary,
          fontWeight: 700, cursor: 'pointer', userSelect: 'none',
          animation: bouncing ? 'bounce-in 0.6s cubic-bezier(.2,1.4,.4,1)' : '',
          textShadow: playing ? `0 0 40px ${theme.primary}55` : 'none',
          transition: 'text-shadow 0.3s',
        }}>{lesson.ar}</div>
        <div style={{ marginTop: 12, fontSize: 14, fontWeight: 700, color: theme.muted, letterSpacing: 2 }}>{lesson.latin}</div>

        {/* Listen button with pulse */}
        <div style={{ marginTop: 32, position: 'relative' }}>
          {playing && (
            <>
              <div style={{ position: 'absolute', inset: 0, borderRadius: '50%', border: `3px solid ${theme.primary}`, animation: 'pulse-ring 1.2s ease-out infinite' }}/>
              <div style={{ position: 'absolute', inset: 0, borderRadius: '50%', border: `3px solid ${theme.primary}`, animation: 'pulse-ring 1.2s ease-out 0.4s infinite' }}/>
            </>
          )}
          <button onClick={playAudio} style={{
            background: theme.primary, color: '#fff',
            border: 'none', padding: '14px 28px',
            borderRadius: 999, fontSize: 16, fontWeight: 800,
            cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 10,
            fontFamily: 'inherit',
            boxShadow: `0 4px 0 ${theme.primaryDark}, 0 8px 20px ${theme.primary}55`,
          }}>
            <Icon name={playing ? 'pause' : 'play'} size={16} color="#fff"/>
            {playing ? 'Memutar...' : 'Dengar'}
          </button>
        </div>
      </div>

      {/* Bottom controls */}
      <div style={{ padding: '12px 20px 24px', display: 'flex', gap: 10, alignItems: 'center' }}>
        <button onClick={prev} style={{
          width: 52, height: 52, borderRadius: 18,
          background: '#fff', border: 'none', cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 4px 0 rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.05)',
        }}>
          <Icon name="arrow-left" size={22} color={theme.ink}/>
        </button>
        <button onClick={next} style={{
          flex: 1, height: 52, borderRadius: 18,
          background: theme.primary, color: '#fff',
          border: 'none', cursor: 'pointer',
          fontSize: 16, fontWeight: 800,
          fontFamily: 'inherit',
          boxShadow: `0 4px 0 ${theme.primaryDark}, 0 6px 16px ${theme.primary}55`,
        }}>{idx === HURUF_LESSONS.length - 1 ? 'Mulai Latihan' : 'Lanjut'}</button>
      </div>
    </div>
  );
};

Object.assign(window, { HomeScreen, JilidListScreen, JilidDetailScreen, HurufScreen });
