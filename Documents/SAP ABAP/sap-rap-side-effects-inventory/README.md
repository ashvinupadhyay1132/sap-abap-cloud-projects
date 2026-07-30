# SAP RAP Side Effects Inventory System

An enterprise Materials Management (MM) Business Object implementation demonstrating **UI Side Effects (`@Consumption.sideEffects`)** and **Dynamic Instance Feature Control** in the SAP RESTful Application Programming Model (RAP) using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│          Service Exposure (ZSRV_INVENTORY_M - OData V4)     │
└──────────────────────────────┬──────────────────────────────┘
                               │ Exposes Entities
┌──────────────────────────────▼──────────────────────────────┐
│  Behavior Definition (ZBDEF_INVENTORY_M - with side effects) │
│   - Annotations: @Consumption.sideEffects                   │
│   - Instance Feature Control: field ( features : instance )  │
│   - Action: reorderStock                                    │
│   - Determination: calculateStockStatus on modify           │
└──────────────────────────────┬──────────────────────────────┘
                               │ Implements
┌──────────────────────────────▼──────────────────────────────┐
│    Behavior Pool Handler Class (ZCL_BP_INVENTORY_M)         │
│   - Method: get_instance_features                           │
│   - Method: calculateStockStatus (Side Effects Target)      │
│   - Method: reorderStock (Action Handler)                   │
└──────────────────────────────┬──────────────────────────────┘
                               │ Recalculates Target Fields
┌──────────────────────────────▼──────────────────────────────┐
│        Fiori UI / ABAP Console Output Display               │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

In SAP S/4HANA Warehouse apps, updating material stock quantities on a Fiori UI must immediately trigger field recalculations (e.g. `Stock_Status`, `Reorder_Flag`) and dynamically enable or disable the `reorderStock` action without requiring a manual page refresh.

### Key Technical Features:
- **RAP UI Side Effects:** Uses `@Consumption.sideEffects` to declare target fields (`Stock_Status`, `Reorder_Flag`) calculated on modifying `Stock_Quantity`.
- **Dynamic Instance Feature Control:** Method `get_instance_features` dynamically enables `reorderStock` only when stock falls below critical threshold (`<= 10`).
- **RAP Determination:** `calculateStockStatus` evaluates critical vs optimal stock levels.
- **Automated ABAP Unit Tests:** Class `zcl_test_rap_side_effects` verifies stock determinations using `cl_abap_unit_assert`.

---

## File Structure

- `zcds_i_inventory_m.acds`: Managed Root CDS View Entity for Inventory Stock with Side Effects annotations.
- `zcds_i_stock_item_m.acds`: Managed Child CDS View Entity for Storage Bin items.
- `zbdef_inventory_m.abapbdef`: Behavior Definition configuring dynamic feature control, determinations, and actions.
- `zcl_bp_inventory_m.abap`: Behavior Pool class implementing instance feature control, action handler `reorderStock`, and determination `calculateStockStatus`.
- `zsrv_inventory_m.srvd`: Service Exposure definition for OData V4.
- `zcl_test_rap_side_effects.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_rap_inventory_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_rap_inventory_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
        SAP BTP RAP FRAMEWORK - SIDE EFFECTS & INSTANCE FEATURE CONTROL TEST RUNNER     
========================================================================================
[EML TEST 1]: Triggering Material Creation with Low Stock (Quantity = 5)...
   [PASS]: Inventory Material Created with ID: 00000001
----------------------------------------------------------------------------------------
[EML TEST 2]: Verifying Side Effects Target Fields (Stock_Status & Reorder_Flag)...
   -> Material    : Industrial High-Pressure Hydraulic Valve
   -> Stock Qty   : 5 units
   -> Stock Status: C (C = Critical Stock Alert)
   -> Reorder Flag: Y (Y = Reorder Action Enabled)
----------------------------------------------------------------------------------------
[EML TEST 3]: Executing Dynamic Action (reorderStock)...
   [PASS]: reorderStock Action Executed Successfully. Replenishment Order Created.
========================================================================================
AUDIT SUMMARY: 100% RAP Side Effects & Dynamic Feature Control Verification Passed.
========================================================================================
```
