# SAP AMDP Consolidated General Ledger Financial Closing Engine

An enterprise Financial Accounting (FI) database procedure implementation demonstrating **ABAP Managed Database Procedures (AMDP)** and **HANA SQLScript Aggregations** in SAP S/4HANA using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│          ABAP Application Layer Execution Runner            │
└──────────────────────────────┬──────────────────────────────┘
                               │ Invokes Static Method
┌──────────────────────────────▼──────────────────────────────┐
│  AMDP ABAP Wrapper Class (ZCL_AMDP_GL_CLOSING)              │
│   - Interface: if_amdp_marker_hdb                           │
│   - Method: get_consolidated_gl_summary                     │
└──────────────────────────────┬──────────────────────────────┘
                               │ Pushes Execution Down to DB
┌──────────────────────────────▼──────────────────────────────┐
│  SAP HANA In-Memory Database Engine                         │
│   - Executes HANA SQLScript Aggregations (SUM, GROUP BY)    │
│   - Calculates Net Financial Balance in-memory              │
└──────────────────────────────┬──────────────────────────────┘
                               │ Returns Result Set to ABAP Layer
┌──────────────────────────────▼──────────────────────────────┐
│        ABAP Internal Table Output Display                   │
└──────────────────────────────┴──────────────────────────────┘
```

---

## Technical Overview

In enterprise Financial Accounting (FI), period-end financial closing across millions of General Ledger (GL) line items cannot be processed in the application layer without causing memory overhead and performance bottlenecks. **AMDP Code Pushdown** pushes financial balance aggregations directly into the SAP HANA in-memory database engine using native SQLScript.

### Key Technical Features:
- **AMDP Class Marker:** Implements interface `if_amdp_marker_hdb`.
- **HANA SQLScript Language:** Method declaration `BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY`.
- **In-Memory Balance Math:** Aggregates debits (`total_debit`), credits (`total_credit`), and evaluates net financial balances (`net_balance`).
- **Automated ABAP Unit Tests:** Class `zcl_test_amdp_gl` verifies SQLScript interface execution using `cl_abap_unit_assert`.

---

## File Structure

- `zcl_amdp_gl_closing.abap`: AMDP Class implementing HANA SQLScript financial closing procedure.
- `zcl_test_amdp_gl.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_amdp_gl_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_amdp_gl_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
       SAP HANA DB - AMDP CONSOLIDATED GENERAL LEDGER CLOSING TEST RUNNER               
========================================================================================
[AMDP TEST 1]: Executing HANA SQLScript Procedure (get_consolidated_gl_summary)...
   [PASS]: AMDP HANA SQLScript Procedure Executed Successfully.
   -> Company Code: 070001 | Records Fetched: 12
========================================================================================
AUDIT SUMMARY: 100% AMDP SQLScript General Ledger Closing Execution Verified.
========================================================================================
```
