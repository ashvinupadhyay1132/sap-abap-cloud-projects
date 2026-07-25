# 📊 SAP ABAP Cloud Open SQL Foundation (`sap-abap-open-sql-foundation`)

Production-style Open SQL demonstration report built for **SAP BTP ABAP Cloud Environment**.

---

## 📌 Business Requirement (Functional Spec)
- **Domain:** Data Analysis & Master Data Audit
- **Problem Statement:** A business analyst needs a consolidated Material / Travel analysis report. The report must validate inputs (`Agency ID` / `Plant` and `Currency` / `Material Type`), count matching entries without loading unnecessary memory, fetch detailed rows via INNER JOIN & LEFT OUTER JOIN (displaying Customer/Master names), group records using Aggregate functions (`COUNT`, `AVG`, `MAX`, `MIN`), filter aggregated groups with `HAVING`, and display a unique list of currencies using `SELECT DISTINCT`.

---

## 📥 Inputs & 📤 Outputs

### Inputs:
- `p_agency_id` (Simulated Plant/Agency parameter, e.g. `'070001'`)
- `p_currency` (Simulated Material Type/Currency parameter, e.g. `'EUR'`)

### Outputs:
- **Validation Message:** Result of `SELECT SINGLE` checking if Agency exists.
- **Record Count:** Integer count returned from `COUNT(*)`.
- **Detail Report:** Joined table display (Travel ID, Customer ID, Customer Name, Price, Currency).
- **Summary Report:** Aggregated table display (`Agency_ID`, `Travel_Count`, `Avg_Price`, `Max_Price`, `Min_Price`).
- **Unique List:** Distinct list of currencies (`EUR`, `JPY`, `USD`, etc.).

---

## 🗄️ Database Tables & Open SQL Feature Matrix

| Open SQL Feature | Database Tables Joined | Purpose |
| :--- | :--- | :--- |
| `SELECT SINGLE` | `/dmo/agency` | Validate agency existence in single DB fetch. |
| `COUNT(*)` | `/dmo/travel` INNER JOIN `/dmo/booking` | Fast database-side record counting. |
| `INNER JOIN` | `/dmo/travel` & `/dmo/booking` | Enforce header-item relational integrity. |
| `LEFT OUTER JOIN` | `/dmo/customer` | Optional description fetch (preserves row if customer name missing). |
| `GROUP BY & HAVING` | `/dmo/travel` | Group metrics by agency, filter groups where count > 0. |
| `SELECT DISTINCT` | `/dmo/travel` | Deduplicate and extract unique currency codes. |

---

## 📄 Component Manifest

| Object Name | Object Type | Business Purpose |
| :--- | :--- | :--- |
| [`zcl_open_sql.abap`](./zcl_open_sql.abap) | ABAP Cloud Class | Executable report implementing `if_oo_adt_classrun` with full Open SQL demonstration. |

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
