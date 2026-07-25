# 🚀 SAP BTP RAP Managed Travel App (`sap-rap-managed-travel-app`)

Industry-grade SAP RESTful Application Programming Model (RAP) application built using Clean Core Principles for **SAP BTP ABAP Environment** and **SAP S/4HANA Cloud**.

---

## 📌 Business Requirement (Functional Spec)
- **Domain:** Travel & Transport Management
- **Problem Statement:** A travel agency requires an enterprise business application to manage travel bookings. The system must support draft capabilities (so users don't lose data mid-entry), validate customer IDs and trip dates prior to saving, dynamically calculate total price including booking fees, and allow agency managers to **Accept** or **Reject** travel requests.

---

## 📥 Inputs & 📤 Outputs

### Inputs:
- `Customer_ID` (Mandatory, e.g., `'000592'`)
- `Agency_ID` (Mandatory, e.g., `'070001'`)
- `Begin_Date` & `End_Date` (Trip Duration)
- `Booking_Fee` (e.g., `120.00 EUR`)

### Outputs:
- **Status:** `'A'` (Approved) / `'X'` (Rejected) / `'O'` (Open)
- **Total Price:** Automatically calculated via determination (`Total_Price = Booking_Fee + Flight_Prices`)
- **OData V4 Payload:** JSON Service Endpoint exposed for SAP Fiori Elements UI.

---

## 🗄️ Database Tables & Data Model Architecture

```
         ┌───────────────────────────────────────────────────────────┐
         │          ZCDS_I_TRAVEL_M (Root View Entity)               │
         │  Keys: travel_id                                          │
         │  Fields: agency_id, customer_id, dates, total_price, etc. │
         └─────────────────────────────┬─────────────────────────────┘
                                       │ 1..* Composition
         ┌─────────────────────────────▼─────────────────────────────┐
         │         ZCDS_I_BOOKING_M (Child View Entity)              │
         │  Keys: travel_id, booking_id                              │
         │  Fields: flight_date, carrier_id, flight_price, etc.      │
         └───────────────────────────────────────────────────────────┘
```

---

## 📄 Component Manifest

| Object Name | Object Type | Business Purpose |
| :--- | :--- | :--- |
| [`zcds_i_travel_m.acds`](./zcds_i_travel_m.acds) | CDS Root View | Travel Header entity with ETag, search annotations, composition. |
| [`zcds_i_booking_m.acds`](./zcds_i_booking_m.acds) | CDS Child View | Flight Booking item entity composed with Travel Header. |
| [`zbdef_travel_m.abapbdef`](./zbdef_travel_m.abapbdef) | Behavior Definition | Defines Drafts, Lock Master, ETag, Actions, Validations & Determinations. |
| [`zcl_bp_travel_m.abap`](./zcl_bp_travel_m.abap) | Behavior Pool | Global ABAP Handler implementing EML logic (`MODIFY ENTITIES IN LOCAL MODE`). |
| [`zsrv_travel_m.srvd`](./zsrv_travel_m.srvd) | Service Definition | OData V4 Service Exposure. |
| [`zcl_rap_test_runner.abap`](./zcl_rap_test_runner.abap) | Test Runner Class | Executable EML Audit Runner simulating transactional lifecycle. |

---

## 🖥️ Automated EML Audit Execution Output Log

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
