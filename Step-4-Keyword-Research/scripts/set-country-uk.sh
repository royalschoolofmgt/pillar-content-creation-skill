#!/usr/bin/env bash
# ============================================================
# set-country-uk.sh — Remove India, add United Kingdom, save
# Usage: ./scripts/set-country-uk.sh
# Requires: AGENT_BROWSER_CDP env var set
# ============================================================
set -euo pipefail

CDP="$AGENT_BROWSER_CDP"
AB="agent-browser --cdp $CDP"

echo "=== Setting location to United Kingdom ==="

# 1. Click location settings button (may say India or United Kingdom)
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

# 3. Check if UK is already added
UK_EXISTS=$($AB snapshot 2>&1 | grep -c "United Kingdom country" || true)
if [ "$UK_EXISTS" -gt 0 ]; then
  echo "  United Kingdom already added"
else
  # 4. Type United Kingdom in combobox
  COMBO_REF=$($AB snapshot 2>&1 | grep "combobox.*Enter a location" | grep -o 'ref=e[0-9]*' | head -1 | sed 's/ref=//')
  if [ -z "$COMBO_REF" ]; then
    echo "ERROR: Location combobox not found"
    exit 1
  fi
  echo "  Typing 'United Kingdom' in combobox (ref=$COMBO_REF)..."
  $AB type "$COMBO_REF" "United Kingdom" 2>&1 | tail -1
  sleep 2

  # 5. Click United Kingdom country in dropdown via JS
  echo "  Clicking 'United Kingdom country' in dropdown..."
  $AB eval '(function(){ var spans = document.querySelectorAll("span"); for(var i=0; i<spans.length; i++){ if(spans[i].textContent.trim() === "United Kingdom country"){ spans[i].click(); return "clicked"; } } return "not found"; })()' 2>&1
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
VERIFY=$($AB snapshot 2>&1 | grep "Locations settings, United Kingdom" | head -1)
if [ -n "$VERIFY" ]; then
  echo "=== Location set to United Kingdom ==="
else
  echo "WARNING: Could not verify UK location — check manually"
fi
