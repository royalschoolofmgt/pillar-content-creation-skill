# Step 3 — Content Gap Analysis: Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Tool:** Agent Browser
**Evidence:** Screenshots saved to this folder for every step
**Depends on:** Step 1 (Brand Discovery) + Step 2 (Competitor Discovery) completed

---

## Phase 1: Brand vs Competitor Keyword Overlap

- [ ] **1.1** List all keywords/topics {{BRAND_NAME}} currently covers — record blog posts, products, ranking keywords
- [ ] **1.2** List all keywords/topics each competitor covers — record post counts and keyword counts per competitor
- [ ] **1.3** Build overlap matrix: topic clusters competitors cover that {{BRAND_NAME}} does NOT
- [ ] **1.4** Build overlap matrix: unique {{BRAND_NAME}} advantages (products, pricing, locations, other differentiators)
- [ ] **1.5** Identify shared keywords — note where {{BRAND_NAME}} ranks lower on all shared transactional terms

## Phase 2: Blue Ocean Keywords

- [ ] **2.1** Google search market-specific terms — screenshot all SERPs with KE data
- [ ] **2.2** Identify blue ocean keywords — terms where no competitor has strong dedicated content
- [ ] **2.3** Screenshot weak SERPs — document low-DA sites ranking for target terms
- [ ] **2.4** Search budget, niche, regulatory, and brand-specific terms
- [ ] **2.5** Search use-case terms — switching guides, troubleshooting, comparisons
- [ ] **2.6** Search level-specific terms — beginner guides, advanced topics

## Phase 3: Content Quality Gaps

- [ ] **3.1** Review #1-3 ranking pages for top target keywords — document DA, traffic, keyword count per result
- [ ] **3.2** Screenshot all SERP queries showing top-ranking pages with KE overlay data
- [ ] **3.3** Identify beatable #1 results — collection pages ranking, low-DA sites, thin guides
- [ ] **3.4** Map SERP features: AI Overview, PAA, Video carousel, Shopping carousel, Local Pack
- [ ] **3.5** Identify high-intent topics with only generic content in SERPs

## Phase 4: Prioritize Gaps

- [ ] **4.1** Score all gaps by volume using KE data from SERP screenshots
- [ ] **4.2** Score by difficulty using real SEO Difficulty from KE
- [ ] **4.3** Score by business relevance — Critical (maps to {{BRAND_NAME}} products), High, Medium, Low
- [ ] **4.4** Rank all gaps: Critical, High, Medium priority
- [ ] **4.5** Create final prioritized gap list with ranked entries + recommended content per gap

---

## Output

After completing all steps, produce:

- [ ] `content-gap-analysis.md` — comprehensive report with overlap matrix, blue ocean keywords, beatable pages, prioritized gaps, SERP feature matrix
- [ ] `screenshots/` folder — screenshots across all SERP queries with KE data overlays

### Keyword Overlap Matrix (render in content-gap-analysis.md)

| Keyword / Topic | {{BRAND_NAME}} | {{C1_NAME}} | {{C2_NAME}} | {{C3_NAME}} | Gap Type |
|----------------|-------------|-------------|-------------|-------------|----------|
| | Yes/No | Yes/No | Yes/No | Yes/No | Missing / Weak / Blue Ocean |

### Blue Ocean Keywords Table (render in content-gap-analysis.md)

| Keyword | Est. Volume | Market | Current SERP Quality | Why It's an Opportunity |
|---------|-------------|--------|---------------------|------------------------|
| | | | Weak / Thin / Outdated / None | |

### Beatable Pages Table (render in content-gap-analysis.md)

| Keyword | Current #1 URL | Why Beatable | {{BRAND_NAME}} Advantage |
|---------|---------------|-------------|----------------------|
| | | Thin / Outdated / No specific focus | |

### Prioritized Gap List (render in content-gap-analysis.md)

| Rank | Keyword / Topic | Volume | Difficulty | Business Relevance | Priority Score | Gap Type |
|------|----------------|--------|------------|-------------------|---------------|----------|
| 1 | | | Low/Med/High | Low/Med/High | | |

---

## Rules

1. **Sequential execution only** — complete each step before moving to the next
2. **Screenshot everything** — every finding needs visual evidence saved to this folder
3. **No assumptions** — only document what is observed on the actual SERPs
4. **Single MD output** — all data goes into `content-gap-analysis.md`, no separate JSON files
5. **Agent Browser for ALL browsing** — any task that requires visiting a webpage, taking screenshots, clicking, or reading page content MUST use `agent-browser` via the CDP connection. The only exception is fetching `sitemap.xml` files, which can use WebFetch/curl. Never use WebFetch for browsing live pages.
6. **No parallel agents for CDP tasks** — never run multiple agents in parallel when using agent-browser CDP. Execute browser tasks sequentially, one at a time.
7. **Clean up tabs at start of every session** — before starting any browsing work, list all open tabs and close stale ones. Only keep the tab you're actively working with.

### Agent Browser Tab Management Reference
```
agent-browser tab                     # List all tabs
agent-browser tab new [url]           # New tab (optionally with URL)
agent-browser tab <n>                 # Switch to tab n
agent-browser tab close [n]           # Close tab n (or current if omitted)
agent-browser window new              # New browser window
```
