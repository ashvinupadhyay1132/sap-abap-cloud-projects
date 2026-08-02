" ============================================================================
" CLASS: zcl_test_badi_ext
" PURPOSE: Automated ABAP Unit Test Suite for BAdI Extensibility Framework
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify BAdI calculation
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_badi_ext DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    METHODS setup.
    METHODS teardown.

    METHODS test_badi_vip_customer_discount FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_badi_ext IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD test_badi_vip_customer_discount.
    DATA lo_badi TYPE REF TO zif_badi_order_calc.
    lo_badi = NEW zcl_badi_order_calc_impl( ).

    lo_badi->calculate_custom_discount(
      EXPORTING
        iv_customer_id   = '000100'
        iv_base_amount   = 100000
      IMPORTING
        ev_discount_rate = DATA(lv_rate)
        ev_discount_amt  = DATA(lv_amt)
    ).

    cl_abap_unit_assert=>assert_equals( act = lv_rate exp = 12 msg = 'VIP Customer should receive 12% discount rate' ).
    cl_abap_unit_assert=>assert_equals( act = lv_amt exp = 12000 msg = 'VIP Discount amount math failed' ).
  ENDMETHOD.

ENDCLASS.
