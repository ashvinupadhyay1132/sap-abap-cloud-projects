# Enterprise SAP BTP ABAP Cloud & RAP Framework Portfolio 🚀

Welcome to my **Enterprise-Grade SAP BTP ABAP Cloud & RESTful Application Programming (RAP)** portfolio repository. 

This repository showcases production-ready architecture designed for **SAP S/4HANA Cloud & SAP BTP Environment**, following MNC industry standards (Clean Core Architecture).

---

## 🏗️ Architecture & Frameworks Used

```
                         ┌─────────────────────────────────────────┐
                         │      SAP Fiori Elements / Web UI        │
                         └────────────────────┬────────────────────┘
                                              │ (OData V4)
                         ┌────────────────────▼────────────────────┐
                         │   Service Binding & Service Definition  │
                         │       (ZSRV_TRAVEL_M, OData V4)         │
                         └────────────────────┬────────────────────┘
                                              │
                         ┌────────────────────▼────────────────────┐
                         │      Behavior Definition (BDEF)         │
                         │    Validations | Actions | Drafts       │
                         └────────────────────┬────────────────────┘
                                              │
                         ┌────────────────────▼────────────────────┐
                         │     Core Data Services (CDS Views)      │
                         │    (ZCDS_I_TRAVEL_M, ZCDS_I_BOOKING_M)  │
                         └────────────────────┬────────────────────┘
                                              │
                         ┌────────────────────▼────────────────────┐
                         │         SAP HANA Database Tables        │
                         └─────────────────────────────────────────┘
```

---

## 📂 Enterprise Projects Included

### 1. SAP BTP RAP Framework — Enterprise Travel & Booking Management App
*Industry-grade Business Object built using RESTful Application Programming Model (RAP)*

- **Core Data Services (CDS View Entities):**
  - [`zcds_i_travel_m.acds`](./zcds_i_travel_m.acds) — Root View Entity for Travel Header with annotations, associations, and ETag control.
  - [`zcds_i_booking_m.acds`](./zcds_i_booking_m.acds) — Child View Entity for Flight Bookings.
- **Behavior Definition & Implementation (BDEF & ABAP Handler):**
  - [`zbdef_travel_m.abapbdef`](./zbdef_travel_m.abapbdef) — BDEF supporting Draft Handling, Actions (`acceptTravel`, `rejectTravel`), Validations (`validateCustomer`, `validateDates`), and Determinations (`calculateTotalPrice`).
  - [`zcl_bp_travel_m.abap`](./zcl_bp_travel_m.abap) — Global Behavior Pool class implementing EML (Entity Manipulation Language) handlers.
- **Service Exposure:**
  - [`zsrv_travel_m.srvd`](./zsrv_travel_m.srvd) — OData V4 Service Exposure definition.
- **Automated RAP EML Audit Runner:**
  - [`zcl_rap_test_runner.abap`](./zcl_rap_test_runner.abap) — Executable test runner executing EML statements and outputting transaction audit logs.

#### 🖥️ EML Audit Execution Output Log:
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

---

### 2. External Cloud REST/JSON API Consumer in ABAP Cloud
*Consuming Third-Party Services via ABAP Cloud HTTP Client*

- **File:** [`zcl_api_consumer.abap`](./zcl_api_consumer.abap)
- **Tech Stack:** `if_web_http_client`, `cl_http_destination_provider`, Exception Handling (`cx_web_http_client_error`), JSON Parsing.

#### 🖥️ HTTP Client Execution Output Log:
```text
========================================================================================
                   ENTERPRISE CLOUD REST API CONSUMER (HTTP CLIENT)                     
========================================================================================
Base Currency   : USD
Target Currency : INR
Exchange Rate   : 1 USD = 83.45 INR
Last Updated    : 25.07.2026
Status          : 200 OK (Connection Successful)
========================================================================================
```

---

### 3. Core OO-ABAP Modules & Business Calculators
- **[`zcl_order_processor.abap`](./zcl_order_processor.abap)** — Enterprise Sales Order Discount Engine with Type Inference (`DATA`, `VALUE`, `COND`, `CONV`).
- **[`zcl_hr_bonus_calc.abap`](./zcl_hr_bonus_calc.abap)** — HR Year-End Bonus Calculation Engine with nested rules.

---

## 👤 Author & Contact
- **Developer:** Ashvin Upadhyay (`ashvinupadhyay1132`)
- **Specialization:** SAP BTP ABAP Cloud / RAP Framework / CDS Data Modeling / Enterprise Integrations
