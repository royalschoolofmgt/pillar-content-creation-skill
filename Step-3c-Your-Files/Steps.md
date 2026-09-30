# Step 3c — Your Files (only when the merchant attached files)

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Inputs Required:** Step 1 (brand-discovery.md), Step 2 (competitor-discovery.md), Step 3 (content-gap-analysis.md),
Step 3b (scope-estimation.md), and the merchant's files in `sources/` (listed in `sources/INDEX.json`)

> **This step exists ONLY when the content plan was created with files** (decks, spec sheets, brochures, price
> lists). The files are stored in Vortex Memory and have already been read into text by the engine:
> `sources/NN-<name>.md`, one per file, every slide / page / section under its own heading. When
> `sources/INDEX.json` does not exist, skip this step entirely — never invent its output.

---

## Objective

Turn the merchant's own material into research inputs BEFORE keyword research (Step 4), so the plan is built on
what the brand actually sells, claims and wants to say — not only on what the storefront and competitors show.
The files OUTRANK anything inferred from the storefront or general knowledge. Never contradict or embellish them.

---

## Phase 1 — Read

- [ ] Read every file in `sources/` in full (a long file in parts — do not skim)
- [ ] Note what each file is (deck, spec sheet, brochure, price list) and how many slides / pages it has

## Phase 2 — Extract (each item names its file and slide / page)

- [ ] **Products** — every product, range or service named, with its key detail
- [ ] **Facts** — specs, materials, certifications, numbers, claims, exactly as the file states them
- [ ] **Themes** — the recurring subjects of the files
- [ ] **Seed keywords** — the merchant's own product names, materials and terms a customer would search,
      each assigned to the pillar / category it belongs to (from Step 3b)
- [ ] **Topic candidates** — articles the files clearly support (a launch, a spec explained, a care guide,
      a story), each with its angle

## Phase 3 — Record

- [ ] Write `source-insights.json` in this folder:

```json
{
  "files": [{ "name": "…", "units_read": 0 }],
  "products": [{ "name": "…", "detail": "…", "file": "…", "unit": "Slide 4" }],
  "facts": [{ "fact": "…", "file": "…", "unit": "Page 12" }],
  "themes": ["…"],
  "seed_keywords": [{ "keyword": "…", "category": "…", "file": "…", "unit": "…" }],
  "topic_candidates": [{ "title": "…", "angle": "…", "file": "…", "unit": "…" }]
}
```

- [ ] Mark `.source-files-done` and set `pipeline-state.json` → `stages.source_files.status = "completed"`

---

## How later steps use it

| Step | Uses |
|------|------|
| 4 Keyword Research | Every `seed_keywords` entry goes into its category's seed group FIRST |
| 6 Pillar Architecture | Every `topic_candidates` entry with search demand becomes a spoke of its pillar, carrying `source_refs` |
| Articles (Phase 2) | The writer cites facts by file and slide / page |
