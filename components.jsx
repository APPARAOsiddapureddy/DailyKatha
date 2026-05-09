// Daily Katha shared components
// Atoms: Icon, Button, Chip, BackBtn, Header, BottomNav
// Cards: HeroCard, MiniCard, FeedCard, BlurOverlay
const { color: C, cat: CAT, type: T, shadow: SH } = window.DK;

// ─────────────────────────────────────────────────────────────
// Icons — minimal stroked set
// ─────────────────────────────────────────────────────────────
const Icon = ({ name, size = 22, color = 'currentColor', strokeWidth = 1.8 }) => {
  const s = strokeWidth;
  const paths = {
    chevronLeft: <path d="M15 5l-7 7 7 7" />,
    chevronRight: <path d="M9 5l7 7-7 7" />,
    chevronDown: <path d="M5 9l7 7 7-7" />,
    close: <path d="M6 6l12 12M18 6L6 18" />,
    check: <path d="M5 12l5 5 9-11" />,
    plus: <path d="M12 5v14M5 12h14" />,
    home: <path d="M4 11l8-7 8 7v9a1 1 0 0 1-1 1h-4v-7h-6v7H5a1 1 0 0 1-1-1z" />,
    homeFill: <><path d="M4 11l8-7 8 7v9a1 1 0 0 1-1 1h-4v-7h-6v7H5a1 1 0 0 1-1-1z" fill={color} stroke="none"/></>,
    compass: <><circle cx="12" cy="12" r="9"/><path d="M15.5 8.5l-2 5-5 2 2-5z"/></>,
    compassFill: <><circle cx="12" cy="12" r="9" fill={color} stroke={color}/><path d="M15.5 8.5l-2 5-5 2 2-5z" stroke="#FBF6EC" fill="#FBF6EC"/></>,
    user: <><circle cx="12" cy="8" r="4"/><path d="M4 21c0-4 4-7 8-7s8 3 8 7"/></>,
    userFill: <><circle cx="12" cy="8" r="4" fill={color} stroke={color}/><path d="M4 21c0-4 4-7 8-7s8 3 8 7" fill={color} stroke={color}/></>,
    heart: <path d="M12 20s-8-5-8-11a5 5 0 0 1 9-3 5 5 0 0 1 9 3c0 6-8 11-8 11z" />,
    heartFill: <path d="M12 20s-8-5-8-11a5 5 0 0 1 9-3 5 5 0 0 1 9 3c0 6-8 11-8 11z" fill={color} />,
    save: <path d="M6 4h12v17l-6-4-6 4z" />,
    saveFill: <path d="M6 4h12v17l-6-4-6 4z" fill={color} />,
    share: <><circle cx="6" cy="12" r="2.5"/><circle cx="18" cy="6" r="2.5"/><circle cx="18" cy="18" r="2.5"/><path d="M8 11l8-4M8 13l8 4"/></>,
    edit: <><path d="M14 4l6 6L9 21H3v-6z"/><path d="M13 5l6 6"/></>,
    photo: <><rect x="3" y="5" width="18" height="14" rx="2"/><circle cx="8.5" cy="10.5" r="1.5"/><path d="M21 16l-5-5-9 8"/></>,
    search: <><circle cx="11" cy="11" r="7"/><path d="M20 20l-4-4"/></>,
    sparkle: <path d="M12 3l1.8 5.4L19 10l-5.2 1.6L12 17l-1.8-5.4L5 10l5.2-1.6z" />,
    sun: <><circle cx="12" cy="12" r="4"/><path d="M12 3v2M12 19v2M3 12h2M19 12h2M5.6 5.6l1.4 1.4M17 17l1.4 1.4M5.6 18.4l1.4-1.4M17 7l1.4-1.4"/></>,
    moon: <path d="M20 14a8 8 0 1 1-9-10 6 6 0 0 0 9 10z" />,
    flame: <path d="M12 3c2 4-3 5-3 9a3 3 0 0 0 6 0c0 1.5-.5 2.5-1.5 3.5C15 14 16 12 16 10c2 1.5 3 3.5 3 6a7 7 0 0 1-14 0c0-5 4-6 4-10z" />,
    arrowRight: <path d="M5 12h14M13 5l7 7-7 7"/>,
    bell: <><path d="M6 16V11a6 6 0 0 1 12 0v5l1.5 2H4.5z"/><path d="M10 21h4"/></>,
    settings: <><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .3 1.8l.1.1a2 2 0 1 1-2.8 2.8l-.1-.1a1.7 1.7 0 0 0-1.8-.3 1.7 1.7 0 0 0-1 1.5V21a2 2 0 1 1-4 0v-.1a1.7 1.7 0 0 0-1-1.5 1.7 1.7 0 0 0-1.8.3l-.1.1A2 2 0 1 1 4.4 17l.1-.1a1.7 1.7 0 0 0 .3-1.8 1.7 1.7 0 0 0-1.5-1H3a2 2 0 1 1 0-4h.1a1.7 1.7 0 0 0 1.5-1 1.7 1.7 0 0 0-.3-1.8L4.2 7A2 2 0 1 1 7 4.2l.1.1a1.7 1.7 0 0 0 1.8.3H9a1.7 1.7 0 0 0 1-1.5V3a2 2 0 1 1 4 0v.1a1.7 1.7 0 0 0 1 1.5 1.7 1.7 0 0 0 1.8-.3l.1-.1A2 2 0 1 1 19.8 7l-.1.1a1.7 1.7 0 0 0-.3 1.8V9a1.7 1.7 0 0 0 1.5 1H21a2 2 0 1 1 0 4h-.1a1.7 1.7 0 0 0-1.5 1z"/></>,
    streak: <path d="M13 2c1 5-4 6-4 11a5 5 0 0 0 10 0c0-3-2-5-3-6 0 2-1 3-2 3 0-3-1-6-1-8z" />,
    sliders: <><path d="M4 6h12M20 6h0M4 12h6M14 12h6M4 18h12M20 18h0"/><circle cx="18" cy="6" r="2"/><circle cx="12" cy="12" r="2"/><circle cx="18" cy="18" r="2"/></>,
    rotate: <><path d="M3 12a9 9 0 0 1 15-6.7L21 8M21 3v5h-5"/><path d="M21 12a9 9 0 0 1-15 6.7L3 16M3 21v-5h5"/></>,
    text: <path d="M5 5h14M12 5v15M9 20h6"/>,
    download: <><path d="M12 4v12M6 12l6 6 6-6"/><path d="M5 20h14"/></>,
  };
  const fillIcons = ['homeFill','compassFill','userFill','heartFill','saveFill'];
  return (
    <svg width={size} height={size} viewBox="0 0 24 24"
      fill="none" stroke={fillIcons.includes(name) ? 'none' : color}
      strokeWidth={s} strokeLinecap="round" strokeLinejoin="round"
      style={{ display: 'block', flexShrink: 0 }}>
      {paths[name]}
    </svg>
  );
};

