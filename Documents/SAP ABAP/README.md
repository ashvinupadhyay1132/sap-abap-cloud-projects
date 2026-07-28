# SAP ABAP Cloud & BTP Enterprise Projects

A collection of production-style ABAP Cloud and BTP projects covering the RESTful Application Programming Model (RAP), ABAP Managed Database Procedures (AMDP), Core Data Services (CDS), Data Dictionary (DDIC), and REST API integrations.

All objects in this repository are written in **ABAP Language Version: ABAP Cloud (7.5+ / Steampunk)** and are compatible with **SAP BTP ABAP Environment** and **SAP S/4HANA Cloud**.

---

## Repository Index

| Project Directory | Focus Area | Key Technologies |
| :--- | :--- | :--- |
| [`sap-amdp-financial-analytics`](./sap-amdp-financial-analytics) | Database Code Pushdown | AMDP, HANA SQLScript, Window Functions (`RANK`), Aggregations |
| [`sap-ddic-purchase-requisition-system`](./sap-ddic-purchase-requisition-system) | Data Dictionary & Procurement | CDS View Entities, Currency/Quantity Semantics, Deep Structures, Table Types |
| [`sap-rap-managed-travel-app`](./sap-rap-managed-travel-app) | Business Object Architecture | SAP RAP Framework, Draft Handling, BDEF, EML, Validations, Actions |
| [`sap-abap-open-sql-foundation`](./sap-abap-open-sql-foundation) | Open SQL Data Fetching | Inner/Left Joins, `GROUP BY`, `HAVING`, Aggregate Functions, `SELECT DISTINCT` |
| [`sap-oo-abap-business-engines`](./sap-oo-abap-business-engines) | Core OO-ABAP Logic | Type Inference (`DATA`, `VALUE`, `COND`), Encapsulation, Reference Tables |
| [`sap-btp-http-rest-integration`](./sap-btp-http-rest-integration) | Cloud API Consumption | `cl_web_http_client_manager`, `cl_http_destination_provider`, JSON Parsing |

---

## Technical Overview

### 1. SAP AMDP Financial Analytics (`sap-amdp-financial-analytics`)
Implements database code pushdown for high-volume financial calculations. The core class `zcl_amdp_financial_analytics` implements `if_amdp_marker_hdb` and executes a native HANA SQLScript procedure to compute gross/net profit margins and rank business divisions via HANA window functions (`RANK() OVER`).

### 2. Purchase Requisition DDIC System (`sap-ddic-purchase-requisition-system`)
Modeled around SAP MM Procurement. Demonstrates Data Dictionary semantics (`@Semantics.amount.currencyCode`, `@Semantics.quantity.unitOfMeasure`), deep internal structures, secondary table keys (`NON-UNIQUE SORTED KEY`), and domain range validations.

### 3. SAP RAP Managed Travel Application (`sap-rap-managed-travel-app`)
A full transactional Business Object built on the RESTful Application Programming Model (RAP). Includes root/child CDS composition (`ZCDS_I_TRAVEL_M`, `ZCDS_I_BOOKING_M`), draft capabilities (`with draft`), custom actions (`acceptTravel`, `rejectTravel`), validations, and an OData V4 service definition (`ZSRV_TRAVEL_M`).

### 4. ABAP Cloud Open SQL Foundation (`sap-abap-open-sql-foundation`)
Demonstrates database queries using released BTP entities (`/dmo/travel`, `/dmo/booking`, `/dmo/customer`). Covers relational joins, aggregate functions (`COUNT`, `AVG`, `MAX`, `MIN`), grouping filters (`HAVING`), and deduplication (`SELECT DISTINCT`).

### 5. OO-ABAP Business Engines (`sap-oo-abap-business-engines`)
Contains Object-Oriented ABAP business engines:
- `zcl_order_processor`: Sales Order engine validating minimum order values (MOQ) and tiered customer discounts.
- `zcl_hr_bonus_calc`: HR engine evaluating rating and experience logic.

### 6. Cloud REST API Integration (`sap-btp-http-rest-integration`)
Implements external HTTP API consumption using `cl_web_http_client_manager` to request JSON exchange rate payloads and handle HTTP status codes.

---

## How to Import & Run in Eclipse ADT

1. **Prerequisites:**
   - Eclipse IDE with ABAP Development Tools (ADT) plugin installed.
   - Access to a SAP BTP Trial / Steampunk or S/4HANA Cloud system.

2. **Steps:**
   - Create a package in your SAP BTP system (e.g. `$TMP` or custom package `Z_MY_PROJECTS`).
   - Create the respective ABAP Class / Data Definition / Behavior Definition in Eclipse.
   - Copy the code from the corresponding `.abap`, `.acds`, `.abapbdef`, or `.srvd` files.
   - Activate using `Ctrl + F3`.
   - Run executable test runner classes (`zcl_*_runner` / `zcl_open_sql`) by pressing `F8`. Output will appear in the **ABAP Console** tab.

---

## Author
**Ashvin Upadhyay** (`ashvinupadhyay1132`)  
ABAP Cloud & BTP Developer
