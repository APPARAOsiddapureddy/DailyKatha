// Onboarding screens: Splash, Language, Religion, Interests
const { color: OC, type: OT, shadow: OSH } = window.DK;

// ─────────────────────────────────────────────────────────────
// Splash
// ─────────────────────────────────────────────────────────────
const SplashScreen = ({ onEnter }) => {
  React.useEffect(() => {
    const t = setTimeout(onEnter, 1600);
    return () => clearTimeout(t);
  }, []);
  return (
    <div style={{
      position: 'absolute', inset: 0, background: OC.brandDeep,
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      gap: 18, overflow: 'hidden',
    }}>
      {/* radial decoration */}
      <div style={{
        position: 'absolute', inset: 0,
        background: 'radial-gradient(ellipse at 50% 30%, rgba(232,155,44,0.22) 0%, rgba(232,155,44,0) 55%)',
      }} />
      {/* lamp dot */}
      <div style={{
        width: 12, height: 12, borderRadius: 12, background: OC.saffron,
        boxShadow: '0 0 24px ' + OC.saffron + ', 0 0 60px rgba(232,155,44,0.4)',
        marginBottom: 8, position: 'relative',
      }} />
      <div style={{
        fontFamily: OT.display, fontSize: 56, fontWeight: 500, color: '#fff',
        letterSpacing: -0.6, position: 'relative', lineHeight: 1,
      }}>
        Daily <span style={{ fontStyle: 'italic', color: OC.saffron }}>Katha</span>
      </div>
      <div style={{
        fontFamily: OT.ui, fontSize: 13, fontWeight: 500, color: 'rgba(255,255,255,0.6)',
        letterSpacing: 3, textTransform: 'uppercase', marginTop: 6, position: 'relative',
      }}>A line for the day</div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// Language picker — Bharat-friendly large rows with native script
// ─────────────────────────────────────────────────────────────
const LanguageScreen = ({ value, onChange, onNext }) => {
  return (
    <div style={{ position: 'absolute', inset: 0, background: OC.cream, display: 'flex', flexDirection: 'column' }}>
      <div style={{ paddingTop: 56, padding: '56px 24px 12px' }}>
        <div style={{
          fontFamily: OT.ui, fontSize: 12, fontWeight: 700, letterSpacing: 2,
          color: OC.brand, textTransform: 'uppercase', marginBottom: 10,
        }}>Step 1 of 3</div>
        <div style={{
          fontFamily: OT.display, fontSize: 32, lineHeight: 1.18, fontWeight: 500,
          color: OC.ink, letterSpacing: -0.4,
        }}>Choose your<br/>reading language</div>
        <div style={{
          fontFamily: OT.ui, fontSize: 15, color: OC.ink3, marginTop: 10, lineHeight: 1.45,
        }}>Cards will appear in this language first.</div>
      </div>
      <div style={{ flex: 1, overflow: 'auto', padding: '12px 16px 16px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {window.DK.languages.map(l => {
          const on = value === l.id;
          return (
            <button key={l.id} onClick={() => onChange(l.id)} style={{
              display: 'flex', alignItems: 'center', gap: 16, padding: '18px 18px',
              border: 'none', cursor: 'pointer',
              background: on ? '#fff' : '#FFFFFF',
              borderRadius: 18,
              boxShadow: on
                ? `0 0 0 2.5px ${OC.brand}, 0 6px 18px rgba(179,58,32,0.10)`
                : `inset 0 0 0 1px ${OC.border}`,
              textAlign: 'left',
            }}>
              <div style={{
                width: 56, height: 56, borderRadius: 14,
                background: on ? OC.brand : OC.surfaceAlt,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: OT.display, fontSize: 22, fontWeight: 600,
                color: on ? '#fff' : OC.ink2, flexShrink: 0,
              }}>{l.native.slice(0, 2)}</div>
              <div style={{ flex: 1 }}>
                <div style={{ fontFamily: OT.display, fontSize: 22, fontWeight: 500, color: OC.ink, letterSpacing: -0.2 }}>
                  {l.native}
                </div>
                <div style={{ fontFamily: OT.ui, fontSize: 13, color: OC.ink3, marginTop: 2 }}>
                  {l.name} · {l.sample}
                </div>
              </div>
              <div style={{
                width: 26, height: 26, borderRadius: 26,
                border: on ? 'none' : `2px solid ${OC.border}`,
                background: on ? OC.brand : 'transparent',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                {on && <Icon name="check" size={14} color="#fff" strokeWidth={2.6} />}
              </div>
            </button>
          );
        })}
      </div>
      <div style={{ padding: '12px 20px 36px', background: OC.cream }}>
        <Button onClick={onNext} disabled={!value} icon="arrowRight">Continue</Button>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// Religion picker — explicit "skip" path
// ─────────────────────────────────────────────────────────────
const ReligionScreen = ({ value, onChange, onNext, onBack }) => {
  return (
    <div style={{ position: 'absolute', inset: 0, background: OC.cream, display: 'flex', flexDirection: 'column' }}>
      <Header title="" onBack={onBack} />
      <div style={{ padding: '4px 24px 14px' }}>
        <div style={{
          fontFamily: OT.ui, fontSize: 12, fontWeight: 700, letterSpacing: 2,
          color: OC.brand, textTransform: 'uppercase', marginBottom: 10,
        }}>Step 2 of 3</div>
        <div style={{
          fontFamily: OT.display, fontSize: 32, lineHeight: 1.18, fontWeight: 500,
          color: OC.ink, letterSpacing: -0.4,
        }}>Any path<br/>you follow?</div>
        <div style={{
          fontFamily: OT.ui, fontSize: 15, color: OC.ink3, marginTop: 10, lineHeight: 1.45,
        }}>So we keep devotional cards<br/>respectful to your tradition.</div>
      </div>
      <div style={{ flex: 1, overflow: 'auto', padding: '4px 16px 16px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {window.DK.religions.map(r => {
          const on = value === r.id;
          return (
            <button key={r.id} onClick={() => onChange(r.id)} style={{
              display: 'flex', alignItems: 'center', gap: 16, padding: '16px 18px',
              border: 'none', cursor: 'pointer', background: OC.surface,
              borderRadius: 18, textAlign: 'left',
              boxShadow: on
                ? `0 0 0 2.5px ${OC.brand}, 0 6px 18px rgba(179,58,32,0.10)`
                : `inset 0 0 0 1px ${OC.border}`,
            }}>
              <div style={{
                width: 48, height: 48, borderRadius: 24,
                background: on ? OC.brand : OC.surfaceAlt,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                fontFamily: OT.display, fontSize: 22, color: on ? '#fff' : OC.ink2,
                flexShrink: 0,
              }}>{r.glyph}</div>
              <div style={{ flex: 1, fontFamily: OT.ui, fontSize: 17, fontWeight: 500, color: OC.ink }}>
                {r.label}
              </div>
              <div style={{
                width: 24, height: 24, borderRadius: 24,
                border: on ? 'none' : `2px solid ${OC.border}`,
                background: on ? OC.brand : 'transparent',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                {on && <Icon name="check" size={13} color="#fff" strokeWidth={2.6} />}
              </div>
            </button>
          );
        })}
      </div>
      <div style={{ padding: '12px 20px 36px', background: OC.cream }}>
        <Button onClick={onNext} disabled={!value} icon="arrowRight">Continue</Button>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// Interests — pick up to 3, large pills with images
// ─────────────────────────────────────────────────────────────
const InterestsScreen = ({ value = [], onChange, onNext, onBack }) => {
  const toggle = (id) => {
    if (value.includes(id)) onChange(value.filter(v => v !== id));
    else if (value.length < 3) onChange([...value, id]);
  };
  return (
    <div style={{ position: 'absolute', inset: 0, background: OC.cream, display: 'flex', flexDirection: 'column' }}>
      <Header title="" onBack={onBack} />
      <div style={{ padding: '4px 24px 12px' }}>
        <div style={{
          fontFamily: OT.ui, fontSize: 12, fontWeight: 700, letterSpacing: 2,
          color: OC.brand, textTransform: 'uppercase', marginBottom: 10,
        }}>Step 3 of 3</div>
        <div style={{
          fontFamily: OT.display, fontSize: 32, lineHeight: 1.18, fontWeight: 500,
          color: OC.ink, letterSpacing: -0.4,
        }}>What do you<br/>love sharing?</div>
        <div style={{
          fontFamily: OT.ui, fontSize: 15, color: OC.ink3, marginTop: 10, lineHeight: 1.45,
        }}>Pick up to 3.  <span style={{ color: OC.brand, fontWeight: 600 }}>{value.length}/3 chosen</span></div>
      </div>
      <div style={{ flex: 1, overflow: 'auto', padding: '4px 16px 16px' }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10 }}>
          {window.DK.interests.map(i => {
            const on = value.includes(i.id);
            const palette = window.DK.cat[i.id] || { bg: OC.brand, accent: OC.saffron };
            const disabled = !on && value.length >= 3;
            return (
              <button key={i.id} onClick={() => !disabled && toggle(i.id)} style={{
                position: 'relative', height: 110, padding: '14px 14px',
                border: 'none', borderRadius: 18, cursor: disabled ? 'default' : 'pointer',
                background: on ? palette.bg : OC.surface,
                boxShadow: on
                  ? `0 8px 18px ${palette.bg}30`
                  : `inset 0 0 0 1px ${OC.border}`,
                opacity: disabled ? 0.45 : 1,
                textAlign: 'left', display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
                transition: 'all 0.15s ease',
              }}>
                <div style={{ fontSize: 26, lineHeight: 1, filter: on ? 'none' : 'grayscale(0.1)' }}>
                  {i.emoji}
                </div>
                <div>
                  <div style={{
                    fontFamily: OT.ui, fontSize: 16, fontWeight: 700,
                    color: on ? '#fff' : OC.ink, letterSpacing: -0.2,
                  }}>{i.label}</div>
                </div>
                {on && (
                  <div style={{
                    position: 'absolute', top: 12, right: 12,
                    width: 24, height: 24, borderRadius: 24, background: palette.accent,
                    display: 'flex', alignItems: 'center', justifyContent: 'center',
                  }}>
                    <Icon name="check" size={13} color={palette.bg} strokeWidth={2.8} />
                  </div>
                )}
              </button>
            );
          })}
        </div>
      </div>
      <div style={{ padding: '12px 20px 36px', background: OC.cream }}>
        <Button onClick={onNext} disabled={value.length === 0} icon="arrowRight">
          {value.length === 0 ? 'Pick at least one' : 'Show me my cards'}
        </Button>
      </div>
    </div>
  );
};

Object.assign(window, { SplashScreen, LanguageScreen, ReligionScreen, InterestsScreen });
