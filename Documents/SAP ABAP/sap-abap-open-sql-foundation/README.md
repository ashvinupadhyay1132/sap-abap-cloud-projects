# ABAP Cloud Open SQL Foundation

Demonstrates Open SQL query patterns in ABAP Cloud using released SAP BTP entities (`/dmo/travel`, `/dmo/booking`, `/dmo/customer`, `/dmo/agency`).

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                 ABAP Application Layer                      │
│        ZCL_OPEN_SQL / Unit Test ZCL_TEST_OPEN_SQL           │
└──────────────────────────────┬──────────────────────────────┘
                               │ Open SQL Queries
┌──────────────────────────────▼──────────────────────────────┐
│             SAP HANA Database Released Entities             │
│        /dmo/travel, /dmo/booking, /dmo/customer             │
│                                                             │
│  1. SELECT SINGLE: Validate agency_id existence             │
│  2. COUNT(*): Database-side record counting                 │
│  3. INNER JOIN & LEFT OUTER JOIN: Relational data           │
│  4. GROUP BY & HAVING: Aggregate pricing metrics            │
└──────────────────────────────┬──────────────────────────────┘
                               │ Result Sets
┌──────────────────────────────▼──────────────────────────────┐
│           ABAP Console Log / Unit Test Assertions           │
└─────────────────────────────────────────────────────────────┘
```

---

## Open SQL Patterns Covered

- **`SELECT SINGLE`:** Fetching a single record to validate agency existence.
- **`COUNT(*)`:** Counting rows directly at database level.
- **`INNER JOIN` & `LEFT OUTER JOIN`:** Joining relational tables while handling optional text descriptions.
- **`GROUP BY` & `HAVING`:** Grouping data and applying aggregate conditions (`COUNT`, `AVG`, `MAX`, `MIN`).
- **`SELECT DISTINCT`:** Fetching deduplicated currency lists.
- **Automated ABAP Unit Tests:** Class `zcl_test_open_sql` verifies master data presence.

---

## File Structure

- `zcl_open_sql.abap`: Class implementing `if_oo_adt_classrun` with all Open SQL queries and output formatting.
- `zcl_test_open_sql.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).

---

## Execution Output

Running `zcl_open_sql` in Eclipse ADT (`F8`):

```text
========================================================================================
          SAP BTP CLOUD - OPEN SQL DEMONSTRATION REPORT (MAPPED FOR BTP TRIAL)
========================================================================================
[VALIDATION OK]: Found Agency Sunshine Travel in City: Rochester
[COUNT RESULT]: Found 77 matching travel records.
----------------------------------------------------------------------------------------
                         DETAIL REPORT (JOINS & SELECTION)
----------------------------------------------------------------------------------------
Travel ID    : 00000104   Customer ID  : 000440   Customer Name: Chantal Gahl         Price        :  1597.00 EUR
Travel ID    : 00000120   Customer ID  : 000100   Customer Name: Ruth Detemple        Price        :  3304.50 EUR
----------------------------------------------------------------------------------------
                 SUMMARY REPORT (GROUP BY, COUNT, AVG, MAX, MIN, HAVING)
----------------------------------------------------------------------------------------
Agency ID    : 070042   Travel Count : 47   Avg Price    : 7524.18 EUR Max Price    :   28638.00 EUR Min Price    :    1569.50 EUR
========================================================================================
```
