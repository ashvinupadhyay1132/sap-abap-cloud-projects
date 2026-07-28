# 🚀 Enterprise SAP BTP RAP Framework Application

This folder contains a complete **SAP BTP RESTful Application Programming Model (RAP)** Business Object following SAP Clean Core Architecture.

---

## 🏗️ Architecture & Framework Components

```
+-----------------------------------------------------------------------+
|                OData V4 Service Binding (ZSRV_TRAVEL_M)               |
+-----------------------------------------------------------------------+
                                    |
+-----------------------------------------------------------------------+
|               Behavior Definition (ZBDEF_TRAVEL_M)                    |
|       - Draft Handling (with draft)                                    |
|       - Validations (validateCustomer, validateDates)                  |
|       - Determinations (calculateTotalPrice)                           |
|       - Actions (acceptTravel, rejectTravel)                           |
+-----------------------------------------------------------------------+
                                    |
+-----------------------------------------------------------------------+
|              Behavior Pool Handler Class (ZCL_BP_TRAVEL_M)            |
|       - EML Statements (MODIFY ENTITIES IN LOCAL MODE)                |
+-----------------------------------------------------------------------+
                                    |
+-----------------------------------------------------------------------+
|             CDS View Entities (ZCDS_I_TRAVEL_M & ZCDS_I_BOOKING_M)   |
|       - Composition & Foreign Key Associations                        |
+-----------------------------------------------------------------------+
```

---

## 📄 File Manifest

| File Name | Object Type | Description |
| :--- | :--- | :--- |
| [`zcds_i_travel_m.acds`](./zcds_i_travel_m.acds) | CDS Root View Entity | Master Travel Header entity with ETag, annotations & associations. |
| [`zcds_i_booking_m.acds`](./zcds_i_booking_m.acds) | CDS Child View Entity | Flight Booking child entity composed with Travel Header. |
| [`zbdef_travel_m.abapbdef`](./zbdef_travel_m.abapbdef) | RAP Behavior Definition | BDEF rules for Drafts, Lock Master, ETag, Actions, Validations. |
| [`zcl_bp_travel_m.abap`](./zcl_bp_travel_m.abap) | Behavior Implementation | Global Behavior Pool class implementing EML action & validation logic. |
| [`zsrv_travel_m.srvd`](./zsrv_travel_m.srvd) | Service Definition | OData V4 Exposure for SAP Fiori Elements. |
| [`zcl_rap_test_runner.abap`](./zcl_rap_test_runner.abap) | ABAP Test Runner Class | Executable EML runner simulating draft creation, validation, & action execution. |

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
