# SEO Domination Engine — Master Matrix

## 9-Step Architecture Checklist

> Pipeline order: **1 Brand → 2 Competitor → 3 Gap → (3b Scope) → 4 Keyword → 5 Cannibalisation →
> 6 Pillar Architecture → 7 Position → 8 Titles & Linking → 9 Verifier.**
> Cannibalisation runs on the KEYWORD set BEFORE pillars are built, so no pillar is ever built on a page
> the store already ranks for. The Verifier is the final holistic pass — it re-checks the whole plan and
> fixes it in place before the deliverables are assembled.

---

### Step 1 — Brand Discovery
> Research brand, products, existing content, site health + Technical SEO baseline (indexing, speed, crawlability)

- [ ] Research brand positioning, mission, and unique selling points
- [ ] Identify and document all products/services with descriptions and URLs
- [ ] Audit existing blog content (count, topics, quality)
- [ ] Analyze site architecture (URL structure, navigation, internal links)
- [ ] Run Technical SEO baseline (crawlability, indexing status, page speed)
- [ ] Check Google Search Console stats (indexed pages, errors, coverage)
- [ ] Screenshots: site structure, page speed scores — save to screenshots/

---

### Step 2 — Competitor Discovery
> Competitor blogs, keywords, rankings, strengths/weaknesses

- [ ] Identify top 3 competitors — {{C1_NAME}} (client-provided), {{C2_NAME}}, {{C3_NAME}}
- [ ] Audit each competitor's blog ({{C1_NAME}} ~{{C1_BLOG_POSTS}}, {{C2_NAME}} ~{{C2_BLOG_POSTS}}, {{C3_NAME}} ~{{C3_BLOG_POSTS}}+ guides)
- [ ] Identify competitor top-ranking keywords (via Agent Browser + KE)
- [ ] Analyze competitor strengths (awards, content depth, DA, Trustpilot)
- [ ] Analyze competitor weaknesses (DA drops, sitemap gaps, outdated content, low traffic)
- [ ] Document competitor domain authority and backlink profiles — DA {{C1_DA}}/{{C2_DA}}/{{C3_DA}}
- [ ] Screenshots: competitor SERPs, homepages, blogs, Trustpilot, site: searches

---

### Step 3 — Content Gap Analysis
> Cross-reference brand vs competitors to find opportunities

- [ ] Build brand vs competitor keyword overlap matrix
- [ ] Identify keywords competitors rank for that {{BRAND_NAME}} does NOT
- [ ] Identify keywords where ALL competitors rank poorly (blue ocean keywords)
- [ ] Identify topics with high volume but weak existing SERP content
- [ ] Prioritize gaps by volume, difficulty, and business relevance
- [ ] Screenshots: SERP screenshots across target queries with KE data overlays

---

### Step 3b — Content Scope Estimation
> Based on Steps 1–3 deliverables, estimate full content scope: pillars, spokes, and keyword research load

