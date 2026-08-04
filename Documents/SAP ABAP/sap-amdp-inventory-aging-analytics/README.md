# SAP AMDP EWM Inventory Stock Aging & Analytics Engine

An enterprise Extended Warehouse Management (EWM) database procedure implementation demonstrating **AMDP Common Table Expressions (CTEs)** and **SQLScript Dynamic Stock Aging Buckets** in SAP S/4HANA using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│          ABAP Application Layer Execution Runner            │
└──────────────────────────────┬──────────────────────────────┘
                               │ Invokes AMDP Procedure
┌──────────────────────────────▼──────────────────────────────┐
│  AMDP ABAP Class (ZCL_AMDP_STOCK_AGING)                      │
│   - Interface: if_amdp_marker_hdb                           │
│   - Method: get_inventory_aging_analytics                   │
└──────────────────────────────┬──────────────────────────────┘
                               │ Pushes CTE Computation to HANA DB
┌──────────────────────────────▼──────────────────────────────┐
│  SAP HANA In-Memory Database Engine                         │
│   - Executes CTEs (WITH cte_stock_raw AS ...)               │
│   - Computes DAYS_BETWEEN movement date & current date      │
│   - Classifies Aging Buckets (FAST_MOVING, SLOW_MOVING)     │
└──────────────────────────────┬──────────────────────────────┘
                               │ Returns Aged Stock Result Set
┌──────────────────────────────▼──────────────────────────────┐
│        ABAP Internal Table Output Display                   │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

In Extended Warehouse Management (EWM), identifying slow-moving inventory and dead stock across thousands of storage bins requires dynamic date math (`DAYS_BETWEEN`) and SQLScript CTE clauses executed in-memory.

### Key Technical Features:
- **HANA SQLScript CTEs:** Uses `WITH cte_stock_raw AS (...)` for temporary result set staging in HANA memory.
- **Dynamic Aging Math:** Uses `DAYS_BETWEEN(movement_date, CURRENT_DATE)` to classify stock into `FAST_MOVING_0_30`, `SLOW_MOVING_31_90`, and `DEAD_STOCK_OVER_90`.
- **Automated ABAP Unit Tests:** Class `zcl_test_amdp_stock` verifies procedure interface parameters using `cl_abap_unit_assert`.

---

## File Structure

- `zcl_amdp_stock_aging.abap`: AMDP Class implementing HANA SQLScript stock aging procedure.
- `zcl_test_amdp_stock.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_amdp_stock_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_amdp_stock_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
       SAP HANA DB - AMDP EWM INVENTORY STOCK AGING ANALYTICS RUNNER                   
========================================================================================
[AMDP TEST 1]: Executing HANA SQLScript Procedure with CTEs (get_inventory_aging_analytics)...
   [PASS]: AMDP SQLScript Stock Aging Procedure Executed Successfully.
   -> Plant: 070001 | Records Fetched: 8
========================================================================================
AUDIT SUMMARY: 100% AMDP Stock Aging Execution Verified.
========================================================================================
```
