#!/usr/bin/env bash
# ============================================================
# set-country.sh — Remove the default location, add the target market (arg or config.json target_markets[0]), save
# Usage: ./scripts/set-country.sh [market]
# Requires: AGENT_BROWSER_CDP env var set
# ============================================================
set -euo pipefail

MARKET="${1:-$(jq -r '.target_markets[0] // "United States"' ../config.json)}"
CDP="$AGENT_BROWSER_CDP"
AB="agent-browser --cdp $CDP"

echo "=== Setting location to $MARKET ==="

# 1. Click location settings button (may say India or the target market)
LOC_REF=$($AB snapshot 2>&1 | grep -o 'button "Locations settings, [^"]*".*ref=e[0-9]*' | grep -o 'ref=e[0-9]*' | head -1 | sed 's/ref=//')
if [ -z "$LOC_REF" ]; then
  echo "ERROR: Location settings button not found"
  exit 1
fi
echo "  Clicking location settings (ref=$LOC_REF)..."
$AB click "$LOC_REF" 2>&1 | tail -1
sleep 2

# 2. Check if India is present and remove it
REMOVE_REF=$($AB snapshot 2>&1 | grep "button.*Remove targeted location.*India" | grep -o 'ref=e[0-9]*' | head -1 | sed 's/ref=//')
if [ -n "$REMOVE_REF" ]; then
  echo "  Removing India (ref=$REMOVE_REF)..."
  $AB click "$REMOVE_REF" 2>&1 | tail -1
  sleep 1
else
  echo "  India not present, skipping removal"
fi

# 3. Check if the target market is already added
MARKET_EXISTS=$($AB snapshot 2>&1 | grep -c "$MARKET country" || true)
if [ "$MARKET_EXISTS" -gt 0 ]; then
  echo "  $MARKET already added"
else
  # 4. Type the target market in combobox
  COMBO_REF=$($AB snapshot 2>&1 | grep "combobox.*Enter a location" | grep -o 'ref=e[0-9]*' | head -1 | sed 's/ref=//')
  if [ -z "$COMBO_REF" ]; then
    echo "ERROR: Location combobox not found"
    exit 1
  fi
  echo "  Typing '$MARKET' in combobox (ref=$COMBO_REF)..."
  $AB type "$COMBO_REF" "$MARKET" 2>&1 | tail -1
  sleep 2

  # 5. Click the target market country in dropdown via JS
  echo "  Clicking '$MARKET country' in dropdown..."
  $AB eval "(function(){ var spans = document.querySelectorAll('span'); for(var i=0; i<spans.length; i++){ if(spans[i].textContent.trim() === '$MARKET country'){ spans[i].click(); return 'clicked'; } } return 'not found'; })()" 2>&1
  sleep 1
fi

# 6. Click Save
SAVE_REF=$($AB snapshot 2>&1 | grep 'button "Save"' | grep -o 'ref=e[0-9]*' | head -1 | sed 's/ref=//')
if [ -z "$SAVE_REF" ]; then
  echo "ERROR: Save button not found"
  exit 1
fi
echo "  Clicking Save (ref=$SAVE_REF)..."
$AB click "$SAVE_REF" 2>&1 | tail -1
sleep 2

# 7. Verify
VERIFY=$($AB snapshot 2>&1 | grep "Locations settings, $MARKET" | head -1)
if [ -n "$VERIFY" ]; then
  echo "=== Location set to $MARKET ==="
else
  echo "WARNING: Could not verify $MARKET location — check manually"
fi