- [ ] Pull all product/service categories from Step 1 and list pillar candidates
- [ ] Pull all content gap clusters from Step 3 and add to pillar candidate list
- [ ] Cross-reference competitor pillar patterns — {{C1_NAME}} (~{{C1_BLOG_POSTS}} posts), {{C2_NAME}} (~{{C2_BLOG_POSTS}} posts), {{C3_NAME}} (~{{C3_BLOG_POSTS}} guides)
- [ ] Consolidate raw pillar candidates to final 8–12 pillars
- [ ] Estimate spoke count per pillar (Low: 4–6 / Medium: 7–12 / High: 13–20)
- [ ] Identify content formats per pillar (Buyer's Guide, How-To, Comparison, FAQ, Review, Regulatory)
- [ ] Estimate keywords per content type and calculate total keyword research load
- [ ] Define 3 scope tiers (MVB / Standard / Aggressive) and select recommended tier
- [ ] Record final scope: {{SCOPE_PILLARS}} pillars · {{SCOPE_TOTAL_SPOKES}} spokes · {{SCOPE_TOTAL_ARTICLES}} total articles · {{SCOPE_TOTAL_KEYWORDS}} keywords to research
- [ ] Update config.json → scope object with all final numbers
- [ ] Screenshots: none required — this is a planning/calculation step

---

### Step 4 — Keyword Research (Real Data)
> Google Search + Keywords Everywhere + Google Trends — all columns with REAL volume/CPC/competition

- [ ] Search target keywords via Google with Keywords Everywhere active
- [ ] Capture real search volume, CPC, and competition data per keyword
- [ ] Run Google Trends analysis for pillar-level terms and key clusters
- [ ] Classify each keyword by search intent (Informational / Commercial / Transactional / Navigational)
- [ ] Assign keyword difficulty (KD) and KD level per keyword
- [ ] Tag geographic targeting (Geo) per keyword
- [ ] Assign priority (Critical / High / Medium) per keyword
- [ ] Map each keyword to a product/service
- [ ] Ensure keyword mix: 30% head, 50% mid-tail, 20% long-tail
- [ ] Produce Master Keyword List with all columns (+ `shortlisted-keywords.csv`)
- [ ] Screenshots: KE overlays, Google Trends charts, SERP results

---

### Step 5 — Cannibalisation Check (BEFORE pillars)
> Prune/re-angle keywords that duplicate the store's live blog, so pillars are built only on clear keywords

- [ ] Load `published-content.json` (pipeline root) — the store's live blog; works without a store API
- [ ] If `store-config.json:has_store_api=true`, supplement with `Step-1-Brand-Discovery/blog-audit.json:live_titles`
- [ ] Compare every `shortlisted-keywords.csv` keyword against live posts (significant-word overlap)
- [ ] Classify each: `clear` (keep) / `reangle` (keep with a distinct angle) / `dropped` (near-duplicate, remove)
- [ ] Write `keywords-cleared.csv` (shortlisted minus dropped, + `cannibalisation` column) — **Step 6 clusters from this**
- [ ] Write `dedup-check.json` (per-keyword relation + summary header)
- [ ] Never hard-fail: no live posts → everything `clear`

---

### Step 6 — Pillar Architecture
> Cluster the CLEARED keywords into 8-12 pillars — backed by actual search volume, not theory

- [ ] Cluster keywords from `Step-5-Cannibalisation/keywords-cleared.csv` (fallback: shortlisted) into topic groups
- [ ] Guardrails: drop/re-angle any pillar matching a `config.json:guardrails.never` rule (semantic match)
- [ ] Seasonality: light tier-nudge only, from `config.json:current_date` — merchant's `content_focus` always wins
- [ ] Define 8-12 pillars with names and URL slugs
- [ ] Assign keywords to pillars with per-pillar volume totals
- [ ] Validate each pillar is justified by real search data
- [ ] Map each pillar to a primary product/service
- [ ] Define sub-sections within each pillar
- [ ] Set target keyword count per pillar
- [ ] Confirm no major keyword clusters are left unassigned (cannibalisation already handled in Step 5)

---

### Step 7 — Position Estimation + SERP Feature Analysis
> Current positions from actual SERP checks + what SERP features Google rewards

- [ ] Check actual SERP positions for top 50 keywords via Agent Browser
- [ ] Estimate positions for remaining keywords based on indexed pages
- [ ] Classify all keywords by position band (P1-3 / P4-10 / P11-20 / P21-50 / 50+ / Not Ranking)
- [ ] Identify SERP features per keyword (featured snippets, PAA, video, local pack, images)
- [ ] Determine optimal content FORMAT based on what Google currently rewards
- [ ] Assign opportunity gap (Full Opportunity / High / Medium / Close / Holding)
- [ ] Set action recommendations per position band (Defend / Push / Optimize / Build / New Content)
- [ ] Screenshots: SERPs for top 50 keywords showing features and rankings

---

### Step 8 — Content Titles & Linking
> Titles matched to SERP-validated formats + internal linking map

- [ ] Guardrails: judge every title semantically against `config.json:guardrails.never` before finalizing
- [ ] Seasonality: `config.json:current_date`-aware framing, never overriding merchant's stated `content_focus`
- [ ] Write pillar page titles (8-12) — comprehensive, 60-80 chars, keyword-rich
- [ ] Write spoke article titles (15-30 per pillar) — specific, 50-70 chars
- [ ] Assign URL slugs using pillar-nested structure (/pillar/spoke)
- [ ] Match content format to SERP feature analysis from Step 7
- [ ] Assign primary + secondary keywords per title
- [ ] Cross-check every title against `published-content.json` — no title may duplicate a live post; link to relevant live posts (`to_live_posts`) instead of recreating them
- [ ] Set word count targets per content piece
- [ ] Build internal linking map: spoke → pillar (mandatory)
- [ ] Build internal linking map: spoke → relevant live posts / collections / products
- [ ] Map CTA/conversion page per pillar

---

### Step 9 — Verifier
> Final holistic pass: re-check the whole plan, fix problems IN PLACE before deliverables are assembled

- [ ] Load the assembled plan (titles-linking + pillar defs + positions + live blog)
- [ ] Duplicate/near-duplicate titles across pillars — re-angle or drop
- [ ] Slug collisions — disambiguate
- [ ] Keyword drift — move a spoke to the pillar it actually fits (or drop)
- [ ] Orphan keywords — fold cleared-but-unused keywords into the best pillar, or record why not
- [ ] Final cannibalisation re-check of FINAL titles vs `published-content.json`
- [ ] Cross-pillar collision — same head term in two+ pillars: keep the best-fit one, re-angle/drop the rest
- [ ] Guardrail violation (last line of defence) — re-check FINAL titles vs `config.json:guardrails.never`
- [ ] Format / word-band mismatch — fix word_count or format
- [ ] Empty/thin pillars — remove or flag
- [ ] Linking integrity — repair links broken by this step's edits
- [ ] Write fixes back into `titles-linking.json` + pillar defs (so `content_map.json` inherits them)
- [ ] Write `verification.json` UNCONDITIONALLY (clean run → `{status:"clean", mutations:[]}`)

---

## Progress Tracker

| Step | Name | Status | Date Completed |
|------|------|--------|----------------|
| 1 | Brand Discovery | Not Started | |
| 2 | Competitor Discovery | Not Started | |
| 3 | Content Gap Analysis | Not Started | |
| 3b | Content Scope Estimation | Not Started | |
| 4 | Keyword Research | Not Started | |
| 5 | Cannibalisation Check | Not Started | |
| 6 | Pillar Architecture | Not Started | |
| 7 | Position Estimation + SERP Analysis | Not Started | |
| 8 | Content Titles & Linking | Not Started | |
| 9 | Verifier | Not Started | |
