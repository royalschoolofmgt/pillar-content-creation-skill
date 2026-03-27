#!/usr/bin/env bash
# ============================================================
# download-to-sheets.sh — Click Download → Google Sheets → Download
# Waits for "Open sheet", clicks it, returns SHEET_ID and GID
# Usage: ./scripts/download-to-sheets.sh
# Requires: AGENT_BROWSER_CDP env var, CDP_HTTP_URL env var
# ============================================================
set -euo pipefail

CDP="$AGENT_BROWSER_CDP"
CDP_HTTP="${CDP_HTTP_URL:-https://referred-devel-birmingham-voted.trycloudflare.com}"
AB="agent-browser --cdp $CDP"

echo "=== Downloading KP results to Google Sheets ==="

# 1. Click "Download keyword ideas" (material-button, invisible to snapshot — use JS)
echo "  Clicking 'Download keyword ideas'..."
$AB eval '(function(){ var all = document.querySelectorAll("material-button"); for(var i=0;i<all.length;i++){ if(all[i].textContent.includes("Download keyword ideas") && !all[i].disabled){ all[i].click(); return "clicked index "+i; }} return "not found"; })()' 2>&1
sleep 2

# 2. Click "Google Sheets" in dropdown (material-select-item, invisible to snapshot)
echo "  Selecting 'Google Sheets' format..."
$AB eval '(function(){ var items = document.querySelectorAll("material-select-dropdown-item, material-select-item, [role=\"menuitem\"]"); for(var i=0;i<items.length;i++){ if(items[i].textContent.trim()==="Google Sheets"){ items[i].click(); return "clicked"; }} return "not found"; })()' 2>&1
sleep 2

# 3. Click "Download" in the dialog (material-button with text "Download")
echo "  Clicking 'Download' in dialog..."
$AB eval '(function(){ var buttons = document.querySelectorAll("material-button"); for(var i=0;i<buttons.length;i++){ if(buttons[i].textContent.trim()==="Download"){ buttons[i].click(); return "clicked"; }} return "not found"; })()' 2>&1

# 4. Wait for "Report downloaded to Sheets" (poll every 3s, max 60s)
echo "  Waiting for report to download..."
for attempt in $(seq 1 20); do
  sleep 3
  OPEN_SHEET=$($AB snapshot 2>&1 | grep 'button "Open sheet"' | head -1)
  if [ -n "$OPEN_SHEET" ]; then
    echo "  Report downloaded!"
    break
  fi
  if [ "$attempt" -eq 20 ]; then
    echo "ERROR: Timed out waiting for report download (60s)"
    exit 1
  fi
done

# 5. Click "Open sheet"
OPEN_REF=$($AB snapshot 2>&1 | grep 'button "Open sheet"' | grep -o 'ref=e[0-9]*' | head -1 | sed 's/ref=//')
echo "  Clicking 'Open sheet' (ref=$OPEN_REF)..."
$AB click "$OPEN_REF" 2>&1 | tail -1
sleep 5

# 6. Get Sheet URL from CDP /json (find the NEWEST spreadsheet tab)
echo "  Finding Sheet URL from CDP..."
SHEET_URL=$(curl -s "$CDP_HTTP/json" | python3 -c "
import json, sys
tabs = json.load(sys.stdin)
sheets = [t for t in tabs if 'spreadsheet' in t.get('url', '')]
if sheets:
    # Sort by title to get the newest (timestamp in title)
    sheets.sort(key=lambda t: t.get('title', ''), reverse=True)
    print(sheets[0]['url'])
else:
    print('none')
")

if [ "$SHEET_URL" = "none" ]; then
  echo "ERROR: No spreadsheet tab found"
  exit 1
fi

# Extract SHEET_ID and GID
SHEET_ID=$(echo "$SHEET_URL" | sed 's|.*spreadsheets/d/||' | sed 's|/.*||')
GID=$(echo "$SHEET_URL" | grep -o 'gid=[0-9]*' | head -1 | sed 's/gid=//')

echo "  SHEET_URL=$SHEET_URL"
echo "  SHEET_ID=$SHEET_ID"
echo "  GID=$GID"
echo "=== Sheet ready ==="

# Export for the next script to consume
echo "$SHEET_ID" > /tmp/kp_sheet_id.txt
echo "$GID" > /tmp/kp_sheet_gid.txt
echo "$SHEET_URL" > /tmp/kp_sheet_url.txt
