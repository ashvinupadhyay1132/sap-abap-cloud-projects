# SAP AMDP Financial Analytics Engine

Implements database code pushdown for financial profitability calculations using ABAP Managed Database Procedures (AMDP) and native SAP HANA SQLScript.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                 ABAP Application Layer                      │
│        ZCL_AMDP_RUNNER / Unit Test ZCL_TEST_AMDP_ANALYTICS  │
└──────────────────────────────┬──────────────────────────────┘
                               │ Passes ITAB :it_postings
┌──────────────────────────────▼──────────────────────────────┐
│             SAP HANA Database Engine Kernel                 │
│    ZCL_AMDP_FINANCIAL_ANALYTICS=>get_financial_revenue_analytics
│                                                             │
│  1. SQLScript Aggregation: SUM(revenue), SUM(cogs)          │
│  2. SQLScript Window Function: RANK() OVER (ORDER BY rev)   │
│  3. SQLScript Expression: CASE WHEN Net_Profit >= 50000     │
└──────────────────────────────┬──────────────────────────────┘
                               │ Returns ETAB :et_analytics
┌──────────────────────────────▼──────────────────────────────┐
│                ABAP Console / TDD Assertions                │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

When calculating profit margins and ranking high-volume financial transactions across multiple company codes and divisions, processing data inside ABAP `LOOP` statements causes performance bottlenecks. 

This project shifts all calculations directly into the SAP HANA Database kernel using AMDP.

### Key Technical Concepts:
- **AMDP Interface:** Class `zcl_amdp_financial_analytics` implements `if_amdp_marker_hdb`.
- **HANA SQLScript:** Method `get_financial_revenue_analytics` is defined as `BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY`.
- **Window Functions:** Uses `RANK() OVER (ORDER BY total_revenue DESC)` inside SQLScript to rank business divisions by revenue.
- **Automated ABAP Unit Tests:** Class `zcl_test_amdp_analytics` verifies calculations using `cl_abap_unit_assert`.

---

## File Structure

- `zcl_amdp_financial_analytics.abap`: Core AMDP class containing interface definition, types, and SQLScript procedure.
- `zcl_amdp_runner.abap`: Test runner class implementing `if_oo_adt_classrun` to populate sample financial data, invoke the procedure, and print output logs.
- `zcl_test_amdp_analytics.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).

---

## Execution Output

Running `zcl_amdp_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
       SAP FI-CO MODULE - AMDP FINANCIAL ANALYTICS ENGINE (HANA SQLSCRIPT PUSHDOWN)     
========================================================================================
[INPUT]: Instantiated 5 Financial Postings across Company Codes 1000 & 2000.
----------------------------------------------------------------------------------------
[EML EXECUTION]: Invoking AMDP Method (HANA DB Engine SQLScript Pushdown)...
   [PASS]: HANA SQLScript Execution Completed Successfully.
----------------------------------------------------------------------------------------
                       FINANCIAL PROFITABILITY & RANKING REPORT                         
----------------------------------------------------------------------------------------
Rank #1 CoCode: 1000 Division: CLOUD_SERVICES    Revenue: ₹   750000 COGS: ₹  270000 Net Profit: ₹  385000 Margin: 51.33% Status: HIGH MARGIN
Rank #2 CoCode: 2000 Division: CONSULTING        Revenue: ₹   600000 COGS: ₹  200000 Net Profit: ₹  320000 Margin: 53.33% Status: HIGH MARGIN
Rank #3 CoCode: 1000 Division: HARDWARE_SALES    Revenue: ₹   180000 COGS: ₹  110000 Net Profit: ₹   45000 Margin: 25.00% Status: MODERATE MARGIN
Rank #4 CoCode: 2000 Division: SUPPORT_SERVICES  Revenue: ₹    90000 COGS: ₹   55000 Net Profit: ₹   15000 Margin: 16.67% Status: LOW MARGIN / LOSS
========================================================================================
AUDIT SUMMARY: 100% AMDP HANA SQLScript Financial Analytics Execution Verified.
========================================================================================
```
