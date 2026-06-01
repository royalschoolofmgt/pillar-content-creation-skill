#!/usr/bin/env python3
"""
Consolidate all KP batches + Google Trends into a single master keyword list.
- Deduplicates by keyword (keeps highest volume entry)
- Scores each keyword 0-100
- Outputs master-keywords.csv and shortlisted-top-500.csv
"""

import csv
import os
import math
import re
import json
from collections import defaultdict

BATCHES_DIR = "batches"
OUTPUT_DIR = "."

# Target geography for output rows — read from config.json target_markets[0]
try:
    GEO = (json.load(open("../config.json")).get("target_markets") or ["United States"])[0]
except Exception:
    GEO = "United States"

# Map each batch CSV filename to its KP source (brand/competitor URL). Replace with this run's batches.
KP_BATCHES = {
    "batch1-<competitor1>.csv": "KP:<competitor1-domain>",
    "batch2-<competitor2>.csv": "KP:<competitor2-domain>",
    "batch3-<brand>.csv": "KP:<brand-domain>",
}

# Define this brand's product categories and the keyword regexes that map to each.
# Populate from config.json scope.pillar_definitions / product categories for this run.
CATEGORY_PATTERNS = {
    "Category 1": [r"<regex>", r"<regex>"],
    "Category 2": [r"<regex>"],
    "Category 3": [r"<regex>"],
    # Keep these helper buckets — they feed the relevance bonus in score_keyword().
    "Educational": [
        r"what is", r"how to", r"guide", r"beginner", r"explained",
        r"difference between", r"vs ", r"versus", r"comparison",
        r"best ", r"top \d", r"review", r"which",
        r"how long", r"how much", r"how many",
    ],
    "Informational": [
        r"safe", r"health", r"risk", r"side effect", r"study",
    ],
    "Regulations & News": [
        r"ban", r"regulation", r"law", r"legal", r"illegal",
        r"tax", r"age", r"news",
    ],
    "Wholesale": [
        r"wholesale", r"bulk", r"trade", r"b2b", r"distributor",
    ],
    # ... add the brand's real categories here
}

def classify_keyword(kw):
    """Classify keyword into this brand's product category."""
    kw_lower = kw.lower()
    scores = {}
    for cat, patterns in CATEGORY_PATTERNS.items():
        score = 0
        for p in patterns:
            if re.search(p, kw_lower):
                score += 1
        if score > 0:
            scores[cat] = score
    if scores:
        return max(scores, key=scores.get)
    return "General"

def classify_intent(kw):
    """Classify search intent."""
    kw_lower = kw.lower()
    if any(w in kw_lower for w in ["buy", "price", "cheap", "deal", "discount", "shop", "store", "order", "delivery", "free delivery", "clearance", "sale"]):
        return "Transactional"
    if any(w in kw_lower for w in ["best", "top", "review", "vs", "compare", "which", "recommended"]):
        return "Commercial"
    if any(w in kw_lower for w in ["what is", "how to", "guide", "why", "can you", "is it", "does", "difference", "explain", "safe", "health", "risk", "ban", "law", "regulation"]):
        return "Informational"
    if any(w in kw_lower for w in ["near me", "login", "website", "amazon"]):  # add this market's big retailers/junk terms
        return "Navigational"
    # Default based on keyword structure
    if len(kw_lower.split()) <= 2:
        return "Commercial"
    return "Commercial"

def parse_volume(vol_str):
    """Parse KP volume string to numeric midpoint."""
    if not vol_str or vol_str == "--":
        return 0
    vol_str = str(vol_str).strip().replace(",", "")
    try:
        return int(vol_str)
    except ValueError:
        # Handle ranges like "1K - 10K"
        m = re.search(r"(\d+)", vol_str)
        if m:
            return int(m.group(1))
        return 0

def parse_competition_index(ci_str):
    """Parse competition index to float 0-100."""
    if not ci_str or ci_str == "--":
        return 50  # default medium
    try:
        return float(ci_str)
    except ValueError:
        return 50

