# Step 6 — Pillar Architecture: Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Tool:** Agent Browser
**Evidence:** Screenshots saved to `screenshots/` folder for every step
**Depends on:** Steps 1-5 completed. Cluster from **Step-5-Cannibalisation/`keywords-cleared.csv`** (the
cannibalisation-pruned set) — fall back to `Step-4-Keyword-Research/shortlisted-keywords.csv` only if
`keywords-cleared.csv` is absent. Every keyword you cluster here has already cleared the live-blog check in
Step 5, so pillars can never be built on a page the store already ranks for — no cannibalisation guard is
needed in this step.

---

## Phase 1: Keyword Clustering

- [ ] **1.1** Load the cleared keyword list — `Step-5-Cannibalisation/keywords-cleared.csv` (fallback:
      `Step-4-Keyword-Research/shortlisted-keywords.csv` if the cleared file is missing)
- [ ] **1.2** Group keywords by natural topic similarity
- [ ] **1.3** Identify distinct clusters from the data
- [ ] **1.4** Calculate total search volume per cluster
- [ ] **1.5** Verify no major keyword groups left unassigned — zero orphans

## Phase 2: Pillar Definition

- [ ] **2.0 Guardrails.** Read the merchant's Setup guardrails (`config.json:guardrails.never`) before naming/scoping any pillar. Drop or re-angle any pillar whose theme matches a never-write-about rule — judge semantically (a rule about "vaping health claims" also catches an "e-cigarette health effects" pillar), not by literal substring.
- [ ] **2.0b Seasonality (light touch — full framing happens at Step 8).** `config.json:current_date` is the real run date. A pillar tied to a near-term real-world event relative to that date may reasonably get a tier nudge (see caps below) — but this is a tie-breaker only. **The merchant's `content_focus`/explicit dates always win over inferred seasonality.**
- [ ] **2.1** Assign pillar names and URL slugs
- [ ] **2.2** Write 2-3 sentence descriptions per pillar
- [ ] **2.3** Define sub-sections per pillar
- [ ] **2.4** Map each pillar to a primary {{BRAND_NAME}} product category
- [ ] **2.5** Calculate keyword counts per pillar
- [ ] **2.6** Calculate volumes per pillar
- [ ] **2.7** Assign all keywords to pillars — update `master-keywords.json` and `.csv`

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
5. **Minimum 15 spoke keywords** per pillar (cannibalisation was already handled in Step 5 — every keyword here is cleared)
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
