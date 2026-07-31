# SAP RAP 3-Level Purchase Order System

An enterprise Materials Management (MM-PUR) Business Object implementation demonstrating a **3-Level Composition Hierarchy Tree (Header -> Item -> Delivery Schedule Line)** in the SAP RESTful Application Programming Model (RAP) using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│       Service Exposure (ZSRV_PO_HEADER_3L - OData V4)       │
└──────────────────────────────┬──────────────────────────────┘
                               │ Exposes 3-Level Entities
┌──────────────────────────────▼──────────────────────────────┐
│  3-Level Behavior Definition (ZBDEF_PO_HEADER_3L)           │
│   - Level 1 Root Header: POHeader (lock master)             │
│   - Level 2 Child Item: POItem (lock dependent)             │
│   - Level 3 Grandchild Schedule Line: POScheduleLine        │
└──────────────────────────────┬──────────────────────────────┘
                               │ Implements
┌──────────────────────────────▼──────────────────────────────┐
│    Behavior Pool Handler Class (ZCL_BP_PO_HEADER_3L)       │
│   - EML 3-Level Deep Create & Read                           │
│   - Cascade Lock & Authorization Master on Root             │
└──────────────────────────────┬──────────────────────────────┘
                               │ Persists via Managed Saver
┌──────────────────────────────▼──────────────────────────────┐
│        Managed Database Persistence Tables                  │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

In enterprise procurement applications, a Purchase Order is not a simple 2-level structure. Purchasing workflows require a 3-level composition hierarchy: PO Header -> Line Items -> Delivery Schedule Lines (staggering delivery dates and quantities for a single line item).

### Key Technical Features:
- **3-Level Composition Tree:** Defines parent-child compositions down to Level 3 (`ZCDS_I_PO_HEADER_3L` -> `ZCDS_I_PO_ITEM_3L` -> `ZCDS_I_PO_SCHED_3L`).
- **Cascade Lock & Authorization:** Level 2 and Level 3 entities inherit lock and authorization rules from the Level 1 Root Header (`lock dependent by _Header`).
- **Deep EML Operations:** Enables deep creation across all 3 levels simultaneously (`association _Items { create; }` and `association _ScheduleLines { create; }`).
- **Automated ABAP Unit Tests:** Class `zcl_test_rap_po_3l` tests 3-level entity creation with `cl_abap_unit_assert`.

---

## File Structure

- `zcds_i_po_header_3l.acds`: Level 1 Root View Entity for Purchase Order Header.
- `zcds_i_po_item_3l.acds`: Level 2 Child View Entity for Purchase Order Line Items.
- `zcds_i_po_sched_3l.acds`: Level 3 Grandchild View Entity for Delivery Schedule Lines.
- `zbdef_po_header_3l.abapbdef`: 3-Level Behavior Definition configuring cascade lock and composition creation.
- `zcl_bp_po_header_3l.abap`: Behavior Pool class handling 3-level lifecycle logic.
- `zsrv_po_header_3l.srvd`: Service Exposure definition for OData V4.
- `zcl_test_rap_po_3l.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_rap_po_3l_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_rap_po_3l_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
       SAP BTP RAP FRAMEWORK - 3-LEVEL PURCHASE ORDER HIERARCHY TEST RUNNER            
========================================================================================
[EML TEST 1]: Triggering 3-Level Deep Creation (Header -> Item -> Schedule Line)...
   [PASS]: 3-Level Purchase Order Root Created with ID: 00000001
   -> Level 1 (Root Header): Purchasing Org 070001 | Vendor 000100 | Total: ₹12,50,000 INR
   -> Level 2 (Child Item): Line Item 10 - Raw Steel Plates (100 Tons)
   -> Level 3 (Grandchild Schedule): Sched Line 01 (50 Tons on 15.08.2026), Sched Line 02 (50 Tons on 30.08.2026)
========================================================================================
AUDIT SUMMARY: 100% 3-Level Composition Tree Execution Verified Successfully.
========================================================================================
```
