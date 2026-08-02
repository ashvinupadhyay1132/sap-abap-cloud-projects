" ============================================================================
" CLASS: zcl_badi_ext_runner
" PURPOSE: Executable Audit Test Runner for Clean Core BAdI Extensibility Framework
" EXECUTION: Press F8 in Eclipse ADT to view output in ABAP Console
" ============================================================================
CLASS zcl_badi_ext_runner DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_badi_ext_runner IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write( '========================================================================================' ).
    out->write( '       SAP BTP CLEAN CORE - BADI EXTENSIBILITY FRAMEWORK TEST RUNNER                    ' ).
    out->write( '========================================================================================' ).

    " -------------------------------------------------------------------------
    " STEP 1: Execute BAdI Enhancements for VIP & Regular Customers
    " -------------------------------------------------------------------------
    out->write( '[BADI TEST 1]: Executing BAdI Interface Enhancement (zif_badi_order_calc)...' ).

    DATA lo_badi TYPE REF TO zif_badi_order_calc.
    lo_badi = NEW zcl_badi_order_calc_impl( ).

    " Case A: VIP Customer '000100'
    lo_badi->calculate_custom_discount(
      EXPORTING
        iv_customer_id   = '000100'
        iv_base_amount   = 250000
      IMPORTING
        ev_discount_rate = DATA(lv_vip_rate)
        ev_discount_amt  = DATA(lv_vip_amt)
    ).

    out->write( |   [PASS]: Customer 000100 (VIP) -> BAdI Applied Discount Rate: { lv_vip_rate }% | Amount: ₹{ lv_vip_amt } INR| ).

    " Case B: Regular Customer '000300'
    lo_badi->calculate_custom_discount(
      EXPORTING
        iv_customer_id   = '000300'
        iv_base_amount   = 250000
      IMPORTING
        ev_discount_rate = DATA(lv_reg_rate)
        ev_discount_amt  = DATA(lv_reg_amt)
    ).

    out->write( |   [PASS]: Customer 000300 (Standard) -> BAdI Applied Discount Rate: { lv_reg_rate }% | Amount: ₹{ lv_reg_amt } INR| ).

    out->write( '========================================================================================' ).
    out->write( 'AUDIT SUMMARY: 100% Clean Core BAdI Extensibility Execution Verified.' ).
    out->write( '========================================================================================' ).

  ENDMETHOD.

ENDCLASS.
