" ============================================================================
" CLASS: zcl_test_pr_ddic
" PURPOSE: Automated ABAP Unit Test Suite for Purchase Requisition DDIC Engine
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify DDIC rules
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_pr_ddic DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_pr_ddic_engine.

    METHODS setup.
    METHODS teardown.

    METHODS test_valid_domain_types FOR TESTING RAISING cx_static_check.
    METHODS test_invalid_domain_type FOR TESTING RAISING cx_static_check.
    METHODS test_pr_total_calculation FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_pr_ddic IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR mo_cut.
  ENDMETHOD.

  METHOD test_valid_domain_types.
    DATA(lv_is_valid) = mo_cut->validate_pr_type( 'NB' ).
    cl_abap_unit_assert=>assert_true( act = lv_is_valid msg = 'PR Type NB should be valid' ).
  ENDMETHOD.

  METHOD test_invalid_domain_type.
    DATA(lv_is_valid) = mo_cut->validate_pr_type( 'INVALID_TYPE' ).
    cl_abap_unit_assert=>assert_false( act = lv_is_valid msg = 'PR Type INVALID_TYPE should be rejected' ).
  ENDMETHOD.

  METHOD test_pr_total_calculation.
    DATA(ls_pr) = VALUE zcl_pr_ddic_engine=>ty_pr_header_ddic(
      pr_number = '100001'
      currency_code = 'INR'
      items = VALUE #(
        ( pr_item_no = 10 quantity = 2 price_per_unit = 500 )
        ( pr_item_no = 20 quantity = 3 price_per_unit = 200 )
      )
    ).

    mo_cut->calculate_pr_totals( CHANGING cs_pr_header = ls_pr ).

    cl_abap_unit_assert=>assert_equals(
      act = ls_pr-total_pr_amount
      exp = 1600
      msg = 'Total PR amount should be (2*500) + (3*200) = 1600'
    ).
  ENDMETHOD.

ENDCLASS.
