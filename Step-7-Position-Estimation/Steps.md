# Step 7 — Position Estimation + SERP Feature Analysis: Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Tool:** Agent Browser
**Evidence:** Screenshots saved to this folder for every step
**Depends on:** Steps 1-6 completed (pillars from Step 6)

---

## Phase 1: Current Position Checks

- [ ] **1.1** For top 50 highest-volume keywords, Google search each one
- [ ] **1.2** Screenshot each SERP — note where {{WEBSITE_DOMAIN}} appears (or doesn't)
- [ ] **1.3** Record position for each keyword (P1-3, P4-10, P11-20, P21-50, 50+, Not Ranking)
- [ ] **1.4** For remaining keywords, search `site:{{WEBSITE_DOMAIN}} [keyword]` to check if a page exists
- [ ] **1.5** Screenshot indexed page results for spot checks
- [ ] **1.6** Estimate positions for remaining keywords based on indexed page patterns

## Phase 2: Position Band Classification

- [ ] **2.1** Classify all keywords into position bands:
  - [ ] P1-3: DEFEND (monitor weekly)
  - [ ] P4-10: PUSH TO P1 (add internal links + update content)
  - [ ] P11-20: OPTIMIZE (build spoke content + schema)
  - [ ] P21-50: BUILD (create dedicated page + backlinks)
  - [ ] 50+: NEW CONTENT (publish targeting page)
  - [ ] Not Ranking: FULL OPPORTUNITY (create from scratch)
- [ ] **2.2** Count keywords per position band
- [ ] **2.3** Calculate total volume per position band

## Phase 3: SERP Feature Analysis

- [ ] **3.1** For top 50 keywords, document which SERP features appear:
  - [ ] Featured Snippet (paragraph, list, table)
  - [ ] People Also Ask (PAA) box
  - [ ] Video carousel
  - [ ] Image pack
  - [ ] Local pack
  - [ ] Knowledge panel
  - [ ] Ads (top and bottom)
- [ ] **3.2** Screenshot SERP features for each keyword
- [ ] **3.3** Note which features {{BRAND_NAME}} could capture with the right content format
- [ ] **3.4** For featured snippets — note the current snippet holder and format used

## Phase 4: Content Format Decisions

- [ ] **4.1** For keywords with featured snippets → content needs snippet-optimized structure
- [ ] **4.2** For keywords with video carousels → video content recommended
- [ ] **4.3** For keywords with PAA boxes → FAQ section required in content
- [ ] **4.4** For keywords with listicle snippets → list-format content needed
- [ ] **4.5** For keywords with local pack → local SEO and geo-specific content needed
- [ ] **4.6** Document recommended content format per keyword based on SERP analysis

## Phase 5: Opportunity Gap Assignment

- [ ] **5.1** Assign opportunity gap to every keyword:
  - [ ] FULL OPPORTUNITY — Not ranking, no existing page
  - [ ] HIGH — Ranking 50+, weak page exists
  - [ ] MEDIUM — Ranking 21-50, page needs optimization
  - [ ] CLOSE — Ranking 4-20, push to page 1 or top 3
  - [ ] HOLDING — Ranking 1-3, defend position
- [ ] **5.2** Update master keyword list with Position and Opportunity Gap columns
- [ ] **5.3** Build 12-month position tracking template with empty monthly columns

---

## Output

After completing all steps, produce:

- [ ] `position-tracker.json` — all keywords with position, band, action, opportunity gap
- [ ] `serp-features.json` — SERP feature analysis per keyword with format recommendations
- [ ] `position-summary.md` — count and volume by position band
- [ ] Updated `master-keywords.json` — Position and Opportunity Gap columns now filled
- [ ] `screenshots/` folder — SERP screenshots for top 50 keywords

---

## Rules

1. **Sequential execution only** — complete each step before moving to the next
2. **Screenshot everything** — every SERP check needs visual evidence
3. **Real positions only** — check actual SERPs, do not estimate without searching
4. **SERP features matter** — content format must match what Google rewards
