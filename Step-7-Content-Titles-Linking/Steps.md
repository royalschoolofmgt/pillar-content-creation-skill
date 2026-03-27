# Step 7 — Content Titles & Linking: Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** UK
**Tool:** Agent Browser
**Evidence:** Screenshots saved to this folder for every step
**Depends on:** Steps 1-6 completed

---

## Phase 1: Pillar Page Titles

- [ ] **1.1** For each pillar (8-12), write a comprehensive title (60-80 chars, includes primary keyword)
- [ ] **1.2** Assign URL slug per pillar page (/pillar-slug)
- [ ] **1.3** Set word count target per pillar (4,000-7,000 words)
- [ ] **1.4** Assign primary + secondary keywords per pillar page
- [ ] **1.5** Match content format to SERP feature analysis from Step 6

## Phase 2: Spoke Article Titles

- [ ] **2.1** For each pillar, write 15-30 spoke article titles (50-70 chars, includes target keyword)
- [ ] **2.2** Assign URL slug per spoke (/pillar-slug/spoke-slug)
- [ ] **2.3** Assign content format per spoke (Guide / Blog / Tutorial / Comparison / Listicle / Product / Resource / Tool)
- [ ] **2.4** Set word count target per spoke based on format
- [ ] **2.5** Assign primary + secondary keywords per spoke
- [ ] **2.6** Apply title writing rules:
  - [ ] Include numbers when possible (10 Ways, 15 Fixes, 2026 Guide)
  - [ ] Include the year for freshness signal (2026)
  - [ ] Include brand name in 20-30% of titles
  - [ ] Use power words (Complete, Ultimate, Proven, Step-by-Step)
  - [ ] Match search intent in title structure

## Phase 3: SERP Validation of Titles

- [ ] **3.1** Google search the primary keyword for each pillar title — screenshot SERP
- [ ] **3.2** Verify the title format matches what currently ranks
- [ ] **3.3** Spot-check 10-15 spoke titles — Google their keywords and confirm format alignment
- [ ] **3.4** Screenshot top-ranking competitor titles for comparison
- [ ] **3.5** Adjust any titles that don't match SERP-validated formats

## Phase 4: Internal Linking Map

- [ ] **4.1** Map every spoke → its parent pillar (mandatory upward link)
- [ ] **4.2** Map every spoke → 2-3 spokes in OTHER pillars (cross-pillar links)
- [ ] **4.3** Map every pillar → its top 5-10 spokes (downward links)
- [ ] **4.4** Map every pillar → 2-3 other pillars (cross-pillar links)
- [ ] **4.5** Assign CTA/conversion page per pillar
- [ ] **4.6** Verify no orphan pages — every page has at least 3 internal links pointing to it

---

## Output

After completing all steps, produce:

- [ ] `content-titles.json` — all pillar + spoke titles with URLs, keywords, formats, word counts
- [ ] `internal-linking-map.json` — complete link map (spoke→pillar, cross-links, CTAs)
- [ ] `content-titles-linking.md` — single report rendering all data with tables below
- [ ] `screenshots/` folder — SERP validation screenshots for titles

### Pillar Pages Table (render in content-titles-linking.md)

| # | Pillar Title | URL Slug | Format | Word Count | Primary Keyword | Secondary Keywords |
|---|-------------|----------|--------|------------|----------------|-------------------|
| 1 | | | | | | |

### Spoke Articles Table (render in content-titles-linking.md, per pillar)

| # | Spoke Title | URL Slug | Format | Word Count | Primary Keyword | Secondary Keywords | Parent Pillar |
|---|------------|----------|--------|------------|----------------|-------------------|--------------|
| 1 | | | | | | | |

### Internal Linking Map (render in content-titles-linking.md)

| Page | Type | Links TO (pillar) | Links TO (cross-pillar spokes) | Links TO (cross-pillar) | CTA Page |
|------|------|------------------|-------------------------------|------------------------|----------|
| | Pillar/Spoke | | | | |

### Pillar Overview (render in content-titles-linking.md)

| Pillar | Total Spokes | Total Volume | Publish Order | CTA Page |
|--------|-------------|-------------|--------------|----------|
| | | | | |

---

## Rules

1. **Sequential execution only** — complete each step before moving to the next
2. **Screenshot everything** — SERP validation for title format decisions
3. **SERP-validated formats only** — titles must match what Google currently rewards
4. **No orphan pages** — every page links and is linked to
5. **JSON + MD output** — create `content-titles.json` and `internal-linking-map.json`, but also render all tables in `content-titles-linking.md`
