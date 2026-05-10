/**
 * Local wall-clock in an IANA timezone (for recommendations).
 */
export function normalizeTimezone(tz) {
  if (!tz || typeof tz !== 'string') return 'Asia/Kolkata';
  const s = tz.trim();
  if (!s) return 'Asia/Kolkata';
  try {
    new Intl.DateTimeFormat('en-US', { timeZone: s }).format(new Date());
    return s;
  } catch {
    return 'Asia/Kolkata';
  }
}

/**
 * @returns {{ year: number, month: number, day: number, hour: number, minute: number, isoDate: string }}
 */
export function getWallClock(timeZone, now = new Date()) {
  const dtf = new Intl.DateTimeFormat('en-US', {
    timeZone,
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    hourCycle: 'h23',
  });
  const parts = dtf.formatToParts(now);
  const m = {};
  for (const p of parts) {
    if (p.type !== 'literal') m[p.type] = p.value;
  }
  const year = Number(m.year);
  const month = Number(m.month);
  const day = Number(m.day);
  const hour = Number(m.hour);
  const minute = Number(m.minute);
  const isoDate = `${year}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
  return { year, month, day, hour, minute, isoDate };
}

/**
 * Multi-year Gregorian windows for major Indian observances (approximate; extend yearly).
 * Tags match optional `cards.festival` JSON / naming; category `festival` still wins via scoring.
 */
export const FESTIVAL_WINDOWS = [
  // Fixed / narrow Gregorian (India public / widely shared)
  { id: 'republic_day', name: 'Republic Day', tags: ['republic'], recurring: { month: 1, startDay: 26, endDay: 26 } },
  { id: 'independence_day', name: 'Independence Day', tags: ['independence'], recurring: { month: 8, startDay: 15, endDay: 15 } },
  { id: 'gandhi_jayanti', name: 'Gandhi Jayanti', tags: ['gandhi'], recurring: { month: 10, startDay: 2, endDay: 2 } },
  { id: 'christmas', name: 'Christmas', tags: ['christmas'], recurring: { month: 12, startDay: 24, endDay: 26 } },

  // Seasonal windows (approximate; refreshed annually in ops if needed)
  { id: 'pongal', name: 'Pongal / Sankranti', tags: ['pongal', 'sankranti', 'makar'], recurring: { month: 1, startDay: 13, endDay: 17 } },
  { id: 'vasant_panchami', name: 'Vasant Panchami', tags: ['vasant', 'saraswati'], recurring: { month: 2, startDay: 1, endDay: 5 } },
  { id: 'maha_shivaratri', name: 'Maha Shivaratri', tags: ['shivaratri', 'shiva'], recurring: { month: 2, startDay: 24, endDay: 28 } },
  { id: 'holi', name: 'Holi', tags: ['holi'], recurring: { month: 3, startDay: 10, endDay: 18 } },
  { id: 'ugadi', name: 'Ugadi / Gudi Padwa', tags: ['ugadi', 'gudi', 'telugu_new_year'], recurring: { month: 3, startDay: 25, endDay: 31 } },
  { id: 'ram_navami', name: 'Ram Navami', tags: ['ram', 'ram_navami'], recurring: { month: 4, startDay: 1, endDay: 12 } },
  { id: 'hanuman_jayanti', name: 'Hanuman Jayanti', tags: ['hanuman'], recurring: { month: 4, startDay: 10, endDay: 24 } },
  { id: 'akshaya_tritiya', name: 'Akshaya Tritiya', tags: ['akshaya'], recurring: { month: 4, startDay: 25, endDay: 30 } },
  { id: 'eid_ul_fitr_window', name: 'Eid al-Fitr (approx)', tags: ['eid', 'ramzan', 'ramadan'], recurring: { month: 3, startDay: 25, endDay: 31 } },
  { id: 'raksha_bandhan', name: 'Raksha Bandhan', tags: ['rakhi', 'raksha'], recurring: { month: 8, startDay: 5, endDay: 15 } },
  { id: 'janmashtami', name: 'Janmashtami', tags: ['janmashtami', 'krishna'], recurring: { month: 8, startDay: 20, endDay: 31 } },
  { id: 'ganesh_chaturthi', name: 'Ganesh Chaturthi', tags: ['ganesh', 'ganapati', 'vinayaka'], recurring: { month: 9, startDay: 1, endDay: 20 } },
  { id: 'onam_window', name: 'Onam season', tags: ['onam', 'kerala'], recurring: { month: 9, startDay: 1, endDay: 15 } },
  { id: 'navratri_dussehra', name: 'Navratri / Dussehra', tags: ['navratri', 'durga', 'dussehra', 'vijayadashami'], recurring: { month: 10, startDay: 1, endDay: 15 } },
  { id: 'diwali_window', name: 'Diwali season', tags: ['diwali', 'deepavali', 'lakshmi'], recurring: { month: 11, startDay: 1, endDay: 15 } },
];

function parseIso(iso) {
  const [y, mo, d] = iso.split('-').map(Number);
  return { y, mo, d };
}

function daysBetween(aIso, bIso) {
  const a = new Date(`${aIso}T12:00:00Z`).getTime();
  const b = new Date(`${bIso}T12:00:00Z`).getTime();
  return Math.round((b - a) / (86400 * 1000));
}

/**
 * Is date (YYYY-MM-DD) inside recurring festival window for that calendar year.
 */
export function isDateInRecurringWindow(isoDate, window) {
  const { y, mo, d } = parseIso(isoDate);
  const { month, startDay, endDay } = window.recurring;
  if (mo !== month) return false;
  if (startDay <= endDay) return d >= startDay && d <= endDay;
  return d >= startDay || d <= endDay;
}

export function getActiveFestivals(isoDate) {
  const active = [];
  for (const w of FESTIVAL_WINDOWS) {
    if (isDateInRecurringWindow(isoDate, w)) {
      active.push({
        id: w.id,
        name: w.name,
        tags: w.tags,
        daysUntil: 0,
        daysUntilEnd: 0,
      });
    }
  }
  return active;
}

/**
 * Next festival *start* dates within `withinDays` (uses recurring startDay / month per year).
 */
export function getUpcomingFestivals(isoToday, withinDays = 14) {
  const y0 = parseInt(isoToday.slice(0, 4), 10);
  const upcoming = [];

  for (const w of FESTIVAL_WINDOWS) {
    const { month, startDay } = w.recurring;
    for (const y of [y0, y0 + 1]) {
      const startIso = `${y}-${String(month).padStart(2, '0')}-${String(startDay).padStart(2, '0')}`;
      const d = daysBetween(isoToday, startIso);
      if (d > 0 && d <= withinDays) {
        upcoming.push({
          id: w.id,
          name: w.name,
          tags: w.tags,
          startsOn: startIso,
          daysUntil: d,
        });
        break;
      }
    }
  }

  upcoming.sort((a, b) => a.daysUntil - b.daysUntil);
  return upcoming.slice(0, 12);
}

/**
 * Map local hour → editorial categories (matches mobile “interest” ids).
 * Night: 21:00–05:00 → good night; Morning: 05:00–12:00 → good morning.
 */
export function inferTimeCategories(hour) {
  const h = Number(hour);
  if (h >= 5 && h < 12) {
    return {
      timeSlot: 'morning',
      primary: 'goodmorning',
      secondary: 'motivation',
    };
  }
  if (h >= 12 && h < 17) {
    return {
      timeSlot: 'afternoon',
      primary: 'motivation',
      secondary: 'cinema',
    };
  }
  if (h >= 17 && h < 21) {
    return {
      timeSlot: 'evening',
      primary: 'family',
      secondary: 'goodnight',
    };
  }
  return {
    timeSlot: 'night',
    primary: 'goodnight',
    secondary: 'calm',
  };
}
