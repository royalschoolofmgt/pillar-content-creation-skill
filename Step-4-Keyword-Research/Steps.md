# Step 4 — Keyword Research (Real Data): Execution Checklist

**Brand:** {{BRAND_NAME}}
**URL:** {{WEBSITE_URL}}
**Target Market:** {{TARGET_MARKETS}}
**Tool:** Agent Browser + Google Search + Google Keyword Planner + Google Trends
**Evidence:** Screenshots saved to `screenshots/` folder for every step
**Depends on:** Steps 1-3 completed

---

## Phase 1: Seed Keyword Collection

- [ ] **1.1** Compile all keywords discovered in Steps 1-3 (brand, competitor, gap keywords)
- [ ] **1.2** Expand seed list with Google Autocomplete — search each core term and capture suggestions
- [ ] **1.3** Screenshot Google Autocomplete suggestions for top seed terms
- [ ] **1.4** Check "People Also Ask" boxes for top seed terms — screenshot and add to list
- [ ] **1.5** Check "Related Searches" at bottom of SERPs — screenshot and add to list

## Phase 2: Volume & Competition Data (Google Ads Keyword Planner)

### Keyword Planner Workflow — Exact Browser Steps

**Base URL:** `{{KEYWORD_PLANNER_URL}}` — paste your Google Ads KP URL here (update config.json `agent_browser.keyword_planner_url`)

**CDP:** `{{AGENT_BROWSER_CDP}}` — from config.json `agent_browser.cdp`

**Environment:** `AGENT_BROWSER_DEFAULT_TIMEOUT=60000` (60s — Google Ads pages are slow)

#### Automation Scripts

Three scripts automate the repetitive parts of each batch. All require `AGENT_BROWSER_CDP` env var set.

| Script | What it does | Usage |
|--------|-------------|-------|
| `scripts/set-country-uk.sh` | Removes India, adds United Kingdom, clicks Save, verifies | Run after clicking "Discover new keywords" and switching to website tab |
| `scripts/download-to-sheets.sh` | Clicks Download → Google Sheets → Download in dialog → waits for "Open sheet" → gets Sheet URL. Writes SHEET_ID/GID to `/tmp/kp_sheet_*.txt` | Run after KP results are showing. Also requires `CDP_HTTP_URL` env var |
| `scripts/share-and-download-csv.sh <batch-name>` | Opens Sheet in new tab → switches to it → Share → Restricted → Anyone with link → Done → downloads CSV → **cleans up ALL stale tabs** → switches back to KP | Run after `download-to-sheets.sh`. Reads from `/tmp/kp_sheet_*.txt` |

**Environment setup before running scripts:**
```bash
export AGENT_BROWSER_CDP="{{AGENT_BROWSER_CDP}}"  # from config.json agent_browser.cdp
export CDP_HTTP_URL="{{CDP_HTTP_URL}}"              # from config.json agent_browser.cdp_http
```

**Quick batch flow (using scripts):**
```bash
# 1. Navigate to KP, click Discover, switch to Website tab
# 2. Set country:
./scripts/set-country-uk.sh
# 3. Enter website URL in textbox, click Get Results, wait for results
# 4. Screenshot results
# 5. Download to Sheets + get Sheet URL:
./scripts/download-to-sheets.sh
# 6. Share, download CSV, cleanup:
./scripts/share-and-download-csv.sh batch3-vapeuk
```

**Keyword-based seeds are BLOCKED** for vaping — Google Ads restricts tobacco/nicotine keywords. Use the **"Start with a website"** tab instead, entering brand or competitor URLs. This returns 250-1000+ keyword ideas without restriction.

---

#### Per-Batch Sequence (16 steps — manual reference)

**IMPORTANT:** Always use `agent-browser --cdp "$AGENT_BROWSER_CDP"` for all commands. Never use raw curl/CDP websockets. The scripts above automate steps 4, 7-16.

##### Part A: Get Keywords from KP (Steps 1-9)

