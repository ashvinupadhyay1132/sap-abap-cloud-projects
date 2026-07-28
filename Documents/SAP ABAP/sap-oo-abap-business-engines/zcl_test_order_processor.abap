" ============================================================================
" CLASS: zcl_test_order_processor
" PURPOSE: Automated ABAP Unit Test Suite for OO-ABAP Sales Order Processor
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify discount logic
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_order_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    DATA mo_cut TYPE REF TO zcl_order_processor.

    METHODS setup.
    METHODS teardown.

    METHODS test_vip_discount FOR TESTING RAISING cx_static_check.
    METHODS test_moq_rejection FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_order_processor IMPLEMENTATION.

  METHOD setup.
    mo_cut = NEW #( ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR mo_cut.
  ENDMETHOD.

  METHOD test_vip_discount.
    DATA(ls_order) = VALUE zcl_order_processor=>ty_order_input(
      order_id = 'ORD100' customer_type = 'VIP' order_amount = 60000 currency = 'INR'
    ).

    DATA(ls_result) = mo_cut->process_sales_order( ls_order ).

    cl_abap_unit_assert=>assert_equals( act = ls_result-status exp = 'APPROVED' msg = 'VIP order > 50k should be approved' ).
    cl_abap_unit_assert=>assert_equals( act = ls_result-discount_pct exp = 20 msg = 'VIP order > 50k should receive 20% discount' ).
  ENDMETHOD.

  METHOD test_moq_rejection.
    DATA(ls_order) = VALUE zcl_order_processor=>ty_order_input(
      order_id = 'ORD101' customer_type = 'REGULAR' order_amount = 10000 currency = 'INR'
    ).

    DATA(ls_result) = mo_cut->process_sales_order( ls_order ).

    cl_abap_unit_assert=>assert_equals( act = ls_result-status exp = 'REJECTED' msg = 'Regular order < 30k MOQ should be rejected' ).
  ENDMETHOD.

ENDCLASS.
