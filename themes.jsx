// Theme data + illustrated backgrounds for each Daily Katha interest
// Each theme: id, pill (te), greeting (te), quoteTe, quoteEn, palette, Bg(SVG component)

const Bg = {
  // === GOOD MORNING — sunrise over hills ===
  goodmorning: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="gm-sky" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#F8D27A"/>
          <stop offset=".45" stopColor="#F2A03F"/>
          <stop offset=".75" stopColor="#C75618"/>
          <stop offset="1" stopColor="#5A1E08"/>
        </linearGradient>
        <radialGradient id="gm-sun" cx=".5" cy=".62" r=".22">
          <stop offset="0" stopColor="#FFF1B8" stopOpacity=".95"/>
          <stop offset=".6" stopColor="#FFD06B" stopOpacity=".4"/>
          <stop offset="1" stopColor="#FFD06B" stopOpacity="0"/>
        </radialGradient>
      </defs>
      <rect width="360" height="560" fill="url(#gm-sky)"/>
      <circle cx="180" cy="350" r="160" fill="url(#gm-sun)"/>
      <circle cx="180" cy="350" r="42" fill="#FFE9A3" opacity=".95"/>
      {/* horizontal sun rays */}
      {Array.from({length:14}).map((_,i)=>(
        <rect key={i} x="0" y={300+i*8} width="360" height="1" fill="#FFE9A3" opacity={0.06+i*0.005}/>
      ))}
      {/* hill silhouettes */}
      <path d="M0 430 Q 80 380 160 410 T 360 405 L360 560 L0 560 Z" fill="#3A1408" opacity=".55"/>
      <path d="M0 470 Q 100 430 200 450 T 360 460 L360 560 L0 560 Z" fill="#2A0C04" opacity=".75"/>
      {/* birds */}
      <path d="M70 180 q8 -6 16 0 q8 -6 16 0" stroke="#1F0A02" strokeWidth="1.6" fill="none" strokeLinecap="round"/>
      <path d="M110 200 q6 -4 12 0 q6 -4 12 0" stroke="#1F0A02" strokeWidth="1.4" fill="none" strokeLinecap="round"/>
      <path d="M250 170 q7 -5 14 0 q7 -5 14 0" stroke="#1F0A02" strokeWidth="1.5" fill="none" strokeLinecap="round"/>
    </svg>
  ),

  // === GOOD NIGHT — moonlit lake ===
  goodnight: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="gn-sky" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#1B1248"/>
          <stop offset=".5" stopColor="#2E1B62"/>
          <stop offset="1" stopColor="#5A2C7A"/>
        </linearGradient>
        <radialGradient id="gn-glow" cx=".82" cy=".15" r=".25">
          <stop offset="0" stopColor="#E5C8FF" stopOpacity=".55"/>
          <stop offset="1" stopColor="#E5C8FF" stopOpacity="0"/>
        </radialGradient>
      </defs>
      <rect width="360" height="560" fill="url(#gn-sky)"/>
      <rect width="360" height="560" fill="url(#gn-glow)"/>
      {/* stars */}
      {[[40,90],[80,140],[140,70],[220,110],[300,80],[260,180],[320,200],[60,200],[180,40]].map(([x,y],i)=>(
        <circle key={i} cx={x} cy={y} r={i%2?1:1.5} fill="#fff" opacity=".75"/>
      ))}
      {/* clouds */}
      <ellipse cx="60" cy="320" rx="120" ry="22" fill="#7A4FB0" opacity=".35"/>
      <ellipse cx="300" cy="310" rx="110" ry="20" fill="#7A4FB0" opacity=".35"/>
      {/* mountains */}
      <path d="M0 430 L80 360 L150 420 L230 350 L310 420 L360 390 L360 560 L0 560 Z" fill="#15093A" opacity=".9"/>
      {/* lake reflection */}
      <rect x="0" y="475" width="360" height="85" fill="#0B0626"/>
      <path d="M120 490 Q180 520 240 490" stroke="#B89BFF" strokeWidth="1" fill="none" opacity=".5"/>
      <path d="M90 510 Q180 540 270 510" stroke="#B89BFF" strokeWidth="1" fill="none" opacity=".4"/>
    </svg>
  ),

  // === LOVE — rose garden at dusk ===
  love: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="lv-sky" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#FFD0CB"/>
          <stop offset=".4" stopColor="#E07B8F"/>
          <stop offset="1" stopColor="#5C0E2A"/>
        </linearGradient>
      </defs>
      <rect width="360" height="560" fill="url(#lv-sky)"/>
      {/* falling petals */}
      {[[40,80,12,18],[110,140,8,20],[260,90,14,16],[300,200,10,30],[80,260,9,15],[200,40,11,25],[160,180,7,12],[330,300,12,18]].map(([x,y,r,a],i)=>(
        <path key={i} d={`M${x} ${y} q${r} -${r/1.5} ${r*2} 0 q-${r} ${r*1.4} -${r*2} 0 z`} fill="#FFB8C9" opacity=".55" transform={`rotate(${a} ${x+r} ${y})`}/>
      ))}
      {/* arch silhouette */}
      <path d="M40 560 L40 400 Q180 280 320 400 L320 560 Z" fill="#3A0820" opacity=".25" stroke="#8E1B3E" strokeWidth=".6"/>
      {/* heart medallion glow at center bottom */}
      <circle cx="180" cy="500" r="120" fill="#FFCDD7" opacity=".15"/>
      <path d="M180 470 c -12 -16 -38 -10 -38 12 c 0 22 38 40 38 40 c 0 0 38 -18 38 -40 c 0 -22 -26 -28 -38 -12 z" fill="#5C0E2A" opacity=".35" stroke="#FFCDD7" strokeWidth=".7"/>
    </svg>
  ),

  // === BHAKTI — temple at dawn with diya ===
  bhakti: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="bk-sky" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#F4C45A"/>
          <stop offset=".4" stopColor="#C8541A"/>
          <stop offset="1" stopColor="#3A0A06"/>
        </linearGradient>
        <radialGradient id="bk-flame" cx=".5" cy=".5" r=".5">
          <stop offset="0" stopColor="#FFF1A8"/>
          <stop offset=".5" stopColor="#FFB23A" stopOpacity=".7"/>
          <stop offset="1" stopColor="#FFB23A" stopOpacity="0"/>
        </radialGradient>
      </defs>
      <rect width="360" height="560" fill="url(#bk-sky)"/>
      {/* radiating rays */}
      {Array.from({length:18}).map((_,i)=>(
        <line key={i} x1="180" y1="350" x2={180+Math.cos(i/18*Math.PI*2)*400} y2={350+Math.sin(i/18*Math.PI*2)*400} stroke="#FFE3A8" strokeWidth="1" opacity=".18"/>
      ))}
      {/* temple silhouette */}
      <g fill="#1A0604" opacity=".85">
        <path d="M120 460 L120 380 L140 380 L140 360 L160 360 L160 340 L170 320 L180 305 L190 320 L200 340 L200 360 L220 360 L220 380 L240 380 L240 460 Z"/>
        <rect x="100" y="460" width="160" height="100"/>
      </g>
      {/* diya glow at bottom */}
      <ellipse cx="180" cy="520" rx="40" ry="20" fill="url(#bk-flame)"/>
      <path d="M170 510 q10 -18 20 0 z" fill="#FFD061"/>
    </svg>
  ),

  // === MOTIVATION — mountain peak at dawn ===
  motivation: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="mt-sky" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#0F4A52"/>
          <stop offset=".5" stopColor="#1F8AA0"/>
          <stop offset="1" stopColor="#F2C76E"/>
        </linearGradient>
      </defs>
      <rect width="360" height="560" fill="url(#mt-sky)"/>
      {/* sunburst */}
      <circle cx="180" cy="430" r="52" fill="#FFE1A0" opacity=".9"/>
      <circle cx="180" cy="430" r="80" fill="#FFE1A0" opacity=".25"/>
      {/* mountain ranges */}
      <path d="M0 460 L80 340 L140 410 L210 280 L290 400 L360 350 L360 560 L0 560 Z" fill="#062931"/>
      <path d="M0 500 L60 440 L130 480 L200 420 L280 470 L360 440 L360 560 L0 560 Z" fill="#031518" opacity=".95"/>
      {/* rising bird */}
      <path d="M260 200 q6 -6 12 0 q6 -6 12 0" stroke="#FFE9A3" strokeWidth="1.6" fill="none" strokeLinecap="round"/>
      <path d="M280 240 q5 -4 10 0 q5 -4 10 0" stroke="#FFE9A3" strokeWidth="1.4" fill="none" strokeLinecap="round"/>
    </svg>
  ),

  // === FESTIVAL — marigold rangoli with diyas ===
  festival: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="fs-bg" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#7A1410"/>
          <stop offset=".5" stopColor="#B94E11"/>
          <stop offset="1" stopColor="#E8761E"/>
        </linearGradient>
      </defs>
      <rect width="360" height="560" fill="url(#fs-bg)"/>
      {/* mango-leaf garland top */}
      <path d="M0 50 Q 20 30 40 50 Q 60 30 80 50 Q 100 30 120 50 Q 140 30 160 50 Q 180 30 200 50 Q 220 30 240 50 Q 260 30 280 50 Q 300 30 320 50 Q 340 30 360 50" stroke="#F5D06B" strokeWidth="1.2" fill="none"/>
      {Array.from({length:18}).map((_,i)=>(
        <ellipse key={i} cx={i*20+10} cy="60" rx="6" ry="14" fill="#0F6E5E" opacity=".9"/>
      ))}
      {/* center marigold rangoli */}
      <g transform="translate(180 350)">
        {Array.from({length:12}).map((_,i)=>(
          <circle key={i} cx={Math.cos(i/12*Math.PI*2)*80} cy={Math.sin(i/12*Math.PI*2)*80} r="14" fill="#F4A547" opacity=".9"/>
        ))}
        {Array.from({length:12}).map((_,i)=>(
          <circle key={i} cx={Math.cos(i/12*Math.PI*2)*55} cy={Math.sin(i/12*Math.PI*2)*55} r="10" fill="#E8761E"/>
        ))}
        <circle r="30" fill="#F5D06B"/>
        <circle r="14" fill="#7A1410"/>
      </g>
      {/* diyas */}
      <ellipse cx="60" cy="510" rx="22" ry="6" fill="#1A0604"/>
      <path d="M50 500 q10 -18 20 0 z" fill="#FFD061"/>
      <ellipse cx="300" cy="510" rx="22" ry="6" fill="#1A0604"/>
      <path d="M290 500 q10 -18 20 0 z" fill="#FFD061"/>
    </svg>
  ),

  // === FAMILY — warm cream with home ===
  family: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="fm-bg" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#F5E1B8"/>
          <stop offset=".5" stopColor="#E8AE7A"/>
          <stop offset="1" stopColor="#7A3A1A"/>
        </linearGradient>
      </defs>
      <rect width="360" height="560" fill="url(#fm-bg)"/>
      {/* sun behind */}
      <circle cx="180" cy="200" r="140" fill="#FFE9A3" opacity=".35"/>
      {/* kolam dots */}
      {Array.from({length:5}).map((_,r)=>Array.from({length:7}).map((_,c)=>(
        <circle key={`${r}-${c}`} cx={70+c*40} cy={420+r*22} r="1.4" fill="#3A1408" opacity=".35"/>
      )))}
      {/* simple house silhouette */}
      <g transform="translate(120 320)">
        <path d="M0 80 L60 20 L120 80 Z" fill="#3A1408"/>
        <rect x="10" y="80" width="100" height="80" fill="#3A1408"/>
        <rect x="48" y="110" width="24" height="50" fill="#F5D06B"/>
        <circle cx="60" cy="30" r="3" fill="#F5D06B"/>
      </g>
      {/* tree */}
      <rect x="42" y="380" width="6" height="60" fill="#3A1408"/>
      <circle cx="45" cy="376" r="22" fill="#0F6E5E" opacity=".85"/>
      <rect x="312" y="380" width="6" height="60" fill="#3A1408"/>
      <circle cx="315" cy="376" r="22" fill="#0F6E5E" opacity=".85"/>
    </svg>
  ),

  // === CINEMA — black & gold cinematic ===
  cinema: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="cn-bg" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#0D0905"/>
          <stop offset=".5" stopColor="#3A2A0E"/>
          <stop offset="1" stopColor="#0D0905"/>
        </linearGradient>
        <radialGradient id="cn-spot" cx=".5" cy=".55" r=".5">
          <stop offset="0" stopColor="#F5D06B" stopOpacity=".35"/>
          <stop offset="1" stopColor="#F5D06B" stopOpacity="0"/>
        </radialGradient>
      </defs>
      <rect width="360" height="560" fill="url(#cn-bg)"/>
      <circle cx="180" cy="320" r="220" fill="url(#cn-spot)"/>
      {/* film strip top & bottom */}
      <rect x="0" y="440" width="360" height="40" fill="#1A0F04"/>
      {Array.from({length:12}).map((_,i)=>(
        <rect key={i} x={i*30+6} y="450" width="18" height="20" fill="#F5D06B" opacity=".25"/>
      ))}
      <rect x="0" y="490" width="360" height="40" fill="#1A0F04"/>
      {Array.from({length:12}).map((_,i)=>(
        <rect key={`b${i}`} x={i*30+6} y="500" width="18" height="20" fill="#F5D06B" opacity=".25"/>
      ))}
      {/* film reel center */}
      <g transform="translate(180 330)" opacity=".5">
        <circle r="60" fill="none" stroke="#D4A12A" strokeWidth="2"/>
        <circle r="48" fill="none" stroke="#D4A12A" strokeWidth="1"/>
        <circle r="8" fill="#D4A12A"/>
        {Array.from({length:6}).map((_,i)=>(
          <circle key={i} cx={Math.cos(i/6*Math.PI*2)*36} cy={Math.sin(i/6*Math.PI*2)*36} r="9" fill="none" stroke="#D4A12A" strokeWidth="1.5"/>
        ))}
      </g>
    </svg>
  ),

  // === HEROES — saffron rays, warrior stand ===
  heroes: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="hr-bg" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#3A0606"/>
          <stop offset=".5" stopColor="#7A1410"/>
          <stop offset="1" stopColor="#E8761E"/>
        </linearGradient>
      </defs>
      <rect width="360" height="560" fill="url(#hr-bg)"/>
      {/* dramatic rays from horizon */}
      {Array.from({length:14}).map((_,i)=>(
        <polygon key={i} points={`180,420 ${180-180+i*30},0 ${180-160+i*30},0`} fill="#F4A547" opacity=".10"/>
      ))}
      {/* horizon */}
      <rect y="420" width="360" height="140" fill="#1A0604"/>
      {/* warrior silhouette - simple cape & shoulders */}
      <g transform="translate(180 380)" fill="#0A0202">
        <path d="M-50 40 Q -50 -10 -30 -40 Q 0 -70 30 -40 Q 50 -10 50 40 Z"/>
        <circle cx="0" cy="-50" r="14"/>
        <path d="M-60 40 L60 40 L80 80 L-80 80 Z" opacity=".9"/>
      </g>
      {/* sword glint at center top */}
      <line x1="180" y1="50" x2="180" y2="120" stroke="#F5D06B" strokeWidth="2" opacity=".7"/>
      <line x1="160" y1="58" x2="200" y2="58" stroke="#F5D06B" strokeWidth="2" opacity=".7"/>
    </svg>
  ),

  // === POETRY — sage paper with lotus pond ===
  poetry: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="po-bg" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0" stopColor="#E8DDB8"/>
          <stop offset=".5" stopColor="#9BB39A"/>
          <stop offset="1" stopColor="#2E4A3F"/>
        </linearGradient>
      </defs>
      <rect width="360" height="560" fill="url(#po-bg)"/>
      {/* paper grain dots */}
      {Array.from({length:60}).map((_,i)=>(
        <circle key={i} cx={Math.random()*360} cy={Math.random()*560} r=".6" fill="#2E4A3F" opacity=".22"/>
      ))}
      {/* pond ripples */}
      {[460,490,520].map((y,i)=>(
        <ellipse key={i} cx="180" cy={y} rx={140-i*30} ry={6-i} fill="none" stroke="#2E4A3F" strokeWidth=".8" opacity=".5"/>
      ))}
      {/* lotuses */}
      <g transform="translate(80 480)">
        <ellipse rx="22" ry="4" fill="#2E4A3F" opacity=".5"/>
        <path d="M-12 -2 q12 -16 24 0 z" fill="#FBE4DA"/>
        <path d="M-16 -1 q16 -10 32 0" fill="#E8AE7A" opacity=".7"/>
      </g>
      <g transform="translate(280 510)">
        <ellipse rx="20" ry="4" fill="#2E4A3F" opacity=".5"/>
        <path d="M-10 -2 q10 -14 20 0 z" fill="#FBE4DA"/>
      </g>
      {/* feather quill */}
      <path d="M40 90 Q 80 60 130 50 L 130 56 Q 80 70 50 110 Z" fill="#2E4A3F" opacity=".65"/>
    </svg>
  ),

  // === FRIENDSHIP — twin trees at sunset ===
  friendship: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="fr-bg" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#F2C76E"/>
          <stop offset=".5" stopColor="#E8761E"/>
          <stop offset="1" stopColor="#0F6E5E"/>
        </linearGradient>
      </defs>
      <rect width="360" height="560" fill="url(#fr-bg)"/>
      <circle cx="180" cy="280" r="60" fill="#FFE9A3" opacity=".7"/>
      {/* two trees */}
      <g transform="translate(110 350)">
        <rect x="-3" y="0" width="6" height="100" fill="#1A0604"/>
        <circle r="38" fill="#063828"/>
      </g>
      <g transform="translate(250 350)">
        <rect x="-3" y="0" width="6" height="100" fill="#1A0604"/>
        <circle r="38" fill="#063828"/>
      </g>
      {/* swing rope between */}
      <path d="M148 348 Q 180 392 212 348" stroke="#1A0604" strokeWidth="1.4" fill="none"/>
      <line x1="172" y1="378" x2="172" y2="392" stroke="#1A0604" strokeWidth="1"/>
      <line x1="188" y1="378" x2="188" y2="392" stroke="#1A0604" strokeWidth="1"/>
      <rect x="166" y="390" width="28" height="3" fill="#1A0604"/>
      {/* ground */}
      <rect y="450" width="360" height="110" fill="#031F18"/>
      {/* two birds together */}
      <path d="M70 130 q6 -5 12 0 q6 -5 12 0" stroke="#1A0604" strokeWidth="1.6" fill="none" strokeLinecap="round"/>
      <path d="M88 138 q5 -4 10 0 q5 -4 10 0" stroke="#1A0604" strokeWidth="1.4" fill="none" strokeLinecap="round"/>
    </svg>
  ),

  // === BIRTHDAY — confetti & garland ===
  birthday: () => (
    <svg viewBox="0 0 360 560" preserveAspectRatio="xMidYMid slice" style={{position:'absolute',inset:0,width:'100%',height:'100%'}}>
      <defs>
        <linearGradient id="bd-bg" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stopColor="#F8C8DA"/>
          <stop offset=".5" stopColor="#E07B8F"/>
          <stop offset="1" stopColor="#5A1E40"/>
        </linearGradient>
      </defs>
      <rect width="360" height="560" fill="url(#bd-bg)"/>
      {/* garland of flowers */}
      <path d="M0 60 Q 90 100 180 70 Q 270 40 360 80" stroke="#F5D06B" strokeWidth="1.5" fill="none"/>
      {Array.from({length:10}).map((_,i)=>{
        const t=i/9; const x=t*360; const y=60+Math.sin(t*Math.PI)*30;
        return <circle key={i} cx={x} cy={y} r="6" fill={i%2?'#F4A547':'#F5D06B'}/>;
      })}
      {/* confetti */}
      {[[40,200,15,'#F5D06B'],[80,140,30,'#FFE9A3'],[140,260,-20,'#0F6E5E'],[260,180,40,'#F4A547'],[310,140,-10,'#FFE9A3'],[300,300,25,'#F5D06B'],[60,360,15,'#0F6E5E'],[200,140,-30,'#FFCDD7'],[220,360,40,'#F4A547'],[120,420,-15,'#FFE9A3']].map(([x,y,r,c],i)=>(
        <rect key={i} x={x} y={y} width="10" height="3" fill={c} transform={`rotate(${r} ${x+5} ${y+1.5})`}/>
      ))}
      {/* candle on cake */}
      <g transform="translate(180 440)">
        <rect x="-50" y="0" width="100" height="50" fill="#FFCDD7" stroke="#5A1E40" strokeWidth="1"/>
        <rect x="-50" y="20" width="100" height="6" fill="#F5D06B"/>
        <rect x="-2" y="-30" width="4" height="30" fill="#FFE9A3"/>
        <path d="M0 -45 q-6 8 0 14 q6 -6 0 -14" fill="#F4A547"/>
      </g>
    </svg>
  ),
};

