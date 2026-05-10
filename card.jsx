// StatusCard + HomeScreen — full phone-frame layout for each interest.

const PaisleyCorner = ({ color, x = 0, y = 0, rotate = 0 }) => (
  <g transform={`translate(${x} ${y}) rotate(${rotate})`}>
    <path d="M0 14 L0 0 L14 0" stroke={color} strokeWidth="1.4" fill="none"/>
    <path d="M2 18 Q 8 8 18 2" stroke={color} strokeWidth=".9" fill="none" opacity=".7"/>
    <circle cx="3" cy="3" r="1.2" fill={color}/>
  </g>
);

// Center divider with theme glyph
const CenterGlyph = ({ kind, color }) => {
  const stroke = { stroke: color, strokeWidth: 1.4, fill: 'none', strokeLinecap: 'round' };
  const fill = { fill: color };
  return (
    <svg width="80" height="32" viewBox="0 0 80 32" style={{display:'block'}}>
      <line x1="0" y1="16" x2="26" y2="16" stroke={color} strokeWidth=".8" opacity=".7"/>
      <circle cx="30" cy="16" r="1.2" {...fill}/>
      <g transform="translate(40 16)">
        {kind === 'lotus' && <path d="M0 -8 q-7 6 -7 8 q3 1 7 -2 q4 3 7 2 q0 -2 -7 -8 z" {...fill}/>}
        {kind === 'sun' && <g><circle r="4" {...fill}/>{Array.from({length:8}).map((_,i)=><line key={i} x1={Math.cos(i/8*Math.PI*2)*6} y1={Math.sin(i/8*Math.PI*2)*6} x2={Math.cos(i/8*Math.PI*2)*9} y2={Math.sin(i/8*Math.PI*2)*9} {...stroke}/>)}</g>}
        {kind === 'heart' && <path d="M0 4 c -4 -5 -10 -3 -10 2 c 0 5 10 9 10 9 c 0 0 10 -4 10 -9 c 0 -5 -6 -7 -10 -2 z" {...fill}/>}
        {kind === 'om' && <text textAnchor="middle" y="6" fontSize="16" fill={color} style={{fontFamily:'serif',fontWeight:600}}>ॐ</text>}
        {kind === 'peak' && <path d="M-9 5 L -3 -5 L 1 1 L 5 -7 L 10 5 Z" {...fill}/>}
        {kind === 'diya' && <g><ellipse rx="8" ry="2" cy="2" {...fill}/><path d="M-2 0 q2 -6 4 0 z" fill={color}/></g>}
        {kind === 'home' && <path d="M-7 5 L 0 -5 L 7 5 Z M-5 5 L -5 8 L 5 8 L 5 5" {...stroke}/>}
        {kind === 'reel' && <g><circle r="6" {...stroke}/><circle r="1.5" {...fill}/></g>}
        {kind === 'sword' && <g><line x1="0" y1="-7" x2="0" y2="7" {...stroke}/><line x1="-3" y1="-3" x2="3" y2="-3" {...stroke}/></g>}
        {kind === 'quill' && <path d="M-7 5 Q 0 -3 7 -5 L 5 -2 Q -2 0 -5 6 Z" {...fill}/>}
        {kind === 'leaf' && <path d="M-7 0 Q 0 -7 7 0 Q 0 7 -7 0 Z" {...fill}/>}
        {kind === 'candle' && <g><rect x="-1" y="-6" width="2" height="10" {...fill}/><path d="M0 -10 q-2 3 0 4 q2 -2 0 -4" {...fill}/></g>}
      </g>
      <circle cx="50" cy="16" r="1.2" {...fill}/>
      <line x1="54" y1="16" x2="80" y2="16" stroke={color} strokeWidth=".8" opacity=".7"/>
    </svg>
  );
};