def score_keyword(volume, comp_index, category, kw):
    """Score keyword 0-100 based on volume, ease, and relevance."""
    # Volume Score (0-50): log scale
    if volume > 0:
        vol_score = min(50, math.log10(max(volume, 1)) * 12)
    else:
        vol_score = 0

    # Ease Score (0-30): lower competition = higher score
    ease_score = 30 - (comp_index * 0.3)

    # Relevance Score (0-20): bonus for this brand's relevant terms
    relevance = 10  # base
    kw_lower = kw.lower()

    # High relevance: core product categories (from CATEGORY_PATTERNS)
    if category in ["Category 1", "Category 2", "Category 3"]:
        relevance += 5
    # Brands this brand stocks / core product terms. Populate per run.
    stocked_brands = ["<brand-or-product-term>"]
    if any(b for b in stocked_brands if b and b in kw_lower):
        relevance += 5
    # Market-specific terms (any token from the target market name, e.g. "United States" -> "united"/"states")
    market_tokens = [t for t in GEO.lower().split() if len(t) > 2]
    if any(t in kw_lower for t in market_tokens):
        relevance += 3
    # Educational/guide content (content marketing opportunity)
    if category in ["Educational", "Informational"]:
        relevance += 3
    # Regulatory (timely, high-interest)
    if category == "Regulations & News":
        relevance += 3

    relevance = min(20, relevance)

    return round(vol_score + ease_score + relevance, 1)

def kd_from_competition(comp_index, comp_label):
    """Estimate keyword difficulty from KP competition data."""
    # KP competition is advertiser competition, not organic KD
    # But it's a useful proxy. Map to 0-100 scale.
    if comp_label == "High":
        return min(100, comp_index + 20)
    elif comp_label == "Medium":
        return comp_index
    elif comp_label == "Low":
        return max(0, comp_index - 10)
    return comp_index

def kd_level(kd):
    if kd < 15:
        return "Very Low"
    elif kd < 30:
        return "Low"
    elif kd < 50:
        return "Medium"
    elif kd < 70:
        return "High"
    return "Very High"

# ============================================================
# PHASE 1: Load all KP batches
# ============================================================
print("=== Phase 1: Loading KP batches ===")

all_keywords = {}  # keyword -> best row dict

for filename, source in KP_BATCHES.items():
    filepath = os.path.join(BATCHES_DIR, filename)
    if not os.path.exists(filepath):
        print(f"  SKIP: {filename} not found")
        continue

    count = 0
    with open(filepath, "r", encoding="utf-8-sig") as f:
        lines = f.readlines()

    # Find header row (starts with "Keyword,Currency")
    header_idx = None
    for i, line in enumerate(lines):
        if line.strip().startswith("Keyword,Currency"):
            header_idx = i
            break

    if header_idx is None:
        print(f"  SKIP: {filename} — no header found")
        continue

    reader = csv.DictReader(lines[header_idx:])
    for row in reader:
        kw = row.get("Keyword", "").strip().lower()
        if not kw:
            continue

        volume = parse_volume(row.get("Avg. monthly searches", "0"))
        comp_label = row.get("Competition", "Unknown")
        comp_index = parse_competition_index(row.get("Competition (indexed value)", "50"))
        three_month = row.get("Three month change", "--")
        yoy = row.get("YoY change", "--")
        bid_low = row.get("Top of page bid (low range)", "")
        bid_high = row.get("Top of page bid (high range)", "")

        # Keep higher volume entry if duplicate
        if kw in all_keywords:
            if volume > all_keywords[kw]["volume"]:
                all_keywords[kw].update({
                    "volume": volume,
                    "competition_label": comp_label,
                    "competition_index": comp_index,
                    "three_month_change": three_month,
                    "yoy_change": yoy,
                    "bid_low": bid_low,
                    "bid_high": bid_high,
                    "source": source,
                })
            # Append source if not already there
            if source not in all_keywords[kw]["all_sources"]:
                all_keywords[kw]["all_sources"].append(source)
        else:
            all_keywords[kw] = {
                "keyword": kw,
                "volume": volume,
                "competition_label": comp_label,
                "competition_index": comp_index,
                "three_month_change": three_month,
                "yoy_change": yoy,
                "bid_low": bid_low,
                "bid_high": bid_high,
                "source": source,
                "all_sources": [source],
                "trend_growth": "",
            }
            count += 1

    print(f"  {filename}: {count} new keywords (total unique so far: {len(all_keywords)})")