// ─────────────────────────────────────────────────────────────
// Header — used at top of every screen
// ─────────────────────────────────────────────────────────────
const Header = ({ title, onBack, right, sticky = true, dark = false }) => (
  <div style={{
    position: sticky ? 'sticky' : 'relative', top: 0, zIndex: 10,
    background: dark ? 'transparent' : C.cream,
    padding: '8px 16px 12px',
    display: 'flex', alignItems: 'center', gap: 12,
    minHeight: 52,
  }}>
    {onBack ? (
      <button onClick={onBack} style={{
        width: 40, height: 40, borderRadius: 20, border: 'none',
        background: dark ? 'rgba(255,255,255,0.12)' : 'rgba(26,20,16,0.04)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        cursor: 'pointer', flexShrink: 0,
      }}>
        <Icon name="chevronLeft" size={22} color={dark ? '#fff' : C.ink} strokeWidth={2.2} />
      </button>
    ) : <div style={{ width: 4 }} />}
    <div style={{
      flex: 1, fontFamily: T.ui, fontSize: 19, fontWeight: 600,
      color: dark ? '#fff' : C.ink, letterSpacing: -0.2,
    }}>{title}</div>
    {right || null}
  </div>
);

// ─────────────────────────────────────────────────────────────
// Primary button — large for older users (56px)
// ─────────────────────────────────────────────────────────────
const Button = ({ children, onClick, disabled, variant = 'primary', size = 'lg', icon, fullWidth = true, style = {} }) => {
  const sizes = { lg: { h: 56, fs: 18 }, md: { h: 48, fs: 16 }, sm: { h: 40, fs: 14 } };
  const sz = sizes[size];
  const variants = {
    primary: {
      background: disabled ? '#D7C9B6' : C.brand,
      color: '#fff',
      boxShadow: disabled ? 'none' : '0 6px 16px rgba(179,58,32,0.28), inset 0 1px 0 rgba(255,255,255,0.15)',
    },
    secondary: {
      background: C.surface,
      color: C.ink,
      boxShadow: 'inset 0 0 0 1.5px ' + C.border,
    },
    ghost: {
      background: 'transparent', color: C.brand,
    },
    dark: {
      background: C.ink, color: '#fff',
      boxShadow: '0 6px 16px rgba(26,20,16,0.22)',
    }
  };
  return (
    <button onClick={onClick} disabled={disabled} style={{
      width: fullWidth ? '100%' : 'auto',
      height: sz.h, padding: '0 24px', borderRadius: 16, border: 'none',
      fontFamily: T.ui, fontSize: sz.fs, fontWeight: 600, letterSpacing: -0.1,
      display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: 10,
      cursor: disabled ? 'default' : 'pointer',
      transition: 'transform 0.12s ease',
      ...variants[variant], ...style,
    }}>
      {children}
      {icon && <Icon name={icon} size={20} color="currentColor" strokeWidth={2} />}
    </button>
  );
};