const StatusCard = ({ theme }) => {
  const { palette, pill, quoteTe, quoteEn, centerGlyph, icon } = theme;
  const Bg = window.Bg[theme.id];
  return (
    <div style={{
      position:'relative', width: '100%', aspectRatio: '0.62',
      borderRadius: 24, overflow: 'hidden',
      boxShadow: '0 18px 40px -18px rgba(31,20,16,0.45), 0 4px 12px rgba(31,20,16,.18)',
    }}>
      <Bg/>
      {/* dashed outer frame */}
      <svg style={{position:'absolute',inset:0,width:'100%',height:'100%',pointerEvents:'none'}} viewBox="0 0 360 580" preserveAspectRatio="none">
        <rect x="10" y="10" width="340" height="560" rx="18" fill="none" stroke={palette.frame} strokeWidth="1" strokeDasharray="3 4" opacity=".55"/>
        <rect x="18" y="18" width="324" height="544" rx="14" fill="none" stroke={palette.frame} strokeWidth=".8" opacity=".7"/>
      </svg>
      {/* corners */}
      <svg style={{position:'absolute',inset:0,width:'100%',height:'100%',pointerEvents:'none'}} viewBox="0 0 360 580">
        <PaisleyCorner color={palette.frame} x={22} y={22} rotate={0}/>
        <PaisleyCorner color={palette.frame} x={338} y={22} rotate={90}/>
        <PaisleyCorner color={palette.frame} x={338} y={558} rotate={180}/>
        <PaisleyCorner color={palette.frame} x={22} y={558} rotate={270}/>
      </svg>

      <div style={{position:'relative', zIndex:2, height:'100%', padding:'22px 22px 18px', display:'flex', flexDirection:'column'}}>
        {/* top row: pill + icon */}
        <div style={{display:'flex', justifyContent:'space-between', alignItems:'center'}}>
          <div style={{
            display:'inline-flex', alignItems:'center', gap:6,
            padding:'5px 12px', borderRadius:999,
            border:`1px solid ${palette.frame}55`,
            background:'rgba(255,255,255,0.08)', backdropFilter:'blur(4px)',
            color: palette.ink, fontFamily:"'Noto Serif Telugu', serif", fontSize: 12.5
          }}>
            <span style={{width:6,height:6,borderRadius:99,background:palette.accent}}/>
            {pill}
          </div>
          <div style={{
            width:30, height:30, borderRadius:8,
            border:`1px solid ${palette.frame}66`,
            display:'flex', alignItems:'center', justifyContent:'center',
            color:palette.accent, fontSize:16
          }}>{icon}</div>
        </div>

        {/* center: divider + telugu hero + english echo */}
        <div style={{flex:1, display:'flex', flexDirection:'column', alignItems:'center', justifyContent:'center', textAlign:'center', padding:'0 6px'}}>
          <div style={{marginBottom:18}}><CenterGlyph kind={centerGlyph} color={palette.accent}/></div>
          <div style={{
            color: palette.ink,
            fontFamily:"'Noto Serif Telugu', serif",
            fontWeight: 600, fontSize: 22, lineHeight: 1.32,
            textShadow: '0 2px 12px rgba(0,0,0,.25)',
            letterSpacing: '.2px'
          }}>{quoteTe}</div>
          <div style={{
            marginTop:18, display:'flex', alignItems:'center', gap:8, opacity:.85
          }}>
            <span style={{flex:1, height:1, background:palette.frame, opacity:.4}}/>
            <span style={{width:4,height:4,background:palette.accent,transform:'rotate(45deg)'}}/>
            <span style={{flex:1, height:1, background:palette.frame, opacity:.4}}/>
          </div>
          <div style={{
            marginTop:14,
            color: palette.sub,
            fontFamily:"'Lora', serif", fontStyle:'italic',
            fontSize: 13.5, lineHeight: 1.45,
            maxWidth: 240,
          }}>{quoteEn}</div>
          <div style={{
            marginTop:14, color: palette.frame,
            fontFamily:"'Noto Serif Telugu', serif", fontSize:11.5, opacity:.85
          }}>— దైనిక కథ</div>
        </div>

        {/* watermark footer */}
        <div style={{display:'flex', alignItems:'center', justifyContent:'center', gap:10, color: palette.frame, opacity:.7}}>
          <span style={{width:5,height:5,background:palette.accent,transform:'rotate(45deg)'}}/>
          <div style={{textAlign:'center', fontFamily:"'Noto Serif Telugu', serif"}}>
            <div style={{fontSize:11, letterSpacing:'1px'}}>డైలీ కథ</div>
            <div style={{fontSize:9, opacity:.85, marginTop:1}}>శుభాలు పంచుకోండి</div>
          </div>
          <span style={{width:5,height:5,background:palette.accent,transform:'rotate(45deg)'}}/>
        </div>
      </div>
    </div>
  );
};

