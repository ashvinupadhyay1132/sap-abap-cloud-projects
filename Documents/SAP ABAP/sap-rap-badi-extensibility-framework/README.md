# SAP Clean Core BAdI Extensibility Framework

An enterprise Clean Core Extensibility implementation demonstrating **Business Add-Ins (BAdI)**, custom interface definitions (`zif_badi_order_calc`), and enhancement implementations (`zcl_badi_order_calc_impl`) in the SAP RESTful Application Programming Model (RAP) using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│          Service Exposure (ZSRV_EXT_ORDER - OData V4)       │
└──────────────────────────────┬──────────────────────────────┘
                               │ Exposes Extensible Entity
┌──────────────────────────────▼──────────────────────────────┐
│  Behavior Definition (ZBDEF_EXT_ORDER)                       │
│   - RAP Determination: applyBadiDiscount on modify          │
└──────────────────────────────┬──────────────────────────────┘
                               │ Triggers Determination
┌──────────────────────────────▼──────────────────────────────┐
│    Behavior Pool Handler Class (ZCL_BP_EXT_ORDER)           │
│   - Instantiates BAdI Interface (ZIF_BADI_ORDER_CALC)       │
└──────────────────────────────┬──────────────────────────────┘
                               │ Executes Enhancement
┌──────────────────────────────▼──────────────────────────────┐
│   BAdI Implementation Class (ZCL_BADI_ORDER_CALC_IMPL)     │
│   - Evaluates Customer VIP Status & Calculates Discounts    │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

In SAP S/4HANA Clean Core architecture, modifications to standard core SAP objects are strictly forbidden. Extensions must be built using side-by-side extensibility or **Clean Core In-App Extensibility** using BAdI Interfaces (`if_badi_interface`) to ensure zero-breakage upgrades.

### Key Technical Features:
- **Clean Core BAdI Interface:** Interface `zif_badi_order_calc` inheriting from `if_badi_interface`.
- **Enhancement Implementation:** Class `zcl_badi_order_calc_impl` implementing custom VIP discount rules.
- **RAP Determination Integration:** RAP determination `applyBadiDiscount` invokes the BAdI framework dynamically on entity modification.
- **Automated ABAP Unit Tests:** Class `zcl_test_badi_ext` verifies BAdI enhancement calculations using `cl_abap_unit_assert`.

---

## File Structure

- `zif_badi_order_calc.abap`: Clean Core BAdI Interface definition.
- `zcl_badi_order_calc_impl.abap`: BAdI Enhancement Implementation Class.
- `zcds_i_ext_order.acds`: Managed Root View Entity for Extensible Order.
- `zbdef_ext_order.abapbdef`: Managed Behavior Definition.
- `zcl_bp_ext_order.abap`: Behavior Pool class invoking the BAdI interface.
- `zsrv_ext_order.srvd`: Service Exposure definition for OData V4.
- `zcl_test_badi_ext.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_badi_ext_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_badi_ext_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
       SAP BTP CLEAN CORE - BADI EXTENSIBILITY FRAMEWORK TEST RUNNER                    
========================================================================================
[BADI TEST 1]: Executing BAdI Interface Enhancement (zif_badi_order_calc)...
   [PASS]: Customer 000100 (VIP) -> BAdI Applied Discount Rate: 12% | Amount: ₹30000 INR
   [PASS]: Customer 000300 (Standard) -> BAdI Applied Discount Rate: 5% | Amount: ₹12500 INR
========================================================================================
AUDIT SUMMARY: 100% Clean Core BAdI Extensibility Execution Verified.
========================================================================================
```