const THEMES = [
  {
    id: 'goodmorning',
    pill: 'శుభోదయం', icon: '☀',
    quoteTe: 'ప్రతి ఉదయం ఒక కొత్త అవకాశం. మీరు సిద్ధమేనా?',
    quoteEn: 'Every dawn brings a new chance. Are you ready?',
    centerGlyph: 'sun',
    palette: { ink:'#FFFCF3', sub:'#FFE7B8', accent:'#F5D06B', frame:'#FFD78A' },
  },
  {
    id: 'goodnight',
    pill: 'శుభరాత్రి', icon: '☾',
    quoteTe: 'రోజంతా పడ్డ అలసటను మరచి ప్రశాంతంగా నిద్రపోండి.',
    quoteEn: "Forget the day's fatigue and sleep peacefully.",
    centerGlyph: 'lotus',
    palette: { ink:'#FFFCF3', sub:'#D8C4FF', accent:'#B89BFF', frame:'#9C7CE0' },
  },
  {
    id: 'love',
    pill: 'ప్రేమ', icon: '❤',
    quoteTe: 'ప్రేమ అంటే రెండు హృదయాలు ఒకే లయలో కొట్టుకోవడం.',
    quoteEn: 'Love is two hearts beating to the same rhythm.',
    centerGlyph: 'heart',
    palette: { ink:'#FFFCF3', sub:'#FFD3DC', accent:'#FFB8C9', frame:'#FF96AE' },
  },
  {
    id: 'bhakti',
    pill: 'భక్తి', icon: 'ॐ',
    quoteTe: 'భక్తుడు ఎక్కడ తలవంచితే, అక్కడే భగవంతుడు ఉంటాడు.',
    quoteEn: 'Where the devotee bows, there the divine resides.',
    centerGlyph: 'om',
    palette: { ink:'#FFF5DC', sub:'#FFD79A', accent:'#F5D06B', frame:'#FFC066' },
  },
  {
    id: 'motivation',
    pill: 'ప్రేరణ', icon: '↑',
    quoteTe: 'మళ్ళీ మొదలెట్టండి. ప్రయత్నించేవారికే ప్రపంచం దారిస్తుంది.',
    quoteEn: 'Begin again. The world bends to those who try.',
    centerGlyph: 'peak',
    palette: { ink:'#FFFCF3', sub:'#CFE6E0', accent:'#F2C76E', frame:'#7FB8A8' },
  },
  {
    id: 'festival',
    pill: 'పండుగ', icon: '✦',
    quoteTe: 'ఈ పండుగ ప్రతి ఇంటిలో వెలుగును, ప్రతి హృదయంలో ప్రేమను నింపుగాక.',
    quoteEn: 'May this festival fill every home with light, every heart with love.',
    centerGlyph: 'diya',
    palette: { ink:'#FFFCF3', sub:'#FFE0B0', accent:'#F5D06B', frame:'#FFC066' },
  },
  {
    id: 'family',
    pill: 'కుటుంబం', icon: '⌂',
    quoteTe: 'కుటుంబం అంటే మీ పేరును ప్రేమగా పిలిచే చిన్న ప్రపంచం.',
    quoteEn: 'Family is the small world that calls your name with love.',
    centerGlyph: 'home',
    palette: { ink:'#3A1408', sub:'#5A2A12', accent:'#B94E11', frame:'#8E3E18' },
  },
  {
    id: 'cinema',
    pill: 'సినిమా', icon: '▶',
    quoteTe: 'పిక్చర్ ఇంకా బాకీ ఉంది మిత్రమా!',
    quoteEn: "The picture isn't over yet, my friend!",
    centerGlyph: 'reel',
    palette: { ink:'#FFFCF3', sub:'#F5D06B', accent:'#D4A12A', frame:'#D4A12A' },
  },
  {
    id: 'heroes',
    pill: 'హీరోలు', icon: '⚔',
    quoteTe: 'హీరోలు అరవరు. వారు సరైన సమయంలో నిలబడతారు.',
    quoteEn: "Heroes don't shout. They show up when it matters.",
    centerGlyph: 'sword',
    palette: { ink:'#FFFCF3', sub:'#FFD7A0', accent:'#F5D06B', frame:'#F4A547' },
  },
  {
    id: 'poetry',
    pill: 'కవిత్వం', icon: '✒',
    quoteTe: 'ఒక్క మాట ఒక మొత్తం వర్షాన్ని మోయగలదు.',
    quoteEn: 'A single word can hold a whole rain.',
    centerGlyph: 'quill',
    palette: { ink:'#1F2A24', sub:'#3D544A', accent:'#7A8E66', frame:'#5C7062' },
  },
  {
    id: 'friendship',
    pill: 'స్నేహం', icon: '✿',
    quoteTe: 'కొన్ని స్నేహాలు ఋతువులను దాటి నిలిచిపోతాయి.',
    quoteEn: 'Some friendships outlast the seasons.',
    centerGlyph: 'leaf',
    palette: { ink:'#FFFCF3', sub:'#FFE0B0', accent:'#F5D06B', frame:'#F2C76E' },
  },
  {
    id: 'birthday',
    pill: 'పుట్టినరోజు', icon: '✦',
    quoteTe: 'ఈ సంవత్సరం మీ పేరును చిరునవ్వులా ధరించుగాక.',
    quoteEn: 'May this year wear your name like a smile.',
    centerGlyph: 'candle',
    palette: { ink:'#FFFCF3', sub:'#FFE0E8', accent:'#F5D06B', frame:'#FFB8C9' },
  },
];

window.THEMES = THEMES;
window.Bg = Bg;
