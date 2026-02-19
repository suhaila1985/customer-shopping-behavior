"""
load_to_postgres.py
───────────────────
Loads the cleaned shopping dataset into PostgreSQL.

Prerequisites:
    pip install sqlalchemy psycopg2-binary pandas

Usage:
    1. Update the credentials below (or set as environment variables)
    2. python scripts/load_to_postgres.py
"""

import os
import pandas as pd
from sqlalchemy import create_engine, text

# ── CONFIGURATION ─────────────────────────────────────────────────────────────
# Option A: Hard-code credentials (not recommended for production)
DB_CONFIG = {
    "username": os.getenv("PG_USER", "postgres"),
    # Set env var PG_PASSWORD
    "password": os.getenv("PG_PASSWORD", "admin"),
    "host":     os.getenv("PG_HOST", "localhost"),
    "port":     os.getenv("PG_PORT", "5433"),
    "database": os.getenv("PG_DB",   "customer_behavior"),
}

TABLE_NAME = "customer_data"
SCHEMA = "public"

INPUT_CSV = r"C:\Users\hp\Desktop\customer-shopping-behavior\data\shopping_data_clean.csv"

# ── CONNECT ───────────────────────────────────────────────────────────────────
print("=" * 60)
print("  POSTGRESQL DATA LOADER")
print("=" * 60)

conn_str = (
    "postgresql+psycopg2://{username}:{password}@{host}:{port}/{database}"
).format(**DB_CONFIG)

try:
    engine = create_engine(conn_str)
    with engine.connect() as conn:
        conn.execute(text("SELECT 1"))
    print(
        f"\n[✓] Connected to PostgreSQL — {DB_CONFIG['database']}@{DB_CONFIG['host']}:{DB_CONFIG['port']}")
except Exception as e:
    print(f"\n[✗] Connection failed: {e}")
    print("    Check your DB_CONFIG credentials above or set environment variables.")
    raise SystemExit(1)

# ── LOAD CSV ──────────────────────────────────────────────────────────────────
print(f"\n[→] Loading CSV: {INPUT_CSV}")
df = pd.read_csv(INPUT_CSV)
print(f"    Shape: {df.shape[0]:,} rows × {df.shape[1]} columns")

# ── WRITE TO POSTGRES ─────────────────────────────────────────────────────────
print(f"\n[→] Writing to {SCHEMA}.{TABLE_NAME} ...")
df.to_sql(
    TABLE_NAME,
    engine,
    schema=SCHEMA,
    if_exists="replace",    # Change to "append" to add rows without dropping
    index=False,
    chunksize=500,          # Write in batches for large datasets
    method="multi",         # Faster multi-row INSERT
)

# ── VERIFY ────────────────────────────────────────────────────────────────────
with engine.connect() as conn:
    result = conn.execute(
        text(f"SELECT COUNT(*) FROM {SCHEMA}.{TABLE_NAME}")
    )
    row_count = result.scalar()

print(f"\n{'=' * 60}")
print(f"  ✅ Successfully loaded {row_count:,} rows into")
print(f"     {SCHEMA}.{TABLE_NAME} in database '{DB_CONFIG['database']}'")
print(f"{'=' * 60}")
