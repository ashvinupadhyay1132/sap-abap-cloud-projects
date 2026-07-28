# SAP RAP Unmanaged Sales Order Application

An enterprise transactional Business Object implementation built on the SAP RESTful Application Programming Model (RAP) using the **Unmanaged Implementation Pattern** in ABAP Cloud.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│          Service Exposure (ZSRV_SALES_ORDER_U - OData V4)   │
└──────────────────────────────┬──────────────────────────────┘
                               │ Exposes Entities
┌──────────────────────────────▼──────────────────────────────┐
│  Unmanaged Behavior Definition (ZBDEF_SALES_ORDER_U)        │
│   - Lock Master: Sales_Order_ID                             │
│   - Unmanaged CRUD: create, update, delete                  │
└──────────────────────────────┬──────────────────────────────┘
                               │ Implements
┌──────────────────────────────▼──────────────────────────────┐
│    Unmanaged Behavior Pool Handler (ZCL_BP_SALES_ORDER_U)  │
│   - EML: CREATE / READ ENTITIES OF zcds_i_sales_order_u     │
│   - Custom Transactional Buffer: gt_so_buffer               │
│   - Unmanaged Save Sequence: lsc_ZCDS_I_SALES_ORDER_U       │
└──────────────────────────────┬──────────────────────────────┘
                               │ Persists via Custom Logic / BAPI
┌──────────────────────────────▼──────────────────────────────┐
│       Legacy Custom Persistence / Database Tables           │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

In enterprise S/4HANA migrations, existing SAP legacy systems often contain custom BAPIs or legacy function modules (e.g. `BAPI_SALESORDER_CREATEFROMDAT2`) and custom buffer tables. When standard RAP Managed persistence cannot be used due to custom transactional buffer rules, developers build an **Unmanaged RAP Application**.

### Key Technical Features:
- **Unmanaged Behavior Definition:** Declares `unmanaged implementation in class zcl_bp_sales_order_u unique`.
- **Custom Transactional Buffer:** Manages CRUD operations in memory via internal table `gt_so_buffer`.
- **Unmanaged Save Sequence:** Class `lsc_ZCDS_I_SALES_ORDER_U` inherits from `cl_abap_behavior_saver` to control the final DB commit phase (`save` / `cleanup`).
- **Automated ABAP Unit Tests:** Class `zcl_test_rap_unmanaged_so` tests EML `MODIFY` and `READ` operations using `cl_abap_unit_assert`.

---

## File Structure

- `zcds_i_sales_order_u.acds`: Unmanaged CDS Root View Entity for Sales Order Header.
- `zcds_i_sales_item_u.acds`: Unmanaged CDS Child View Entity for Sales Order Line Items.
- `zbdef_sales_order_u.abapbdef`: Behavior Definition configuring unmanaged CRUD operations.
- `zcl_bp_sales_order_u.abap`: Behavior Pool class implementing unmanaged `create`, `update`, `delete`, `read`, and saver sequence methods.
- `zsrv_sales_order_u.srvd`: Service Exposure definition for OData V4.
- `zcl_test_rap_unmanaged_so.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_rap_unmanaged_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_rap_unmanaged_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
         SAP BTP RAP FRAMEWORK - UNMANAGED SALES ORDER SCENARIO TEST RUNNER            
========================================================================================
[EML TEST 1]: Triggering Unmanaged CREATE for Sales Order...
   [PASS]: Unmanaged Sales Order Created with Generated Key: 90000101
----------------------------------------------------------------------------------------
[EML TEST 2]: Reading Unmanaged Sales Order from Custom Buffer...
   -> Order ID : 90000101
   -> Sales Org: 070001
   -> Customer : 000100
   -> Total Amt: ₹250000 INR
   -> Status   : O
========================================================================================
AUDIT SUMMARY: 100% Unmanaged RAP Scenario Execution Verified Successfully.
========================================================================================
```
