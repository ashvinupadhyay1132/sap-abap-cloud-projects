# 📈 Enterprise SAP AMDP Financial Analytics (`sap-amdp-financial-analytics`)

A real-time, production-grade **SAP Financial Accounting & Controlling (FI-CO)** analytics engine leveraging **ABAP Managed Database Procedures (AMDP)** and **SAP HANA SQLScript Code Pushdown** in **SAP BTP ABAP Cloud Environment**.

---

## 📌 Business Requirement Document (BRD & Functional Spec)

### 🏢 Enterprise Business Scenario
In multinational SAP S/4HANA ERP systems, financial posted data contains millions of rows across various company codes and divisions. Performing financial aggregations, profit margin calculations, and division rankings inside ABAP loops causes severe application server bottlenecks.

### 🎯 Functional Objectives:
1. **Database Code Pushdown:** Push all financial calculations (Revenue aggregation, Cost of Goods Sold deduction, Operating Expenses deduction, Profit Margin %, and Revenue Ranking) directly into the **SAP HANA Database** layer.
2. **HANA SQLScript Execution:** Implement a procedure written in native HANA SQLScript using `if_amdp_marker_hdb` and `BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT`.
3. **Window Functions & Ranking:** Use native HANA Window functions (`RANK() OVER (ORDER BY revenue DESC)`) to dynamically compute revenue rankings.
4. **Conditional Categorization:** Categorize division profit margins dynamically (`HIGH MARGIN`, `MODERATE MARGIN`, `LOW MARGIN / LOSS`).

---

## 🏗️ AMDP Architecture & Code Pushdown Flow

```
+-----------------------------------------------------------------------+
|                    ABAP Application Layer                             |
|          ZCL_AMDP_RUNNER (Instantiates Financial Postings)             |
+-----------------------------------┬-----------------------------------+
                                    | Passes ITAB :it_postings
                                    v
+-----------------------------------------------------------------------+
|                 SAP HANA Database Engine Layer                        |
|        ZCL_AMDP_FINANCIAL_ANALYTICS=>get_financial_revenue_analytics |
|                                                                       |
|   1. HANA SQLScript Grouping & Aggregation (SUM, AVG)                |
|   2. HANA Window Function Execution: RANK() OVER (ORDER BY Revenue)   |
|   3. HANA Conditional Evaluation: CASE WHEN Margin >= 50000          |
+-----------------------------------┬-----------------------------------+
                                    | Returns ETAB :et_analytics
                                    v
+-----------------------------------------------------------------------+
|                    ABAP Console Output Display                        |
+-----------------------------------------------------------------------+
```

---

## 📥 Inputs & 📤 Outputs

### 📥 Functional Inputs:
- **`company_code`**: Company Code ID (e.g., `'1000'`, `'2000'`)
- **`division`**: Business Division (e.g., `'CLOUD_SERVICES'`, `'CONSULTING'`, `'HARDWARE_SALES'`)
- **`revenue`**: Total Gross Sales Revenue (e.g., `₹4,00,000`)
- **`cogs`**: Cost of Goods Sold (e.g., `₹1,50,000`)
- **`opex`**: Operating Expenses (e.g., `₹50,000`)

### 📤 System Outputs:
- **`gross_profit`**: Calculated Gross Profit (`Revenue - COGS`)
- **`net_profit`**: Calculated Net Profit (`Revenue - COGS - OPEX`)
- **`margin_pct`**: Net Profit Margin Percentage (`(Net_Profit / Revenue) * 100`)
- **`margin_status`**: Performance Category (`HIGH MARGIN`, `MODERATE MARGIN`, `LOW MARGIN / LOSS`)
- **`revenue_rank`**: Dynamic HANA Window Rank integer (`Rank #1`, `Rank #2`, etc.)

---

## 🗄️ AMDP & SQLScript Feature Matrix

| Feature | Implementation | Purpose & Benefit |
| :--- | :--- | :--- |
| **AMDP Marker Interface** | `INTERFACES if_amdp_marker_hdb` | Registers class as a valid AMDP database procedure host. |
| **SQLScript Engine Option** | `BY DATABASE PROCEDURE FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY` | Bypasses ABAP application server and executes directly in HANA DB kernel. |
| **HANA Window Function** | `RANK() OVER (ORDER BY total_revenue DESC)` | Computes division revenue ranking directly in database memory. |
| **SQLScript Expressions** | `CASE WHEN ... THEN ... ELSE ... END` | Computes dynamic margin status categories on HANA DB. |
| **HANA Math Functions** | `ROUND( ..., 2 )` | Standardizes decimal precision for financial profit percentages. |

---

## 📄 Component Manifest

| File Name | Object Type | Description |
| :--- | :--- | :--- |
| [`zcl_amdp_financial_analytics.abap`](./zcl_amdp_financial_analytics.abap) | AMDP Class | Contains AMDP marker interface and HANA SQLScript database procedure implementation. |
| [`zcl_amdp_runner.abap`](./zcl_amdp_runner.abap) | ABAP Test Class | Executable test runner implementing `if_oo_adt_classrun` to trigger AMDP procedure. |

---

## 🖥️ Execution Output Log (SAP BTP Console Verification)

```text
========================================================================================
       SAP FI-CO MODULE - AMDP FINANCIAL ANALYTICS ENGINE (HANA SQLSCRIPT PUSHDOWN)     
========================================================================================
[INPUT]: Instantiated 5 Financial Postings across Company Codes 1000 & 2000.
----------------------------------------------------------------------------------------
[EML EXECUTION]: Invoking AMDP Method (HANA DB Engine SQLScript Pushdown)...
   [PASS]: HANA SQLScript Execution Completed Successfully.
----------------------------------------------------------------------------------------
                       FINANCIAL PROFITABILITY & RANKING REPORT                         
----------------------------------------------------------------------------------------
Rank #1 CoCode: 1000 Division: CLOUD_SERVICES    Revenue: ₹   750000 COGS: ₹  270000 Net Profit: ₹  385000 Margin: 51.33% Status: HIGH MARGIN
Rank #2 CoCode: 2000 Division: CONSULTING        Revenue: ₹   600000 COGS: ₹  200000 Net Profit: ₹  320000 Margin: 53.33% Status: HIGH MARGIN
Rank #3 CoCode: 1000 Division: HARDWARE_SALES    Revenue: ₹   180000 COGS: ₹  110000 Net Profit: ₹   45000 Margin: 25.00% Status: MODERATE MARGIN
Rank #4 CoCode: 2000 Division: SUPPORT_SERVICES  Revenue: ₹    90000 COGS: ₹   55000 Net Profit: ₹   15000 Margin: 16.67% Status: LOW MARGIN / LOSS
========================================================================================
AUDIT SUMMARY: 100% AMDP HANA SQLScript Financial Analytics Execution Verified.
========================================================================================
```
