// Feed (vertical card scroll), Editor, Festival pack
const { color: FC, type: FT, cat: FCAT } = window.DK;

// ─────────────────────────────────────────────────────────────
// Feed — vertical PageView of full cards with side actions
// ─────────────────────────────────────────────────────────────
const FeedScreen = ({ cards, startIndex = 0, onBack, onEdit }) => {
  const [idx, setIdx] = React.useState(startIndex);
  const [liked, setLiked] = React.useState({});
  const [saved, setSaved] = React.useState({});
  const card = cards[idx];
  const next = () => setIdx(Math.min(cards.length - 1, idx + 1));
  const prev = () => setIdx(Math.max(0, idx - 1));
  const toggle = (set, id) => set(s => ({ ...s, [id]: !s[id] }));

  return (
    <div style={{ position: 'absolute', inset: 0, background: '#0A0807', overflow: 'hidden' }}>
      {/* Top chrome */}
      <div style={{
        position: 'absolute', top: 0, left: 0, right: 0, zIndex: 5,
        padding: '54px 16px 16px', display: 'flex', alignItems: 'center', gap: 12,
        background: 'linear-gradient(180deg, rgba(0,0,0,0.55) 0%, rgba(0,0,0,0) 100%)',
      }}>
        <button onClick={onBack} style={{
          width: 40, height: 40, borderRadius: 20, border: 'none',
          background: 'rgba(255,255,255,0.14)', backdropFilter: 'blur(12px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
        }}>
          <Icon name="chevronLeft" size={20} color="#fff" strokeWidth={2.2} />
        </button>
        <div style={{ flex: 1, textAlign: 'center' }}>
          <div style={{ fontFamily: FT.ui, fontSize: 11, fontWeight: 700, letterSpacing: 2, color: 'rgba(255,255,255,0.6)', textTransform: 'uppercase' }}>
            Feed
          </div>
          <div style={{ fontFamily: FT.ui, fontSize: 14, fontWeight: 600, color: '#fff', marginTop: 2 }}>
            {idx + 1} of {cards.length}
          </div>
        </div>
        <button style={{
          width: 40, height: 40, borderRadius: 20, border: 'none',
          background: 'rgba(255,255,255,0.14)', backdropFilter: 'blur(12px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
        }}>
          <Icon name="search" size={18} color="#fff" strokeWidth={2}/>
        </button>
      </div>

      {/* Card */}
      <div style={{
        position: 'absolute', top: 96, bottom: 116, left: 16, right: 76,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <div style={{ width: '100%', maxHeight: '100%', display: 'flex', justifyContent: 'center' }}>
          <QuoteCard card={card} size="feed" />
        </div>
      </div>

      {/* Side action rail */}
      <div style={{
        position: 'absolute', right: 12, top: '50%', transform: 'translateY(-50%)',
        display: 'flex', flexDirection: 'column', gap: 12,
      }}>
        <FeedAction icon={liked[card.id] ? 'heartFill' : 'heart'} active={liked[card.id]} label={liked[card.id] ? 'Liked' : 'Like'} onClick={() => toggle(setLiked, card.id)} accent="#FF5A6E" />
        <FeedAction icon={saved[card.id] ? 'saveFill' : 'save'} active={saved[card.id]} label={saved[card.id] ? 'Saved' : 'Save'} onClick={() => toggle(setSaved, card.id)} accent={FC.saffron}/>
        <FeedAction icon="edit"  label="Edit"   onClick={() => onEdit(card)} accent="#FFF" />
        <FeedAction icon="share" label="Share"  onClick={() => onEdit(card)} accent="#FFF" />
      </div>

      {/* Bottom share-to-status bar */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0, padding: '14px 16px 28px',
        background: 'linear-gradient(0deg, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0) 100%)',
        display: 'flex', gap: 10,
      }}>
        <Button size="md" variant="primary" icon="share" onClick={() => onEdit(card)}>
          Share to WhatsApp Status
        </Button>
        <button onClick={() => onEdit(card)} style={{
          width: 56, height: 48, borderRadius: 14, border: 'none', cursor: 'pointer',
          background: 'rgba(255,255,255,0.14)', backdropFilter: 'blur(12px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
          boxShadow: 'inset 0 0 0 1px rgba(255,255,255,0.18)',
        }}>
          <Icon name="photo" size={20} color="#fff" strokeWidth={1.8} />
        </button>
      </div>

      {/* Page dots */}
      <div style={{
        position: 'absolute', left: 16, top: '50%', transform: 'translateY(-50%)',
        display: 'flex', flexDirection: 'column', gap: 6,
      }}>
        {cards.map((_, i) => (
          <button key={i} onClick={() => setIdx(i)} style={{
            width: 4, height: i === idx ? 22 : 4, borderRadius: 4, border: 'none',
            background: i === idx ? '#fff' : 'rgba(255,255,255,0.32)',
            cursor: 'pointer', padding: 0, transition: 'all 0.2s ease',
          }}/>
        ))}
      </div>

      {/* Up/Down nav buttons */}
      <button onClick={prev} disabled={idx===0} style={{
        position: 'absolute', top: 70, right: 16, width: 32, height: 28, borderRadius: 14,
        background: 'rgba(255,255,255,0.10)', border: 'none', cursor: 'pointer',
        display: 'flex', alignItems: 'center', justifyContent: 'center', opacity: idx === 0 ? 0.3 : 1,
      }}>
        <Icon name="chevronDown" size={16} color="#fff" strokeWidth={2}/>
        <div style={{ position: 'absolute' }}>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#fff" strokeWidth="2.2" strokeLinecap="round" strokeLinejoin="round" style={{transform:'rotate(180deg)'}}><path d="M5 9l7 7 7-7"/></svg>
        </div>
      </button>
    </div>
  );
};

const FeedAction = ({ icon, label, onClick, active, accent }) => (
  <button onClick={onClick} style={{
    width: 56, background: 'none', border: 'none', cursor: 'pointer',
    display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4, padding: 0,
  }}>
    <div style={{
      width: 44, height: 44, borderRadius: 22,
      background: active ? 'rgba(255,255,255,0.95)' : 'rgba(255,255,255,0.14)',
      backdropFilter: 'blur(14px)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      boxShadow: 'inset 0 0 0 1px rgba(255,255,255,0.16)',
    }}>
      <Icon name={icon} size={20} color={active ? accent : '#fff'} strokeWidth={1.9} />
    </div>
    <span style={{ fontFamily: FT.ui, fontSize: 10, fontWeight: 600, color: '#fff', letterSpacing: 0.2 }}>{label}</span>
  </button>
);

// ─────────────────────────────────────────────────────────────
// Editor — add photo + caption + share
// ─────────────────────────────────────────────────────────────
const EditorScreen = ({ card, onBack, onShare }) => {
  const [photo, setPhoto] = React.useState(card.photo);
  const [caption, setCaption] = React.useState('');
  const [tab, setTab] = React.useState('photo');
  const swatches = [
    'https://images.unsplash.com/photo-1506260408121-e353d10b87c7?w=600&q=80',
    'https://images.unsplash.com/photo-1604608672516-f1b9b1cb5f6f?w=600&q=80',
    'https://images.unsplash.com/photo-1605197788044-5d2c64a04c47?w=600&q=80',
    'https://images.unsplash.com/photo-1518622358385-8ea7d0794bf6?w=600&q=80',
    'https://images.unsplash.com/photo-1518002171953-a080ee817e1f?w=600&q=80',
    'https://images.unsplash.com/photo-1532978879514-6cb1a3f0a1c1?w=600&q=80',
  ];
  return (
    <div style={{ position: 'absolute', inset: 0, background: '#0E0B09', overflow: 'hidden', display: 'flex', flexDirection: 'column' }}>
      {/* Top */}
      <div style={{
        paddingTop: 54, padding: '54px 16px 14px', display: 'flex', alignItems: 'center', gap: 12,
      }}>
        <button onClick={onBack} style={{
          width: 40, height: 40, borderRadius: 20, border: 'none',
          background: 'rgba(255,255,255,0.10)', cursor: 'pointer',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>
          <Icon name="close" size={20} color="#fff" strokeWidth={2.2}/>
        </button>
        <div style={{ flex: 1, fontFamily: FT.ui, fontSize: 16, fontWeight: 600, color: '#fff', textAlign: 'center' }}>
          Make it yours
        </div>
        <button style={{
          height: 40, padding: '0 14px', borderRadius: 20, border: 'none', cursor: 'pointer',
          background: 'rgba(255,255,255,0.14)', color: '#fff',
          fontFamily: FT.ui, fontSize: 13, fontWeight: 600, display: 'flex', alignItems: 'center', gap: 6,
        }}>
          <Icon name="rotate" size={14} color="#fff" strokeWidth={2}/> Reset
        </button>
      </div>
      {/* Card preview */}
      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '4px 24px' }}>
        <div style={{ width: '64%' }}>
          <QuoteCard card={{ ...card, photo }} caption={caption || null} size="hero" />
        </div>
      </div>

      {/* Tabs */}
      <div style={{ display: 'flex', gap: 6, padding: '0 16px 12px', justifyContent: 'center' }}>
        {[
          { id: 'photo',   label: 'Photo',   icon: 'photo' },
          { id: 'caption', label: 'Caption', icon: 'text'  },
          { id: 'style',   label: 'Style',   icon: 'sliders' },
        ].map(t => {
          const on = tab === t.id;
          return (
            <button key={t.id} onClick={() => setTab(t.id)} style={{
              height: 38, padding: '0 14px', borderRadius: 19, border: 'none', cursor: 'pointer',
              background: on ? '#fff' : 'rgba(255,255,255,0.10)',
              color: on ? FC.ink : '#fff',
              fontFamily: FT.ui, fontSize: 13, fontWeight: 600,
              display: 'flex', alignItems: 'center', gap: 6,
            }}>
              <Icon name={t.icon} size={14} color={on ? FC.ink : '#fff'} strokeWidth={1.8}/>
              {t.label}
            </button>
          );
        })}
      </div>

      {/* Tab content */}
      <div style={{
        background: '#1A1410', borderTopLeftRadius: 24, borderTopRightRadius: 24,
        padding: '18px 16px 28px', minHeight: 196,
      }}>
        {tab === 'photo' && (
          <>
            <div style={{ fontFamily: FT.ui, fontSize: 12, fontWeight: 700, letterSpacing: 1.6, color: 'rgba(255,255,255,0.5)', textTransform: 'uppercase', marginBottom: 12 }}>
              Pick a photo
            </div>
            <div style={{ display: 'flex', gap: 10, overflowX: 'auto', paddingBottom: 4 }}>
              <button style={{
                width: 64, height: 64, borderRadius: 14, flexShrink: 0, border: '2px dashed rgba(255,255,255,0.4)', background: 'transparent',
                display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: 2, cursor: 'pointer', color: '#fff',
              }}>
                <Icon name="plus" size={18} color="#fff" strokeWidth={2}/>
                <span style={{ fontFamily: FT.ui, fontSize: 9, fontWeight: 600 }}>Yours</span>
              </button>
              {swatches.map((s, i) => {
                const on = photo === s;
                return (
                  <button key={i} onClick={() => setPhoto(s)} style={{
                    width: 64, height: 64, borderRadius: 14, flexShrink: 0, border: 'none', cursor: 'pointer', padding: 0,
                    backgroundImage: `url(${s})`, backgroundSize: 'cover', backgroundPosition: 'center',
                    boxShadow: on ? `0 0 0 3px ${FC.brand}, 0 0 0 5px #fff` : 'none', transition: 'box-shadow 0.15s',
                  }}/>
                );
              })}
            </div>
          </>
        )}
        {tab === 'caption' && (
          <>
            <div style={{ fontFamily: FT.ui, fontSize: 12, fontWeight: 700, letterSpacing: 1.6, color: 'rgba(255,255,255,0.5)', textTransform: 'uppercase', marginBottom: 10 }}>
              Add a caption (optional)
            </div>
            <input value={caption} onChange={e => setCaption(e.target.value)}
              placeholder="With love, Padma · 5 May" maxLength={48}
              style={{
                width: '100%', height: 52, borderRadius: 14, border: 'none',
                background: 'rgba(255,255,255,0.08)', color: '#fff', padding: '0 16px',
                fontFamily: FT.ui, fontSize: 16, outline: 'none',
                boxShadow: 'inset 0 0 0 1px rgba(255,255,255,0.12)',
                boxSizing: 'border-box',
              }}/>
            <div style={{ fontFamily: FT.ui, fontSize: 11, color: 'rgba(255,255,255,0.4)', marginTop: 6 }}>
              {caption.length}/48 · appears in top-right of the card
            </div>
          </>
        )}
        {tab === 'style' && (
          <>
            <div style={{ fontFamily: FT.ui, fontSize: 12, fontWeight: 700, letterSpacing: 1.6, color: 'rgba(255,255,255,0.5)', textTransform: 'uppercase', marginBottom: 10 }}>
              Quote style
            </div>
            <div style={{ display: 'flex', gap: 8 }}>
              {['Classic', 'Bold', 'Minimal'].map((n, i) => (
                <button key={n} style={{
                  flex: 1, height: 60, borderRadius: 14, border: 'none', cursor: 'pointer',
                  background: i === 0 ? '#fff' : 'rgba(255,255,255,0.08)',
                  color: i === 0 ? FC.ink : '#fff',
                  fontFamily: i === 1 ? FT.ui : FT.display, fontSize: 14, fontWeight: i === 1 ? 700 : 500,
                  fontStyle: i === 2 ? 'italic' : 'normal',
                  boxShadow: i === 0 ? `inset 0 0 0 2px ${FC.brand}` : 'inset 0 0 0 1px rgba(255,255,255,0.12)',
                }}>{n}</button>
              ))}
            </div>
          </>
        )}
      </div>

      {/* Bottom share bar */}
      <div style={{ padding: '12px 16px 28px', background: '#0A0807', display: 'flex', gap: 10 }}>
        <button onClick={onBack} style={{
          height: 56, padding: '0 18px', borderRadius: 16, border: 'none', cursor: 'pointer',
          background: 'rgba(255,255,255,0.10)', color: '#fff',
          fontFamily: FT.ui, fontSize: 16, fontWeight: 600,
          display: 'flex', alignItems: 'center', gap: 8, flexShrink: 0,
        }}>
          <Icon name="download" size={18} color="#fff" strokeWidth={1.8}/> Save
        </button>
        <Button size="lg" variant="primary" icon="share" onClick={onShare}>Share now</Button>
      </div>
    </div>
  );
};

// ─────────────────────────────────────────────────────────────
// Festival pack detail
// ─────────────────────────────────────────────────────────────
const FestivalPackScreen = ({ packId = 'ugadi', onBack, onOpenAll, onOpenCard }) => {
  const cards = window.DK.cards.filter(c => c.cat === 'festival').concat(window.DK.cards.filter(c => c.cat === 'goodmorning'));
  return (
    <div style={{ position: 'absolute', inset: 0, background: MC_safe.cream || '#FBF6EC', overflow: 'auto', paddingBottom: 24 }}>
      {/* hero header */}
      <div style={{
        position: 'relative', height: 280, overflow: 'hidden',
        background: 'linear-gradient(180deg, #7E1F0E 0%, #B33A20 100%)',
      }}>
        <div style={{
          position: 'absolute', inset: 0,
          background: 'radial-gradient(ellipse at 80% 20%, rgba(232,155,44,0.4) 0%, transparent 60%)',
        }}/>
        {/* marigold dots */}
        {[...Array(8)].map((_, i) => (
          <div key={i} style={{
            position: 'absolute',
            top: `${10 + (i*7) % 40}%`, left: `${(i * 13) % 90}%`,
            width: 6 + (i % 3) * 4, height: 6 + (i % 3) * 4, borderRadius: '50%',
            background: i % 2 ? '#E89B2C' : '#F4D03F', opacity: 0.6,
          }} />
        ))}
        <div style={{ position: 'absolute', top: 0, left: 0, right: 0, padding: '54px 16px 0', display: 'flex' }}>
          <button onClick={onBack} style={{
            width: 40, height: 40, borderRadius: 20, border: 'none',
            background: 'rgba(0,0,0,0.25)', backdropFilter: 'blur(8px)', cursor: 'pointer',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}>
            <Icon name="chevronLeft" size={20} color="#fff" strokeWidth={2.2}/>
          </button>
        </div>
        <div style={{ position: 'absolute', bottom: 24, left: 24, right: 24 }}>
          <div style={{
            display: 'inline-flex', padding: '4px 11px', borderRadius: 999,
            background: 'rgba(255,255,255,0.16)', backdropFilter: 'blur(10px)',
            fontFamily: FT.ui, fontSize: 10, fontWeight: 700, letterSpacing: 2,
            color: '#fff', textTransform: 'uppercase', marginBottom: 12,
          }}>Festival Pack</div>
          <div style={{ fontFamily: FT.display, fontSize: 36, fontWeight: 500, color: '#fff', letterSpacing: -0.4, lineHeight: 1.05 }}>
            Ugadi greetings
          </div>
          <div style={{ fontFamily: FT.ui, fontSize: 13, color: 'rgba(255,255,255,0.78)', marginTop: 8 }}>
            12 cards · refreshed daily until 14 May
          </div>
        </div>
      </div>
      {/* CTA + grid */}
      <div style={{ padding: '16px 20px 6px', display: 'flex', gap: 10 }}>
        <Button size="md" variant="primary" icon="arrowRight" onClick={onOpenAll}>Open in feed</Button>
        <button style={{
          width: 56, height: 48, borderRadius: 14, border: 'none', cursor: 'pointer',
          background: FC.surface, boxShadow: 'inset 0 0 0 1.5px ' + FC.border,
          display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
        }}>
          <Icon name="save" size={20} color={FC.ink} strokeWidth={1.8}/>
        </button>
      </div>
      <div style={{ padding: '16px 20px 8px', fontFamily: FT.ui, fontSize: 11, fontWeight: 700, letterSpacing: 2, color: FC.ink3, textTransform: 'uppercase' }}>
        All 12 cards
      </div>
      <div style={{ padding: '0 20px 24px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 12 }}>
        {cards.map(c => (
          <MiniCard key={c.id} card={c} onClick={() => onOpenCard(c)} />
        ))}
      </div>
    </div>
  );
};

// safe alias to avoid undefined
const MC_safe = window.DK.color;

Object.assign(window, { FeedScreen, EditorScreen, FestivalPackScreen });
