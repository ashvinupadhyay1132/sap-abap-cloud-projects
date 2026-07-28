# SAP RAP Managed Travel Application

A transactional Business Object implementation built on the SAP RESTful Application Programming Model (RAP) using ABAP Cloud standards.

---

## Architecture Overview

This project implements a managed RAP scenario with draft capabilities for Travel and Booking entities.

```
┌─────────────────────────────────────────────────────────────┐
│          Service Definition (ZSRV_TRAVEL_M)                 │
└──────────────────────────────┬──────────────────────────────┘
                               │ Exposes
┌──────────────────────────────▼──────────────────────────────┐
│       Behavior Definition (ZBDEF_TRAVEL_M - with draft)     │
│   - Draft Tables: ztravel_d, zbooking_d                     │
│   - Lock & Authorization Master                             │
│   - Actions: acceptTravel, rejectTravel                     │
│   - Validations: validateCustomer, validateDates            │
│   - Determination: calculateTotalPrice                      │
└──────────────────────────────┬──────────────────────────────┘
                               │ Implements
┌──────────────────────────────▼──────────────────────────────┐
│        Behavior Pool Handler Class (ZCL_BP_TRAVEL_M)        │
│   - EML: MODIFY ENTITIES OF zcds_i_travel_m IN LOCAL MODE   │
└──────────────────────────────┬──────────────────────────────┘
                               │ Queries
┌──────────────────────────────▼──────────────────────────────┐
│         CDS View Entities (ZCDS_I_TRAVEL_M / BOOKING_M)     │
└─────────────────────────────────────────────────────────────┘
```

---

## File Structure

- `zcds_i_travel_m.acds`: Root View Entity for Travel Header (includes composition to `_Booking`, ETag annotations, and master data associations).
- `zcds_i_booking_m.acds`: Child View Entity for Flight Bookings.
- `zbdef_travel_m.abapbdef`: Behavior Definition configuring draft actions (`Edit`, `Activate`, `Discard`), field control, validations, determinations, and custom actions.
- `zcl_bp_travel_m.abap`: Global Behavior Pool class implementing action handlers (`acceptTravel`, `rejectTravel`), validations (`validateCustomer`, `validateDates`), and determinations (`calculateTotalPrice`).
- `zsrv_travel_m.srvd`: Service Definition exposing entities for OData V4 consumption.
- `zcl_rap_test_runner.abap`: Executable test runner simulating EML operations (`MODIFY ENTITIES`).

---

## Execution Output

Running `zcl_rap_test_runner` in Eclipse ADT (`F8`) produces the following output:

```text
========================================================================================
             SAP BTP RAP FRAMEWORK - AUTOMATED EML AUDIT & INTEGRATION TEST            
========================================================================================
[EML TEST 1]: Triggering RAP Entity Creation (ZCDS_I_TRAVEL_M)...
   -> Draft Created for Travel ID : 00004001
   -> Agency: 070001 | Customer: 000592
   -> Dates: 25.07.2026 to 01.08.2026
----------------------------------------------------------------------------------------
[EML TEST 2]: Executing RAP Validations (validateCustomer & validateDates)...
   [PASS]: validateCustomer - Customer ID 000592 is Valid.
   [PASS]: validateDates    - Begin Date < End Date is Valid.
----------------------------------------------------------------------------------------
[EML TEST 3]: Executing RAP Determination (calculateTotalPrice)...
   -> Booking Fee  : ₹120
   -> Total Price  : ₹620 (Auto-calculated via Determination)
----------------------------------------------------------------------------------------
[EML TEST 4]: Executing RAP Action (acceptTravel)...
   -> Action Result: Travel Request 00004001 Status updated to 'APPROVED' (A)
   -> EML State: Transaction Committed to SAP HANA Database via RAP Save Sequence.
========================================================================================
AUDIT RESULT: 100% RAP Business Object Verification Passed (0 Errors, 4 Checks Succeeded)
========================================================================================
```