const HomeScreen = ({ theme, name = 'Vikas', date = 'SUNDAY · 10 MAY' }) => {
  const greetingMap = {
    goodmorning: 'శుభోదయం', goodnight: 'శుభ రాత్రి', love: 'ప్రేమతో', bhakti: 'భక్తితో',
    motivation: 'శుభదినం', festival: 'శుభ పండుగ', family: 'వందనాలు', cinema: 'హలో',
    heroes: 'వీర వందనం', poetry: 'వందనాలు', friendship: 'హాయ్', birthday: 'శుభాకాంక్షలు'
  };
  const greeting = greetingMap[theme.id] || 'నమస్కారం';

  return (
    <div style={{
      width:'100%', height:'100%', background:'#FBF4E6',
      fontFamily:"'DM Sans', system-ui, sans-serif",
      color:'#1F1410', display:'flex', flexDirection:'column',
      paddingTop: 12,
    }}>
      {/* status bar substitute */}
      <div style={{display:'flex', justifyContent:'space-between', padding:'2px 22px 4px', fontSize:11, color:'#1F1410', fontWeight:600}}>
        <span>9:41</span>
        <span style={{display:'inline-flex',gap:5,opacity:.7}}><span>•••</span><span>◐</span><span>◧</span></span>
      </div>

      {/* header */}
      <div style={{padding:'10px 22px 6px', display:'flex', justifyContent:'space-between', alignItems:'flex-start'}}>
        <div>
          <div style={{fontSize:11, letterSpacing:'1.4px', color:'#8A6F56', fontWeight:600}}>{date}</div>
          <div style={{
            marginTop:6, fontFamily:"'Noto Serif Telugu','Lora',serif",
            fontSize:23, color:'#1F1410', fontWeight:600
          }}>
            <span>{greeting},</span> <span style={{fontFamily:"'Lora',serif"}}>{name}.</span>
          </div>
        </div>
        <div style={{
          width:38, height:38, borderRadius:'50%', background:'#fff',
          boxShadow:'0 2px 8px rgba(31,20,16,.08)',
          display:'flex', alignItems:'center', justifyContent:'center',
          position:'relative', flexShrink:0
        }}>
          <span style={{fontSize:16}}>🔔</span>
          <span style={{position:'absolute',top:9,right:11,width:6,height:6,borderRadius:99,background:'#B3261E'}}/>
        </div>
      </div>

      {/* create card pill */}
      <div style={{padding:'8px 22px 10px'}}>
        <div style={{
          display:'inline-flex', alignItems:'center', gap:8,
          padding:'10px 18px', borderRadius:999, background:'#fff',
          boxShadow:'0 2px 8px rgba(31,20,16,.06)',
          fontSize:13, color:'#1F1410', fontWeight:500
        }}>
          <span style={{width:18,height:18,borderRadius:99,border:'1px solid #1F1410',display:'flex',alignItems:'center',justifyContent:'center',fontSize:13,fontWeight:600,lineHeight:1}}>+</span>
          Create Card
        </div>
      </div>

      {/* label row */}
      <div style={{padding:'4px 22px 10px', display:'flex', justifyContent:'space-between', alignItems:'center'}}>
        <span style={{fontSize:11, fontWeight:700, letterSpacing:'1.6px', color:'#B3261E'}}>YOUR CARD TODAY</span>
        <span style={{fontSize:12, color:'#8A6F56', display:'inline-flex', alignItems:'center', gap:5}}>
          <span style={{color:'#E8761E'}}>🔥</span>5-day streak
        </span>
      </div>

      {/* card */}
      <div style={{padding:'0 18px', flex:1}}>
        <StatusCard theme={theme}/>
      </div>

      {/* share + save */}
      <div style={{padding:'14px 22px 10px', display:'flex', gap:10}}>
        <div style={{
          flex:1, padding:'13px', borderRadius:14, background:'#fff',
          boxShadow:'0 2px 8px rgba(31,20,16,.06)',
          display:'flex', alignItems:'center', justifyContent:'center', gap:8,
          fontSize:13.5, fontWeight:600, color:'#1F1410'
        }}>
          <span style={{fontSize:14}}>↑</span> Share to Status
        </div>
        <div style={{
          width:46, padding:'13px', borderRadius:14, background:'#fff',
          boxShadow:'0 2px 8px rgba(31,20,16,.06)',
          display:'flex', alignItems:'center', justifyContent:'center',
          fontSize:14
        }}>🔖</div>
      </div>

      {/* tab bar */}
      <div style={{borderTop:'1px solid rgba(31,20,16,.08)', display:'flex', padding:'10px 0 14px'}}>
        {[
          {icon:'⌂', te:'హోమ్', active:true},
          {icon:'⊕', te:'అన్వేషించు', active:false},
          {icon:'☻', te:'ప్రొఫైల్', active:false},
        ].map((t,i)=>(
          <div key={i} style={{flex:1, textAlign:'center', color: t.active?'#B3261E':'#8A6F56'}}>
            <div style={{fontSize:18, lineHeight:1}}>{t.icon}</div>
            <div style={{fontSize:10.5, marginTop:3, fontFamily:"'Noto Serif Telugu',serif"}}>{t.te}</div>
          </div>
        ))}
      </div>
    </div>
  );
};

window.StatusCard = StatusCard;
window.HomeScreen = HomeScreen;
