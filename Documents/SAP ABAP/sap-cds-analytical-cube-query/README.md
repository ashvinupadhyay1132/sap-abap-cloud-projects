# SAP S/4HANA Embedded Analytics CDS Cube & Query System

An enterprise Embedded Analytics implementation demonstrating **CDS Analytical Cubes (`@Analytics.dataCategory: #CUBE`)** and **CDS Analytical Queries (`@Analytics.query: true`)** in SAP S/4HANA using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│          SAP Fiori Multidimensional Analytical Reports      │
└──────────────────────────────┬──────────────────────────────┘
                               │ Reads Analytical Query
┌──────────────────────────────▼──────────────────────────────┐
│  CDS Analytical Query View (ZCDS_C_QUERY_SALES)             │
│   - Annotation: @Analytics.query: true                      │
└──────────────────────────────┬──────────────────────────────┘
                               │ Aggregates Dimension Data
┌──────────────────────────────▼──────────────────────────────┐
│  CDS Analytical Cube View (ZCDS_C_CUBE_SALES)               │
│   - Annotation: @Analytics.dataCategory: #CUBE              │
│   - Dimensions: Agency_ID, Customer_ID, Currency            │
│   - Measures: Total_Sales_Volume (@DefaultAggregation: #SUM)│
└──────────────────────────────┬──────────────────────────────┘
                               │ Pushes Aggregations to HANA DB
┌──────────────────────────────▼──────────────────────────────┐
│        SAP HANA In-Memory Database Engine                   │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

In SAP S/4HANA Embedded Analytics, operational business users require real-time multidimensional slicing and dicing (Pivoting, Aggregating, Summing) over live transactional data without extracting data out to external Data Warehouses (BW/4HANA).

### Key Technical Features:
- **CDS Analytical Cube:** Declares `@Analytics.dataCategory: #CUBE` defining dimensions (`@Analytics.dimension: true`) and measures (`@DefaultAggregation: #SUM`).
- **CDS Analytical Query:** Declares `@Analytics.query: true` defining multidimensional layouts for Fiori Analytical Apps.
- **Automated ABAP Unit Tests:** Class `zcl_test_cds_analytics` verifies analytical view data fetching using `cl_abap_unit_assert`.

---

## File Structure

- `zcds_c_cube_sales.acds`: CDS View Entity configured as Analytical Cube.
- `zcds_c_query_sales.acds`: CDS View Entity configured as Analytical Query.
- `zcl_test_cds_analytics.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_cds_analytics_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_cds_analytics_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
       SAP S/4HANA EMBEDDED ANALYTICS - CDS CUBE & QUERY TEST RUNNER                   
========================================================================================
[CDS TEST 1]: Reading CDS Analytical Cube (ZCDS_C_CUBE_SALES)...
   [PASS]: CDS Analytical Cube Execution Successful. Rows: 5
   -> Agency: 070001 | Customer: 000100 | Aggregated Volume: ₹1250000 INR
========================================================================================
AUDIT SUMMARY: 100% Embedded Analytics CDS Cube & Query Execution Verified.
========================================================================================
```
