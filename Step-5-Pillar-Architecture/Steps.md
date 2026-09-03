# Step 5 — Pillar Architecture: Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Tool:** Agent Browser
**Evidence:** Screenshots saved to `screenshots/` folder for every step
**Depends on:** Steps 1-4 completed (especially Step 4 keyword data)

---

## Phase 1: Keyword Clustering

- [ ] **1.1** Load master keyword list from Step 4
- [ ] **1.2** Group keywords by natural topic similarity
- [ ] **1.3** Identify distinct clusters from the data
- [ ] **1.4** Calculate total search volume per cluster
- [ ] **1.5** Verify no major keyword groups left unassigned — zero orphans

## Phase 2: Pillar Definition

- [ ] **2.1** Assign pillar names and URL slugs
- [ ] **2.2** Write 2-3 sentence descriptions per pillar
- [ ] **2.3** Define sub-sections per pillar
- [ ] **2.4** Map each pillar to a primary {{BRAND_NAME}} product category
- [ ] **2.5** Calculate keyword counts per pillar
- [ ] **2.6** Calculate volumes per pillar
- [ ] **2.7** Assign all keywords to pillars — update `master-keywords.json` and `.csv`

## Phase 2b: Existing-Content Cannibalisation Guard (run BEFORE finalising pillars)

The store's already-published posts are in `published-content.json` at the pipeline root —
`{ inventory: [{title, slug, url}], source, count }`. This is the store's live blog. If the file is
missing or `count` is 0, note that and continue (nothing to guard against). This step exists so the plan
**complements** the live blog instead of competing with pages the store already ranks for.

- [ ] **2b.1** Load `published-content.json` from the pipeline root
- [ ] **2b.2** For every pillar AND every spoke, compare its title + target search intent against each live post
- [ ] **2b.3** If a proposed topic duplicates a live post's title OR its search intent, it **cannibalises** an
      existing page — re-angle it (clearly different intent/format/audience) or drop it. Never propose a
      near-duplicate of a page the store already has.
- [ ] **2b.4** Prefer topics that fill GAPS the live posts do not cover; lean the pillar toward those
- [ ] **2b.5** Write `dedup-check.json` (in this Step-5 folder) recording, per pillar/spoke:
      `{ "topic": str, "slug": str, "existing_match": url|null, "relation": "gap-fill"|"complements"|"differentiates"|"dropped-cannibalising", "note": str }`
- [ ] **2b.6** Confirm zero remaining spokes are near-duplicates of a live post

## Phase 3: Pillar Validation (via SERP checks)

- [ ] **3.1** Google search each pillar's primary keyword — screenshots saved
- [ ] **3.2** Verify pillar-style comprehensive pages dominate SERPs
- [ ] **3.3** Note difficulty per pillar and strategy for hard ones
- [ ] **3.4** Confirm zero cannibalization — all pillars show distinct SERP results
- [ ] **3.5** Confirm all pillars have >=15 spoke keywords

## Phase 4: Pillar Framework Check

- [ ] **4.1** Core Product Pillar — covered?
- [ ] **4.2** Category/Definitional Pillar — covered?
- [ ] **4.3** Use-Case / Lifestyle Pillar — covered?
- [ ] **4.4** Comparison / Alternative Pillar — covered?
- [ ] **4.5** Problem-Solution Pillar — covered?
- [ ] **4.6** Educational / Beginner Pillar — covered?
- [ ] **4.7** Industry/Vertical Pillar — covered?
- [ ] **4.8** Geo-Specific Pillar — covered (if applicable)?
- [ ] **4.9** Confirm all framework types covered across pillars

---

## Output

| File | Description |
|------|-------------|
| `pillars.json` | Pillar definitions with name, slug, description, sub-sections, volume, keyword count, top keywords |
| `dedup-check.json` | Per pillar/spoke comparison against the store's live posts (`published-content.json`): gap-fill / complements / differentiates / dropped-cannibalising |
| `pillar-summary.md` | Full overview: pillar table, sub-sections, top keywords, framework validation, SERP results |
| `build-pillars.py` | Python script that classifies keywords, produces pillars.json, updates master-keywords |
| Updated `master-keywords.json` | Pillar column now filled for all keywords |
| Updated `master-keywords.csv` | Pillar column now filled for all keywords |
| `screenshots/` | SERP validation screenshots |

---

## Rules

1. **Sequential execution only** — complete each step before moving to the next
2. **Screenshot everything** — SERP validation for every pillar
3. **Data-driven only** — every pillar must be justified by keyword volume from Step 4
4. **No orphan keywords** — every keyword must belong to a pillar
5. **Minimum 15 spoke keywords** per pillar
5b. **No cannibalisation of live content** — no pillar or spoke may duplicate the title or search intent of an existing published post (`published-content.json`); re-angle or drop it and record the decision in `dedup-check.json`
6. **Agent Browser for ALL browsing** — any task that requires visiting a webpage, taking screenshots, clicking, or reading page content MUST use `agent-browser` via the CDP connection. The only exception is fetching `sitemap.xml` files, which can use WebFetch/curl. Never use WebFetch for browsing live pages.
7. **No parallel agents for CDP tasks** — never run multiple agents in parallel when using agent-browser CDP. Execute browser tasks sequentially, one at a time.
8. **Clean up tabs at start of every session** — before starting any browsing work, list all open tabs and close stale ones. Only keep the tab you're actively working with.

### Agent Browser Tab Management Reference
```
agent-browser tab                     # List all tabs
agent-browser tab new [url]           # New tab (optionally with URL)
agent-browser tab <n>                 # Switch to tab n
agent-browser tab close [n]           # Close tab n (or current if omitted)
agent-browser window new              # New browser window
```
