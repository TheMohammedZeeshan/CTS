# data_ingestion.py

import time
import requests
import pandas as pd
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas

# ─── Config ─────────────────────────────────────────────────────────────────────
SF_OPTS = {
    "user":      "reach2zeeshan",
    "password":  "Learning@143143",
    "account":   "DTVABHB-AE51151",
    "warehouse": "COMPUTE_WH",
    "database":  "DB_CLINICAL_TRIALS_GOV",
    "schema":    "SH_CLINICAL_TRIALS_GOV_RAW",
}
TABLE_NAME = "RAW_CTGOV__STUDIES"
API_URL    = "https://clinicaltrials.gov/api/v2/studies"
PAGE_SIZE  = 100
#FILTER     = (
 #   "(AREA[StudyFirstSubmitDate]RANGE[01/01/2015, MAX] AND INTERVENTIONAL AND (AREA[Phase]EXPANSION[None]\"Phase 2\" OR AREA[Phase]EXPANSION[None]\"Phase 3\"))"
#)

FILTER     = (
   "(AREA[StudyFirstSubmitDate]RANGE[01/01/2015, MAX] AND INTERVENTIONAL AND (AREA[Phase]EXPANSION[None]\"Phase 3\") )"
)
 

#"AND SEARCH[phases](AREA[phases]\"Phase 2\"  AREA[phases]\"Phase 3\")"

# ─── Fetch all studies ──────────────────────────────────────────────────────────
def fetch_all_studies():
    records, token = [], None
    params = {"format": "json", "pageSize": PAGE_SIZE, "query.cond": FILTER}

    while True:
        if token:
            params["pageToken"] = token
        r = requests.get(API_URL, params=params, timeout=30)
        r.raise_for_status()
        data = r.json()

        batch = data.get("studies", [])
        if not batch:
            break
        records.extend(batch)

        token = data.get("nextPageToken")
        if not token:
            break
        time.sleep(0.1)

    return records

# ─── Load all records in one bulk write ─────────────────────────────────────────
def load_to_snowflake(records):
    if not records:
        print("Loaded 0 records successfully.")
        return

    # Construct DataFrame with a single VARIANT column
    df = pd.DataFrame({"payload": records})

    conn = snowflake.connector.connect(**SF_OPTS)
    try:
        with conn.cursor() as cur:
        # 1) Clear out old data
            cur.execute(f"TRUNCATE TABLE {TABLE_NAME}")
        # 2) Bulk load new data
            success, nchunks, nrows, _ = write_pandas(
                conn,
                df,
                table_name=TABLE_NAME,
                database=SF_OPTS["database"],
                schema=SF_OPTS["schema"],
                chunk_size=len(df),          # one shot
                quote_identifiers=False
            )
            print(f"Loaded {nrows} records successfully.")
    finally:
        conn.close()

# ─── Main flow ───────────────────────────────────────────────────────────────────
def main():
    print("Fetching studies…")
    studies = fetch_all_studies()
    print(f"Total fetched: {len(studies)} records.")

    print("Loading into Snowflake…")
    load_to_snowflake(studies)

if __name__ == "__main__":
    main()
