# SAP ABAP Cloud & BTP Enterprise Projects

A collection of production-style ABAP Cloud and BTP projects covering the RESTful Application Programming Model (RAP), ABAP Managed Database Procedures (AMDP), Core Data Services (CDS), Data Dictionary (DDIC), and REST API integrations.

All objects in this repository are written in **ABAP Language Version: ABAP Cloud (7.5+ / Steampunk)** and are compatible with **SAP BTP ABAP Environment** and **SAP S/4HANA Cloud**.

---

## 🌟 Production Engineering Standards
Every project in this repository adheres to two enterprise production standards:
1. **Automated ABAP Unit Tests (`FOR TESTING`):** Uses `cl_abap_unit_assert` for Test-Driven Development (TDD) and clean core code quality.
2. **Architecture & Data Flow Diagrams:** Visual sequence flow diagrams in every project `README.md` detailing application-to-database interaction.

---

## Repository Index

| Project Directory | Focus Area | Key Technologies |
| :--- | :--- | :--- |
| [`sap-rap-side-effects-inventory`](./sap-rap-side-effects-inventory) | RAP Side Effects & Feature Control | `@Consumption.sideEffects`, Dynamic Features, Determinations, ABAP Unit Tests |
| [`sap-rap-custom-numbering-invoice`](./sap-rap-custom-numbering-invoice) | RAP Early Custom Numbering | Managed RAP, `early numbering`, `cl_number_range` API, ABAP Unit Tests |
| [`sap-rap-unmanaged-sales-order`](./sap-rap-unmanaged-sales-order) | Unmanaged BO & Legacy BAPI | Unmanaged RAP, Custom Transactional Buffer, Saver Sequence, ABAP Unit Tests |
| [`sap-amdp-financial-analytics`](./sap-amdp-financial-analytics) | Database Code Pushdown | AMDP, HANA SQLScript, Window Functions (`RANK`), ABAP Unit Tests |
| [`sap-ddic-purchase-requisition-system`](./sap-ddic-purchase-requisition-system) | Data Dictionary & Procurement | CDS View Entities, Currency/Quantity Semantics, Deep Structures, Table Types, ABAP Unit Tests |
| [`sap-rap-managed-travel-app`](./sap-rap-managed-travel-app) | Business Object Architecture | SAP RAP Framework, Draft Handling, BDEF, EML, Validations, ABAP Unit Tests |
| [`sap-abap-open-sql-foundation`](./sap-abap-open-sql-foundation) | Open SQL Data Fetching | Inner/Left Joins, `GROUP BY`, `HAVING`, Aggregate Functions, ABAP Unit Tests |
| [`sap-oo-abap-business-engines`](./sap-oo-abap-business-engines) | Core OO-ABAP Logic | Type Inference (`DATA`, `VALUE`, `COND`), Encapsulation, ABAP Unit Tests |
| [`sap-btp-http-rest-integration`](./sap-btp-http-rest-integration) | Cloud API Consumption | `cl_web_http_client_manager`, `cl_http_destination_provider`, ABAP Unit Tests |

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
   - Run automated ABAP Unit Tests by pressing `Ctrl + Shift + F10` on any `zcl_test_*` class.

---

## License
This repository is licensed under the [MIT License](./LICENSE).

---

## Author
**Ashvin Upadhyay** (`ashvinupadhyay1132`)  
ABAP Cloud & BTP Developer
