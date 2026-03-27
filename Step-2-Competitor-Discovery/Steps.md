# Step 2 — Competitor Discovery: Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Tool:** Agent Browser
**Evidence:** Screenshots saved to this folder for every step
**Depends on:** Step 1 (Brand Discovery) completed

---

## Phase 1: Identify Competitors

- [ ] **1.1** Google search {{BRAND_NAME}}'s core product terms — use main product category keywords
- [ ] **1.2** Google search alternative product terms — mid-tail and long-tail variations
- [ ] **1.3** Google search `best online [industry] shop {{TARGET_MARKETS}}` — screenshot SERP with AI Overview
- [ ] **1.4** Google search client-provided competitor — screenshot with Knowledge Panel
- [ ] **1.5** Google search core terms from target market context — capture multiple SERPs
- [ ] **1.6** Compile final list: **{{C1_NAME}}** (client-provided), **{{C2_NAME}}** (SERP), **{{C3_NAME}}** (SERP)

## Phase 2: Analyze Each Competitor (repeat for each of the 2-3 competitors)

- [ ] **2.1** Open competitor homepages — screenshot all, note positioning/messaging
- [ ] **2.2** Document products/services — extract via nav, sitemap counts, meta descriptions
- [ ] **2.3** Screenshot product/service pages
- [ ] **2.4** Navigate to blogs — screenshot blog/guide hubs for each competitor
- [ ] **2.5** Count blog posts for each competitor
- [ ] **2.6** List blog categories for each competitor
- [ ] **2.7** Screenshot blog pages — blog listings for all competitors
- [ ] **2.8** Assess content quality — rate each competitor's content (1-10)

## Phase 3: Competitor Keywords

- [ ] **3.1** Check MOZ/DA data for each competitor — record DA, referring domains, ranking keywords
- [ ] **3.2** Search key industry terms with Keywords Everywhere — capture KE data per competitor
- [ ] **3.3** Run `site:` searches for each competitor — record indexed pages
- [ ] **3.4** Document keyword targets from page titles/meta for all competitors
- [ ] **3.5** Screenshot competitor rankings for key terms showing traffic data

## Phase 4: Competitor Strengths & Weaknesses

- [ ] **4.1** Document strengths for all competitors (awards, content, DA, reviews, product range)
- [ ] **4.2** Document weaknesses (DA drops, sitemap issues, outdated content, spam score)
- [ ] **4.3** Screenshot strong pages — top-ranking blog posts, key product pages
- [ ] **4.4** Identify weakness opportunities — content gaps, technical issues, outdated content
- [ ] **4.5** Note untargeted terms — keywords no competitor is targeting well

## Phase 5: Competitor Social & Market Presence

- [ ] **5.1** Check social profiles for all competitors — record platforms and follower counts
- [ ] **5.2** Screenshot social media presence for key competitors
- [ ] **5.3** Screenshot Trustpilot profiles for all competitors — record ratings and review counts
- [ ] **5.4** Check for competitor paid ads in organic SERPs

---

## Output

After completing all steps, produce:

- [ ] `competitor-discovery.md` — comprehensive report with all tables and findings
- [ ] `screenshots/` folder — screenshots organized by phase
- [ ] Update `config.json` with discovered competitors (3 competitors with full data: name, url, positioning, platform, hq, founded, domain_authority, ref_domains, indexed_pages, blog_posts, ranking_keywords, website_traffic_mo, trustpilot_rating, trustpilot_reviews, free_delivery, source)

### Competitor Overview Table (render in competitor-discovery.md)

| Competitor | URL | Positioning | Products/Services | Indexed Pages | Blog Posts | Publishing Freq |
|-----------|-----|-------------|-----------------|---------------|------------|-----------------|
| | | | | | | |
| | | | | | | |
| | | | | | | |

### Competitor Keywords Table (render in competitor-discovery.md, per competitor)

| Keyword | Volume | CPC | Competition | Page Ranking | Position |
|---------|--------|-----|-------------|-------------|----------|
| | | | | | |

### Strengths & Weaknesses Table (render in competitor-discovery.md)

| Competitor | Strengths | Weaknesses | Market Focus |
|-----------|-----------|------------|-------------|
| | | | |
| | | | |
| | | | |

### Social Presence Table (render in competitor-discovery.md)

| Competitor | Facebook | Instagram | LinkedIn | YouTube | Twitter/X | TikTok | Reviews |
|-----------|----------|-----------|----------|---------|-----------|--------|---------|
| | | | | | | | |

---

## Rules

1. **Sequential execution only** — complete each step before moving to the next
2. **Screenshot everything** — every finding needs visual evidence saved to this folder
3. **No assumptions** — only document what is observed on the actual sites and SERPs
4. **2-3 competitors only** — focused deep analysis, not a broad shallow scan
5. **Single MD output** — all data goes into `competitor-discovery.md`, no separate JSON files
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
