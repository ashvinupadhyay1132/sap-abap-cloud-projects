# SAP AMDP Financial Analytics Engine

Implements database code pushdown for financial profitability calculations using ABAP Managed Database Procedures (AMDP) and native SAP HANA SQLScript.

---

## Technical Overview

When calculating profit margins and ranking high-volume financial transactions across multiple company codes and divisions, processing data inside ABAP `LOOP` statements causes performance bottlenecks. 

This project shifts all calculations directly into the SAP HANA Database kernel using AMDP.

### Key Technical Concepts:
- **AMDP Interface:** Class `zcl_amdp_financial_analytics` implements `if_amdp_marker_hdb`.
- **HANA SQLScript:** Method `get_financial_revenue_analytics` is defined as `BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY`.
- **Window Functions:** Uses `RANK() OVER (ORDER BY total_revenue DESC)` inside SQLScript to rank business divisions by revenue.
- **SQLScript Expressions:** Evaluates profit margins (`Revenue - COGS - OPEX`) and maps status categories (`HIGH MARGIN`, `MODERATE MARGIN`, `LOW MARGIN / LOSS`) directly in database memory.

---

## File Structure

- `zcl_amdp_financial_analytics.abap`: Core AMDP class containing interface definition, types, and SQLScript procedure.
- `zcl_amdp_runner.abap`: Test runner class implementing `if_oo_adt_classrun` to populate sample financial data, invoke the procedure, and print the output log.

---

## Data Schema & Structures

```abap
TYPES: BEGIN OF ty_financial_posting,
         company_code TYPE string,
         division     TYPE string,
         fiscal_year  TYPE string,
         posting_date TYPE dats,
         revenue      TYPE decfloat34,
         cogs         TYPE decfloat34,
         opex         TYPE decfloat34,
         currency     TYPE string,
       END OF ty_financial_posting.

TYPES: BEGIN OF ty_financial_analytics,
         company_code  TYPE string,
         division      TYPE string,
         total_revenue TYPE decfloat34,
         total_cogs    TYPE decfloat34,
         total_opex    TYPE decfloat34,
         gross_profit  TYPE decfloat34,
         net_profit    TYPE decfloat34,
         margin_pct    TYPE decfloat34,
         margin_status TYPE string,
         revenue_rank  TYPE i,
         currency      TYPE string,
       END OF ty_financial_analytics.
```

---

## Execution Output

Running `zcl_amdp_runner` in Eclipse ADT (`F8`) produces the following console output:

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
