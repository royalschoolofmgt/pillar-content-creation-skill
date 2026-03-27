# Step 3b — Content Scope Estimation

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Date:** {{DISCOVERY_DATE}}
**Inputs Required:** Step 1 (brand-discovery.md), Step 2 (competitor-discovery.md), Step 3 (content-gap-analysis.md)

---

## Objective

Before running keyword research (Step 4), establish the full content scope: how many pillars, how many spokes, and how many keywords you need to research. This prevents both under-scoping (missing major topic clusters) and over-scoping (burning research time on content you won't build for 12 months).

---

## Phase 1 — Pillar Candidate Identification

**1.1** Pull all product/service categories from Step 1 (brand-discovery.md)
- [ ] List every primary product category {{BRAND_NAME}} sells
- [ ] List every secondary/niche category
- [ ] Note which categories have dedicated collection/landing pages vs no SEO page

**1.2** Pull all blue ocean and gap topics from Step 3 (content-gap-analysis.md)
- [ ] List all Tier 1 content gaps (high volume, all competitors weak)
- [ ] List all Tier 2 content gaps (medium volume, clear opportunity)
- [ ] List all "Beatable Pages" clusters (topics with competitor pages to outrank)

**1.3** Cross-reference competitor pillar patterns from Step 2
- [ ] List {{C1_NAME}}'s main blog/guide categories (~{{C1_BLOG_POSTS}} posts)
- [ ] List {{C2_NAME}}'s main blog/guide categories (~{{C2_BLOG_POSTS}} posts)
- [ ] List {{C3_NAME}}'s main guide categories (~{{C3_BLOG_POSTS}} posts)
- [ ] Identify which topic clusters ALL three competitors cover (validate demand)
- [ ] Identify which clusters only 1-2 cover (opportunity gaps)

**1.4** Draft raw pillar candidate list
- [ ] Merge product categories + gap topics + competitor patterns into a single list
- [ ] Eliminate duplicates and merge overlapping themes
- [ ] Target: 10–20 raw candidates to be narrowed to 8–12 pillars

---

## Phase 2 — Spoke Estimation Per Pillar

**2.1** For each pillar candidate, estimate spoke article count
- [ ] Count how many distinct questions/subtopics exist under each pillar
- [ ] Use competitor blog post depth as a benchmark:
  - {{C1_NAME}}: ~{{C1_BLOG_POSTS}} posts across their categories
  - {{C2_NAME}}: ~{{C2_BLOG_POSTS}} posts across their categories
  - {{C3_NAME}}: ~{{C3_BLOG_POSTS}} articles across their guide hub
- [ ] Assign Low (4–6), Medium (7–12), or High (13–20) spoke depth per pillar
- [ ] Set realistic target spoke count per pillar based on client resources

**2.2** Identify spoke content formats per pillar
- [ ] For each pillar, list which formats apply:
  - [ ] Buyer's Guide / Best Of (commercial intent)
  - [ ] How-To / Tutorial (informational intent)
  - [ ] Comparison / vs. Article (commercial intent)
  - [ ] FAQ / Explainer (informational intent)
  - [ ] Review / Roundup (commercial intent)
  - [ ] Regulatory / News (informational intent)
- [ ] Format count informs minimum spoke count per pillar

---

## Phase 3 — Keyword Volume Estimation Per Piece

**3.1** Estimate keywords needed per content type
- [ ] Pillar pages: 8–15 keywords each (head + mid-tail + long-tail cluster)
- [ ] Spoke articles — Buyer's Guide / Best Of: 5–10 keywords
- [ ] Spoke articles — How-To / Tutorial: 3–6 keywords
- [ ] Spoke articles — Comparison / vs.: 3–5 keywords
- [ ] Spoke articles — FAQ / Explainer: 2–4 keywords
- [ ] Record the assumed avg keywords per piece for this client

**3.2** Calculate total keyword research load
- [ ] Total Pillar Pages × avg keywords per pillar = Pillar Keyword Count
- [ ] Total Spoke Articles × avg keywords per spoke = Spoke Keyword Count
- [ ] Add 20% buffer for discovery (related terms, variants, negatives)
- [ ] Record Grand Total keywords to research in Step 4

---

## Phase 4 — Scope Tiers

**4.1** Define 3 build tiers for this client
- [ ] **Tier 1 — Minimum Viable Build (MVB):** Pillars only + 3 spokes each
- [ ] **Tier 2 — Standard Build:** All pillars + 6–8 spokes each (recommended)
- [ ] **Tier 3 — Aggressive / Full Build:** All pillars + 10–15 spokes each (DA 30+ clients)

**4.2** Match tier to client context
- [ ] Current DA: {{DOMAIN_AUTHORITY}} → guides realistic tier selection
- [ ] Current blog posts: {{BLOG_POSTS_COUNT}} → gauge team's content capacity
- [ ] Competitor closest in DA: {{C1_NAME}} (DA {{C1_DA}}) — use as benchmark
- [ ] Recommend a tier and document the rationale

**4.3** Set final scope numbers
- [ ] Final Pillar Count: ___
- [ ] Final Total Spoke Count: ___
- [ ] Final Total Articles (Pillars + Spokes): ___
- [ ] Final Total Keywords to Research: ___
- [ ] Recommended Tier: ___

---

## Phase 5 — Output: Update config.json

- [ ] Open config.json
- [ ] Update `scope` object with final estimates:
  - `pillars` — final pillar count
  - `avg_spokes_per_pillar` — average spokes per pillar
  - `total_spokes` — total spoke count
  - `total_articles` — pillars + spokes
  - `avg_keywords_per_piece` — average keyword target per content piece
  - `total_keywords_to_research` — grand total for Step 4
  - `tier` — "mvb" / "standard" / "aggressive"
  - `rationale` — one-sentence reason for tier choice
- [ ] Save scope-estimation.md deliverable

---

## Deliverable

`Step-3b-Content-Scope-Estimation/scope-estimation.md`

**Time estimate:** 1–2 hours (mostly table-filling from existing Step 1–3 outputs)
