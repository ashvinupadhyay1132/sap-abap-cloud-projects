# SAP RAP Dynamic Sales Pricing & Tax Engine

An enterprise Sales & Distribution (SD) Business Object implementation demonstrating **RAP Virtual Elements (`@ObjectModel.virtualElement`)** and **SADL Calculation Exit Classes (`if_sadl_exit_calc_element_read`)** in the SAP RESTful Application Programming Model (RAP) using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│       Service Exposure (ZSRV_SALES_PRICING - OData V4)      │
└──────────────────────────────┬──────────────────────────────┘
                               │ Exposes Entity with Virtual Elements
┌──────────────────────────────▼──────────────────────────────┐
│  CDS View Entity (ZCDS_I_SALES_PRICING)                     │
│   - Annotation: @ObjectModel.virtualElementCalculatedBy     │
│   - Virtual Fields: Discount_Amount, Net_Tax_Amount,        │
│                     Final_Gross_Price                       │
└──────────────────────────────┬──────────────────────────────┘
                               │ Triggers SADL Read Exit
┌──────────────────────────────▼──────────────────────────────┐
│  ABAP Exit Class (ZCL_CALC_SALES_PRICING)                   │
│   - Interface: if_sadl_exit_calc_element_read               │
│   - Method: calculate (Dynamic Discount & 18% GST Tax Math) │
└──────────────────────────────┬──────────────────────────────┘
                               │ Returns Calculated Fields to UI
┌──────────────────────────────▼──────────────────────────────┐
│        Fiori UI / OData Consumer Response                   │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

In enterprise Sales & Distribution (SD) systems, calculated pricing fields (`Discount_Amount`, `Net_Tax_Amount`, `Final_Gross_Price`) must not be stored in database tables to maintain 3NF database normalization and prevent data redundancy.

### Key Technical Features:
- **RAP Virtual Elements:** Annotates transient fields with `@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_CALC_SALES_PRICING'`.
- **SADL Exit Class:** Implements interface `if_sadl_exit_calc_element_read~calculate` for dynamic runtime math.
- **SADL Requested Info:** Implements `if_sadl_exit_calc_element_read~get_calculation_info` declaring dependent database fields (`Base_List_Price`, `Discount_Percentage`).
- **Automated ABAP Unit Tests:** Class `zcl_test_sales_pricing` tests pricing and tax calculations using `cl_abap_unit_assert`.

---

## File Structure

- `zcds_i_sales_pricing.acds`: Managed Root View Entity with Virtual Element annotations.
- `zbdef_sales_pricing.abapbdef`: Managed Behavior Definition.
- `zcl_calc_sales_pricing.abap`: ABAP Exit Class implementing `if_sadl_exit_calc_element_read`.
- `zcl_bp_sales_pricing.abap`: Behavior Pool class.
- `zsrv_sales_pricing.srvd`: Service Exposure definition for OData V4.
- `zcl_test_sales_pricing.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).
- `zcl_sales_pricing_runner.abap`: Executable test runner implementing `if_oo_adt_classrun`.

---

## Execution Output

Running `zcl_sales_pricing_runner` in Eclipse ADT (`F8`):

```text
========================================================================================
       SAP BTP RAP FRAMEWORK - SD SALES PRICING VIRTUAL ELEMENTS TEST RUNNER            
========================================================================================
[EML TEST 1]: Triggering Sales Order Creation (List Price = ₹5,00,000 INR, Discount = 15%)...
   [PASS]: Sales Order Created with ID: 00000001
----------------------------------------------------------------------------------------
[EML TEST 2]: Verifying SADL Exit Class Dynamic Calculations...
   -> Base List Price  : ₹500000 INR
   -> Discount (15%)   : ₹75000 INR
   -> Net Tax (18% GST): ₹76500 INR
   -> Final Gross Total: ₹501500 INR
========================================================================================
AUDIT SUMMARY: 100% RAP Virtual Elements Dynamic Calculation Execution Verified.
========================================================================================
```
