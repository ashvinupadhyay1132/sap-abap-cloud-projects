# Purchase Requisition DDIC System

A Purchase Requisition (PR) data processing module built for SAP Materials Management (MM) concepts in ABAP Cloud. Focuses on Data Dictionary (DDIC) semantics, structures, domain value checks, and line-item aggregations.

---

## Technical Overview

The module handles procurement requisition structures with header and line-item relationships. It enforces data dictionary constraints, quantity/currency binding semantics, and memory-efficient internal table operations.

### Key Concepts Applied:
- **Domain Value Validation:** Validates `PR_Type` (`NB` = Standard, `FO` = Framework, `RV` = Outline Agreement) and `PR_Status` (`D` = Draft, `S` = Submitted, `A` = Approved, `R` = Rejected).
- **Semantics:** Binds numeric fields using `@Semantics.amount.currencyCode` and `@Semantics.quantity.unitOfMeasure`.
- **Deep Structures:** Uses `ty_pr_header_ddic` containing nested line items.
- **Secondary Keys:** Uses table type `tt_pr_items_ddic` with `NON-UNIQUE SORTED KEY item_key COMPONENTS pr_item_no`.
- **Field Symbols:** Modifies line-item rows in-place using `ASSIGNING FIELD-SYMBOL(<fs_item>)`.

---

## File Structure

- `zddic_pr_header.acds`: CDS Root View Entity for PR Header.
- `zddic_pr_item.acds`: CDS Child View Entity for PR Line Items.
- `zcl_pr_ddic_engine.abap`: Core engine class containing DDIC types, domain checks, and total price calculation.
- `zcl_pr_ddic_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_pr_ddic_runner` in Eclipse ADT (`F8`) produces the following output:

```text
========================================================================================
          SAP MM MODULE - PURCHASE REQUISITION DATA DICTIONARY (DDIC) ENGINE           
========================================================================================
----------------------------------------------------------------------------------------
PR Number : 10000891 | Plant : 1000 | Dept : IT Infrastructure | Created By : ASHVIN_U
   [DDIC VALIDATED]: PR Type 'NB' & Status 'S' Passed Data Dictionary Validation.
   Line Items:
     - Item 10: MAT-SERVER-01      Dell PowerEdge R750 Server     Qty:   2 ST  Price/Unit: ₹  250000 Total Item Val: ₹   500000 INR
     - Item 20: MAT-RAM-64GB       64GB DDR4 ECC RAM Module       Qty:   8 ST  Price/Unit: ₹   18000 Total Item Val: ₹   144000 INR
   -> Calculated Total Requisition Value : ₹644000 INR
----------------------------------------------------------------------------------------
PR Number : 10000892 | Plant : 2000 | Dept : Plant Operations | Created By : RIYA_S
   [DDIC DOMAIN ERROR]: PR Type 'INVALID_TYPE' is INVALID! Value Range must be NB, FO, or RV.
========================================================================================
SUMMARY: Purchase Requisition Data Dictionary Processing & Validation Completed.
========================================================================================
```
