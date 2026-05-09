// Daily Katha design tokens — exposed on window for cross-script use
window.DK = window.DK || {};

window.DK.color = {
  // Brand
  brand:        '#B33A20',  // sindoor
  brandDeep:    '#7E1F0E',
  saffron:      '#E89B2C',
  gold:         '#C49247',

  // Surfaces (light app)
  cream:        '#FBF6EC',
  surface:      '#FFFFFF',
  surfaceAlt:   '#F4ECDD',
  border:       '#E8DFD0',
  divider:      '#EDE3D2',

  // Ink
  ink:          '#1A1410',
  ink2:         '#4A3F36',
  ink3:         '#8A7C6E',
  ink4:         '#B4A696',

  // System
  success:      '#2A6F3F',
  saved:        '#C49247',

  // Tab bar
  tabBg:        '#FFFFFF',
  tabActive:    '#B33A20',
  tabIdle:      '#8A7C6E',
};

// Per-category palettes used on hero cards (bg, accent text, supporting accent)
window.DK.cat = {
  bhakti:      { bg: '#5B1A1A', accent: '#F0B560', mood: 'devotional', label: 'Bhakti' },
  love:        { bg: '#7A2540', accent: '#F8C7B5', mood: 'romantic',   label: 'Love' },
  motivation:  { bg: '#1B2D44', accent: '#F2B544', mood: 'bold',       label: 'Motivation' },
  festival:    { bg: '#7E1F0E', accent: '#F4D03F', mood: 'festive',    label: 'Festival' },
  goodmorning: { bg: '#C66829', accent: '#FFE3B8', mood: 'warm',       label: 'Good Morning' },
  goodnight:   { bg: '#1F2848', accent: '#C9B3F2', mood: 'calm',       label: 'Good Night' },
  friendship:  { bg: '#2C5F4A', accent: '#F2C94C', mood: 'warm',       label: 'Friendship' },
  family:      { bg: '#5B3220', accent: '#F4C892', mood: 'warm',       label: 'Family' },
  poetry:      { bg: '#3A2548', accent: '#E8B4D8', mood: 'calm',       label: 'Poetry' },
  birthday:    { bg: '#A93757', accent: '#FFD964', mood: 'festive',    label: 'Birthday' },
};

window.DK.type = {
  display:  '"Spectral", "Source Serif 4", Georgia, serif',
  ui:       '"DM Sans", -apple-system, "SF Pro", system-ui, sans-serif',
  mono:     'ui-monospace, "SF Mono", monospace',
};

window.DK.shadow = {
  sm: '0 1px 2px rgba(26,20,16,0.06), 0 1px 1px rgba(26,20,16,0.04)',
  md: '0 4px 12px rgba(26,20,16,0.08), 0 1px 3px rgba(26,20,16,0.05)',
  lg: '0 12px 32px rgba(26,20,16,0.14), 0 2px 6px rgba(26,20,16,0.06)',
  card: '0 18px 40px rgba(91,26,26,0.18), 0 4px 12px rgba(91,26,26,0.10)',
};