1. **Open KP** — `agent-browser --cdp 9222 open <BASE_URL>`. If it times out, that's OK — page still loads. Verify with `snapshot -i`.
2. **Dismiss banner** — Snapshot to find "Hide" or "Dismiss" button for the "Reactivate" notification banner. Click it.
3. **Click "Discover new keywords"** — In snapshot, find button `"Discover new keywords Get keyword ideas..."` and click its ref. This opens the keyword input panel.
4. **Set locations** — Click `"Locations settings, India"` button. In the dialog:
   - Click `"Remove targeted location, India"` button
   - `type` (NOT `fill`) `"United Kingdom"` in the `"Enter a location to include"` combobox
   - Wait 2s, then use JS eval to click the `<span>` with text "United Kingdom" (dropdown options are NOT in accessibility snapshot)
   - Click `"Save"` button
   - Verify button now reads `"Locations settings, United Kingdom"`
5. **Enter seed keywords** — Find `textbox "Search input"` ref. For each keyword:
   - `type @ref "keyword text"` (NOT `fill` — fill doesn't trigger chip creation)
   - `press Tab` (NOT Enter, NOT Comma — only Tab creates a chip in KP's Material Design input)
   - Re-snapshot to get the NEW textbox ref (it changes after each chip: e84 → e86 → e88...)
   - Maximum 10 keywords per batch. Use 3-5 broad seeds for best results.
6. **Click "Get results"** — Click the `"Get results"` button ref. Then `wait --load networkidle`.
7. **Click "Download keyword ideas"** — This is a `<material-button>` NOT visible in accessibility snapshot. Must use JS eval:
   ```js
   (function() {
     var b = Array.from(document.querySelectorAll('material-button')).find(el => el.textContent.includes('Download keyword ideas'));
     if (b) { b.click(); return 'clicked'; }
     return 'not found';
   })()
   ```
8. **Select "Google Sheets"** — The dropdown shows `.csv` and `Google Sheets`. Use JS eval:
   ```js
   (function() {
     var item = Array.from(document.querySelectorAll('material-select-item')).find(el => el.textContent.includes('Google Sheets'));
     if (item) { item.click(); return 'clicked'; }
     return 'not found';
   })()
   ```
   This opens a dialog titled "Download to Google Sheets".
9. **Click "Download" in dialog** — Another `<material-button>`. Use JS eval:
   ```js
   (function() {
     var buttons = Array.from(document.querySelectorAll('material-button'));
     var dl = buttons.find(el => el.textContent.trim() === 'Download');
     if (dl) { dl.click(); return 'clicked'; }
     return 'not found';
   })()
   ```
   Wait ~10 seconds. Bottom of page shows "Preparing report..." then "Report downloaded to Sheets" with **"Open sheet"** and **"Dismiss"** buttons.

##### Part B: Get Sheet URL & Tab Management (Steps 10-11)

10. **Click "Open sheet"** — Snapshot to find `button "Open sheet"` ref, click it. This opens a new tab with the Google Sheet.
11. **Get Sheet URL, switch to Sheet tab, close unused tabs** — The new tab has the Sheet. Get its URL:
    ```bash
    curl -s <CDP_HTTP_URL>/json | python3 -c "import json,sys; tabs=json.load(sys.stdin); [print(t['url']) for t in tabs if 'spreadsheet' in t.get('url','')]"
    ```
    The URL format: `https://docs.google.com/spreadsheets/d/{SHEET_ID}/edit?gid={GID}#gid={GID}`

    #### Tabs & Windows — Agent Browser Commands

    ```bash
    agent-browser --cdp "$AGENT_BROWSER_CDP" tab                  # List all tabs (arrow → shows active tab)
    agent-browser --cdp "$AGENT_BROWSER_CDP" tab <n>               # Switch to tab n (REQUIRED before interacting)
    agent-browser --cdp "$AGENT_BROWSER_CDP" tab new [url]         # Open new tab (optionally with URL)
    agent-browser --cdp "$AGENT_BROWSER_CDP" tab close [n]         # Close tab n (or current tab if n omitted)
    agent-browser --cdp "$AGENT_BROWSER_CDP" window new            # Open new browser window
    ```

    #### CRITICAL — You MUST switch tabs before interacting

    After "Open sheet" creates a new tab, agent-browser may still be attached to the old KP tab. **You cannot see or click elements on a tab you haven't switched to.** The workflow is:

    1. **List tabs** to find the Sheet tab number:
       ```bash
       agent-browser --cdp "$AGENT_BROWSER_CDP" tab
       ```
    2. **Switch to the Sheet tab** — this is MANDATORY or Share/snapshot will silently fail:
       ```bash
       agent-browser --cdp "$AGENT_BROWSER_CDP" tab <n>   # n = the Sheet tab number
       ```
    3. **Verify** you're on the Sheet with `snapshot` — you should see the Sheet toolbar, Share button, etc.
    4. Only THEN proceed to click Share, open the iframe, etc.

    #### Cleanup — Close unused tabs after EVERY batch

    Google Sheets pages are HEAVY and freeze CDP connections. After downloading the CSV for each batch:

    1. **Close the Sheet tab:**
       ```bash
       agent-browser --cdp "$AGENT_BROWSER_CDP" tab close <n>
       ```
    2. **Close any other stale tabs** (e.g., extra new-tab pages, old KP results):
       ```bash
       agent-browser --cdp "$AGENT_BROWSER_CDP" tab close <n>
       ```
    3. **Switch back to the KP tab** for the next batch:
       ```bash
       agent-browser --cdp "$AGENT_BROWSER_CDP" tab 0
       ```
    4. **Verify** only the KP tab remains open before starting the next batch.

    **WHY THIS MATTERS:**
    - If the Sheet tab is NOT the focused/active tab, clicking Share will silently fail — no iframe opens, no error.
    - If you leave Sheet tabs open, the browser consumes excessive memory and CDP connections timeout.
    - After each batch: switch to Sheet tab → Share → download CSV → close Sheet tab → switch back to KP tab.

##### Part C: Make Sheet Public & Download CSV (Steps 12-16)

12. **Click Share button** — Use the toolbar Share button (more reliable than File → Share menu):
    - Snapshot, find `button "Share. Private only to me."`, click it
    - Wait 5 seconds for the iframe to load
    - Verify iframe exists:
      ```js
      (function(){ var i=document.querySelector("iframe.share-client-content-iframe"); return i?"found":"not found" })()
      ```
    - If `"not found"`, the tab is NOT focused. Run `agent-browser --cdp 9222 tab 0` and retry.

    **Alternative (less reliable):** File menu path:
    - Snapshot, find `menuitem "File"`, click it
    - Snapshot, find `menuitem "Share s ►"`, click it
    - Snapshot, find `menuitem "Share with others s"`, click it
    - NOTE: The File menu often closes before you can click Share. The toolbar Share button is preferred.

    The Share dialog opens **inside an iframe** (`iframe.share-client-content-iframe`). Standard snapshot will NOT show these elements.

13. **Click "Restricted" → Select "Anyone with the link"** — The share dialog is in an iframe. Must use JS eval to access it.

    **HICCUP:** A simple `.click()` on the Restricted button does NOT open the dropdown. You must dispatch full mouse events (`mousedown` → `mouseup` → `click`) for the dropdown to appear. Then **verify** the dropdown opened by checking for `[role="menuitemradio"]` elements. If they're not there, dispatch the events again.

    ```js
    // Step 13a: Open the Restricted dropdown (MUST use dispatchEvent, not .click())
    (function() {
      var iframe = document.querySelector('iframe.share-client-content-iframe');
      var doc = iframe.contentDocument || iframe.contentWindow.document;
      var btn = doc.querySelector('[aria-label="Restricted change general access"]');
      if (!btn) return 'button not found';
      ['mousedown', 'mouseup', 'click'].forEach(function(evt) {
        btn.dispatchEvent(new MouseEvent(evt, {bubbles: true, cancelable: true, view: iframe.contentWindow}));
      });
      return 'dispatched events on Restricted button';
    })()
    ```

    Wait 2s, then **verify the dropdown opened** before clicking:
    ```js
    // Step 13b: Verify dropdown is open (check for menuitemradio elements)
    (function() {
      var iframe = document.querySelector('iframe.share-client-content-iframe');
      var doc = iframe.contentDocument || iframe.contentWindow.document;
      var items = doc.querySelectorAll('[role="menuitemradio"]');
      var r = [];
      for (var i = 0; i < items.length; i++) {
        r.push(items[i].getAttribute('data-value') + ':' + items[i].textContent.trim().substring(0, 30));
      }
      if (r.length === 0) return 'DROPDOWN NOT OPEN — retry step 13a';
      return r.join(' | ');
    })()
    ```
    Expected output: `1:checkRestricted | 8:check<OrgName> | 4:checkAnyone with the link`

    If output is `DROPDOWN NOT OPEN`, repeat step 13a (dispatch events again).

    Once dropdown is confirmed open, select "Anyone with the link":
    ```js
    // Step 13c: Select "Anyone with the link" (data-value="4")
    (function() {
      var iframe = document.querySelector('iframe.share-client-content-iframe');
      var doc = iframe.contentDocument || iframe.contentWindow.document;
      var option = doc.querySelector('[data-value="4"][role="menuitemradio"]');
      if (option) { option.click(); return 'clicked Anyone with the link'; }
      return 'not found — dropdown may not be open, retry step 13a';
    })()
    ```

14. **Click "Done"** — Close the share dialog:
    ```js
    (function() {
      var iframe = document.querySelector('iframe.share-client-content-iframe');
      var doc = iframe.contentDocument || iframe.contentWindow.document;
      var btns = doc.querySelectorAll('button');
      for (var i = 0; i < btns.length; i++) {
        if (btns[i].textContent.trim() === 'Done') { btns[i].click(); return 'clicked Done'; }
      }
      return 'not found';
    })()
    ```

15. **Download CSV with curl** — The sheet is now public. Use the export URL:
    ```bash
    curl -sL "https://docs.google.com/spreadsheets/d/{SHEET_ID}/export?format=csv&gid={GID}" \
      -o batches/batch{N}-name.csv
    ```
    Verify with `wc -l` and `head -5`.

16. **Cleanup — Close ALL stale tabs before next batch**

    After downloading the CSV, you MUST clean up every tab/window that isn't the KP tab. Stale Sheets tabs consume memory and freeze CDP connections.

    **Step 16a: List all open targets via CDP JSON endpoint:**
    ```bash
    curl -s <CDP_HTTP_URL>/json | python3 -c "import json,sys; tabs=json.load(sys.stdin); [print(i, t.get('title','')[:50], '|', t['url'][:80]) for i,t in enumerate(tabs)]"
    ```

    **Step 16b: Close every target that is NOT the KP tab:**
    ```python
    python3 << 'PYEOF'
    import json, urllib.request
    url = "<CDP_HTTP_URL>/json"
    tabs = json.loads(urllib.request.urlopen(url).read())
    for i, t in enumerate(tabs):
        if "keywordplanner" in t.get("url", ""):
            print(f"KEEP [{i}]: {t.get('title','')[:40]}")
        else:
            target_id = t.get("id", "")
            close_url = f"<CDP_HTTP_URL>/json/close/{target_id}"
            try:
                urllib.request.urlopen(close_url)
                print(f"CLOSED [{i}]: {t.get('title','')[:40]}")
            except:
                pass  # service workers / iframes return 404, ignore
    PYEOF
    ```

    **Step 16c: Verify only KP tab remains:**
    ```bash
    curl -s <CDP_HTTP_URL>/json | python3 -c "import json,sys; tabs=json.load(sys.stdin); [print(i, t.get('title','')[:50]) for i,t in enumerate(tabs)]"
    ```

    **Step 16d: Switch agent-browser to the KP tab and verify:**
    ```bash
    agent-browser --cdp "$AGENT_BROWSER_CDP" tab 0
    agent-browser --cdp "$AGENT_BROWSER_CDP" snapshot | grep "Keyword Planner"
    ```

    If KP tab was closed by accident, navigate the remaining tab back to KP:
    ```bash
    agent-browser --cdp "$AGENT_BROWSER_CDP" eval 'window.location.href="<KP_BASE_URL>"'
    ```

    **Common stale targets to close:**
    - Google Sheets tabs (from "Open sheet" button — opens in new window)
    - `accounts.google.com/RotateCookiesPage` (cookie rotation iframes)
    - Blank tabs (`chrome://newtab/`)
    - Old KP results pages (if you navigated away)

    **DO NOT start the next batch until cleanup is confirmed.**

#### Key Element Selectors Reference

| Element | Location | How to Find |
|---------|----------|-------------|
| Reactivate banner "Hide" | KP home | `snapshot -i` → `button "Hide"` |
| Discover new keywords | KP home | `snapshot -i` → `button "Discover new keywords Get keyword ideas..."` |
| Location settings | Discover panel | `snapshot -i` → `button "Locations settings, India"` |
| Remove India | Location dialog | `snapshot -i` → `button "Remove targeted location, India"` |
| Country in dropdown | Location dialog | NOT in snapshot — JS eval: `document.querySelectorAll('span').find(el => el.textContent.trim() === 'United Kingdom')` |
| Search input | Discover panel | `snapshot -i` → `textbox "Search input"` (ref changes after each chip!) |
| Get results | Discover panel | `snapshot -i` → `button "Get results"` |
| Download keyword ideas | KP results | NOT in snapshot — JS eval: `document.querySelectorAll('material-button').find(...)` |
| Google Sheets option | Download dropdown | NOT in snapshot — JS eval: `document.querySelectorAll('material-select-item').find(...)` |
| Download button (dialog) | Download dialog | NOT in snapshot — JS eval: `document.querySelectorAll('material-button').find(el => el.textContent.trim() === 'Download')` |
| Open sheet | KP results toast | `snapshot -i` → `button "Open sheet"` |
| File menu | Google Sheets | `snapshot -i` → `menuitem "File"` |
| Share submenu | File menu | `snapshot -i` → `menuitem "Share s ►"` |
| Share with others | Share submenu | `snapshot -i` → `menuitem "Share with others s"` |
| Restricted button | Share dialog (IFRAME) | JS eval via `iframe.share-client-content-iframe` → `doc.querySelector('[aria-label="Restricted change general access"]')` |
| Anyone with the link | Restricted dropdown (IFRAME) | JS eval → `doc.querySelector('[data-value="4"][role="menuitemradio"]')` |
| Done button | Share dialog (IFRAME) | JS eval → find `button` with text "Done" |

#### Lessons Learned

- **`fill` does NOT create chips** — must use `type` + `Tab` for KP's Material Design chip input.
- **`Enter` and Comma do NOT create chips** — only `Tab` works.
- **Textbox ref changes** after each chip — always re-snapshot to get fresh ref.
- **`<material-button>` elements are invisible** to accessibility snapshot — always use JS eval.
- **`<material-select-item>` elements are invisible** to accessibility snapshot — always use JS eval.
- **Share dialog is in an iframe** (`iframe.share-client-content-iframe`) — must access via `iframe.contentDocument`.
- **Restricted dropdown options** use `data-value="4"` for "Anyone with the link" and `role="menuitemradio"`.
- **Google Sheets pages are HEAVY** — they freeze CDP connections and timeout on screenshots. Replace the tab (navigate KP tab to Sheet URL) instead of opening new tabs.
- **Never have multiple Sheets tabs open** — close/replace them to avoid browser memory issues.
- **Screenshots on Sheets pages** will timeout (`Page.captureScreenshot` fails) — use JPEG format on KP pages only: `--screenshot-format jpeg --screenshot-quality 50`.
- **Location defaults to India** — must remove India and add UK every time.
- **"Open sheet" opens a NEW WINDOW, not a tab** — agent-browser `tab` command won't see it. Use `curl <CDP_HTTP_URL>/json` to find the Sheet URL, then `agent-browser tab new <URL>` to open it in a tab you can switch to.
- **MUST switch tabs with `agent-browser tab <n>` before interacting** — snapshot/click/Share all silently fail on unfocused tabs. Always `tab <n>` first, then verify with `snapshot`.
- **MUST close ALL stale tabs after EVERY batch** — use `curl <CDP_HTTP_URL>/json/close/<target_id>` for each non-KP target. Verify clean state before starting next batch. Stale Sheets tabs freeze CDP.
- **Keyword-based seeds get blocked for vaping** — Google Ads restricts tobacco/nicotine keywords. Use "Start with a website" tab instead, passing the brand or competitor URL. This returns 250-1000+ keyword ideas without restriction.
- **Download button ref click opens nav menu instead** — the `Download keyword ideas` button ref overlaps with the nav. Use JS eval with `document.querySelectorAll("material-button")[14].click()` or find by `aria-label`/`textContent` instead.
- **Google Sheets menuitem ref click fails** — use JS eval: `document.querySelectorAll("material-select-dropdown-item, material-select-item, [role='menuitem']")` and find by textContent.
- **Google Ads pages timeout on `open`** but still load — verify with snapshot after timeout error.
- **Restricted button `.click()` does NOT open dropdown** — must dispatch full mouse events (`mousedown` → `mouseup` → `click`) via `dispatchEvent()`. A plain `.click()` silently fails. Always verify the dropdown opened by checking for `[role="menuitemradio"]` elements before trying to select an option. If not open, dispatch events again.
- **Share dialog won't open on unfocused tabs** — when "Open sheet" creates a new tab, the KP tab loses focus. The Share button click silently fails on unfocused tabs. Fix: use `agent-browser --cdp 9222 tab 0` to switch to the active tab, or close extra tabs with `agent-browser --cdp 9222 tab close <n>`. Always verify the iframe exists after clicking Share.
- **Use toolbar Share button, not File menu** — File → Share → Share with others often fails because the File menu closes before you can click the submenu items. The toolbar `button "Share. Private only to me."` is more reliable.

### Batches

Run 6 batches across verticals relevant to {{BRAND_NAME}}'s product categories. Each batch:
- 2-5 seed keywords (focused, not 10 generic ones)
- Location: UK
- Language: English
- Export to Google Sheets → download CSV from Sheets

### Consolidation & Filtering

- [ ] **2.1** Combine all batches
- [ ] **2.2** Deduplicate across batches
- [ ] **2.3** Filter out junk keywords (competitor brands, irrelevant queries, single generic words)
- [ ] **2.4** Score remaining keywords using relevance scoring (0-100) based on: volume, competition, CPC signal, {{BRAND_NAME}} product alignment, market specificity, growth trends
- [ ] **2.5** Select top **500 keywords** by score (Iteration 1)
- [ ] **2.6** Cross-verify all rows against raw batch data

### Columns Per Keyword

1. `id` — sequential ID
2. `keyword` — keyword phrase
3. `avg_monthly_searches` — volume as range string
4. `volume` — midpoint estimate
5. `competition_kp` — KP competition label (Low / Medium / High)
6. `competition_index` — KP competition indexed value (0-100)
7. `kd` — keyword difficulty (0-100)
8. `kd_level` — Very Low / Low / Medium / High / Very High
9. `yoy_change` — year-over-year change
10. `three_month_change` — 3-month change
11. `geo` — target geography
12. `intent` — Informational / Commercial / Transactional / Navigational
13. `priority` — Critical / High / Medium
14. `pillar` — blank (assigned in Step 5)
15. `product_category` — which {{BRAND_NAME}} product category this maps to
16. `page_type` — Pillar / Landing Page / Blog / Comparison / Tutorial / Tool
17. `trends_score` — from Google Trends
18. `cpc_usd` — CPC in USD
19. `current_position` — blank (filled in Step 6)
20. `opportunity_gap` — blank (filled in Step 6)
21. `notes` — additional context

## Phase 3: Google Trends Analysis

- [ ] **3.1** Compare pillar-level terms on Google Trends
- [ ] **3.2** Screenshot trend lines for UK
- [ ] **3.3** Document key findings (dominant terms per market, seasonal patterns)
- [ ] **3.4** Geographic breakdown by city/region
- [ ] **3.5** Capture rising queries
- [ ] **3.6** Note seasonal patterns

## Phase 4: Keyword Mix Validation

- [ ] **4.1** Check priority distribution (Critical / High / Medium)
- [ ] **4.2** Check volume distribution across bands
- [ ] **4.3** Check market coverage (UK represented)
- [ ] **4.4** Check intent mix (Informational + Commercial balanced, Transactional and Navigational covered)
- [ ] **4.5** Confirm total keyword count meets target
- [ ] **4.6** Confirm zero duplicates
- [ ] **4.7** Cross-verification against raw batch data

---

## Output

| File | Description |
|------|-------------|
| `master-keywords.json` | All keywords with 21 columns of real data |
| `master-keywords.csv` | Same data in CSV format |
| `keywords-by-volume.md` | Top keywords by volume + critical keywords + stats |
| `render-keywords.py` | Python renderer to regenerate MD from JSON |
| `batches/` | Raw KP exports per batch |
| `screenshots/` | All screenshots as evidence |

---

## Rules

1. **Sequential execution only** — complete each step before moving to the next
2. **Screenshot everything** — every Keyword Planner result and Trends chart needs to be saved
3. **Real data only** — no estimated volumes, only what Google Keyword Planner and Trends actually report
4. **Pillar column left blank** — gets assigned in Step 5
5. **Position columns left blank** — gets filled in Step 6
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
