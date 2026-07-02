/* ============================================================================
   Progress charts — renders inline SVG line charts + sparklines from
   window.PROGRESS, and fills [data-stat] text nodes so every number on the
   canvas comes from one source and can never drift.
   Markup contract:
     <span class="chart" data-chart="spark|mini|line|hero|rail" data-ex="rdl"
           [data-tone="up|stall|cold|plain"] [data-w="" data-h=""]></span>
     <span data-stat="rdl.current"></span>   // current | start | pr | delta
                                              // | deltaAbs | weight | reps
                                              // | workouts | last | scheme
   ==========================================================================*/
(function () {
  const NS = 'http://www.w3.org/2000/svg';
  const TONE = {
    up: '#46d6a4', stall: '#e6b450', cold: '#6f665a',
    plain: '#9b9184', brand: '#ff5a2c',
  };
  const DIM = {
    spark: [116, 34, 3, 5, 5],   // w,h,padX,padTop,padBot
    mini: [200, 62, 4, 8, 8],
    rail: [88, 30, 3, 5, 5],
    line: [540, 210, 10, 16, 22],
    hero: [780, 300, 16, 22, 30],
  };

  function el(name, attrs) {
    const n = document.createElementNS(NS, name);
    for (const k in attrs) n.setAttribute(k, attrs[k]);
    return n;
  }

  function coords(vals, w, h, padX, padTop, padBot) {
    const min = Math.min(...vals), max = Math.max(...vals);
    const range = (max - min) || 1;
    const iw = w - padX * 2, ih = h - padTop - padBot;
    return vals.map((v, i) => {
      const x = padX + (vals.length === 1 ? iw / 2 : (i / (vals.length - 1)) * iw);
      const y = padTop + ih - ((v - min) / range) * ih;
      return [x, y];
    });
  }

  const lineStr = (pts) => pts.map((p, i) => (i ? 'L' : 'M') + p[0].toFixed(1) + ' ' + p[1].toFixed(1)).join(' ');

  function render(node) {
    const variant = node.getAttribute('data-chart');
    const ex = window.PROGRESS.byKey[node.getAttribute('data-ex')];
    if (!ex || !DIM[variant]) return;
    const tone = node.getAttribute('data-tone') || ex.tone || 'brand';
    const stroke = TONE[tone] || TONE.brand;
    let [w, h, padX, padTop, padBot] = DIM[variant];
    w = +node.getAttribute('data-w') || w;
    h = +node.getAttribute('data-h') || h;

    const svg = el('svg', { viewBox: `0 0 ${w} ${h}`, width: w, height: h, class: 'chart-svg' });
    const showAxis = variant === 'hero';
    const showGrid = variant === 'hero' || variant === 'line';
    const axisPad = showAxis ? 34 : 0;
    const cx0 = padX + axisPad;
    const iw = w - cx0 - padX;

    const vals = ex.series;
    const min = Math.min(...vals), max = Math.max(...vals);
    const range = (max - min) || 1;
    const ih = h - padTop - padBot;
    const X = (i) => cx0 + (vals.length === 1 ? iw / 2 : (i / (vals.length - 1)) * iw);
    const Y = (v) => padTop + ih - ((v - min) / range) * ih;
    const pts = vals.map((v, i) => [X(i), Y(v)]);

    // gridlines + y labels
    if (showGrid) {
      const rows = showAxis ? 4 : 3;
      for (let g = 0; g <= rows; g++) {
        const gy = padTop + (ih / rows) * g;
        svg.appendChild(el('line', {
          x1: cx0, y1: gy.toFixed(1), x2: w - padX, y2: gy.toFixed(1),
          stroke: 'rgba(255,255,255,.06)', 'stroke-width': 1,
        }));
        if (showAxis) {
          const val = max - (range / rows) * g;
          const t = el('text', {
            x: cx0 - 8, y: (gy + 3.5).toFixed(1), 'text-anchor': 'end', class: 'chart-axis',
          });
          t.textContent = Math.round(val);
          svg.appendChild(t);
        }
      }
    }

    // area fill under the line
    const grad = 'grad-' + ex.key + '-' + variant;
    const defs = el('defs', {});
    const lg = el('linearGradient', { id: grad, x1: 0, y1: 0, x2: 0, y2: 1 });
    lg.appendChild(el('stop', { offset: '0%', 'stop-color': stroke, 'stop-opacity': variant === 'hero' ? .22 : .16 }));
    lg.appendChild(el('stop', { offset: '100%', 'stop-color': stroke, 'stop-opacity': 0 }));
    defs.appendChild(lg);
    svg.appendChild(defs);

    const base = h - padBot;
    const area = lineStr(pts) + ` L ${pts[pts.length - 1][0].toFixed(1)} ${base} L ${pts[0][0].toFixed(1)} ${base} Z`;
    svg.appendChild(el('path', { d: area, fill: `url(#${grad})`, stroke: 'none' }));

    // the line
    svg.appendChild(el('path', {
      d: lineStr(pts), fill: 'none', stroke,
      'stroke-width': variant === 'spark' || variant === 'rail' ? 1.8 : 2.4,
      'stroke-linejoin': 'round', 'stroke-linecap': 'round',
    }));

    // data dots on larger charts
    if (variant === 'line' || variant === 'hero') {
      pts.forEach((p, i) => {
        if (i === pts.length - 1) return;
        svg.appendChild(el('circle', { cx: p[0].toFixed(1), cy: p[1].toFixed(1), r: 2.6, fill: '#16130f', stroke, 'stroke-width': 1.6 }));
      });
      // x-axis date labels (first, last, and a couple between)
      if (showAxis) {
        const idxs = [0, Math.round((vals.length - 1) / 2), vals.length - 1];
        [...new Set(idxs)].forEach((i) => {
          const t = el('text', { x: X(i).toFixed(1), y: h - 8, 'text-anchor': i === 0 ? 'start' : i === vals.length - 1 ? 'end' : 'middle', class: 'chart-axis' });
          t.textContent = ex.points[i].date;
          svg.appendChild(t);
        });
      }
    }

    // current point — always emphasised in brand ember
    const cur = pts[pts.length - 1];
    const cr = variant === 'spark' || variant === 'rail' ? 2.6 : variant === 'mini' ? 3.2 : 4.4;
    if (variant === 'hero' || variant === 'line') {
      svg.appendChild(el('circle', { cx: cur[0].toFixed(1), cy: cur[1].toFixed(1), r: cr + 3, fill: TONE.brand, 'fill-opacity': .16 }));
    }
    svg.appendChild(el('circle', { cx: cur[0].toFixed(1), cy: cur[1].toFixed(1), r: cr, fill: TONE.brand, stroke: '#16130f', 'stroke-width': 1.5 }));

    node.replaceChildren(svg);
  }

  function injectStats() {
    document.querySelectorAll('[data-stat]').forEach((n) => {
      const [key, field] = n.getAttribute('data-stat').split('.');
      const ex = window.PROGRESS.byKey[key];
      if (!ex) return;
      let v = '';
      switch (field) {
        case 'current': v = ex.current; break;
        case 'start': v = ex.start; break;
        case 'pr': v = ex.pr; break;
        case 'prDate': v = ex.prDate; break;
        case 'delta': v = (ex.deltaPct >= 0 ? '+' : '') + ex.deltaPct + '%'; break;
        case 'deltaAbs': v = (ex.deltaPct >= 0 ? '+' : '') + Math.round((ex.current - ex.start) * 10) / 10; break;
        case 'weight': v = ex.currentW; break;
        case 'reps': v = ex.currentR; break;
        case 'workouts': v = ex.workouts; break;
        case 'last': v = ex.lastDate; break;
        case 'days': v = ex.days; break;
        case 'scheme': v = ex.scheme || 'free'; break;
        case 'name': v = ex.name; break;
        case 'muscle': v = ex.muscle; break;
        default: v = '';
      }
      n.textContent = v;
    });
  }

  function boot() {
    if (!window.PROGRESS) return;
    injectStats();
    document.querySelectorAll('[data-chart]').forEach(render);
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', boot);
  else boot();

  window.__chartRender = render;
})();
