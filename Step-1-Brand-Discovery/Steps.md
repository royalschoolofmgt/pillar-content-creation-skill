# Step 1 — Brand Discovery: Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Tool:** Agent Browser
**Evidence:** Screenshots saved to this folder for every step

---

## Phase 1: Website Analysis

- [ ] **1.1** Open {{WEBSITE_URL}} and take a screenshot of the homepage
- [ ] **1.2** Navigate the main menu — document all pages/sections available
- [ ] **1.3** Screenshot the products/services pages
- [ ] **1.4** Identify and list all products/services with names, descriptions, and URLs
- [ ] **1.5** Screenshot the pricing page (if exists)
- [ ] **1.6** Screenshot the about page — extract brand positioning and mission
- [ ] **1.7** Check for sitemap.xml or llms.txt — screenshot if found

## Phase 2: Blog & Content Audit

- [ ] **2.1** Navigate to the blog/resources section
- [ ] **2.2** Screenshot the blog listing page
- [ ] **2.3** Count total blog posts and note publishing frequency
- [ ] **2.4** List blog categories/topics covered
- [ ] **2.5** Screenshot 3-5 recent blog posts (titles, dates, topics)
- [ ] **2.6** Assess content quality — word count, formatting, images, internal links
- [ ] **2.7** Note languages used on the site

## Phase 3: Site Architecture

- [ ] **3.1** Document the URL structure (flat, nested, blog prefix, etc.)
- [ ] **3.2** Screenshot the navigation/menu structure
- [ ] **3.3** Check for landing pages, resource hubs, or pillar-style pages
- [ ] **3.4** Note CTA types used across the site
- [ ] **3.5** Check for social proof elements

## Phase 4: Technical SEO Baseline

- [ ] **4.1** Google search `site:{{WEBSITE_URL}}` — record indexed pages
- [ ] **4.2** Check page speed — record CWV scores: LCP, INP, CLS
- [ ] **4.3** Check mobile responsiveness — viewport meta tag and theme
- [ ] **4.4** Check for schema markup — list all types found
- [ ] **4.5** Check for meta titles and descriptions — rate quality on homepage and product pages
- [ ] **4.6** Check for hreflang tags — note if needed

## Phase 5: Market Presence ({{TARGET_MARKETS}})

- [ ] **5.1** Google search `{{BRAND_NAME}}` — record position and SERP features (sitelinks, Knowledge Panel)
- [ ] **5.2** Google search `{{BRAND_NAME}} {{TARGET_MARKETS}}` — record visibility
- [ ] **5.3** Google search core product terms + market terms — note branded vs non-branded visibility
- [ ] **5.4** Check for social media profiles — record all platforms and handles found
- [ ] **5.5** Check third-party listings — Trustpilot, Google reviews, and other platforms

---

## Output

After completing all steps, produce:

- [ ] `brand-discovery.md` — single report containing all findings, with tables for products, content audit, technical SEO, and market presence
- [ ] `screenshots/` folder — all screenshots organized by phase
- [ ] Update `config.json` with discovered fields (products_count, collections_count, blog_posts_count, description, positioning, locations, contact, cwv, reviews, social, own_brand_products, key_brands)

### Brand Brief (render in brand-discovery.md)

| Field | Value |
|-------|-------|
| Brand Name | |
| Positioning | |
| Target Audience | |
| Unique Selling Points | |
| Conversion Paths | |
| Languages | |

### Products Table (render in brand-discovery.md)

| Product Name | Description | URL | Key Features |
|-------------|-------------|-----|--------------|
| | | | |

### Blog Audit Table (render in brand-discovery.md)

| Metric | Value |
|--------|-------|
| Total Posts | |
| Publishing Frequency | |
| Categories | |
| Languages | |
| Avg Quality Score | |

### Technical SEO Table (render in brand-discovery.md)

| Check | Status | Notes |
|-------|--------|-------|
| Indexed Pages | | |
| Page Speed | | |
| Mobile Responsive | | |
| Schema Markup | | |
| Meta Titles/Descriptions | | |
| Hreflang Tags | | |

---

## Rules

1. **Sequential execution only** — complete each step before moving to the next
2. **Screenshot everything** — every finding needs visual evidence saved to this folder
3. **No assumptions** — only document what is observed on the actual site and SERPs
4. **Single MD output** — all data goes into `brand-discovery.md`, no separate JSON files
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
