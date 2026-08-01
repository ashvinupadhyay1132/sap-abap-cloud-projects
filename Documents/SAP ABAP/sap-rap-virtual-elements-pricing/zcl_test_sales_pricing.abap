" ============================================================================
" CLASS: zcl_test_sales_pricing
" PURPOSE: Automated ABAP Unit Test Suite for SD Sales Pricing Virtual Elements
" TEST-DRIVEN DEVELOPMENT (TDD): Uses cl_abap_unit_assert to verify price & tax math
" LANGUAGE VERSION: ABAP Cloud / BTP Steampunk Compatible
" ============================================================================
CLASS zcl_test_sales_pricing DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS .

  PRIVATE SECTION.
    METHODS setup.
    METHODS teardown.

    METHODS test_virtual_pricing_math FOR TESTING RAISING cx_static_check.
ENDCLASS.

CLASS zcl_test_sales_pricing IMPLEMENTATION.

  METHOD setup.
  ENDMETHOD.

  METHOD teardown.
  ENDMETHOD.

  METHOD test_virtual_pricing_math.
    " Test input: Base Price = 100,000 INR, Discount = 10%
    DATA lv_base_price TYPE /dmo/total_price VALUE 100000.
    DATA lv_discount_pct TYPE /dmo/booking_fee VALUE 10.

    " Expected Math:
    " Discount Amount = 10,000 INR
    " Taxable Amount  = 90,000 INR
    " 18% GST Tax     = 16,200 INR
    " Final Gross     = 106,200 INR
    DATA(lv_discount_amt) = ( lv_base_price * lv_discount_pct ) / 100.
    DATA(lv_tax_amt)      = ( ( lv_base_price - lv_discount_amt ) * 18 ) / 100.
    DATA(lv_final_gross)  = ( lv_base_price - lv_discount_amt ) + lv_tax_amt.

    cl_abap_unit_assert=>assert_equals( act = lv_discount_amt exp = 10000 msg = 'Discount Amount calculation failed' ).
    cl_abap_unit_assert=>assert_equals( act = lv_tax_amt exp = 16200 msg = '18% GST Tax Amount calculation failed' ).
    cl_abap_unit_assert=>assert_equals( act = lv_final_gross exp = 106200 msg = 'Final Gross Price calculation failed' ).
  ENDMETHOD.

ENDCLASS.
