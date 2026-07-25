# ⚙️ Object-Oriented ABAP Business Engines (`sap-oo-abap-business-engines`)

Production-style Object-Oriented ABAP programs showcasing 7.5+ Modern ABAP syntax, Type Inference, Encapsulation, and Business Rule Validation.

---

## 📌 Business Requirement (Functional Spec)

### 1. Enterprise Sales Order Discount Engine (`zcl_order_processor.abap`):
- **Domain:** Sales & Distribution (SD) / E-Commerce
- **Problem Statement:** Validate incoming sales orders. Reject orders with amount <= 0. Enforce Minimum Order Quantity (MOQ = ₹30,000) for Regular customers. Calculate tiered discounts for VIP (20%/15%), Regular (10%), and New (2%) customers, and compute net revenue.

### 2. HR Bonus Calculation Engine (`zcl_hr_bonus_calc.abap`):
- **Domain:** Human Resources (HR)
- **Problem Statement:** Calculate year-end employee bonuses dynamically. Employees with Rating 'A' & >= 5 years experience receive 30% bonus, Rating 'A' & < 5 years receive 20%, Rating 'B' receives 10%, and Rating 'C' receives 0%.

---

## 📥 Inputs & 📤 Outputs

### Inputs:
- **Sales Order:** `order_id`, `customer_name`, `customer_type` (VIP/REGULAR/NEW), `gross_amount`
- **Employee:** `emp_id`, `emp_name`, `emp_rating` (A/B/C), `emp_basesalary`, `emp_experience`

### Outputs:
- **Sales Order:** Net Amount, Discount %, Order Status (`PROCESSED & APPROVED` vs `REJECTED`), Total Approved Revenue.
- **Employee:** Bonus %, Final Bonus Amount in INR, Summary List.

---

## 📄 Component Manifest

| File Name | Domain | Description |
| :--- | :--- | :--- |
| [`zcl_order_processor.abap`](./zcl_order_processor.abap) | Sales & Distribution (SD) | Sales Order Discount Engine using Type Inference (`DATA`, `VALUE`, `COND`, `CONV`). |
| [`zcl_hr_bonus_calc.abap`](./zcl_hr_bonus_calc.abap) | Human Resources (HR) | Year-End Bonus Calculation Engine with nested rules & object loops. |

---

## 🖥️ Execution Output Logs

### HR Bonus Engine Output:
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
