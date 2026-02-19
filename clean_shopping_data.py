"""
clean_shopping_data.py
──────────────────────
Data cleaning pipeline for customer_shopping_behavior.csv

Issues handled:
  1. BOM character in header
  2. Missing Review Rating (37 rows) — filled with median
  3. Data type standardisation
  4. Text inconsistencies (whitespace, casing)
  5. Boolean-like column safety (Yes/No guard)
  6. Column renaming (snake_case)
  7. Derived columns (age_group, spend_tier, is_loyal)
  8. Range validation & clipping
  9. Duplicate removal

Usage:
    python clean_shopping_data.py
"""

import pandas as pd
import numpy as np
import os

# ── PATHS ─────────────────────────────────────────────────────────────────────
INPUT = r"C:\Users\hp\Desktop\customer-shopping-behavior\data\customer_shopping_behavior.csv"
OUTPUT = r"C:\Users\hp\Desktop\customer-shopping-behavior\data\shopping_data_clean.csv"

print("=" * 60)
print("  CUSTOMER SHOPPING DATA — CLEANING PIPELINE")
print("=" * 60)

# ── 1. LOAD ───────────────────────────────────────────────────────────────────
df = pd.read_csv(INPUT, encoding="utf-8-sig")   # utf-8-sig strips the BOM (﻿)
print(f"\n[1] Loaded       : {df.shape[0]} rows × {df.shape[1]} columns")

# ── 2. RENAME COLUMNS (snake_case) ────────────────────────────────────────────
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace(r"[^a-z0-9_]", "", regex=True)
)
df.rename(columns={
    "purchase_amount_usd":       "purchase_amount",
    "frequency_of_purchases":    "purchase_frequency",
    "subscription_status":       "subscription",
    "item_purchased":            "item",
}, inplace=True)
print(f"[2] Columns renamed to snake_case")

# ── 3. VALIDATE EXPECTED COLUMNS ─────────────────────────────────────────────
expected = ["customer_id", "age", "gender", "item", "category",
            "purchase_amount", "review_rating", "previous_purchases",
            "season", "subscription", "payment_method", "shipping_type"]
missing_cols = [c for c in expected if c not in df.columns]
if missing_cols:
    raise ValueError(
        f"[ERROR] Missing expected columns after rename: {missing_cols}")
print(f"[3] Column validation passed")

# ── 4. FIX DATA TYPES ─────────────────────────────────────────────────────────
df["customer_id"] = df["customer_id"].astype("Int64")
df["age"] = pd.to_numeric(df["age"], errors="coerce").astype("Int64")
df["purchase_amount"] = pd.to_numeric(df["purchase_amount"], errors="coerce")
df["review_rating"] = pd.to_numeric(df["review_rating"],   errors="coerce")
df["previous_purchases"] = pd.to_numeric(
    df["previous_purchases"], errors="coerce").astype("Int64")
print(f"[4] Data types fixed")

# ── 5. STANDARDISE TEXT COLUMNS ───────────────────────────────────────────────
text_cols = ["gender", "item", "category", "location", "size", "color",
             "season", "shipping_type", "payment_method", "purchase_frequency"]
for col in text_cols:
    if col in df.columns:
        df[col] = df[col].astype(str).str.strip().str.title()
print(f"[5] Text columns standardised")

# ── 6. SAFE BOOLEAN STANDARDISATION ──────────────────────────────────────────
# Safer than .title() — explicitly maps known variants, fills unknowns with "No"
bool_map = {
    "yes": "Yes", "no": "No",
    "true": "Yes", "false": "No",
    "1": "Yes", "0": "No"
}
for col in ["subscription", "discount_applied", "promo_code_used"]:
    if col in df.columns:
        df[col] = (df[col].astype(str).str.strip().str.lower()
                   .map(bool_map).fillna("No"))
print(f"[6] Boolean columns standardised safely")

# ── 7. HANDLE MISSING VALUES ──────────────────────────────────────────────────
missing_before = df.isnull().sum().sum()
median_rating = df["review_rating"].median()
df["review_rating"] = df["review_rating"].fillna(median_rating)
missing_after = df.isnull().sum().sum()
print(f"[7] Missing values: {missing_before} → {missing_after}  "
      f"(review_rating filled with median {median_rating})")

# ── 8. CLIP / VALIDATE RANGES ─────────────────────────────────────────────────
df["age"] = df["age"].clip(18, 100)
df["purchase_amount"] = df["purchase_amount"].clip(0, 10_000)
df["review_rating"] = df["review_rating"].clip(1.0, 5.0)
print(f"[8] Values clipped to valid ranges")

# ── 9. REMOVE DUPLICATES ──────────────────────────────────────────────────────
before = len(df)
df = df.drop_duplicates(subset="customer_id", keep="first")
print(f"[9] Duplicates removed: {before - len(df)} "
      f"(by customer_id — {len(df)} rows remain)")

# ── 10. ADD DERIVED COLUMNS ───────────────────────────────────────────────────
# Age group
bins = [17, 25, 35, 45, 55, 65, 100]
labels = ["18-25", "26-35", "36-45", "46-55", "56-65", "66+"]
df["age_group"] = pd.cut(df["age"], bins=bins, labels=labels).astype(str)

# Spend tier — FIXED: use float('inf') so values above $70 are captured correctly
df["spend_tier"] = pd.cut(
    df["purchase_amount"],
    bins=[0, 40, 70, float("inf")],
    labels=["Low (<$40)", "Mid ($40-$70)", "High (>$70)"]
).astype(str)

# Loyal customer flag: subscribed + more than 25 previous purchases
df["is_loyal"] = (
    (df["subscription"] == "Yes") & (df["previous_purchases"] > 25)
).map({True: "Yes", False: "No"})

print(f"[10] Derived columns added: age_group, spend_tier, is_loyal")

# ── 11. SAVE ──────────────────────────────────────────────────────────────────
os.makedirs(os.path.dirname(OUTPUT), exist_ok=True)
df.to_csv(OUTPUT, index=False)

print(f"\n{'=' * 60}")
print(f"  ✅ Saved → {OUTPUT}")
print(f"     Final shape  : {df.shape[0]} rows × {df.shape[1]} columns")
print(f"     Missing      : {df.isnull().sum().sum()}")
print(f"     Duplicates   : {df.duplicated(subset='customer_id').sum()}")
print(f"\n  Columns: {df.columns.tolist()}")
print(f"{'=' * 60}")
print(df.head())

# ── 12. QUICK SUMMARY REPORT ──────────────────────────────────────────────────
print(f"\n{'─' * 60}")
print("  DATA QUALITY SUMMARY")
print(f"{'─' * 60}")
print(f"  Total customers     : {len(df):,}")
print(f"  Avg purchase amount : ${df['purchase_amount'].mean():.2f}")
print(f"  Avg review rating   : {df['review_rating'].mean():.2f}")
print(
    f"  Subscription rate   : {(df['subscription'] == 'Yes').mean()*100:.1f}%")
print(f"  Loyal customers     : {(df['is_loyal'] == 'Yes').sum():,}")
print(
    f"  Age groups          :\n{df['age_group'].value_counts().sort_index().to_string()}")
print(
    f"  Spend tiers         :\n{df['spend_tier'].value_counts().to_string()}")
print(f"{'─' * 60}")
