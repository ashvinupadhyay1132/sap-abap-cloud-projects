# SAP RAP Custom Numbering Invoice System

An enterprise billing Business Object implementation demonstrating **Early Custom Numbering** in the SAP RESTful Application Programming Model (RAP) using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│          Service Exposure (ZSRV_INVOICE_H - OData V4)       │
└──────────────────────────────┬──────────────────────────────┘
                               │ Exposes Entities
┌──────────────────────────────▼──────────────────────────────┐
│       Behavior Definition (ZBDEF_INVOICE_H - early numbering)│
│   - Persistent Table: /dmo/travel                           │
│   - Key Definition: Invoice_ID (readonly, early numbering)  │
└──────────────────────────────┬──────────────────────────────┘
                               │ Triggers FOR NUMBERING
┌──────────────────────────────▼──────────────────────────────┐
│        Behavior Pool Handler Class (ZCL_BP_INVOICE_H)       │
│   - Method: earlynumbering_create FOR NUMBERING             │
│   - Integrates cl_number_range API / Custom Sequence Engine │
└──────────────────────────────┬──────────────────────────────┘
                               │ Returns Mapped Key (INV-2026-00000001)
┌──────────────────────────────▼──────────────────────────────┐
│              RAP Persistence & Database Save                │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

In multinational billing systems (FI-SD Module), standard sequential primary keys are rejected by tax compliance authorities. Invoices require custom formatted document numbers (e.g. `INV-2026-00000001`) with fiscal year prefixes generated dynamically before the instance is saved to the database.

### Key Technical Features:
- **RAP Early Numbering:** Declares `early numbering` in the Behavior Definition to handle key generation in memory.
- **Number Range Integration:** Integrates key generation rules within `earlynumbering_create FOR NUMBERING`.
- **Managed Persistence:** Automatic save sequence to database table `/dmo/travel`.
- **Automated ABAP Unit Tests:** Class `zcl_test_rap_invoice_num` tests EML entity creation with early custom key generation.

---

## File Structure

- `zcds_i_invoice_h.acds`: Managed CDS Root View Entity for Invoice Header.
- `zcds_i_invoice_i.acds`: Managed CDS Child View Entity for Invoice Line Items.
- `zbdef_invoice_h.abapbdef`: Behavior Definition configuring `early numbering` for `create`.
- `zcl_bp_invoice_h.abap`: Behavior Pool class implementing early numbering method `earlynumbering_create`.
- `zsrv_invoice_h.srvd`: Service Exposure definition for OData V4.
- `zcl_test_rap_invoice_num.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_rap_invoice_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_rap_invoice_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
       SAP BTP RAP FRAMEWORK - EARLY CUSTOM NUMBERING INVOICE ENGINE TEST RUNNER       
========================================================================================
[EML TEST 1]: Triggering RAP Entity Creation (Early Custom Numbering)...
   [PASS]: Early Numbering Engine Generated Key: 00000001
   -> Company Code: 070001 | Customer: 000100 | Billed Amount: ₹850000 INR
========================================================================================
AUDIT SUMMARY: 100% RAP Early Custom Numbering Engine Execution Verified.
========================================================================================
```
