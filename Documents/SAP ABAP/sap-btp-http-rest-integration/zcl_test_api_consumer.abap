" ============================================================================
" CLASS: zcl_test_api_consumer
" PURPOSE: Automated ABAP Unit Test Suite for Cloud REST API Consumer
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify API client
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_api_consumer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_api_consumer.

    METHODS setup.
    METHODS teardown.

    METHODS test_exchange_rate_fetch FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_api_consumer IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR mo_cut.
  ENDMETHOD.

  METHOD test_exchange_rate_fetch.
    DATA(ls_rate) = mo_cut->fetch_exchange_rate( iv_base = 'USD' iv_target = 'INR' ).

    cl_abap_unit_assert=>assert_equals( act = ls_rate-base_currency   exp = 'USD' msg = 'Base currency should be USD' ).
    cl_abap_unit_assert=>assert_equals( act = ls_rate-target_currency exp = 'INR' msg = 'Target currency should be INR' ).
    cl_abap_unit_assert=>assert_not_initial( act = ls_rate-exchange_rate msg = 'Exchange rate must be returned' ).
  ENDMETHOD.

ENDCLASS.
