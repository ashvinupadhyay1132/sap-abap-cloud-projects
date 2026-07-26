# 📦 Enterprise Purchase Requisition System (`sap-ddic-purchase-requisition-system`)

A real-time, production-grade **SAP Materials Management (MM) Procurement System** demonstrating core **SAP Data Dictionary (DDIC)** concepts in **SAP BTP ABAP Cloud Environment**.

---

## 📌 Business Requirement Document (BRD & Functional Spec)

### 🏢 Enterprise Business Scenario
In global SAP S/4HANA & BTP ERP deployments, the Purchasing Department relies on a standardized **Purchase Requisition (PR)** framework to manage internal procurement requests before generating formal Purchase Orders (POs). 

### 🎯 Functional Objectives:
1. **Data Integrity & Domain Constraints:** Restrict PR Document Types to approved domain value ranges (`NB` = Standard PR, `FO` = Framework PR, `RV` = Outline Agreement PR) and Document Statuses (`D` = Draft, `S` = Submitted, `A` = Approved, `R` = Rejected).
2. **Semantics & Currency/Quantity References:** Annotate line item quantities with appropriate Units of Measure (`ST` = Pieces, `LTR` = Liters, `KG` = Kilograms) and line item amounts with Currency Codes (`INR`, `EUR`, `USD`).
3. **Deep Relational Structures:** Structure Header records and Line Item records using DDIC Deep Structures (`ty_pr_header_ddic`) and Secondary Key Table Types (`tt_pr_items_ddic`).
4. **Automated Line-Item & Total Calculation:** Dynamically compute line-item totals (`Quantity * Price_Per_Unit`) and aggregate grand total requisition amounts per header.

---

## 📥 Inputs & 📤 Outputs

### 📥 Functional Inputs:
- **Header Level:** `PR_Number` (`'10000891'`), `PR_Type` (`'NB'`), `PR_Status` (`'S'`), `Plant` (`'1000'`), `Department` (`'IT Infrastructure'`), `Created_By` (`'ASHVIN_U'`), `Currency` (`'INR'`).
- **Item Level:** `PR_Item_No` (`10`, `20`), `Material_No` (`'MAT-SERVER-01'`), `Quantity` (`2`), `Unit_Of_Measure` (`'ST'`), `Price_Per_Unit` (`₹2,50,000`).

### 📤 System Outputs:
- **Validation Audit Log:** DDIC Domain range check pass/fail notification.
- **Line Item Total Amount:** Computed item total (`2 * ₹2,50,000 = ₹5,00,000`).
- **Header Grand Total Amount:** Aggregated requisition total (`₹5,00,000 + ₹1,44,000 = ₹6,44,000 INR`).

---

## 🗄️ Data Dictionary (DDIC) Concepts & Semantics Matrix

| DDIC Concept | Component Implementation | Business Purpose & Description |
| :--- | :--- | :--- |
| **Domain Fixed Values** | `PR_Type` (`NB`, `FO`, `RV`) | Enforces valid document type values at data dictionary level. |
| **Domain Fixed Values** | `PR_Status` (`D`, `S`, `A`, `R`) | Controls transactional lifecycle states. |
| **Quantity Reference** | `@Semantics.quantity.unitOfMeasure` | Binds numeric quantity to unit of measure (`ST`, `LTR`, `KG`). |
| **Amount Reference** | `@Semantics.amount.currencyCode` | Binds monetary value to currency code (`INR`, `EUR`, `USD`). |
| **Deep DDIC Structure** | `ty_pr_header_ddic` | Nested structure containing header fields and internal table of items. |
| **Secondary Keys Table Type** | `tt_pr_items_ddic` | Standard table type with `NON-UNIQUE SORTED KEY item_key` for fast lookup. |
| **Field Symbol Pointers** | `ASSIGNING FIELD-SYMBOL(<fs_item>)` | Memory-efficient in-place modification of internal table rows. |

---

## 📄 File Manifest

| File Name | Object Type | Description |
| :--- | :--- | :--- |
| [`zddic_pr_header.acds`](./zddic_pr_header.acds) | CDS Root Entity | Purchase Requisition Header dictionary view entity with DDIC annotations. |
| [`zddic_pr_item.acds`](./zddic_pr_item.acds) | CDS Child Entity | Purchase Requisition Item dictionary view entity with Quantity/Currency reference semantics. |
| [`zcl_pr_ddic_engine.abap`](./zcl_pr_ddic_engine.abap) | ABAP Engine Class | Core processing engine handling DDIC structures, validations, and total calculations. |
| [`zcl_pr_ddic_runner.abap`](./zcl_pr_ddic_runner.abap) | ABAP Test Class | Executable test runner implementing `if_oo_adt_classrun` for BTP console output. |

---

## 🖥️ Execution Output Log (SAP BTP Console Verification)

```text
========================================================================================
          SAP MM MODULE - PURCHASE REQUISITION DATA DICTIONARY (DDIC) ENGINE           
========================================================================================
----------------------------------------------------------------------------------------
PR Number : 10000891 | Plant : 1000 | Dept : IT Infrastructure | Created By : ASHVIN_U
   [DDIC VALIDATED]: PR Type 'NB' & Status 'S' Passed Data Dictionary Validation.
   Line Items:
     - Item 10: MAT-SERVER-01      Dell PowerEdge R750 Server     Qty:   2 ST  Price/Unit: ₹  250000 Total Item Val: ₹   500000 INR
     - Item 20: MAT-RAM-64GB       64GB DDR4 ECC RAM Module       Qty:   8 ST  Price/Unit: ₹   18000 Total Item Val: ₹   144000 INR
   -> Calculated Total Requisition Value : ₹644000 INR
----------------------------------------------------------------------------------------
PR Number : 10000892 | Plant : 2000 | Dept : Plant Operations | Created By : RIYA_S
   [DDIC DOMAIN ERROR]: PR Type 'INVALID_TYPE' is INVALID! Value Range must be NB, FO, or RV.
========================================================================================
SUMMARY: Purchase Requisition Data Dictionary Processing & Validation Completed.
========================================================================================
```
