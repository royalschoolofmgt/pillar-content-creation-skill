# Step 9 — Verifier: Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Tool:** none (pure data step — no browser)
**Depends on:** Steps 1-8 completed (pillars from Step 6, positions from Step 7, titles+linking from Step 8)

---

## Why this step exists

Every earlier step is local — it sees only its own slice. No step so far looks at the **whole plan at once**.
The verifier does: it re-checks the assembled plan holistically, catches the problems that only show up
across pillars/spokes, and — critically — **fixes them in place** so the corrections reach the final
deliverables. A verifier that only writes a report and leaves the plan wrong is useless: `content_map.json`
is assembled from `titles-linking.json` and the pillar defs, so **the verifier must write its fixes back
into those files**, not just into `verification.json`.

This runs as the last planning step, **before** the deliverables are assembled.

---

## Phase 1: Load the whole plan

- [ ] **1.1** Load `Step-8-Content-Titles-Linking/titles-linking.json` (titles, slugs, formats, links)
- [ ] **1.2** Load the pillar defs (`config.json:scope.pillar_definitions` + `Step-6-Pillar-Architecture/pillars.json`)
- [ ] **1.3** Load `Step-7-Position-Estimation/positions.json` (bands, recommended formats)
- [ ] **1.4** Load `published-content.json` from the pipeline root (live blog — for the final cannibalisation re-check)
- [ ] **1.5** Load `Step-5-Cannibalisation/dedup-check.json` (what Step 5 re-angled / dropped)

## Phase 2: Holistic checks (things no earlier step can see)

Run every check below across the FULL set of pillars + spokes. For each problem found, decide a fix and
apply it (Phase 3), then record it as a mutation (Phase 4).

- [ ] **2.1 Duplicate / near-duplicate titles across pillars** — no two spokes (or a spoke and a hub) may
      share a title or a near-identical one. Re-angle the lower-priority one; if no distinct angle, drop it.
- [ ] **2.2 Slug collisions** — every `slug` must be unique across all hubs + spokes. Disambiguate duplicates.
- [ ] **2.3 Keyword drift** — a spoke whose primary keyword no longer matches its assigned pillar's theme
      moves to the pillar it actually fits (or is dropped if it fits none).
- [ ] **2.4 Orphan keywords** — a cleared keyword (Step 5) that never made it into any spoke: fold it into
      the best-fitting pillar as a spoke, or record why it was intentionally left out.
- [ ] **2.5 Final cannibalisation re-check** — re-compare every FINAL title against `published-content.json`.
      This is the last line of defence after Step 8's re-angles: any title that now duplicates a live post's
      title or intent must be re-angled or dropped here.
- [ ] **2.6 Format / word-band mismatch** — each spoke's `format` must have a `word_count` inside that
      format's band (P 3,500–5,000 · H 1,500–2,500 · E 1,200–2,000 · B 2,000–3,000 · C 1,800–2,800 ·
      RU 2,000–3,500 · L 1,000–1,800 · O 800–1,200 · S 400–700). Fix the word_count (or the format if the
      title's intent clearly disagrees with the code).
- [ ] **2.7 Empty / thin pillars** — a pillar with 0 spokes is removed; a pillar under the scale's spoke
      floor is flagged (fold or note).
- [ ] **2.8 Linking integrity** — every spoke still links back to its pillar hub; no link points at a
      dropped/renamed slug. Repair links broken by this step's own edits.

## Phase 3: Apply fixes IN PLACE (this is the point of the step)

- [ ] **3.1** Write every correction back into `Step-8-Content-Titles-Linking/titles-linking.json`
      (titles, slugs, formats, word counts, links).
- [ ] **3.2** Where a pillar was re-scoped, dropped, or a spoke moved pillars, update the pillar defs:
      `Step-6-Pillar-Architecture/pillars.json` AND `config.json:scope.pillar_definitions` (keep them in sync).
- [ ] **3.3** Re-verify after editing: re-run Phase 2 once over the mutated files and confirm zero remaining
      problems (a fix must not introduce a new duplicate/collision). Iterate at most twice.

## Phase 4: Write `verification.json` (ALWAYS — even on a clean run)

- [ ] **4.1** Write `verification.json` at the pipeline root, UNCONDITIONALLY. On a clean run it still gets
      written with empty arrays and `status:"clean"`. It is a required deliverable — never skip the write.

```json
{
  "generated_at": "ISO-8601",
  "status": "clean | corrected",
  "checked": { "pillars": 0, "spokes": 0, "titles": 0 },
  "summary": { "titles_deduped": 0, "slugs_fixed": 0, "keywords_moved": 0, "orphans_placed": 0,
               "cannibalising_dropped": 0, "format_band_fixed": 0, "pillars_removed": 0, "links_repaired": 0 },
  "mutations": [
    { "check": "duplicate-title|slug-collision|keyword-drift|orphan-keyword|cannibalisation|format-band|empty-pillar|link",
      "severity": "high|warning",
      "topic_id": "t7|u2|<slug>",
      "before": "…", "after": "…",
      "action": "reangled|dropped|moved|renamed|word_count_adjusted|format_changed|link_repaired|placed" }
  ],
  "notes": []
}
```

- [ ] **4.2** `mutations[]` records EVERY change made in Phase 3, one entry each — this is the feed the
      workbench Content-Audit panel renders as evidence, so `before`/`after` must be human-readable.
- [ ] **4.3** `status` = `"clean"` only when `mutations` is empty; otherwise `"corrected"`.

---

## Output

| File | Description |
|------|-------------|
| `verification.json` (pipeline root) | Holistic verification result + every mutation applied. **Always written**, even on a clean run. |
| Updated `Step-8-Content-Titles-Linking/titles-linking.json` | Corrected titles/slugs/formats/links (in place) |
| Updated `Step-6-Pillar-Architecture/pillars.json` + `config.json:scope.pillar_definitions` | Re-scoped pillar defs (in place, kept in sync) |

---

## Rules

1. **Fixes must reach the deliverable** — always write corrections back into `titles-linking.json` / pillar defs. A verifier that only writes `verification.json` is broken: Stage assembly reads the corrected files, not the report.
2. **`verification.json` is written unconditionally** — including a clean run (`{status:"clean", mutations:[]}`). It is a hard gate deliverable; skipping the write fails the whole report.
3. **Record every mutation** as `{check, severity, topic_id, before, after, action}` — human-readable `before`/`after`.
4. **Runs before deliverable assembly** — never merge this into the assembly step; verify, mutate, THEN assemble.
5. **Idempotent-ish** — re-running the check after fixes must find zero problems; iterate at most twice, then record any residue in `notes`.
6. **No browser** — pure data step. No screenshots.
