# ⚙️ Object-Oriented ABAP (OO-ABAP) Core Engines

This folder contains modular, production-level Object-Oriented ABAP programs showcasing 7.5+ Modern ABAP syntax and Type Inference.

---

## 🛠️ OO-ABAP Concepts Covered

- **Classes & Interfaces**: Implementing `if_oo_adt_classrun` for BTP Console Execution.
- **Type Inference Operators**: `DATA(...)`, `VALUE #(...)`, `COND #(...)`, `CONV decfloat34(...)`.
- **Method Signatures**: `IMPORTING`, `EXPORTING`, `CHANGING`, `RETURNING` parameters.
- **Constructor & Attributes**: State initialization via `me->` self reference.
- **Object Collections**: `REF TO` object tables and reference loop iteration (`LOOP AT ... REFERENCE INTO`).

---

## 📄 File Manifest

| File Name | Domain | Description |
| :--- | :--- | :--- |
| [`zcl_order_processor.abap`](./zcl_order_processor.abap) | Sales & Distribution (SD) | Enterprise Sales Order Discount Engine validating minimum order value (MOQ) and tiered customer discounts. |
| [`zcl_hr_bonus_calc.abap`](./zcl_hr_bonus_calc.abap) | Human Resources (HR) | Year-End Bonus Calculation Engine evaluating employee ratings (A, B, C) and experience years. |

---

## 🖥️ Sample Execution Output Logs

### HR Bonus Engine (`ZCL_HR_BONUS_CALC`):
```text
========================================================================================
                       HR BONUS CALCULATION ENGINE                           
========================================================================================
ID: EMP01 Name: Amit Kumar      Rating: A Salary: ₹50000 Bonus: 30% Bonus Amt: ₹15000
ID: EMP02 Name: Riya Sharma     Rating: A Salary: ₹60000 Bonus: 20% Bonus Amt: ₹12000
ID: EMP03 Name: Rahul Verma     Rating: B Salary: ₹45000 Bonus: 10% Bonus Amt: ₹4500
ID: EMP04 Name: Neha Gupta      Rating: C Salary: ₹40000 Bonus: 0% Bonus Amt: ₹0
========================================================================================
```
