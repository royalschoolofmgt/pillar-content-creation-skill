#!/usr/bin/env bash
# ============================================================
# share-and-download-csv.sh — Open Sheet tab, make public, download CSV, cleanup
# Usage: ./scripts/share-and-download-csv.sh <batch-name>
#   e.g. ./scripts/share-and-download-csv.sh batch3-<category-name>
# Reads SHEET_ID and GID from /tmp/kp_sheet_id.txt and /tmp/kp_sheet_gid.txt
# (written by download-to-sheets.sh)
# Requires: AGENT_BROWSER_CDP env var, CDP_HTTP_URL env var
# ============================================================
set -euo pipefail

BATCH_NAME="${1:?Usage: share-and-download-csv.sh <batch-name>}"
CDP="$AGENT_BROWSER_CDP"
CDP_HTTP="${CDP_HTTP_URL:-https://referred-devel-birmingham-voted.trycloudflare.com}"
AB="agent-browser --cdp $CDP"
BATCHES_DIR="$(cd "$(dirname "$0")/../batches" && pwd)"

SHEET_ID=$(cat /tmp/kp_sheet_id.txt)
GID=$(cat /tmp/kp_sheet_gid.txt)
SHEET_URL=$(cat /tmp/kp_sheet_url.txt)

echo "=== Sharing & downloading: $BATCH_NAME ==="
echo "  Sheet ID: $SHEET_ID"
echo "  GID: $GID"

# 1. Open Sheet in a new tab (Open Sheet opens a new WINDOW, not a tab)
echo "  Opening Sheet in new tab..."
$AB tab new "$SHEET_URL" 2>&1 | tail -1
sleep 8

# 2. Switch to the Sheet tab (MUST do this before interacting)
echo "  Switching to Sheet tab..."
# Find which tab has the sheet — list tabs, get the highest tab number
TAB_LIST=$($AB tab 2>&1)
echo "$TAB_LIST"
# Extract all [N] numbers, pick the highest (newest tab = the Sheet we just opened)
SHEET_TAB=$(echo "$TAB_LIST" | grep -oP '\[(\d+)\]' | grep -oP '\d+' | sort -n | tail -1)
if [ -z "$SHEET_TAB" ]; then
  SHEET_TAB=1
fi
echo "  Switching to tab $SHEET_TAB..."
REAL_URL=$($AB tab "$SHEET_TAB" 2>&1 | grep -oP 'https://docs\.google\.com/spreadsheets/d/[^\s]+' | head -1)
sleep 4

# 2b. Extract real GID from the loaded Sheet URL (the /json GID is often truncated)
if [ -n "$REAL_URL" ]; then
  REAL_GID=$(echo "$REAL_URL" | grep -oP 'gid=\K[0-9]+' | tail -1)
  if [ -n "$REAL_GID" ] && [ "$REAL_GID" != "$GID" ]; then
    echo "  GID corrected: $GID → $REAL_GID"
    GID="$REAL_GID"
  fi
fi

# 3. Verify we're on the Sheet
SHARE_BTN=$($AB snapshot 2>&1 | grep 'button "Share. Private' | grep -o 'ref=e[0-9]*' | head -1 | sed 's/ref=//')
if [ -z "$SHARE_BTN" ]; then
  echo "  Share button not found, trying tab 0..."
  $AB tab 0 2>&1 | tail -1
  sleep 2
  SHARE_BTN=$($AB snapshot 2>&1 | grep 'button "Share. Private' | grep -o 'ref=e[0-9]*' | head -1 | sed 's/ref=//')
fi

if [ -z "$SHARE_BTN" ]; then
  echo "ERROR: Cannot find Share button on any tab"
  exit 1
fi

# 4. Click Share
echo "  Clicking Share (ref=$SHARE_BTN)..."
$AB click "$SHARE_BTN" 2>&1 | tail -1
sleep 5

# 5. Verify iframe loaded
IFRAME_CHECK=$($AB eval '(function(){ var i=document.querySelector("iframe.share-client-content-iframe"); return i?"found":"not found"; })()' 2>&1)
if echo "$IFRAME_CHECK" | grep -q "not found"; then
  echo "  Iframe not found, retrying Share..."
  $AB click "$SHARE_BTN" 2>&1 | tail -1
  sleep 5
  IFRAME_CHECK=$($AB eval '(function(){ var i=document.querySelector("iframe.share-client-content-iframe"); return i?"found":"not found"; })()' 2>&1)