# ============================================================
# PHASE 2: Load Google Trends rising queries
# ============================================================
print("\n=== Phase 2: Loading Google Trends rising queries ===")

trends_file = os.path.join(BATCHES_DIR, "trends-rising-queries.csv")
trends_added = 0
trends_enriched = 0

with open(trends_file, "r") as f:
    reader = csv.DictReader(f)
    for row in reader:
        kw = row["Keyword"].strip().lower()
        growth = row.get("Trend_Growth", "")

        if kw in all_keywords:
            # Enrich existing keyword with trend data
            all_keywords[kw]["trend_growth"] = growth
            if "Trends" not in all_keywords[kw]["all_sources"]:
                all_keywords[kw]["all_sources"].append("Trends")
            trends_enriched += 1
        else:
            # Add as new keyword (no KP volume data)
            all_keywords[kw] = {
                "keyword": kw,
                "volume": 0,  # no KP data
                "competition_label": "Unknown",
                "competition_index": 50,
                "three_month_change": "--",
                "yoy_change": "--",
                "bid_low": "",
                "bid_high": "",
                "source": "Trends",
                "all_sources": ["Trends"],
                "trend_growth": growth,
            }
            trends_added += 1

print(f"  Trends: {trends_added} new keywords, {trends_enriched} enriched existing")
print(f"  Total unique keywords: {len(all_keywords)}")

# ============================================================
# PHASE 3: Classify, score, and sort
# ============================================================
print("\n=== Phase 3: Classifying and scoring ===")

results = []
for kw_data in all_keywords.values():
    kw = kw_data["keyword"]
    volume = kw_data["volume"]
    comp_index = kw_data["competition_index"]
    comp_label = kw_data["competition_label"]

    category = classify_keyword(kw)
    intent = classify_intent(kw)
    kd = kd_from_competition(comp_index, comp_label)
    kd_lev = kd_level(kd)
    score = score_keyword(volume, comp_index, category, kw)

    # Boost score for trending keywords
    trend = kw_data["trend_growth"]
    if trend:
        if "Breakout" in trend:
            score = min(100, score + 10)
        else:
            pct_match = re.search(r'\+(\d+)', trend.replace(",", ""))
            if pct_match:
                pct = int(pct_match.group(1))
                if pct >= 500:
                    score = min(100, score + 8)
                elif pct >= 200:
                    score = min(100, score + 5)
                elif pct >= 100:
                    score = min(100, score + 3)

    # Priority based on score
    if score >= 70:
        priority = "Critical"
    elif score >= 50:
        priority = "High"
    else:
        priority = "Medium"

    # Format volume display
    if volume > 0:
        vol_display = str(volume)
    else:
        vol_display = "N/A (Trends only)"

    # Source display
    sources_str = " + ".join(kw_data["all_sources"])

    results.append({
        "keyword": kw,
        "avg_monthly_searches": vol_display,
        "volume": volume,
        "competition_label": comp_label,
        "competition_index": comp_index,
        "kd": round(kd),
        "kd_level": kd_lev,
        "three_month_change": kw_data["three_month_change"],
        "yoy_change": kw_data["yoy_change"],
        "trend_growth": trend,
        "intent": intent,
        "priority": priority,
        "product_category": category,
        "score": score,
        "bid_low": kw_data["bid_low"],
        "bid_high": kw_data["bid_high"],
        "source": sources_str,
        "geo": GEO,
    })

