/* ============================================================================
   Progress data — real product content for the Progress-flow exploration.
   One row per logged exercise_variation; each workout carries the best set
   (max estimated-1RM set) for that exercise on that day.
   e1RM = weight * (1 + reps/30)  (Epley), weight used as-is per schema.
   NOW = Wed Jul 1 2026.
   ==========================================================================*/
(function () {
  const e1 = (w, r) => Math.round(w * (1 + r / 30) * 10) / 10;

  // key, name, muscle, weight_scheme, recent-trend tone, days-since-last,
  // next-step (rule-based, mirrors the Plan engine), one-line coach verdict,
  // and the best set [dateLabel, weight, reps, rir] per workout (oldest→newest).
  const RAW = [
    {
      key: 'rdl', name: 'Romanian Deadlift', muscle: 'Hamstrings',
      scheme: 'per_side', tone: 'up', days: 7,
      next: { kind: 'up', label: '+2.5', target: '85 kg' },
      verdict: 'Cleanest climber you log — up 38% since March, clears every top set. Take 85.',
      sets: [
        ['Mar 8', 60, 8, 2], ['Mar 24', 65, 8, 2], ['Apr 7', 70, 8, 1],
        ['Apr 21', 72.5, 8, 1], ['May 6', 75, 8, 1], ['May 20', 77.5, 8, 1],
        ['Jun 5', 80, 8, 1], ['Jun 24', 82.5, 8, 0],
      ],
    },
    {
      key: 'row', name: 'Seated Cable Row', muscle: 'Back',
      scheme: 'machine', tone: 'up', days: 4,
      next: { kind: 'up', label: '+2.5', target: '55 kg' },
      verdict: 'New high last session at 52.5×11. Progressing on schedule — go 55.',
      sets: [
        ['Mar 5', 40, 12, 2], ['Mar 19', 42.5, 12, 2], ['Apr 2', 45, 10, 1],
        ['Apr 18', 45, 12, 1], ['May 3', 47.5, 11, 1], ['May 17', 50, 10, 1],
        ['Jun 1', 50, 12, 1], ['Jun 27', 52.5, 11, 0],
      ],
    },
    {
      key: 'incline', name: 'Incline Dumbbell Press', muscle: 'Chest',
      scheme: null, tone: 'stall', days: 4,
      next: { kind: 'hold', label: 'HOLD', target: '15 kg' },
      verdict: 'Flat since May 10 — three sessions stuck at 15. Hold, or drop to 12.5 for reps.',
      sets: [
        ['Mar 3', 12.5, 8, 2], ['Mar 15', 12.5, 10, 1], ['Mar 29', 12.5, 12, 1],
        ['Apr 12', 15, 8, 1], ['Apr 26', 15, 10, 1], ['May 10', 15, 11, 0],
        ['May 24', 15, 11, 0], ['Jun 9', 15, 11, 0], ['Jun 27', 15, 10, 0],
      ],
    },
    {
      key: 'preacher', name: 'Preacher Curl', muscle: 'Biceps',
      scheme: null, tone: 'stall', days: 16,
      next: { kind: 'rebase', label: 'REBASE', target: 'swap variation' },
      verdict: 'Big early jump, then 10 weeks flat at 7.5. Stimulus is stale — change the variation.',
      sets: [
        ['Feb 20', 5, 12, 3], ['Mar 6', 7.5, 10, 2], ['Mar 20', 7.5, 11, 2],
        ['Apr 5', 7.5, 12, 1], ['Apr 22', 7.5, 12, 1], ['May 8', 7.5, 12, 1],
        ['May 25', 7.5, 13, 0], ['Jun 15', 7.5, 12, 1],
      ],
    },
    {
      key: 'lat', name: 'Lat Pulldown', muscle: 'Back',
      scheme: 'machine', tone: 'up', days: 15,
      next: { kind: 'up', label: '+2.5', target: '52.5 kg' },
      verdict: 'Steady since March, no wall in sight. Add 2.5.',
      sets: [
        ['Mar 10', 40, 10, 2], ['Mar 26', 42.5, 10, 1], ['Apr 9', 45, 10, 1],
        ['Apr 24', 45, 11, 1], ['May 12', 47.5, 10, 1], ['May 28', 50, 9, 0],
        ['Jun 16', 50, 11, 1],
      ],
    },
    {
      key: 'ohp', name: 'Machine Shoulder Press', muscle: 'Front delts',
      scheme: 'machine', tone: 'up', days: 19,
      next: { kind: 'up', label: '+2.5', target: '27.5 kg' },
      verdict: 'Recovered from the April dip and set a new high at 25. Keep climbing.',
      sets: [
        ['Mar 2', 20, 10, 2], ['Mar 16', 22.5, 10, 1], ['Mar 30', 22.5, 11, 1],
        ['Apr 13', 20, 10, 2], ['Apr 27', 20, 12, 1], ['May 11', 22.5, 10, 1],
        ['May 26', 22.5, 12, 0], ['Jun 12', 25, 10, 0],
      ],
    },
    {
      key: 'hack', name: 'Hack Squat', muscle: 'Quads',
      scheme: 'machine', tone: 'stall', days: 13,
      next: { kind: 'hold', label: 'HOLD', target: '100 kg' },
      verdict: 'Two sessions parked at 100. Not stalled yet — hold once more, then load.',
      sets: [
        ['Mar 4', 70, 10, 2], ['Mar 18', 80, 10, 2], ['Apr 1', 90, 8, 1],
        ['Apr 16', 90, 10, 1], ['Apr 30', 95, 10, 1], ['May 14', 100, 9, 0],
        ['May 30', 100, 10, 0], ['Jun 18', 100, 10, 0],
      ],
    },
    {
      key: 'calf', name: 'Standing Calf Raise', muscle: 'Calves',
      scheme: 'machine', tone: 'cold', days: 38,
      next: { kind: 'cold', label: 'COLD', target: '38d idle' },
      verdict: '38 days untouched — the longest-cold lift you log. Three sessions all year.',
      sets: [
        ['Mar 12', 60, 15, 2], ['Apr 20', 60, 15, 1], ['May 24', 60, 16, 1],
      ],
    },
    {
      key: 'lateral', name: 'Cable Lateral Raise', muscle: 'Side delts',
      scheme: 'per_side', tone: 'up', days: 17,
      next: { kind: 'up', label: '+reps', target: '8 kg · 18 reps' },
      verdict: 'Creeping up rep by rep. Bank a few more before adding load.',
      sets: [
        ['Mar 7', 5, 15, 3], ['Mar 21', 7.5, 12, 2], ['Apr 6', 7.5, 14, 1],
        ['Apr 23', 7.5, 15, 1], ['May 9', 8, 14, 1], ['May 27', 8, 15, 0],
        ['Jun 14', 8, 16, 0],
      ],
    },
    {
      key: 'pecdeck', name: 'Reverse Pec Deck', muscle: 'Rear delts',
      scheme: 'machine', tone: 'up', days: 21,
      next: { kind: 'up', label: '+2.5', target: '27.5 kg' },
      verdict: 'Quietly consolidating at 25. One more clean session, then load.',
      sets: [
        ['Mar 9', 18, 14, 2], ['Apr 4', 20, 14, 1], ['Apr 25', 22.5, 12, 1],
        ['May 16', 22.5, 14, 1], ['Jun 10', 25, 12, 0],
      ],
    },
  ];

  // Derive series + summary stats for each exercise.
  const byKey = {};
  const list = RAW.map((ex) => {
    const points = ex.sets.map(([date, w, r, rir]) => ({
      date, w, r, rir, e1: e1(w, r),
    }));
    const series = points.map((p) => p.e1);
    const last = points[points.length - 1];
    const first = points[0];
    const pr = Math.max(...series);
    const o = {
      ...ex,
      points, series,
      current: last.e1,
      currentW: last.w,
      currentR: last.r,
      lastDate: last.date,
      start: first.e1,
      startDate: first.date,
      pr,
      prDate: points[series.indexOf(pr)].date,
      deltaPct: Math.round(((last.e1 - first.e1) / first.e1) * 100),
      workouts: points.length,
    };
    byKey[ex.key] = o;
    return o;
  });

  // Group by muscle (never push/pull/leg). Muscle "days" = its freshest lift.
  const muscleOrder = [
    'Chest', 'Back', 'Side delts', 'Rear delts', 'Front delts',
    'Biceps', 'Triceps', 'Quads', 'Hamstrings', 'Calves',
  ];
  const muscles = {};
  list.forEach((ex) => {
    (muscles[ex.muscle] = muscles[ex.muscle] || { name: ex.muscle, exercises: [], days: 99 })
      .exercises.push(ex);
  });
  Object.values(muscles).forEach((m) => {
    m.days = Math.min(...m.exercises.map((e) => e.days));
  });
  const muscleList = muscleOrder
    .filter((m) => muscles[m])
    .map((m) => muscles[m]);

  window.PROGRESS = {
    e1, list, byKey, muscles, muscleList,
    now: 'Wed Jul 1',
    // convenience orderings used by several directions
    byImprovement: [...list].sort((a, b) => b.deltaPct - a.deltaPct),
    byStale: [...list].sort((a, b) => b.days - a.days),
    byRecent: [...list].sort((a, b) => a.days - b.days),
  };
})();
