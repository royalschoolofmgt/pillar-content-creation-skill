# Step 5 — Cannibalisation Check: Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Tool:** none (pure data step — no browser)
**Depends on:** Steps 1-4 completed (especially Step 4 `shortlisted-keywords.csv`)

---

## Why this step runs BEFORE pillar architecture

The store's already-published posts are the live blog it already ranks for. If we cluster keywords into
pillars first and only check for cannibalisation afterwards, we build a plan and then tear it apart —
backwards. So cannibalisation runs here, on the **keyword set**, before any pillar exists. It prunes /
re-angles keywords that duplicate a live post, and hands the **cleared** keyword set to Step 6, which builds
pillars from what survives. Nothing downstream ever proposes a near-duplicate of a page the store already has.

The live blog is in **`published-content.json` at the pipeline root**:
`{ inventory: [{title, slug, url}], source, count }`. This file is produced by the box (sitemap/site crawl)
and is present **even when the store has no Admin API** — that is the whole point: it is the source of truth
here. When `store-config.json:has_store_api=true`, `Step-1-Brand-Discovery/blog-audit.json:live_titles`
**supplements** it (richer titles). If both are missing or empty, note it and pass every keyword through as
`clear` (nothing to guard against) — never hard-fail.

---

## Phase 1: Load live content

- [ ] **1.1** Load `published-content.json` from the pipeline root (always try this first)
- [ ] **1.2** If `store-config.json:has_store_api=true`, also load `Step-1-Brand-Discovery/blog-audit.json`
      and merge its `live_titles` into the live-content set
- [ ] **1.3** Build the comparison set = every live post `{title, slug, url}`. Record `live_count`.
      If `live_count == 0`, skip to Phase 3 and mark every keyword `clear`.

## Phase 2: Compare every shortlisted keyword against live content

- [ ] **2.1** Load `Step-4-Keyword-Research/shortlisted-keywords.csv`
- [ ] **2.2** For each keyword row, compute significant-word overlap against every live post title/slug
      (drop stop-words; a match = ≥2 shared significant words OR ≥50% of the keyword's words present)
- [ ] **2.3** Classify each keyword:
      - `clear` — no meaningful overlap with any live post. Keep as-is.
      - `reangle` — overlaps a live post but a genuinely different intent/format/audience is possible.
        Keep the keyword but record the angle it must take to NOT cannibalise the live post.
      - `dropped` — a near-duplicate of a live post's title AND intent, with no distinct angle. Remove it
        so no pillar is ever built on it.
- [ ] **2.4** Prefer keywords that fill GAPS the live blog does not cover — never re-create a live page.

## Phase 3: Emit the cleared keyword set + the audit record

- [ ] **3.1** Write `keywords-cleared.csv` — the SAME columns as `shortlisted-keywords.csv`, with:
      - every `dropped` row removed,
      - one extra column `cannibalisation` = `clear | reangle`,
      - `reangle` rows keep the keyword (Step 6 clusters them; the angle note lives in `dedup-check.json`).
      This is the file Step 6 clusters from. It must always be written (even if identical to shortlisted).
- [ ] **3.2** Write `dedup-check.json` recording, per keyword compared:
      `{ "keyword": str, "existing_match": url|null, "relation": "clear"|"reangle"|"dropped", "note": str }`
      plus a header `{ "live_count": int, "checked": int, "cleared": int, "reangled": int, "dropped": int }`.
- [ ] **3.3** Confirm zero `dropped` keywords remain in `keywords-cleared.csv`, and that the file is non-empty
      (if every keyword dropped — implausible — keep the highest-volume `reangle` candidates so Step 6 is not starved).

---

## Output

| File | Description |
|------|-------------|
| `keywords-cleared.csv` | Shortlisted keywords minus cannibalising ones, with a `cannibalisation` column. **Step 6 clusters from this file.** |
| `dedup-check.json` | Per-keyword comparison vs the store's live posts (`published-content.json`): clear / reangle / dropped, with a summary header |

---

## Rules

1. **Runs before pillars** — this is the whole reason the step exists. Never let a pillar be built on a dropped keyword.
2. **`published-content.json` is the source of truth** — it works without a store API. `blog-audit.json` only supplements it.
3. **Never hard-fail on missing live content** — no live posts means everything is `clear`; write the files and move on.
4. **`keywords-cleared.csv` is always written** — Step 6 depends on it; a missing file makes Step 6 fall back to `shortlisted-keywords.csv`, which silently defeats this step.
5. **Re-angle over drop where a real distinct angle exists** — the goal is a plan that complements the live blog, not a smaller plan for its own sake.
6. **No browser** — pure data comparison. No screenshots.