# Sort by score descending
results.sort(key=lambda x: x["score"], reverse=True)

# ============================================================
# PHASE 4: Output files
# ============================================================
print("\n=== Phase 4: Writing output files ===")

# Master keywords CSV
master_cols = [
    "id", "keyword", "avg_monthly_searches", "volume",
    "competition_label", "competition_index", "kd", "kd_level",
    "three_month_change", "yoy_change", "trend_growth",
    "intent", "priority", "product_category", "score",
    "bid_low", "bid_high", "source", "geo",
]

master_path = os.path.join(OUTPUT_DIR, "master-keywords.csv")
with open(master_path, "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=master_cols)
    writer.writeheader()
    for i, row in enumerate(results, 1):
        row["id"] = i
        writer.writerow(row)

print(f"  master-keywords.csv: {len(results)} keywords")

# Shortlisted top 500
shortlist = results[:500]
shortlist_path = os.path.join(OUTPUT_DIR, "shortlisted-top-500.csv")
with open(shortlist_path, "w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=master_cols)
    writer.writeheader()
    for i, row in enumerate(shortlist, 1):
        row["id"] = i
        writer.writerow(row)

print(f"  shortlisted-top-500.csv: {len(shortlist)} keywords")

# ============================================================
# PHASE 5: Stats summary
# ============================================================
print("\n=== Summary Statistics ===")

# Volume bands
head_terms = [r for r in results if r["volume"] >= 5000]
mid_tail = [r for r in results if 500 <= r["volume"] < 5000]
long_tail = [r for r in results if 0 < r["volume"] < 500]
no_vol = [r for r in results if r["volume"] == 0]

print(f"  Total unique keywords: {len(results)}")
print(f"  Head terms (5K+):  {len(head_terms)} ({len(head_terms)*100//max(len(results),1)}%)")
print(f"  Mid-tail (500-5K): {len(mid_tail)} ({len(mid_tail)*100//max(len(results),1)}%)")
print(f"  Long-tail (<500):  {len(long_tail)} ({len(long_tail)*100//max(len(results),1)}%)")
print(f"  Trends-only (no vol): {len(no_vol)} ({len(no_vol)*100//max(len(results),1)}%)")

# Priority distribution
crit = len([r for r in shortlist if r["priority"] == "Critical"])
high = len([r for r in shortlist if r["priority"] == "High"])
med = len([r for r in shortlist if r["priority"] == "Medium"])
print(f"\n  Shortlist priority: Critical={crit}, High={high}, Medium={med}")

# Intent distribution
intents = defaultdict(int)
for r in shortlist:
    intents[r["intent"]] += 1
print(f"  Shortlist intent: {dict(intents)}")

# Category distribution
cats = defaultdict(int)
for r in shortlist:
    cats[r["product_category"]] += 1
print(f"\n  Shortlist categories:")
for cat, cnt in sorted(cats.items(), key=lambda x: -x[1]):
    print(f"    {cat}: {cnt}")

# Source distribution
kp_only = len([r for r in shortlist if "KP" in r["source"] and "Trends" not in r["source"]])
trends_only = len([r for r in shortlist if r["source"] == "Trends"])
both = len([r for r in shortlist if "KP" in r["source"] and "Trends" in r["source"]])
print(f"\n  Shortlist sources: KP only={kp_only}, Trends only={trends_only}, Both={both}")

# Score bands
s90 = len([r for r in shortlist if r["score"] >= 90])
s70 = len([r for r in shortlist if 70 <= r["score"] < 90])
s50 = len([r for r in shortlist if 50 <= r["score"] < 70])
s_below = len([r for r in shortlist if r["score"] < 50])
print(f"  Score bands: 90+={s90}, 70-89={s70}, 50-69={s50}, <50={s_below}")

print("\n=== Done ===")
