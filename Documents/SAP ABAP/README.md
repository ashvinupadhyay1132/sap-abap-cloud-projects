# SAP ABAP Cloud & Enterprise RAP Framework Portfolio 🚀

Welcome to my **SAP ABAP Cloud & Enterprise RAP Framework** developer portfolio repository. 

This repository contains industry-grade SAP projects categorized by business architecture, frameworks, database data modeling, and enterprise API integrations.

---

## 📁 Industry Standard Repository Structure

```text
sap-abap-cloud-projects/
│
├── 📂 sap-rap-managed-travel-app/          <-- Enterprise RAP Framework Application
│   ├── zcds_i_travel_m.acds                (Root View Entity)
│   ├── zcds_i_booking_m.acds               (Child View Entity)
│   ├── zbdef_travel_m.abapbdef             (Behavior Definition - Drafts, Actions, Validations)
│   ├── zcl_bp_travel_m.abap                (Global Behavior Pool Handler Class)
│   ├── zsrv_travel_m.srvd                  (OData V4 Service Exposure)
│   ├── zcl_rap_test_runner.abap            (Automated RAP EML Audit Test Runner)
│   └── README.md                           (Detailed Functional Spec & Architecture)
│
├── 📂 sap-abap-open-sql-foundation/        <-- Database Open SQL Core Concepts
│   ├── zcl_open_sql.abap                   (JOINS, GROUP BY, HAVING, AGGREGATES, SELECT DISTINCT)
│   └── README.md                           (Detailed Open SQL Functional Spec & Logs)
│
├── 📂 sap-oo-abap-business-engines/        <-- Object-Oriented ABAP Business Engines
│   ├── zcl_order_processor.abap            (Enterprise Sales Order Discount Engine)
│   ├── zcl_hr_bonus_calc.abap              (HR Year-End Bonus Calculation Engine)
│   └── README.md                           (OO-ABAP Principles & Functional Specs)
│
└── 📂 sap-btp-http-rest-integration/       <-- SAP BTP Cloud REST API Integration
    ├── zcl_api_consumer.abap               (HTTP Client, JSON Parsing & Exception Handling)
    └── README.md                           (Integration Spec & Architecture)
```

---

## 🚀 Future Enterprise Projects Roadmap

- [ ] **Project 5: ABAP CDS Analytical Queries & Cube Views (Financial Analytics)**
  - `@Analytics.query: true` / `@Analytics.dataCategory: #CUBE`
  - Window functions (`SUM OVER`, `RANK`), Aggregations, Parameters.
- [ ] **Project 6: SAP AMDP (ABAP Managed Database Procedures - HANA SQLScript)**
  - Database procedure in HANA SQLScript (`CLASS-METHODS ... FOR HDB LANGUAGE SQLSCRIPT`).
- [ ] **Project 7: ABAP Unit Testing & Test Double Framework**
  - Automated unit tests (`FOR TESTING`), Mocking database tables via SQL Test Double Framework.
- [ ] **Project 8: Full-Stack SAP Fiori Elements UI + RAP Unmanaged / Custom Logic**
  - Unmanaged BDEF with custom legacy function module integration (`save`, `create`).

---

## 👤 Author
- **Developer:** Ashvin Upadhyay (`ashvinupadhyay1132`)
- **Specialization:** SAP BTP ABAP Cloud / RAP Framework / CDS Data Modeling / Enterprise Integration
