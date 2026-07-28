# ABAP Cloud Open SQL Foundation

Demonstrates Open SQL query patterns in ABAP Cloud using released SAP BTP entities (`/dmo/travel`, `/dmo/booking`, `/dmo/customer`, `/dmo/agency`).

---

## Open SQL Patterns Covered

- **`SELECT SINGLE`:** Fetching a single record to validate agency existence.
- **`COUNT(*)`:** Counting rows directly at database level.
- **`INNER JOIN` & `LEFT OUTER JOIN`:** Joining relational tables while handling optional text descriptions.
- **`GROUP BY` & `HAVING`:** Grouping data and applying aggregate conditions.
- **Aggregate Functions:** `SUM`, `AVG`, `MAX`, `MIN`.
- **`SELECT DISTINCT`:** Fetching deduplicated currency lists.

---

## File Structure

- `zcl_open_sql.abap`: Class implementing `if_oo_adt_classrun` with all Open SQL queries and output formatting.

---

## Execution Output

Running `zcl_open_sql` in Eclipse ADT (`F8`) produces the following output:

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
...
----------------------------------------------------------------------------------------
                 SUMMARY REPORT (GROUP BY, COUNT, AVG, MAX, MIN, HAVING)
----------------------------------------------------------------------------------------
Agency ID    : 070042   Travel Count : 47   Avg Price    : 7524.18 EUR Max Price    :   28638.00 EUR Min Price    :    1569.50 EUR
Agency ID    : 070017   Travel Count : 45   Avg Price    : 7408.62 EUR Max Price    :   30076.50 EUR Min Price    :    1632.50 EUR
...
----------------------------------------------------------------------------------------
                 SELECT DISTINCT EXAMPLE (UNIQUE CURRENCIES IN BTP)
----------------------------------------------------------------------------------------
Currency Code: EUR
Currency Code: JPY
Currency Code: SGD
Currency Code: USD
========================================================================================
```
