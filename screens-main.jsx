// Main app screens: Home, Explore, Profile, Saved
const { color: MC, type: MT, cat: MCAT, shadow: MSH } = window.DK;

// ─────────────────────────────────────────────────────────────
// Section header (used on Home + Explore)
// ─────────────────────────────────────────────────────────────
const SectionHead = ({ title, sub, action, onAction }) => (
  <div style={{
    display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between',
    padding: '4px 20px 10px',
  }}>
    <div>
      <div style={{ fontFamily: MT.display, fontSize: 22, fontWeight: 500, color: MC.ink, letterSpacing: -0.2, lineHeight: 1.15 }}>
        {title}
      </div>
      {sub && <div style={{ fontFamily: MT.ui, fontSize: 12, color: MC.ink3, marginTop: 2, letterSpacing: 0.1 }}>{sub}</div>}
    </div>
    {action && (
      <button onClick={onAction} style={{
        background: 'none', border: 'none', cursor: 'pointer',
        fontFamily: MT.ui, fontSize: 13, fontWeight: 600, color: MC.brand,
        display: 'flex', alignItems: 'center', gap: 4,
      }}>{action}<Icon name="chevronRight" size={14} color={MC.brand} strokeWidth={2.4}/></button>
    )}
  </div>
);

// ─────────────────────────────────────────────────────────────
// Home — top hero (1 today's card) + rails
// ─────────────────────────────────────────────────────────────
const HomeScreen = ({ user, onOpenSection, onOpenCard }) => {
  const greeting = (() => {
    const h = new Date().getHours();
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    return 'Good evening';
  })();
  // Today's hero card
  const heroCard = window.DK.cards.find(c => user.interests.includes(c.cat)) || window.DK.cards[0];
  // Rails: one per user interest
  const railFor = (interest) =>
    window.DK.cards.filter(c => c.cat === interest);
  // Today's pick (festival highlighted card)
  const festival = window.DK.cards.find(c => c.cat === 'festival');

  return (
    <div style={{ position: 'absolute', inset: 0, paddingBottom: 84, overflow: 'auto', background: MC.cream }}>
      {/* greeting bar */}
      <div style={{
        padding: '54px 20px 14px', display: 'flex', alignItems: 'center', gap: 12,
        background: 'linear-gradient(180deg, #FBF6EC 0%, #FBF6EC 100%)',
      }}>
        <div style={{ flex: 1 }}>
          <div style={{ fontFamily: MT.ui, fontSize: 12, color: MC.ink3, letterSpacing: 1.5, fontWeight: 600, textTransform: 'uppercase' }}>
            Tuesday · 5 May
          </div>
          <div style={{ fontFamily: MT.display, fontSize: 26, fontWeight: 500, color: MC.ink, letterSpacing: -0.3, marginTop: 2 }}>
            {greeting}
          </div>
        </div>
        <button style={{
          width: 44, height: 44, borderRadius: 22, border: 'none', background: MC.surface,
          boxShadow: 'inset 0 0 0 1px ' + MC.border,
          display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer', position: 'relative',
        }}>
          <Icon name="bell" size={20} color={MC.ink} strokeWidth={1.8} />
          <span style={{ position: 'absolute', top: 10, right: 12, width: 8, height: 8, borderRadius: 4, background: MC.brand, border: '1.5px solid #fff' }} />
        </button>
      </div>

      {/* Today section — single hero card big + share */}
      <div style={{ padding: '4px 20px 24px' }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 12 }}>
          <div style={{ fontFamily: MT.ui, fontSize: 12, fontWeight: 700, letterSpacing: 2, color: MC.brand, textTransform: 'uppercase' }}>
            Your card today
          </div>
          <div style={{ fontFamily: MT.ui, fontSize: 11, color: MC.ink3, display: 'flex', alignItems: 'center', gap: 4 }}>
            <Icon name="streak" size={12} color={MC.saffron} strokeWidth={2} />
            <span style={{ fontWeight: 600 }}>5-day streak</span>
          </div>
        </div>
        <div style={{ position: 'relative' }}>
          <button onClick={() => onOpenCard(heroCard)} style={{ background: 'none', border: 'none', padding: 0, cursor: 'pointer', display: 'block', width: '100%' }}>
            <div style={{ width: '64%', margin: '0 auto' }}>
              <QuoteCard card={heroCard} size="hero" />
            </div>
          </button>
        </div>
        <div style={{ display: 'flex', gap: 10, marginTop: 18, padding: '0 4px' }}>
          <Button size="md" variant="primary" icon="share" onClick={() => onOpenCard(heroCard)}>Share to Status</Button>
          <button style={{
            width: 56, height: 48, borderRadius: 14, border: 'none', cursor: 'pointer',
            background: MC.surface, boxShadow: 'inset 0 0 0 1.5px ' + MC.border,
            display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
          }}>
            <Icon name="save" size={20} color={MC.ink} strokeWidth={1.8} />
          </button>
        </div>
      </div>

      {/* Rails — one per interest */}
      {user.interests.map(interest => {
        const cards = railFor(interest);
        if (cards.length === 0) return null;
        const meta = MCAT[interest] || {};
        return (
          <div key={interest} style={{ marginBottom: 24 }}>
            <SectionHead
              title={meta.label || interest}
              sub={`${cards.length} new today`}
              action="View all"
              onAction={() => onOpenSection(interest)}
            />
            <div style={{
              display: 'flex', gap: 12, overflowX: 'auto', padding: '0 20px 4px',
              scrollbarWidth: 'none', WebkitOverflowScrolling: 'touch',
            }}>
              {cards.map((c, i) => (
                <MiniCard key={c.id} card={c} blurred={i !== 0} onClick={() => i === 0 ? onOpenCard(c) : onOpenSection(interest)} />
              ))}
            </div>
          </div>
        );
      })}

      {/* Trending */}
      <div style={{ marginBottom: 12 }}>
        <SectionHead title="Trending today" sub="What India is sharing" action="View all" onAction={() => onOpenSection('trending')} />
        <div style={{
          display: 'flex', gap: 12, overflowX: 'auto', padding: '0 20px 4px',
          scrollbarWidth: 'none', WebkitOverflowScrolling: 'touch',
        }}>
          {window.DK.cards.slice(4, 9).map((c, i) => (
            <MiniCard key={c.id} card={c} blurred={i !== 0} onClick={() => i === 0 ? onOpenCard(c) : onOpenSection('trending')} />
          ))}
        </div>
      </div>

      <div style={{ height: 24 }} />
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// Section preview — one full card visible, rest blurred grid
// ─────────────────────────────────────────────────────────────
const SectionPreviewScreen = ({ section, cards, onBack, onOpenAll, onOpenCard }) => {
  const [hero, ...rest] = cards;
  const meta = MCAT[section] || { label: section, accent: MC.brand, bg: MC.brand };
  return (
    <div style={{ position: 'absolute', inset: 0, background: MC.cream, paddingBottom: 84, overflow: 'auto' }}>
      <Header title={meta.label || section} onBack={onBack} />
      <div style={{ padding: '4px 20px 16px' }}>
        <div style={{ fontFamily: MT.ui, fontSize: 13, color: MC.ink3, lineHeight: 1.4 }}>
          A clean line for today, then more behind a tap.
        </div>
      </div>
      <div style={{ padding: '0 20px' }}>
        <div style={{ width: '78%', margin: '0 auto' }}>
          <button onClick={() => onOpenCard(hero)} style={{ background: 'none', border: 'none', padding: 0, cursor: 'pointer', display: 'block', width: '100%' }}>
            <QuoteCard card={hero} size="hero" />
          </button>
        </div>
        <div style={{ display: 'flex', gap: 10, marginTop: 18, padding: '0 4px' }}>
          <Button size="md" variant="primary" icon="arrowRight" onClick={onOpenAll}>Open all {cards.length} cards</Button>
        </div>
      </div>
      <div style={{ padding: '24px 20px 8px' }}>
        <SectionHead title="Also today" sub={`${rest.length} more in this section`} />
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12, padding: '0 0 6px' }}>
          {rest.map(c => (
            <div key={c.id} style={{ width: '100%' }}>
              <MiniCard card={c} blurred onClick={onOpenAll} size="mini" />
            </div>
          ))}
        </div>
      </div>
      <div style={{ height: 12 }} />
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// Explore — Search, festival pack, categories grid, packs
// ─────────────────────────────────────────────────────────────
const ExploreScreen = ({ onOpenCard, onOpenSection, onOpenPack }) => {
  return (
    <div style={{ position: 'absolute', inset: 0, background: MC.cream, paddingBottom: 84, overflow: 'auto' }}>
      <div style={{ padding: '54px 20px 16px' }}>
        <div style={{
          fontFamily: MT.display, fontSize: 30, fontWeight: 500, color: MC.ink, letterSpacing: -0.4,
        }}>Explore</div>
        <div style={{ fontFamily: MT.ui, fontSize: 14, color: MC.ink3, marginTop: 4 }}>
          Festival packs, themes, and what's trending.
        </div>
      </div>
      {/* Search */}
      <div style={{ padding: '0 20px 18px' }}>
        <div style={{
          height: 52, borderRadius: 16, background: MC.surface, display: 'flex', alignItems: 'center',
          padding: '0 14px', gap: 10, boxShadow: 'inset 0 0 0 1px ' + MC.border,
        }}>
          <Icon name="search" size={20} color={MC.ink3} strokeWidth={1.8}/>
          <div style={{ flex: 1, fontFamily: MT.ui, fontSize: 16, color: MC.ink3 }}>Search greetings, festivals, names…</div>
        </div>
      </div>
      {/* Featured pack — full hero */}
      <div style={{ padding: '0 20px 24px' }}>
        <button onClick={() => onOpenPack('ugadi')} style={{
          width: '100%', height: 168, borderRadius: 22, border: 'none', cursor: 'pointer',
          background: 'linear-gradient(135deg, #7E1F0E 0%, #B33A20 60%, #E89B2C 130%)',
          padding: 22, display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
          textAlign: 'left', position: 'relative', overflow: 'hidden',
          boxShadow: '0 16px 32px rgba(126,31,14,0.22)',
        }}>
          {/* decorative marigold dots */}
          <div style={{ position: 'absolute', top: -20, right: -20, width: 140, height: 140, borderRadius: '50%', background: 'radial-gradient(circle, rgba(255,221,133,0.35) 0%, rgba(255,221,133,0) 65%)' }}/>
          <div style={{
            display: 'inline-flex', alignSelf: 'flex-start', padding: '5px 11px', borderRadius: 999,
            background: 'rgba(255,255,255,0.18)', backdropFilter: 'blur(10px)',
            fontFamily: MT.ui, fontSize: 10, fontWeight: 700, letterSpacing: 2, color: '#fff', textTransform: 'uppercase',
          }}>Festival Pack · Live</div>
          <div>
            <div style={{ fontFamily: MT.display, fontSize: 28, fontWeight: 500, color: '#fff', letterSpacing: -0.3, lineHeight: 1.1 }}>
              Ugadi greetings
            </div>
            <div style={{ fontFamily: MT.ui, fontSize: 13, color: 'rgba(255,255,255,0.78)', marginTop: 6, fontWeight: 500 }}>
              12 cards · refreshed daily until 14 May
            </div>
          </div>
        </button>
      </div>
      {/* Categories grid */}
      <SectionHead title="By interest" sub="Tap to browse" />
      <div style={{ padding: '0 20px 24px' }}>
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 10 }}>
          {window.DK.interests.slice(0, 9).map(i => {
            const p = MCAT[i.id] || { bg: MC.ink, accent: MC.saffron };
            return (
              <button key={i.id} onClick={() => onOpenSection(i.id)} style={{
                aspectRatio: '1', borderRadius: 16, border: 'none', cursor: 'pointer',
                background: p.bg, position: 'relative', padding: 12,
                display: 'flex', flexDirection: 'column', justifyContent: 'space-between', textAlign: 'left',
                boxShadow: '0 4px 10px ' + p.bg + '20',
              }}>
                <div style={{ fontSize: 22, lineHeight: 1 }}>{i.emoji}</div>
                <div style={{
                  fontFamily: MT.ui, fontSize: 13, fontWeight: 700, color: '#fff', letterSpacing: -0.1,
                }}>{i.label}</div>
              </button>
            );
          })}
        </div>
      </div>
      {/* Themes (mood-based packs) */}
      <SectionHead title="Curated packs" sub="Hand-picked sets you can save" />
      <div style={{ padding: '0 20px 32px', display: 'flex', flexDirection: 'column', gap: 10 }}>
        {[
          { id: 'monday',  title: 'Monday strength',     sub: '8 motivation cards · for the week ahead', cat: 'motivation' },
          { id: 'mom',     title: "Mother's Day",         sub: '10 cards · for the woman who started it all', cat: 'family' },
          { id: 'evening', title: 'Quiet evenings',       sub: '6 cards · slow down with these', cat: 'goodnight' },
        ].map(p => {
          const palette = MCAT[p.cat];
          return (
            <button key={p.id} onClick={() => onOpenPack(p.id)} style={{
              display: 'flex', gap: 14, alignItems: 'center', padding: 12, borderRadius: 16,
              background: MC.surface, border: 'none', cursor: 'pointer', textAlign: 'left',
              boxShadow: 'inset 0 0 0 1px ' + MC.border,
            }}>
              <div style={{
                width: 56, height: 76, borderRadius: 12, flexShrink: 0,
                background: palette.bg, position: 'relative', overflow: 'hidden',
              }}>
                <div style={{
                  position: 'absolute', inset: 0,
                  background: 'linear-gradient(180deg, transparent 50%, rgba(0,0,0,0.4) 100%)',
                }}/>
                <div style={{ position: 'absolute', bottom: 5, left: 7, right: 7, fontFamily: MT.display, fontSize: 9, color: '#fff', lineHeight: 1.1 }}>
                  Aa
                </div>
              </div>
              <div style={{ flex: 1 }}>
                <div style={{ fontFamily: MT.ui, fontSize: 15, fontWeight: 600, color: MC.ink, letterSpacing: -0.1 }}>{p.title}</div>
                <div style={{ fontFamily: MT.ui, fontSize: 12, color: MC.ink3, marginTop: 3 }}>{p.sub}</div>
              </div>
              <Icon name="chevronRight" size={18} color={MC.ink4} strokeWidth={2}/>
            </button>
          );
        })}
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// Profile — saved + edits + settings
// ─────────────────────────────────────────────────────────────
const ProfileScreen = ({ user, onOpenSaved, onOpenEdits, onEditInterests, onEditLanguage, onEditReligion }) => {
  const langName = (window.DK.languages.find(l => l.id === user.language) || {}).native || '—';
  const relName  = (window.DK.religions.find(r => r.id === user.religion) || {}).label || '—';
  return (
    <div style={{ position: 'absolute', inset: 0, background: MC.cream, paddingBottom: 84, overflow: 'auto' }}>
      <div style={{ padding: '54px 20px 8px' }}>
        <div style={{ fontFamily: MT.display, fontSize: 30, fontWeight: 500, color: MC.ink, letterSpacing: -0.4 }}>You</div>
      </div>
      {/* Streak hero */}
      <div style={{ padding: '12px 20px 18px' }}>
        <div style={{
          padding: 18, borderRadius: 20,
          background: 'linear-gradient(135deg, #1A1410 0%, #3A2A1F 100%)',
          color: '#fff', display: 'flex', alignItems: 'center', gap: 16,
        }}>
          <div style={{
            width: 64, height: 64, borderRadius: 32,
            background: 'linear-gradient(135deg, #E89B2C 0%, #B33A20 100%)',
            display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
            boxShadow: '0 6px 18px rgba(232,155,44,0.45)',
          }}>
            <Icon name="streak" size={30} color="#fff" strokeWidth={1.8}/>
          </div>
          <div style={{ flex: 1 }}>
            <div style={{ fontFamily: MT.display, fontSize: 28, fontWeight: 500, letterSpacing: -0.3, lineHeight: 1 }}>5 days</div>
            <div style={{ fontFamily: MT.ui, fontSize: 13, color: 'rgba(255,255,255,0.7)', marginTop: 4, lineHeight: 1.3 }}>
              You've sent a card<br/>every day this week.
            </div>
          </div>
        </div>
      </div>
      {/* Quick stats */}
      <div style={{ padding: '0 20px 22px', display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: 8 }}>
        {[
          { n: 12, l: 'Saved' },
          { n: 4,  l: 'My edits' },
          { n: 23, l: 'Shared' },
        ].map(s => (
          <div key={s.l} style={{
            background: MC.surface, borderRadius: 14, padding: '14px 12px',
            boxShadow: 'inset 0 0 0 1px ' + MC.border, textAlign: 'center',
          }}>
            <div style={{ fontFamily: MT.display, fontSize: 24, fontWeight: 500, color: MC.ink, lineHeight: 1 }}>{s.n}</div>
            <div style={{ fontFamily: MT.ui, fontSize: 11, color: MC.ink3, marginTop: 4, fontWeight: 500, letterSpacing: 0.3, textTransform: 'uppercase' }}>{s.l}</div>
          </div>
        ))}
      </div>
      {/* Library */}
      <div style={{ padding: '0 20px 8px', fontFamily: MT.ui, fontSize: 11, fontWeight: 700, letterSpacing: 2, color: MC.ink3, textTransform: 'uppercase' }}>
        Library
      </div>
      <ProfileRow icon="heartFill" iconBg="#FFE4DC" iconColor={MC.brand} title="Saved cards" sub="12 cards" onClick={onOpenSaved} />
      <ProfileRow icon="edit" iconBg="#FFF1D9" iconColor={MC.saffron} title="My edits" sub="4 cards with your photos" onClick={onOpenEdits} />
      <div style={{ height: 18 }}/>
      <div style={{ padding: '0 20px 8px', fontFamily: MT.ui, fontSize: 11, fontWeight: 700, letterSpacing: 2, color: MC.ink3, textTransform: 'uppercase' }}>
        Preferences
      </div>
      <ProfileRow icon="text" iconBg="#EAE3D2" iconColor={MC.ink2} title="Language" sub={langName} onClick={onEditLanguage} />
      <ProfileRow icon="sparkle" iconBg="#EAE3D2" iconColor={MC.ink2} title="Path / tradition" sub={relName} onClick={onEditReligion} />
      <ProfileRow icon="sliders" iconBg="#EAE3D2" iconColor={MC.ink2} title="Your interests" sub={`${user.interests.length} selected`} onClick={onEditInterests} />
      <div style={{ height: 18 }}/>
      <div style={{ padding: '0 20px 8px', fontFamily: MT.ui, fontSize: 11, fontWeight: 700, letterSpacing: 2, color: MC.ink3, textTransform: 'uppercase' }}>
        About
      </div>
      <ProfileRow icon="bell"     iconBg="#EAE3D2" iconColor={MC.ink2} title="Daily reminder" sub="7:00 AM" />
      <ProfileRow icon="settings" iconBg="#EAE3D2" iconColor={MC.ink2} title="Settings" />
      <div style={{ padding: '20px 20px 12px', textAlign: 'center', fontFamily: MT.ui, fontSize: 11, color: MC.ink4, letterSpacing: 1 }}>
        Daily Katha · v1.0
      </div>
    </div>
  );
};

const ProfileRow = ({ icon, iconBg, iconColor, title, sub, onClick }) => (
  <button onClick={onClick} style={{
    display: 'flex', alignItems: 'center', gap: 14,
    width: 'calc(100% - 32px)', margin: '0 16px 8px', padding: '14px 14px',
    background: MC.surface, border: 'none', borderRadius: 16, cursor: 'pointer', textAlign: 'left',
    boxShadow: 'inset 0 0 0 1px ' + MC.border,
  }}>
    <div style={{
      width: 40, height: 40, borderRadius: 12, background: iconBg,
      display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
    }}>
      <Icon name={icon} size={20} color={iconColor} strokeWidth={1.8} />
    </div>
    <div style={{ flex: 1 }}>
      <div style={{ fontFamily: MT.ui, fontSize: 16, fontWeight: 600, color: MC.ink, letterSpacing: -0.1 }}>{title}</div>
      {sub && <div style={{ fontFamily: MT.ui, fontSize: 12, color: MC.ink3, marginTop: 2 }}>{sub}</div>}
    </div>
    <Icon name="chevronRight" size={18} color={MC.ink4} strokeWidth={2}/>
  </button>
);

// ─────────────────────────────────────────────────────────────
// Saved screen — grid of saved cards
// ─────────────────────────────────────────────────────────────
const SavedScreen = ({ onBack, onOpenCard }) => {
  const saved = window.DK.cards.slice(0, 8);
  return (
    <div style={{ position: 'absolute', inset: 0, background: MC.cream, paddingBottom: 24, overflow: 'auto' }}>
      <Header title="Saved cards" onBack={onBack} />
      <div style={{ padding: '0 20px 12px', fontFamily: MT.ui, fontSize: 13, color: MC.ink3 }}>
        {saved.length} cards · tap any card to share again.
      </div>
      <div style={{ padding: '4px 20px 12px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
        {saved.map(c => (
          <MiniCard key={c.id} card={c} onClick={() => onOpenCard(c)} />
        ))}
      </div>
    </div>
  );
};

Object.assign(window, {
  HomeScreen, SectionPreviewScreen, ExploreScreen, ProfileScreen, SavedScreen,
});