// ─────────────────────────────────────────────────────────────
// Bottom tab bar — 3 large tabs
// ─────────────────────────────────────────────────────────────
const BottomNav = ({ active, onChange }) => {
  const tabs = [
    { id: 'home',    label: 'Home',    icon: 'home',    iconFill: 'homeFill' },
    { id: 'explore', label: 'Explore', icon: 'compass', iconFill: 'compassFill' },
    { id: 'profile', label: 'You',     icon: 'user',    iconFill: 'userFill' },
  ];
  return (
    <div style={{
      position: 'absolute', bottom: 0, left: 0, right: 0, zIndex: 30,
      background: C.tabBg,
      borderTop: '0.5px solid ' + C.divider,
      paddingBottom: 28, paddingTop: 8,
      display: 'flex', justifyContent: 'space-around',
      boxShadow: '0 -4px 16px rgba(26,20,16,0.04)',
    }}>
      {tabs.map(t => {
        const on = active === t.id;
        return (
          <button key={t.id} onClick={() => onChange(t.id)} style={{
            flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center',
            gap: 4, background: 'none', border: 'none', cursor: 'pointer',
            padding: '8px 0',
          }}>
            <Icon name={on ? t.iconFill : t.icon} size={24}
                  color={on ? C.tabActive : C.tabIdle} strokeWidth={1.8}/>
            <span style={{
              fontFamily: T.ui, fontSize: 11, fontWeight: on ? 700 : 500,
              color: on ? C.tabActive : C.tabIdle, letterSpacing: 0.1,
            }}>{t.label}</span>
          </button>
        );
      })}
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// Quote card — photo-first, 9:16, bottom protection gradient
// ─────────────────────────────────────────────────────────────
const QuoteCard = ({ card, size = 'feed', userPhoto, caption, footerName = 'Daily Katha' }) => {
  // sizes: feed (full), hero (scaled), mini, micro
  const ratios = {
    feed:  { w: '100%',  fs: 26, lh: 1.32, pad: 28, br: 28, mark: 13, attr: 14, capH: 52 },
    hero:  { w: '100%',  fs: 24, lh: 1.30, pad: 22, br: 22, mark: 12, attr: 13, capH: 46 },
    mini:  { w: 168,     fs: 13, lh: 1.30, pad: 14, br: 18, mark: 9,  attr: 10, capH: 30 },
    micro: { w: 104,     fs: 10, lh: 1.28, pad: 9,  br: 14, mark: 7,  attr: 8,  capH: 24 },
  };
  const r = ratios[size];
  const palette = CAT[card.cat] || CAT.bhakti;
  const photo = userPhoto || card.photo;

  return (
    <div style={{
      width: r.w, aspectRatio: '9 / 16', borderRadius: r.br,
      position: 'relative', overflow: 'hidden',
      background: palette.bg,
      boxShadow: size === 'mini' ? SH.md : (size === 'micro' ? SH.sm : SH.card),
      flexShrink: 0,
    }}>
      {/* photo */}
      {photo && (
        <img src={photo} alt="" style={{
          position: 'absolute', inset: 0, width: '100%', height: '100%',
          objectFit: 'cover', filter: 'saturate(0.92) contrast(1.05)',
        }} />
      )}
      {/* dim overlay for readability */}
      <div style={{
        position: 'absolute', inset: 0,
        background: 'linear-gradient(180deg, rgba(0,0,0,0.32) 0%, rgba(0,0,0,0) 24%, rgba(0,0,0,0) 50%, rgba(0,0,0,0.55) 80%, rgba(0,0,0,0.78) 100%)',
      }} />
      {/* festival badge */}
      {card.festival && size !== 'micro' && (
        <div style={{
          position: 'absolute', top: r.pad, left: r.pad,
          padding: '6px 11px', borderRadius: 999,
          background: 'rgba(255,255,255,0.92)', color: palette.bg,
          fontFamily: T.ui, fontSize: r.attr - 2, fontWeight: 700, letterSpacing: 0.5,
          textTransform: 'uppercase',
        }}>{card.festival}</div>
      )}
      {/* wordmark top right */}
      {size !== 'micro' && (
        <div style={{
          position: 'absolute', top: r.pad, right: r.pad,
          fontFamily: T.display, fontSize: r.mark, color: 'rgba(255,255,255,0.85)',
          fontStyle: 'italic', letterSpacing: 0.3, textAlign: 'right',
        }}>
          <span style={{ display: 'block', fontFamily: T.ui, fontSize: r.mark - 2, letterSpacing: 1.5, fontWeight: 600, textTransform: 'uppercase', opacity: 0.7 }}>Daily</span>
          <span style={{ display: 'block', marginTop: -1 }}>Katha</span>
        </div>
      )}
      {/* caption (user-written) */}
      {caption && size !== 'micro' && (
        <div style={{
          position: 'absolute', top: r.pad + r.capH, right: r.pad, left: r.pad,
          fontFamily: T.ui, fontSize: r.attr, fontWeight: 500,
          color: '#fff', textAlign: 'right', textShadow: '0 1px 4px rgba(0,0,0,0.4)',
        }}>{caption}</div>
      )}
      {/* quote */}
      <div style={{
        position: 'absolute', bottom: r.pad + (size === 'feed' ? 36 : 22),
        left: r.pad, right: r.pad,
      }}>
        <div style={{
          fontFamily: T.display, fontSize: r.fs, lineHeight: r.lh,
          color: '#fff', fontWeight: 500, whiteSpace: 'pre-line',
          letterSpacing: -0.1, textShadow: '0 1px 8px rgba(0,0,0,0.25)',
        }}>{card.quote}</div>
        {size !== 'micro' && (
          <div style={{
            marginTop: size === 'mini' ? 6 : 12,
            fontFamily: T.ui, fontSize: r.attr,
            color: palette.accent, fontWeight: 500, letterSpacing: 0.2,
          }}>{card.author}</div>
        )}
      </div>
      {/* bottom-right footer signature */}
      {size === 'feed' && (
        <div style={{
          position: 'absolute', bottom: r.pad - 4, right: r.pad,
          display: 'flex', alignItems: 'center', gap: 6,
          fontFamily: T.ui, fontSize: 11, color: 'rgba(255,255,255,0.65)',
          letterSpacing: 1.5, textTransform: 'uppercase', fontWeight: 600,
        }}>
          <span style={{ width: 4, height: 4, borderRadius: 4, background: palette.accent }} />
          {footerName}
        </div>
      )}
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// Mini card with optional blur lock
// ─────────────────────────────────────────────────────────────
const MiniCard = ({ card, blurred, onClick, size = 'mini' }) => (
  <button onClick={onClick} style={{
    background: 'none', border: 'none', padding: 0, cursor: 'pointer',
    position: 'relative', display: 'block',
  }}>
    <QuoteCard card={card} size={size} />
    {blurred && (
      <>
        <div style={{
          position: 'absolute', inset: 0, borderRadius: size === 'mini' ? 18 : 14,
          backdropFilter: 'blur(8px) saturate(0.85)',
          WebkitBackdropFilter: 'blur(8px) saturate(0.85)',
          background: 'rgba(26,20,16,0.18)',
        }} />
        <div style={{
          position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%,-50%)',
          width: 36, height: 36, borderRadius: 36, background: 'rgba(255,255,255,0.92)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 4px 12px rgba(0,0,0,0.18)',
        }}>
          <Icon name="sparkle" size={18} color={C.brand} strokeWidth={2} />
        </div>
      </>
    )}
  </button>
);

Object.assign(window, {
  Icon, Header, Button, BottomNav, QuoteCard, MiniCard,
});
