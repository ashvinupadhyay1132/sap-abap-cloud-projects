# 📊 SAP ABAP Cloud Open SQL Foundation

This folder contains comprehensive Open SQL demonstration scripts written for **SAP BTP ABAP Cloud Environment**.

---

## 🛠️ Open SQL Concepts Demonstrated

- **`SELECT SINGLE`**: Master data record validation against BTP released entity `/dmo/agency`.
- **`COUNT(*)`**: Fast record counting across joined tables.
- **`INNER JOIN` & `LEFT OUTER JOIN`**: Joining Header (`/dmo/travel`), Item (`/dmo/booking`), and Master Description (`/dmo/customer`).
- **Aggregate Functions**: `COUNT`, `AVG`, `MAX`, `MIN` grouped by Agency.
- **`GROUP BY` & `HAVING`**: Filtering grouped aggregate result sets.
- **`ORDER BY`**: Sorting results ascending / descending.
- **`SELECT DISTINCT`**: Extracting unique domain values.

---

## 📄 File Manifest

| File Name | Description |
| :--- | :--- |
| [`zcl_open_sql.abap`](./zcl_open_sql.abap) | Executable Open SQL Demonstration Class implementing `if_oo_adt_classrun`. |

---

## 🖥️ Execution Output Log (SAP BTP Cloud Trial)

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
