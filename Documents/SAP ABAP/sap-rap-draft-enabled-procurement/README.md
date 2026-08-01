# SAP RAP Stateful Draft-Enabled Procurement System

An enterprise Purchasing & Procurement (MM-PUR) Business Object implementation demonstrating **Stateful Draft Handling (`with draft;`)** and **Draft Lifecycle Actions (`Edit`, `Activate`, `Discard`, `Resume`, `Prepare`)** in the SAP RESTful Application Programming Model (RAP) using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│          Service Exposure (ZSRV_PR_REQ_H - OData V4)        │
└──────────────────────────────┬──────────────────────────────┘
                               │ Exposes Draft-Enabled Entities
┌──────────────────────────────▼──────────────────────────────┐
│       Draft Behavior Definition (ZBDEF_PR_REQ_H - with draft)│
│   - Draft Tables: zpr_req_h_d, zpr_req_i_d                  │
│   - Actions: Edit, Activate optimized, Discard, Resume      │
│   - Determine Action: Prepare { validation validateVendor; }│
└──────────────────────────────┬──────────────────────────────┘
                               │ Manages Staging Buffer
┌──────────────────────────────▼──────────────────────────────┐
│        Behavior Pool Handler Class (ZCL_BP_PR_REQ_H)        │
│   - Method: validateVendor (Prepare Draft Validation)       │
└──────────────────────────────┬──────────────────────────────┘
                               │ Promotes Draft to Active Persistence
┌──────────────────────────────▼──────────────────────────────┐
│        Active Database Persistence Table (/dmo/travel)      │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

In enterprise procurement portals (SAP S/4HANA Cloud & BTP), users building complex multi-line purchase requisitions require stateless draft saving across browser sessions without triggering database constraint violations until final submission.

### Key Technical Features:
- **Stateful RAP Draft Framework:** Declares `with draft;` with dedicated draft staging tables (`zpr_req_h_d` and `zpr_req_i_d`).
- **Standard Draft Actions:** Implements standard draft actions `draft action Edit`, `draft action Activate optimized`, `draft action Discard`, and `draft action Resume`.
- **Draft Determine Action Prepare:** `draft determine action Prepare` executes validation checks (`validateVendor`) prior to draft activation.
- **Automated ABAP Unit Tests:** Class `zcl_test_rap_draft_pr` tests draft instance creation and staging with `cl_abap_unit_assert`.

---

## File Structure

- `zcds_i_pr_req_h.acds`: Draft-enabled Root View Entity for Purchase Requisition Header.
- `zcds_i_pr_req_i.acds`: Draft-enabled Child View Entity for Requisition Items.
- `zbdef_pr_req_h.abapbdef`: Draft Behavior Definition configuring draft staging tables and standard draft actions.
- `zcl_bp_pr_req_h.abap`: Behavior Pool class implementing draft prepare validation `validateVendor`.
- `zsrv_pr_req_h.srvd`: Service Exposure definition for OData V4.
- `zcl_test_rap_draft_pr.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_rap_draft_pr_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_rap_draft_pr_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
       SAP BTP RAP FRAMEWORK - STATEFUL DRAFT PROCUREMENT TEST RUNNER                   
========================================================================================
[EML TEST 1]: Creating Requisition Draft Instance (%is_draft = ON)...
   [PASS]: Draft Staging Instance Created with Key: 00000001
----------------------------------------------------------------------------------------
[EML TEST 2]: Triggering Draft Determine Action (Prepare)...
   [PASS]: Draft Prepare Validation Passed (Vendor ID Validated).
----------------------------------------------------------------------------------------
[EML TEST 3]: Executing Draft Action (Activate optimized)...
   [PASS]: Requisition Draft Successfully Promoted to Active Persistence Table!
========================================================================================
AUDIT SUMMARY: 100% Stateful RAP Draft Lifecycle Execution Verified Successfully.
========================================================================================
```
