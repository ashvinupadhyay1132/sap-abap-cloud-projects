# SAP ABAP Cloud & Enterprise RAP Framework Portfolio 🚀

Welcome to my **SAP ABAP Cloud & Enterprise RAP Framework** developer portfolio repository. 

This repository contains industry-grade SAP projects categorized by business architecture, frameworks, database data modeling, AMDP HANA SQLScript pushdown, data dictionary (DDIC) concepts, and enterprise API integrations.

---

## 📁 Repository Folder Architecture

```text
sap-abap-cloud-projects/
│
├── 📂 sap-amdp-financial-analytics/          <-- Enterprise AMDP HANA SQLScript Financial Engine
│   ├── zcl_amdp_financial_analytics.abap     (AMDP Class with if_amdp_marker_hdb & SQLScript Procedure)
│   ├── zcl_amdp_runner.abap                  (Executable AMDP Test Runner & Audit Log Display)
│   └── README.md                             (Functional Spec, AMDP Architecture, Inputs/Outputs)
│
├── 📂 sap-ddic-purchase-requisition-system/  <-- Real-Time Data Dictionary (DDIC) Procurement App
│   ├── zddic_pr_header.acds                  (Header DDIC Dictionary View Entity)
│   ├── zddic_pr_item.acds                    (Item DDIC View Entity with Currency/Qty References)
│   ├── zcl_pr_ddic_engine.abap               (DDIC Engine Class: Deep Structures, Table Keys)
│   ├── zcl_pr_ddic_runner.abap               (Executable Runner with Domain Validation Audit Logs)
│   └── README.md                             (Functional Spec, DDIC Matrix, Inputs/Outputs)
│
├── 📂 sap-rap-managed-travel-app/            <-- Enterprise RAP Framework Application
│   ├── zcds_i_travel_m.acds                  (Root View Entity)
│   ├── zcds_i_booking_m.acds                 (Child View Entity)
│   ├── zbdef_travel_m.abapbdef               (Behavior Definition - Drafts, Actions, Validations)
│   ├── zcl_bp_travel_m.abap                  (Global Behavior Pool Handler Class)
│   ├── zsrv_travel_m.srvd                    (OData V4 Service Exposure)
│   ├── zcl_rap_test_runner.abap              (Automated RAP EML Audit Test Runner)
│   └── README.md                             (Detailed Functional Spec & Architecture)
│
├── 📂 sap-abap-open-sql-foundation/          <-- Database Open SQL Core Concepts
│   ├── zcl_open_sql.abap                     (JOINS, GROUP BY, HAVING, AGGREGATES, SELECT DISTINCT)
│   └── README.md                             (Detailed Open SQL Functional Spec & Logs)
│
├── 📂 sap-oo-abap-business-engines/          <-- Object-Oriented ABAP Business Engines
│   ├── zcl_order_processor.abap             (Enterprise Sales Order Discount Engine)
│   ├── zcl_hr_bonus_calc.abap                (HR Year-End Bonus Calculation Engine)
│   └── README.md                             (OO-ABAP Principles & Functional Specs)
│
└── 📂 sap-btp-http-rest-integration/         <-- SAP BTP Cloud REST API Integration
    ├── zcl_api_consumer.abap                 (HTTP Client, JSON Parsing & Exception Handling)
    └── README.md                             (Integration Spec & Architecture)
```

---

## 🛠️ Key Frameworks & Technologies

| Layer / Technology | Description |
| :--- | :--- |
| **AMDP & HANA SQLScript** | `if_amdp_marker_hdb`, `BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT`, Window Functions (`RANK() OVER`), Code Pushdown |
| **Data Dictionary (DDIC)** | Domains, Fixed Value Ranges, Data Elements, Semantics (`@Semantics.amount`, `@Semantics.quantity`), Deep Structures, Secondary Key Table Types |
| **SAP RAP Framework** | Core Data Services View Entities, Behavior Definitions (`with draft`), EML (`MODIFY ENTITIES`), Actions & Validations |
| **Open SQL (ABAP Cloud)** | Inner Join, Left Outer Join, Group By, Having, Aggregate Functions (`COUNT`, `AVG`, `MAX`, `MIN`), Select Distinct |
| **OO-ABAP 7.5+** | Classes, Interfaces (`if_oo_adt_classrun`), Type Inference (`DATA`, `VALUE`, `COND`, `CONV`), References (`REF TO`) |
| **BTP Cloud Integrations** | REST API consumption via `cl_web_http_client_manager` & `cl_http_destination_provider` |

---

## 👤 Author
- **Developer:** Ashvin Upadhyay (`ashvinupadhyay1132`)
- **Specialization:** SAP BTP ABAP Cloud / AMDP HANA SQLScript / RAP Framework / Data Dictionary (DDIC) / Enterprise Integrations
