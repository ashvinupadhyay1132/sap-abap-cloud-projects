# SAP RAP Managed Travel Application

A transactional Business Object implementation built on the SAP RESTful Application Programming Model (RAP) using ABAP Cloud standards.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│          Service Exposure (ZSRV_TRAVEL_M - OData V4)        │
└──────────────────────────────┬──────────────────────────────┘
                               │ Exposes
┌──────────────────────────────▼──────────────────────────────┐
│       Behavior Definition (ZBDEF_TRAVEL_M - with draft)     │
│   - Draft Tables: ztravel_d, zbooking_d                     │
│   - Actions: acceptTravel, rejectTravel                     │
│   - Validations: validateCustomer, validateDates            │
│   - Determination: calculateTotalPrice                      │
└──────────────────────────────┬──────────────────────────────┘
                               │ Implements
┌──────────────────────────────▼──────────────────────────────┐
│       Behavior Pool Handler Class (ZCL_BP_TRAVEL_M)         │
│   - EML: MODIFY ENTITIES OF zcds_i_travel_m IN LOCAL MODE   │
└──────────────────────────────┬──────────────────────────────┘
                               │ Reads/Modifies
┌──────────────────────────────▼──────────────────────────────┐
│         CDS View Entities (ZCDS_I_TRAVEL_M / BOOKING_M)     │
└─────────────────────────────────────────────────────────────┘
```

---

## Technical Overview

This project implements a managed RAP scenario with draft capabilities for Travel and Booking entities.

### Key Features Applied:
- **Managed Persistence:** Automatic CREATE, UPDATE, DELETE handled by the RAP framework.
- **Draft Handling:** Transactional draft tables (`ztravel_d`, `zbooking_d`) allowing multi-step editing without locking real DB tables.
- **Custom Actions:** `acceptTravel` and `rejectTravel` triggered via EML (`MODIFY ENTITIES`).
- **Automated ABAP Unit Tests:** Class `zcl_test_rap_travel` verifies RAP validations and date sequencing.

---

## File Structure

- `zcds_i_travel_m.acds`: Root View Entity for Travel Header.
- `zcds_i_booking_m.acds`: Child View Entity for Flight Bookings.
- `zbdef_travel_m.abapbdef`: Behavior Definition configuring draft actions (`Edit`, `Activate`, `Discard`), validations, determinations, and custom actions.
- `zcl_bp_travel_m.abap`: Global Behavior Pool class implementing action handlers and validations.
- `zsrv_travel_m.srvd`: Service Definition exposing entities for OData V4 consumption.
- `zcl_rap_test_runner.abap`: Executable test runner simulating EML operations (`MODIFY ENTITIES`).
- `zcl_test_rap_travel.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).

---

## How to Answer in MNC Technical Interviews

### Q1: What is the difference between Managed RAP and Unmanaged RAP?
**Senior Answer:** In **Managed RAP**, the RAP framework automatically handles the Standard Create, Update, and Delete operations to the database persistence table. In **Unmanaged RAP**, the developer must manually code the CRUD lifecycle operations inside the Behavior Pool (ABAP handler class), which is mandatory when wrapping existing BAPIs or legacy function modules.

### Q2: What is the purpose of `IN LOCAL MODE` in Entity Manipulation Language (EML)?
**Senior Answer:** Using `IN LOCAL MODE` inside a RAP Behavior Pool bypasses feature control and authorization checks. It allows internal framework code (such as Determinations or Actions) to modify draft/active instances without triggering infinite validation loops or failing user privilege checks.

---

## Execution Output

Running `zcl_rap_test_runner` in Eclipse ADT (`F8`):

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
