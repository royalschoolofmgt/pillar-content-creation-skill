# Content Scope Estimation — {{BRAND_NAME}}

**Date:** {{DISCOVERY_DATE}}
**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Current DA:** {{DOMAIN_AUTHORITY}} | **Current Blog Posts:** {{BLOG_POSTS_COUNT}} | **Ranking Keywords:** {{RANKING_KEYWORDS}}

---

## 1. Pillar Candidates

### 1a. Product/Service Categories (from Step 1)

| Category | Has Dedicated SEO Page? | Collection URL | Priority |
|----------|------------------------|----------------|----------|
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |

### 1b. Content Gap Clusters (from Step 3)

| Topic Cluster | Gap Tier | Opportunity Type | Competitor Coverage |
|--------------|----------|-----------------|---------------------|
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |

### 1c. Competitor Pillar Patterns (from Step 2)

| Competitor | Blog/Guide Count | Main Topic Clusters |
|-----------|-----------------|---------------------|
| {{C1_NAME}} | ~{{C1_BLOG_POSTS}} posts | |
| {{C2_NAME}} | ~{{C2_BLOG_POSTS}} posts | |
| {{C3_NAME}} | ~{{C3_BLOG_POSTS}} articles | |

### 1d. Raw Pillar Candidate List

| # | Pillar Candidate | Source | Keep? |
|---|-----------------|--------|-------|
| 1 | | | |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |
| 6 | | | |
| 7 | | | |
| 8 | | | |
| 9 | | | |
| 10 | | | |
| 11 | | | |
| 12 | | | |

---

## 2. Spoke Estimation by Pillar

| Pillar | Formats Applicable | Competitor Spoke Depth | Target Spoke Count |
|--------|-------------------|----------------------|-------------------|
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| | | | |
| **TOTAL** | | | |

**Format key:** BG = Buyer's Guide / Best Of · HT = How-To / Tutorial · CP = Comparison / vs · FAQ = Explainer · RV = Review / Roundup · RG = Regulatory / News

---

## 3. Keyword Volume Estimation

### 3a. Keywords Per Content Type

| Content Type | Count | Avg Keywords Each | Subtotal |
|-------------|-------|------------------|----------|
| Pillar Pages | | | |
| Buyer's Guide / Best Of | | | |
| How-To / Tutorial | | | |
| Comparison / vs. | | | |
| FAQ / Explainer | | | |
| Review / Roundup | | | |
| Other | | | |
| **Subtotal** | | | |
| **+20% Discovery Buffer** | | | |
| **Grand Total** | | | **{{SCOPE_TOTAL_KEYWORDS}}** |

### 3b. Step 4 Research Plan

- **Total keyword batches to run in KP:** approximately `{{SCOPE_TOTAL_KEYWORDS}}` ÷ 20 per batch = `{{SCOPE_KP_BATCHES}}` batches
- **Estimated KP session time:** `{{SCOPE_KP_BATCHES}}` × ~5 min = approximately `{{SCOPE_KP_TIME}}` minutes

---

## 4. Scope Tier Comparison

| Metric | Tier 1 — MVB | Tier 2 — Standard | Tier 3 — Aggressive |
|--------|-------------|------------------|---------------------|
| Pillars | 8 | 10 | 12 |
| Spokes per Pillar | 3 | 6–8 | 10–15 |
| Total Articles | ~32 | ~80–100 | ~130–192 |
| Total Keywords to Research | ~200 | ~500–650 | ~900–1,300 |
| Est. Time to Publish All | 3–4 months | 6–9 months | 12–18 months |
| Suited for DA | {{DOMAIN_AUTHORITY}} (current) | DA 10–25 | DA 25+ |
| Closest Competitor Match | — | {{C1_NAME}} (DA {{C1_DA}}) | {{C3_NAME}} (DA {{C3_DA}}) |

---

## 5. Recommended Scope

| Field | Value |
|-------|-------|
| **Recommended Tier** | {{SCOPE_TIER}} |
| **Final Pillar Count** | {{SCOPE_PILLARS}} |
| **Avg Spokes per Pillar** | {{SCOPE_AVG_SPOKES}} |
| **Total Spoke Count** | {{SCOPE_TOTAL_SPOKES}} |
| **Total Articles (Pillars + Spokes)** | {{SCOPE_TOTAL_ARTICLES}} |
| **Avg Keywords per Piece** | {{SCOPE_AVG_KEYWORDS}} |
| **Total Keywords to Research** | {{SCOPE_TOTAL_KEYWORDS}} |
| **Rationale** | {{SCOPE_RATIONALE}} |

---

## 6. Key Findings

- **Pillar selection logic:** _Fill in: why these specific pillars were chosen (product alignment, gap density, competitor precedent)_
- **Scope constraint:** _Fill in: what is the binding constraint — DA, content team capacity, budget, timeline?_
- **Biggest opportunity:** _Fill in: which 2-3 pillars have the highest ROI and why_
- **What to deprioritize:** _Fill in: which pillar candidates were cut and why_

---

## 7. config.json Update Checklist

After completing this step, update `config.json → scope`:

- [ ] `scope.pillars` = {{SCOPE_PILLARS}}
- [ ] `scope.avg_spokes_per_pillar` = {{SCOPE_AVG_SPOKES}}
- [ ] `scope.total_spokes` = {{SCOPE_TOTAL_SPOKES}}
- [ ] `scope.total_articles` = {{SCOPE_TOTAL_ARTICLES}}
- [ ] `scope.avg_keywords_per_piece` = {{SCOPE_AVG_KEYWORDS}}
- [ ] `scope.total_keywords_to_research` = {{SCOPE_TOTAL_KEYWORDS}}
- [ ] `scope.tier` = "{{SCOPE_TIER}}"
- [ ] `scope.rationale` = filled in

→ Proceed to **Step 4 — Keyword Research** with `total_keywords_to_research` as your batch target.
