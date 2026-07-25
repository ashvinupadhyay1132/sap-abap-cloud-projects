# SAP ABAP Cloud & Enterprise RAP Framework Portfolio 🚀

Welcome to my **SAP ABAP Cloud & Enterprise RAP Framework** developer portfolio repository. 

This repository contains modularized, industry-standard SAP projects categorized by business architecture, frameworks, and data modeling concepts.

---

## 📁 Repository Folder Architecture

```text
sap-abap-cloud-projects/
│
├── 📂 01_Enterprise_RAP_App/          <-- Enterprise RAP Framework App (CDS + BDEF + EML)
│   ├── zcds_i_travel_m.acds           (Root View Entity)
│   ├── zcds_i_booking_m.acds          (Child View Entity)
│   ├── zbdef_travel_m.abapbdef        (Behavior Definition - Drafts, Actions, Validations)
│   ├── zcl_bp_travel_m.abap           (Global Behavior Pool Handler Class)
│   ├── zsrv_travel_m.srvd             (OData V4 Service Exposure)
│   └── zcl_rap_test_runner.abap       (Automated RAP EML Audit Test Runner)
│
├── 📂 02_Open_SQL_Foundation/         <-- Database Open SQL Core Concepts
│   └── zcl_open_sql.abap              (JOINS, GROUP BY, HAVING, AGGREGATES, SELECT DISTINCT)
│
├── 📂 03_OO_ABAP_Core/                <-- Object-Oriented ABAP Business Engines
│   ├── zcl_order_processor.abap       (Enterprise Sales Order Discount Engine)
│   └── zcl_hr_bonus_calc.abap         (HR Year-End Bonus Calculation Engine)
│
└── 📂 04_Integration_HTTP_API/        <-- SAP BTP Cloud REST API Integration
    └── zcl_api_consumer.abap          (HTTP Client, JSON Parsing & Exception Handling)
```

---

## 🛠️ Key Frameworks & Technologies

| Layer / Technology | Description |
| :--- | :--- |
| **SAP RAP Framework** | Core Data Services View Entities, Behavior Definitions (`with draft`), EML (`MODIFY ENTITIES`), Actions & Validations |
| **Open SQL (ABAP Cloud)** | Inner Join, Left Outer Join, Group By, Having, Aggregate Functions (`COUNT`, `AVG`, `MAX`, `MIN`), Select Distinct |
| **OO-ABAP 7.5+** | Classes, Interfaces (`if_oo_adt_classrun`), Type Inference (`DATA`, `VALUE`, `COND`, `CONV`), References (`REF TO`) |
| **BTP Cloud Integrations** | REST API consumption via `cl_web_http_client_manager` & `cl_http_destination_provider` |

---

## 👤 Author
- **Developer:** Ashvin Upadhyay (`ashvinupadhyay1132`)
- **Specialization:** SAP BTP ABAP Cloud / RAP Framework / CDS Data Modeling / Enterprise Open SQL
