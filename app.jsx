// Daily Katha prototype — main app shell with navigation state
const C = window.DK.color;

const initialUser = {
  language: 'en',
  religion: 'hindu',
  interests: ['goodmorning', 'bhakti', 'motivation'],
};

function App() {
  // route: { name, params }
  const [route, setRoute] = React.useState({ name: 'splash' });
  const [user, setUser] = React.useState({ language: null, religion: null, interests: [] });

  const go = (name, params = {}) => setRoute({ name, params });
  const goTab = (tab) => setRoute({ name: 'tab', params: { tab } });

  // Onboarding handlers
  const finishOnboarding = (overrides = {}) => {
    const u = { ...initialUser, ...user, ...overrides };
    setUser(u);
    setRoute({ name: 'tab', params: { tab: 'home' } });
  };

  // dev: jump straight in
  const jumpHome = () => {
    setUser(initialUser);
    setRoute({ name: 'tab', params: { tab: 'home' } });
  };

  let body;
  if (route.name === 'splash') {
    body = <SplashScreen onEnter={() => go('language')} />;
  } else if (route.name === 'language') {
    body = <LanguageScreen
      value={user.language}
      onChange={v => setUser({ ...user, language: v })}
      onNext={() => go('religion')} />;
  } else if (route.name === 'religion') {
    body = <ReligionScreen
      value={user.religion}
      onChange={v => setUser({ ...user, religion: v })}
      onNext={() => go('interests')}
      onBack={() => go('language')} />;
  } else if (route.name === 'interests') {
    body = <InterestsScreen
      value={user.interests}
      onChange={v => setUser({ ...user, interests: v })}
      onNext={() => finishOnboarding(user.language ? {} : initialUser)}
      onBack={() => go('religion')} />;
  } else if (route.name === 'tab') {
    const u = user.language ? user : initialUser;
    if (route.params.tab === 'home') {
      body = <HomeScreen user={u}
        onOpenSection={(s) => go('sectionPreview', { section: s })}
        onOpenCard={(c) => go('feed', { startIndex: window.DK.cards.findIndex(x => x.id === c.id) })} />;
    } else if (route.params.tab === 'explore') {
      body = <ExploreScreen
        onOpenCard={(c) => go('feed', { startIndex: window.DK.cards.findIndex(x => x.id === c.id) })}
        onOpenSection={(s) => go('sectionPreview', { section: s })}
        onOpenPack={(id) => go('festivalPack', { packId: id })} />;
    } else if (route.params.tab === 'profile') {
      body = <ProfileScreen user={u}
        onOpenSaved={() => go('saved')}
        onOpenEdits={() => go('saved')}
        onEditInterests={() => go('editInterests')}
        onEditLanguage={() => go('editLanguage')}
        onEditReligion={() => go('editReligion')} />;
    }
  } else if (route.name === 'sectionPreview') {
    const s = route.params.section;
    const cards = s === 'trending' ? window.DK.cards.slice(0, 6)
      : window.DK.cards.filter(c => c.cat === s);
    body = <SectionPreviewScreen section={s} cards={cards}
      onBack={() => goTab('home')}
      onOpenAll={() => go('feed', { cards, startIndex: 0 })}
      onOpenCard={(c) => go('feed', { cards, startIndex: cards.findIndex(x => x.id === c.id) })} />;
  } else if (route.name === 'feed') {
    const cards = route.params.cards || window.DK.cards;
    body = <FeedScreen cards={cards} startIndex={route.params.startIndex || 0}
      onBack={() => goTab('home')}
      onEdit={(c) => go('editor', { card: c })} />;
  } else if (route.name === 'editor') {
    body = <EditorScreen card={route.params.card}
      onBack={() => go('feed', { startIndex: 0 })}
      onShare={() => goTab('home')} />;
  } else if (route.name === 'festivalPack') {
    body = <FestivalPackScreen packId={route.params.packId}
      onBack={() => goTab('explore')}
      onOpenAll={() => {
        const cards = window.DK.cards.filter(c => c.cat === 'festival').concat(window.DK.cards.filter(c => c.cat === 'goodmorning'));
        go('feed', { cards, startIndex: 0 });
      }}
      onOpenCard={(c) => go('feed', { cards: window.DK.cards, startIndex: window.DK.cards.findIndex(x => x.id === c.id) })} />;
  } else if (route.name === 'saved') {
    body = <SavedScreen onBack={() => goTab('profile')}
      onOpenCard={(c) => go('feed', { startIndex: window.DK.cards.findIndex(x => x.id === c.id) })} />;
  } else if (route.name === 'editInterests') {
    body = <InterestsScreen value={user.interests || []}
      onChange={v => setUser({ ...user, interests: v })}
      onNext={() => goTab('profile')}
      onBack={() => goTab('profile')} />;
  } else if (route.name === 'editLanguage') {
    body = <LanguageScreen value={user.language}
      onChange={v => setUser({ ...user, language: v })}
      onNext={() => goTab('profile')} />;
  } else if (route.name === 'editReligion') {
    body = <ReligionScreen value={user.religion}
      onChange={v => setUser({ ...user, religion: v })}
      onNext={() => goTab('profile')}
      onBack={() => goTab('profile')} />;
  }

  // bottom tab is shown only on tab routes
  const showTab = route.name === 'tab';

  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden' }}>
      {body}
      {showTab && (
        <BottomNav active={route.params.tab}
          onChange={(t) => setRoute({ name: 'tab', params: { tab: t } })} />
      )}
    </div>
  );
}

window.DKApp = App;
