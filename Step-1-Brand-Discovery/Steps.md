# Step 1 — Brand Discovery: Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Tool:** the merchant's own Chrome (VortexIQ Browser Agent extension — the `vortexiq-browser` tools)
**Evidence:** a `shot` filed under this step for every finding (copied into `screenshots/` here)

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
2. **Screenshot everything** — every finding needs visual evidence: `shot` with this step's folder as `step`
3. **No assumptions** — only document what is observed on the actual site and SERPs
4. **Single MD output** — all data goes into `brand-discovery.md`, no separate JSON files
5. **The merchant's Chrome for ALL browsing** — any task that requires visiting a webpage, taking screenshots, clicking, or reading page content uses the `vortexiq-browser` tools (`open_tab`, `navigate`, `get_text`, `snapshot`, `find`, `click`, `scroll`, and `shot` for every screenshot). The job is read-only: never type, post or submit. The only exception is fetching `sitemap.xml` files, which can use curl. Never use WebFetch, curl or any other browser for live pages.
6. **One browser call at a time** — browser work is sequential: never parallel agents or parallel calls.
7. **One tab** — open the job's tab once (`open_tab`) and `navigate` it; open a second only for a side-by-side comparison, and never more than 3.

### Browser tab reference (`vortexiq-browser` tools)
```
open_tab   {url}              # a new tab of this job's (returns its tabId)
navigate   {tabId, url}       # move a tab (allow_site first if the site is new to this job)
list_tabs                     # this job's tabs only
close_tab  {tabId}
shot       {step, caption}    # screenshot as this step's evidence (returns its id + the step's count)
```
