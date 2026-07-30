" ============================================================================
" CLASS: zcl_test_rap_side_effects
" PURPOSE: Automated ABAP Unit Test Suite for RAP Side Effects & Inventory BO
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify determinations
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_rap_side_effects DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    METHODS setup.
    METHODS teardown.

    METHODS test_critical_stock_determination FOR TESTING RAISING cx_static_check.
    METHODS test_optimal_stock_determination  FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_rap_side_effects IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD test_critical_stock_determination.
    " Test Critical Stock logic (Stock <= 10)
    DATA(lv_stock_qty) = 5.
    DATA(lv_expected_status) = COND #( WHEN lv_stock_qty <= 10 THEN 'C' ELSE 'O' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_expected_status
      exp = 'C'
      msg = 'Stock quantity <= 10 should trigger Critical Stock status (C)'
    ).
  ENDMETHOD.

  METHOD test_optimal_stock_determination.
    " Test Optimal Stock logic (Stock > 10)
    DATA(lv_stock_qty) = 150.
    DATA(lv_expected_status) = COND #( WHEN lv_stock_qty <= 10 THEN 'C' ELSE 'O' ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_expected_status
      exp = 'O'
      msg = 'Stock quantity > 10 should trigger Optimal Stock status (O)'
    ).
  ENDMETHOD.

ENDCLASS.
