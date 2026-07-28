# OO-ABAP Business Engines

Contains modular Object-Oriented ABAP business engines showcasing ABAP 7.5+ language syntax, type inference, conditional expressions, and reference table iterations.

---

## Architecture & Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                 ABAP Application Layer                      │
│     ZCL_ORDER_PROCESSOR / Unit Test ZCL_TEST_ORDER_PROCESSOR│
└──────────────────────────────┬──────────────────────────────┘
                               │ Passes Order Input Structure
┌──────────────────────────────▼──────────────────────────────┐
│                  ZCL_ORDER_PROCESSOR                        │
│                                                             │
│  1. MOQ Validation Check (MOQ >= 30,000 INR)                │
│  2. Tiered Discount Engine: COND #( WHEN 'VIP' THEN 20% )   │
│  3. Reference Iteration: LOOP AT ... REFERENCE INTO         │
└──────────────────────────────┬──────────────────────────────┘
                               │ Returns Processed Result
┌──────────────────────────────▼──────────────────────────────┐
│           ABAP Console Log / Unit Test Assertions           │
└─────────────────────────────────────────────────────────────┘
```

---

## Included Engines

### 1. Sales Order Discount Processor (`zcl_order_processor.abap`)
- Validates minimum order values (MOQ = ₹30,000 for regular customers).
- Computes customer tiered discounts (`VIP` = 20%/15%, `REGULAR` = 10%, `NEW` = 2%).
- Uses constructor expressions (`VALUE #(...)`, `COND #(...)`) and reference loop pointers (`LOOP AT ... REFERENCE INTO`).

### 2. HR Bonus Calculation Engine (`zcl_hr_bonus_calc.abap`)
- Calculates year-end employee bonuses based on rating (`A`, `B`, `C`) and years of experience.
- Demonstrates changing parameters (`CHANGING cs_emp TYPE ty_employee`).

---

## File Structure

- `zcl_order_processor.abap`: Sales Order processor class.
- `zcl_hr_bonus_calc.abap`: HR Bonus calculator class.
- `zcl_test_order_processor.abap`: Automated ABAP Unit Test suite (`FOR TESTING`).

---

## Execution Output

Running `zcl_hr_bonus_calc` in Eclipse ADT (`F8`):

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