// Sample quote content (English-only per user request, structured as cards)
window.DK.cards = [
  {
    id: 'gm1', cat: 'goodmorning', section: 'morning',
    quote: 'Begin the day\nwith a quiet smile —\nthe rest will follow.',
    author: '— a morning thought',
    photo: 'https://images.unsplash.com/photo-1506260408121-e353d10b87c7?w=900&q=80', // sunrise
  },
  {
    id: 'bh1', cat: 'bhakti', section: 'morning',
    quote: 'Where the lamp is lit\nthe heart already knows\nit is being heard.',
    author: '— a quiet prayer',
    photo: 'https://images.unsplash.com/photo-1604608672516-f1b9b1cb5f6f?w=900&q=80', // diya
  },
  {
    id: 'bh2', cat: 'bhakti', section: 'morning',
    quote: 'Faith does not move mountains.\nIt moves the one\nwho carries them.',
    author: '— reflection',
    photo: 'https://images.unsplash.com/photo-1518002171953-a080ee817e1f?w=900&q=80', // temple
  },
  {
    id: 'fes1', cat: 'festival', section: 'festival',
    quote: 'May this Ugadi bring\nnew beginnings,\nnew joys, new us.',
    author: '— Ugadi 2026',
    photo: 'https://images.unsplash.com/photo-1605197788044-5d2c64a04c47?w=900&q=80', // marigold
    festival: 'Ugadi',
  },
  {
    id: 'mo1', cat: 'motivation', section: 'trending',
    quote: 'The work you do today\nis the proof you wanted\nthe life you imagined.',
    author: '— for the long week',
    photo: 'https://images.unsplash.com/photo-1543269865-cbf427effbad?w=900&q=80',
  },
  {
    id: 'lv1', cat: 'love', section: 'interests',
    quote: 'Some hands you hold once\nand never put down\nin all the years that follow.',
    author: '— a love note',
    photo: 'https://images.unsplash.com/photo-1518622358385-8ea7d0794bf6?w=900&q=80',
  },
  {
    id: 'fr1', cat: 'friendship', section: 'interests',
    quote: 'A real friend\nis the one who knows the song\nin your silence.',
    author: '— a thought for you',
    photo: 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=900&q=80',
  },
  {
    id: 'fa1', cat: 'family', section: 'interests',
    quote: 'Home is not a place.\nIt is a small group of people\nwho keep waiting for you.',
    author: '— for family',
    photo: 'https://images.unsplash.com/photo-1511895426328-dc8714191300?w=900&q=80',
  },
  {
    id: 'gn1', cat: 'goodnight', section: 'evening',
    quote: 'Let the day go gently.\nWhat was meant to stay\nwill find you tomorrow.',
    author: '— good night',
    photo: 'https://images.unsplash.com/photo-1532978879514-6cb1a3f0a1c1?w=900&q=80',
  },
  {
    id: 'po1', cat: 'poetry', section: 'interests',
    quote: 'In a small word\nlike sometimes,\na whole life keeps living.',
    author: '— a small poem',
    photo: 'https://images.unsplash.com/photo-1455390582262-044cdead277a?w=900&q=80',
  },
  {
    id: 'fes2', cat: 'festival', section: 'festival',
    quote: 'May the lamps you light\nlight the homes\nof everyone you love.',
    author: '— Diwali wishes',
    photo: 'https://images.unsplash.com/photo-1605197788044-5d2c64a04c47?w=900&q=80',
    festival: 'Diwali',
  },
  {
    id: 'bd1', cat: 'birthday', section: 'interests',
    quote: 'Another year\nof being exactly\nwho the world needed.',
    author: '— happy birthday',
    photo: 'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?w=900&q=80',
  },
];

window.DK.interests = [
  { id: 'goodmorning', label: 'Good Morning',  emoji: '☀️' },
  { id: 'bhakti',      label: 'Bhakti',         emoji: '🪔' },
  { id: 'love',        label: 'Love',           emoji: '❤️' },
  { id: 'motivation',  label: 'Motivation',     emoji: '⚡' },
  { id: 'festival',    label: 'Festivals',      emoji: '🎉' },
  { id: 'family',      label: 'Family',         emoji: '🏠' },
  { id: 'friendship',  label: 'Friendship',     emoji: '🤝' },
  { id: 'cinema',      label: 'Cinema',         emoji: '🎬' },
  { id: 'heroes',      label: 'Heroes',         emoji: '⭐' },
  { id: 'poetry',      label: 'Poetry',         emoji: '📜' },
  { id: 'goodnight',   label: 'Good Night',     emoji: '🌙' },
  { id: 'birthday',    label: 'Birthday',       emoji: '🎂' },
];

window.DK.languages = [
  { id: 'te', name: 'Telugu',    native: 'తెలుగు',   sample: 'శుభోదయం' },
  { id: 'hi', name: 'Hindi',     native: 'हिन्दी',     sample: 'सुप्रभात' },
  { id: 'ta', name: 'Tamil',     native: 'தமிழ்',    sample: 'காலை வணக்கம்' },
  { id: 'kn', name: 'Kannada',   native: 'ಕನ್ನಡ',     sample: 'ಶುಭೋದಯ' },
  { id: 'ml', name: 'Malayalam', native: 'മലയാളം',  sample: 'സുപ്രഭാതം' },
  { id: 'en', name: 'English',   native: 'English',  sample: 'Good morning' },
];

window.DK.religions = [
  { id: 'hindu',     label: 'Hindu',     glyph: 'ॐ' },
  { id: 'muslim',    label: 'Muslim',    glyph: '☪' },
  { id: 'christian', label: 'Christian', glyph: '✝' },
  { id: 'sikh',      label: 'Sikh',      glyph: '☬' },
  { id: 'spiritual', label: 'Spiritual — no specific path', glyph: '✦' },
  { id: 'none',      label: 'Prefer not to say',            glyph: '·' },
];