fi
echo "  Share iframe: $IFRAME_CHECK"

# 6. Open Restricted dropdown (dispatch full mouse events, retry up to 3 times)
JS_RESTRICTED='(function(){ var iframe=document.querySelector("iframe.share-client-content-iframe"); var doc=iframe.contentDocument||iframe.contentWindow.document; var btn=doc.querySelector("[aria-label=\"Restricted change general access\"]"); if(!btn) return "button not found"; ["mousedown","mouseup","click"].forEach(function(evt){ btn.dispatchEvent(new MouseEvent(evt,{bubbles:true,cancelable:true,view:iframe.contentWindow})); }); return "dispatched"; })()'

JS_VERIFY='(function(){ var iframe=document.querySelector("iframe.share-client-content-iframe"); var doc=iframe.contentDocument||iframe.contentWindow.document; var items=doc.querySelectorAll("[role=\"menuitemradio\"]"); if(items.length===0) return "NOT_OPEN"; var r=[]; for(var i=0;i<items.length;i++){ r.push(items[i].getAttribute("data-value")+":"+items[i].textContent.trim().substring(0,20)); } return r.join("|"); })()'

for attempt in 1 2 3; do
  echo "  Opening Restricted dropdown (attempt $attempt)..."
  $AB eval "$JS_RESTRICTED" 2>&1 | tail -1
  sleep 3
  DROPDOWN=$($AB eval "$JS_VERIFY" 2>&1)
  if echo "$DROPDOWN" | grep -q "4:"; then
    echo "  Dropdown open: $DROPDOWN"
    break
  fi
  if [ "$attempt" -eq 3 ]; then
    echo "ERROR: Restricted dropdown won't open after 3 attempts"
    exit 1
  fi
done

# 7. Select "Anyone with the link" (data-value="4")
echo "  Selecting 'Anyone with the link'..."
$AB eval '(function(){ var iframe=document.querySelector("iframe.share-client-content-iframe"); var doc=iframe.contentDocument||iframe.contentWindow.document; var opt=doc.querySelector("[data-value=\"4\"][role=\"menuitemradio\"]"); if(opt){ opt.click(); return "clicked"; } return "not found"; })()' 2>&1
sleep 2

# 8. Click Done
echo "  Clicking Done..."
$AB eval '(function(){ var iframe=document.querySelector("iframe.share-client-content-iframe"); var doc=iframe.contentDocument||iframe.contentWindow.document; var btns=doc.querySelectorAll("button"); for(var i=0;i<btns.length;i++){ if(btns[i].textContent.trim()==="Done"){ btns[i].click(); return "clicked"; }} return "not found"; })()' 2>&1
sleep 2

# 9. Download CSV
CSV_PATH="$BATCHES_DIR/${BATCH_NAME}.csv"
echo "  Downloading CSV to $CSV_PATH..."
curl -sL "https://docs.google.com/spreadsheets/d/${SHEET_ID}/export?format=csv&gid=${GID}" -o "$CSV_PATH"
LINES=$(wc -l < "$CSV_PATH")
echo "  Downloaded: $LINES lines"
head -4 "$CSV_PATH"

# 10. Cleanup — close ALL non-KP tabs via CDP
echo "  Cleaning up stale tabs..."
python3 << PYEOF
import json, urllib.request
url = "${CDP_HTTP}/json"
tabs = json.loads(urllib.request.urlopen(url).read())
for t in tabs:
    if "keywordplanner" not in t.get("url", ""):
        tid = t.get("id", "")
        try:
            urllib.request.urlopen(f"${CDP_HTTP}/json/close/{tid}")
            print(f"  Closed: {t.get('title','')[:40]}")
        except:
            pass
PYEOF

# 11. Verify clean state
REMAINING=$(curl -s "$CDP_HTTP/json" | python3 -c "import json,sys; tabs=json.load(sys.stdin); print(len(tabs))")
echo "  Tabs remaining: $REMAINING"

# 12. Switch back to KP tab
$AB tab 0 2>&1 | tail -1

echo "=== Done: $CSV_PATH ($LINES lines) ==="
