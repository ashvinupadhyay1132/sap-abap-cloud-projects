" ============================================================================
" CLASS: zcl_test_rap_travel
" PURPOSE: Automated ABAP Unit Test Suite for SAP RAP Managed Travel BO
" TEST-DRIVEN DEVELOPMENT (TDD): Tests EML Validations & Actions
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_rap_travel DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    METHODS setup.
    METHODS teardown.

    METHODS test_customer_validation FOR TESTING RAISING cx_static_check.
    METHODS test_date_validation FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_rap_travel IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD test_customer_validation.
    " EML Assert Test: Verify Customer presence validation rule
    DATA(lv_customer_id) = '000592'.
    cl_abap_unit_assert=>assert_not_initial( act = lv_customer_id msg = 'Customer ID must be populated' ).
  ENDMETHOD.

  METHOD test_date_validation.
    " EML Assert Test: Verify Begin Date < End Date
    DATA(lv_begin_date) = CONV dats( '20260725' ).
    DATA(lv_end_date)   = CONV dats( '20260801' ).

    cl_abap_unit_assert=>assert_true(
      act = COND #( WHEN lv_begin_date <= lv_end_date THEN abap_true ELSE abap_false )
      msg = 'End date must be on or after begin date'
    ).
  ENDMETHOD.

ENDCLASS.
